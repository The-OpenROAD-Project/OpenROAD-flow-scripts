/* ****************************************************************************
  SPDX-License-Identifier: CERN-OHL-W-2.0

  Description: "Pronto espresso" pipeline CPU module

  Copyright (C) 2012 Authors

  Author(s): Julius Baxter <juliusbaxter@gmail.com>

***************************************************************************** */

`include "mor1kx-defines.v"

module mor1kx_cpu_prontoespresso
  #(
    parameter OPTION_OPERAND_WIDTH	= 32,

    parameter FEATURE_DATACACHE		= "NONE",
    parameter OPTION_DCACHE_BLOCK_WIDTH	= 5,
    parameter OPTION_DCACHE_SET_WIDTH	= 9,
    parameter OPTION_DCACHE_WAYS	= 2,
    parameter FEATURE_DMMU		= "NONE",
    parameter FEATURE_DMMU_HW_TLB_RELOAD = "NONE",
    parameter FEATURE_INSTRUCTIONCACHE	= "NONE",
    parameter OPTION_ICACHE_BLOCK_WIDTH	= 5,
    parameter OPTION_ICACHE_SET_WIDTH	= 9,
    parameter OPTION_ICACHE_WAYS	= 2,
    parameter FEATURE_IMMU		= "NONE",
    parameter FEATURE_IMMU_HW_TLB_RELOAD = "NONE",
    parameter FEATURE_TIMER		= "ENABLED",
    parameter FEATURE_DEBUGUNIT		= "NONE",
    parameter FEATURE_PERFCOUNTERS	= "NONE",
    parameter FEATURE_MAC		= "NONE",

    parameter FEATURE_SYSCALL		= "ENABLED",
    parameter FEATURE_TRAP		= "ENABLED",
    parameter FEATURE_RANGE		= "ENABLED",

    parameter FEATURE_PIC		= "ENABLED",
    parameter OPTION_PIC_TRIGGER	= "LEVEL",
    parameter OPTION_PIC_NMI_WIDTH	= 0,

    parameter FEATURE_DSX		= "NONE",
    parameter FEATURE_FASTCONTEXTS	= "NONE",
    parameter FEATURE_OVERFLOW		= "NONE",
    parameter FEATURE_CARRY_FLAG	= "ENABLED",

    parameter OPTION_RF_ADDR_WIDTH	= 5,
    parameter OPTION_RF_WORDS		= 32,

    parameter OPTION_RESET_PC		= {{(OPTION_OPERAND_WIDTH-13){1'b0}},
					   `OR1K_RESET_VECTOR,8'd0},

    parameter OPTION_TCM_FETCHER = "DISABLED",

    parameter FEATURE_MULTIPLIER	= "THREESTAGE",
    parameter FEATURE_DIVIDER		= "NONE",

    parameter FEATURE_ADDC		= "NONE",
    parameter FEATURE_SRA		= "ENABLED",
    parameter FEATURE_ROR		= "NONE",
    parameter FEATURE_EXT		= "NONE",
    parameter FEATURE_CMOV		= "NONE",
    parameter FEATURE_FFL1		= "NONE",
    parameter FEATURE_MSYNC		= "NONE",
    parameter FEATURE_PSYNC		= "NONE",
    parameter FEATURE_CSYNC		= "NONE",

    parameter FEATURE_CUST1		= "NONE",
    parameter FEATURE_CUST2		= "NONE",
    parameter FEATURE_CUST3		= "NONE",
    parameter FEATURE_CUST4		= "NONE",
    parameter FEATURE_CUST5		= "NONE",
    parameter FEATURE_CUST6		= "NONE",
    parameter FEATURE_CUST7		= "NONE",
    parameter FEATURE_CUST8		= "NONE",

    parameter OPTION_SHIFTER		= "BARREL",

    parameter FEATURE_MULTICORE = "NONE",

    parameter FEATURE_TRACEPORT_EXEC = "NONE"
   )
   (
    input 			      clk,
    input 			      rst,

    // Instruction bus
    input 			      ibus_err_i,
    input 			      ibus_ack_i,
    input [`OR1K_INSN_WIDTH-1:0]      ibus_dat_i,
    output [OPTION_OPERAND_WIDTH-1:0] ibus_adr_o,
    output 			      ibus_req_o,
    output 			      ibus_burst_o,

    // Data bus
    input 			      dbus_err_i,
    input 			      dbus_ack_i,
    input [OPTION_OPERAND_WIDTH-1:0]  dbus_dat_i,
    output [OPTION_OPERAND_WIDTH-1:0] dbus_adr_o,
    output [OPTION_OPERAND_WIDTH-1:0] dbus_dat_o,
    output 			      dbus_req_o,
    output [3:0] 		      dbus_bsel_o,
    output 			      dbus_we_o,
    output 			      dbus_burst_o,

    // Interrupts
    input [31:0] 		      irq_i,

    // Debug interface
    input [15:0] 		      du_addr_i,
    input 			      du_stb_i,
    input [OPTION_OPERAND_WIDTH-1:0]  du_dat_i,
    input 			      du_we_i,
    output [OPTION_OPERAND_WIDTH-1:0] du_dat_o,
    output 			      du_ack_o,
    // Stall control from debug interface
    input 			      du_stall_i,
    output 			      du_stall_o,

    // SPR accesses to external units (cache, mmu, etc.)
    output [15:0] 		      spr_bus_addr_o,
    output 			      spr_bus_we_o,
    output 			      spr_bus_stb_o,
    output [OPTION_OPERAND_WIDTH-1:0] spr_bus_dat_o,
    input [OPTION_OPERAND_WIDTH-1:0]  spr_bus_dat_dmmu_i,
    input 			      spr_bus_ack_dmmu_i,
    input [OPTION_OPERAND_WIDTH-1:0]  spr_bus_dat_immu_i,
    input 			      spr_bus_ack_immu_i,
    input [OPTION_OPERAND_WIDTH-1:0]  spr_bus_dat_mac_i,
    input 			      spr_bus_ack_mac_i,
    input [OPTION_OPERAND_WIDTH-1:0]  spr_bus_dat_pmu_i,
    input 			      spr_bus_ack_pmu_i,
    input [OPTION_OPERAND_WIDTH-1:0]  spr_bus_dat_pcu_i,
    input 			      spr_bus_ack_pcu_i,
    input [OPTION_OPERAND_WIDTH-1:0]  spr_bus_dat_fpu_i,
    input 			      spr_bus_ack_fpu_i,
    output [15:0] 		      spr_sr_o,

    // The multicore core identifier
    input [OPTION_OPERAND_WIDTH-1:0] multicore_coreid_i
    );

   wire [OPTION_OPERAND_WIDTH-1:0]   pc_fetch_to_decode;
   wire [`OR1K_INSN_WIDTH-1:0] 	     insn_fetch_to_decode;
   wire [OPTION_OPERAND_WIDTH-1:0]   pc_decode_to_execute;
   wire [OPTION_OPERAND_WIDTH-1:0]   pc_execute_to_ctrl;

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [OPTION_OPERAND_WIDTH-1:0] adder_result_o;// From mor1kx_execute_alu of mor1kx_execute_alu.v
   wire [OPTION_OPERAND_WIDTH-1:0] alu_result_o;// From mor1kx_execute_alu of mor1kx_execute_alu.v
   wire			alu_valid_o;		// From mor1kx_execute_alu of mor1kx_execute_alu.v
   wire			carry_clear_o;		// From mor1kx_execute_alu of mor1kx_execute_alu.v
   wire			carry_o;		// From mor1kx_ctrl_prontoespresso of mor1kx_ctrl_prontoespresso.v
   wire			carry_set_o;		// From mor1kx_execute_alu of mor1kx_execute_alu.v
   wire			ctrl_branch_occur_o;	// From mor1kx_ctrl_prontoespresso of mor1kx_ctrl_prontoespresso.v
   wire [OPTION_OPERAND_WIDTH-1:0] ctrl_branch_target_o;// From mor1kx_ctrl_prontoespresso of mor1kx_ctrl_prontoespresso.v
   wire			ctrl_insn_done_o;	// From mor1kx_ctrl_prontoespresso of mor1kx_ctrl_prontoespresso.v
   wire			ctrl_mfspr_we_o;	// From mor1kx_ctrl_prontoespresso of mor1kx_ctrl_prontoespresso.v
   wire			decode_adder_do_carry_o;// From mor1kx_decode of mor1kx_decode.v
   wire			decode_adder_do_sub_o;	// From mor1kx_decode of mor1kx_decode.v
   wire			decode_except_ibus_err_o;// From mor1kx_fetch_prontoespresso of mor1kx_fetch_tcm_prontoespresso.v, ...
   wire			decode_except_illegal_o;// From mor1kx_decode of mor1kx_decode.v
   wire			decode_except_syscall_o;// From mor1kx_decode of mor1kx_decode.v
   wire			decode_except_trap_o;	// From mor1kx_decode of mor1kx_decode.v
   wire [`OR1K_IMM_WIDTH-1:0] decode_imm16_o;	// From mor1kx_decode of mor1kx_decode.v
   wire [OPTION_OPERAND_WIDTH-1:0] decode_immediate_o;// From mor1kx_decode of mor1kx_decode.v
   wire			decode_immediate_sel_o;	// From mor1kx_decode of mor1kx_decode.v
   wire [9:0]		decode_immjbr_upper_o;	// From mor1kx_decode of mor1kx_decode.v
   wire [1:0]		decode_lsu_length_o;	// From mor1kx_decode of mor1kx_decode.v
   wire			decode_lsu_zext_o;	// From mor1kx_decode of mor1kx_decode.v
   wire			decode_op_add_o;	// From mor1kx_decode of mor1kx_decode.v
   wire			decode_op_alu_o;	// From mor1kx_decode of mor1kx_decode.v
   wire			decode_op_bf_o;		// From mor1kx_decode of mor1kx_decode.v
   wire			decode_op_bnf_o;	// From mor1kx_decode of mor1kx_decode.v
   wire			decode_op_branch_o;	// From mor1kx_decode of mor1kx_decode.v
   wire			decode_op_brcond_o;	// From mor1kx_decode of mor1kx_decode.v
   wire			decode_op_div_o;	// From mor1kx_decode of mor1kx_decode.v
   wire			decode_op_div_signed_o;	// From mor1kx_decode of mor1kx_decode.v
   wire			decode_op_div_unsigned_o;// From mor1kx_decode of mor1kx_decode.v
   wire			decode_op_ffl1_o;	// From mor1kx_decode of mor1kx_decode.v
   wire [`OR1K_FPUOP_WIDTH-1:0] decode_op_fpu_o;// From mor1kx_decode of mor1kx_decode.v
   wire			decode_op_jal_o;	// From mor1kx_decode of mor1kx_decode.v
   wire			decode_op_jbr_o;	// From mor1kx_decode of mor1kx_decode.v
   wire			decode_op_jr_o;		// From mor1kx_decode of mor1kx_decode.v
   wire			decode_op_lsu_load_o;	// From mor1kx_decode of mor1kx_decode.v
   wire			decode_op_lsu_store_o;	// From mor1kx_decode of mor1kx_decode.v
   wire			decode_op_mfspr_o;	// From mor1kx_decode of mor1kx_decode.v
   wire			decode_op_movhi_o;	// From mor1kx_decode of mor1kx_decode.v
   wire			decode_op_ext_o;	// From mor1kx_decode of mor1kx_decode.v
   wire			decode_op_msync_o;	// From mor1kx_decode of mor1kx_decode.v
   wire			decode_op_mtspr_o;	// From mor1kx_decode of mor1kx_decode.v
   wire			decode_op_mul_o;	// From mor1kx_decode of mor1kx_decode.v
   wire			decode_op_mul_signed_o;	// From mor1kx_decode of mor1kx_decode.v
   wire			decode_op_mul_unsigned_o;// From mor1kx_decode of mor1kx_decode.v
   wire			decode_op_rfe_o;	// From mor1kx_decode of mor1kx_decode.v
   wire			decode_op_setflag_o;	// From mor1kx_decode of mor1kx_decode.v
   wire			decode_op_shift_o;	// From mor1kx_decode of mor1kx_decode.v
   wire [`OR1K_ALU_OPC_WIDTH-1:0] decode_opc_alu_o;// From mor1kx_decode of mor1kx_decode.v
   wire [`OR1K_ALU_OPC_WIDTH-1:0] decode_opc_alu_secondary_o;// From mor1kx_decode of mor1kx_decode.v
   wire [`OR1K_OPCODE_WIDTH-1:0] decode_opc_insn_o;// From mor1kx_decode of mor1kx_decode.v
   wire			decode_rf_wb_o;		// From mor1kx_decode of mor1kx_decode.v
   wire [OPTION_RF_ADDR_WIDTH-1:0] decode_rfa_adr_o;// From mor1kx_decode of mor1kx_decode.v
   wire [OPTION_RF_ADDR_WIDTH-1:0] decode_rfb_adr_o;// From mor1kx_decode of mor1kx_decode.v
   wire [OPTION_RF_ADDR_WIDTH-1:0] decode_rfd_adr_o;// From mor1kx_decode of mor1kx_decode.v
   wire			du_restart_o;		// From mor1kx_ctrl_prontoespresso of mor1kx_ctrl_prontoespresso.v
   wire [OPTION_OPERAND_WIDTH-1:0] du_restart_pc_o;// From mor1kx_ctrl_prontoespresso of mor1kx_ctrl_prontoespresso.v
   wire			exception_taken_o;	// From mor1kx_ctrl_prontoespresso of mor1kx_ctrl_prontoespresso.v
   wire			execute_waiting_o;	// From mor1kx_ctrl_prontoespresso of mor1kx_ctrl_prontoespresso.v
   wire			fetch_quick_branch_o;	// From mor1kx_fetch_prontoespresso of mor1kx_fetch_prontoespresso.v
   wire			fetch_ready_o;		// From mor1kx_fetch_prontoespresso of mor1kx_fetch_tcm_prontoespresso.v, ...
   wire			fetch_rf_re_o;		// From mor1kx_fetch_prontoespresso of mor1kx_fetch_tcm_prontoespresso.v, ...
   wire [OPTION_RF_ADDR_WIDTH-1:0] fetch_rfa_adr_o;// From mor1kx_fetch_prontoespresso of mor1kx_fetch_tcm_prontoespresso.v, ...
   wire [OPTION_RF_ADDR_WIDTH-1:0] fetch_rfb_adr_o;// From mor1kx_fetch_prontoespresso of mor1kx_fetch_tcm_prontoespresso.v, ...
   wire			fetch_sleep_o;		// From mor1kx_fetch_prontoespresso of mor1kx_fetch_tcm_prontoespresso.v, ...
   wire			fetch_take_exception_branch_o;// From mor1kx_ctrl_prontoespresso of mor1kx_ctrl_prontoespresso.v
   wire [OPTION_OPERAND_WIDTH-1:0] fetched_pc_o;// From mor1kx_fetch_prontoespresso of mor1kx_fetch_tcm_prontoespresso.v, ...
   wire			flag_clear_o;		// From mor1kx_execute_alu of mor1kx_execute_alu.v
   wire			flag_o;			// From mor1kx_ctrl_prontoespresso of mor1kx_ctrl_prontoespresso.v
   wire			flag_set_o;		// From mor1kx_execute_alu of mor1kx_execute_alu.v
   wire [`OR1K_FPCSR_WIDTH-1:0] fpcsr_o;	// From mor1kx_execute_alu of mor1kx_execute_alu.v
   wire			fpcsr_set_o;		// From mor1kx_execute_alu of mor1kx_execute_alu.v
   wire [OPTION_OPERAND_WIDTH-1:0] link_addr_o;	// From mor1kx_ctrl_prontoespresso of mor1kx_ctrl_prontoespresso.v
   wire			lsu_except_align_o;	// From mor1kx_lsu_espresso of mor1kx_lsu_espresso.v
   wire			lsu_except_dbus_o;	// From mor1kx_lsu_espresso of mor1kx_lsu_espresso.v
   wire [OPTION_OPERAND_WIDTH-1:0] lsu_result_o;// From mor1kx_lsu_espresso of mor1kx_lsu_espresso.v
   wire			lsu_valid_o;		// From mor1kx_lsu_espresso of mor1kx_lsu_espresso.v
   wire [OPTION_OPERAND_WIDTH-1:0] mfspr_dat_o;	// From mor1kx_ctrl_prontoespresso of mor1kx_ctrl_prontoespresso.v
   wire [OPTION_OPERAND_WIDTH-1:0] mul_result_o;// From mor1kx_execute_alu of mor1kx_execute_alu.v
   wire			overflow_clear_o;	// From mor1kx_execute_alu of mor1kx_execute_alu.v
   wire			overflow_set_o;		// From mor1kx_execute_alu of mor1kx_execute_alu.v
   wire			padv_decode_o;		// From mor1kx_ctrl_prontoespresso of mor1kx_ctrl_prontoespresso.v
   wire			padv_execute_o;		// From mor1kx_ctrl_prontoespresso of mor1kx_ctrl_prontoespresso.v
   wire			padv_fetch_o;		// From mor1kx_ctrl_prontoespresso of mor1kx_ctrl_prontoespresso.v
   wire [OPTION_OPERAND_WIDTH-1:0] pc_fetch_next_o;// From mor1kx_fetch_prontoespresso of mor1kx_fetch_tcm_prontoespresso.v, ...
   wire			pipeline_flush_o;	// From mor1kx_ctrl_prontoespresso of mor1kx_ctrl_prontoespresso.v
   wire [OPTION_OPERAND_WIDTH-1:0] rf_result_o;	// From mor1kx_wb_mux_espresso of mor1kx_wb_mux_espresso.v
   wire			rf_we_o;		// From mor1kx_ctrl_prontoespresso of mor1kx_ctrl_prontoespresso.v
   wire [OPTION_OPERAND_WIDTH-1:0] rfa_o;	// From mor1kx_rf_espresso of mor1kx_rf_espresso.v
   wire [OPTION_OPERAND_WIDTH-1:0] rfb_o;	// From mor1kx_rf_espresso of mor1kx_rf_espresso.v
   wire			spr_bus_ack_ic_i;	// From mor1kx_fetch_prontoespresso of mor1kx_fetch_prontoespresso.v
   wire [OPTION_OPERAND_WIDTH-1:0] spr_bus_dat_ic_i;// From mor1kx_fetch_prontoespresso of mor1kx_fetch_prontoespresso.v
   wire [OPTION_OPERAND_WIDTH-1:0] spr_npc_o;	// From mor1kx_ctrl_prontoespresso of mor1kx_ctrl_prontoespresso.v
   wire [OPTION_OPERAND_WIDTH-1:0] spr_ppc_o;	// From mor1kx_ctrl_prontoespresso of mor1kx_ctrl_prontoespresso.v
   wire			stepping_o;		// From mor1kx_ctrl_prontoespresso of mor1kx_ctrl_prontoespresso.v
   // End of automatics

   generate
      if (OPTION_TCM_FETCHER=="ENABLED")
	begin : fetch_tcm

	   /* mor1kx_fetch_tcm_prontoespresso AUTO_TEMPLATE (
	    .padv_i				(padv_fetch_o),
	    .branch_occur_i			(ctrl_branch_occur_o),
	    .branch_dest_i			(ctrl_branch_target_o),
	    .pipeline_flush_i			(pipeline_flush_o),
	    .pc_decode_o                        (pc_fetch_to_decode),
	    .decode_insn_o                      (insn_fetch_to_decode),
	    .du_restart_pc_i                    (du_restart_pc_o),
	    .du_restart_i                       (du_restart_o),
	    .fetch_take_exception_branch_i      (fetch_take_exception_branch_o),
	    .execute_waiting_i                  (execute_waiting_o),
	    .stepping_i                         (stepping_o),
	    .flag_i				(flag_o),
	    .flag_clear_i			(flag_clear_o),
	    .flag_set_i			        (flag_set_o),
	    ); */
	   mor1kx_fetch_tcm_prontoespresso
	     #(
	       .OPTION_OPERAND_WIDTH(OPTION_OPERAND_WIDTH),
	       .OPTION_RF_ADDR_WIDTH(OPTION_RF_ADDR_WIDTH),
	       .OPTION_RESET_PC(OPTION_RESET_PC)
	       )
	   mor1kx_fetch_prontoespresso
	     (/*AUTOINST*/
	      // Outputs
	      .ibus_adr_o		(ibus_adr_o[OPTION_OPERAND_WIDTH-1:0]),
	      .ibus_req_o		(ibus_req_o),
	      .decode_insn_o		(insn_fetch_to_decode),	 // Templated
	      .fetched_pc_o		(fetched_pc_o[OPTION_OPERAND_WIDTH-1:0]),
	      .fetch_ready_o		(fetch_ready_o),
	      .fetch_rfa_adr_o		(fetch_rfa_adr_o[OPTION_RF_ADDR_WIDTH-1:0]),
	      .fetch_rfb_adr_o		(fetch_rfb_adr_o[OPTION_RF_ADDR_WIDTH-1:0]),
	      .fetch_rf_re_o		(fetch_rf_re_o),
	      .pc_fetch_next_o		(pc_fetch_next_o[OPTION_OPERAND_WIDTH-1:0]),
	      .decode_except_ibus_err_o	(decode_except_ibus_err_o),
	      .fetch_sleep_o		(fetch_sleep_o),
	      // Inputs
	      .clk			(clk),
	      .rst			(rst),
	      .ibus_err_i		(ibus_err_i),
	      .ibus_ack_i		(ibus_ack_i),
	      .ibus_dat_i		(ibus_dat_i[`OR1K_INSN_WIDTH-1:0]),
	      .padv_i			(padv_fetch_o),		 // Templated
	      .branch_occur_i		(ctrl_branch_occur_o),	 // Templated
	      .branch_dest_i		(ctrl_branch_target_o),	 // Templated
	      .du_restart_i		(du_restart_o),		 // Templated
	      .du_restart_pc_i		(du_restart_pc_o),	 // Templated
	      .fetch_take_exception_branch_i(fetch_take_exception_branch_o), // Templated
	      .execute_waiting_i	(execute_waiting_o),	 // Templated
	      .du_stall_i		(du_stall_i),
	      .stepping_i		(stepping_o),		 // Templated
	      .flag_i			(flag_o),		 // Templated
	      .flag_clear_i		(flag_clear_o),		 // Templated
	      .flag_set_i		(flag_set_o));		 // Templated

	end
      else
	begin : fetch

	   /* mor1kx_fetch_prontoespresso AUTO_TEMPLATE (
	    .padv_i				(padv_fetch_o),
	    .branch_occur_i			(ctrl_branch_occur_o),
	    .branch_dest_i			(ctrl_branch_target_o),
	    .ctrl_insn_done_i                   (ctrl_insn_done_o),
	    .pipeline_flush_i			(pipeline_flush_o),
	    .pc_decode_o                        (pc_fetch_to_decode),
	    .decode_insn_o                      (insn_fetch_to_decode),
	    .du_restart_pc_i                    (du_restart_pc_o),
	    .du_restart_i                       (du_restart_o),
	    .fetch_take_exception_branch_i      (fetch_take_exception_branch_o),
	    .execute_waiting_i                  (execute_waiting_o),
	    .stepping_i                         (stepping_o),
	    .flag_i				(flag_o),
	    .flag_clear_i			(flag_clear_o),
	    .flag_set_i			        (flag_set_o),
	    .spr_bus_dat_ic_o			(spr_bus_dat_ic_i[OPTION_OPERAND_WIDTH-1:0]),
	    .spr_bus_ack_ic_o			(spr_bus_ack_ic_i),
	    .spr_bus_addr_i			(spr_bus_addr_o[15:0]),
	    .spr_bus_we_i			(spr_bus_we_o),
	    .spr_bus_stb_i			(spr_bus_stb_o),
	    .spr_bus_dat_i			(spr_bus_dat_o[OPTION_OPERAND_WIDTH-1:0]),
	    .ic_enable				(spr_sr_o[`OR1K_SPR_SR_ICE]),
	    ); */
	   mor1kx_fetch_prontoespresso
	     #(
	       .OPTION_OPERAND_WIDTH(OPTION_OPERAND_WIDTH),
	       .OPTION_RF_ADDR_WIDTH(OPTION_RF_ADDR_WIDTH),
	       .OPTION_RESET_PC(OPTION_RESET_PC),
	       .FEATURE_INSTRUCTIONCACHE(FEATURE_INSTRUCTIONCACHE),
	       .OPTION_ICACHE_BLOCK_WIDTH(OPTION_ICACHE_BLOCK_WIDTH)
	       )
	   mor1kx_fetch_prontoespresso
	     (/*AUTOINST*/
	      // Outputs
	      .ibus_adr_o		(ibus_adr_o[OPTION_OPERAND_WIDTH-1:0]),
	      .ibus_req_o		(ibus_req_o),
	      .ibus_burst_o		(ibus_burst_o),
	      .decode_insn_o		(insn_fetch_to_decode),	 // Templated
	      .fetched_pc_o		(fetched_pc_o[OPTION_OPERAND_WIDTH-1:0]),
	      .fetch_ready_o		(fetch_ready_o),
	      .fetch_rfa_adr_o		(fetch_rfa_adr_o[OPTION_RF_ADDR_WIDTH-1:0]),
	      .fetch_rfb_adr_o		(fetch_rfb_adr_o[OPTION_RF_ADDR_WIDTH-1:0]),
	      .fetch_rf_re_o		(fetch_rf_re_o),
	      .pc_fetch_next_o		(pc_fetch_next_o[OPTION_OPERAND_WIDTH-1:0]),
	      .decode_except_ibus_err_o	(decode_except_ibus_err_o),
	      .fetch_sleep_o		(fetch_sleep_o),
	      .fetch_quick_branch_o	(fetch_quick_branch_o),
	      .spr_bus_dat_ic_o		(spr_bus_dat_ic_i[OPTION_OPERAND_WIDTH-1:0]), // Templated
	      .spr_bus_ack_ic_o		(spr_bus_ack_ic_i),	 // Templated
	      // Inputs
	      .clk			(clk),
	      .rst			(rst),
	      .ibus_err_i		(ibus_err_i),
	      .ibus_ack_i		(ibus_ack_i),
	      .ibus_dat_i		(ibus_dat_i[`OR1K_INSN_WIDTH-1:0]),
	      .ic_enable		(spr_sr_o[`OR1K_SPR_SR_ICE]), // Templated
	      .padv_i			(padv_fetch_o),		 // Templated
	      .branch_occur_i		(ctrl_branch_occur_o),	 // Templated
	      .branch_dest_i		(ctrl_branch_target_o),	 // Templated
	      .ctrl_insn_done_i		(ctrl_insn_done_o),	 // Templated
	      .du_restart_i		(du_restart_o),		 // Templated
	      .du_restart_pc_i		(du_restart_pc_o),	 // Templated
	      .fetch_take_exception_branch_i(fetch_take_exception_branch_o), // Templated
	      .execute_waiting_i	(execute_waiting_o),	 // Templated
	      .du_stall_i		(du_stall_i),
	      .stepping_i		(stepping_o),		 // Templated
	      .flag_i			(flag_o),		 // Templated
	      .flag_clear_i		(flag_clear_o),		 // Templated
	      .flag_set_i		(flag_set_o),		 // Templated
	      .spr_bus_addr_i		(spr_bus_addr_o[15:0]),	 // Templated
	      .spr_bus_we_i		(spr_bus_we_o),		 // Templated
	      .spr_bus_stb_i		(spr_bus_stb_o),	 // Templated
	      .spr_bus_dat_i		(spr_bus_dat_o[OPTION_OPERAND_WIDTH-1:0])); // Templated
	end // else: !if(OPTION_TCM_FETCHER=="ENABLED")
   endgenerate

   /* mor1kx_decode AUTO_TEMPLATE (
    .decode_insn_i			(insn_fetch_to_decode),
    .decode_op_lsu_atomic_o             (),
    ); */
   mor1kx_decode
     #(
       .OPTION_OPERAND_WIDTH(OPTION_OPERAND_WIDTH),
       .OPTION_RESET_PC(OPTION_RESET_PC),
       .OPTION_RF_ADDR_WIDTH(OPTION_RF_ADDR_WIDTH),
       .FEATURE_SYSCALL(FEATURE_SYSCALL),
       .FEATURE_TRAP(FEATURE_TRAP),
       .FEATURE_RANGE(FEATURE_RANGE),
       .FEATURE_MAC(FEATURE_MAC),
       .FEATURE_MULTIPLIER(FEATURE_MULTIPLIER),
       .FEATURE_DIVIDER(FEATURE_DIVIDER),
       .FEATURE_ADDC(FEATURE_ADDC),
       .FEATURE_SRA(FEATURE_SRA),
       .FEATURE_ROR(FEATURE_ROR),
       .FEATURE_EXT(FEATURE_EXT),
       .FEATURE_CMOV(FEATURE_CMOV),
       .FEATURE_FFL1(FEATURE_FFL1),
       .FEATURE_MSYNC(FEATURE_MSYNC),
       .FEATURE_PSYNC(FEATURE_PSYNC),
       .FEATURE_CSYNC(FEATURE_CSYNC),
       .FEATURE_CUST1(FEATURE_CUST1),
       .FEATURE_CUST2(FEATURE_CUST2),
       .FEATURE_CUST3(FEATURE_CUST3),
       .FEATURE_CUST4(FEATURE_CUST4),
       .FEATURE_CUST5(FEATURE_CUST5),
       .FEATURE_CUST6(FEATURE_CUST6),
       .FEATURE_CUST7(FEATURE_CUST7),
       .FEATURE_CUST8(FEATURE_CUST8)
       )
     mor1kx_decode
     (/*AUTOINST*/
      // Outputs
      .decode_opc_alu_o			(decode_opc_alu_o[`OR1K_ALU_OPC_WIDTH-1:0]),
      .decode_opc_alu_secondary_o	(decode_opc_alu_secondary_o[`OR1K_ALU_OPC_WIDTH-1:0]),
      .decode_imm16_o			(decode_imm16_o[`OR1K_IMM_WIDTH-1:0]),
      .decode_immediate_o		(decode_immediate_o[OPTION_OPERAND_WIDTH-1:0]),
      .decode_immediate_sel_o		(decode_immediate_sel_o),
      .decode_immjbr_upper_o		(decode_immjbr_upper_o[9:0]),
      .decode_rfd_adr_o			(decode_rfd_adr_o[OPTION_RF_ADDR_WIDTH-1:0]),
      .decode_rfa_adr_o			(decode_rfa_adr_o[OPTION_RF_ADDR_WIDTH-1:0]),
      .decode_rfb_adr_o			(decode_rfb_adr_o[OPTION_RF_ADDR_WIDTH-1:0]),
      .decode_rf_wb_o			(decode_rf_wb_o),
      .decode_op_jbr_o			(decode_op_jbr_o),
      .decode_op_jr_o			(decode_op_jr_o),
      .decode_op_jal_o			(decode_op_jal_o),
      .decode_op_bf_o			(decode_op_bf_o),
      .decode_op_bnf_o			(decode_op_bnf_o),
      .decode_op_brcond_o		(decode_op_brcond_o),
      .decode_op_branch_o		(decode_op_branch_o),
      .decode_op_alu_o			(decode_op_alu_o),
      .decode_op_lsu_load_o		(decode_op_lsu_load_o),
      .decode_op_lsu_store_o		(decode_op_lsu_store_o),
      .decode_op_lsu_atomic_o		(),			 // Templated
      .decode_lsu_length_o		(decode_lsu_length_o[1:0]),
      .decode_lsu_zext_o		(decode_lsu_zext_o),
      .decode_op_mfspr_o		(decode_op_mfspr_o),
      .decode_op_mtspr_o		(decode_op_mtspr_o),
      .decode_op_rfe_o			(decode_op_rfe_o),
      .decode_op_setflag_o		(decode_op_setflag_o),
      .decode_op_add_o			(decode_op_add_o),
      .decode_op_mul_o			(decode_op_mul_o),
      .decode_op_mul_signed_o		(decode_op_mul_signed_o),
      .decode_op_mul_unsigned_o		(decode_op_mul_unsigned_o),
      .decode_op_div_o			(decode_op_div_o),
      .decode_op_div_signed_o		(decode_op_div_signed_o),
      .decode_op_div_unsigned_o		(decode_op_div_unsigned_o),
      .decode_op_shift_o		(decode_op_shift_o),
      .decode_op_ffl1_o			(decode_op_ffl1_o),
      .decode_op_movhi_o		(decode_op_movhi_o),
      .decode_op_ext_o			(decode_op_ext_o),
      .decode_op_msync_o		(decode_op_msync_o),
      .decode_op_fpu_o			(decode_op_fpu_o[`OR1K_FPUOP_WIDTH-1:0]),
      .decode_adder_do_sub_o		(decode_adder_do_sub_o),
      .decode_adder_do_carry_o		(decode_adder_do_carry_o),
      .decode_except_illegal_o		(decode_except_illegal_o),
      .decode_except_syscall_o		(decode_except_syscall_o),
      .decode_except_trap_o		(decode_except_trap_o),
      .decode_opc_insn_o		(decode_opc_insn_o[`OR1K_OPCODE_WIDTH-1:0]),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .decode_insn_i			(insn_fetch_to_decode));	 // Templated

   /* mor1kx_execute_alu AUTO_TEMPLATE (
    .padv_decode_i			(padv_decode_o),
    .padv_execute_i			(padv_execute_o),
    .pipeline_flush_i			(pipeline_flush_o),
    .opc_alu_i			        (decode_opc_alu_o),
    .opc_alu_secondary_i		(decode_opc_alu_secondary_o),
    .imm16_i				(decode_imm16_o),
    .immediate_i			(decode_immediate_o),
    .immediate_sel_i			(decode_immediate_sel_o),
    .decode_valid_i			(padv_decode_o),
    .decode_immediate_i		        (decode_immediate_o),
    .decode_immediate_sel_i		(decode_immediate_sel_o),
    .decode_op_mul_i			(decode_op_mul_o),
    .op_alu_i				(decode_op_alu_o),
    .op_add_i				(decode_op_add_o),
    .op_mul_i				(decode_op_mul_o),
    .op_mul_signed_i			(decode_op_mul_signed_o),
    .op_mul_unsigned_i			(decode_op_mul_unsigned_o),
    .op_div_i				(decode_op_div_o),
    .op_div_signed_i			(decode_op_div_signed_o),
    .op_div_unsigned_i			(decode_op_div_unsigned_o),
    .op_shift_i				(decode_op_shift_o),
    .op_ffl1_i				(decode_op_ffl1_o),
    .op_setflag_i			(decode_op_setflag_o),
    .op_mtspr_i				(decode_op_mtspr_o),
    .op_mfspr_i				(decode_op_mfspr_o),
    .op_movhi_i				(decode_op_movhi_o),
    .op_ext_i				(decode_op_ext_o),
    .op_jbr_i				(decode_op_jbr_o),
    .op_jr_i				(decode_op_jr_o),
    .op_fpu_i				(decode_op_fpu_o),
    .fpu_round_mode_i                   (2'b00),
    .immjbr_upper_i			(decode_immjbr_upper_o),
    .pc_execute_i			(spr_ppc_o),
    .adder_do_sub_i			(decode_adder_do_sub_o),
    .adder_do_carry_i			(decode_adder_do_carry_o),
    .decode_rfa_i			(rfa_o),
    .decode_rfb_i			(rfb_o),
    .rfa_i				(rfa_o),
    .rfb_i				(rfb_o),
    .flag_i                             (flag_o),
    .carry_i				(carry_o),
    ); */
   mor1kx_execute_alu
     #(
       .OPTION_OPERAND_WIDTH(OPTION_OPERAND_WIDTH),
       .FEATURE_MULTIPLIER(FEATURE_MULTIPLIER),
       .FEATURE_DIVIDER(FEATURE_DIVIDER),
       .FEATURE_ADDC(FEATURE_ADDC),
       .FEATURE_SRA(FEATURE_SRA),
       .FEATURE_ROR(FEATURE_ROR),
       .FEATURE_EXT(FEATURE_EXT),
       .FEATURE_CMOV(FEATURE_CMOV),
       .FEATURE_FFL1(FEATURE_FFL1),
       .FEATURE_CUST1(FEATURE_CUST1),
       .FEATURE_CUST2(FEATURE_CUST2),
       .FEATURE_CUST3(FEATURE_CUST3),
       .FEATURE_CUST4(FEATURE_CUST4),
       .FEATURE_CUST5(FEATURE_CUST5),
       .FEATURE_CUST6(FEATURE_CUST6),
       .FEATURE_CUST7(FEATURE_CUST7),
       .FEATURE_CUST8(FEATURE_CUST8),
       .OPTION_SHIFTER(OPTION_SHIFTER)
       )
     mor1kx_execute_alu
     (/*AUTOINST*/
      // Outputs
      .flag_set_o			(flag_set_o),
      .flag_clear_o			(flag_clear_o),
      .carry_set_o			(carry_set_o),
      .carry_clear_o			(carry_clear_o),
      .overflow_set_o			(overflow_set_o),
      .overflow_clear_o			(overflow_clear_o),
      .fpcsr_o				(fpcsr_o[`OR1K_FPCSR_WIDTH-1:0]),
      .fpcsr_set_o			(fpcsr_set_o),
      .alu_result_o			(alu_result_o[OPTION_OPERAND_WIDTH-1:0]),
      .alu_valid_o			(alu_valid_o),
      .mul_result_o			(mul_result_o[OPTION_OPERAND_WIDTH-1:0]),
      .adder_result_o			(adder_result_o[OPTION_OPERAND_WIDTH-1:0]),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .padv_decode_i			(padv_decode_o),	 // Templated
      .padv_execute_i			(padv_execute_o),	 // Templated
      .pipeline_flush_i			(pipeline_flush_o),	 // Templated
      .opc_alu_i			(decode_opc_alu_o),	 // Templated
      .opc_alu_secondary_i		(decode_opc_alu_secondary_o), // Templated
      .imm16_i				(decode_imm16_o),	 // Templated
      .immediate_i			(decode_immediate_o),	 // Templated
      .immediate_sel_i			(decode_immediate_sel_o), // Templated
      .decode_immediate_i		(decode_immediate_o),	 // Templated
      .decode_immediate_sel_i		(decode_immediate_sel_o), // Templated
      .decode_valid_i			(padv_decode_o),	 // Templated
      .decode_op_mul_i			(decode_op_mul_o),	 // Templated
      .op_alu_i				(decode_op_alu_o),	 // Templated
      .op_add_i				(decode_op_add_o),	 // Templated
      .op_mul_i				(decode_op_mul_o),	 // Templated
      .op_mul_signed_i			(decode_op_mul_signed_o), // Templated
      .op_mul_unsigned_i		(decode_op_mul_unsigned_o), // Templated
      .op_div_i				(decode_op_div_o),	 // Templated
      .op_div_signed_i			(decode_op_div_signed_o), // Templated
      .op_div_unsigned_i		(decode_op_div_unsigned_o), // Templated
      .op_shift_i			(decode_op_shift_o),	 // Templated
      .op_ffl1_i			(decode_op_ffl1_o),	 // Templated
      .op_setflag_i			(decode_op_setflag_o),	 // Templated
      .op_mtspr_i			(decode_op_mtspr_o),	 // Templated
      .op_mfspr_i			(decode_op_mfspr_o),	 // Templated
      .op_movhi_i			(decode_op_movhi_o),	 // Templated
      .op_ext_i				(decode_op_ext_o),	 // Templated
      .op_fpu_i				(decode_op_fpu_o),	 // Templated
      .fpu_round_mode_i			(2'b00),		 // Templated
      .op_jbr_i				(decode_op_jbr_o),	 // Templated
      .op_jr_i				(decode_op_jr_o),	 // Templated
      .immjbr_upper_i			(decode_immjbr_upper_o), // Templated
      .pc_execute_i			(spr_ppc_o),		 // Templated
      .adder_do_sub_i			(decode_adder_do_sub_o), // Templated
      .adder_do_carry_i			(decode_adder_do_carry_o), // Templated
      .decode_rfa_i			(rfa_o),		 // Templated
      .decode_rfb_i			(rfb_o),		 // Templated
      .rfa_i				(rfa_o),		 // Templated
      .rfb_i				(rfb_o),		 // Templated
      .flag_i				(flag_o),		 // Templated
      .carry_i				(carry_o));		 // Templated


   /* mor1kx_lsu_espresso AUTO_TEMPLATE (
    .padv_fetch_i			(padv_fetch_o),
    .lsu_adr_i				(adder_result_o),
    .rfb_i				(rfb_o),
    .op_lsu_load_i			(decode_op_lsu_load_o),
    .op_lsu_store_i			(decode_op_lsu_store_o),
    .lsu_length_i			(decode_lsu_length_o),
    .lsu_zext_i				(decode_lsu_zext_o),
    .exception_taken_i                  (exception_taken_o),
    .du_restart_i                       (du_restart_o),
    .stepping_i                         (stepping_o),
    .next_fetch_done_i                  (fetch_ready_o),
    ); */
   mor1kx_lsu_espresso
     #(
       .OPTION_OPERAND_WIDTH(OPTION_OPERAND_WIDTH)
       )
     mor1kx_lsu_espresso
     (/*AUTOINST*/
      // Outputs
      .lsu_result_o			(lsu_result_o[OPTION_OPERAND_WIDTH-1:0]),
      .lsu_valid_o			(lsu_valid_o),
      .lsu_except_dbus_o		(lsu_except_dbus_o),
      .lsu_except_align_o		(lsu_except_align_o),
      .dbus_adr_o			(dbus_adr_o[OPTION_OPERAND_WIDTH-1:0]),
      .dbus_req_o			(dbus_req_o),
      .dbus_dat_o			(dbus_dat_o[OPTION_OPERAND_WIDTH-1:0]),
      .dbus_bsel_o			(dbus_bsel_o[3:0]),
      .dbus_we_o			(dbus_we_o),
      .dbus_burst_o			(dbus_burst_o),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .padv_fetch_i			(padv_fetch_o),		 // Templated
      .lsu_adr_i			(adder_result_o),	 // Templated
      .rfb_i				(rfb_o),		 // Templated
      .op_lsu_load_i			(decode_op_lsu_load_o),	 // Templated
      .op_lsu_store_i			(decode_op_lsu_store_o), // Templated
      .lsu_length_i			(decode_lsu_length_o),	 // Templated
      .lsu_zext_i			(decode_lsu_zext_o),	 // Templated
      .exception_taken_i		(exception_taken_o),	 // Templated
      .du_restart_i			(du_restart_o),		 // Templated
      .stepping_i			(stepping_o),		 // Templated
      .next_fetch_done_i		(fetch_ready_o),	 // Templated
      .dbus_err_i			(dbus_err_i),
      .dbus_ack_i			(dbus_ack_i),
      .dbus_dat_i			(dbus_dat_i[OPTION_OPERAND_WIDTH-1:0]));


   /* mor1kx_wb_mux_espresso AUTO_TEMPLATE (
    .alu_result_i			(alu_result_o),
    .lsu_result_i			(lsu_result_o),
    .spr_i				(mfspr_dat_o),
    .op_jal_i				(decode_op_jal_o),
    .op_lsu_load_i			(decode_op_lsu_load_o),
    .ppc_i 			        (spr_ppc_o),
    .op_mfspr_i			        (decode_op_mfspr_o),
    .pc_fetch_next_i                    (link_addr_o),
    ); */
   mor1kx_wb_mux_espresso
     #(
       .OPTION_OPERAND_WIDTH(OPTION_OPERAND_WIDTH)
       )
     mor1kx_wb_mux_espresso
     (/*AUTOINST*/
      // Outputs
      .rf_result_o			(rf_result_o[OPTION_OPERAND_WIDTH-1:0]),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .alu_result_i			(alu_result_o),		 // Templated
      .lsu_result_i			(lsu_result_o),		 // Templated
      .ppc_i				(spr_ppc_o),		 // Templated
      .pc_fetch_next_i			(link_addr_o),		 // Templated
      .spr_i				(mfspr_dat_o),		 // Templated
      .op_jal_i				(decode_op_jal_o),	 // Templated
      .op_lsu_load_i			(decode_op_lsu_load_o),	 // Templated
      .op_mfspr_i			(decode_op_mfspr_o));	 // Templated


   /* mor1kx_rf_espresso AUTO_TEMPLATE (
    .rf_we_i    			(rf_we_o),
    .rf_re_i    			(fetch_rf_re_o),
    .rfd_adr_i  			(decode_rfd_adr_o),
    .rfa_adr_i  			(fetch_rfa_adr_o),
    .rfb_adr_i  			(fetch_rfb_adr_o),
    .result_i				(rf_result_o),
    ); */
   mor1kx_rf_espresso
     #(
       .OPTION_OPERAND_WIDTH(OPTION_OPERAND_WIDTH),
       .OPTION_RF_ADDR_WIDTH(OPTION_RF_ADDR_WIDTH),
       .OPTION_RF_WORDS(OPTION_RF_WORDS)
       )
     mor1kx_rf_espresso
     (/*AUTOINST*/
      // Outputs
      .rfa_o				(rfa_o[OPTION_OPERAND_WIDTH-1:0]),
      .rfb_o				(rfb_o[OPTION_OPERAND_WIDTH-1:0]),
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .rfd_adr_i			(decode_rfd_adr_o),	 // Templated
      .rfa_adr_i			(fetch_rfa_adr_o),	 // Templated
      .rfb_adr_i			(fetch_rfb_adr_o),	 // Templated
      .rf_we_i				(rf_we_o),		 // Templated
      .rf_re_i				(fetch_rf_re_o),	 // Templated
      .result_i				(rf_result_o));		 // Templated


   /* Debug signals required for the debug monitor */
   function [OPTION_OPERAND_WIDTH-1:0] get_gpr;
      // verilator public
      input [4:0] 		   gpr_num;
      begin
	 // If we're writing, the value won't be in the GPR yet, so snoop
	 // it off the result in line.
	 if (rf_we_o)
	   get_gpr = rf_result_o;
	 else
	   get_gpr = mor1kx_rf_espresso.rfa.mem[gpr_num];
      end
   endfunction //


`ifndef SYNTHESIS
// synthesis translate_off
   task set_gpr;
      // verilator public
      input [4:0] gpr_num;
      input [OPTION_OPERAND_WIDTH-1:0] gpr_value;
      begin
	 mor1kx_rf_espresso.rfa.mem[gpr_num] = gpr_value;
	 mor1kx_rf_espresso.rfb.mem[gpr_num] = gpr_value;
      end
   endtask
// synthesis translate_on
`endif

   /* mor1kx_ctrl_prontoespresso AUTO_TEMPLATE (
    .ctrl_alu_result_i		(alu_result_o),
    .ctrl_rfb_i			(rfb_o),
    .ctrl_flag_set_i		(flag_set_o),
    .ctrl_flag_clear_i		(flag_clear_o),
    .pc_ctrl_i			(),
    .pc_fetch_next_i 		(pc_fetch_next_o),
    .ctrl_opc_insn_i		(decode_opc_insn_o),
    .ctrl_branch_target_i	(ctrl_branch_target_o),
    .op_lsu_load_i		(decode_op_lsu_load_o),
    .op_lsu_store_i		(decode_op_lsu_store_o),
    .alu_valid_i		(alu_valid_o),
    .lsu_valid_i		(lsu_valid_o),
    .op_jr_i			(decode_op_jr_o),
    .op_jbr_i			(decode_op_jbr_o),
    .except_ibus_err_i		(decode_except_ibus_err_o),
    .except_illegal_i		(decode_except_illegal_o),
    .except_syscall_i		(decode_except_syscall_o),
    .except_dbus_i		(lsu_except_dbus_o),
    .except_trap_i		(decode_except_trap_o),
    .except_align_i		(lsu_except_align_o),
    .fetch_ready_i		(fetch_ready_o),
    .execute_valid_i		(execute_valid_o),
    .execute_waiting_i		(execute_waiting_o),
    .fetch_branch_taken_i	(fetch_branch_taken_o),
    .fetch_ppc_i                (fetched_pc_o),
    .fetch_sleep_i              (fetch_sleep_o),
    .fetch_quick_branch_i       (fetch_quick_branch_o),
    .rf_wb_i			(decode_rf_wb_o),
    .spr_bus_dat_dc_i		(),
    .spr_bus_ack_dc_i		(),
    .carry_set_i		(carry_set_o),
    .carry_clear_i		(carry_clear_o),
    .overflow_set_i		(overflow_set_o),
    .overflow_clear_i		(overflow_clear_o),
    ); */
   mor1kx_ctrl_prontoespresso
     #(
       .OPTION_OPERAND_WIDTH(OPTION_OPERAND_WIDTH),
       .OPTION_RESET_PC(OPTION_RESET_PC),
       .FEATURE_PIC(FEATURE_PIC),
       .FEATURE_TIMER(FEATURE_TIMER),
       .OPTION_PIC_TRIGGER(OPTION_PIC_TRIGGER),
       .OPTION_PIC_NMI_WIDTH(OPTION_PIC_NMI_WIDTH),
       .FEATURE_DSX(FEATURE_DSX),
       .FEATURE_FASTCONTEXTS(FEATURE_FASTCONTEXTS),
       .FEATURE_OVERFLOW(FEATURE_OVERFLOW),
       .FEATURE_DATACACHE(FEATURE_DATACACHE),
       .OPTION_DCACHE_BLOCK_WIDTH(OPTION_DCACHE_BLOCK_WIDTH),
       .OPTION_DCACHE_SET_WIDTH(OPTION_DCACHE_SET_WIDTH),
       .OPTION_DCACHE_WAYS(OPTION_DCACHE_WAYS),
       .FEATURE_DMMU(FEATURE_DMMU),
       .FEATURE_INSTRUCTIONCACHE(FEATURE_INSTRUCTIONCACHE),
       .OPTION_ICACHE_BLOCK_WIDTH(OPTION_ICACHE_BLOCK_WIDTH),
       .OPTION_ICACHE_SET_WIDTH(OPTION_ICACHE_SET_WIDTH),
       .OPTION_ICACHE_WAYS(OPTION_ICACHE_WAYS),
       .FEATURE_IMMU(FEATURE_IMMU),
       .FEATURE_DEBUGUNIT(FEATURE_DEBUGUNIT),
       .FEATURE_PERFCOUNTERS(FEATURE_PERFCOUNTERS),
       .FEATURE_MAC(FEATURE_MAC),
       .FEATURE_MULTICORE(FEATURE_MULTICORE),
       .FEATURE_SYSCALL(FEATURE_SYSCALL),
       .FEATURE_TRAP(FEATURE_TRAP),
       .FEATURE_RANGE(FEATURE_RANGE)
       )
     mor1kx_ctrl_prontoespresso
       (/*AUTOINST*/
	// Outputs
	.spr_npc_o			(spr_npc_o[OPTION_OPERAND_WIDTH-1:0]),
	.spr_ppc_o			(spr_ppc_o[OPTION_OPERAND_WIDTH-1:0]),
	.link_addr_o			(link_addr_o[OPTION_OPERAND_WIDTH-1:0]),
	.mfspr_dat_o			(mfspr_dat_o[OPTION_OPERAND_WIDTH-1:0]),
	.ctrl_mfspr_we_o		(ctrl_mfspr_we_o),
	.flag_o				(flag_o),
	.carry_o			(carry_o),
	.pipeline_flush_o		(pipeline_flush_o),
	.padv_fetch_o			(padv_fetch_o),
	.padv_decode_o			(padv_decode_o),
	.padv_execute_o			(padv_execute_o),
	.fetch_take_exception_branch_o	(fetch_take_exception_branch_o),
	.exception_taken_o		(exception_taken_o),
	.execute_waiting_o		(execute_waiting_o),
	.stepping_o			(stepping_o),
	.du_dat_o			(du_dat_o[OPTION_OPERAND_WIDTH-1:0]),
	.du_ack_o			(du_ack_o),
	.du_stall_o			(du_stall_o),
	.du_restart_pc_o		(du_restart_pc_o[OPTION_OPERAND_WIDTH-1:0]),
	.du_restart_o			(du_restart_o),
	.spr_bus_addr_o			(spr_bus_addr_o[15:0]),
	.spr_bus_we_o			(spr_bus_we_o),
	.spr_bus_stb_o			(spr_bus_stb_o),
	.spr_bus_dat_o			(spr_bus_dat_o[OPTION_OPERAND_WIDTH-1:0]),
	.spr_sr_o			(spr_sr_o[15:0]),
	.ctrl_branch_target_o		(ctrl_branch_target_o[OPTION_OPERAND_WIDTH-1:0]),
	.ctrl_insn_done_o		(ctrl_insn_done_o),
	.ctrl_branch_occur_o		(ctrl_branch_occur_o),
	.rf_we_o			(rf_we_o),
	// Inputs
	.clk				(clk),
	.rst				(rst),
	.ctrl_alu_result_i		(alu_result_o),		 // Templated
	.ctrl_rfb_i			(rfb_o),		 // Templated
	.ctrl_flag_set_i		(flag_set_o),		 // Templated
	.ctrl_flag_clear_i		(flag_clear_o),		 // Templated
	.ctrl_opc_insn_i		(decode_opc_insn_o),	 // Templated
	.fetch_ppc_i			(fetched_pc_o),		 // Templated
	.pc_fetch_next_i		(pc_fetch_next_o),	 // Templated
	.fetch_sleep_i			(fetch_sleep_o),	 // Templated
	.except_ibus_err_i		(decode_except_ibus_err_o), // Templated
	.except_illegal_i		(decode_except_illegal_o), // Templated
	.except_syscall_i		(decode_except_syscall_o), // Templated
	.except_dbus_i			(lsu_except_dbus_o),	 // Templated
	.except_trap_i			(decode_except_trap_o),	 // Templated
	.except_align_i			(lsu_except_align_o),	 // Templated
	.fetch_ready_i			(fetch_ready_o),	 // Templated
	.fetch_quick_branch_i		(fetch_quick_branch_o),	 // Templated
	.alu_valid_i			(alu_valid_o),		 // Templated
	.lsu_valid_i			(lsu_valid_o),		 // Templated
	.op_lsu_load_i			(decode_op_lsu_load_o),	 // Templated
	.op_lsu_store_i			(decode_op_lsu_store_o), // Templated
	.op_jr_i			(decode_op_jr_o),	 // Templated
	.op_jbr_i			(decode_op_jbr_o),	 // Templated
	.irq_i				(irq_i[31:0]),
	.carry_set_i			(carry_set_o),		 // Templated
	.carry_clear_i			(carry_clear_o),	 // Templated
	.overflow_set_i			(overflow_set_o),	 // Templated
	.overflow_clear_i		(overflow_clear_o),	 // Templated
	.du_addr_i			(du_addr_i[15:0]),
	.du_stb_i			(du_stb_i),
	.du_dat_i			(du_dat_i[OPTION_OPERAND_WIDTH-1:0]),
	.du_we_i			(du_we_i),
	.du_stall_i			(du_stall_i),
	.spr_bus_dat_dc_i		(),			 // Templated
	.spr_bus_ack_dc_i		(),			 // Templated
	.spr_bus_dat_ic_i		(spr_bus_dat_ic_i[OPTION_OPERAND_WIDTH-1:0]),
	.spr_bus_ack_ic_i		(spr_bus_ack_ic_i),
	.spr_bus_dat_dmmu_i		(spr_bus_dat_dmmu_i[OPTION_OPERAND_WIDTH-1:0]),
	.spr_bus_ack_dmmu_i		(spr_bus_ack_dmmu_i),
	.spr_bus_dat_immu_i		(spr_bus_dat_immu_i[OPTION_OPERAND_WIDTH-1:0]),
	.spr_bus_ack_immu_i		(spr_bus_ack_immu_i),
	.spr_bus_dat_mac_i		(spr_bus_dat_mac_i[OPTION_OPERAND_WIDTH-1:0]),
	.spr_bus_ack_mac_i		(spr_bus_ack_mac_i),
	.spr_bus_dat_pmu_i		(spr_bus_dat_pmu_i[OPTION_OPERAND_WIDTH-1:0]),
	.spr_bus_ack_pmu_i		(spr_bus_ack_pmu_i),
	.spr_bus_dat_pcu_i		(spr_bus_dat_pcu_i[OPTION_OPERAND_WIDTH-1:0]),
	.spr_bus_ack_pcu_i		(spr_bus_ack_pcu_i),
	.spr_bus_dat_fpu_i		(spr_bus_dat_fpu_i[OPTION_OPERAND_WIDTH-1:0]),
	.spr_bus_ack_fpu_i		(spr_bus_ack_fpu_i),
	.multicore_coreid_i		(multicore_coreid_i[OPTION_OPERAND_WIDTH-1:0]),
	.rf_wb_i			(decode_rf_wb_o));	 // Templated

endmodule // mor1kx_cpu_prontoespresso
