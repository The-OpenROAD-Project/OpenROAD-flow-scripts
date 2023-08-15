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
  val ADD, SUB, AND, OR, XOR, SHL, SHR, SRA, SETCC_EQ, SETCC_NE, SETCC_LT,
      SETCC_ULT, SETCC_LE, SETCC_ULE, MULT = Value
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
      bitWidth: Int
  ): UInt = {
    val operand = Module(new Operand(bitWidth, op, name) with InlineInstance)
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
class multiplier extends BlackBox with HasBlackBoxPath {
  val io = IO(new Bundle() {
    val a = Input(UInt(64.W))
    val b = Input(UInt(64.W))
    val o = Output(UInt(128.W))
    val clk = Input(Clock())
    val rst = Input(Reset())
  })
  addPath("multiplier.v")
}

class MockAlu()(implicit bitWidth: Int, supportedOperations: Seq[ALUOps.Type])
    extends Module {
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

  val nameLookup = (ALUOps.all zip ALUOps.allNames).toMap

  val isSubtraction =
    Seq(
      ALUOps.SUB,
      ALUOps.SETCC_EQ,
      ALUOps.SETCC_NE,
      ALUOps.SETCC_LT,
      ALUOps.SETCC_LE,
      ALUOps.SETCC_ULT,
      ALUOps.SETCC_ULE
    ).map(op === _).reduce(_ || _)

  val modifiedB = Mux(isSubtraction, ~b, b)

  val extendedResult =
    WireInit(UInt(((bitWidth + 1).W)), a +& modifiedB +& isSubtraction.asUInt)

  val result = extendedResult(extendedResult.getWidth - 2, 0)
  val carryOut = extendedResult(extendedResult.getWidth - 1)

  val isTrueZero = !result.orR
  val isNegative = result(bitWidth - 1)

  val barrel = Module(new BarrelShifter(bitWidth))
  barrel.io.data := a
  barrel.io.shiftAmount := b
  barrel.io.dir := io.op

  val mult = Module(new multiplier())
  mult.io.clk := clock
  mult.io.rst := reset
  mult.io.a := a
  mult.io.b := b

  io.out := RegNext(
    MuxLookup(
      op.asUInt,
      WireInit(chiselTypeOf(io.out), DontCare),
      (Seq[(ALUOps.Type, (UInt, UInt) => UInt)](
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
        ALUOps.MULT -> mult.io.o
      ))
        .filter(a => supportedOperations.contains(a._1))
        .map(a => (a._1.asUInt -> a._2))
    )
  )
}

case class ALUConfig(
    width: Int = 64
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
        .text("input file is required")
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
            ChiselGeneratorAnnotation(() =>
              new MockAlu()(
                c.width,
                ALUOps.all diff Seq(
                )
              )
            )
          )
        )

    case _ =>
      // arguments are invalid
      OParser.usage(parser, RenderingMode.TwoColumns)
      sys.exit(1)
  }
}
