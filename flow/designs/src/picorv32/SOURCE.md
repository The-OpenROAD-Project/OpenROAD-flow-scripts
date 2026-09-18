# PicoRV32 source

- Top: `picorv32`
- Benchmark source: `zeroasiccorp/LogikBench`, commit
  `62fc37ec58451c7d8813d7d3e3e1d7a1377c9082`
- Upstream source: `YosysHQ/picorv32`, commit
  `87c89acc18994c8cf9a2311e871818e87d304568`

The packaged RTL is byte-identical to the LogikBench benchmark. LogikBench's
intentional parameter-default changes relative to upstream are part of the
benchmark definition. Only the file suffix was changed from `.v` to `.sv`;
the contents are unchanged.

`LICENSES/LogikBench-MIT.txt` records the immediate benchmark grant and
`LICENSES/PicoRV32-ISC.txt` records the authored RTL grant preserved in the
source header.
