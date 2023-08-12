import chisel3._

import org.scalatest._

import chisel3._
import chisel3.util._
import chisel3.stage._
import scopt.OParser
import System.err
import scopt.RenderingMode
import scala.collection.immutable.SeqMap

object ALUOps extends ChiselEnum {
  val ADD, SUB, AND, OR, XOR, SHL, SHR, SRA, SETCC_EQ, SETCC_NE, SETCC_LT,
      SETCC_ULT, SETCC_LE, SETCC_ULE, MULT = Value
}

class MockAlu(bitWidth: Int) extends Module {
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

  val out = WireInit(chiselTypeOf(io.out), DontCare)

  val shiftAmount = b(log2Ceil(bitWidth), 0)

  switch(op) {
    is(ALUOps.ADD) {
      out := a + b
    }
    is(ALUOps.SUB) {
      out := a - b
    }
    is(ALUOps.AND) {
      out := a & b
    }
    is(ALUOps.OR) {
      out := a | b
    }
    is(ALUOps.XOR) {
      out := a ^ b
    }
    is(ALUOps.SETCC_EQ) {
      out := a === b
    }
    is(ALUOps.SETCC_NE) {
      out := a =/= b
    }
    is(ALUOps.SETCC_LT) {
      out := a.asSInt < b.asSInt
    }
    is(ALUOps.SETCC_LE) {
      out := a.asSInt <= b.asSInt
    }
    is(ALUOps.SETCC_ULT) {
      out := a < b
    }
    is(ALUOps.SETCC_ULE) {
      out := a <= b
    }
    // TODO later we can examine barrel shifters and pipelined multiplication, focus
    // on addition/subtraction and comparison as well as muxing required in an ALU
    //
    // is(ALUOps.SHL) {
    //   out := a << shiftAmount
    // }
    // is(ALUOps.SHR) {
    //   out := a >> shiftAmount
    // }
    // is(ALUOps.SRA) {
    //   out := (a.asSInt >> shiftAmount).asUInt
    // }
    // is(ALUOps.MULT) {
    //   // pipelined multiplication
    //   out := ShiftRegister(a * b, 4)
    // }
  }
  io.out := RegNext(out)
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
            ChiselGeneratorAnnotation(() => new MockAlu(c.width))
          )
        )

    case _ =>
      // arguments are invalid
      OParser.usage(parser, RenderingMode.TwoColumns)
      sys.exit(1)
  }
}
