// to generate code, run:
// sbt "test:runMain GenerateMockArray --emit-modules verilog --target-dir ."

import chisel3._

import org.scalatest._

import chisel3._
import chisel3.dontTouch
import chisel3.util._
import chisel3.stage._
import chisel3.experimental._
import scopt.OParser
import System.err
import scopt.RenderingMode

class MockArray(width:Int, height:Int, singleElementWidth:Int) extends Module {

  val io = IO(new Bundle {
    val insHorizontal = Input(Vec(2, Vec(width, UInt(singleElementWidth.W))))
    val outsHorizontal = Output(Vec(2, Vec(width, UInt(singleElementWidth.W))))
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

  val ces = Seq.fill(height)(Seq.fill(width)(Module(new Element())))

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

case class ArrayConfig(width: Int = 8, height: Int = 8, dataWidth: Int = 8, remainingArgs: Seq[String] = Seq.empty)

object GenerateMockArray extends App {


  val builder = OParser.builder[ArrayConfig]
  val parser = {
    import builder._
    OParser.sequence(
      programName("my-program"),
      opt[Int]('w', "width")
        .required()
        .valueName("Array width")
        .action((width, c) => c.copy(width = width))
        .text("input file is required"),
      opt[Int]('h', "height")
        .required()
        .valueName("height")
        .action((height, c) => c.copy(height = height))
        .text("Array height"),
      opt[Int]('d', "dataWidth")
        .required()
        .valueName("dataWidth")
        .action((dataWidth, c) => c.copy(dataWidth = dataWidth))
        .text("data path width")
    )
  }

  val (configArgs, afterDelimiter) = args.span(_ != "--")
  val chiselArgs = afterDelimiter.drop(1)

  OParser.parse(parser, configArgs, ArrayConfig()) match {
    case Some(c) =>

    new ChiselStage()
      .execute(chiselArgs, Seq(ChiselGeneratorAnnotation(() => new MockArray(c.width, c.height, c.dataWidth))))

    case _ =>
      // arguments are invalid
      OParser.usage(parser, RenderingMode.TwoColumns)
      sys.exit(1)
  }
}
