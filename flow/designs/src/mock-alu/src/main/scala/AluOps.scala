import chisel3._

import chisel3._
import chisel3.util._
import chisel3.util.experimental.InlineInstance
import chisel3.stage._

object ALUOps extends ChiselEnum {
  val ADD, ADDYOSYS, CLAADD,KOGGESTONEADD, ADD8, ADD16, ADD32, SUB, AND, OR, XOR, SHL, SHR, SRA, SETCC_EQ,
      SETCC_NE, SETCC_LT, SETCC_ULT, SETCC_LE, SETCC_ULE, MULT, MULT_HANCARLSON,
      MULT_HANCARLSON8, MULT_HANCARLSON16, MULT_HANCARLSON32, MULT_HANCARLSON48,
      MULT_HANCARLSON64, MULT_HANCARLSON96, MULT_HANCARLSON128, MULT_BRENTKUNG,
      MAC_BRENTKUNG, MULT_INFERRED, MULT_KOGGESTONE, MULT_RIPPLE,
      
      
      ADD_HANCARLSON,
      ADD_BRENTKUNG,
      ADD_INFERRED, ADD_KOGGESTONE, ADD_RIPPLE,
      
       MUX1, MUX2,
      MUX3, MUX4, MUX5, MUX6, MUX7, MUX8 = Value
  def multipliers: Seq[ALUOps.Type] = {
    Seq(
      MULT,
      MULT_BRENTKUNG,
      MULT_HANCARLSON,
      MULT_INFERRED,
      MULT_KOGGESTONE,
      MULT_RIPPLE,
      MULT_HANCARLSON8,
      MULT_HANCARLSON16,
      MULT_HANCARLSON32,
      MULT_HANCARLSON48,
      MULT_HANCARLSON64,
      MULT_HANCARLSON96,
      MULT_HANCARLSON128
    )
  }
  def macs: Seq[ALUOps.Type] = {
    Seq(
      ALUOps.MAC_BRENTKUNG
    )
  }
  def adders: Seq[ALUOps.Type] = {
    Seq(
      ADD_BRENTKUNG,
      ADD_HANCARLSON,
      ADD_INFERRED,
      ADD_KOGGESTONE,
      ADD_RIPPLE
    )
  }
}

object nameLookup {
  def apply(op: ALUOps.Type): String = {
    val map = (ALUOps.all zip ALUOps.allNames).toMap
    map(op)
  }
  def apply(name: String): ALUOps.Type = {
    val map = (ALUOps.allNames zip ALUOps.all).toMap
    map(name)
  }
}
