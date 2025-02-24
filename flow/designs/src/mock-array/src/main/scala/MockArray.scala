// to generate code, run:
// ../../asap7/mock-array/configure.sh

import chisel3._

import org.scalatest._
import chiseltest._
import chiseltest.simulator.SimulatorDebugAnnotation
import chiseltest.simulator.VerilatorFlags
import org.scalatest.flatspec.AnyFlatSpec

import chisel3._
import chisel3.util._
import chisel3.stage._
import chisel3.experimental._
import chisel3.util.HasBlackBoxResource
import scopt.OParser
import System.err
import scopt.RenderingMode
import scala.collection.immutable.SeqMap
import java.nio.file.Paths

object Routes extends Enumeration {
  type Routes = Value

  val LEFT, UP, RIGHT, DOWN = Value
}

class RoutesVec(singleElementWidth: Int) extends Record {
  val routes = SeqMap(Routes.values.toSeq.map { bus =>
    bus -> UInt(singleElementWidth.W)
  }: _*)
  val elements = routes.map { case (a, b) => a.toString().toLowerCase() -> b }

  def asMap: SeqMap[Routes.Value, UInt] = routes
  def asSeq: Seq[UInt] = routes.map(_._2).toSeq
}

class BusesVec(singleElementWidth: Int, width: Int, height: Int)
    extends Record {
  val routes = SeqMap(
    Routes.LEFT -> Vec(height, UInt(singleElementWidth.W)),
    Routes.RIGHT -> Vec(height, UInt(singleElementWidth.W)),
    Routes.UP -> Vec(width, UInt(singleElementWidth.W)),
    Routes.DOWN -> Vec(width, UInt(singleElementWidth.W))
  )
  val elements = routes.map { case (a, b) => a.toString().toLowerCase() -> b }

  def asMap: SeqMap[Routes.Value, Vec[UInt]] = routes
  def asSeq: Seq[Vec[UInt]] = routes.map(_._2).toSeq
}

class MockArrayBundle(width: Int, height: Int, singleElementWidth: Int) extends Bundle {
  val ins = Input(new BusesVec(singleElementWidth, width, height))
  val outs = Output(new BusesVec(singleElementWidth, width, height))
  val lsbs = Output(Vec(width * height, Bool()))
}

// Generated with:
//
// vlsi-multiplier --register-input --register-post-ppg --register-post-ppa --register-output --bits=32 --algorithm=brentkung --tech=asap7 --output=multiplier.v
class Multiplier extends BlackBox with HasBlackBoxResource {
  override def desiredName = "multiplier"
  val io = IO(new Bundle {
    val a = Input(UInt(32.W))
    val b = Input(UInt(32.W))
    val o = Output(UInt(32.W))
    val rst = Input(Bool())
    val clk = Input(Clock())
  })
  addResource("/multiplier.v")
}

class MockArray(width: Int, height: Int, singleElementWidth: Int)
    extends Module {
  val io = IO(new MockArrayBundle(width, height, singleElementWidth))

  class Element extends Module {
    val io =
      IO(new Bundle {
        val ins = Input(new RoutesVec(singleElementWidth))
        val outs = Output(new RoutesVec(singleElementWidth))

        val lsbIns = Input(Vec(width, Bool()))
        val lsbOuts = Output(Vec(width, Bool()))
      })

    // Registered routing paths
    //  left <-> down
    //  up <-> right
    (io.outs.asSeq zip (io.ins.asSeq ++ Seq(io.ins.asSeq.head))
      .sliding(2).toSeq.reverse.map(_.map(RegNext(_)))).foreach {
      case (a, b) => a := RegNext({
        val mult = Module(new Multiplier())
        mult.io.a := b(0)
        mult.io.b := b(1)
        // save some area and complexity by not having reset
        mult.io.rst := false.B
        mult.io.clk := clock
        // reduce output bit-width until we slight negative slack
        mult.io.o(15, 0)
      })
    }

    // Combinational logic, but a maximum flight path of 4 elements
    val MAX_FLIGHT = 4
    io.lsbOuts := (io.lsbIns
      .drop(1)
      .reverse
      .sliding(MAX_FLIGHT, MAX_FLIGHT)
      .map { lsbs =>
        if (lsbs.length < MAX_FLIGHT) {
          lsbs
        } else {
          lsbs.dropRight(1) ++ Seq(RegNext(lsbs.last))
        }
      })
      .flatten
      .toSeq
      .reverse ++ Seq(io.outs.asSeq.head(0)(0))
  }

  val ces = Seq.fill(height)(Seq.fill(width)(Module(new Element())))

  ces.foreach { row =>
    row.head.io.lsbIns := DontCare
    if (row.length > 1) {
      row.sliding(2, 1).foreach { pair =>
        pair(1).io.lsbIns := pair(0).io.lsbOuts
      }
    }
  }

  io.lsbs := RegNext(VecInit(ces.map(_.last.io.lsbOuts).flatten))

  // Connect inputs to edge element buses
  (ces.map(_.head).map(_.io.ins.asMap(Routes.RIGHT)) zip io.ins.asMap(
    Routes.RIGHT
  )).foreach { case (a, b) => a := b }
  (ces.last.map(_.io.ins.asMap(Routes.DOWN)) zip io.ins.asMap(Routes.DOWN))
    .foreach { case (a, b) => a := b }
  (ces.map(_.last).map(_.io.ins.asMap(Routes.LEFT)) zip io.ins.asMap(
    Routes.LEFT
  )).foreach { case (a, b) => a := b }
  (ces.head.map(_.io.ins.asMap(Routes.UP)) zip io.ins.asMap(Routes.UP))
    .foreach { case (a, b) => a := b }

  // Connect edge element buses to outputs
  (ces.map(_.head).map(_.io.outs.asMap(Routes.LEFT)) zip io.outs.asMap(
    Routes.LEFT
  )).foreach { case (a, b) => b := a }
  (ces.last.map(_.io.outs.asMap(Routes.UP)) zip io.outs.asMap(Routes.UP))
    .foreach { case (a, b) => b := a }
  (ces.map(_.last).map(_.io.outs.asMap(Routes.RIGHT)) zip io.outs.asMap(
    Routes.RIGHT
  )).foreach { case (a, b) => b := a }
  (ces.head.map(_.io.outs.asMap(Routes.DOWN)) zip io.outs.asMap(Routes.DOWN))
    .foreach { case (a, b) => b := a }

  // Connect neighboring left/right element buses
  (ces.transpose.flatten zip ces.transpose.drop(1).flatten).foreach {
    case (a, b) =>
      a.io.ins.asMap(Routes.LEFT) := b.io.outs.asMap(Routes.LEFT)
      b.io.ins.asMap(Routes.RIGHT) := a.io.outs.asMap(Routes.RIGHT)
  }

  // Connect neighboring up/down element buses
  (ces.flatten zip ces.drop(1).flatten).foreach { case (a, b) =>
    a.io.ins.asMap(Routes.DOWN) := b.io.outs.asMap(Routes.DOWN)
    b.io.ins.asMap(Routes.UP) := a.io.outs.asMap(Routes.UP)
  }
}

case class ArrayConfig(
    width: Int = 8,
    height: Int = 8,
    dataWidth: Int = 8,
    remainingArgs: Seq[String] = Seq.empty
)

class MockArrayPostSynthesis(width:Int, height:Int, singleElementWidth:Int) 
extends BlackBox with HasBlackBoxPath {
  override def desiredName = "MockArray"
  val io = IO(new Bundle {
    val clock = Input(Clock())
    val reset = Input(Bool())
    val io = new MockArrayBundle(width, height, singleElementWidth)
  })
  val platformDir = sys.env.getOrElse("PLATFORM_DIR", "defaultPath") + "/verilog/stdcell/"
  (Seq("asap7sc7p5t_AO_RVT_TT_201020.v",
    "dff.v",
    "asap7sc7p5t_SIMPLE_RVT_TT_201020.v",
    "asap7sc7p5t_INVBUF_RVT_TT_201020.v",
    "empty.v").map(p=>Paths.get(platformDir + p)) ++
    Seq(
  "MockArrayFinal.v",
  "MockArrayElementFinal.v").map(p=>Paths.get("post/" + p)))
  .foreach(p=> addPath(p.toAbsolutePath().toString()))
}

class MockArrayTestbench(width:Int, height:Int, singleElementWidth:Int) extends Module {
  val io = IO(new MockArrayBundle(width, height, singleElementWidth))
  val postSynthesis = Module(new MockArrayPostSynthesis(width, height, singleElementWidth))
  postSynthesis.io.io <> io
  postSynthesis.io.reset := reset.asBool
  postSynthesis.io.clock := clock
}


class MockArrayTest(width:Int, height:Int, singleElementWidth:Int) extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "MockArray"

  it should "Wiggle some wires" in {
    // find full path foo.v in scala/src/resources
    test(new MockArrayTestbench(width, height, singleElementWidth)).
      withAnnotations(Seq(WriteVcdAnnotation,
      VerilatorBackendAnnotation,
      SimulatorDebugAnnotation,
      // DD flip flops use UDP Tables, unsupported by Verilator
      VerilatorFlags(Seq())
      )) { dut =>
      for (j <- 0 until 5) {
        dut.io.ins.routes.foreach { case (route, vec) =>
          vec.zipWithIndex.foreach { case (wire, i) =>
            wire.poke((i+j).U)
            dut.clock.step(1)
          }
        }
      }
    }
  }
}


object parse {
  def apply(args:Array[String]) : (ArrayConfig, Array[String]) = {
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
        return (c, chiselArgs)

      case _ =>
        // arguments are invalid
        OParser.usage(parser, RenderingMode.TwoColumns)
        sys.exit(1)
    }
  }

}

object GenerateMockArray extends App {
  val (c, chiselArgs) = parse(args)

  new ChiselStage()
    .execute(
      chiselArgs,
      Seq(
        ChiselGeneratorAnnotation(() =>
          new MockArray(c.width, c.height, c.dataWidth)
        )
      )
    )
}

object SimulatePostSynthesis extends App {
  val (c, chiselArgs) = parse(args)
  new MockArrayTest(c.width, c.height, c.dataWidth).execute()
}
