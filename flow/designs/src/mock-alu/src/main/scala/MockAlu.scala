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

object ALUOps extends ChiselEnum {
  val ADD, ADD8, ADD16, ADD32, SUB, AND, OR, XOR, SHL, SHR, SRA, SETCC_EQ,
      SETCC_NE, SETCC_LT, SETCC_ULT, SETCC_LE, SETCC_ULE, MULT, MULT_HANCARLSON,
      MULT_BRENTKUNG, MAC_BRENTKUNG, MULT_INFERRED, MULT_KOGGESTONE,
      MULT_RIPPLE, MUX1, MUX2, MUX3, MUX4, MUX5, MUX6, MUX7, MUX8 = Value
  def multipliers: Seq[ALUOps.Type] = {
    Seq(
      ALUOps.MULT,
      ALUOps.MULT_BRENTKUNG,
      ALUOps.MULT_HANCARLSON,
      ALUOps.MULT_INFERRED,
      ALUOps.MULT_KOGGESTONE,
      ALUOps.MULT_RIPPLE
    )
  }
  def macs: Seq[ALUOps.Type] = {
    Seq(
      ALUOps.MAC_BRENTKUNG
    )
  }
}

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

// TODO Will synthesis result in a realistic barrel shifter?
class BarrelShifter(bitWidth: Int) extends Module {
  val io = IO(new Bundle {
    val data = Input(UInt(bitWidth.W))
    val shiftAmount = Input(UInt(log2Ceil(bitWidth).W))
    val dir = Input(ALUOps())
    val out = Output(UInt(bitWidth.W))
  })

  val rotate = Mux(
    io.dir === ALUOps.SHL,
    bitWidth.U - io.shiftAmount,
    io.shiftAmount
  )

  val rotateInput = MuxLookup(
    io.dir.asUInt,
    0.U,
    Seq(
      ALUOps.SRA ->
        Fill(bitWidth, io.data(bitWidth - 1)),
      ALUOps.SHL -> io.data,
      ALUOps.SHR -> 0.U
    ).map(a => (a._1.asUInt, a._2))
  ) ## Mux(io.dir === ALUOps.SHL, 0.U, io.data)

  io.out := rotateInput >> rotate
}

// multiply.v was generated using https://github.com/antonblanchard/vlsiffra:
//
// vlsi-multiplier --bits=64 --algorithm=hancarlson --tech=asap7 --register-post-ppa --register-post-ppg --output=multiply.v
class multiplier()(implicit config: ALUConfig)
    extends BlackBox
    with HasBlackBoxResource {
  val io = IO(new Bundle() {
    val a = Input(UInt(64.W))
    val b = Input(UInt(64.W))
    val o = Output(UInt(128.W))
    val clk = Input(Clock())
    val rst = Input(Reset())
  })
  val mult = ALUOps.multipliers.intersect(config.operations)(0)
  val opName = nameLookup(mult).toLowerCase()
  val algorithm = if (opName == "mult") { "mult_hancarlson" }
  else { opName }

  addResource("/" + algorithm + ".v")
}

class multiply_adder()(implicit config: ALUConfig)
    extends BlackBox
    with HasBlackBoxResource {
  val io = IO(new Bundle() {
    val a = Input(UInt(64.W))
    val b = Input(UInt(64.W))
    val c = Input(UInt(64.W))
    val o = Output(UInt(128.W))
    val clk = Input(Clock())
    val rst = Input(Reset())
  })
  val mult = ALUOps.macs.intersect(config.operations)(0)
  val algorithm = nameLookup(mult).toLowerCase()

  addResource("/" + algorithm + ".v")
}

object nameLookup {
  def apply(op: ALUOps.Type): String = {
    val map = (ALUOps.all zip ALUOps.allNames).toMap
    map(op)
  }
  def apply(name: String): ALUOps.Type = {
    val map = (ALUOps.allNames zip ALUOps.all).toMap
    map(name)
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
  assert(Seq(0, 1).contains(activeMultipliers.length))

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
    ALUOps.XOR -> (_ ^ _)
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
    ALUOps.ADD16 -> result(15, 0),
    ALUOps.ADD32 -> result(31, 0),
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
    ALUOps.MAC_BRENTKUNG -> macResult
  ) ++ ALUOps.multipliers.map(op => op -> multResult) ++
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
      op -> (io.a >> i)
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
    operations: Seq[ALUOps.Type] = Seq.empty
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
        .text("ALU operations")
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
