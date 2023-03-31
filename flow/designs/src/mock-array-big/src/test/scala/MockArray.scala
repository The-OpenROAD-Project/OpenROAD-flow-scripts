// to generate code, run:
// ../../asap7/mock-array-big/configure.sh

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
import scala.collection.immutable.SeqMap


class VecWithNames[T <: Data](names: () => SeqMap[String, T]) extends Record {
  lazy val elements = names()

  def asSeq: Seq[T] = elements.map(_._2).toSeq
}

object Routes extends Enumeration {
  type Routes = Value

  val LEFT, UP, RIGHT, DOWN = Value
}

class MockArray(width:Int, height:Int, singleElementWidth:Int) extends Module {

  val routes = (() => {
    SeqMap(Routes.values.toSeq.map { bus =>
      bus.toString().toLowerCase() -> UInt(singleElementWidth.W)
    }: _*)
  })


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
        val ins = Input(new VecWithNames(routes))
        val outs = Output(new VecWithNames(routes))
      })
    (io.outs.asSeq zip io.ins.asSeq.reverse.map(RegNext(_))).foreach{case (a, b) => a := b}
  }

  val ces = Seq.fill(height)(Seq.fill(width)(Module(new Element())))

  io.lsbs := ces.flatten.map(_.io.outs.asSeq.head(0))

  // 0 top
  // 1 right
  // 2 bottom
  // 3 left
  (ces(0).map(_.io.ins.asSeq(0)) zip io.insHorizontal(0)).foreach { case (a, b)        => a := b }
  (ces.map(_.last).map(_.io.ins.asSeq(1)) zip io.insVertical(0)).foreach { case (a, b) => a := b }
  (ces.last.map(_.io.ins.asSeq(2)) zip io.insHorizontal(1)).foreach { case (a, b)      => a := b }
  (ces.map(_.head).map(_.io.ins.asSeq(3)) zip io.insVertical(1)).foreach { case (a, b) => a := b }

  (ces(0).map(_.io.outs.asSeq(0)) zip io.outsHorizontal(0)).foreach { case (a, b)        => b := a }
  (ces.map(_.last).map(_.io.outs.asSeq(1)) zip io.outsVertical(0)).foreach { case (a, b) => b := a }
  (ces.last.map(_.io.outs.asSeq(2)) zip io.outsHorizontal(1)).foreach { case (a, b)      => b := a }
  (ces.map(_.head).map(_.io.outs.asSeq(3)) zip io.outsVertical(1)).foreach { case (a, b) => b := a }

  (ces.flatten zip ces.drop(1).flatten).foreach {
    case (a, b) =>
      a.io.ins.asSeq(2) := b.io.outs.asSeq(0)
      b.io.ins.asSeq(0) := a.io.outs.asSeq(2)
  }

  (ces.transpose.flatten zip ces.transpose.drop(1).flatten).foreach {
    case (a, b) =>
      a.io.ins.asSeq(1) := b.io.outs.asSeq(3)
      b.io.ins.asSeq(3) := a.io.outs.asSeq(1)
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
