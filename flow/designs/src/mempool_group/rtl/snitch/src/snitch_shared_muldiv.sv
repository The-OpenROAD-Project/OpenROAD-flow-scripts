// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

/// Shared Multiply/Divide a.k.a M Extension
/// Based on Ariane Multiply Divide
/// Author: Michael Schaffner,  <schaffner@iis.ee.ethz.ch>
/// Author: Florian Zaruba , <zarubaf@iis.ee.ethz.ch>

module snitch_shared_muldiv #(
  parameter int unsigned IdWidth = 5
) (
  input  logic                     clk_i,
  input  logic                     rst_i,
  // Accelerator Interface - Slave
  input  logic [31:0]              acc_qaddr_i, // unused
  input  logic [IdWidth-1:0]       acc_qid_i,
  input  logic [31:0]              acc_qdata_op_i, // RISC-V instruction
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
  logic mul_valid_op, mul_ready_op;
  // output handshake
  logic mul_valid, mul_ready;
  logic div_valid, div_ready;
  result_t div, mul, oup;
  logic illegal_instruction;

  always_comb begin
    mul_valid_op = 1'b0;
    div_valid_op = 1'b0;
    acc_qready_o = 1'b0;
    acc_perror_o = 1'b0;
    illegal_instruction = 1'b0;
    unique casez (acc_qdata_op_i)
      riscv_instr::MUL,
      riscv_instr::MULH,
      riscv_instr::MULHSU,
      riscv_instr::MULHU: begin
        mul_valid_op = acc_qvalid_i;
        acc_qready_o = mul_ready_op;
      end
      riscv_instr::DIV,
      riscv_instr::DIVU,
      riscv_instr::REM,
      riscv_instr::REMU: begin
        div_valid_op = acc_qvalid_i;
        acc_qready_o = div_ready_op;
      end
      default: illegal_instruction = 1'b1;
    endcase
  end

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
  assign acc_pdata_o = oup.result;
  assign acc_pid_o = oup.id;
endmodule

module multiplier  #(
  parameter int unsigned Width = 64,
  parameter int unsigned IdWidth = 5
) (
    input  logic               clk_i,
    input  logic               rst_i,
    input  logic [IdWidth-1:0] id_i,
    input  logic [31:0]        operator_i,
    input  logic [Width-1:0]   operand_a_i,
    input  logic [Width-1:0]   operand_b_i,
    input  logic               valid_i,
    output logic               ready_o,
    output logic [Width-1:0]   result_o,
    output logic               valid_o,
    input  logic               ready_i,
    output logic [IdWidth-1:0] id_o
);
  // Pipeline register
  logic [IdWidth-1:0] id_q;
  logic               valid_d, valid_q;
  logic               select_upper_q, select_upper_d;
  logic [2*Width-1:0] result_d, result_q;

  // control registers
  logic  sign_a, sign_b;
  // control signals
  assign ready_o    = ~valid_o | ready_i;
  // datapath
  logic [2*Width-1:0] mult_result;
  assign mult_result = $signed({operand_a_i[Width-1] & sign_a, operand_a_i}) * $signed({operand_b_i[Width-1] & sign_b, operand_b_i});
  // Sign Select MUX
  always_comb begin
    sign_a = 1'b0;
    sign_b = 1'b0;
    unique casez (operator_i)
      riscv_instr::MULH: begin
        sign_a   = 1'b1;
        sign_b   = 1'b1;
        select_upper_d = 1'b1;
      end
      riscv_instr::MULHU: begin
        select_upper_d = 1'b1;
      end
      riscv_instr::MULHSU: begin
        sign_a   = 1'b1;
        select_upper_d = 1'b1;
      end
      // MUL performs an XLEN-bit × XLEN-bit multiplication and places the lower XLEN bits in the destination register
      default: begin            // including MUL
        select_upper_d = 1'b0;
      end
    endcase
  end
  // single stage version
  assign result_d = $signed({operand_a_i[Width-1] & sign_a, operand_a_i}) *
                    $signed({operand_b_i[Width-1] & sign_b, operand_b_i});
  // ressult mux
  always_comb begin
    result_o = result_q[Width-1:0];
    if (select_upper_q) begin
      result_o = result_q[2*Width-1:Width];
    end
  end

  always_comb begin
    valid_d = valid_q;
    if (valid_q & ready_i)
      valid_d = 0;
    if (valid_i & ready_o)
      valid_d = 1;
  end
  `FFAR(valid_q, valid_d, '0, clk_i, rst_i)
  // Pipe-line registers
  `FFLAR(id_q,           id_i,           (valid_i & ready_o), '0, clk_i, rst_i)
  `FFLAR(result_q,       result_d,       (valid_i & ready_o), '0, clk_i, rst_i)
  `FFLAR(select_upper_q, select_upper_d, (valid_i & ready_o), '0, clk_i, rst_i)

  assign id_o = id_q;
  assign valid_o = valid_q;

endmodule


module serdiv #(
  parameter WIDTH = 64,
  parameter int unsigned IdWidth = 5
) (
  input  logic                 clk_i,
  input  logic                 rst_ni,
  // input IF
  input  logic [IdWidth-1:0]   id_i,
  input  logic [31:0]          operator_i,
  input  logic [WIDTH-1:0]     op_a_i,
  input  logic [WIDTH-1:0]     op_b_i,
  // handshake
  input  logic                 in_vld_i, // there is a cycle delay from in_rdy_o->in_vld_i, see issue_read_operands.sv stage
  output logic                 in_rdy_o,
  // output IF
  output logic                 out_vld_o,
  input  logic                 out_rdy_i,
  output logic [IdWidth-1:0]   id_o,
  output logic [WIDTH-1:0]     res_o
);

  logic signed_op;
  logic rem;

  always_comb begin
    signed_op = 1'b0;
    rem = 1'b0;
    unique casez (operator_i)
      riscv_instr::DIV: begin
        signed_op = 1'b1;
      end
      riscv_instr::DIVU: begin
      end
      riscv_instr::REM: begin
        signed_op = 1'b1;
        rem = 1'b1;
      end
      riscv_instr::REMU: begin
        rem = 1'b1;
      end
      default:;
    endcase
  end

  enum logic [1:0] {
    IDLE, DIVIDE, FINISH
  } state_d, state_q;

  logic [WIDTH-1:0]       res_q, res_d;
  logic [WIDTH-1:0]       op_a_q, op_a_d;
  logic [WIDTH-1:0]       op_b_q, op_b_d;
  logic                   op_a_sign, op_b_sign;
  logic                   op_b_zero, op_b_zero_q, op_b_zero_d;

  logic [IdWidth-1:0] id_q, id_d;

  logic rem_sel_d, rem_sel_q;
  logic comp_inv_d, comp_inv_q;
  logic res_inv_d, res_inv_q;

  logic [WIDTH-1:0] add_mux;
  logic [WIDTH-1:0] add_out;
  logic [WIDTH-1:0] add_tmp;
  logic [WIDTH-1:0] b_mux;
  logic [WIDTH-1:0] out_mux;

  logic [$clog2(WIDTH+1)-1:0] cnt_q, cnt_d;
  logic cnt_zero;

  logic [WIDTH-1:0] lzc_a_input, lzc_b_input, op_b;
  logic [$clog2(WIDTH)-1:0] lzc_a_result, lzc_b_result;
  logic [$clog2(WIDTH+1)-1:0] shift_a;
  logic [$clog2(WIDTH+1):0] div_shift;

  logic a_reg_en, b_reg_en, res_reg_en, ab_comp, pm_sel, load_en;
  logic lzc_a_no_one, lzc_b_no_one;
  logic div_res_zero_d, div_res_zero_q;
  /////////////////////////////////////
  // align the input operands
  // for faster division
  /////////////////////////////////////
  assign op_b_zero = (op_b_i == 0);
  assign op_a_sign = op_a_i[$high(op_a_i)];
  assign op_b_sign = op_b_i[$high(op_b_i)];

  assign lzc_a_input = (signed_op & op_a_sign) ? {~op_a_i, 1'b0} : op_a_i;
  assign lzc_b_input = (signed_op & op_b_sign) ? ~op_b_i         : op_b_i;

  lzc #(
    .MODE    ( 1          ), // count leading zeros
    .WIDTH   ( WIDTH      )
  ) i_lzc_a (
    .in_i    ( lzc_a_input  ),
    .cnt_o   ( lzc_a_result ),
    .empty_o ( lzc_a_no_one )
  );

  lzc #(
    .MODE    ( 1          ), // count leading zeros
    .WIDTH   ( WIDTH      )
  ) i_lzc_b (
    .in_i    ( lzc_b_input  ),
    .cnt_o   ( lzc_b_result ),
    .empty_o ( lzc_b_no_one )
  );

  assign shift_a      = (lzc_a_no_one) ? WIDTH : lzc_a_result;
  assign div_shift    = (lzc_b_no_one) ? WIDTH : lzc_b_result-shift_a;

  assign op_b         = op_b_i <<< $unsigned(div_shift);

  // the division is zero if |opB| > |opA| and can be terminated
  assign div_res_zero_d = (load_en) ? ($signed(div_shift) < 0) : div_res_zero_q;

  /////////////////////////////////////
  // Datapath
  /////////////////////////////////////

  assign pm_sel      = load_en & ~(signed_op & (op_a_sign ^ op_b_sign));
  // muxes
  assign add_mux     = (load_en)   ? op_a_i  : op_b_q;
  // attention: logical shift by one in case of negative operand B!
  assign b_mux       = (load_en)   ? op_b : {comp_inv_q, (op_b_q[$high(op_b_q):1])};
  // in case of bad timing, we could output from regs -> needs a cycle more in the FSM
  assign out_mux     = (rem_sel_q) ? op_a_q : res_q;
  // invert if necessary
  assign res_o       = (res_inv_q) ? -$signed(out_mux) : out_mux;
  // main comparator
  assign ab_comp     = ((op_a_q == op_b_q) | ((op_a_q > op_b_q) ^ comp_inv_q)) & ((|op_a_q) | op_b_zero_q);
  // main adder
  assign add_tmp     = (load_en) ? 0 : op_a_q;
  assign add_out     = (pm_sel)  ? add_tmp + add_mux : add_tmp - $signed(add_mux);

  /////////////////////////////////////
  // FSM, counter
  /////////////////////////////////////
  assign cnt_zero = (cnt_q == 0);
  assign cnt_d    = (load_en)   ? div_shift  :
                    (~cnt_zero) ? cnt_q - 1  : cnt_q;

  always_comb begin : p_fsm
    // default
    state_d        = state_q;
    in_rdy_o       = 1'b0;
    out_vld_o      = 1'b0;
    load_en        = 1'b0;
    a_reg_en       = 1'b0;
    b_reg_en       = 1'b0;
    res_reg_en     = 1'b0;
    unique case (state_q)
      IDLE: begin
        in_rdy_o    = 1'b1;
        if (in_vld_i) begin
          a_reg_en  = 1'b1;
          b_reg_en  = 1'b1;
          load_en   = 1'b1;
          state_d   = DIVIDE;
        end
      end
      DIVIDE: begin
        if (!div_res_zero_q) begin
          a_reg_en     = ab_comp;
          b_reg_en     = 1'b1;
          res_reg_en   = 1'b1;
        end
        // can end the division now if the result is clearly 0
        if (div_res_zero_q) begin
          out_vld_o = 1'b1;
          state_d   = FINISH;
          if (out_rdy_i) begin
            state_d  = IDLE;
          end
        end else if (cnt_zero) begin
          state_d   = FINISH;
        end
      end
      FINISH: begin
        out_vld_o = 1'b1;

        if (out_rdy_i) begin
          state_d  = IDLE;
        end
      end
      default : state_d = IDLE;
    endcase
  end

  /////////////////////////////////////
  // regs, flags
  /////////////////////////////////////

  // get flags
  assign rem_sel_d    = (load_en) ? rem                   : rem_sel_q;
  assign comp_inv_d   = (load_en) ? signed_op & op_b_sign : comp_inv_q;
  assign op_b_zero_d  = (load_en) ? op_b_zero             : op_b_zero_q;
  assign res_inv_d    = (load_en) ? (~op_b_zero | rem) & signed_op & (op_a_sign ^ op_b_sign) : res_inv_q;

  // transaction id
  assign id_d = (load_en) ? id_i : id_q;
  assign id_o = id_q;

  assign op_a_d   = (a_reg_en)   ? add_out : op_a_q;
  assign op_b_d   = (b_reg_en)   ? b_mux   : op_b_q;
  assign res_d    = (load_en)   ? '0       :
                    (res_reg_en) ? {res_q[$high(res_q)-1:0], ab_comp} : res_q;

  always_ff @(posedge clk_i or negedge rst_ni) begin : p_regs
    if (!rst_ni) begin
      state_q        <= IDLE;
      op_a_q         <= '0;
      op_b_q         <= '0;
      res_q          <= '0;
      cnt_q          <= '0;
      id_q           <= '0;
      rem_sel_q      <= 1'b0;
      comp_inv_q     <= 1'b0;
      res_inv_q      <= 1'b0;
      op_b_zero_q    <= 1'b0;
      div_res_zero_q <= 1'b0;
    end else begin
      state_q        <= state_d;
      op_a_q         <= op_a_d;
      op_b_q         <= op_b_d;
      res_q          <= res_d;
      cnt_q          <= cnt_d;
      id_q           <= id_d;
      rem_sel_q      <= rem_sel_d;
      comp_inv_q     <= comp_inv_d;
      res_inv_q      <= res_inv_d;
      op_b_zero_q    <= op_b_zero_d;
      div_res_zero_q <= div_res_zero_d;
    end
  end

endmodule
