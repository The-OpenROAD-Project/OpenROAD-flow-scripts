#!/usr/bin/env python3
"""Refresh ``docs/_vendor/openroad/`` from the pinned ``tools/OpenROAD`` submodule.

The ORFS documentation splices three files that live in the OpenROAD repository
into its own pages (see ``docs/conf.py``).  Those files used to be downloaded
from ``raw.githubusercontent.com/.../OpenROAD/master/`` while Sphinx was
running, which made the docs build depend on the network, non-reproducible, and
liable to document a version of OpenROAD that ORFS does not ship.

They are vendored instead.  This script is the *only* thing that talks to the
network: it downloads the three files **at the SHA that ``tools/OpenROAD`` is
pinned to**, rewrites the repo-relative links inside them so they still resolve
when rendered from this repository, and records the SHA in ``SOURCE.json``.

Only what ``docs/conf.py`` actually consumes is stored.  For OpenROAD's
``docs/index.md`` that is a single section -- the supported-OS table -- so this
script extracts it and vendors the section alone rather than the whole landing
page, which is mostly prose ORFS never renders.

Usage::

    python3 docs/scripts/refresh_openroad_docs.py [--sha SHA]

It is idempotent: running it twice in a row leaves the working tree unchanged.

``docs/scripts/check_vendored_docs.py`` is the offline counterpart: run it to
assert the vendored tree is still in sync with the submodule pointer.
"""

from __future__ import annotations

import argparse
import json
import posixpath
import re
import subprocess
import sys
import urllib.error
import urllib.request
from pathlib import Path
from typing import NamedTuple

REPO = "The-OpenROAD-Project/OpenROAD"
SUBMODULE_PATH = "tools/OpenROAD"

REPO_ROOT = Path(__file__).resolve().parents[2]
VENDOR_DIR = REPO_ROOT / "docs" / "_vendor" / "openroad"
SOURCE_JSON = VENDOR_DIR / "SOURCE.json"


class Vendored(NamedTuple):
    """One file to vendor out of the OpenROAD repository.

    ``section`` restricts what is stored to a single ``## `` section of the
    upstream file, delimited by ``(start, end)`` headings.  The vendored file
    then holds ``start`` followed by everything up to -- but not including --
    ``end``; ``docs/conf.py`` strips the leading heading and splices the rest.

    ``rewrite_links`` turns repo-relative markdown links into absolute GitHub
    URLs at the vendored SHA.  Without it a link such as ``../../LICENSE``
    would resolve against *this* repository and 404.
    """

    upstream: str
    name: str
    section: tuple[str, str] | None = None
    rewrite_links: bool = False


# Keep this in sync with the readers in docs/conf.py.
#
# GitGuide.md is deliberately not link-rewritten: conf.py adapts it for ORFS
# and its remaining relative links (./DeveloperGuide.md, ./CI.md) resolve
# against ORFS's own docs/contrib/ pages.
#
# Only the supported-OS table is taken from docs/index.md. Vendoring that page
# whole would drag OpenROAD's entire landing page -- partner and programme
# prose included -- into this repository to render one table.
VENDORED_FILES = (
    Vendored("docs/contrib/GitGuide.md", "GitGuide.md"),
    Vendored(
        "docs/index.md",
        "index-SupportedOS.md",
        section=("## Supported Operating Systems", "## Code of conduct"),
    ),
    Vendored("src/utl/README.md", "utl-README.md", rewrite_links=True),
)

_LINK_RE = re.compile(r"(!?)\[([^\]]*)\]\(\s*([^)\s]+)\s*\)")
_ABSOLUTE_PREFIXES = ("http://", "https://", "mailto:", "ftp://", "//")
_IMAGE_SUFFIXES = (".png", ".jpg", ".jpeg", ".gif", ".svg", ".webp", ".ico")

_SHA_RE = re.compile(r"^[0-9a-f]{40}$")


def _git(*args: str, cwd: Path = REPO_ROOT) -> str:
    """Run git and return stripped stdout, or raise with a readable message."""
    result = subprocess.run(
        ["git", *args],
        cwd=str(cwd),
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        raise RuntimeError(
            "command failed: git %s (in %s)\n%s"
            % (" ".join(args), cwd, result.stderr.strip())
        )
    return result.stdout.strip()


def resolve_pinned_sha() -> tuple[str, str]:
    """Return ``(sha, how)`` for the OpenROAD commit ORFS pins.

    The nightly bot updates the ``tools/OpenROAD`` working tree first and only
    then commits, so when the submodule is checked out its ``HEAD`` is what the
    resulting commit will pin -- and that is the SHA the docs must match.  When
    the submodule is not initialised (a plain ``git clone`` without
    ``--recursive``) fall back to the committed gitlink.
    """
    submodule_dir = REPO_ROOT / SUBMODULE_PATH
    if (submodule_dir / ".git").exists():
        sha = _git("rev-parse", "HEAD", cwd=submodule_dir)
        how = "%s working tree (git -C %s rev-parse HEAD)" % (
            SUBMODULE_PATH,
            SUBMODULE_PATH,
        )
    else:
        sha = _git("rev-parse", "HEAD:%s" % SUBMODULE_PATH)
        how = "committed submodule pointer (git rev-parse HEAD:%s)" % SUBMODULE_PATH

    if not _SHA_RE.match(sha):
        raise RuntimeError(
            "resolved OpenROAD SHA %r from the %s is not a 40-character "
            "commit id" % (sha, how)
        )
    return sha, how


def download(url: str) -> str:
    """Fetch ``url`` as text, failing loudly on any non-200 response.

    The old ``conf.py`` helper wrote ``r.content`` unconditionally, so a 404 or
    an outage silently produced a doc page containing GitHub's error body.
    """
    request = urllib.request.Request(
        url, headers={"User-Agent": "orfs-refresh-openroad-docs"}
    )
    try:
        with urllib.request.urlopen(request, timeout=60) as response:
            status = response.status
            body = response.read()
    except urllib.error.HTTPError as exc:
        raise RuntimeError(
            "GET %s failed with HTTP %s %s" % (url, exc.code, exc.reason)
        ) from exc
    except urllib.error.URLError as exc:
        raise RuntimeError("GET %s failed: %s" % (url, exc.reason)) from exc

    if status != 200:
        raise RuntimeError("GET %s returned HTTP %s, expected 200" % (url, status))
    if not body.strip():
        raise RuntimeError("GET %s returned an empty body" % url)
    return body.decode("utf-8")


def _to_github_url(target: str, src_dir: str, sha: str) -> str | None:
    """Map a repo-relative markdown target to an absolute GitHub URL.

    Returns ``None`` when the target should be left alone (already absolute, or
    a pure in-page anchor).
    """
    if target.startswith(_ABSOLUTE_PREFIXES) or target.startswith("#"):
        return None

    path, sep, fragment = target.partition("#")
    if not path:
        return None

    if path.startswith("/"):
        # Repo-root-relative, e.g. /docs/images/grafana.png
        repo_path = path.lstrip("/")
    else:
        repo_path = posixpath.normpath(posixpath.join(src_dir, path))

    if repo_path.startswith(".."):
        raise RuntimeError(
            "link target %r in %s/ escapes the OpenROAD repository root"
            % (target, src_dir)
        )

    if repo_path.lower().endswith(_IMAGE_SUFFIXES):
        # Images must point at the raw blob so they actually render.
        return "https://raw.githubusercontent.com/%s/%s/%s" % (REPO, sha, repo_path)
    return "https://github.com/%s/blob/%s/%s%s%s" % (
        REPO,
        sha,
        repo_path,
        sep,
        fragment,
    )


def rewrite_links(text: str, upstream_path: str, sha: str) -> str:
    """Rewrite repo-relative links in a vendored file to absolute GitHub URLs."""
    src_dir = posixpath.dirname(upstream_path)

    def replace(match: re.Match) -> str:
        bang, label, target = match.group(1), match.group(2), match.group(3)
        url = _to_github_url(target, src_dir, sha)
        if url is None:
            return match.group(0)
        return "%s[%s](%s)" % (bang, label, url)

    return _LINK_RE.sub(replace, text)


def extract_section(text: str, upstream_path: str, start: str, end: str) -> str:
    """Return the ``start`` heading plus everything up to (not including) ``end``.

    This is the extraction ``docs/conf.py`` used to perform on the whole
    downloaded file.  Doing it here means an upstream heading rename fails
    *now*, naming both headings, instead of vendoring a page the documentation
    build cannot splice.
    """
    match = re.search("%s(.*?)%s" % (re.escape(start), re.escape(end)), text, re.DOTALL)
    if match is None:
        raise RuntimeError(
            "cannot find a section starting at '%s' and ending at '%s' in "
            "%s:%s.\n"
            "  OpenROAD most likely renamed or reordered one of those "
            "headings. Look at the upstream file, then update the section "
            "bounds in this script, the anchor in docs/conf.py, and the "
            "anchor in docs/scripts/check_vendored_docs.py to match."
            % (start, end, REPO, upstream_path)
        )
    body = match.group(1)
    if not body.strip():
        raise RuntimeError(
            "the section '%s' in %s:%s is empty. Vendoring it would silently "
            "publish a supported-OS heading with nothing under it."
            % (start, REPO, upstream_path)
        )
    return start + body


def _write_if_changed(path: Path, content: str) -> bool:
    """Write ``content`` to ``path``; return True if the file changed on disk."""
    if path.exists() and path.read_text(encoding="utf-8") == content:
        return False
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")
    return True


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument(
        "--sha",
        help="OpenROAD commit to vendor from (default: the pinned "
        "tools/OpenROAD submodule commit)",
    )
    args = parser.parse_args(argv)

    if args.sha:
        sha, how = args.sha, "--sha command-line override"
        if not _SHA_RE.match(sha):
            parser.error("--sha must be a full 40-character commit id")
    else:
        sha, how = resolve_pinned_sha()

    print("OpenROAD repo: %s" % REPO)
    print("OpenROAD sha:  %s" % sha)
    print("resolved from: %s" % how)

    changed = []
    files = {}
    for entry in VENDORED_FILES:
        url = "https://raw.githubusercontent.com/%s/%s/%s" % (REPO, sha, entry.upstream)
        text = download(url)
        record = {"vendored": entry.name}
        if entry.section is not None:
            start, end = entry.section
            text = extract_section(text, entry.upstream, start, end)
            record["section"] = {"start": start, "end": end}
        if entry.rewrite_links:
            text = rewrite_links(text, entry.upstream, sha)
            record["links_rewritten"] = True
        files[entry.upstream] = record
        if _write_if_changed(VENDOR_DIR / entry.name, text):
            changed.append("docs/_vendor/openroad/%s" % entry.name)
        print(
            "  %-24s <- %s%s"
            % (
                entry.name,
                entry.upstream,
                " ['%s' section only]" % entry.section[0] if entry.section else "",
            )
        )

    source = {
        "_comment": (
            "Generated by docs/scripts/refresh_openroad_docs.py -- do not edit "
            "by hand. Run that script to re-vendor after bumping the "
            "tools/OpenROAD submodule."
        ),
        "repo": REPO,
        "sha": sha,
        "files": files,
    }
    if _write_if_changed(SOURCE_JSON, json.dumps(source, indent=2) + "\n"):
        changed.append("docs/_vendor/openroad/SOURCE.json")

    if changed:
        print("updated:")
        for name in changed:
            print("  %s" % name)
    else:
        print("already up to date; nothing written.")
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except RuntimeError as error:
        print("error: %s" % error, file=sys.stderr)
        sys.exit(1)
