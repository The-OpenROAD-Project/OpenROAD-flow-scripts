/* ****************************************************************************
  SPDX-License-Identifier: CERN-OHL-W-2.0

  Description: mor1kx execute stage ALU

  Inputs are opcodes, the immediate field, operands from RF, instruction
  opcode

  Copyright (C) 2012 Julius Baxter <juliusbaxter@gmail.com>
  Copyright (C) 2012-2014 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>

***************************************************************************** */

`include "mor1kx-defines.v"

module mor1kx_execute_alu
  #(
    parameter OPTION_OPERAND_WIDTH = 32,

    parameter FEATURE_OVERFLOW = "NONE",
    parameter FEATURE_CARRY_FLAG = "ENABLED",

    parameter FEATURE_MULTIPLIER = "THREESTAGE",
    parameter FEATURE_DIVIDER = "NONE",

    parameter FEATURE_ADDC = "NONE",
    parameter FEATURE_SRA = "ENABLED",
    parameter FEATURE_ROR = "NONE",
    parameter FEATURE_EXT = "NONE",
    parameter FEATURE_CMOV = "NONE",
    parameter FEATURE_FFL1 = "NONE",

    parameter FEATURE_CUST1 = "NONE",
    parameter FEATURE_CUST2 = "NONE",
    parameter FEATURE_CUST3 = "NONE",
    parameter FEATURE_CUST4 = "NONE",
    parameter FEATURE_CUST5 = "NONE",
    parameter FEATURE_CUST6 = "NONE",
    parameter FEATURE_CUST7 = "NONE",
    parameter FEATURE_CUST8 = "NONE",

    parameter FEATURE_FPU    = "NONE", // ENABLED|NONE
    parameter OPTION_SHIFTER = "BARREL",

    // Pipeline specific internal parameters
    parameter CALCULATE_BRANCH_DEST = "TRUE"
    )
   (
    input 			      clk,
    input 			      rst,

    // pipeline control signal in
    input 			      padv_decode_i,
    input 			      padv_execute_i,

    input 			      pipeline_flush_i ,// flush pipelined fpu

    // inputs to ALU
    input [`OR1K_ALU_OPC_WIDTH-1:0]   opc_alu_i,
    input [`OR1K_ALU_OPC_WIDTH-1:0]   opc_alu_secondary_i,

    input [`OR1K_IMM_WIDTH-1:0]       imm16_i,
    input [OPTION_OPERAND_WIDTH-1:0]  immediate_i,
    input 			      immediate_sel_i,

    input [OPTION_OPERAND_WIDTH-1:0]  decode_immediate_i,
    input 			      decode_immediate_sel_i,

    input 			      decode_valid_i,

    input 			      decode_op_mul_i,

    input 			      op_alu_i,
    input 			      op_add_i,
    input 			      op_mul_i,
    input 			      op_mul_signed_i,
    input 			      op_mul_unsigned_i,
    input 			      op_div_i,
    input 			      op_div_signed_i,
    input 			      op_div_unsigned_i,
    input 			      op_shift_i,
    input 			      op_ffl1_i,
    input 			      op_setflag_i,
    input 			      op_mtspr_i,
    input 			      op_mfspr_i,
    input 			      op_movhi_i,
    input 			      op_ext_i,
    input [`OR1K_FPUOP_WIDTH-1:0]   op_fpu_i,
    input [`OR1K_FPCSR_RM_SIZE-1:0] fpu_round_mode_i,
    input 			      op_jbr_i,
    input 			      op_jr_i,
    input [9:0] 		      immjbr_upper_i,
    input [OPTION_OPERAND_WIDTH-1:0]  pc_execute_i,

    // Adder control logic
    input 			      adder_do_sub_i,
    input 			      adder_do_carry_i,

    input [OPTION_OPERAND_WIDTH-1:0]  decode_rfa_i,
    input [OPTION_OPERAND_WIDTH-1:0]  decode_rfb_i,

    input [OPTION_OPERAND_WIDTH-1:0]  rfa_i,
    input [OPTION_OPERAND_WIDTH-1:0]  rfb_i,

    // flag fed back from ctrl
    input 			      flag_i,

    output 			      flag_set_o,
    output 			      flag_clear_o,

    input 			      carry_i,
    output 			      carry_set_o,
    output 			      carry_clear_o,

    output 			      overflow_set_o,
    output 			      overflow_clear_o,

    output [`OR1K_FPCSR_WIDTH-1:0] fpcsr_o,
    output                         fpcsr_set_o,

    output [OPTION_OPERAND_WIDTH-1:0] alu_result_o,
    output 			      alu_valid_o,
    output [OPTION_OPERAND_WIDTH-1:0] mul_result_o,
    output [OPTION_OPERAND_WIDTH-1:0] adder_result_o
    );

   wire                                   alu_stall;

   wire [OPTION_OPERAND_WIDTH-1:0]        a;
   wire [OPTION_OPERAND_WIDTH-1:0]        b;

   // Adder & comparator wires
   wire [OPTION_OPERAND_WIDTH-1:0]        adder_result;
   wire                                   adder_carryout;
   wire 				  adder_signed_overflow;
   wire 				  adder_unsigned_overflow;
   wire 				  adder_result_sign;

   wire [OPTION_OPERAND_WIDTH-1:0]        b_neg;
   wire [OPTION_OPERAND_WIDTH-1:0]        b_mux;
   wire                                   carry_in;

   wire                                   a_eq_b;
   wire                                   a_lts_b;
   wire                                   a_ltu_b;

   // Shifter wires
   wire [`OR1K_ALU_OPC_SECONDARY_WIDTH-1:0] opc_alu_shr;
   wire [OPTION_OPERAND_WIDTH-1:0]        shift_result;
   wire                                   shift_valid;

   // Comparison wires
   reg                                    flag_set; // comb.

   // Logic wires
   wire 				  op_logic;
   reg [OPTION_OPERAND_WIDTH-1:0] 	  logic_result;

   // Multiplier wires
   wire [OPTION_OPERAND_WIDTH-1:0]        mul_result;
   wire                                   mul_valid;
   wire 				  mul_signed_overflow;
   wire 				  mul_unsigned_overflow;

   wire [OPTION_OPERAND_WIDTH-1:0]        div_result;
   wire                                   div_valid;
   wire 				  div_by_zero;


   wire [OPTION_OPERAND_WIDTH-1:0]        ffl1_result;

   wire 				  op_cmov;
   wire [OPTION_OPERAND_WIDTH-1:0]        cmov_result;

   wire [OPTION_OPERAND_WIDTH-1:0]        decode_a;
   wire [OPTION_OPERAND_WIDTH-1:0]        decode_b;

   // Sign extension wires
   reg [OPTION_OPERAND_WIDTH-1:0]         ext_result; // comb
   wire [`OR1K_ALU_OPC_SECONDARY_WIDTH-1:0] opc_alu_ext;
generate
if (CALCULATE_BRANCH_DEST=="TRUE") begin : calculate_branch_dest
   assign a = (op_jbr_i | op_jr_i) ? pc_execute_i : rfa_i;
   assign b = immediate_sel_i ? immediate_i :
              op_jbr_i ? {{4{immjbr_upper_i[9]}},immjbr_upper_i,imm16_i,2'b00} :
              rfb_i;
end else begin
   assign a = rfa_i;
   assign b = immediate_sel_i ? immediate_i : rfb_i;

   assign decode_a = decode_rfa_i;
   assign decode_b = decode_immediate_sel_i ? decode_immediate_i : decode_rfb_i;

end
endgenerate

   assign opc_alu_shr = opc_alu_secondary_i[`OR1K_ALU_OPC_SECONDARY_WIDTH-1:0];
   assign opc_alu_ext = opc_alu_secondary_i[`OR1K_ALU_OPC_SECONDARY_WIDTH-1:0];

   // Adder/subtractor inputs
   assign b_neg = ~b;
   assign carry_in = adder_do_sub_i | adder_do_carry_i & carry_i;
   assign b_mux = adder_do_sub_i ? b_neg : b;
   // Adder
   assign {adder_carryout, adder_result} = a + b_mux +
                                           {{OPTION_OPERAND_WIDTH-1{1'b0}},
                                            carry_in};

   assign adder_result_sign = adder_result[OPTION_OPERAND_WIDTH-1];

   assign adder_signed_overflow = // Input signs are same and ...
				  (a[OPTION_OPERAND_WIDTH-1] ==
				   b_mux[OPTION_OPERAND_WIDTH-1]) &
				  // result sign is different to input signs
				  (a[OPTION_OPERAND_WIDTH-1] ^
				   adder_result[OPTION_OPERAND_WIDTH-1]);

   assign adder_unsigned_overflow = adder_carryout;

   assign adder_result_o = adder_result;

   generate
      /* verilator lint_off WIDTH */
      if (FEATURE_MULTIPLIER=="THREESTAGE") begin : threestagemultiply
	 /* verilator lint_on WIDTH */
         // 32-bit multiplier with three registering stages to help with timing
         reg [OPTION_OPERAND_WIDTH-1:0]           mul_opa;
         reg [OPTION_OPERAND_WIDTH-1:0]           mul_opb;
         reg [OPTION_OPERAND_WIDTH-1:0]           mul_result1;
         reg [OPTION_OPERAND_WIDTH-1:0]           mul_result2;
         reg [2:0]                                mul_valid_shr;

	 always @(posedge clk) begin
	    if (op_mul_i) begin
	       mul_opa <= a;
	       mul_opb <= b;
	    end
	    mul_result1 <= mul_opa * mul_opb;
	    mul_result2 <= mul_result1;
	 end

         assign mul_result = mul_result2;

         always @(posedge clk)
           if (decode_valid_i)
             mul_valid_shr <= {2'b00, op_mul_i};
           else
             mul_valid_shr <= mul_valid_shr[2] ? mul_valid_shr:
			      {mul_valid_shr[1:0], 1'b0};

         assign mul_valid = mul_valid_shr[2] & !decode_valid_i;

	 // Can't detect unsigned overflow in this implementation
	 assign mul_unsigned_overflow = 0;

      end // if (FEATURE_MULTIPLIER=="THREESTAGE")
      /* verilator lint_off WIDTH */
      else if (FEATURE_MULTIPLIER=="PIPELINED") begin : pipelinedmultiply
	 /* verilator lint_on WIDTH */
         // 32-bit multiplier in sync with cpu pipeline
         reg [OPTION_OPERAND_WIDTH-1:0]           mul_opa;
         reg [OPTION_OPERAND_WIDTH-1:0]           mul_opb;
         reg [OPTION_OPERAND_WIDTH-1:0]           mul_result1;
         reg [OPTION_OPERAND_WIDTH-1:0]           mul_result2;

	 always @(posedge clk) begin
	    if (decode_op_mul_i & padv_decode_i) begin
	       mul_opa <= decode_a;
	       mul_opb <= decode_b;
	    end
	    if (padv_execute_i)
	      mul_result1 <= mul_opa * mul_opb;

	    mul_result2 <= mul_result1;
	 end

         assign mul_result = mul_result2;

         assign mul_valid = 1;

	 // Can't detect unsigned overflow in this implementation
	 assign mul_unsigned_overflow = 0;

      end // if (FEATURE_MULTIPLIER=="PIPELINED")
      else if (FEATURE_MULTIPLIER=="SERIAL") begin : serialmultiply
         reg [(OPTION_OPERAND_WIDTH*2)-1:0]  mul_prod_r;
         reg [5:0]   serial_mul_cnt;
         reg         mul_done;
	 wire [OPTION_OPERAND_WIDTH-1:0] mul_a, mul_b;

	 // Check if it's a signed multiply and operand b is negative,
	 // convert to positive
	 assign mul_a = op_mul_signed_i & a[OPTION_OPERAND_WIDTH-1] ?
			~a + 1 : a;
	 assign mul_b = op_mul_signed_i & b[OPTION_OPERAND_WIDTH-1] ?
			~b + 1 : b;

         always @(posedge clk)
           if (rst) begin
               mul_prod_r <=  64'h0000_0000_0000_0000;
               serial_mul_cnt <= 6'd0;
               mul_done <= 1'b0;
            end
            else if (|serial_mul_cnt) begin
               serial_mul_cnt <= serial_mul_cnt - 6'd1;

               if (mul_prod_r[0])
                  mul_prod_r[(OPTION_OPERAND_WIDTH*2)-1:OPTION_OPERAND_WIDTH-1]
                     <= mul_prod_r[(OPTION_OPERAND_WIDTH*2)-1:OPTION_OPERAND_WIDTH] + mul_a;
               else
                  mul_prod_r[(OPTION_OPERAND_WIDTH*2)-1:OPTION_OPERAND_WIDTH-1]
                     <= {1'b0,mul_prod_r[(OPTION_OPERAND_WIDTH*2)-1:OPTION_OPERAND_WIDTH]};

               mul_prod_r[OPTION_OPERAND_WIDTH-2:0] <= mul_prod_r[OPTION_OPERAND_WIDTH-1:1];

               if (serial_mul_cnt==6'd1)
                  mul_done <= 1'b1;

            end
            else if (decode_valid_i && op_mul_i) begin
               mul_prod_r[(OPTION_OPERAND_WIDTH*2)-1:OPTION_OPERAND_WIDTH] <= 32'd0;
               mul_prod_r[OPTION_OPERAND_WIDTH-1:0] <= mul_b;
               mul_done <= 0;
               serial_mul_cnt <= 6'b10_0000;
            end
            else if (decode_valid_i) begin
               mul_done <= 1'b0;
            end

         assign mul_valid  = mul_done & !decode_valid_i;

         assign mul_result = op_mul_signed_i ?
			     ((a[OPTION_OPERAND_WIDTH-1] ^
			       b[OPTION_OPERAND_WIDTH-1]) ?
			      ~mul_prod_r[OPTION_OPERAND_WIDTH-1:0] + 1 :
			      mul_prod_r[OPTION_OPERAND_WIDTH-1:0]) :
			     mul_prod_r[OPTION_OPERAND_WIDTH-1:0];

	 assign mul_unsigned_overflow =  OPTION_OPERAND_WIDTH==64 ? 0 :
					 |mul_prod_r[(OPTION_OPERAND_WIDTH*2)-1:
						     OPTION_OPERAND_WIDTH];

	 // synthesis translate_off
	 `ifndef verilator
	 always @(posedge mul_valid)
	   begin
	      @(posedge clk);

	   if (((a*b) & {OPTION_OPERAND_WIDTH{1'b1}}) != mul_result)
	     begin
		$display("%t incorrect serial multiply result at pc %08h",
			 $time, pc_execute_i);
		$display("a=%08h b=%08h, mul_result=%08h, expected %08h",
			 a, b, mul_result, ((a*b) & {OPTION_OPERAND_WIDTH{1'b1}}));
	     end
	   end
	 `endif
         // synthesis translate_on

      end // if (FEATURE_MULTIPLIER=="SERIAL")
      else if (FEATURE_MULTIPLIER=="SIMULATION") begin
         // Simple multiplier result
	 wire [(OPTION_OPERAND_WIDTH*2)-1:0] mul_full_result;
	 assign mul_full_result = a * b;
         assign mul_result = mul_full_result[OPTION_OPERAND_WIDTH-1:0];

	 assign mul_unsigned_overflow =  OPTION_OPERAND_WIDTH==64 ? 0 :
	       |mul_full_result[(OPTION_OPERAND_WIDTH*2)-1:OPTION_OPERAND_WIDTH];

         assign mul_valid = 1;
      end
      else if (FEATURE_MULTIPLIER=="NONE") begin
         // No multiplier
         assign mul_result = 0;
         assign mul_valid = 1'b1;
	 assign mul_unsigned_overflow = 0;
      end
      else begin
         // Incorrect configuration option
         initial begin
            $display("%m: Error - chosen multiplier implementation (%s) not available",
                    FEATURE_MULTIPLIER);
            $finish;
         end
      end
   endgenerate

   // One signed overflow detection for all multiplication implmentations
   assign mul_signed_overflow = (FEATURE_MULTIPLIER=="NONE") ||
				(FEATURE_MULTIPLIER=="PIPELINED") ? 1'b0 :
				// Same signs, check for negative result
				// (should be positive)
				((a[OPTION_OPERAND_WIDTH-1] ==
				  b[OPTION_OPERAND_WIDTH-1]) &&
				 mul_result[OPTION_OPERAND_WIDTH-1]) ||
				// Differring signs, check for positive result
				// (should be negative)
				((a[OPTION_OPERAND_WIDTH-1] ^
				  b[OPTION_OPERAND_WIDTH-1]) &&
				 !mul_result[OPTION_OPERAND_WIDTH-1]);

   assign mul_result_o = mul_result;

   generate
      /* verilator lint_off WIDTH */
      if (FEATURE_DIVIDER=="SERIAL") begin
      /* verilator lint_on WIDTH */
         reg [5:0] div_count;
         reg [OPTION_OPERAND_WIDTH-1:0] div_n;
         reg [OPTION_OPERAND_WIDTH-1:0] div_d;
         reg [OPTION_OPERAND_WIDTH-1:0] div_r;
         wire [OPTION_OPERAND_WIDTH:0]  div_sub;
         reg                            div_neg;
         reg                            div_done;
	 reg 				div_by_zero_r;


         assign div_sub = {div_r[OPTION_OPERAND_WIDTH-2:0],
                           div_n[OPTION_OPERAND_WIDTH-1]} - div_d;

         /* Cycle counter */
         always @(posedge clk `OR_ASYNC_RST)
            if (rst) begin
               div_done <= 0;
               div_count <= 0;
            end else if (decode_valid_i & op_div_i) begin
               div_done <= 0;
               div_count <= OPTION_OPERAND_WIDTH[5:0];
            end else if (div_count == 1)
               div_done <= 1;
            else if (!div_done)
               div_count <= div_count - 1'd1;

         always @(posedge clk) begin
            if (decode_valid_i & op_div_i) begin
               div_n <= rfa_i;
               div_d <= rfb_i;
               div_r <= 0;
               div_neg <= 1'b0;
               div_by_zero_r <= !(|rfb_i);

               /*
                * Convert negative operands in the case of signed division.
                * If only one of the operands is negative, the result is
                * converted back to negative later on
                */
               if (op_div_signed_i) begin
                  if (rfa_i[OPTION_OPERAND_WIDTH-1] ^
		      rfb_i[OPTION_OPERAND_WIDTH-1])
                    div_neg <= 1'b1;

                  if (rfa_i[OPTION_OPERAND_WIDTH-1])
                    div_n <= ~rfa_i + 1;

                  if (rfb_i[OPTION_OPERAND_WIDTH-1])
                    div_d <= ~rfb_i + 1;
               end
            end else if (!div_done) begin
               if (!div_sub[OPTION_OPERAND_WIDTH]) begin // div_sub >= 0
                  div_r <= div_sub[OPTION_OPERAND_WIDTH-1:0];
                  div_n <= {div_n[OPTION_OPERAND_WIDTH-2:0], 1'b1};
               end else begin // div_sub < 0
                  div_r <= {div_r[OPTION_OPERAND_WIDTH-2:0],
                            div_n[OPTION_OPERAND_WIDTH-1]};
                  div_n <= {div_n[OPTION_OPERAND_WIDTH-2:0], 1'b0};
               end
           end
         end

         assign div_valid = div_done & !decode_valid_i;
         assign div_result = div_neg ? ~div_n + 1 : div_n;
	 assign div_by_zero = div_by_zero_r;
      end
      /* verilator lint_off WIDTH */
      else if (FEATURE_DIVIDER=="SIMULATION") begin
      /* verilator lint_on WIDTH */
         assign div_result = a / b;
         assign div_valid = 1;
	 assign div_by_zero = (opc_alu_i == `OR1K_ALU_OPC_DIV ||
				 opc_alu_i == `OR1K_ALU_OPC_DIVU) && !(|b);

      end
      else if (FEATURE_DIVIDER=="NONE") begin
         assign div_result = 0;
         assign div_valid = 1'b1;
	 assign div_by_zero = 0;
      end
      else begin
         // Incorrect configuration option
         initial begin
            $display("%m: Error - chosen divider implementation (%s) not available",
                     FEATURE_DIVIDER);
            $finish;
         end
      end
   endgenerate


  // FPU related
  //  arithmetic part interface
  wire fpu_op_is_arith;
  wire fpu_arith_valid;
  wire [OPTION_OPERAND_WIDTH-1:0] fpu_result;
  //  comparator part interface
  wire fpu_op_is_cmp;
  wire fpu_cmp_valid;
  wire fpu_cmp_flag;
  //  instance
  generate
    /* verilator lint_off WIDTH */
    if (FEATURE_FPU!="NONE") begin :  fpu_alu_ena
    /* verilator lint_on WIDTH */
      // fpu32 instance
      pfpu32_top  u_pfpu32
      (
        .clk(clk),
        .rst(rst),
        .flush_i(pipeline_flush_i),
        .padv_decode_i(padv_decode_i),
        .padv_execute_i(padv_execute_i),
        .op_fpu_i(op_fpu_i),
        .round_mode_i(fpu_round_mode_i),
        .rfa_i(rfa_i),
        .rfb_i(rfb_i),
        .fpu_result_o(fpu_result),
        .fpu_arith_valid_o(fpu_arith_valid),
        .fpu_cmp_flag_o(fpu_cmp_flag),
        .fpu_cmp_valid_o(fpu_cmp_valid),
        .fpcsr_o(fpcsr_o)
      );
      // flag to update FPCSR
      assign fpcsr_set_o = fpu_arith_valid | fpu_cmp_valid;
      // some glue logic
      assign fpu_op_is_arith = op_fpu_i[`OR1K_FPUOP_WIDTH-1] & (~op_fpu_i[3]);
      assign fpu_op_is_cmp   = op_fpu_i[`OR1K_FPUOP_WIDTH-1] &   op_fpu_i[3];
    end
    else begin :  fpu_alu_none
      // arithmetic part
      assign fpu_op_is_arith = 0;
      assign fpu_arith_valid = 0;
      assign fpu_result      = {OPTION_OPERAND_WIDTH{1'b0}};
      // comparator part
      assign fpu_op_is_cmp = 0;
      assign fpu_cmp_valid = 0;
      assign fpu_cmp_flag  = 0;
      // fpu's common
      assign fpcsr_o     = {`OR1K_FPCSR_WIDTH{1'b0}};
      assign fpcsr_set_o = 0;
    end
  endgenerate // FPU related


   wire ffl1_valid;
   generate
      if (FEATURE_FFL1!="NONE") begin
	 wire [OPTION_OPERAND_WIDTH-1:0] ffl1_result_wire;
	 assign ffl1_result_wire = (opc_alu_secondary_i[2]) ?
				   (a[31] ? 32 : a[30] ? 31 : a[29] ? 30 :
				    a[28] ? 29 : a[27] ? 28 : a[26] ? 27 :
				    a[25] ? 26 : a[24] ? 25 : a[23] ? 24 :
				    a[22] ? 23 : a[21] ? 22 : a[20] ? 21 :
				    a[19] ? 20 : a[18] ? 19 : a[17] ? 18 :
				    a[16] ? 17 : a[15] ? 16 : a[14] ? 15 :
				    a[13] ? 14 : a[12] ? 13 : a[11] ? 12 :
				    a[10] ? 11 : a[9] ? 10 : a[8] ? 9 :
				    a[7] ? 8 : a[6] ? 7 : a[5] ? 6 : a[4] ? 5 :
				    a[3] ? 4 : a[2] ? 3 : a[1] ? 2 : a[0] ? 1 : 0 ) :
				   (a[0] ? 1 : a[1] ? 2 : a[2] ? 3 : a[3] ? 4 :
				    a[4] ? 5 : a[5] ? 6 : a[6] ? 7 : a[7] ? 8 :
				    a[8] ? 9 : a[9] ? 10 : a[10] ? 11 : a[11] ? 12 :
				    a[12] ? 13 : a[13] ? 14 : a[14] ? 15 :
				    a[15] ? 16 : a[16] ? 17 : a[17] ? 18 :
				    a[18] ? 19 : a[19] ? 20 : a[20] ? 21 :
				    a[21] ? 22 : a[22] ? 23 : a[23] ? 24 :
				    a[24] ? 25 : a[25] ? 26 : a[26] ? 27 :
				    a[27] ? 28 : a[28] ? 29 : a[29] ? 30 :
				    a[30] ? 31 : a[31] ? 32 : 0);
	 /* verilator lint_off WIDTH */
	 if (FEATURE_FFL1=="REGISTERED") begin
	    /* verilator lint_on WIDTH */
	    reg [OPTION_OPERAND_WIDTH-1:0] ffl1_result_r;

	    assign ffl1_valid = !decode_valid_i;
	    assign ffl1_result = ffl1_result_r;

	    always @(posedge clk)
	      if (decode_valid_i)
		ffl1_result_r = ffl1_result_wire;
	 end else begin
	    assign ffl1_result = ffl1_result_wire;
	    assign ffl1_valid = 1'b1;
	 end
      end
      else begin
	 assign ffl1_result = 0;
	 assign ffl1_valid = 1'b1;
      end
   endgenerate

   // Equal compare
   assign a_eq_b = (a == b);
   // Signed compare
   assign a_lts_b = !(adder_result_sign == adder_signed_overflow);
   // Unsigned compare
   assign a_ltu_b = !adder_carryout;

   generate
      /* verilator lint_off WIDTH */
      if (OPTION_SHIFTER=="BARREL") begin : barrel_shifter
         /* verilator lint_on WIDTH */

	 function [OPTION_OPERAND_WIDTH-1:0] reverse;
	    input [OPTION_OPERAND_WIDTH-1:0] in;
	    integer 			     i;
	    begin
	       for (i = 0; i < OPTION_OPERAND_WIDTH; i=i+1) begin
		  reverse[(OPTION_OPERAND_WIDTH-1)-i] = in[i];
	       end
	    end
	 endfunction

	 wire op_sll = (opc_alu_shr==`OR1K_ALU_OPC_SECONDARY_SHRT_SLL);
	 wire op_srl = (opc_alu_shr==`OR1K_ALU_OPC_SECONDARY_SHRT_SRL);
	 wire op_sra = (opc_alu_shr==`OR1K_ALU_OPC_SECONDARY_SHRT_SRA) &&
		       (FEATURE_SRA!="NONE");
	 wire op_ror = (opc_alu_shr==`OR1K_ALU_OPC_SECONDARY_SHRT_ROR) &&
		       (FEATURE_ROR!="NONE");

	 wire [OPTION_OPERAND_WIDTH-1:0] shift_right;
	 wire [OPTION_OPERAND_WIDTH-1:0] shift_lsw;
	 wire [OPTION_OPERAND_WIDTH-1:0] shift_msw;
	 wire [OPTION_OPERAND_WIDTH*2-1:0] shift_wide;

	 //
	 // Bit-reverse on left shift, perform right shift,
	 // bit-reverse result on left shift.
	 //
	 assign shift_lsw = op_sll ? reverse(a) : a;
	 assign shift_msw = op_sra ?
			    {OPTION_OPERAND_WIDTH{a[OPTION_OPERAND_WIDTH-1]}} :
			    op_ror ? a : {OPTION_OPERAND_WIDTH{1'b0}};

	 assign shift_wide = {shift_msw, shift_lsw} >> b[4:0];
	 assign shift_right = shift_wide[OPTION_OPERAND_WIDTH-1:0];
	 assign shift_result = op_sll ? reverse(shift_right) : shift_right;

         assign shift_valid = 1;

      end else if (OPTION_SHIFTER=="SERIAL") begin : serial_shifter
         // Serial shifter
         reg [4:0] shift_cnt;
         reg       shift_go;
         reg [OPTION_OPERAND_WIDTH-1:0] shift_result_r;
         always @(posedge clk `OR_ASYNC_RST)
           if (rst)
             shift_go <= 0;
           else if (decode_valid_i)
             shift_go <= op_shift_i;

         always @(posedge clk `OR_ASYNC_RST)
           if (rst) begin
              shift_cnt <= 0;
              shift_result_r <= 0;
           end
           else if (decode_valid_i & op_shift_i) begin
              shift_cnt <= 0;
              shift_result_r <= a;
           end
           else if (shift_go && !(shift_cnt==b[4:0])) begin
              shift_cnt <= shift_cnt + 1;
              if (opc_alu_shr==`OR1K_ALU_OPC_SECONDARY_SHRT_SRL)
                shift_result_r <= {1'b0,shift_result_r[OPTION_OPERAND_WIDTH-1:1]};
              else if (opc_alu_shr==`OR1K_ALU_OPC_SECONDARY_SHRT_SLL)
                shift_result_r <= {shift_result_r[OPTION_OPERAND_WIDTH-2:0],1'b0};
              else if (opc_alu_shr==`OR1K_ALU_OPC_SECONDARY_SHRT_ROR)
                shift_result_r <= {shift_result_r[0]
                                   ,shift_result_r[OPTION_OPERAND_WIDTH-1:1]};

              else if (opc_alu_shr==`OR1K_ALU_OPC_SECONDARY_SHRT_SRA)
                shift_result_r <= {a[OPTION_OPERAND_WIDTH-1],
                                   shift_result_r[OPTION_OPERAND_WIDTH-1:1]};
           end // if (shift_go && !(shift_cnt==b[4:0]))

         assign shift_valid = (shift_cnt==b[4:0]) & shift_go & !decode_valid_i;

         assign shift_result = shift_result_r;

      end // if (OPTION_SHIFTER=="SERIAL")
      else
         initial begin
            $display("%m: Error - chosen shifter implementation (%s) not available",
                     OPTION_SHIFTER);
            $finish;

      end
   endgenerate

   // Conditional move
   generate
      /* verilator lint_off WIDTH */
      if (FEATURE_CMOV=="ENABLED") begin
      /* verilator lint_on WIDTH */
         assign cmov_result = flag_i ? a : b;
      end
      else
	 assign cmov_result = 32'b0;
   endgenerate

   // Sign Extension
   generate
      /* verilator lint_off WIDTH */
      if (FEATURE_EXT=="ENABLED") begin
         always @*
           case(opc_alu_i)
             `OR1K_ALU_OPC_EXTBH:
                case(opc_alu_ext)
                  `OR1K_ALU_OPC_SECONDARY_EXTBH_EXTBS,
                  `OR1K_ALU_OPC_SECONDARY_EXTBH_EXTBZ:
                    ext_result = a[7] && (opc_alu_ext == `OR1K_ALU_OPC_SECONDARY_EXTBH_EXTBS) ?
                                 {{(OPTION_OPERAND_WIDTH-8){1'b1}}, a[7:0]} :
                                 {{(OPTION_OPERAND_WIDTH-8){1'b0}}, a[7:0]};
                  `OR1K_ALU_OPC_SECONDARY_EXTBH_EXTHS,
                  `OR1K_ALU_OPC_SECONDARY_EXTBH_EXTHZ:
                    ext_result = a[15] && (opc_alu_ext == `OR1K_ALU_OPC_SECONDARY_EXTBH_EXTHS) ?
                                 {{(OPTION_OPERAND_WIDTH-16){1'b1}}, a[15:0]} :
                                 {{(OPTION_OPERAND_WIDTH-16){1'b0}}, a[15:0]};
                  default:
                    ext_result = a;
                endcase // case(opc_alu_ext)
             `OR1K_ALU_OPC_EXTW:
                //`OR1K_ALU_OPC_SECONDARY_EXTW_EXTWS,
                //`OR1K_ALU_OPC_SECONDARY_EXTW_EXTWZ:
               ext_result = a;
             default:
               ext_result = a;
           endcase // case(opc_alu_i)
      end
      else
	 always @*
	    ext_result = 32'b0;
   endgenerate

   // Comparison logic
   // To update SR[F] either from integer or float point comparision
   assign flag_set_o   = fpu_op_is_cmp ?
                         (fpu_cmp_flag & fpu_cmp_valid) :
                         (flag_set & op_setflag_i);
   assign flag_clear_o = fpu_op_is_cmp ?
                         ((~fpu_cmp_flag) & fpu_cmp_valid) :
                         ((~flag_set) & op_setflag_i);

   // Combinatorial block
   always @*
     case(opc_alu_secondary_i)
       `OR1K_COMP_OPC_EQ:
         flag_set = a_eq_b;
       `OR1K_COMP_OPC_NE:
         flag_set = !a_eq_b;
       `OR1K_COMP_OPC_GTU:
         flag_set = !(a_eq_b | a_ltu_b);
       `OR1K_COMP_OPC_GTS:
         flag_set = !(a_eq_b | a_lts_b);
       `OR1K_COMP_OPC_GEU:
         flag_set = !a_ltu_b;
       `OR1K_COMP_OPC_GES:
         flag_set = !a_lts_b;
       `OR1K_COMP_OPC_LTU:
         flag_set = a_ltu_b;
       `OR1K_COMP_OPC_LTS:
         flag_set = a_lts_b;
       `OR1K_COMP_OPC_LEU:
         flag_set = a_eq_b | a_ltu_b;
       `OR1K_COMP_OPC_LES:
         flag_set = a_eq_b | a_lts_b;
       default:
         flag_set = 0;
     endcase // case (opc_alu_secondary_i)

   //
   // Logic operations
   //
   // Create a look-up-table for AND/OR/XOR
   reg [3:0] logic_lut;
   always @(*) begin
     case(opc_alu_i)
       `OR1K_ALU_OPC_AND:
	 logic_lut = 4'b1000;
       `OR1K_ALU_OPC_OR:
	 logic_lut = 4'b1110;
       `OR1K_ALU_OPC_XOR:
	 logic_lut = 4'b0110;
       default:
	 logic_lut = 0;
     endcase
      if (!op_alu_i)
	logic_lut = 0;
      // Threat mfspr/mtspr as 'OR'
      if (op_mfspr_i | op_mtspr_i)
	logic_lut = 4'b1110;
   end

   // Extract the result, bit-for-bit, from the look-up-table
   integer i;
   always @(*)
     for (i = 0; i < OPTION_OPERAND_WIDTH; i=i+1) begin
        logic_result[i] = logic_lut[{a[i], b[i]}];
     end

   assign op_logic = |logic_lut;

   assign op_cmov = op_alu_i & opc_alu_i == `OR1K_ALU_OPC_CMOV;

   // Result muxing - result is registered in RF
   assign alu_result_o = op_logic ? logic_result :
			 op_cmov ? cmov_result :
			 op_movhi_i ? immediate_i :
			 op_ext_i ? ext_result :
			 op_mul_i ? mul_result[OPTION_OPERAND_WIDTH-1:0] :
			 fpu_arith_valid ? fpu_result :
			 op_shift_i ? shift_result :
			 op_div_i ? div_result :
			 op_ffl1_i ? ffl1_result :
			 adder_result;

   // Carry and overflow flag generation
   assign overflow_set_o = FEATURE_OVERFLOW!="NONE" &
			   (op_add_i & adder_signed_overflow |
			    op_mul_signed_i & mul_signed_overflow |
			    op_div_signed_i & div_by_zero);

   assign overflow_clear_o = FEATURE_OVERFLOW!="NONE" &
			     (op_add_i & !adder_signed_overflow |
			      op_mul_signed_i & !mul_signed_overflow |
			      op_div_signed_i & !div_by_zero);

   assign carry_set_o = FEATURE_CARRY_FLAG!="NONE" &
			(op_add_i & adder_unsigned_overflow |
			 op_mul_unsigned_i & mul_unsigned_overflow |
			 op_div_unsigned_i & div_by_zero);

   assign carry_clear_o = FEATURE_CARRY_FLAG!="NONE" &
			  (op_add_i & !adder_unsigned_overflow |
			   op_mul_unsigned_i & !mul_unsigned_overflow |
			   op_div_unsigned_i & !div_by_zero);

   // Stall logic for multicycle ALU operations
   assign alu_stall = op_div_i & !div_valid |
		      op_mul_i & !mul_valid |
		      fpu_op_is_arith & !fpu_arith_valid |
		      fpu_op_is_cmp & !fpu_cmp_valid |
		      op_shift_i & !shift_valid |
		      op_ffl1_i & !ffl1_valid;

   assign alu_valid_o = !alu_stall;

/*-------------------Formal Checking------------------*/

`ifdef FORMAL

`ifdef ALU
`define ASSUME assume
`else
`define ASSUME assert
`endif

   reg f_past_valid;
   initial f_past_valid = 1'b0;

   always @(posedge clk)
      f_past_valid <= 1'b1;

   always @(*)
      if (!f_past_valid)
         assume (rst);
      else
         assume (!rst);

   wire [16:0] f_exec_opcodes;
   assign f_exec_opcodes = {op_add_i, op_mul_i, op_div_i,
                            op_movhi_i, op_shift_i,
                            op_ffl1_i, op_mtspr_i,
                            op_mfspr_i, op_ext_i,
                            op_jbr_i, op_jr_i};

   always @(posedge clk)
      if (op_mul_i && f_past_valid && !$past(rst))
         `ASSUME (op_mul_unsigned_i | op_mul_signed_i);

   always @(posedge clk)
      if (op_div_i && f_past_valid && !$past(rst))
         `ASSUME (op_div_signed_i | op_div_unsigned_i);

   always @(posedge clk)
      if (f_past_valid)
         `ASSUME ($onehot0(f_exec_opcodes));

   //MULTIPLICATION: PIPELINED
   always @(posedge clk) begin
      if ($past(decode_op_mul_i,3) && $past(padv_decode_i,3) &&
          $past(padv_execute_i,2) && f_past_valid &&
          FEATURE_MULTIPLIER == "PIPELINED" && !$past(rst)
          && op_mul_i && !$past(rst,2) && !$past(rst,3)) begin
         assert (mul_valid);
         assert (alu_valid_o);
         assert (!alu_stall);
      end
   end
   
   //MULTIPLICATION: SIMULATION
   always @(*) begin
      if (FEATURE_MULTIPLIER == "SIMULATION" &&
          op_mul_i && !rst) begin
         //No stall for simulation based multiplier
         assert (!alu_stall);
         assert (alu_valid_o);
         assert (mul_valid);
      end
   end


   //MULTIPLICATION: SERIAL & THREESTAGE
   generate
      if (FEATURE_MULTIPLIER == "SERIAL" || FEATURE_MULTIPLIER == "THREESTAGE") begin : f_mul_multiclock
          f_multiclock_op #(
             .STABLE_WIDTH(32 + 32 + 1 + 1),
             .OP_MAX_CLOCKS(FEATURE_MULTIPLIER == "SERIAL" ? 32 : 3)
           ) u_f_multiclock_mul (
             .clk(clk),
             .f_op_i(op_mul_i),
             .f_op_valid_i(mul_valid),
             .decode_valid_i(decode_valid_i),
             .f_stable_i({rfa_i, rfb_i, op_mul_unsigned_i, op_mul_signed_i}),
             .f_past_valid(f_past_valid)
          );
      end
   endgenerate

   always @(posedge clk) begin
      if (FEATURE_MULTIPLIER == "NONE") begin
         assume (!op_mul_i);
         assert (!mul_result);
      end
   end

   //TODO
   //Formal verification of FPU.

   //DIVIDER: SIMULATION
   always @(posedge clk) begin
      if (FEATURE_DIVIDER == "SIMULATION" &&
         (opc_alu_i == `OR1K_ALU_OPC_DIV ||
         opc_alu_i == `OR1K_ALU_OPC_DIVU)) begin
         assert (div_valid);
         //Divide by zero testing
         if (b==0)
            assert (div_by_zero);
       end

       if (FEATURE_DIVIDER == "NONE" && f_past_valid && !$past(rst)) begin
          assert (!div_result);
          assert (!div_by_zero);
       end
   end

   //DIVIDER: SERIAL
   generate
      if (FEATURE_DIVIDER == "SERIAL") begin : f_div_multiclock
          f_multiclock_op #(
             .STABLE_WIDTH(32 + 32 + 1 + 1),
             .OP_MAX_CLOCKS(FEATURE_MULTIPLIER == "SERIAL" ? 32 : 3)
           ) u_f_multiclock_div (
             .clk(clk),
             .f_op_i(op_div_i),
             .f_op_valid_i(div_valid),
             .decode_valid_i(decode_valid_i),
             .f_stable_i({rfa_i, rfb_i, op_div_unsigned_i, op_div_signed_i}),
             .f_past_valid(f_past_valid)
          );
      end
   endgenerate

   //SHIFTER: BARREL
   (* anyconst *) reg [4:0] f_b;
   wire [OPTION_OPERAND_WIDTH-1:0] f_sll;
   assign f_sll = a << f_b;
   wire [OPTION_OPERAND_WIDTH-1:0] f_srl;
   assign f_srl = a >> f_b;

   always @(posedge clk) begin
      if (OPTION_SHIFTER == "BARREL" && op_shift_i &&
          !op_alu_i && f_past_valid && !$past(rst)) begin
         //Logical shifts
         if (opc_alu_shr == `OR1K_ALU_OPC_SECONDARY_SHRT_SLL && b == f_b)
            assert (alu_result_o == f_sll);
         if (opc_alu_shr == `OR1K_ALU_OPC_SECONDARY_SHRT_SRL && b == f_b)
            assert (alu_result_o == f_srl);
      end
   end

   //SHIFTER: SERIAL
   generate
      if (OPTION_SHIFTER == "SERIAL") begin : f_shft_multiclock
          f_multiclock_op #(
             .STABLE_WIDTH(32 + 32 + `OR1K_IMM_WIDTH + 32 + 1 +`OR1K_ALU_OPC_WIDTH),
             .OP_MAX_CLOCKS(32)
           ) u_f_multiclock_shft (
             .clk(clk),
             .f_op_i(op_shift_i),
             .f_op_valid_i(shift_valid),
             .decode_valid_i(decode_valid_i),
             .f_stable_i({rfa_i, rfb_i, imm16_i, immediate_i, immediate_sel_i, opc_alu_secondary_i}),
             .f_past_valid(f_past_valid)
          );
      end
   endgenerate

   //FFL1
   generate
      if (FEATURE_FFL1 == "REGISTERED") begin : f_ffl1_multiclock
          f_multiclock_op #(
             .STABLE_WIDTH(`OR1K_ALU_OPC_WIDTH),
             .OP_MAX_CLOCKS(1)
           ) u_f_multiclock_ffl1 (
             .clk(clk),
             .f_op_i(op_ffl1_i),
             .f_op_valid_i(ffl1_valid),
             .decode_valid_i(decode_valid_i),
             .f_stable_i(opc_alu_secondary_i),
             .f_past_valid(f_past_valid)
          );
      end
   endgenerate

   always @(*) begin

      //If adder result is zero than a must be equal to b.
      if ((adder_result == 0) && !adder_carryout && op_add_i)
         assert (carry_clear_o && a_eq_b);

      //If carry is generated then carry flag has to be set
      if (adder_carryout & op_add_i)
         assert (carry_set_o);

      //Overflow set condition
      if (op_add_i && adder_signed_overflow && FEATURE_OVERFLOW != "NONE")
         assert (overflow_set_o);

      //Short duration ALU operations shouldn't stall. 
      if (!op_div_i && !op_mul_i && !fpu_op_is_arith &&
          !fpu_op_is_cmp && !op_shift_i && !op_ffl1_i)
         assert (!alu_stall);

   end

   wire [OPTION_OPERAND_WIDTH-1:0] f_logic_and;
   assign f_logic_and = a & b;
   wire [OPTION_OPERAND_WIDTH-1:0] f_logic_or;
   assign f_logic_or = a | b;
   wire [OPTION_OPERAND_WIDTH-1:0] f_logic_xor;
   assign f_logic_xor = a ^ b;

   always @(*) begin

      //Logical Operations
      if (opc_alu_i == `OR1K_ALU_OPC_AND && op_alu_i
          && !op_mtspr_i && !op_mfspr_i)
         assert (logic_result == f_logic_and);
      else if (opc_alu_i == `OR1K_ALU_OPC_OR
               && (op_alu_i || op_mtspr_i || op_mfspr_i))
         assert (logic_result == f_logic_or);
      else if (opc_alu_i == `OR1K_ALU_OPC_XOR
               && op_alu_i && !op_mtspr_i && !op_mfspr_i)
         assert (logic_result == f_logic_xor);

   end

`endif
endmodule // mor1kx_execute_alu
