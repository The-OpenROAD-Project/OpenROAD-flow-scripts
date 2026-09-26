# XiangShan CoupledL2

- Benchmark id: `xiangshan_coupledl2`
- RTL top: `CoupledL2`
- XiangShan source root: [OpenXiangShan/XiangShan](https://github.com/OpenXiangShan/XiangShan)
  `96c3f568f943a096ffd3d712dc6f462ac4b1ba33`
- CoupledL2 source: [OpenXiangShan/XSCache](https://github.com/OpenXiangShan/XSCache)
  `54a2a7527f7366e3cb3fe378b1f1e92f18cbf33f`
- Utility source: [OpenXiangShan/Utility](https://github.com/OpenXiangShan/Utility)
  `bab34605babce74732f7f441c5d126a0869285bd`
- Generator selection: `top.TopMain --config MinimalConfig --issue E.b
  --num-cores 1 --target systemverilog --split-verilog --fpga-platform`
- Generator: Chisel `7.3.0`, CIRCT firtool `1.135.0`
- RTL closure: 145 SystemVerilog files; top file `CoupledL2.sv`

Generator dependency pins at the XiangShan source root:

| Component | Repository | Commit or version |
|---|---|---|
| rocket-chip | `OpenXiangShan/rocket-chip` | `c4ba35a80758881da59399b693a6b51448eea1e4` |
| cde | `chipsalliance/cde` | `52768c97a27b254c0cc0ac9401feb55b29e18c28` |
| hardfloat | `ucb-bar/berkeley-hardfloat` | `d93aa570806013dea479a92ba9bb33d1f2d4f69f` |
| OpenNCB | `OpenXiangShan/OpenNCB` | `9a83eb7e6c0e36e0d6b72642ff93641ec65819cf` |
| ChiselAIA | `OpenXiangShan/ChiselAIA` | `53edde5226123e0ce9daa016b9f9b049866d3980` |
| ChiselIOPMP | `OpenXiangShan/ChiselIOPMP` | `435815008053614c2e338439a16b2a1359931c9e` |
| difftest | `OpenXiangShan/difftest` | `36062fbd54579220e8aff92bc820e2fd3e749539` |
| ready-to-run | `OpenXiangShan/ready-to-run` | `955e6e2a5b5a51426d000597710cd632aeba2f52` |
| YunSuan | `OpenXiangShan/YunSuan` | `447cd17b1637f998daeb6be3efcd4890f48cb2b9` |
| Chisel | `chipsalliance/chisel` | `v7.3.0` (`42f1a1e1a9f6bbf940344113da155d77499dcaa7`) |
| firtool | `llvm/circt` | `firtool-1.135.0` (`4d750dbb2971d5f97e2fc48c700e01e460a5bdc8`) |
| mill / scala | `com-lihaoyi/mill`, `org.scala-lang/scala` | `0.12.15` / `2.13.17` |

Two offline generator replays emit 138 selected SystemVerilog files byte for
byte from the pinned source graph. The only replay difference is disclosed
enum ordering in an unshipped full-chip FIR file. Of the 138 generated files,
48 come from XSCache sources, 54 from Utility sources, 26 are Chisel standard
library modules (`Arbiter*`, `Queue*`), and 10 are CIRCT memory lowerings of
Chisel queues (`ram_*`). The other seven files in the 145-file closure are
local physical-memory boundary files: six `array_*_bb` blackbox declarations
and the banking wrapper `deps/array_2048x137_wrap.sv`. They are not attributed
to the OpenXiangShan generator. Their legacy `.v` suffixes were migrated to
`.sv` without behavioral changes. The license basis of each group is described
in `LICENSES/README.md`.

The SRAM macro views are shared platform collateral: the LEF, Liberty, and
`array_*_bb` blackbox declarations live under
`platforms/<pdk>/{lef,lib,verilog}/`, and `fakeram.cfg` in each design
directory records the generator parameters they were built with.

The functional L2 shares the `XSTileWrap` core clock; the pinned source does
not divide it into a separate 500 MHz domain.
