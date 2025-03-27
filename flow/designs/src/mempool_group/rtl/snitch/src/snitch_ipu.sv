// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

/// Integer Processing Unit
/// Based on Snitch Shared Muliplier/Divider
/// Author: Sergio Mazzola, <smazzola@student.ethz.ch>

module snitch_ipu #(
  parameter int unsigned IdWidth = 5
) (
  input  logic                     clk_i,
  input  logic                     rst_i,
  // Accelerator Interface - Slave
  input  logic [31:0]              acc_qaddr_i,      // unused
  input  logic [IdWidth-1:0]       acc_qid_i,
  input  logic [31:0]              acc_qdata_op_i,   // RISC-V instruction
  input  logic [31:0]              acc_qdata_arga_i,
  input  logic [31:0]              acc_qdata_argb_i,
  input  logic [31:0]              acc_qdata_argc_i,
  input  logic                     acc_qvalid_i,
  output logic                     acc_qready_o,
  output logic [31:0]              acc_pdata_o,
  output logic [IdWidth-1:0]       acc_pid_o,
  output logic                     acc_perror_o,
  output logic                     acc_pvalid_o,
  input  logic                     acc_pready_i
);
  `include "common_cells/registers.svh"

  typedef struct packed {
    logic [31:0]        result;
    logic [IdWidth-1:0] id;
  } result_t;
  // input handshake
  logic div_valid_op, div_ready_op;
  /* verilator lint_off UNDRIVEN */
  logic mul_valid_op, mul_ready_op;
  logic dsp_valid_op, dsp_ready_op;
  /* verilator lint_on UNDRIVEN */
  // output handshake
  logic mul_valid, mul_ready;
  logic div_valid, div_ready;
  logic dsp_valid, dsp_ready;
  result_t div, mul, dsp, oup;
  logic illegal_instruction;

  always_comb begin
    mul_valid_op = 1'b0;
    div_valid_op = 1'b0;
    dsp_valid_op = 1'b0;
    acc_qready_o = 1'b0;
    acc_perror_o = 1'b0;
    illegal_instruction = 1'b0;
    unique casez (acc_qdata_op_i)
      riscv_instr::MUL,
      riscv_instr::MULH,
      riscv_instr::MULHSU,
      riscv_instr::MULHU: begin
        if (snitch_pkg::XPULPIMG) begin
          dsp_valid_op = acc_qvalid_i;
          acc_qready_o = dsp_ready_op;
        end else begin
          mul_valid_op = acc_qvalid_i;
          acc_qready_o = mul_ready_op;
        end
      end
      riscv_instr::DIV,
      riscv_instr::DIVU,
      riscv_instr::REM,
      riscv_instr::REMU: begin
        div_valid_op = acc_qvalid_i;
        acc_qready_o = div_ready_op;
      end
      riscv_instr::P_ABS,                 // Xpulpimg: p.abs
      riscv_instr::P_SLET,                // Xpulpimg: p.slet
      riscv_instr::P_SLETU,               // Xpulpimg: p.sletu
      riscv_instr::P_MIN,                 // Xpulpimg: p.min
      riscv_instr::P_MINU,                // Xpulpimg: p.minu
      riscv_instr::P_MAX,                 // Xpulpimg: p.max
      riscv_instr::P_MAXU,                // Xpulpimg: p.maxu
      riscv_instr::P_EXTHS,               // Xpulpimg: p.exths
      riscv_instr::P_EXTHZ,               // Xpulpimg: p.exthz
      riscv_instr::P_EXTBS,               // Xpulpimg: p.extbs
      riscv_instr::P_EXTBZ,               // Xpulpimg: p.extbz
      riscv_instr::P_CLIP,                // Xpulpimg: p.clip
      riscv_instr::P_CLIPU,               // Xpulpimg: p.clipu
      riscv_instr::P_CLIPR,               // Xpulpimg: p.clipr
      riscv_instr::P_CLIPUR,              // Xpulpimg: p.clipur
      riscv_instr::P_MAC,                 // Xpulpimg: p.mac
      riscv_instr::P_MSU,                 // Xpulpimg: p.msu
      riscv_instr::PV_ADD_H,              // Xpulpimg: pv.add.h
      riscv_instr::PV_ADD_SC_H,           // Xpulpimg: pv.add.sc.h
      riscv_instr::PV_ADD_SCI_H,          // Xpulpimg: pv.add.sci.h
      riscv_instr::PV_ADD_B,              // Xpulpimg: pv.add.b
      riscv_instr::PV_ADD_SC_B,           // Xpulpimg: pv.add.sc.b
      riscv_instr::PV_ADD_SCI_B,          // Xpulpimg: pv.add.sci.b
      riscv_instr::PV_SUB_H,              // Xpulpimg: pv.sub.h
      riscv_instr::PV_SUB_SC_H,           // Xpulpimg: pv.sub.sc.h
      riscv_instr::PV_SUB_SCI_H,          // Xpulpimg: pv.sub.sci.h
      riscv_instr::PV_SUB_B,              // Xpulpimg: pv.sub.b
      riscv_instr::PV_SUB_SC_B,           // Xpulpimg: pv.sub.sc.b
      riscv_instr::PV_SUB_SCI_B,          // Xpulpimg: pv.sub.sci.b
      riscv_instr::PV_AVG_H,              // Xpulpimg: pv.avg.h
      riscv_instr::PV_AVG_SC_H,           // Xpulpimg: pv.avg.sc.h
      riscv_instr::PV_AVG_SCI_H,          // Xpulpimg: pv.avg.sci.h
      riscv_instr::PV_AVG_B,              // Xpulpimg: pv.avg.b
      riscv_instr::PV_AVG_SC_B,           // Xpulpimg: pv.avg.sc.b
      riscv_instr::PV_AVG_SCI_B,          // Xpulpimg: pv.avg.sci.b
      riscv_instr::PV_AVGU_H,             // Xpulpimg: pv.avgu.h
      riscv_instr::PV_AVGU_SC_H,          // Xpulpimg: pv.avgu.sc.h
      riscv_instr::PV_AVGU_SCI_H,         // Xpulpimg: pv.avgu.sci.h
      riscv_instr::PV_AVGU_B,             // Xpulpimg: pv.avgu.b
      riscv_instr::PV_AVGU_SC_B,          // Xpulpimg: pv.avgu.sc.b
      riscv_instr::PV_AVGU_SCI_B,         // Xpulpimg: pv.avgu.sci.b
      riscv_instr::PV_MIN_H,              // Xpulpimg: pv.min.h
      riscv_instr::PV_MIN_SC_H,           // Xpulpimg: pv.min.sc.h
      riscv_instr::PV_MIN_SCI_H,          // Xpulpimg: pv.min.sci.h
      riscv_instr::PV_MIN_B,              // Xpulpimg: pv.min.b
      riscv_instr::PV_MIN_SC_B,           // Xpulpimg: pv.min.sc.b
      riscv_instr::PV_MIN_SCI_B,          // Xpulpimg: pv.min.sci.b
      riscv_instr::PV_MINU_H,             // Xpulpimg: pv.minu.h
      riscv_instr::PV_MINU_SC_H,          // Xpulpimg: pv.minu.sc.h
      riscv_instr::PV_MINU_SCI_H,         // Xpulpimg: pv.minu.sci.h
      riscv_instr::PV_MINU_B,             // Xpulpimg: pv.minu.b
      riscv_instr::PV_MINU_SC_B,          // Xpulpimg: pv.minu.sc.b
      riscv_instr::PV_MINU_SCI_B,         // Xpulpimg: pv.minu.sci.b
      riscv_instr::PV_MAX_H,              // Xpulpimg: pv.max.h
      riscv_instr::PV_MAX_SC_H,           // Xpulpimg: pv.max.sc.h
      riscv_instr::PV_MAX_SCI_H,          // Xpulpimg: pv.max.sci.h
      riscv_instr::PV_MAX_B,              // Xpulpimg: pv.max.b
      riscv_instr::PV_MAX_SC_B,           // Xpulpimg: pv.max.sc.b
      riscv_instr::PV_MAX_SCI_B,          // Xpulpimg: pv.max.sci.b
      riscv_instr::PV_MAXU_H,             // Xpulpimg: pv.maxu.h
      riscv_instr::PV_MAXU_SC_H,          // Xpulpimg: pv.maxu.sc.h
      riscv_instr::PV_MAXU_SCI_H,         // Xpulpimg: pv.maxu.sci.h
      riscv_instr::PV_MAXU_B,             // Xpulpimg: pv.maxu.b
      riscv_instr::PV_MAXU_SC_B,          // Xpulpimg: pv.maxu.sc.b
      riscv_instr::PV_MAXU_SCI_B,         // Xpulpimg: pv.maxu.sci.b
      riscv_instr::PV_SRL_H,              // Xpulpimg: pv.srl.h
      riscv_instr::PV_SRL_SC_H,           // Xpulpimg: pv.srl.sc.h
      riscv_instr::PV_SRL_SCI_H,          // Xpulpimg: pv.srl.sci.h
      riscv_instr::PV_SRL_B,              // Xpulpimg: pv.srl.b
      riscv_instr::PV_SRL_SC_B,           // Xpulpimg: pv.srl.sc.b
      riscv_instr::PV_SRL_SCI_B,          // Xpulpimg: pv.srl.sci.b
      riscv_instr::PV_SRA_H,              // Xpulpimg: pv.sra.h
      riscv_instr::PV_SRA_SC_H,           // Xpulpimg: pv.sra.sc.h
      riscv_instr::PV_SRA_SCI_H,          // Xpulpimg: pv.sra.sci.h
      riscv_instr::PV_SRA_B,              // Xpulpimg: pv.sra.b
      riscv_instr::PV_SRA_SC_B,           // Xpulpimg: pv.sra.sc.b
      riscv_instr::PV_SRA_SCI_B,          // Xpulpimg: pv.sra.sci.b
      riscv_instr::PV_SLL_H,              // Xpulpimg: pv.sll.h
      riscv_instr::PV_SLL_SC_H,           // Xpulpimg: pv.sll.sc.h
      riscv_instr::PV_SLL_SCI_H,          // Xpulpimg: pv.sll.sci.h
      riscv_instr::PV_SLL_B,              // Xpulpimg: pv.sll.b
      riscv_instr::PV_SLL_SC_B,           // Xpulpimg: pv.sll.sc.b
      riscv_instr::PV_SLL_SCI_B,          // Xpulpimg: pv.sll.sci.b
      riscv_instr::PV_OR_H,               // Xpulpimg: pv.or.h
      riscv_instr::PV_OR_SC_H,            // Xpulpimg: pv.or.sc.h
      riscv_instr::PV_OR_SCI_H,           // Xpulpimg: pv.or.sci.h
      riscv_instr::PV_OR_B,               // Xpulpimg: pv.or.b
      riscv_instr::PV_OR_SC_B,            // Xpulpimg: pv.or.sc.b
      riscv_instr::PV_OR_SCI_B,           // Xpulpimg: pv.or.sci.b
      riscv_instr::PV_XOR_H,              // Xpulpimg: pv.xor.h
      riscv_instr::PV_XOR_SC_H,           // Xpulpimg: pv.xor.sc.h
      riscv_instr::PV_XOR_SCI_H,          // Xpulpimg: pv.xor.sci.h
      riscv_instr::PV_XOR_B,              // Xpulpimg: pv.xor.b
      riscv_instr::PV_XOR_SC_B,           // Xpulpimg: pv.xor.sc.b
      riscv_instr::PV_XOR_SCI_B,          // Xpulpimg: pv.xor.sci.b
      riscv_instr::PV_AND_H,              // Xpulpimg: pv.and.h
      riscv_instr::PV_AND_SC_H,           // Xpulpimg: pv.and.sc.h
      riscv_instr::PV_AND_SCI_H,          // Xpulpimg: pv.and.sci.h
      riscv_instr::PV_AND_B,              // Xpulpimg: pv.and.b
      riscv_instr::PV_AND_SC_B,           // Xpulpimg: pv.and.sc.b
      riscv_instr::PV_AND_SCI_B,          // Xpulpimg: pv.and.sci.b
      riscv_instr::PV_ABS_H,              // Xpulpimg: pv.abs.h
      riscv_instr::PV_ABS_B,              // Xpulpimg: pv.abs.b
      riscv_instr::PV_EXTRACT_H,          // Xpulpimg: pv.extract.h
      riscv_instr::PV_EXTRACT_B,          // Xpulpimg: pv.extract.b
      riscv_instr::PV_EXTRACTU_H,         // Xpulpimg: pv.extractu.h
      riscv_instr::PV_EXTRACTU_B,         // Xpulpimg: pv.extractu.b
      riscv_instr::PV_INSERT_H,           // Xpulpimg: pv.insert.h
      riscv_instr::PV_INSERT_B,           // Xpulpimg: pv.insert.b
      riscv_instr::PV_DOTUP_H,            // Xpulpimg: pv.dotup.h
      riscv_instr::PV_DOTUP_SC_H,         // Xpulpimg: pv.dotup.sc.h
      riscv_instr::PV_DOTUP_SCI_H,        // Xpulpimg: pv.dotup.sci.h
      riscv_instr::PV_DOTUP_B,            // Xpulpimg: pv.dotup.b
      riscv_instr::PV_DOTUP_SC_B,         // Xpulpimg: pv.dotup.sc.b
      riscv_instr::PV_DOTUP_SCI_B,        // Xpulpimg: pv.dotup.sci.b
      riscv_instr::PV_DOTUSP_H,           // Xpulpimg: pv.dotusp.h
      riscv_instr::PV_DOTUSP_SC_H,        // Xpulpimg: pv.dotusp.sc.h
      riscv_instr::PV_DOTUSP_SCI_H,       // Xpulpimg: pv.dotusp.sci.h
      riscv_instr::PV_DOTUSP_B,           // Xpulpimg: pv.dotusp.b
      riscv_instr::PV_DOTUSP_SC_B,        // Xpulpimg: pv.dotusp.sc.b
      riscv_instr::PV_DOTUSP_SCI_B,       // Xpulpimg: pv.dotusp.sci.b
      riscv_instr::PV_DOTSP_H,            // Xpulpimg: pv.dotsp.h
      riscv_instr::PV_DOTSP_SC_H,         // Xpulpimg: pv.dotsp.sc.h
      riscv_instr::PV_DOTSP_SCI_H,        // Xpulpimg: pv.dotsp.sci.h
      riscv_instr::PV_DOTSP_B,            // Xpulpimg: pv.dotsp.b
      riscv_instr::PV_DOTSP_SC_B,         // Xpulpimg: pv.dotsp.sc.b
      riscv_instr::PV_DOTSP_SCI_B,        // Xpulpimg: pv.dotsp.sci.b
      riscv_instr::PV_SDOTUP_H,           // Xpulpimg: pv.sdotup.h
      riscv_instr::PV_SDOTUP_SC_H,        // Xpulpimg: pv.sdotup.sc.h
      riscv_instr::PV_SDOTUP_SCI_H,       // Xpulpimg: pv.sdotup.sci.h
      riscv_instr::PV_SDOTUP_B,           // Xpulpimg: pv.sdotup.b
      riscv_instr::PV_SDOTUP_SC_B,        // Xpulpimg: pv.sdotup.sc.b
      riscv_instr::PV_SDOTUP_SCI_B,       // Xpulpimg: pv.sdotup.sci.b
      riscv_instr::PV_SDOTUSP_H,          // Xpulpimg: pv.sdotusp.h
      riscv_instr::PV_SDOTUSP_SC_H,       // Xpulpimg: pv.sdotusp.sc.h
      riscv_instr::PV_SDOTUSP_SCI_H,      // Xpulpimg: pv.sdotusp.sci.h
      riscv_instr::PV_SDOTUSP_B,          // Xpulpimg: pv.sdotusp.b
      riscv_instr::PV_SDOTUSP_SC_B,       // Xpulpimg: pv.sdotusp.sc.b
      riscv_instr::PV_SDOTUSP_SCI_B,      // Xpulpimg: pv.sdotusp.sci.b
      riscv_instr::PV_SDOTSP_H,           // Xpulpimg: pv.sdotsp.h
      riscv_instr::PV_SDOTSP_SC_H,        // Xpulpimg: pv.sdotsp.sc.h
      riscv_instr::PV_SDOTSP_SCI_H,       // Xpulpimg: pv.sdotsp.sci.h
      riscv_instr::PV_SDOTSP_B,           // Xpulpimg: pv.sdotsp.b
      riscv_instr::PV_SDOTSP_SC_B,        // Xpulpimg: pv.sdotsp.sc.b
      riscv_instr::PV_SDOTSP_SCI_B,       // Xpulpimg: pv.sdotsp.sci.b
      riscv_instr::PV_SHUFFLE2_H,         // Xpulpimg: pv.shuffle2.h
      riscv_instr::PV_SHUFFLE2_B: begin   // Xpulpimg: pv.shuffle2.b
        if (snitch_pkg::XPULPIMG) begin
          dsp_valid_op = acc_qvalid_i;
          acc_qready_o = dsp_ready_op;
        end else begin
          illegal_instruction = 1'b1;
        end
      end
      default: illegal_instruction = 1'b1;
    endcase
  end

  // Serial Divider
  serdiv #(
      .WIDTH       ( 32      ),
      .IdWidth     ( IdWidth )
  ) i_div (
      .clk_i       ( clk_i                ),
      .rst_ni      ( ~rst_i               ),
      .id_i        ( acc_qid_i              ),
      .operator_i  ( acc_qdata_op_i         ),
      .op_a_i      ( acc_qdata_arga_i       ),
      .op_b_i      ( acc_qdata_argb_i       ),
      .in_vld_i    ( div_valid_op           ),
      .in_rdy_o    ( div_ready_op           ),
      .out_vld_o   ( div_valid              ),
      .out_rdy_i   ( div_ready              ),
      .id_o        ( div.id                 ),
      .res_o       ( div.result             )
  );

  if (snitch_pkg::XPULPIMG) begin : gen_xpulpimg
    // DSP Unit
    dspu #(
        .Width    ( 32      ),
        .IdWidth  ( IdWidth )
    ) i_dspu (
        .clk_i       ( clk_i                ),
        .rst_i       ( rst_i                ),
        .id_i        ( acc_qid_i            ),
        .operator_i  ( acc_qdata_op_i       ),
        .op_a_i      ( acc_qdata_arga_i     ),
        .op_b_i      ( acc_qdata_argb_i     ),
        .op_c_i      ( acc_qdata_argc_i     ),
        .in_valid_i  ( dsp_valid_op         ),
        .in_ready_o  ( dsp_ready_op         ),
        .out_valid_o ( dsp_valid            ),
        .out_ready_i ( dsp_ready            ),
        .id_o        ( dsp.id               ),
        .result_o    ( dsp.result           )
    );
    // Output Arbitration
    stream_arbiter #(
      .DATA_T ( result_t ),
      .N_INP  ( 2        )
    ) i_stream_arbiter (
      .clk_i,
      .rst_ni      ( ~rst_i                 ),
      .inp_data_i  ( {div, dsp}             ),
      .inp_valid_i ( {div_valid, dsp_valid} ),
      .inp_ready_o ( {div_ready, dsp_ready} ),
      .oup_data_o  ( oup                    ),
      .oup_valid_o ( acc_pvalid_o           ),
      .oup_ready_i ( acc_pready_i           )
    );
  end else begin : gen_vanilla
    // Multiplication
    multiplier #(
      .Width    ( 32      ),
      .IdWidth  ( IdWidth )
    ) i_multiplier (
      .clk_i,
      .rst_i,
      .id_i        ( acc_qid_i              ),
      .operator_i  ( acc_qdata_op_i         ),
      .operand_a_i ( acc_qdata_arga_i       ),
      .operand_b_i ( acc_qdata_argb_i       ),
      .valid_i     ( mul_valid_op           ),
      .ready_o     ( mul_ready_op           ),
      .result_o    ( mul.result             ),
      .valid_o     ( mul_valid              ),
      .ready_i     ( mul_ready              ),
      .id_o        ( mul.id                 )
    );
    // Output Arbitration
    stream_arbiter #(
      .DATA_T ( result_t ),
      .N_INP  ( 2        )
    ) i_stream_arbiter (
      .clk_i,
      .rst_ni      ( ~rst_i                 ),
      .inp_data_i  ( {div, mul}             ),
      .inp_valid_i ( {div_valid, mul_valid} ),
      .inp_ready_o ( {div_ready, mul_ready} ),
      .oup_data_o  ( oup                    ),
      .oup_valid_o ( acc_pvalid_o           ),
      .oup_ready_i ( acc_pready_i           )
    );
  end

  assign acc_pdata_o = oup.result;
  assign acc_pid_o = oup.id;
endmodule


module dspu #(
  parameter int unsigned Width = 32,
  parameter int unsigned IdWidth = 5
) (
    input  logic               clk_i,      // unused
    input  logic               rst_i,      // unused
    input  logic [IdWidth-1:0] id_i,
    input  logic [31:0]        operator_i,
    input  logic [Width-1:0]   op_a_i,
    input  logic [Width-1:0]   op_b_i,
    input  logic [Width-1:0]   op_c_i,
    input  logic               in_valid_i,
    output logic               in_ready_o,
    output logic               out_valid_o,
    input  logic               out_ready_i,
    output logic [IdWidth-1:0] id_o,
    output logic [Width-1:0]   result_o
);

  // Control signals
  assign out_valid_o = in_valid_i;
  assign in_ready_o = out_ready_i;
  assign id_o = id_i;

  // Decoded fields
  logic [4:0] imm5;
  logic [5:0] imm6;
  assign imm5 = operator_i[24:20];
  assign imm6 = {operator_i[24:20], operator_i[25]};

  // Internal control signals
  logic cmp_signed;            // comparator operation is signed
  enum logic [1:0] {
    None, Reg, Zero, ClipBound
  } cmp_op_b_sel;              // selection of shared comparator operands
  logic clip_unsigned;         // clip operation has "0" as lower bound
  logic clip_register;         // if 1 clip operation uses rs2, else imm5
  enum logic [1:0] {
    NoMul, MulLow, MulHigh, MulMac
  } mul_op;                    // type of multiplication operation
  logic mac_msu;               // multiplication operation is MSU
  logic mul_op_a_sign;         // sign of multiplier operand a
  logic mac_op_b_sign;         // sign of multiplier operand b
  enum logic [3:0] {
    Nop, Abs, Sle, Min, Max, Exths, Exthz, Extbs, Extbz, Clip, Mac, Simd
  } res_sel;                   // result selection

  enum logic [4:0] {
    SimdNop, SimdAdd, SimdSub, SimdAvg, SimdMin, SimdMax, SimdSrl, SimdSra, SimdSll, SimdOr,
    SimdXor, SimdAnd, SimdAbs, SimdExt, SimdIns, SimdDotp, SimdShuffle
  } simd_op;                   // SIMD operation
  enum logic {
    HalfWord, Byte
  } simd_size;                 // SIMD granularity
  enum logic [1:0] {
    Vect, Sc, Sci
  } simd_mode;                 // SIMD mode
  logic simd_signed;           // SIMD operation is signed and uses sign-extended imm6
  logic simd_dotp_op_a_signed; // signedness of SIMD dotp operand a
  logic simd_dotp_op_b_signed; // signedness of SIMD dotp operand b
  logic simd_dotp_acc;         // accumulate result of SIMD dotp on destination reg

  // --------------------
  // Decoder
  // --------------------

  always_comb begin
    cmp_signed = 1'b1;
    cmp_op_b_sel = None;
    clip_unsigned = 1'b0;
    clip_register = 1'b0;
    mul_op = NoMul;
    mac_msu = 1'b0;
    mul_op_a_sign = 1'b0;
    mac_op_b_sign = 1'b0;
    res_sel = Nop;
    simd_op = SimdNop;
    simd_size = HalfWord;
    simd_mode = Vect;
    simd_signed = 1;
    simd_dotp_op_a_signed = 1;
    simd_dotp_op_b_signed = 1;
    simd_dotp_acc = 0;
    unique casez (operator_i)
      // Multiplications from M extension
      riscv_instr::MUL: begin
        mul_op = MulLow;
        mul_op_a_sign = 1'b1;
        mac_op_b_sign = 1'b1;
        res_sel = Mac;
      end
      riscv_instr::MULH: begin
        mul_op = MulHigh;
        mul_op_a_sign = 1'b1;
        mac_op_b_sign = 1'b1;
        res_sel = Mac;
      end
      riscv_instr::MULHSU: begin
        mul_op = MulHigh;
        mul_op_a_sign = 1'b1;
        res_sel = Mac;
      end
      riscv_instr::MULHU: begin
        mul_op = MulHigh;
        res_sel = Mac;
      end
      // Instructions from Xpulpimg
      riscv_instr::P_ABS: begin
        cmp_op_b_sel = Zero;
        res_sel = Abs;
      end
      riscv_instr::P_SLET: begin
        cmp_op_b_sel = Reg;
        res_sel = Sle;
      end
      riscv_instr::P_SLETU: begin
        cmp_signed = 1'b0;
        cmp_op_b_sel = Reg;
        res_sel = Sle;
      end
      riscv_instr::P_MIN: begin
        cmp_op_b_sel = Reg;
        res_sel = Min;
      end
      riscv_instr::P_MINU: begin
        cmp_signed = 1'b0;
        cmp_op_b_sel = Reg;
        res_sel = Min;
      end
      riscv_instr::P_MAX: begin
        cmp_op_b_sel = Reg;
        res_sel = Max;
      end
      riscv_instr::P_MAXU: begin
        cmp_signed = 1'b0;
        cmp_op_b_sel = Reg;
        res_sel = Max;
      end
      riscv_instr::P_EXTHS: begin
        cmp_op_b_sel = Reg;
        res_sel = Exths;
      end
      riscv_instr::P_EXTHZ: begin
        cmp_op_b_sel = Reg;
        res_sel = Exthz;
      end
      riscv_instr::P_EXTBS: begin
        cmp_op_b_sel = Reg;
        res_sel = Extbs;
      end
      riscv_instr::P_EXTBZ: begin
        cmp_op_b_sel = Reg;
        res_sel = Extbz;
      end
      riscv_instr::P_CLIP: begin
        cmp_op_b_sel = ClipBound;
        res_sel = Clip;
      end
      riscv_instr::P_CLIPU: begin
        clip_unsigned = 1'b1;
        cmp_op_b_sel = ClipBound;
        res_sel = Clip;
      end
      riscv_instr::P_CLIPR: begin
        clip_register = 1'b1;
        cmp_op_b_sel = ClipBound;
        res_sel = Clip;
      end
      riscv_instr::P_CLIPUR: begin
        clip_unsigned = 1'b1;
        clip_register = 1'b1;
        cmp_op_b_sel = ClipBound;
        res_sel = Clip;
      end
      riscv_instr::P_MAC: begin
        mul_op = MulMac;
        mul_op_a_sign = 1'b1;
        mac_op_b_sign = 1'b1;
        res_sel = Mac;
      end
      riscv_instr::P_MSU: begin
        mul_op = MulMac;
        mac_msu = 1'b1;
        mul_op_a_sign = 1'b1;
        mac_op_b_sign = 1'b1;
        res_sel = Mac;
      end
      riscv_instr::PV_ADD_H: begin
        simd_op = SimdAdd;
        res_sel = Simd;
      end
      riscv_instr::PV_ADD_SC_H: begin
        simd_op = SimdAdd;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_ADD_SCI_H: begin
        simd_op = SimdAdd;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_ADD_B: begin
        simd_op = SimdAdd;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_ADD_SC_B: begin
        simd_op = SimdAdd;
        simd_size = Byte;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_ADD_SCI_B: begin
        simd_op = SimdAdd;
        simd_size = Byte;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_SUB_H: begin
        simd_op = SimdSub;
        res_sel = Simd;
      end
      riscv_instr::PV_SUB_SC_H: begin
        simd_op = SimdSub;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_SUB_SCI_H: begin
        simd_op = SimdSub;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_SUB_B: begin
        simd_op = SimdSub;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_SUB_SC_B: begin
        simd_op = SimdSub;
        simd_size = Byte;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_SUB_SCI_B: begin
        simd_op = SimdSub;
        simd_size = Byte;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_AVG_H: begin
        simd_op = SimdAvg;
        res_sel = Simd;
      end
      riscv_instr::PV_AVG_SC_H: begin
        simd_op = SimdAvg;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_AVG_SCI_H: begin
        simd_op = SimdAvg;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_AVG_B: begin
        simd_op = SimdAvg;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_AVG_SC_B: begin
        simd_op = SimdAvg;
        simd_size = Byte;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_AVG_SCI_B: begin
        simd_op = SimdAvg;
        simd_size = Byte;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_AVGU_H: begin
        simd_op = SimdAvg;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_AVGU_SC_H: begin
        simd_op = SimdAvg;
        simd_mode = Sc;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_AVGU_SCI_H: begin
        simd_op = SimdAvg;
        simd_mode = Sci;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_AVGU_B: begin
        simd_op = SimdAvg;
        simd_size = Byte;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_AVGU_SC_B: begin
        simd_op = SimdAvg;
        simd_size = Byte;
        simd_mode = Sc;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_AVGU_SCI_B: begin
        simd_op = SimdAvg;
        simd_size = Byte;
        simd_mode = Sci;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_MIN_H: begin
        simd_op = SimdMin;
        res_sel = Simd;
      end
      riscv_instr::PV_MIN_SC_H: begin
        simd_op = SimdMin;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_MIN_SCI_H: begin
        simd_op = SimdMin;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_MIN_B: begin
        simd_op = SimdMin;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_MIN_SC_B: begin
        simd_op = SimdMin;
        simd_size = Byte;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_MIN_SCI_B: begin
        simd_op = SimdMin;
        simd_size = Byte;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_MINU_H: begin
        simd_op = SimdMin;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_MINU_SC_H: begin
        simd_op = SimdMin;
        simd_mode = Sc;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_MINU_SCI_H: begin
        simd_op = SimdMin;
        simd_mode = Sci;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_MINU_B: begin
        simd_op = SimdMin;
        simd_size = Byte;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_MINU_SC_B: begin
        simd_op = SimdMin;
        simd_size = Byte;
        simd_mode = Sc;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_MINU_SCI_B: begin
        simd_op = SimdMin;
        simd_size = Byte;
        simd_mode = Sci;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_MAX_H: begin
        simd_op = SimdMax;
        res_sel = Simd;
      end
      riscv_instr::PV_MAX_SC_H: begin
        simd_op = SimdMax;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_MAX_SCI_H: begin
        simd_op = SimdMax;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_MAX_B: begin
        simd_op = SimdMax;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_MAX_SC_B: begin
        simd_op = SimdMax;
        simd_size = Byte;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_MAX_SCI_B: begin
        simd_op = SimdMax;
        simd_size = Byte;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_MAXU_H: begin
        simd_op = SimdMax;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_MAXU_SC_H: begin
        simd_op = SimdMax;
        simd_mode = Sc;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_MAXU_SCI_H: begin
        simd_op = SimdMax;
        simd_mode = Sci;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_MAXU_B: begin
        simd_op = SimdMax;
        simd_size = Byte;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_MAXU_SC_B: begin
        simd_op = SimdMax;
        simd_size = Byte;
        simd_mode = Sc;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_MAXU_SCI_B: begin
        simd_op = SimdMax;
        simd_size = Byte;
        simd_mode = Sci;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_SRL_H: begin
        simd_op = SimdSrl;
        res_sel = Simd;
      end
      riscv_instr::PV_SRL_SC_H: begin
        simd_op = SimdSrl;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_SRL_SCI_H: begin
        simd_op = SimdSrl;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_SRL_B: begin
        simd_op = SimdSrl;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_SRL_SC_B: begin
        simd_op = SimdSrl;
        simd_size = Byte;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_SRL_SCI_B: begin
        simd_op = SimdSrl;
        simd_size = Byte;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_SRA_H: begin
        simd_op = SimdSra;
        res_sel = Simd;
      end
      riscv_instr::PV_SRA_SC_H: begin
        simd_op = SimdSra;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_SRA_SCI_H: begin
        simd_op = SimdSra;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_SRA_B: begin
        simd_op = SimdSra;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_SRA_SC_B: begin
        simd_op = SimdSra;
        simd_size = Byte;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_SRA_SCI_B: begin
        simd_op = SimdSra;
        simd_size = Byte;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_SLL_H: begin
        simd_op = SimdSll;
        res_sel = Simd;
      end
      riscv_instr::PV_SLL_SC_H: begin
        simd_op = SimdSll;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_SLL_SCI_H: begin
        simd_op = SimdSll;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_SLL_B: begin
        simd_op = SimdSll;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_SLL_SC_B: begin
        simd_op = SimdSll;
        simd_size = Byte;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_SLL_SCI_B: begin
        simd_op = SimdSll;
        simd_size = Byte;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_OR_H: begin
        simd_op = SimdOr;
        res_sel = Simd;
      end
      riscv_instr::PV_OR_SC_H: begin
        simd_op = SimdOr;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_OR_SCI_H: begin
        simd_op = SimdOr;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_OR_B: begin
        simd_op = SimdOr;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_OR_SC_B: begin
        simd_op = SimdOr;
        simd_size = Byte;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_OR_SCI_B: begin
        simd_op = SimdOr;
        simd_size = Byte;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_XOR_H: begin
        simd_op = SimdXor;
        res_sel = Simd;
      end
      riscv_instr::PV_XOR_SC_H: begin
        simd_op = SimdXor;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_XOR_SCI_H: begin
        simd_op = SimdXor;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_XOR_B: begin
        simd_op = SimdXor;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_XOR_SC_B: begin
        simd_op = SimdXor;
        simd_size = Byte;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_XOR_SCI_B: begin
        simd_op = SimdXor;
        simd_size = Byte;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_AND_H: begin
        simd_op = SimdAnd;
        res_sel = Simd;
      end
      riscv_instr::PV_AND_SC_H: begin
        simd_op = SimdAnd;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_AND_SCI_H: begin
        simd_op = SimdAnd;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_AND_B: begin
        simd_op = SimdAnd;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_AND_SC_B: begin
        simd_op = SimdAnd;
        simd_size = Byte;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_AND_SCI_B: begin
        simd_op = SimdAnd;
        simd_size = Byte;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_ABS_H: begin
        simd_op = SimdAbs;
        res_sel = Simd;
      end
      riscv_instr::PV_ABS_B: begin
        simd_op = SimdAbs;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_EXTRACT_H: begin
        simd_op = SimdExt;
        res_sel = Simd;
      end
      riscv_instr::PV_EXTRACT_B: begin
        simd_op = SimdExt;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_EXTRACTU_H: begin
        simd_op = SimdExt;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_EXTRACTU_B: begin
        simd_op = SimdExt;
        simd_size = Byte;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_INSERT_H: begin
        simd_op = SimdIns;
        res_sel = Simd;
      end
      riscv_instr::PV_INSERT_B: begin
        simd_op = SimdIns;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTUP_H: begin
        simd_op = SimdDotp;
        simd_signed = 0;
        simd_dotp_op_a_signed = 0;
        simd_dotp_op_b_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTUP_SC_H: begin
        simd_op = SimdDotp;
        simd_mode = Sc;
        simd_signed = 0;
        simd_dotp_op_a_signed = 0;
        simd_dotp_op_b_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTUP_SCI_H: begin
        simd_op = SimdDotp;
        simd_mode = Sci;
        simd_signed = 0;
        simd_dotp_op_a_signed = 0;
        simd_dotp_op_b_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTUP_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_signed = 0;
        simd_dotp_op_a_signed = 0;
        simd_dotp_op_b_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTUP_SC_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_mode = Sc;
        simd_signed = 0;
        simd_dotp_op_a_signed = 0;
        simd_dotp_op_b_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTUP_SCI_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_mode = Sci;
        simd_signed = 0;
        simd_dotp_op_a_signed = 0;
        simd_dotp_op_b_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTUSP_H: begin
        simd_op = SimdDotp;
        simd_dotp_op_a_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTUSP_SC_H: begin
        simd_op = SimdDotp;
        simd_mode = Sc;
        simd_dotp_op_a_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTUSP_SCI_H: begin
        simd_op = SimdDotp;
        simd_mode = Sci;
        simd_dotp_op_a_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTUSP_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_dotp_op_a_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTUSP_SC_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_mode = Sc;
        simd_dotp_op_a_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTUSP_SCI_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_mode = Sci;
        simd_dotp_op_a_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTSP_H: begin
        simd_op = SimdDotp;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTSP_SC_H: begin
        simd_op = SimdDotp;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTSP_SCI_H: begin
        simd_op = SimdDotp;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTSP_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTSP_SC_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTSP_SCI_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTUP_H: begin
        simd_op = SimdDotp;
        simd_signed = 0;
        simd_dotp_op_a_signed = 0;
        simd_dotp_op_b_signed = 0;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTUP_SC_H: begin
        simd_op = SimdDotp;
        simd_mode = Sc;
        simd_signed = 0;
        simd_dotp_op_a_signed = 0;
        simd_dotp_op_b_signed = 0;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTUP_SCI_H: begin
        simd_op = SimdDotp;
        simd_mode = Sci;
        simd_signed = 0;
        simd_dotp_op_a_signed = 0;
        simd_dotp_op_b_signed = 0;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTUP_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_signed = 0;
        simd_dotp_op_a_signed = 0;
        simd_dotp_op_b_signed = 0;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTUP_SC_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_mode = Sc;
        simd_signed = 0;
        simd_dotp_op_a_signed = 0;
        simd_dotp_op_b_signed = 0;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTUP_SCI_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_mode = Sci;
        simd_signed = 0;
        simd_dotp_op_a_signed = 0;
        simd_dotp_op_b_signed = 0;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTUSP_H: begin
        simd_op = SimdDotp;
        simd_dotp_op_a_signed = 0;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTUSP_SC_H: begin
        simd_op = SimdDotp;
        simd_mode = Sc;
        simd_dotp_op_a_signed = 0;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTUSP_SCI_H: begin
        simd_op = SimdDotp;
        simd_mode = Sci;
        simd_dotp_op_a_signed = 0;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTUSP_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_dotp_op_a_signed = 0;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTUSP_SC_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_mode = Sc;
        simd_dotp_op_a_signed = 0;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTUSP_SCI_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_mode = Sci;
        simd_dotp_op_a_signed = 0;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTSP_H: begin
        simd_op = SimdDotp;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTSP_SC_H: begin
        simd_op = SimdDotp;
        simd_mode = Sc;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTSP_SCI_H: begin
        simd_op = SimdDotp;
        simd_mode = Sci;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTSP_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTSP_SC_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_mode = Sc;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTSP_SCI_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_mode = Sci;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SHUFFLE2_H: begin
        simd_op = SimdShuffle;
        res_sel = Simd;
      end
      riscv_instr::PV_SHUFFLE2_B: begin
        simd_op = SimdShuffle;
        simd_size = Byte;
        res_sel = Simd;
      end
      default: ;
    endcase
  end

  //  ___    _  _____  _    ___   _  _____  _  _
  // |   \  /_\|_   _|/_\  | _ \ /_\|_   _|| || |
  // | |) |/ _ \ | | / _ \ |  _// _ \ | |  | __ |
  // |___//_/ \_\|_|/_/ \_\|_| /_/ \_\|_|  |_||_|
  //

  // --------------------
  // Clips
  // --------------------
  logic clip_use_n_bound;
  logic [Width-1:0] clip_op_b_n, clip_op_b; // clip lower and upper bounds
  logic [Width-1:0] clip_lower;
  logic [Width-1:0] clip_comp;

  // Generate -2^(imm5-1), 2^(imm5-1)-1 for clip/clipu and -rs2-1, rs2 for clipr, clipur
  assign clip_lower = ({(Width+1){1'b1}} << $unsigned(imm5)) >> 1;
  assign clip_op_b_n = clip_unsigned ? 'b0 : (clip_register ? ~op_b_i : clip_lower);
  assign clip_op_b = clip_register ? op_b_i : ~clip_lower;

  // is 1 when NOT(rs1 >= 0 AND clip_op_b >= 0), i.e. at least one operand is negative
  assign clip_use_n_bound = op_a_i[Width-1] | clip_op_b[Width-1];

  // Select operand to use in comparison for clip operations: clips would need two comparisons
  // to clamp the result between the two bounds; but one comparison is enough if we select the
  // second operand basing on op_a and clip_op_b signs (i.e. rs1 and clip upper bound, being
  // either rs2 or 2^(imm5-1)-1)
  assign clip_comp = clip_use_n_bound ? clip_op_b_n : clip_op_b;

  // --------------------
  // Shared comparator
  // --------------------
  logic [Width-1:0] cmp_op_a, cmp_op_b;
  logic cmp_result;

  // Comparator operand A assignment
  assign cmp_op_a = op_a_i;
  // Comparator operand B assignment
  always_comb begin
    unique case (cmp_op_b_sel)
      Reg: cmp_op_b = op_b_i;
      Zero: cmp_op_b = '0;
      ClipBound: cmp_op_b = clip_comp;
      default: cmp_op_b = '0;
    endcase
  end

  // Instantiate comparator
  assign cmp_result = $signed({cmp_op_a[Width-1] & cmp_signed, cmp_op_a}) <= $signed({cmp_op_b[Width-1] & cmp_signed, cmp_op_b});

  // --------------------
  // Multiplier & acc
  // --------------------

  // 32x32 into 32 bits multiplier & accumulator
  logic [Width-1:0] mul_op_a;
  logic [2*Width-1:0] mul_result;
  logic [Width-1:0] mac_result;

  assign mul_op_a = mac_msu ? -op_a_i : op_a_i; // op_a_i is sign-inverted if mac_msu=1, to have -op_a*op_b

  // 32-bits input, 64-bits output multiplier
  assign mul_result = $signed({mul_op_a[Width-1] & mul_op_a_sign, mul_op_a}) * $signed({op_b_i[Width-1] & mac_op_b_sign, op_b_i});

  always_comb begin
    unique case (mul_op)
      MulLow: mac_result = mul_result[Width-1:0]; // mul, take lowest 32 bits
      MulHigh: mac_result = mul_result[2*Width-1:Width]; // mul high, take highest 32 bits
      MulMac: mac_result = op_c_i + mul_result[Width-1:0]; // accumulate
      default: mac_result = '0;
    endcase
  end

  // --------------------
  // SIMD operations
  // --------------------

  logic [3:0][7:0] simd_op_a, simd_op_b, simd_op_c;
  logic [1:0][7:0] simd_imm;
  logic [3:0][7:0] simd_result;

  // half-word and byte immediate extensions
  always_comb
    if(simd_signed) simd_imm = $signed(imm6);
    else simd_imm = $unsigned(imm6);

  // SIMD operands composition
  always_comb begin
    simd_op_a = 'b0;
    simd_op_b = 'b0;
    simd_op_c = 'b0;
    unique case (simd_size)
      // half-word granularity
      HalfWord:
        for (int i = 0; i < Width/16; i++) begin
          simd_op_a[2*i +: 2] = op_a_i[16*i +: 16]; // operands A are the half-words of op_a_i
          // operands B are the half-words of op_b_i, replicated lowest half-word of op_b_i or replicated 6-bit immediate
          simd_op_b[2*i +: 2] = (simd_mode == Vect) ? op_b_i[16*i +: 16] : ((simd_mode == Sc) ? op_b_i[15:0] : simd_imm);
          simd_op_c[2*i +: 2] = op_c_i[16*i +: 16]; // operands C are the half-words of op_c_i
        end
      // byte granularity
      Byte:
        for (int i = 0; i < Width/8; i++) begin
          simd_op_a[i] = op_a_i[8*i +: 8]; // operands A are the bytes of op_a_i
          // operands B are the bytes of op_b_i, replicated lowest byte of op_b_i or replicated 6-bit immediate
          simd_op_b[i] = (simd_mode == Vect) ? op_b_i[8*i +: 8] : ((simd_mode == Sc) ? op_b_i[7:0] : simd_imm[0]);
          simd_op_c[i] = op_c_i[8*i +: 8]; // operands C are the bytes of op_c_i
        end
      default: ;
    endcase
  end

  // SIMD unit
  always_comb begin
    simd_result = 'b0;
    unique case (simd_size)
      // half-word granularity
      HalfWord: begin
        unique case (simd_op)
          SimdAdd:
            for (int i = 0; i < Width/16; i++)
              simd_result[2*i +: 2] = $signed(simd_op_a[2*i +: 2]) + $signed(simd_op_b[2*i +: 2]);
          SimdSub:
            for (int i = 0; i < Width/16; i++)
              simd_result[2*i +: 2] = $signed(simd_op_a[2*i +: 2]) - $signed(simd_op_b[2*i +: 2]);
          SimdAvg:
            for (int i = 0; i < Width/16; i++) begin
              simd_result[2*i +: 2] = $signed(simd_op_a[2*i +: 2]) + $signed(simd_op_b[2*i +: 2]);
              simd_result[2*i +: 2] = {simd_result[2*i+1][7] & simd_signed, simd_result[2*i +: 2]} >> 1;
            end
          SimdMin:
            for (int i = 0; i < Width/16; i++)
              simd_result[2*i +: 2] = $signed({simd_op_a[2*i+1][7] & simd_signed, simd_op_a[2*i +: 2]}) <=
                                       $signed({simd_op_b[2*i+1][7] & simd_signed, simd_op_b[2*i +: 2]}) ?
                                       simd_op_a[2*i +: 2] : simd_op_b[2*i +: 2];
          SimdMax:
            for (int i = 0; i < Width/16; i++)
              simd_result[2*i +: 2] = $signed({simd_op_a[2*i+1][7] & simd_signed, simd_op_a[2*i +: 2]}) >
                                       $signed({simd_op_b[2*i+1][7] & simd_signed, simd_op_b[2*i +: 2]}) ?
                                       simd_op_a[2*i +: 2] : simd_op_b[2*i +: 2];
          SimdSrl:
            for (int i = 0; i < Width/16; i++)
              simd_result[2*i +: 2] = $unsigned(simd_op_a[2*i +: 2]) >> simd_op_b[2*i][3:0];
          SimdSra:
            for (int i = 0; i < Width/16; i++)
              simd_result[2*i +: 2] = $signed(simd_op_a[2*i +: 2]) >>> simd_op_b[2*i][3:0];
          SimdSll:
            for (int i = 0; i < Width/16; i++)
              simd_result[2*i +: 2] = $unsigned(simd_op_a[2*i +: 2]) << simd_op_b[2*i][3:0];
          SimdOr: simd_result = simd_op_a | simd_op_b;
          SimdXor: simd_result = simd_op_a ^ simd_op_b;
          SimdAnd: simd_result = simd_op_a & simd_op_b;
          SimdAbs:
            for (int i = 0; i < Width/16; i++)
              simd_result[2*i +: 2] = $signed(simd_op_a[2*i +: 2]) > 0 ? simd_op_a[2*i +: 2] : -$signed(simd_op_a[2*i +: 2]);
          SimdExt: begin
            simd_result[1:0] = simd_op_a[2*imm6[0] +: 2];
            // sign- or zero-extend
            simd_result[3:2] = {16{simd_op_a[2*imm6[0]+1][7] & simd_signed}};
          end
          SimdIns: begin
            simd_result = op_c_i;
            simd_result[2*imm6[0] +: 2] = simd_op_a[1:0];
          end
          SimdDotp: begin
            simd_result = op_c_i & {(Width){simd_dotp_acc}}; // accumulate on rd or start from zero
            for (int i = 0; i < Width/16; i++) begin
              simd_result = $signed(simd_result) + $signed({simd_op_a[2*i+1][7] & simd_dotp_op_a_signed, simd_op_a[2*i +: 2]}) *
                                                   $signed({simd_op_b[2*i+1][7] & simd_dotp_op_b_signed, simd_op_b[2*i +: 2]});
            end
          end
          SimdShuffle:
            for (int i = 0; i < Width/16; i++)
              simd_result[2*i +: 2] = simd_op_b[2*i][1] ? simd_op_a[2*simd_op_b[2*i][0] +: 2] : simd_op_c[2*simd_op_b[2*i][0] +: 2];
          default: ;
        endcase
      end
      // byte granularity
      Byte: begin
        unique case (simd_op)
          SimdAdd:
            for (int i = 0; i < Width/8; i++)
              simd_result[i] = $signed(simd_op_a[i]) + $signed(simd_op_b[i]);
          SimdSub:
            for (int i = 0; i < Width/8; i++)
              simd_result[i] = $signed(simd_op_a[i]) - $signed(simd_op_b[i]);
          SimdAvg:
            for (int i = 0; i < Width/8; i++) begin
              simd_result[i] = $signed(simd_op_a[i]) + $signed(simd_op_b[i]);
              simd_result[i] = {simd_result[i][7] & simd_signed, simd_result[i]} >> 1;
            end
          SimdMin:
            for (int i = 0; i < Width/8; i++)
              simd_result[i] = $signed({simd_op_a[i][7] & simd_signed, simd_op_a[i]}) <=
                               $signed({simd_op_b[i][7] & simd_signed, simd_op_b[i]}) ?
                               simd_op_a[i] : simd_op_b[i];
          SimdMax:
            for (int i = 0; i < Width/8; i++)
              simd_result[i] = $signed({simd_op_a[i][7] & simd_signed, simd_op_a[i]}) >
                               $signed({simd_op_b[i][7] & simd_signed, simd_op_b[i]}) ?
                               simd_op_a[i] : simd_op_b[i];
          SimdSrl:
            for (int i = 0; i < Width/8; i++)
              simd_result[i] = $unsigned(simd_op_a[i]) >> simd_op_b[i][2:0];
          SimdSra:
            for (int i = 0; i < Width/8; i++)
              simd_result[i] = $signed(simd_op_a[i]) >>> simd_op_b[i][2:0];
          SimdSll:
            for (int i = 0; i < Width/8; i++)
              simd_result[i] = $unsigned(simd_op_a[i]) << simd_op_b[i][2:0];
          SimdOr: simd_result = simd_op_a | simd_op_b;
          SimdXor: simd_result = simd_op_a ^ simd_op_b;
          SimdAnd: simd_result = simd_op_a & simd_op_b;
          SimdAbs:
            for (int i = 0; i < Width/8; i++)
              simd_result[i] = $signed(simd_op_a[i]) > 0 ? simd_op_a[i] : -$signed(simd_op_a[i]);
          SimdExt: begin
            simd_result[0] = simd_op_a[imm6[1:0]];
            // sign- or zero-extend
            simd_result[3:1] = {24{simd_op_a[imm6[1:0]][7] & simd_signed}};
          end
          SimdIns: begin
            simd_result = op_c_i;
            simd_result[imm6[1:0]] = simd_op_a[0];
          end
          SimdDotp: begin
            simd_result = op_c_i & {(Width){simd_dotp_acc}}; // accumulate on rd or start from zero
            for (int i = 0; i < Width/8; i++)
              simd_result = $signed(simd_result) + $signed({simd_op_a[i][7] & simd_dotp_op_a_signed, simd_op_a[i]}) *
                                                   $signed({simd_op_b[i][7] & simd_dotp_op_b_signed, simd_op_b[i]});
          end
          SimdShuffle:
            for (int i = 0; i < Width/8; i++)
              simd_result[i] = simd_op_b[i][2] ? simd_op_a[simd_op_b[i][1:0]] : simd_op_c[simd_op_b[i][1:0]];
          default: ;
        endcase
      end
      default: ;
    endcase
  end

  // --------------------
  // Result generation
  // --------------------

  always_comb begin
    unique case (res_sel)
      Abs: result_o = cmp_result ? -$signed(op_a_i) : op_a_i;
      Sle: result_o = $unsigned(cmp_result);
      Min: result_o = cmp_result ? op_a_i : op_b_i;
      Max: result_o = ~cmp_result ? op_a_i : op_b_i;
      Exths: result_o = $signed(op_a_i[15:0]);
      Exthz: result_o = $unsigned(op_a_i[15:0]);
      Extbs: result_o = $signed(op_a_i[7:0]);
      Extbz: result_o = $unsigned(op_a_i[7:0]);
      // Select the clip output basing on the result of the comparison and on the signs of the operands:
      // - if rs1 <= clip_comp (i.e. cmp_result = 1)
      //   * if clip_comp=clip_op_b_n (i.e. rs1<0 or clip_op_b<0): rs1 is below the lower boundand since
      //     this check has priority over the others, result_o is clipped to clip_op_b_n
      //   * if clip_comp=clip_op_b (i.e. rs1>=0 and clip_op_b>=0): since rs1<=clip_op_b, then it is
      //     clip_op_b_n < 0 <= rs1 <= clip_op_b thus rs1 is already within the clip bounds
      // - if rs1 > clip_comp (i.e. cmp_result = 0)
      //   * if rs1 < 0: clip_comp=clip_op_b_n because clip_use_n_bound=1; since rs1>clip_op_b_n and
      //     rs1<0 it is clip_op_b_n < rs1 < 0 <= clip_op_b, thus rs1 is already within the clip bounds
      //   * if rs1 >= 0: then clip_comp might be clip_op_b_n or clip_op_b basing on clip_op_b sign;
      //     + if clip_op_b < 0: clip_comp=clip_op_b_n, so rs1>clip_op_b_n but also rs1 >= 0, so it is
      //       clip_op_b < 0 <= clip_op_n <= rs1; then rs1 is not <= clip_ob_n but it is >= clip_op_b,
      //       so result_o is clipped to clip_op_b
      //     + if clip_op_b >= 0: clip_comp=clip_op_b (i.e. rs1>=0 and clip_op_b>=0) and the result must
      //       be clipped to the upper bound since rs1 > clip_op_b
      Clip: result_o = cmp_result ? (clip_use_n_bound ? clip_op_b_n : op_a_i) : (op_a_i[Width-1] ? op_a_i : clip_op_b);
      Mac: result_o = mac_result;
      Simd: result_o = simd_result;
      default: result_o = '0;
    endcase
  end

endmodule
