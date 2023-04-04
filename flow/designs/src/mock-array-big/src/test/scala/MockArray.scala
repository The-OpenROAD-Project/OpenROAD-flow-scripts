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
    val insLeft = Input(Vec(width, UInt(singleElementWidth.W)))
    val insUp = Input(Vec(width, UInt(singleElementWidth.W)))
    val insRight = Input(Vec(width, UInt(singleElementWidth.W)))
    val insDown = Input(Vec(width, UInt(singleElementWidth.W)))
    val outsLeft = Output(Vec(width, UInt(singleElementWidth.W)))
    val outsUp = Output(Vec(width, UInt(singleElementWidth.W)))
    val outsRight = Output(Vec(width, UInt(singleElementWidth.W)))
    val outsDown = Output(Vec(width, UInt(singleElementWidth.W)))

    val lsbs = Output(Vec(width * height, Bool()))
  })

  class Element extends Module {
    val io =
      IO(new Bundle {
        val ins = Input(new VecWithNames(routes))
        val outs = Output(new VecWithNames(routes))

        val lsbIns = Input(Vec(width, Bool()))
        val lsbOuts = Output(Vec(width, Bool()))
      })

    // Registered routing paths
    //  left <-> down
    //  up <-> right
    (io.outs.asSeq zip io.ins.asSeq.reverse.map(RegNext(_))).foreach{case (a, b) => a := b}

    // Combinational logic
    //  Ensure no bits are excluded during optimization
    dontTouch(io.lsbIns)
    io.lsbOuts := io.lsbIns.drop(1) ++ Seq(io.outs.asSeq.head(0)(0))
  }

  val ces = Seq.fill(height)(Seq.fill(width)(Module(new Element())))

  ces.foreach{row =>
    row.head.io.lsbIns := DontCare
    row.sliding(2, 1).foreach{pair =>
      pair(1).io.lsbIns := pair(0).io.lsbOuts
  }}

  io.lsbs := ces.map(_.last.io.lsbOuts).flatten

  // Connect inputs to edge element buses
  (ces.map(_.head).map(_.io.ins.asSeq(Routes.RIGHT.id)) zip io.insRight).foreach { case (a, b) => a := b }
  (ces.last.map(_.io.ins.asSeq(Routes.DOWN.id)) zip io.insDown).foreach { case (a, b) => a := b }
  (ces.map(_.last).map(_.io.ins.asSeq(Routes.LEFT.id)) zip io.insLeft).foreach { case (a, b) => a := b }
  (ces.head.map(_.io.ins.asSeq(Routes.UP.id)) zip io.insUp).foreach { case (a, b) => a := b }

  // Connect edge element buses to outputs
  (ces.map(_.head).map(_.io.outs.asSeq(Routes.LEFT.id)) zip io.outsLeft).foreach { case (a, b) => b := a }
  (ces.last.map(_.io.outs.asSeq(Routes.UP.id)) zip io.outsUp).foreach { case (a, b) => b := a }
  (ces.map(_.last).map(_.io.outs.asSeq(Routes.RIGHT.id)) zip io.outsRight).foreach { case (a, b) => b := a }
  (ces.head.map(_.io.outs.asSeq(Routes.DOWN.id)) zip io.outsDown).foreach { case (a, b) => b := a }

  // Connect neighboring left/right element buses
  (ces.transpose.flatten zip ces.transpose.drop(1).flatten).foreach {
    case (a, b) =>
      a.io.ins.asSeq(Routes.LEFT.id) := b.io.outs.asSeq(Routes.LEFT.id)
      b.io.ins.asSeq(Routes.RIGHT.id) := a.io.outs.asSeq(Routes.RIGHT.id)
  }

  // Connect neighboring up/down element buses
  (ces.flatten zip ces.drop(1).flatten).foreach {
    case (a, b) =>
      a.io.ins.asSeq(Routes.DOWN.id) := b.io.outs.asSeq(Routes.DOWN.id)
      b.io.ins.asSeq(Routes.UP.id) := a.io.outs.asSeq(Routes.UP.id)
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
