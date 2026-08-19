# Vendored OpenROAD documentation sources

**Do not edit these files by hand.** They are verbatim copies of files from the
[OpenROAD](https://github.com/The-OpenROAD-Project/OpenROAD) repository, taken at
the exact commit that the `tools/OpenROAD` submodule pins. `SOURCE.json` records
the repository, the commit SHA, and the upstream path of every file here.

| File | Upstream path | Used by `docs/conf.py` to build |
| --- | --- | --- |
| `GitGuide.md` | `docs/contrib/GitGuide.md` | `docs/contrib/GitGuide.md` (renamed for ORFS, with `contrib/GitGuideAdapter.md` spliced in) |
| `index-SupportedOS.md` | `docs/index.md`, `## Supported Operating Systems` section only | that section, demoted to `####`, spliced into `docs/index2.md` under `### Setup` |
| `utl-README.md` | `src/utl/README.md` | `docs/Manpage.md` |

Only what `docs/conf.py` consumes is stored. OpenROAD's `docs/index.md` is a
landing page and ORFS renders exactly one section of it, so the refresh script
extracts that section and vendors it alone — copying the whole page in would
bring unrelated project prose into this repository to render one table.

The repo-relative links in `utl-README.md` are rewritten to absolute GitHub URLs
at the vendored SHA, because they would otherwise resolve against this
repository and 404.

These files are exempt from the whitespace checks in `.gitattributes`: they are
byte-for-byte upstream copies, and the refresh script is only idempotent if
nothing rewrites them.

## Why these are vendored

`docs/conf.py` used to `requests.get()` all three files from
`raw.githubusercontent.com/.../OpenROAD/master/` while Sphinx was running. That
made the documentation build require network access, produced non-reproducible
output, tracked OpenROAD `master` rather than the version ORFS actually ships,
and overwrote files in the working tree on every local `make html`. Vendoring
gives the documentation the same hash-pinned reproducibility as
`docs/requirements_lock.txt`.

## Refreshing

```shell
python3 docs/scripts/refresh_openroad_docs.py
```

This is the only thing that downloads from GitHub, and it is wired into
`.github/workflows/github-actions-cron-update-OR.yml` so the nightly
submodule-bump PR carries the refreshed docs in the same commit. Run it by hand
whenever you bump `tools/OpenROAD` yourself.

## Checking

```shell
python3 docs/scripts/check_vendored_docs.py
```

Asserts, offline, that `SOURCE.json`'s SHA still matches
`git rev-parse HEAD:tools/OpenROAD`, that every heading `docs/conf.py` splices
on is still present, and that `index-SupportedOS.md` still holds exactly one
`##` section. Run it on any pull request that bumps `tools/OpenROAD`.
