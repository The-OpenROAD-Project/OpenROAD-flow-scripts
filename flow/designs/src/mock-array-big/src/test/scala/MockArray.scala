// to generate code, run:
// sbt "test:runMain GenerateMockArray --emit-modules verilog --target-dir ."

import chisel3._

import org.scalatest._

import chisel3._
import chisel3.dontTouch
import chisel3.util._
import chisel3.stage._
import chisel3.experimental._

class MockArray extends Module {

  val width = 8
  val height = 8
  val singleElementWidth = 8

  val io = IO(new Bundle {
    val insHorizontal = Input(Vec(2, Vec(width, UInt(singleElementWidth.W))))
    val outsHorizontal = Output(Vec(2, Vec(height, UInt(singleElementWidth.W))))
    val insVertical = Input(Vec(2, Vec(height, UInt(singleElementWidth.W))))
    val outsVertical = Output(Vec(2, Vec(height, UInt(singleElementWidth.W))))
    val lsbs = Output(Vec(width * height, Bool()))
  })

  class Element extends Module {
    val io =
      IO(new Bundle {
        val ins = Input(Vec(4, UInt(singleElementWidth.W)))
        val outs = Output(Vec(4, UInt(singleElementWidth.W)))
      })
    io.outs := io.ins.reverse.map(RegNext(_))
  }

  val ces = Seq.fill(height)(Seq.fill(height)(Module(new Element())))

  io.lsbs := ces.flatten.map(_.io.outs.head(0))

  // 0 top
  // 1 right
  // 2 bottom
  // 3 left
  (ces(0).map(_.io.ins(0)) zip io.insHorizontal(0)).foreach { case (a, b)        => a := b }
  (ces.map(_.last).map(_.io.ins(1)) zip io.insVertical(0)).foreach { case (a, b) => a := b }
  (ces.last.map(_.io.ins(2)) zip io.insHorizontal(1)).foreach { case (a, b)      => a := b }
  (ces.map(_.head).map(_.io.ins(3)) zip io.insVertical(1)).foreach { case (a, b) => a := b }

  (ces(0).map(_.io.outs(0)) zip io.outsHorizontal(0)).foreach { case (a, b)        => b := a }
  (ces.map(_.last).map(_.io.outs(1)) zip io.outsVertical(0)).foreach { case (a, b) => b := a }
  (ces.last.map(_.io.outs(2)) zip io.outsHorizontal(1)).foreach { case (a, b)      => b := a }
  (ces.map(_.head).map(_.io.outs(3)) zip io.outsVertical(1)).foreach { case (a, b) => b := a }

  (ces.flatten zip ces.drop(1).flatten).foreach {
    case (a, b) =>
      a.io.ins(2) := b.io.outs(0)
      b.io.ins(0) := a.io.outs(2)
  }

  (ces.transpose.flatten zip ces.transpose.drop(1).flatten).foreach {
    case (a, b) =>
      a.io.ins(1) := b.io.outs(3)
      b.io.ins(3) := a.io.outs(1)
  }
}

object GenerateMockArray extends App {

  new ChiselStage()
    .execute(args, Seq(ChiselGeneratorAnnotation(() => new MockArray())))
}
