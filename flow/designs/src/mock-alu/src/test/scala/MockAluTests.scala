import chisel3._

import org.scalatest._

import chisel3._
import chisel3.util._
import chisel3.util.experimental.InlineInstance
import chisel3.stage._
import chiseltest._
import chiseltest.formal._
import chiseltest.simulator.{WriteVcdAnnotation, VerilatorFlags}
import chiseltest.internal.CachingAnnotation

import org.scalatest.flatspec.AnyFlatSpec

import scopt.OParser
import System.err
import scopt.RenderingMode
import scala.collection.immutable.SeqMap

import java.nio.file.Paths

// Run tests:
//
// VERILATOR_ROOT=~/verilator/install/v5.006/verilator sbt "test:testOnly *"
class MockAluTests extends AnyFlatSpec with ChiselScalatestTester with Formal {
  behavior of "MockAlu"

  val bitWidth = 8
  val annotations =
    Seq(
      WriteVcdAnnotation,
      VerilatorBackendAnnotation,
      VerilatorFlags(
        Seq(
          "-Wno-TIMESCALEMOD",
          "-I" + Paths.get("src/test/resources").toAbsolutePath.toString,
          "asap7sc7p5t_AO_RVT_TT_201020.v",
          "asap7sc7p5t_INVBUF_RVT_TT_201020.v",
          "asap7sc7p5t_OA_RVT_TT_201020.v",
          // "asap7sc7p5t_SEQ_RVT_TT_220101.v",
          "asap7sc7p5t_SIMPLE_RVT_TT_201020.v"
        )
      ),
      CachingAnnotation
    )

  def testOp(
      a: Int,
      b: Int,
      out: Int,
      op: ALUOps.Type,
      pipelineStages: Int = 1
  ): Unit = {

    it should (op.toString + " " + a.toHexString + " " + b.toHexString + "=" + out.toHexString) in {
      test(
        new MockAlu()(
          ALUConfig(
            bitWidth,
            ALUOps.all.diff(ALUOps.multipliers ++ ALUOps.adders) ++ Seq(
              ALUOps.MULT
            )
          )
        )
      )
        .withAnnotations(annotations) { dut =>
          val mask = (1 << bitWidth) - 1
          dut.io.a.poke((a & mask).U)
          dut.io.b.poke((b & mask).U)
          dut.io.op.poke(op)
          for (i <- 0 until pipelineStages) {
            dut.clock.step(1)
          }
          dut.clock.step(1)
          dut.io.out.expect((out & mask).U)
        }
    }
  }
  testOp(123, 33, 123 + 33, ALUOps.CLAADD)
  testOp(123, 33, 123 + 33, ALUOps.KOGGESTONEADD)
  testOp(0x83, 0x77, (0x77 + 0x83) & 0xff, ALUOps.KOGGESTONEADD)
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
  testOp(21, 2, 42, ALUOps.MULT, 4)
  testOp(127598, 1235215, 127598 * 1235215, ALUOps.MULT, 4)
}
