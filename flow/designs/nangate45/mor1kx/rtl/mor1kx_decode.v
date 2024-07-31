/* ****************************************************************************
  SPDX-License-Identifier: CERN-OHL-W-2.0

  Description: mor1kx decode unit

  Completely combinatorial.

  Outputs:
   - ALU operation
   - indication of other type of op - LSU/SPR
   - immediates
   - register file addresses
   - exception decodes:  illegal, system call

  Copyright (C) 2012 Julius Baxter <juliusbaxter@gmail.com>
  Copyright (C) 2013 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>

***************************************************************************** */

`include "mor1kx-defines.v"

module mor1kx_decode
  #(
    parameter OPTION_OPERAND_WIDTH = 32,
    parameter OPTION_RESET_PC = {{(OPTION_OPERAND_WIDTH-13){1'b0}},
				 `OR1K_RESET_VECTOR,8'd0},
    parameter OPTION_RF_ADDR_WIDTH = 5,

    parameter FEATURE_SYSCALL = "ENABLED",
    parameter FEATURE_TRAP = "ENABLED",
    parameter FEATURE_RANGE = "ENABLED",
    parameter FEATURE_MAC = "NONE",
    parameter FEATURE_MULTIPLIER = "PARALLEL",
    parameter FEATURE_DIVIDER = "NONE",

    parameter FEATURE_ADDC = "NONE",
    parameter FEATURE_SRA = "ENABLED",
    parameter FEATURE_ROR = "NONE",
    parameter FEATURE_EXT = "NONE",
    parameter FEATURE_CMOV = "NONE",
    parameter FEATURE_FFL1 = "NONE",
    parameter FEATURE_ATOMIC = "ENABLED",
    parameter FEATURE_MSYNC = "ENABLED",
    parameter FEATURE_PSYNC = "NONE",
    parameter FEATURE_CSYNC = "NONE",

    parameter FEATURE_FPU   = "NONE", // ENABLED|NONE

    parameter FEATURE_CUST1 = "NONE",
    parameter FEATURE_CUST2 = "NONE",
    parameter FEATURE_CUST3 = "NONE",
    parameter FEATURE_CUST4 = "NONE",
    parameter FEATURE_CUST5 = "NONE",
    parameter FEATURE_CUST6 = "NONE",
    parameter FEATURE_CUST7 = "NONE",
    parameter FEATURE_CUST8 = "NONE"
    )
   (
    input 			      clk,
    input 			      rst,

    // input from fetch stage
    input [`OR1K_INSN_WIDTH-1:0]      decode_insn_i,

    // ALU opcodes
    output [`OR1K_ALU_OPC_WIDTH-1:0]  decode_opc_alu_o,
    output [`OR1K_ALU_OPC_WIDTH-1:0]  decode_opc_alu_secondary_o,

    output [`OR1K_IMM_WIDTH-1:0]      decode_imm16_o,
    output [OPTION_OPERAND_WIDTH-1:0] decode_immediate_o,
    output 			      decode_immediate_sel_o,

    // Upper 10 bits of immediate for jumps and branches
    output [9:0] 		      decode_immjbr_upper_o,

    // GPR numbers
    output [OPTION_RF_ADDR_WIDTH-1:0] decode_rfd_adr_o,
    output [OPTION_RF_ADDR_WIDTH-1:0] decode_rfa_adr_o,
    output [OPTION_RF_ADDR_WIDTH-1:0] decode_rfb_adr_o,

    output 			      decode_rf_wb_o,

    output 			      decode_op_jbr_o,
    output 			      decode_op_jr_o,
    output 			      decode_op_jal_o,
    output 			      decode_op_bf_o,
    output 			      decode_op_bnf_o,
    output 			      decode_op_brcond_o,
    output 			      decode_op_branch_o,

    output 			      decode_op_alu_o,

    output 			      decode_op_lsu_load_o,
    output 			      decode_op_lsu_store_o,
    output 			      decode_op_lsu_atomic_o,
    output reg [1:0] 		      decode_lsu_length_o,
    output 			      decode_lsu_zext_o,

    output 			      decode_op_mfspr_o,
    output 			      decode_op_mtspr_o,

    output 			      decode_op_rfe_o,
    output 			      decode_op_setflag_o,
    output 			      decode_op_add_o,
    output 			      decode_op_mul_o,
    output 			      decode_op_mul_signed_o,
    output 			      decode_op_mul_unsigned_o,
    output 			      decode_op_div_o,
    output 			      decode_op_div_signed_o,
    output 			      decode_op_div_unsigned_o,
    output 			      decode_op_shift_o,
    output 			      decode_op_ffl1_o,
    output 			      decode_op_movhi_o,
    output 			      decode_op_ext_o,

    // Sync operations
    output                            decode_op_msync_o,
    output [`OR1K_FPUOP_WIDTH-1:0]    decode_op_fpu_o,


    // Adder control logic
    output 			      decode_adder_do_sub_o,
    output 			      decode_adder_do_carry_o,

    // exception output -
    output reg 			      decode_except_illegal_o,
    output 			      decode_except_syscall_o,
    output 			      decode_except_trap_o,

    output [`OR1K_OPCODE_WIDTH-1:0]   decode_opc_insn_o
    );

   wire [`OR1K_OPCODE_WIDTH-1:0]      opc_insn;
   wire [`OR1K_ALU_OPC_WIDTH-1:0]     opc_alu;

   wire [OPTION_OPERAND_WIDTH-1:0]    imm_sext;
   wire 			      imm_sext_sel;
   wire [OPTION_OPERAND_WIDTH-1:0]    imm_zext;
   wire 			      imm_zext_sel;
   wire [OPTION_OPERAND_WIDTH-1:0]    imm_high;
   wire 			      imm_high_sel;

   wire 			      decode_except_ibus_align;

   // Insn opcode
   assign opc_insn = decode_insn_i[`OR1K_OPCODE_SELECT];
   assign decode_opc_insn_o = opc_insn;

   // load opcodes are 6'b10_0000 to 6'b10_0110, 0 to 6, so check for 7 and up
   assign decode_op_lsu_load_o = (decode_insn_i[31:30] == 2'b10) &
				 !(&decode_insn_i[28:26]) &
				 !decode_insn_i[29] ||
				 ((opc_insn == `OR1K_OPCODE_LWA) &
				 (FEATURE_ATOMIC!="NONE"));

   // Detect when instruction is store
   assign decode_op_lsu_store_o = (opc_insn == `OR1K_OPCODE_SW) ||
				  (opc_insn == `OR1K_OPCODE_SB) ||
				  (opc_insn == `OR1K_OPCODE_SH) ||
				  ((opc_insn == `OR1K_OPCODE_SWA) &
				  (FEATURE_ATOMIC!="NONE"));

   assign decode_op_lsu_atomic_o = ((opc_insn == `OR1K_OPCODE_LWA) ||
				    (opc_insn == `OR1K_OPCODE_SWA)) &
				   (FEATURE_ATOMIC!="NONE");

   // Decode length of load/store operation
   always @(*)
     case (opc_insn)
       `OR1K_OPCODE_SB,
       `OR1K_OPCODE_LBZ,
       `OR1K_OPCODE_LBS:
	 decode_lsu_length_o = 2'b00;

       `OR1K_OPCODE_SH,
       `OR1K_OPCODE_LHZ,
       `OR1K_OPCODE_LHS:
	 decode_lsu_length_o = 2'b01;

       `OR1K_OPCODE_SW,
       `OR1K_OPCODE_SWA,
       `OR1K_OPCODE_LWZ,
       `OR1K_OPCODE_LWS,
       `OR1K_OPCODE_LWA:
	 decode_lsu_length_o = 2'b10;

       default:
	 decode_lsu_length_o = 2'b10;
     endcase

   assign decode_lsu_zext_o = opc_insn[0];

   assign decode_op_msync_o = FEATURE_MSYNC!="NONE" &&
                              opc_insn == `OR1K_OPCODE_SYSTRAPSYNC &&
                              decode_insn_i[`OR1K_SYSTRAPSYNC_OPC_SELECT] ==
                              `OR1K_SYSTRAPSYNC_OPC_MSYNC;

   assign decode_op_mtspr_o = opc_insn == `OR1K_OPCODE_MTSPR;

   // Detect when setflag instruction
   assign decode_op_setflag_o = opc_insn == `OR1K_OPCODE_SF ||
				opc_insn == `OR1K_OPCODE_SFIMM;

   assign decode_op_alu_o = opc_insn == `OR1K_OPCODE_ALU ||
			    opc_insn == `OR1K_OPCODE_ORI ||
			    opc_insn == `OR1K_OPCODE_ANDI ||
			    opc_insn == `OR1K_OPCODE_XORI;

   // Bottom 4 opcodes branch against an immediate
   assign decode_op_jbr_o = opc_insn < `OR1K_OPCODE_NOP;

   assign decode_op_jr_o = opc_insn == `OR1K_OPCODE_JR |
			   opc_insn == `OR1K_OPCODE_JALR;

   assign decode_op_jal_o = opc_insn == `OR1K_OPCODE_JALR |
			    opc_insn == `OR1K_OPCODE_JAL;

   assign decode_op_bf_o = opc_insn == `OR1K_OPCODE_BF;
   assign decode_op_bnf_o = opc_insn == `OR1K_OPCODE_BNF;
   assign decode_op_brcond_o = decode_op_bf_o | decode_op_bnf_o;

   // All branch instructions combined
   assign decode_op_branch_o = decode_op_jbr_o |
			       decode_op_jr_o |
			       decode_op_jal_o;

   assign decode_op_mfspr_o = opc_insn == `OR1K_OPCODE_MFSPR;

   assign decode_op_rfe_o = opc_insn == `OR1K_OPCODE_RFE;

   assign decode_op_add_o = (opc_insn == `OR1K_OPCODE_ALU &&
			     (opc_alu == `OR1K_ALU_OPC_ADDC ||
			      opc_alu == `OR1K_ALU_OPC_ADD ||
			      opc_alu == `OR1K_ALU_OPC_SUB)) ||
			    opc_insn == `OR1K_OPCODE_ADDIC ||
			    opc_insn == `OR1K_OPCODE_ADDI;

   assign decode_op_mul_signed_o = (opc_insn == `OR1K_OPCODE_ALU &&
				    opc_alu == `OR1K_ALU_OPC_MUL) ||
				   opc_insn == `OR1K_OPCODE_MULI;

   assign decode_op_mul_unsigned_o = opc_insn == `OR1K_OPCODE_ALU &&
				     opc_alu == `OR1K_ALU_OPC_MULU;

   assign decode_op_mul_o = decode_op_mul_signed_o | decode_op_mul_unsigned_o;

   assign decode_op_div_signed_o = opc_insn == `OR1K_OPCODE_ALU &&
				   opc_alu == `OR1K_ALU_OPC_DIV;

   assign decode_op_div_unsigned_o = opc_insn == `OR1K_OPCODE_ALU &&
				     opc_alu == `OR1K_ALU_OPC_DIVU;

   assign decode_op_div_o = decode_op_div_signed_o | decode_op_div_unsigned_o;

   assign decode_op_shift_o = opc_insn == `OR1K_OPCODE_ALU &&
			      opc_alu == `OR1K_ALU_OPC_SHRT ||
			      opc_insn == `OR1K_OPCODE_SHRTI;

   /* check bit 9 to verify valid l.fl1/l.ff1 instruction */
   assign decode_op_ffl1_o = opc_insn == `OR1K_OPCODE_ALU &&
                             (decode_insn_i[9:8] == 2'b00 || decode_insn_i[9:8] == 2'b01) &&
			     opc_alu == `OR1K_ALU_OPC_FFL1;

   assign decode_op_movhi_o = opc_insn == `OR1K_OPCODE_MOVHI;

   assign decode_op_ext_o = opc_insn == `OR1K_OPCODE_ALU &&
			    (opc_alu == `OR1K_ALU_OPC_EXTBH ||
			     opc_alu == `OR1K_ALU_OPC_EXTW) &&
			    (FEATURE_EXT!="NONE");

   // FPU related
   generate
     /* verilator lint_off WIDTH */
     if (FEATURE_FPU!="NONE") begin : fpu_decode_ena
     /* verilator lint_on WIDTH */
       // Only single precision FP-instructions are supported
       assign decode_op_fpu_o  = { ((opc_insn == `OR1K_OPCODE_FPU) &
                                    ~decode_insn_i[`OR1K_FPUOP_DOUBLE_BIT]), 
                                   decode_insn_i[`OR1K_FPUOP_WIDTH-2:0] };
     end
     else begin : fpu_decode_none
       assign decode_op_fpu_o  = {`OR1K_FPUOP_WIDTH{1'b0}};
     end
   endgenerate // FPU related

   // Which instructions cause writeback?
   assign decode_rf_wb_o = (opc_insn == `OR1K_OPCODE_JAL |
			    opc_insn == `OR1K_OPCODE_MOVHI |
			    opc_insn == `OR1K_OPCODE_JALR |
			    opc_insn == `OR1K_OPCODE_LWA) |
			   // All '10????' opcodes except l.sfxxi
			   (decode_insn_i[31:30] == 2'b10 &
			    !(opc_insn == `OR1K_OPCODE_SFIMM)) |
			   // All '11????' opcodes except l.sfxx and l.mtspr and lf.sfxx.s
			   (decode_insn_i[31:30] == 2'b11 &
			    !(opc_insn == `OR1K_OPCODE_SF |
			      decode_op_mtspr_o | decode_op_lsu_store_o) &
          !(decode_op_fpu_o[`OR1K_FPUOP_WIDTH-1] & decode_insn_i[3]));

   // Register file addresses
   assign decode_rfa_adr_o = decode_insn_i[`OR1K_RA_SELECT];
   assign decode_rfb_adr_o = decode_insn_i[`OR1K_RB_SELECT];

   assign decode_rfd_adr_o = decode_op_jal_o ? 5'd9 :
			     decode_insn_i[`OR1K_RD_SELECT];

   // Immediate in l.mtspr is broken up, reassemble
   assign decode_imm16_o = (decode_op_mtspr_o | decode_op_lsu_store_o) ?
			   {decode_insn_i[25:21],decode_insn_i[10:0]} :
			   decode_insn_i[`OR1K_IMM_SELECT];


   // Upper 10 bits for jump/branch instructions
   assign decode_immjbr_upper_o = decode_insn_i[25:16];

   assign imm_sext = {{16{decode_imm16_o[15]}}, decode_imm16_o[15:0]};
   assign imm_sext_sel = ((opc_insn[5:4] == 2'b10) &
                          ~(opc_insn == `OR1K_OPCODE_ORI) &
                          ~(opc_insn == `OR1K_OPCODE_ANDI)) |
                         (opc_insn == `OR1K_OPCODE_SWA) |
                         (opc_insn == `OR1K_OPCODE_LWA) |
                         (opc_insn == `OR1K_OPCODE_SW) |
                         (opc_insn == `OR1K_OPCODE_SH) |
                         (opc_insn == `OR1K_OPCODE_SB);

   assign imm_zext = {{16{1'b0}}, decode_imm16_o[15:0]};
   assign imm_zext_sel = ((opc_insn[5:4] == 2'b10) &
                          ((opc_insn == `OR1K_OPCODE_ORI) |
			   (opc_insn == `OR1K_OPCODE_ANDI))) |
                         (opc_insn == `OR1K_OPCODE_MTSPR);

   assign imm_high = {decode_imm16_o, 16'd0};
   assign imm_high_sel = decode_op_movhi_o;

   assign decode_immediate_o = imm_sext_sel ? imm_sext :
			       imm_zext_sel ? imm_zext : imm_high;

   assign decode_immediate_sel_o = imm_sext_sel | imm_zext_sel | imm_high_sel;

   // ALU opcode
   assign opc_alu = decode_insn_i[`OR1K_ALU_OPC_SELECT];
   assign decode_opc_alu_o = opc_insn == `OR1K_OPCODE_ORI ? `OR1K_ALU_OPC_OR :
			     opc_insn == `OR1K_OPCODE_ANDI ? `OR1K_ALU_OPC_AND :
			     opc_insn == `OR1K_OPCODE_XORI ? `OR1K_ALU_OPC_XOR :
			     opc_alu;

   assign decode_opc_alu_secondary_o = decode_op_setflag_o ?
				       decode_insn_i[`OR1K_COMP_OPC_SELECT]:
				       {1'b0,
					decode_insn_i[`OR1K_ALU_OPC_SECONDARY_SELECT]};

   assign decode_except_syscall_o = opc_insn == `OR1K_OPCODE_SYSTRAPSYNC &&
				    decode_insn_i[`OR1K_SYSTRAPSYNC_OPC_SELECT] ==
				    `OR1K_SYSTRAPSYNC_OPC_SYSCALL;

   assign decode_except_trap_o = opc_insn == `OR1K_OPCODE_SYSTRAPSYNC &&
				 decode_insn_i[`OR1K_SYSTRAPSYNC_OPC_SELECT] ==
				 `OR1K_SYSTRAPSYNC_OPC_TRAP;

   // Illegal instruction decode
   always @*
     case (opc_insn)
       `OR1K_OPCODE_J,
       `OR1K_OPCODE_JAL,
       `OR1K_OPCODE_BNF,
       `OR1K_OPCODE_BF,
       `OR1K_OPCODE_MOVHI,
       `OR1K_OPCODE_RFE,
       `OR1K_OPCODE_JR,
       `OR1K_OPCODE_JALR,
       `OR1K_OPCODE_LWZ,
       `OR1K_OPCODE_LWS,
       `OR1K_OPCODE_LBZ,
       `OR1K_OPCODE_LBS,
       `OR1K_OPCODE_LHZ,
       `OR1K_OPCODE_LHS,
       `OR1K_OPCODE_ADDI,
       `OR1K_OPCODE_ANDI,
       `OR1K_OPCODE_ORI,
       `OR1K_OPCODE_XORI,
       `OR1K_OPCODE_MFSPR,
       /*
	`OR1K_OPCODE_SLLI,
	`OR1K_OPCODE_SRLI,
	`OR1K_OPCODE_SRAI,
	`OR1K_OPCODE_RORI,
	*/
       `OR1K_OPCODE_SFIMM,
       `OR1K_OPCODE_MTSPR,
       `OR1K_OPCODE_SW,
       `OR1K_OPCODE_SB,
       `OR1K_OPCODE_SH,
       /*
	`OR1K_OPCODE_SFEQ,
	`OR1K_OPCODE_SFNE,
	`OR1K_OPCODE_SFGTU,
	`OR1K_OPCODE_SFGEU,
	`OR1K_OPCODE_SFLTU,
	`OR1K_OPCODE_SFLEU,
	`OR1K_OPCODE_SFGTS,
	`OR1K_OPCODE_SFGES,
	`OR1K_OPCODE_SFLTS,
	`OR1K_OPCODE_SFLES,
	*/
       `OR1K_OPCODE_SF,
       `OR1K_OPCODE_NOP:
	 decode_except_illegal_o = 1'b0;

       `OR1K_OPCODE_SWA,
       `OR1K_OPCODE_LWA:
	 decode_except_illegal_o = (FEATURE_ATOMIC=="NONE");

       `OR1K_OPCODE_CUST1:
	 decode_except_illegal_o = (FEATURE_CUST1=="NONE");
       `OR1K_OPCODE_CUST2:
	 decode_except_illegal_o = (FEATURE_CUST2=="NONE");
       `OR1K_OPCODE_CUST3:
	 decode_except_illegal_o = (FEATURE_CUST3=="NONE");
       `OR1K_OPCODE_CUST4:
	 decode_except_illegal_o = (FEATURE_CUST4=="NONE");
       `OR1K_OPCODE_CUST5:
	 decode_except_illegal_o = (FEATURE_CUST5=="NONE");
       `OR1K_OPCODE_CUST6:
	 decode_except_illegal_o = (FEATURE_CUST6=="NONE");
       `OR1K_OPCODE_CUST7:
	 decode_except_illegal_o = (FEATURE_CUST7=="NONE");
       `OR1K_OPCODE_CUST8:
	 decode_except_illegal_o = (FEATURE_CUST8=="NONE");
       `OR1K_OPCODE_FPU:
	 decode_except_illegal_o = (FEATURE_FPU=="NONE") |
                             decode_insn_i[`OR1K_FPUOP_DOUBLE_BIT];

       `OR1K_OPCODE_LD,
	 `OR1K_OPCODE_SD:
	   decode_except_illegal_o = !(OPTION_OPERAND_WIDTH==64);

       `OR1K_OPCODE_ADDIC:
	 decode_except_illegal_o = (FEATURE_ADDC=="NONE");

       //`OR1K_OPCODE_MACRC, // Same as movhi - check!
       `OR1K_OPCODE_MACI,
	 `OR1K_OPCODE_MAC:
	   decode_except_illegal_o = (FEATURE_MAC=="NONE");

       `OR1K_OPCODE_MULI:
	 decode_except_illegal_o = (FEATURE_MULTIPLIER=="NONE");

       `OR1K_OPCODE_SHRTI:
	 case(decode_insn_i[`OR1K_ALU_OPC_SECONDARY_SELECT])
	   `OR1K_ALU_OPC_SECONDARY_SHRT_SLL,
	   `OR1K_ALU_OPC_SECONDARY_SHRT_SRL:
	     decode_except_illegal_o = 1'b0;
	   `OR1K_ALU_OPC_SECONDARY_SHRT_SRA:
	     decode_except_illegal_o = (FEATURE_SRA=="NONE");

	   `OR1K_ALU_OPC_SECONDARY_SHRT_ROR:
	     decode_except_illegal_o = (FEATURE_ROR=="NONE");
	   default:
	     decode_except_illegal_o = 1'b1;
	 endcase // case (decode_insn_i[`OR1K_ALU_OPC_SECONDARY_SELECT])

       `OR1K_OPCODE_ALU:
	 case(decode_insn_i[`OR1K_ALU_OPC_SELECT])
	   `OR1K_ALU_OPC_ADD,
	   `OR1K_ALU_OPC_SUB,
	   `OR1K_ALU_OPC_OR,
	   `OR1K_ALU_OPC_XOR,
	   `OR1K_ALU_OPC_AND:
	     decode_except_illegal_o = 1'b0;
	   `OR1K_ALU_OPC_CMOV:
	     decode_except_illegal_o = (FEATURE_CMOV=="NONE");
	   `OR1K_ALU_OPC_FFL1:
	     decode_except_illegal_o = (FEATURE_FFL1=="NONE");
	   `OR1K_ALU_OPC_DIV,
	     `OR1K_ALU_OPC_DIVU:
	       decode_except_illegal_o = (FEATURE_DIVIDER=="NONE");
	   `OR1K_ALU_OPC_ADDC:
	     decode_except_illegal_o = (FEATURE_ADDC=="NONE");
	   `OR1K_ALU_OPC_MUL,
	     `OR1K_ALU_OPC_MULU:
	       decode_except_illegal_o = (FEATURE_MULTIPLIER=="NONE");
	   `OR1K_ALU_OPC_EXTBH,
	     `OR1K_ALU_OPC_EXTW:
	       decode_except_illegal_o = (FEATURE_EXT=="NONE");
	   `OR1K_ALU_OPC_SHRT:
	     case(decode_insn_i[`OR1K_ALU_OPC_SECONDARY_SELECT])
	       `OR1K_ALU_OPC_SECONDARY_SHRT_SLL,
	       `OR1K_ALU_OPC_SECONDARY_SHRT_SRL:
		 decode_except_illegal_o = 1'b0;
	       `OR1K_ALU_OPC_SECONDARY_SHRT_SRA:
		 decode_except_illegal_o = (FEATURE_SRA=="NONE");
	       `OR1K_ALU_OPC_SECONDARY_SHRT_ROR:
		 decode_except_illegal_o = (FEATURE_ROR=="NONE");
	       default:
		 decode_except_illegal_o = 1'b1;
	     endcase // case (decode_insn_i[`OR1K_ALU_OPC_SECONDARY_SELECT])
	   default:
	     decode_except_illegal_o = 1'b1;
	 endcase // case (decode_insn_i[`OR1K_ALU_OPC_SELECT])

       `OR1K_OPCODE_SYSTRAPSYNC: begin
	  if ((decode_insn_i[`OR1K_SYSTRAPSYNC_OPC_SELECT] ==
	       `OR1K_SYSTRAPSYNC_OPC_SYSCALL &&
	       FEATURE_SYSCALL=="ENABLED") ||
	      (decode_insn_i[`OR1K_SYSTRAPSYNC_OPC_SELECT] ==
	       `OR1K_SYSTRAPSYNC_OPC_TRAP &&
	       FEATURE_TRAP=="ENABLED") ||
	      (decode_insn_i[`OR1K_SYSTRAPSYNC_OPC_SELECT] ==
	       `OR1K_SYSTRAPSYNC_OPC_MSYNC) ||
	      (decode_insn_i[`OR1K_SYSTRAPSYNC_OPC_SELECT] ==
	       `OR1K_SYSTRAPSYNC_OPC_PSYNC &&
	       FEATURE_PSYNC!="NONE") ||
	      (decode_insn_i[`OR1K_SYSTRAPSYNC_OPC_SELECT] ==
	       `OR1K_SYSTRAPSYNC_OPC_CSYNC &&
	       FEATURE_CSYNC!="NONE"))
	    decode_except_illegal_o = 1'b0;
	  else
	    decode_except_illegal_o = 1'b1;
       end // case: endcase...
       default:
	 decode_except_illegal_o = 1'b1;

     endcase // case (decode_insn_i[`OR1K_OPCODE_SELECT])

   // Adder control logic
   // Subtract when comparing to check if equal
   assign decode_adder_do_sub_o = (opc_insn == `OR1K_OPCODE_ALU &
				   opc_alu == `OR1K_ALU_OPC_SUB) |
				  decode_op_setflag_o;

   // Generate carry-in select
   assign decode_adder_do_carry_o = (FEATURE_ADDC!="NONE") &&
				    ((opc_insn == `OR1K_OPCODE_ALU &
				      opc_alu == `OR1K_ALU_OPC_ADDC) ||
				     (opc_insn == `OR1K_OPCODE_ADDIC));



/*----------------------Formal Checking---------------------*/

`ifdef FORMAL

    wire [30:0] f_set_of_opcodes;
    assign f_set_of_opcodes = {decode_op_lsu_load_o, decode_op_lsu_store_o,
                                   decode_op_mfspr_o, decode_op_mtspr_o,
                                   decode_op_rfe_o, decode_op_setflag_o,
                                   decode_op_add_o, decode_op_mul_signed_o,
                                   decode_op_mul_unsigned_o,
                                   decode_op_div_signed_o,
                                   decode_op_ext_o, decode_op_div_unsigned_o,
                                   decode_op_shift_o, decode_op_ffl1_o,
                                   decode_op_movhi_o, decode_op_msync_o,
                                   decode_op_branch_o};

   //one instruction => one opcode
   always @(*)
      assert ($onehot0(f_set_of_opcodes));

`endif
endmodule // mor1kx_decode
