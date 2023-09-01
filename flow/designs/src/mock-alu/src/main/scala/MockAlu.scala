import chisel3._

import org.scalatest._

import chisel3._
import chisel3.util._
import chisel3.util.experimental.InlineInstance
import chisel3.stage._

import scopt.OParser
import System.err
import scopt.RenderingMode
import scala.collection.immutable.SeqMap
import os.ResourcePath

class Operands(bitWidth: Int) extends Bundle {
  val a = Input(UInt(bitWidth.W))
  val b = Input(UInt(bitWidth.W))
  val out = Output(UInt(bitWidth.W))
}

class Operand(bitWidth: Int, operand: (UInt, UInt) => UInt, name: String)
    extends Module {
  override val desiredName = name
  val io = IO(new Operands(bitWidth))
  io.out := operand(io.a, io.b)
}

object operation {
  def apply(a: UInt, b: UInt, op: (UInt, UInt) => UInt, name: String)(implicit
      config: ALUConfig
  ): UInt = {
    val operand = Module(
      new Operand(config.width, op, name) with InlineInstance
    )
    operand.io.a := a
    operand.io.b := b
    operand.io.out
  }
}

class MockAlu()(implicit config: ALUConfig) extends Module {
  val bitWidth = config.width
  val io = IO(new Bundle {
    val op = Input(ALUOps())
    val a = Input(UInt(bitWidth.W))
    val b = Input(UInt(bitWidth.W))
    val out = Output(UInt(bitWidth.W))
  })

  io.out := 0.U

  val op = RegNext(io.op)
  val a = RegNext(io.a)
  val b = RegNext(io.b)

  val isSubtraction =
    Seq(
      ALUOps.SUB,
      ALUOps.SETCC_EQ,
      ALUOps.SETCC_NE,
      ALUOps.SETCC_LT,
      ALUOps.SETCC_LE,
      ALUOps.SETCC_ULT,
      ALUOps.SETCC_ULE
    ).filter(config.operations.contains(_))
      .map(op === _)
      .reduceLeftOption(_ || _)
      .getOrElse(false.B)

  val modifiedB = Mux(isSubtraction, ~b, b)

  val extendedResult =
    WireInit(UInt(((bitWidth + 1).W)), (a +& modifiedB) + isSubtraction.asUInt)

  val result = extendedResult(extendedResult.getWidth - 2, 0)
  val carryOut = extendedResult(extendedResult.getWidth - 1)

  val isTrueZero = !result.orR
  val isNegative = result(bitWidth - 1)

  val barrel = Module(new BarrelShifter(bitWidth))
  barrel.io.data := a
  barrel.io.shiftAmount := b
  barrel.io.dir := io.op

  val activeMultipliers =
    ALUOps.multipliers.filter(config.operations.contains(_))
  require(Seq(0, 1).contains(activeMultipliers.length))

  val multResult = if (activeMultipliers.size == 1) {
    val mult = Module(new multiplier())
    mult.io.clk := clock
    mult.io.rst := reset
    mult.io.a := a
    mult.io.b := b
    mult.io.o
  } else {
    WireInit(UInt(config.width.W), DontCare)
  }

  val activeAdders =
    ALUOps.adders.filter(config.operations.contains(_))
  require(Seq(0, 1).contains(activeMultipliers.length))

  val adderResult = if (activeAdders.size == 1) {
    val adder = Module(new adder())
    adder.io.a := a
    adder.io.b := b
    adder.io.o
  } else {
    WireInit(UInt(config.width.W), DontCare)
  }

  val claResult = if (config.operations.contains(ALUOps.CLAADD)) {
    val cla = Module(new CarryLookAheadAdder(config.width))
    cla.io.A := a
    cla.io.B := b
    cla.io.Cin := isSubtraction
    cla.io.Cout ## cla.io.SUM
  } else {
    WireInit(UInt(config.width.W), DontCare)
  }

  val koggeStoneResult = if (config.operations.contains(ALUOps.KOGGESTONEADD)) {
    val cla = Module(new KoggeStoneAdder(config.width))
    cla.io.A := a
    cla.io.B := b
    cla.io.cin := isSubtraction
    cla.io.cout ## cla.io.sum
  } else {
    WireInit(UInt(config.width.W), DontCare)
  }

  val activeMacs =
    ALUOps.macs.filter(config.operations.contains(_))
  val macResult = if (activeMacs.size == 1) {
    val mult = Module(new multiply_adder())
    mult.io.clk := clock
    mult.io.rst := reset
    mult.io.a := a
    mult.io.b := b
    mult.io.c := io.out
    mult.io.o
  } else {
    WireInit(UInt(config.width.W), DontCare)
  }

  val aluResult = (Seq[(ALUOps.Type, (UInt, UInt) => UInt)](
    ALUOps.AND -> (_ & _),
    ALUOps.OR -> (_ | _),
    ALUOps.XOR -> (_ ^ _),
    ALUOps.ADDYOSYS -> (_ + _)
  ).map(aluop =>
    aluop._1 -> operation(
      a,
      b,
      aluop._2,
      nameLookup(aluop._1)
    )
  ) ++ Seq[(ALUOps.Type, UInt)](
    ALUOps.ADD -> result,
    ALUOps.ADD8 -> result(7, 0),
    ALUOps.ADD16 -> (if (config.width >= 16) { result(15, 0) }
                     else { 0.U }),
    ALUOps.ADD32 -> (if (config.width >= 32) { result(31, 0) }
                     else { 0.U }),
    ALUOps.SUB -> result,
    ALUOps.SETCC_EQ -> isTrueZero.asUInt,
    ALUOps.SETCC_NE -> (~isTrueZero).asUInt,
    ALUOps.SETCC_LT -> isNegative.asUInt,
    ALUOps.SETCC_LE -> (isTrueZero || isNegative).asUInt,
    ALUOps.SETCC_ULT -> (!carryOut).asUInt,
    ALUOps.SETCC_ULE -> (isTrueZero || (!carryOut)).asUInt,
    ALUOps.SHL -> barrel.io.out,
    ALUOps.SHR -> barrel.io.out,
    ALUOps.SRA -> barrel.io.out,
    ALUOps.MAC_BRENTKUNG -> macResult,
    ALUOps.CLAADD -> claResult,
    ALUOps.KOGGESTONEADD -> koggeStoneResult
  ) ++ ALUOps.multipliers.map(op => op -> multResult) ++
    ALUOps.adders.map(op => op -> adderResult) ++
    Seq(
      ALUOps.MUX1,
      ALUOps.MUX2,
      ALUOps.MUX3,
      ALUOps.MUX4,
      ALUOps.MUX5,
      ALUOps.MUX6,
      ALUOps.MUX7,
      ALUOps.MUX8
    ).zipWithIndex.map { case (op, i) =>
      op -> (a >> i)
    })
    .filter(a => config.operations.contains(a._1))
    .map(a => (a._1.asUInt -> a._2))

  io.out := RegNext(
    if (aluResult.size == 1) {
      aluResult(0)._2
    } else {
      MuxLookup(
        op.asUInt,
        WireInit(chiselTypeOf(io.out), DontCare),
        aluResult
      )
    }
  )
}

case class ALUConfig(
    width: Int = 64,
    operations: Seq[ALUOps.Type] = Seq.empty,
    platform: String = "asap7"
)

object GenerateMockAlu extends App {

  val builder = OParser.builder[ALUConfig]
  val parser = {
    import builder._
    OParser.sequence(
      programName("my-program"),
      opt[Int]('w', "width")
        .required()
        .valueName("data width")
        .action((width, c) => c.copy(width = width))
        .text("input file is required"),
      opt[Seq[String]]('o', "operations")
        .optional()
        .valueName("Operations, any of: " + ALUOps.allNames.mkString(", "))
        .action((operations, c) =>
          c.copy(operations = operations.map(nameLookup(_)))
        )
        .text("ALU operations"),
      opt[String]('p', "platform")
        .optional()
        .valueName(
          "Platform, any of: " + Seq("asap7", "sky130hd").mkString(", ")
        )
        .action((platform, c) => c.copy(platform = platform))
        .text("PDK")
    )
  }

  val (configArgs, afterDelimiter) = args.span(_ != "--")
  val chiselArgs = afterDelimiter.drop(1)

  OParser.parse(parser, configArgs, ALUConfig()) match {
    case Some(c) =>
      new ChiselStage()
        .execute(
          chiselArgs,
          Seq(
            ChiselGeneratorAnnotation(() => new MockAlu()(c))
          )
        )

    case _ =>
      // arguments are invalid
      OParser.usage(parser, RenderingMode.TwoColumns)
      sys.exit(1)
  }
}
