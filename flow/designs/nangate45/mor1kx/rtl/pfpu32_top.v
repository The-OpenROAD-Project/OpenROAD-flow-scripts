/////////////////////////////////////////////////////////////////////
////                                                             ////
////  pfpu32_top                                                 ////
////  32-bit floating point top level                            ////
////                                                             ////
////  Author: Andrey Bacherov                                    ////
////          avbacherov@opencores.org                           ////
////                                                             ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2014 Andrey Bacherov                          ////
////                    avbacherov@opencores.org                 ////
////                                                             ////
//// This source file may be used and distributed without        ////
//// restriction provided that this copyright statement is not   ////
//// removed from the file and that any derivative work contains ////
//// the original copyright notice and the associated disclaimer.////
////                                                             ////
////     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ////
//// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ////
//// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ////
//// FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ////
//// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ////
//// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ////
//// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ////
//// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ////
//// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ////
//// LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ////
//// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ////
//// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ////
//// POSSIBILITY OF SUCH DAMAGE.                                 ////
////                                                             ////
/////////////////////////////////////////////////////////////////////

// fpu operations:
// ==========================
// 0000 = add,
// 0001 = substract,
// 0010 = multiply,
// 0011 = divide,
// 0100 = i2f
// 0101 = f2i
// 0110 = unused (rem)
// 0111 = reserved
// 1xxx = comparison

`include "mor1kx-defines.v"

module pfpu32_top
#(
  parameter OPTION_OPERAND_WIDTH = 32
)
(
  input clk,
  input rst,
  input flush_i,
  input padv_decode_i,
  input padv_execute_i,
  input [`OR1K_FPUOP_WIDTH-1:0]    op_fpu_i,
  input [`OR1K_FPCSR_RM_SIZE-1:0]  round_mode_i,
  input [OPTION_OPERAND_WIDTH-1:0] rfa_i,
  input [OPTION_OPERAND_WIDTH-1:0] rfb_i,
  output [OPTION_OPERAND_WIDTH-1:0] fpu_result_o,
  output fpu_arith_valid_o,
  output fpu_cmp_flag_o,
  output fpu_cmp_valid_o,
  output [`OR1K_FPCSR_WIDTH-1:0] fpcsr_o
);

// MSB (set by decode stage) indicates FPU instruction
// Get rid of top bit - is FPU op valid bit
wire   is_op_fpu = op_fpu_i[`OR1K_FPUOP_WIDTH-1];
wire [`OR1K_FPUOP_WIDTH-1:0] op_fpu = {1'b0,op_fpu_i[`OR1K_FPUOP_WIDTH-2:0]};
wire [2:0] op_arith_conv = op_fpu_i[2:0]; // alias
wire a_cmp = op_fpu_i[3]; // alias for compare bit of fpu's opcode

// advance FPU units
wire padv_fpu_units = padv_execute_i |
                      ((~fpu_arith_valid_o) & (~fpu_cmp_valid_o));

// start logic
reg new_data;
always @(posedge clk `OR_ASYNC_RST) begin
  if (rst)
    new_data <= 1'b0;
  else if(flush_i)
    new_data <= 1'b0;
  else if(padv_decode_i)
    new_data <= 1'b1;
  else if(padv_fpu_units)
    new_data <= 1'b0;
end // posedge clock

wire new_fpu_data = new_data & is_op_fpu;


// analysis of input values
//   split input a
wire        in_signa  = rfa_i[31];
wire [7:0]  in_expa   = rfa_i[30:23];
wire [22:0] in_fracta = rfa_i[22:0];
//   detect infinity a
wire in_expa_ff = &in_expa;
wire in_infa    = in_expa_ff & (~(|in_fracta));
//   signaling NaN: exponent is 8hff, [22] is zero,
//                  rest of fract is non-zero
//   quiet NaN: exponent is 8hff, [22] is 1
wire in_snan_a = in_expa_ff & (~in_fracta[22]) & (|in_fracta[21:0]);
wire in_qnan_a = in_expa_ff &   in_fracta[22];
//   denormalized/zero of a
wire in_opa_0  = ~(|rfa_i[30:0]);
wire in_opa_dn = (~(|in_expa)) & (|in_fracta);

//   split input b
wire        in_signb  = rfb_i[31];
wire [7:0]  in_expb   = rfb_i[30:23];
wire [22:0] in_fractb = rfb_i[22:0];
//   detect infinity b
wire in_expb_ff = &in_expb;
wire in_infb    = in_expb_ff & (~(|in_fractb));
//   detect NaNs in b
wire in_snan_b = in_expb_ff & (~in_fractb[22]) & (|in_fractb[21:0]);
wire in_qnan_b = in_expb_ff &   in_fractb[22];
//   denormalized/zero of a
wire in_opb_0  = ~(|rfb_i[30:0]);
wire in_opb_dn = (~(|in_expb)) & (|in_fractb);

// detection of some exceptions
//   a nan input -> qnan output
wire in_snan = in_snan_a | in_snan_b;
wire in_qnan = in_qnan_a | in_qnan_b;
//   sign of output nan
wire in_anan_sign = (in_snan_a | in_qnan_a) ? in_signa :
                                              in_signb;

// restored exponents
wire [9:0] in_exp10a = {2'd0,in_expa[7:1],(in_expa[0] | in_opa_dn)};
wire [9:0] in_exp10b = {2'd0,in_expb[7:1],(in_expb[0] | in_opb_dn)};
// restored fractionals
wire [23:0] in_fract24a = {((~in_opa_dn) & (~in_opa_0)),in_fracta};
wire [23:0] in_fract24b = {((~in_opb_dn) & (~in_opb_0)),in_fractb};


// comparator
//   inputs & outputs
wire op_cmp = a_cmp &
              new_fpu_data;
wire addsub_agtb_o, addsub_aeqb_o;
wire cmp_result, cmp_ready,
     cmp_inv, cmp_inf;
//   module istance
pfpu32_fcmp u_f32_cmp
(
  .fpu_op_is_comp_i(op_cmp),
  .generic_cmp_opc_i(op_fpu[`OR1K_FPUOP_GENERIC_CMP_SELECT]),
  .unordered_cmp_bit_i(op_fpu[`OR1K_FPUOP_UNORDERED_CMP_BIT]),
  // operand 'a' related inputs
  .signa_i(in_signa),
  .exp10a_i(in_exp10a),
  .fract24a_i(in_fract24a),
  .snana_i(in_snan_a),
  .qnana_i(in_qnan_a),
  .infa_i(in_infa),
  .zeroa_i(in_opa_0),
  // operand 'b' related inputs
  .signb_i(in_signb),
  .exp10b_i(in_exp10b),
  .fract24b_i(in_fract24b),
  .snanb_i(in_snan_b),
  .qnanb_i(in_qnan_b),
  .infb_i(in_infb),
  .zerob_i(in_opb_0),
  // support addsub
  .addsub_agtb_o(addsub_agtb_o),
  .addsub_aeqb_o(addsub_aeqb_o),
  // outputs
  .cmp_flag_o(cmp_result),
  .inv_o(cmp_inv),
  .inf_o(cmp_inf),
  .ready_o(cmp_ready)
);


// addition / substraction
//   inputs & outputs
wire the_sub   = (op_arith_conv == 3'd1);
wire op_add    = (~a_cmp) & ((op_arith_conv == 3'd0) | the_sub);
wire add_start = op_add & 
                 new_fpu_data;
wire        add_rdy_o;       // add/sub is ready
wire        add_sign_o;      // add/sub signum
wire        add_sub_0_o;     // flag that actual substruction is performed and result is zero
wire        add_shr_o;       // do right shift in align stage
wire  [4:0] add_shl_o;       // do left shift in align stage
wire  [9:0] add_exp10sh0_o;  // exponent for no shift in align
wire [27:0] add_fract28_o;   // fractional with appended {r,s} bits
wire        add_inv_o;       // add/sub invalid operation flag
wire        add_inf_o;       // add/sub infinity output reg
wire        add_snan_o;      // add/sub signaling NaN output reg
wire        add_qnan_o;      // add/sub quiet NaN output reg
wire        add_anan_sign_o; // add/sub signum for output nan
//   module istance
pfpu32_addsub u_f32_addsub
(
  .clk           (clk),
  .rst           (rst),
  .flush_i       (flush_i),        // flushe pipe
  .adv_i         (padv_fpu_units), // advance pipe
  .start_i       (add_start), 
  .is_sub_i      (the_sub),        // 1: substruction, 0: addition
  // input 'a' related values
  .signa_i       (in_signa),
  .exp10a_i      (in_exp10a),
  .fract24a_i    (in_fract24a),
  .infa_i        (in_infa),
  // input 'b' related values
  .signb_i       (in_signb),
  .exp10b_i      (in_exp10b),
  .fract24b_i    (in_fract24b),
  .infb_i        (in_infb),
  // 'a'/'b' related
  .snan_i        (in_snan),
  .qnan_i        (in_qnan),
  .anan_sign_i   (in_anan_sign),
  .addsub_agtb_i (addsub_agtb_o),
  .addsub_aeqb_i (addsub_aeqb_o),
  // outputs
  .add_rdy_o       (add_rdy_o),       // add/sub is ready
  .add_sign_o      (add_sign_o),      // add/sub signum
  .add_sub_0_o     (add_sub_0_o),     // flag that actual substruction is performed and result is zero
  .add_shr_o       (add_shr_o),       // do right shift in align stage
  .add_shl_o       (add_shl_o),       // do left shift in align stage
  .add_exp10sh0_o  (add_exp10sh0_o),  // exponent for no shift in align
  .add_fract28_o   (add_fract28_o),   // fractional with appended {r,s} bits
  .add_inv_o       (add_inv_o),       // add/sub invalid operation flag
  .add_inf_o       (add_inf_o),       // add/sub infinity output reg
  .add_snan_o      (add_snan_o),      // add/sub signaling NaN output reg
  .add_qnan_o      (add_qnan_o),      // add/sub quiet NaN output reg
  .add_anan_sign_o (add_anan_sign_o)  // add/sub signum for output nan
);

// MUL/DIV combined pipeline
//   inputs & outputs
wire op_mul    = (~a_cmp) & (op_arith_conv == 3'd2);
wire op_div    = (~a_cmp) & (op_arith_conv == 3'd3);
wire mul_start = (op_mul | op_div) & 
                 new_fpu_data;
// MUL/DIV common outputs
wire        mul_rdy_o;       // mul is ready
wire        mul_sign_o;      // mul signum
wire  [9:0] mul_shr_o;       // do right shift in align stage
wire        mul_shl_o;       // do left shift in align stage
wire  [9:0] mul_exp10sh0_o;  // exponent for no shift in align
wire [27:0] mul_fract28_o;   // fractional with appended {r,s} bits
wire        mul_inv_o;       // mul invalid operation flag
wire        mul_inf_o;       // mul infinity output reg
wire        mul_snan_o;      // mul signaling NaN output reg
wire        mul_qnan_o;      // mul quiet NaN output reg
wire        mul_anan_sign_o; // mul signum for output nan
// DIV additional outputs
wire        div_op_o;        // operation is division
wire        div_sign_rmnd_o; // signum or reminder for IEEE compliant rounding
wire        div_dbz_o;       // division by zero flag
//   module istance
pfpu32_muldiv u_f32_muldiv
(
  .clk         (clk),
  .rst         (rst),
  .flush_i     (flush_i),        // flushe pipe
  .adv_i       (padv_fpu_units), // advance pipe
  .start_i     (mul_start),
  .is_div_i    (op_div),
  // input 'a' related values
  .signa_i     (in_signa),
  .exp10a_i    (in_exp10a),
  .fract24a_i  (in_fract24a),
  .infa_i      (in_infa),
  .zeroa_i     (in_opa_0),
  // input 'b' related values
  .signb_i     (in_signb),
  .exp10b_i    (in_exp10b),
  .fract24b_i  (in_fract24b),
  .infb_i      (in_infb),
  .zerob_i     (in_opb_0),
  // 'a'/'b' related
  .snan_i      (in_snan),        
  .qnan_i      (in_qnan),
  .anan_sign_i (in_anan_sign),
  // MUL/DIV common outputs
  .muldiv_rdy_o       (mul_rdy_o),       // mul is ready
  .muldiv_sign_o      (mul_sign_o),      // mul signum
  .muldiv_shr_o       (mul_shr_o),       // do right shift in align stage
  .muldiv_shl_o       (mul_shl_o),       // do left shift in align stage
  .muldiv_exp10sh0_o  (mul_exp10sh0_o),  // exponent for no shift in align
  .muldiv_fract28_o   (mul_fract28_o),   // fractional with appended {r,s} bits
  .muldiv_inv_o       (mul_inv_o),       // mul invalid operation flag
  .muldiv_inf_o       (mul_inf_o),       // mul infinity output reg
  .muldiv_snan_o      (mul_snan_o),      // mul signaling NaN output reg
  .muldiv_qnan_o      (mul_qnan_o),      // mul quiet NaN output reg
  .muldiv_anan_sign_o (mul_anan_sign_o), // mul signum for output nan
  // DIV additional outputs
  .div_op_o(div_op_o),                  // operation is division
  .div_sign_rmnd_o(div_sign_rmnd_o),    // signum of reminder for IEEE compliant rounding
  .div_dbz_o(div_dbz_o)                 // division by zero flag
);

// convertor
//   i2f signals
wire op_i2f_cnv = (~a_cmp) & (op_arith_conv == 3'd4);
wire i2f_start  = op_i2f_cnv & 
                  new_fpu_data;
wire        i2f_rdy_o;       // i2f is ready
wire        i2f_sign_o;      // i2f signum
wire  [3:0] i2f_shr_o;
wire  [4:0] i2f_shl_o;
wire [31:0] i2f_fract32_o;
//   i2f module instance
pfpu32_i2f u_i2f_cnv
(
  .clk            (clk),
  .rst            (rst),
  .flush_i        (flush_i),        // flush pipe
  .adv_i          (padv_fpu_units), // advance pipe
  .start_i        (i2f_start),      // start conversion
  .opa_i          (rfa_i),
  .i2f_rdy_o      (i2f_rdy_o),     // i2f is ready
  .i2f_sign_o     (i2f_sign_o),    // i2f signum
  .i2f_shr_o      (i2f_shr_o),
  .i2f_shl_o      (i2f_shl_o),
  .i2f_fract32_o  (i2f_fract32_o)
);
//   f2i signals
wire op_f2i_cnv = (~a_cmp) & (op_arith_conv == 3'd5);
wire f2i_start  = op_f2i_cnv & 
                  new_fpu_data;
wire        f2i_rdy_o;       // f2i is ready
wire        f2i_sign_o;      // f2i signum
wire [23:0] f2i_int24_o;     // f2i fractional
wire  [4:0] f2i_shr_o;       // f2i required shift right value
wire  [3:0] f2i_shl_o;       // f2i required shift left value   
wire        f2i_ovf_o;       // f2i overflow flag
wire        f2i_snan_o;      // f2i signaling NaN output reg
//    f2i module instance
pfpu32_f2i u_f2i_cnv
(
  .clk         (clk),
  .rst         (rst),
  .flush_i     (flush_i),        // flush pipe
  .adv_i       (padv_fpu_units), // advance pipe
  .start_i     (f2i_start),      // start conversion
  .signa_i     (in_signa),       // input 'a' related values
  .exp10a_i    (in_exp10a),
  .fract24a_i  (in_fract24a),
  .snan_i      (in_snan),        // 'a'/'b' related
  .qnan_i      (in_qnan),
  .f2i_rdy_o   (f2i_rdy_o),       // f2i is ready
  .f2i_sign_o  (f2i_sign_o),      // f2i signum
  .f2i_int24_o (f2i_int24_o),     // f2i fractional
  .f2i_shr_o   (f2i_shr_o),       // f2i required shift right value
  .f2i_shl_o   (f2i_shl_o),       // f2i required shift left value   
  .f2i_ovf_o   (f2i_ovf_o),       // f2i overflow flag
  .f2i_snan_o  (f2i_snan_o)       // f2i signaling NaN output reg
);


// multiplexing and rounding
pfpu32_rnd  u_f32_rnd
(
  // clocks, resets and other controls
  .clk             (clk),
  .rst             (rst),
  .flush_i         (flush_i),         // flush pipe
  .adv_i           (padv_fpu_units),  // advance pipe
  .rmode_i         (round_mode_i),    // rounding mode
  // from add/sub
  .add_rdy_i       (add_rdy_o),       // add/sub is ready
  .add_sign_i      (add_sign_o),      // add/sub signum
  .add_sub_0_i     (add_sub_0_o),     // flag that actual substruction is performed and result is zero
  .add_shr_i       (add_shr_o),       // do right shift in align stage
  .add_shl_i       (add_shl_o),       // do left shift in align stage
  .add_exp10sh0_i  (add_exp10sh0_o),  // exponent for no shift in align
  .add_fract28_i   (add_fract28_o),   // fractional with appended {r,s} bits
  .add_inv_i       (add_inv_o),       // add/sub invalid operation flag
  .add_inf_i       (add_inf_o),       // add/sub infinity
  .add_snan_i      (add_snan_o),      // add/sub signaling NaN
  .add_qnan_i      (add_qnan_o),      // add/sub quiet NaN
  .add_anan_sign_i (add_anan_sign_o), // add/sub signum for output nan
  // from mul
  .mul_rdy_i       (mul_rdy_o),       // mul is ready
  .mul_sign_i      (mul_sign_o),      // mul signum
  .mul_shr_i       (mul_shr_o),       // do right shift in align stage
  .mul_shl_i       (mul_shl_o),       // do left shift in align stage
  .mul_exp10sh0_i  (mul_exp10sh0_o),  // exponent for no shift in align
  .mul_fract28_i   (mul_fract28_o),   // fractional with appended {r,s} bits
  .mul_inv_i       (mul_inv_o),       // mul invalid operation flag
  .mul_inf_i       (mul_inf_o),       // mul infinity 
  .mul_snan_i      (mul_snan_o),      // mul signaling NaN
  .mul_qnan_i      (mul_qnan_o),      // mul quiet NaN
  .mul_anan_sign_i (mul_anan_sign_o), // mul signum for output nan
  .div_op_i        (div_op_o),         // MUL/DIV output is division
  .div_sign_rmnd_i (div_sign_rmnd_o),  // signum or reminder for IEEE compliant rounding
  .div_dbz_i       (div_dbz_o),        // division by zero flag
  // from i2f
  .i2f_rdy_i       (i2f_rdy_o),       // i2f is ready
  .i2f_sign_i      (i2f_sign_o),      // i2f signum
  .i2f_shr_i       (i2f_shr_o),
  .i2f_shl_i       (i2f_shl_o),
  .i2f_fract32_i   (i2f_fract32_o),
  // from f2i
  .f2i_rdy_i       (f2i_rdy_o),       // f2i is ready
  .f2i_sign_i      (f2i_sign_o),      // f2i signum
  .f2i_int24_i     (f2i_int24_o),     // f2i fractional
  .f2i_shr_i       (f2i_shr_o),       // f2i required shift right value
  .f2i_shl_i       (f2i_shl_o),       // f2i required shift left value   
  .f2i_ovf_i       (f2i_ovf_o),       // f2i overflow flag
  .f2i_snan_i      (f2i_snan_o),      // f2i signaling NaN
   // from cmp
  .cmp_rdy_i       (cmp_ready),       // cmp is ready
  .cmp_res_i       (cmp_result),      // cmp result
  .cmp_inv_i       (cmp_inv),         // cmp invalid flag
  .cmp_inf_i       (cmp_inf),         // cmp infinity flag
  // outputs
  .fpu_result_o      (fpu_result_o),
  .fpu_arith_valid_o (fpu_arith_valid_o),
  .fpu_cmp_flag_o    (fpu_cmp_flag_o),
  .fpu_cmp_valid_o   (fpu_cmp_valid_o),
  .fpcsr_o           (fpcsr_o)
);

endmodule // pfpu32_top
