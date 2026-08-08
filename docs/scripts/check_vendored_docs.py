#!/usr/bin/env python3
"""Check that ``docs/_vendor/openroad/`` is in sync with the pinned submodule.

Two things can silently break the ORFS documentation build:

1. The ``tools/OpenROAD`` submodule is bumped without re-vendoring, so the docs
   describe a different OpenROAD than the one ORFS ships.
2. Upstream renames one of the headings that ``docs/conf.py`` splices on, so the
   build fails (or, worse, silently produces a page with a missing or an
   unrelated section).  Files vendored as a single extracted section carry that
   risk in their shape, so it is the shape that is checked: the file must start
   with the section heading, have a body, and contain no second ``## `` heading.

This script catches both **offline**, so it can run on the submodule-bump pull
request -- the one place a human already reviews the OpenROAD delta.

Usage::

    python3 docs/scripts/check_vendored_docs.py

Exits 0 when everything is in sync, 1 otherwise, printing every problem it
found along with the command that fixes it.
"""

from __future__ import annotations

import json
import re
import subprocess
import sys
from pathlib import Path

SUBMODULE_PATH = "tools/OpenROAD"
REFRESH_CMD = "python3 docs/scripts/refresh_openroad_docs.py"

REPO_ROOT = Path(__file__).resolve().parents[2]
VENDOR_DIR = REPO_ROOT / "docs" / "_vendor" / "openroad"
SOURCE_JSON = VENDOR_DIR / "SOURCE.json"

# Every heading docs/conf.py splices on, and the file it must appear in.
# Paths are relative to the repository root.
REQUIRED_ANCHORS = [
    ("docs/_vendor/openroad/GitGuide.md", "## Creating a branch"),
    # Not vendored: this is the ORFS page the supported-OS table is spliced
    # into, so it is just as load-bearing as the upstream headings.
    ("docs/index.md", "### Setup"),
]

# Vendored files holding a single extracted `## ` section of an upstream page
# rather than the whole page: (vendored path, upstream path, section heading).
#
# refresh_openroad_docs.py does the extraction, so the end heading that bounded
# it upstream is deliberately *not* present here. What must hold on disk is
# stricter and checkable offline: the file starts with the section heading,
# has a body under it, and contains no second `## ` heading. A file that fails
# any of those was cut on the wrong boundary -- which is what an upstream
# heading rename or reorder looks like from this side.
EXTRACTED_SECTIONS = [
    (
        "docs/_vendor/openroad/index-SupportedOS.md",
        "docs/index.md",
        "## Supported Operating Systems",
    ),
]

_H2_RE = re.compile(r"^## .*$", re.MULTILINE)


def committed_submodule_sha(problems: list[str]) -> str | None:
    """Return the SHA the committed ``tools/OpenROAD`` gitlink points at."""
    result = subprocess.run(
        ["git", "rev-parse", "HEAD:%s" % SUBMODULE_PATH],
        cwd=str(REPO_ROOT),
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        problems.append(
            "could not read the pinned submodule commit: "
            "`git rev-parse HEAD:%s` failed: %s"
            % (SUBMODULE_PATH, result.stderr.strip())
        )
        return None
    return result.stdout.strip()


def load_source(problems: list[str]) -> dict | None:
    if not SOURCE_JSON.exists():
        problems.append(
            "%s is missing. Create it with: %s"
            % (SOURCE_JSON.relative_to(REPO_ROOT), REFRESH_CMD)
        )
        return None
    try:
        return json.loads(SOURCE_JSON.read_text(encoding="utf-8"))
    except json.JSONDecodeError as error:
        problems.append(
            "%s is not valid JSON (%s). Regenerate it with: %s"
            % (SOURCE_JSON.relative_to(REPO_ROOT), error, REFRESH_CMD)
        )
        return None


def check_sha(source: dict, problems: list[str]) -> None:
    pinned = committed_submodule_sha(problems)
    if pinned is None:
        return

    vendored = source.get("sha")
    if not vendored:
        problems.append(
            '%s has no "sha" field. Regenerate it with: %s'
            % (SOURCE_JSON.relative_to(REPO_ROOT), REFRESH_CMD)
        )
        return

    if vendored != pinned:
        problems.append(
            "the vendored OpenROAD docs are stale:\n"
            "    %s says sha = %s\n"
            "    git rev-parse HEAD:%s   = %s\n"
            "  The tools/OpenROAD submodule was bumped without re-vendoring "
            "the documentation it ships. Fix with: %s"
            % (
                SOURCE_JSON.relative_to(REPO_ROOT),
                vendored,
                SUBMODULE_PATH,
                pinned,
                REFRESH_CMD,
            )
        )


def check_files_present(source: dict, problems: list[str]) -> None:
    files = source.get("files")
    if not isinstance(files, dict) or not files:
        problems.append(
            '%s has no usable "files" mapping. Regenerate it with: %s'
            % (SOURCE_JSON.relative_to(REPO_ROOT), REFRESH_CMD)
        )
        return

    for upstream_path, record in sorted(files.items()):
        if not isinstance(record, dict) or not record.get("vendored"):
            problems.append(
                '%s has a malformed entry for "%s". Regenerate it with: %s'
                % (SOURCE_JSON.relative_to(REPO_ROOT), upstream_path, REFRESH_CMD)
            )
            continue
        name = record["vendored"]
        path = VENDOR_DIR / name
        if not path.exists():
            problems.append(
                "%s is missing (vendored from %s:%s). Fix with: %s"
                % (
                    path.relative_to(REPO_ROOT),
                    source.get("repo", "OpenROAD"),
                    upstream_path,
                    REFRESH_CMD,
                )
            )
        elif not path.read_text(encoding="utf-8").strip():
            problems.append(
                "%s is empty. Fix with: %s" % (path.relative_to(REPO_ROOT), REFRESH_CMD)
            )


def check_anchors(source: dict, problems: list[str]) -> None:
    cache: dict[str, str | None] = {}

    def read(rel_path: str) -> str | None:
        if rel_path not in cache:
            path = REPO_ROOT / rel_path
            cache[rel_path] = (
                path.read_text(encoding="utf-8") if path.exists() else None
            )
        return cache[rel_path]

    for rel_path, anchor in REQUIRED_ANCHORS:
        text = read(rel_path)
        if text is None:
            # check_files_present already reported missing vendored files.
            if not rel_path.startswith("docs/_vendor/"):
                problems.append(
                    "%s is missing; it must contain %r" % (rel_path, anchor)
                )
            continue
        if anchor not in text:
            if rel_path.startswith("docs/_vendor/"):
                remedy = (
                    "OpenROAD most likely renamed it. Re-vendor with `%s`; if "
                    "the heading really changed, update it in docs/conf.py and "
                    "in docs/scripts/check_vendored_docs.py." % REFRESH_CMD
                )
            else:
                remedy = (
                    "This is an ORFS-owned page. Restore the heading, or update "
                    "the anchor in docs/conf.py and in "
                    "docs/scripts/check_vendored_docs.py."
                )
            problems.append(
                "%s does not contain the heading %r, which docs/conf.py splices "
                "on.\n  %s" % (rel_path, anchor, remedy)
            )

    files = source.get("files") if isinstance(source.get("files"), dict) else {}

    for rel_path, upstream_path, heading in EXTRACTED_SECTIONS:
        remedy = (
            "Re-vendor with `%s`. If OpenROAD really renamed or reordered the "
            "heading, update the section bounds in "
            "docs/scripts/refresh_openroad_docs.py, the anchor in "
            "docs/conf.py, and EXTRACTED_SECTIONS here to match." % REFRESH_CMD
        )
        text = read(rel_path)
        if text is None:
            # check_files_present already reported missing vendored files.
            continue

        if not text.startswith(heading):
            problems.append(
                "%s does not start with %r. It must hold that one section of "
                "%s and nothing else, because docs/conf.py strips the heading "
                "and splices the rest into docs/index2.md.\n  %s"
                % (rel_path, heading, upstream_path, remedy)
            )
        elif not text[len(heading) :].strip():
            problems.append(
                "%s contains %r with no body under it, so docs/index2.md would "
                "publish an empty supported-OS section.\n  %s"
                % (rel_path, heading, remedy)
            )

        extra = [h for h in _H2_RE.findall(text) if h != heading]
        if extra:
            problems.append(
                "%s contains %d unexpected `## ` heading(s) besides %r: %s.\n"
                "  The extraction from %s ran past the end of the section, so "
                "docs/index2.md would publish unrelated content.\n  %s"
                % (
                    rel_path,
                    len(extra),
                    heading,
                    ", ".join(repr(h) for h in extra),
                    upstream_path,
                    remedy,
                )
            )

        # The declarations above must agree with what the refresh script
        # recorded; otherwise conf.py and the refresh script have drifted and
        # the checks above are guarding the wrong heading.
        recorded = (files.get(upstream_path) or {}).get("section") or {}
        if recorded.get("start") not in (None, heading):
            problems.append(
                "%s records that %s was cut at %r, but docs/conf.py and this "
                "script expect %r.\n  Reconcile "
                "docs/scripts/refresh_openroad_docs.py, docs/conf.py and "
                "EXTRACTED_SECTIONS here, then re-vendor with `%s`."
                % (
                    SOURCE_JSON.relative_to(REPO_ROOT),
                    upstream_path,
                    recorded.get("start"),
                    heading,
                    REFRESH_CMD,
                )
            )


def main() -> int:
    problems: list[str] = []

    source = load_source(problems)
    if source is not None:
        check_sha(source, problems)
        check_files_present(source, problems)
    check_anchors(source or {}, problems)

    if problems:
        print("check_vendored_docs: FAIL (%d problem(s))" % len(problems))
        for problem in problems:
            print("  - %s" % problem)
        return 1

    print(
        "check_vendored_docs: OK (vendored at %s @ %s)"
        % (source.get("repo"), source.get("sha"))
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
