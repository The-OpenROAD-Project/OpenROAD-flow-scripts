import chisel3._
import chisel3.util._
import java.nio.charset.StandardCharsets._
import java.nio.file.{Files, Paths, StandardOpenOption}

object Operation extends Enumeration {
  type Operation = Value

  val COPY, ADD, MULTIPLY, DIVIDE = Value
}

/**
  * Muxes of various sizes with anything from just wiring, to add, to multiply with pipelining
  */
class MuxTest(width: Int, inputNum: Int, outputNum: Int, pipeline: Int) extends Module {
  class MuxTestBundle extends Bundle {
    val selects = Input(Vec(outputNum, Vec(2, UInt(log2Ceil(inputNum).W))))
    val operation = Input(Vec(outputNum, UInt(log2Ceil((Operation.maxId + 1)).W)))
    val inputs = Input(Vec(inputNum, UInt(width.W)))
    val outputs = Output(Vec(outputNum, UInt(width.W)))
  }
  val io = IO(new MuxTestBundle)
  io.outputs :=
    (io.selects.map(_.map(io.inputs(_))) zip io.operation)
      .map {
        case (inputs, operation) =>
          MuxLookup(
            operation,
            0.U,
            Seq(
              Operation.COPY.id.U -> inputs(0),
              Operation.ADD.id.U -> inputs.reduce(_ + _),
              Operation.MULTIPLY.id.U -> inputs.reduce(_ * _),
              Operation.DIVIDE.id.U -> inputs.reduce(_ / _)
            )
          )
      }
      .map(ShiftRegister(_, pipeline))
}

/**
  * One simple way to edit these tests is:
  *
  * 1. Install Visual Studio Code
  * 2. Install Scala Metals plug
  * 3. Edit
  * 4. From within Visual Studio Code terminal, run "sbt "test:runMain GenerateTests"
  *    to generate the tests.
  */
object GenerateTests extends App {

  def generateTest(testName: String, dut: () => Module) {
    val testFile = testName + ".v"
    chisel3.Driver.execute(Array[String]("--output-file", testFile), dut)

    Files.write(
      Paths.get(testFile),
      new String(Files.readAllBytes(Paths.get(testFile)), UTF_8)
        .replace("MuxTest", testName)
        .getBytes("UTF8"),
      StandardOpenOption.WRITE,
      StandardOpenOption.CREATE
    )
  }

  def muxTests() {
    for (pipeline <- Seq(0, 5)) {
      for (width <- Seq(1, 16, 64, 256)) {
        val variants = Seq(1, 4, 8, 16)
        for (inputNum <- variants) {
          for (outputNum <- variants) {
            generateTest(
              "MuxTest_width_" + width + "_inputs_" + inputNum + "_outputs_" + outputNum + "_pipeline_" + pipeline,
              () => new MuxTest(width, inputNum, outputNum, pipeline)
            )
          }
        }
      }
    }
  }

  muxTests
}
