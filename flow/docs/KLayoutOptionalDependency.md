# KLayout as an Optional Dependency

KLayout is only required for a real GDS/OAS stream, DRC, and LVS
verification. All other ORFS functionality — synthesis, floorplanning,
placement, CTS, routing, timing reports, and abstract generation — works
without KLayout installed.

KLayout is a big application, packaged differently on every
distribution, and writing out a GDS file is a small task at the end of
the flow. Many who run ORFS don't need or want a GDS file. Without
KLayout, `make` therefore streams out an empty file and warns:

```
WARNING: klayout not found, mocking klayout by writing empty file ./results/asap7/gcd/base/6_1_merged.gds
```

Nobody mistakes an empty GDS file for a valid one. Installing KLayout
opts out: the GDS file is then written by KLayout. A GDS file written
empty before KLayout was installed is up to date as far as make knows;
`make clean_finish` removes it.

## Makefile Targets

| Target | Requires KLayout | Description |
|---|---|---|
| `make finish` | No (empty GDS without it) | Complete flow including GDS generation |
| `make gds` | No (empty GDS without it) | Generate GDS/OAS from finished design |
| `make drc` | Yes | Run DRC checks (requires GDS) |
| `make lvs` | Yes | Run LVS checks (requires GDS) |
| `make gallery` | Yes | Generate layout screenshots |
| `make klayout_<file>` | Yes | Open result in KLayout viewer |
| `make generate_abstract` | No | Generate LEF/LIB abstracts |

A `check-klayout` guard produces a clear error message when KLayout is
missing and a target that needs it is invoked:

```
Error: KLayout not found. Install KLayout or set KLAYOUT_CMD.
Hint: KLayout is needed for DRC, LVS, the gallery and the viewers.
```

## bazel-orfs Integration

bazel-orfs uses the `do-` prefixed targets which bypass Make's dependency
management. `do-finish` / `do-final` only run the finish stage recipe
itself, while `make finish` also pulls in the GDS target as a Make
dependency. `do-gds` runs GDS generation separately (an empty file without KLayout).

An `orfs_gds()` Bazel rule can call `do-gds` independently from
`orfs_flow()`, making KLayout an optional toolchain dependency configured
in `MODULE.bazel`.

## KLayout Tech File Generation

The `do-klayout` and `do-klayout_wrap` targets generate `.lyt` technology
files by substituting LEF and map file paths into platform templates.
This is implemented in `util/generate_klayout_tech.py` using stdlib XML
processing — no KLayout dependency required.

## Testing Without KLayout

Unit tests for all KLayout-related Python scripts use `unittest.mock` to
mock the `pya` API:

```
cd flow/test
python -m unittest test_generate_klayout_tech test_def2stream test_convertDrc
```

These tests cover:
- `.lyt` tech file generation (`test_generate_klayout_tech.py`)
- DEF-to-GDS merging logic (`test_def2stream.py`)
- DRC report conversion (`test_convertDrc.py`)
