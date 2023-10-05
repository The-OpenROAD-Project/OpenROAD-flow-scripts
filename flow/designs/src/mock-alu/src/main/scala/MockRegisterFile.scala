import chisel3._

import org.scalatest._

import chisel3._
import chisel3.util.log2Ceil
import chisel3.stage._
import chisel3.experimental._

import scopt.OParser
import System.err
import scopt.RenderingMode
import scala.collection.immutable.SeqMap
import os.ResourcePath

class Read()(implicit config: Config) extends Bundle {
  val address = Input(UInt(log2Ceil(config.registers).W))
  val value = Output(UInt(config.width.W))
}

class Write()(implicit config: Config) extends Bundle {
  val write = Input(Bool())
  val address = Input(UInt(log2Ceil(config.registers).W))
  val value = Input(UInt(config.width.W))
  val byteMask = Input(Vec(config.width / 8, Bool()))
}

class RegisterFileBundle()(implicit config: Config) extends Bundle {
  val read = Vec(config.readPorts, new Read)
  val write = Vec(config.writePorts, new Write)
}

class MockRegisterFile()(implicit config: Config) extends Module {
  val io = IO(new RegisterFileBundle)

  val registerFile = Module(new RegisterFile)

  (registerFile.io.read zip io.read).foreach { case (a, b) =>
    a.address := RegNext(b.address)
    b.value := RegNext(a.value)
  }
  (registerFile.io.write zip io.write).foreach { case (a, b) =>
    a.write := RegNext(b.write)
    a.address := RegNext(b.address)
    a.byteMask := RegNext(b.byteMask)
    a.value := RegNext(b.value)
  }
}

class RegisterSRAM()(implicit config: Config) extends Module {
  val io = IO(new RegisterFileBundle)

  val ram = SyncReadMem(config.bankSize, Vec(config.width / 8, UInt(8.W)))

  io.write.foreach { w =>
    when(w.write) {
      ram.write(w.address, w.value.asTypeOf(ram(0)), w.byteMask)
    }
  }
  io.read.foreach { r =>
    r.value := ram.read(r.address).asUInt
  }
}

class RegisterFile()(implicit config: Config) extends Module {
  val io = IO(new RegisterFileBundle)

  require(config.registers % config.split == 0)
  val registers = Seq.fill(config.split)(
    Module(new RegisterSRAM)
  )

  (io.write zip registers.map(_.io.write).transpose).foreach { case (w, sram) =>
    sram.zipWithIndex.foreach { case (sram, i) =>
      sram <> w
      sram.write := w.write && (w.address / config.bankSize.U === i.U)
    }
  }

  (io.read zip registers.map(_.io.read).transpose).foreach { case (r, srams) =>
    srams.foreach { _ <> r }
    r.value := VecInit(
      srams
        .map { _.value }
    )(r.address / config.bankSize.U)
  }
}

case class Config(
    width: Int = 64,
    readPorts: Int = 16,
    writePorts: Int = 8,
    registers: Int = 4,
    split: Int = 2,
    platform: String = "asap7"
) {
  def bankSize = registers / split
}

object GenerateMockRegisterFile extends App {

  val builder = OParser.builder[Config]
  val parser = {
    import builder._
    OParser.sequence(
      programName("my-program"),
      opt[Int]('w', "width")
        .required()
        .action((width, c) => c.copy(width = width))
        .text("Bit width of registers"),
      opt[Int]('r', "registers")
        .required()
        .action((registers, c) => c.copy(registers = registers))
        .text("Number of registers"),
      opt[Int]('s', "split")
        .required()
        .action((split, c) => c.copy(split = split))
        .text("Split registerfile into this many parts"),
      opt[Int]('r', "read-ports")
        .optional()
        .action((readPorts, c) => c.copy(readPorts = readPorts))
        .text("Number of read ports"),
      opt[Int]('w', "write-ports")
        .optional()
        .action((writePorts, c) => c.copy(writePorts = writePorts))
        .text("Number of write ports"),
      opt[String]('p', "platform")
        .optional()
        .action((platform, c) => c.copy(platform = platform))
        .text("PDK")
    )
  }

  val (configArgs, afterDelimiter) = args.span(_ != "--")
  val chiselArgs = afterDelimiter.drop(1)

  OParser.parse(parser, configArgs, Config()) match {
    case Some(c) =>
      new circt.stage.ChiselStage()
        .execute(
          Array("--target-dir", chiselArgs(0), "--split-verilog"),
          Seq(
            circt.stage.CIRCTTargetAnnotation(
              circt.stage.CIRCTTarget.SystemVerilog
            ),
            ChiselGeneratorAnnotation(() => new MockRegisterFile()(c)),
            circt.stage.FirtoolOption(
              "--lowering-options=disallowPackedArrays,disallowLocalVariables,noAlwaysComb,omitVersionComment"
            ),
            circt.stage.FirtoolOption("--split-verilog"),
            circt.stage.FirtoolOption("--dedup"),
            circt.stage.FirtoolOption("--strip-debug-info"),
            circt.stage.FirtoolOption("--extract-test-code"),
            circt.stage.FirtoolOption("--disable-annotation-unknown"),
            circt.stage.FirtoolOption("--disable-all-randomization"),
            circt.stage.FirtoolOption("--emit-chisel-asserts-as-sva")
          )
        )

    case _ =>
      // arguments are invalid
      OParser.usage(parser, RenderingMode.TwoColumns)
      sys.exit(1)
  }
}
