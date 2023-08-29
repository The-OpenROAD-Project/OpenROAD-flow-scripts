import chisel3._

import chisel3._
import chisel3.util._

// multiply.v was generated using https://github.com/antonblanchard/vlsiffra:
//
// vlsi-multiplier --bits=64 --algorithm=hancarlson --tech=asap7 --register-post-ppa --register-post-ppg --output=multiply.v
class multiplier()(implicit config: ALUConfig)
    extends BlackBox
    with HasBlackBoxResource {
  val io = IO(new Bundle() {
    val a = Input(UInt(64.W))
    val b = Input(UInt(64.W))
    val o = Output(UInt(128.W))
    val clk = Input(Clock())
    val rst = Input(Reset())
  })
  val mult = ALUOps.multipliers.intersect(config.operations)(0)
  val opName = nameLookup(mult).toLowerCase()
  val algorithm = if (opName == "mult") { "mult_hancarlson" }
  else { opName }

  addResource("/" + config.platform + "/" + algorithm + ".v")
}

class adder()(implicit config: ALUConfig)
    extends BlackBox
    with HasBlackBoxResource {
  val io = IO(new Bundle() {
    val a = Input(UInt(64.W))
    val b = Input(UInt(64.W))
    val o = Output(UInt(64.W))
  })
  val adder = ALUOps.adders.intersect(config.operations)(0)
  val opName = nameLookup(adder).toLowerCase()

  addResource("/" + config.platform + "/" + opName + ".v")
}

class multiply_adder()(implicit config: ALUConfig)
    extends BlackBox
    with HasBlackBoxResource {
  val io = IO(new Bundle() {
    val a = Input(UInt(64.W))
    val b = Input(UInt(64.W))
    val c = Input(UInt(64.W))
    val o = Output(UInt(128.W))
    val clk = Input(Clock())
    val rst = Input(Reset())
  })
  val mult = ALUOps.macs.intersect(config.operations)(0)
  val algorithm = nameLookup(mult).toLowerCase()

  addResource("/" + config.platform + "/" + algorithm + ".v")
}

class CLA4bit extends Module {
  val io = IO(new Bundle {
    val A = Input(UInt(4.W))
    val B = Input(UInt(4.W))
    val Cin = Input(Bool())
    val SUM = Output(UInt(4.W))
    val Cout = Output(Bool())
  })

  val G = io.A & io.B
  val P = io.A ^ io.B

  val C = Wire(Vec(4, Bool()))
  C(0) := io.Cin
  C(1) := G(0) | (P(0) & C(0))
  C(2) := G(1) | (P(1) & G(0)) | (P(1) & P(0) & C(0))
  C(3) := G(2) | (P(2) & G(1)) | (P(2) & P(1) & G(0)) | (P(2) & P(1) & P(0) & C(
    0
  ))

  io.Cout := G(3) | (P(3) & G(2)) | (P(3) & P(2) & G(1)) | (P(3) & P(2) & P(
    1
  ) & G(0)) | (P(3) & P(2) & P(1) & P(0) & C(0))
  io.SUM := P ^ (C(3) ## C(2) ## C(1) ## C(0))
}

class CarryLookAheadAdder(val width: Int) extends Module {
  require(width % 4 == 0, "Width must be a multiple of 4")
  val numBlocks = width / 4

  val io = IO(new Bundle {
    val A = Input(UInt(width.W))
    val B = Input(UInt(width.W))
    val Cin = Input(Bool()) // Added this line for carry-in
    val SUM = Output(UInt(width.W))
    val Cout = Output(Bool())
  })

  val blockSum = Wire(Vec(numBlocks, UInt(4.W)))
  val blockCarry = Wire(Vec(numBlocks, Bool()))

  for (i <- 0 until numBlocks) {
    val cla = Module(new CLA4bit)
    cla.io.A := io.A(4 * i + 3, 4 * i)
    cla.io.B := io.B(4 * i + 3, 4 * i)
    cla.io.Cin := {
      if (i == 0) io.Cin else blockCarry(i - 1)
    }
    blockSum(i) := cla.io.SUM
    blockCarry(i) := cla.io.Cout
  }

  io.SUM := blockSum.reverse.reduce(_ ## _)
  io.Cout := blockCarry.last
}

class AO22x1_ASAP7_75t_R extends BlackBox {
  val io = IO(new Bundle {
    val A1 = Input(Bool())
    val A2 = Input(Bool())
    val B1 = Input(Bool())
    val B2 = Input(Bool())
    val Y = Output(Bool())
  })
}

class AO22 extends Module {
  val io = IO(new Bundle {
    val A1 = Input(Bool())
    val A2 = Input(Bool())
    val B1 = Input(Bool())
    val B2 = Input(Bool())
    val Y = Output(Bool())
  })

  val and_out1 = io.A1 & io.A2
  val and_out2 = io.B1 & io.B2

  io.Y := and_out1 | and_out2
}

// HAxp5_ASAP7_75t_R _18_ (
//   .A(\a[0] ),
//   .B(\b[0] ),
//   .CON(_06_),
//   .SN(_07_)
// );

// Define the given half adder module with the same PDK interface
class HAxp5_ASAP7_75t_R_behavioral extends Module {
  val io = IO(new Bundle {
    val A = Input(Bool())
    val B = Input(Bool())
    val SN = Output(Bool()) // This is effectively the sum
    val CON = Output(Bool()) // This is effectively the carry-out
  })

  // Provided half adder logic
  val A__bar = ~io.A
  val B__bar = ~io.B
  io.CON := A__bar | B__bar
  io.SN := (A__bar & B__bar) | (io.A & io.B)
}

class HAxp5_ASAP7_75t_R extends BlackBox {
  val io = IO(new Bundle {
    val A = Input(Bool())
    val B = Input(Bool())
    val SN = Output(Bool()) // This is effectively the sum
    val CON = Output(Bool()) // This is effectively the carry-out
  })
}

class FAx1_ASAP7_75t_R extends BlackBox {
  val io = IO(new Bundle {
    val A = Input(Bool())
    val B = Input(Bool())
    val CI = Input(Bool())
    val CON = Output(Bool())
    val SN = Output(Bool())
  })
}

class KoggeStoneAdder(val width: Int) extends Module {
  val io = IO(new Bundle {
    val A = Input(UInt(width.W))
    val B = Input(UInt(width.W))
    val cin = Input(Bool())
    val sum = Output(UInt(width.W))
    val cout = Output(Bool())
  })

  val G = Array.fill(width)(false.B)
  val P = Array.fill(width)(false.B)
  val Gout = Array.fill(width + 1)(false.B) // +1 for initial carry in
  val Pout = Array.fill(width + 1)(false.B) // +1 for initial carry in

  // Use the full adders to generate the base Generate (G) and Propagate (P) signals
  val fullAdders = Array.fill(width)(Module(new FAx1_ASAP7_75t_R))
  for (i <- 0 until width) {
    fullAdders(i).io.A := io.A(i)
    fullAdders(i).io.B := io.B(i)
    fullAdders(i).io.CI := 0.U // No carry-in for this stage
    P(i) = fullAdders(i).io.SN
    G(i) = fullAdders(i).io.CON
  }

  // Initialize the Kogge-Stone carry structure with input carry and the base Generate/Propagate
  Gout(0) = io.cin
  Pout(0) = io.cin

  for (i <- 0 until width) {
    Gout(i + 1) = G(i)
    Pout(i + 1) = P(i)
  }

  // Kogge-Stone Prefix Network
  val stages = log2Ceil(width)
  for (stage <- 1 to stages) {
    val offset = 1 << (stage - 1)
    for (i <- 1 to width) {
      if (i >= offset) {
        Gout(i) = Gout(i) | (Pout(i) & Gout(i - offset))
        Pout(i) = Pout(i) & Pout(i - offset)

        // val ao_gate = Module(new AO22x1_ASAP7_75t_R())
        val ao_gate = Module(new AO22())
        ao_gate.io.A1 := Pout(i)
        ao_gate.io.A2 := Gout(i - offset)
        ao_gate.io.B1 := 0.U
        ao_gate.io.B2 := 0.U
        Gout(i) = Gout(i) | ao_gate.io.Y

        Pout(i) = Pout(i) & Pout(i - offset)
      }
    }
  }

  // Sum computation using half adders
  io.sum := Seq
    .tabulate(width) { i =>
      io.A(i) ^ io.B(i) ^ Gout(i)
    }
    .map(_.asUInt)
    .reverse
    .reduce { (a, b) => a ## b } // reverse, because we generated MSB to LSB

  // Carry out computation
  io.cout := Gout(width)
}
