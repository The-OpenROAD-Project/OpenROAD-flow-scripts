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

class MockAluRegisterFile()(implicit config: AluRegisterFileConfig)
    extends Module {
  val io = IO(new Bundle {
    val registerFile = new RegisterFileBundle()(config.registerFile)
    val op = Input(ALUOps())
  })

  val registerFile = Module(new RegisterFile()(config.registerFile))

  (registerFile.io.read zip io.registerFile.read).foreach { case (a, b) =>
    a.address := RegNext(b.address)
    b.value := RegNext(a.value)
  }
  (registerFile.io.write zip io.registerFile.write).foreach { case (a, b) =>
    a.write := RegNext(b.write)
    a.address := RegNext(b.address)
    a.byteMask := RegNext(b.byteMask)
    a.value := RegNext(b.value)
  }

  val alu = Module(new Alu()(config.aluConfig))
  alu.io.a := registerFile.io.read(0).value
  alu.io.b := registerFile.io.read(1).value
  alu.io.op := RegNext(io.op)
  registerFile.io.write(0).value := alu.io.out
}

case class AluRegisterFileConfig(
    registerFile: Config = Config(),
    aluConfig: ALUConfig = ALUConfig()
)

object GenerateMockAluRegisterFile extends App {

  val builder = OParser.builder[AluRegisterFileConfig]
  val parser = {
    import builder._
    OParser.sequence(
      programName("my-program"),
      opt[Int]('w', "width")
        .required()
        .action((width, c) =>
          c
            .copy(registerFile = c.registerFile.copy(width = width))
            .copy(aluConfig = c.aluConfig.copy(width = width))
        )
        .text("Bit width of registers"),
      opt[Int]('r', "registers")
        .required()
        .action((registers, c) =>
          c.copy(registerFile = c.registerFile.copy(registers = registers))
        )
        .text("Number of registers"),
      opt[Int]('r', "read-ports")
        .optional()
        .action((readPorts, c) =>
          c.copy(registerFile = c.registerFile.copy(readPorts = readPorts))
        )
        .text("Number of read ports"),
      opt[Int]('w', "write-ports")
        .optional()
        .action((writePorts, c) =>
          c.copy(registerFile = c.registerFile.copy(writePorts = writePorts))
        )
        .text("Number of write ports"),
      opt[String]('p', "platform")
        .optional()
        .action((platform, c) =>
          c.copy(registerFile = c.registerFile.copy(platform = platform))
            .copy(aluConfig = c.aluConfig.copy(platform = platform))
        )
        .text("PDK"),
      opt[Seq[String]]('o', "operations")
        .optional()
        .valueName("Operations, any of: " + ALUOps.allNames.mkString(", "))
        .action((operations, c) =>
          c.copy(aluConfig =
            c.aluConfig.copy(operations = operations.map(nameLookup(_)))
          )
        )
        .text("ALU operations")
    )
  }

  val (configArgs, afterDelimiter) = args.span(_ != "--")
  val chiselArgs = afterDelimiter.drop(1)

  OParser.parse(parser, configArgs, AluRegisterFileConfig()) match {
    case Some(c) =>
      new circt.stage.ChiselStage()
        .execute(
          chiselArgs.drop(1),
          Seq(
            circt.stage.CIRCTTargetAnnotation(
              circt.stage.CIRCTTarget.SystemVerilog
            ),
            ChiselGeneratorAnnotation(() => new MockAluRegisterFile()(c)),
            circt.stage.FirtoolOption(
              "--lowering-options=disallowPackedArrays,disallowLocalVariables,noAlwaysComb"
            ),
            circt.stage.FirtoolOption("--split-verilog"),
            circt.stage.FirtoolOption("--dedup"),
            circt.stage.FirtoolOption("--strip-debug-info"),
            circt.stage.FirtoolOption("--extract-test-code"),
            circt.stage.FirtoolOption("--disable-annotation-unknown"),
            circt.stage.FirtoolOption("--disable-all-randomization"),
            circt.stage.FirtoolOption("--emit-chisel-asserts-as-sva"),
            circt.stage.FirtoolOption("-o=" + chiselArgs(0))
          )
        )

    case _ =>
      // arguments are invalid
      OParser.usage(parser, RenderingMode.TwoColumns)
      sys.exit(1)
  }
}
