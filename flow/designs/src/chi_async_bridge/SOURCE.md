# chi_async_bridge source

- Top: `chi_async_bridge`
- Upstream sources, as XiangShan pins them:
  - `OpenXiangShan/XiangShan`, commit
    `aa6b52033add528a504bdb2c2b726100d89f070a`
  - `OpenXiangShan/XSCache`, commit
    `300515bc7b2f65ca988041a984204489d80ec2fb`
  - `OpenXiangShan/Utility`, commit
    `eb8e12b00a33e4716e7778175f6dd45b7a3a9ede`
  - `OpenXiangShan/rocket-chip`, commit
    `a2df1a42399cfe2b343eeb5293796268dc2bc211`

The upstream RTL is Chisel. These files are not the Verilog it
generates: they were rewritten as readable SystemVerilog, module by
module, from that Chisel, and each file's header names the Scala source
and lines it models. They are derived from that source and keep its
license:

| file | derived from | license |
|---|---|---|
| `async_queue_source.sv`, `async_queue_sink.sv` | rocket-chip `src/main/scala/util/AsyncQueue.scala` | Apache-2.0, `LICENSES/rocket-chip-Apache-2.0.txt` |
| `sync_shift_reg.sv` | rocket-chip `src/main/scala/util/SynchronizerReg.scala` | Apache-2.0, `LICENSES/rocket-chip-Apache-2.0.txt` |
| `chi_async_bridge_source.sv`, `chi_async_bridge_sink.sv`, `shadow_buffer.sv` | XSCache `src/main/scala/xscache/chi/AsyncBridge.scala` | Mulan PSL v2, `LICENSES/XiangShan-MulanPSL-2.0.txt` |
| `reset_gen.sv` | Utility `src/main/scala/utility/ResetGen.scala` | Mulan PSL v2, `LICENSES/XiangShan-MulanPSL-2.0.txt` |
| `chi_async_bridge.sv` | XiangShan `XSTileWrap.scala` and `XSNoCTop.scala`, which place the two halves | Mulan PSL v2, `LICENSES/XiangShan-MulanPSL-2.0.txt` |

`LICENSES/rocket-chip-Apache-2.0.txt` is rocket-chip's `LICENSE.SiFive`,
to which those Scala files refer. `LICENSES/XiangShan-MulanPSL-2.0.txt`
is XSCache's `LICENSE`; the Utility and XiangShan sources carry the same
Mulan PSL v2 header.
