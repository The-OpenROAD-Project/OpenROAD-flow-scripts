# OpenROAD-flow-scripts Documentation

This is the source for the OpenROAD-flow-scripts (ORFS) documentation, published
at [https://openroad-flow-scripts.readthedocs.io/en/latest/](https://openroad-flow-scripts.readthedocs.io/en/latest/).

The documentation for the OpenROAD application itself lives in a different
repository and is published at
[https://openroad.readthedocs.io/en/latest/](https://openroad.readthedocs.io/en/latest/).

## Build locally

### Requires

- Python 3.10+ (tested through 3.14) — Read the Docs builds with 3.12 (see
  `.readthedocs.yaml`); any recent `python3` on PATH works locally.
- `pip`
- `virtualenv` (or the standard-library `venv`)

### Install prerequisites

Run from `docs/`:

``` shell
make venv
source .venv/bin/activate
```

`make venv` just runs `python3 -m venv .venv && .venv/bin/pip install -r
requirements_lock.txt`; pass `PYTHON=/path/to/python3` to use a specific
interpreter instead of whatever `python3` resolves to on your PATH.

`docs/requirements_lock.txt` is the hash-pinned lock file that Read the Docs
installs, so a local build matches the published one. The direct dependencies
are listed in `docs/requirements.in`; after editing that file, regenerate the
lock with [`uv`](https://docs.astral.sh/uv/) (`pip-compile` from `pip-tools`
is a documented alternative, but at time of writing has a compatibility bug
with recent `pip` releases):

``` shell
uv pip compile --upgrade --generate-hashes --output-file=docs/requirements_lock.txt docs/requirements.in
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
- `conf.py`'s `exclude_patterns` excludes `build` (the actual output directory
  — Sphinx's own default is `_build`) and any local `.venv`/`venv`, so re-running
  a build, or building from a checkout with a local virtualenv already in
  `docs/`, does not pick that up as source content.
