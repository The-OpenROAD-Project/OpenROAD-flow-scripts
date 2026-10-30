# KLayout as an Optional Dependency

The flow writes its GDS/OAS stream with KLayout, and takes the first
KLayout it finds:

1. the `klayout` Python module, `pip install klayout`: a prebuilt wheel,
   with no Qt and nothing to compile, for Linux (x86_64 and aarch64) and
   macOS;
2. a KLayout executable, `KLAYOUT_CMD` or `klayout` on `PATH`;
3. neither: the stream file is written empty, with a warning, and the
   flow runs to the end:

```
WARNING: klayout not found, mocking klayout by writing empty file ./results/asap7/gcd/base/6_1_merged.gds
```

`flow/util/def2stream.py` makes the choice, run by `PYTHON_EXE`. The
module and the executable write the same layout. A GDS file written empty
before KLayout was installed is up to date as far as make knows;
`make clean_finish` removes it.

DRC, LVS, the gallery and the viewers need a KLayout executable. The DRC
and LVS rule decks are scripts in KLayout's Ruby-based DSL, which the
Python module does not include. None of them runs in the default `make`.

## Makefile Targets

| Target | Requires KLayout | Description |
|---|---|---|
| `make finish` | No (Python module, or an empty GDS) | Complete flow including GDS generation |
| `make gds` | No (Python module, or an empty GDS) | Generate GDS/OAS from finished design |
| `make drc` | Yes, the executable | Run DRC checks (requires GDS) |
| `make lvs` | Yes, the executable | Run LVS checks (requires GDS) |
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
dependency. `do-gds` runs GDS generation separately.

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
python -m unittest test_generate_klayout_tech test_def2stream test_convertDrc test_klayout_sh
```

These tests cover:
- `.lyt` tech file generation (`test_generate_klayout_tech.py`)
- DEF-to-GDS merging logic and the choice of KLayout (`test_def2stream.py`)
- DRC report conversion (`test_convertDrc.py`)
