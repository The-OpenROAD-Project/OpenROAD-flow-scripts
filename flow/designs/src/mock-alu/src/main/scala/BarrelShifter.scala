import chisel3._

import chisel3._
import chisel3.util._

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
