import chisel3._

import org.scalatest._

import chisel3._
import chisel3.util._
import chisel3.util.experimental.InlineInstance
import chisel3.stage._
import chiseltest._
import chiseltest.formal._
import chiseltest.simulator.WriteVcdAnnotation

import org.scalatest.flatspec.AnyFlatSpec

import scopt.OParser
import System.err
import scopt.RenderingMode
import scala.collection.immutable.SeqMap

class MockAluTests extends AnyFlatSpec with ChiselScalatestTester with Formal {
  behavior of "MockAlu"

  val bitWidth = 8
  val annotations = Seq(WriteVcdAnnotation)

  def testOp(a: Int, b: Int, out: Int, op: ALUOps.Type): Unit = {

    it should (op.toString + " " + a.toHexString + " " + b.toHexString + "=" + out.toHexString) in {
      test(new MockAlu()(bitWidth, ALUOps.all))
        .withAnnotations(annotations) { dut =>
          val mask = (1 << bitWidth) - 1
          dut.io.a.poke((a & mask).U)
          dut.io.b.poke((b & mask).U)
          dut.io.op.poke(op)
          dut.clock.step(1)
          dut.clock.step(1)
          dut.io.out.expect((out & mask).U)
        }
    }
  }
  testOp(20, 22, 42, ALUOps.ADD)
  testOp(0xff, 0x1, 0, ALUOps.ADD)
  testOp(43, 1, 42, ALUOps.SUB)
  testOp(42, 42, 1, ALUOps.SETCC_EQ)
  testOp(43, 42, 1, ALUOps.SETCC_NE)
  testOp(42, 43, 1, ALUOps.SETCC_LT)
  testOp(42, 42, 0, ALUOps.SETCC_LT)
  testOp(42, 43, 1, ALUOps.SETCC_LE)
  testOp(42, 42, 1, ALUOps.SETCC_LE)
  testOp(42, 41, 0, ALUOps.SETCC_LE)
  testOp(-1, -2, 0, ALUOps.SETCC_LE)
  testOp(-3, -2, 1, ALUOps.SETCC_LE)
  testOp(0xfe, 0xff, 1, ALUOps.SETCC_ULE)
  testOp(0xff, 0xff, 1, ALUOps.SETCC_ULE)
  testOp(0, 0xff, 1, ALUOps.SETCC_ULE)
  testOp(0xff, 0xfe, 0, ALUOps.SETCC_ULE)
  testOp(0xfe, 0xff, 1, ALUOps.SETCC_ULT)
  testOp(0xff, 0xff, 0, ALUOps.SETCC_ULT)
  testOp(0, 0xff, 1, ALUOps.SETCC_ULT)
  testOp(0xff, 0xfe, 0, ALUOps.SETCC_ULT)
  testOp(0xff, 4, 0xf, ALUOps.SHR)
  testOp(0xff, 4, 0xff, ALUOps.SRA)
  testOp(0xf0, 3, 0xfe, ALUOps.SRA)
  testOp(0x0f, 4, 0xf0, ALUOps.SHL)
}
