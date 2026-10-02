# TPU source

The TPU RTL comes from LogikBench commit
`62fc37ec58451c7d8813d7d3e3e1d7a1377c9082` and is distributed under the MIT
license in `LICENSES/LogikBench-MIT.txt`. The RTL files are byte-identical to
the benchmark; only the file suffix was changed from `.v` to `.sv`.

ORFS uses the RTL defaults `N=8`, `DW=8`, and `ACCW=32`. The implemented design
is therefore an 8x8 processing-element array. The larger LogikBench `N=128`
configuration is intentionally not used because its ABC technology-mapping
runtime is unsuitable for a regularly exercised public flow.
