# OpenROAD-flow-scripts Documentation

This is the source for the OpenROAD-flow-scripts (ORFS) documentation, published
at [https://openroad-flow-scripts.readthedocs.io/en/latest/](https://openroad-flow-scripts.readthedocs.io/en/latest/).

The documentation for the OpenROAD application itself lives in a different
repository and is published at
[https://openroad.readthedocs.io/en/latest/](https://openroad.readthedocs.io/en/latest/).

## Build locally

### Requires

- Python 3.10 — the version Read the Docs builds with (see `.readthedocs.yaml`).
  The pinned Sphinx release does not run on Python 3.13 or newer.
- `pip`
- `virtualenv` (or the standard-library `venv`)

### Install prerequisites

Run from the repository root:

``` shell
virtualenv .venv
source .venv/bin/activate
pip install -r docs/requirements_lock.txt
```

`docs/requirements_lock.txt` is the hash-pinned lock file that Read the Docs
installs, so a local build matches the published one. The direct dependencies
are listed in `docs/requirements.in`; after editing that file, regenerate the
lock with:

``` shell
pip-compile --generate-hashes --output-file=docs/requirements_lock.txt docs/requirements.in
```

### Build

``` shell
cd docs
make html
```

The generated site is in `docs/build/html`; open `docs/build/html/index.html`.

### Check for broken links

``` shell
cd docs
make checklinks
```

The report is written to `docs/build/output.txt` (and `docs/build/output.json`).
It exits non-zero when any link is unreachable.

### Notes

- The build needs network access: `docs/conf.py` downloads three files from the
  OpenROAD repository at build time.
- Building writes generated pages into the source tree: `index2.md`,
  `SupportedOS.md`, `Manpage.md`, `mainREADME.md`, and — because it is fetched
  rather than authored here — the tracked file `contrib/GitGuide.md`. Do not
  commit those changes; `git checkout docs/contrib/GitGuide.md` after a build.
- Always `rm -rf docs/build` before rebuilding. The output directory is
  `build/`, but `conf.py`'s `exclude_patterns` only excludes `_build`, so a
  second run picks up the Markdown files written under `build/html/` as if they
  were source pages.
