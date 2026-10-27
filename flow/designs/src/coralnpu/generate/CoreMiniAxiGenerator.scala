package orfs.coralnpu

import chisel3._
import chisel3.reflect.DataMirror
import circt.stage.ChiselStage
import coralnpu._
import scala.collection.immutable.SeqMap

/** CoreMiniAxi for synthesis.
  *
  * coralnpu's core_mini_axi_cc_library configuration (128-bit fetch and
  * load/store data, the float unit with Zfbfmin, AXI ports) without its
  * debug ports, which only expose state to a testbench. The core is built
  * as CoreMiniCoreAxi inside a CoreMiniAxi with the same ports except the
  * test enable, which is tied low: in functional mode it only selects
  * reset bypasses and opens clock gates, and as a constant synthesis
  * removes that logic.
  */
class CoreMiniAxi(p: Parameters) extends RawModule {
  val core = Module(new CoreAxi(p, "CoreMiniCore"))

  val io = IO(new Record {
    val elements = SeqMap.from(
      core.io.elements.toSeq.reverse.collect {
        case (name, data) if name != "te" => name -> DataMirror.internal.chiselTypeClone(data)
      }
    )
  })
  core.io.te := false.B
  for ((name, data) <- io.elements) {
    data <> core.io.elements(name)
  }
}

object CoreMiniAxiGenerator extends App {
  val p = new Parameters
  p.fetchDataBits = 128
  p.lsuDataBits = 128
  p.enableFloat = true
  p.enableZfbfmin = true
  p.m = MemoryRegions.default
  ChiselStage.emitHWDialect(new CoreMiniAxi(p), Array(), args)
}
