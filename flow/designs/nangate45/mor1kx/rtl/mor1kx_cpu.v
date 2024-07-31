/* ****************************************************************************
  SPDX-License-Identifier: CERN-OHL-W-2.0

  Description: CPU wrapper module

  Allows selection of CPU pipeline implementation based on parameter.

  Also provides some API-like hooks into the pipeline for monitors.

  Copyright (C) 2012 Authors

  Author(s): Julius Baxter <juliusbaxter@gmail.com>

***************************************************************************** */

`include "mor1kx-defines.v"

module mor1kx_cpu
  #(
    parameter OPTION_OPERAND_WIDTH	= 32,

    parameter OPTION_CPU		= "CAPPUCCINO",

    parameter FEATURE_DATACACHE		= "NONE",
    parameter OPTION_DCACHE_BLOCK_WIDTH	= 5,
    parameter OPTION_DCACHE_SET_WIDTH	= 9,
    parameter OPTION_DCACHE_WAYS	= 2,
    parameter OPTION_DCACHE_LIMIT_WIDTH = 32,
    parameter OPTION_DCACHE_SNOOP = "NONE",
    parameter FEATURE_DMMU		= "NONE",
    parameter FEATURE_DMMU_HW_TLB_RELOAD = "NONE",
    parameter OPTION_DMMU_SET_WIDTH 	= 6,
    parameter OPTION_DMMU_WAYS		= 1,
    parameter FEATURE_INSTRUCTIONCACHE	= "NONE",
    parameter OPTION_ICACHE_BLOCK_WIDTH	= 5,
    parameter OPTION_ICACHE_SET_WIDTH	= 9,
    parameter OPTION_ICACHE_WAYS	= 2,
    parameter OPTION_ICACHE_LIMIT_WIDTH	= 32,
    parameter FEATURE_IMMU		= "NONE",
    parameter FEATURE_IMMU_HW_TLB_RELOAD = "NONE",
    parameter OPTION_IMMU_SET_WIDTH	= 6,
    parameter OPTION_IMMU_WAYS		= 1,
    parameter FEATURE_TIMER		= "ENABLED",
    parameter FEATURE_DEBUGUNIT		= "NONE",
    parameter FEATURE_PERFCOUNTERS	= "NONE",
    parameter OPTION_PERFCOUNTERS_NUM	= 0,
    parameter FEATURE_MAC		= "NONE",

    parameter FEATURE_SYSCALL		= "ENABLED",
    parameter FEATURE_TRAP		= "ENABLED",
    parameter FEATURE_RANGE		= "ENABLED",

    parameter FEATURE_PIC		= "ENABLED",
    parameter OPTION_PIC_TRIGGER	= "LEVEL",
    parameter OPTION_PIC_NMI_WIDTH	= 0,

    parameter FEATURE_DSX		= "NONE",
    parameter FEATURE_OVERFLOW		= "NONE",
    parameter FEATURE_CARRY_FLAG	= "ENABLED",

    parameter FEATURE_FASTCONTEXTS	= "NONE",
    parameter OPTION_RF_CLEAR_ON_INIT 	= 0,
    parameter OPTION_RF_NUM_SHADOW_GPR 	= 0,
    parameter OPTION_RF_ADDR_WIDTH	= 5,
    parameter OPTION_RF_WORDS		= 32,

    parameter OPTION_RESET_PC		= {{(OPTION_OPERAND_WIDTH-13){1'b0}},
					   `OR1K_RESET_VECTOR,8'd0},

    parameter OPTION_TCM_FETCHER 	= "DISABLED",

    parameter FEATURE_MULTIPLIER	= "THREESTAGE",
    parameter FEATURE_DIVIDER		= "NONE",

    parameter OPTION_SHIFTER		= "BARREL",

    parameter FEATURE_ADDC		= "NONE",
    parameter FEATURE_SRA		= "ENABLED",
    parameter FEATURE_ROR		= "NONE",
    parameter FEATURE_EXT		= "NONE",
    parameter FEATURE_CMOV		= "NONE",
    parameter FEATURE_FFL1		= "NONE",
    parameter FEATURE_MSYNC		= "ENABLED",
    parameter FEATURE_PSYNC		= "NONE",
    parameter FEATURE_CSYNC		= "NONE",
    parameter FEATURE_ATOMIC		= "ENABLED",

    parameter FEATURE_FPU		= "NONE", // ENABLED|NONE

    parameter FEATURE_CUST1		= "NONE",
    parameter FEATURE_CUST2		= "NONE",
    parameter FEATURE_CUST3		= "NONE",
    parameter FEATURE_CUST4		= "NONE",
    parameter FEATURE_CUST5		= "NONE",
    parameter FEATURE_CUST6		= "NONE",
    parameter FEATURE_CUST7		= "NONE",
    parameter FEATURE_CUST8		= "NONE",

    parameter FEATURE_STORE_BUFFER	= "ENABLED",
    parameter OPTION_STORE_BUFFER_DEPTH_WIDTH = 8,

    parameter FEATURE_MULTICORE = "NONE",

    parameter FEATURE_TRACEPORT_EXEC = "NONE",
    parameter FEATURE_BRANCH_PREDICTOR = "SIMPLE"
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

    output                            traceport_exec_valid_o,
    output [31:0]                     traceport_exec_pc_o,
    output                            traceport_exec_jb_o,
    output                            traceport_exec_jal_o,
    output                            traceport_exec_jr_o,
    output [31:0]                     traceport_exec_jbtarget_o,
    output [`OR1K_INSN_WIDTH-1:0]     traceport_exec_insn_o,
    output [OPTION_OPERAND_WIDTH-1:0] traceport_exec_wbdata_o,
    output [OPTION_RF_ADDR_WIDTH-1:0] traceport_exec_wbreg_o,
    output                           traceport_exec_wben_o,

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
    input [OPTION_OPERAND_WIDTH-1:0]  multicore_coreid_i,
    // The number of cores
    input [OPTION_OPERAND_WIDTH-1:0]  multicore_numcores_i,

    input [31:0] 		     snoop_adr_i,
    input 			     snoop_en_i
    );

   wire [`OR1K_INSN_WIDTH-1:0] 	     monitor_execute_insn/* verilator public */;
   wire 			     monitor_execute_advance/* verilator public */;
   wire 			     monitor_flag_set/* verilator public */;
   wire 			     monitor_flag_clear/* verilator public */;
   wire 			     monitor_flag_sr/* verilator public */;
   wire 			     monitor_flag/* verilator public */;
   wire [OPTION_OPERAND_WIDTH-1:0]   monitor_spr_sr/* verilator public */;
   wire [OPTION_OPERAND_WIDTH-1:0]   monitor_execute_pc/* verilator public */;
   wire [OPTION_OPERAND_WIDTH-1:0]   monitor_rf_result_in/* verilator public */;
   wire 			     monitor_clk/* verilator public */;
   wire [OPTION_OPERAND_WIDTH-1:0]   monitor_spr_epcr/* verilator public */;
   wire [OPTION_OPERAND_WIDTH-1:0]   monitor_spr_eear/* verilator public */;
   wire [OPTION_OPERAND_WIDTH-1:0]   monitor_spr_esr/* verilator public */;
   wire 			     monitor_branch_mispredict/* verilator public */;

	// synthesis translate_off
`ifndef SYNTHESIS
   /* Provide interface hooks for register functions. */
	`include "mor1kx_utils.vh"
	localparam RF_ADDR_WIDTH = calc_rf_addr_width(OPTION_RF_ADDR_WIDTH,
                                                  OPTION_RF_NUM_SHADOW_GPR);
   generate
      if (OPTION_CPU=="CAPPUCCINO") begin : monitor
         function [OPTION_OPERAND_WIDTH-1:0] get_gpr;
            // verilator public
            input [RF_ADDR_WIDTH-1:0] gpr_num;
            get_gpr = cappuccino.mor1kx_cpu.get_gpr(gpr_num);
         endfunction
         task set_gpr;
            // verilator public
            input [RF_ADDR_WIDTH-1:0] gpr_num;
            input [OPTION_OPERAND_WIDTH-1:0] gpr_value;
            cappuccino.mor1kx_cpu.set_gpr(gpr_num, gpr_value);
         endtask
      end
      else if (OPTION_CPU=="ESPRESSO") begin : monitor
         function [OPTION_OPERAND_WIDTH-1:0] get_gpr;
            // verilator public
            input [15:0] gpr_num;
            get_gpr = espresso.mor1kx_cpu.get_gpr(gpr_num);
         endfunction
         task set_gpr;
            // verilator public
            input [15:0] gpr_num;
            input [OPTION_OPERAND_WIDTH-1:0] gpr_value;
            espresso.mor1kx_cpu.set_gpr(gpr_num, gpr_value);
         endtask
      end
      /* verilator lint_off WIDTH */
      else if (OPTION_CPU=="PRONTO_ESPRESSO") begin : monitor
         function [OPTION_OPERAND_WIDTH-1:0] get_gpr;
            // verilator public
            input [15:0] gpr_num;
            get_gpr = prontoespresso.mor1kx_cpu.get_gpr(gpr_num);
         endfunction
         task set_gpr;
            // verilator public
            input [15:0] gpr_num;
            input [OPTION_OPERAND_WIDTH-1:0] gpr_value;
            prontoespresso.mor1kx_cpu.set_gpr(gpr_num, gpr_value);
         endtask
      end
   endgenerate
`endif
	// synthesis translate_on

   generate
      /* verilator lint_off WIDTH */
      if (OPTION_CPU=="CAPPUCCINO") begin : cappuccino
	 /* verilator lint_on WIDTH */
	 mor1kx_cpu_cappuccino
	   #(
	     .OPTION_OPERAND_WIDTH(OPTION_OPERAND_WIDTH),
	     .FEATURE_DATACACHE(FEATURE_DATACACHE),
	     .OPTION_DCACHE_BLOCK_WIDTH(OPTION_DCACHE_BLOCK_WIDTH),
	     .OPTION_DCACHE_SET_WIDTH(OPTION_DCACHE_SET_WIDTH),
	     .OPTION_DCACHE_WAYS(OPTION_DCACHE_WAYS),
	     .OPTION_DCACHE_LIMIT_WIDTH(OPTION_DCACHE_LIMIT_WIDTH),
             .OPTION_DCACHE_SNOOP(OPTION_DCACHE_SNOOP),
	     .FEATURE_DMMU(FEATURE_DMMU),
	     .FEATURE_DMMU_HW_TLB_RELOAD(FEATURE_DMMU_HW_TLB_RELOAD),
	     .OPTION_DMMU_SET_WIDTH(OPTION_DMMU_SET_WIDTH),
	     .OPTION_DMMU_WAYS(OPTION_DMMU_WAYS),
	     .FEATURE_INSTRUCTIONCACHE(FEATURE_INSTRUCTIONCACHE),
	     .OPTION_ICACHE_BLOCK_WIDTH(OPTION_ICACHE_BLOCK_WIDTH),
	     .OPTION_ICACHE_SET_WIDTH(OPTION_ICACHE_SET_WIDTH),
	     .OPTION_ICACHE_WAYS(OPTION_ICACHE_WAYS),
	     .OPTION_ICACHE_LIMIT_WIDTH(OPTION_ICACHE_LIMIT_WIDTH),
	     .FEATURE_IMMU(FEATURE_IMMU),
	     .FEATURE_IMMU_HW_TLB_RELOAD(FEATURE_IMMU_HW_TLB_RELOAD),
	     .OPTION_IMMU_SET_WIDTH(OPTION_IMMU_SET_WIDTH),
	     .OPTION_IMMU_WAYS(OPTION_IMMU_WAYS),
	     .FEATURE_PIC(FEATURE_PIC),
	     .FEATURE_TIMER(FEATURE_TIMER),
	     .FEATURE_DEBUGUNIT(FEATURE_DEBUGUNIT),
	     .FEATURE_PERFCOUNTERS(FEATURE_PERFCOUNTERS),
	     .OPTION_PERFCOUNTERS_NUM(OPTION_PERFCOUNTERS_NUM),
	     .FEATURE_MAC(FEATURE_MAC),
	     .FEATURE_MULTICORE(FEATURE_MULTICORE),
	     .FEATURE_TRACEPORT_EXEC(FEATURE_TRACEPORT_EXEC),
	     .FEATURE_BRANCH_PREDICTOR(FEATURE_BRANCH_PREDICTOR),
	     .FEATURE_SYSCALL(FEATURE_SYSCALL),
	     .FEATURE_TRAP(FEATURE_TRAP),
	     .FEATURE_RANGE(FEATURE_RANGE),
	     .OPTION_PIC_TRIGGER(OPTION_PIC_TRIGGER),
	     .OPTION_PIC_NMI_WIDTH(OPTION_PIC_NMI_WIDTH),
	     .FEATURE_DSX(FEATURE_DSX),
	     .FEATURE_FASTCONTEXTS(FEATURE_FASTCONTEXTS),
	     .OPTION_RF_CLEAR_ON_INIT(OPTION_RF_CLEAR_ON_INIT),
	     .OPTION_RF_NUM_SHADOW_GPR(OPTION_RF_NUM_SHADOW_GPR),
	     .FEATURE_OVERFLOW(FEATURE_OVERFLOW),
	     .FEATURE_CARRY_FLAG(FEATURE_CARRY_FLAG),
	     .OPTION_RF_ADDR_WIDTH(OPTION_RF_ADDR_WIDTH),
	     .OPTION_RF_WORDS(OPTION_RF_WORDS),
	     .OPTION_RESET_PC(OPTION_RESET_PC),
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
	     .FEATURE_ATOMIC(FEATURE_ATOMIC),
	     .FEATURE_FPU(FEATURE_FPU),
	     .FEATURE_CUST1(FEATURE_CUST1),
	     .FEATURE_CUST2(FEATURE_CUST2),
	     .FEATURE_CUST3(FEATURE_CUST3),
	     .FEATURE_CUST4(FEATURE_CUST4),
	     .FEATURE_CUST5(FEATURE_CUST5),
	     .FEATURE_CUST6(FEATURE_CUST6),
	     .FEATURE_CUST7(FEATURE_CUST7),
	     .FEATURE_CUST8(FEATURE_CUST8),
	     .OPTION_SHIFTER(OPTION_SHIFTER),
	     .FEATURE_STORE_BUFFER(FEATURE_STORE_BUFFER),
	     .OPTION_STORE_BUFFER_DEPTH_WIDTH(OPTION_STORE_BUFFER_DEPTH_WIDTH)
	     )
	   mor1kx_cpu
	   (/*AUTOINST*/
	    // Outputs
	    .ibus_adr_o			(ibus_adr_o[OPTION_OPERAND_WIDTH-1:0]),
	    .ibus_req_o			(ibus_req_o),
	    .ibus_burst_o		(ibus_burst_o),
	    .dbus_adr_o			(dbus_adr_o[OPTION_OPERAND_WIDTH-1:0]),
	    .dbus_dat_o			(dbus_dat_o[OPTION_OPERAND_WIDTH-1:0]),
	    .dbus_req_o			(dbus_req_o),
	    .dbus_bsel_o		(dbus_bsel_o[3:0]),
	    .dbus_we_o			(dbus_we_o),
	    .dbus_burst_o		(dbus_burst_o),
	    .du_dat_o			(du_dat_o[OPTION_OPERAND_WIDTH-1:0]),
	    .du_ack_o			(du_ack_o),
	    .du_stall_o			(du_stall_o),
            .traceport_exec_valid_o     (traceport_exec_valid_o),
            .traceport_exec_pc_o        (traceport_exec_pc_o[31:0]),
            .traceport_exec_jb_o        (traceport_exec_jb_o),
            .traceport_exec_jal_o       (traceport_exec_jal_o),
            .traceport_exec_jr_o        (traceport_exec_jr_o),
            .traceport_exec_jbtarget_o  (traceport_exec_jbtarget_o[31:0]),
            .traceport_exec_insn_o      (traceport_exec_insn_o[`OR1K_INSN_WIDTH-1:0]),
            .traceport_exec_wbdata_o    (traceport_exec_wbdata_o[OPTION_OPERAND_WIDTH-1:0]),
            .traceport_exec_wbreg_o     (traceport_exec_wbreg_o[OPTION_RF_ADDR_WIDTH-1:0]),
            .traceport_exec_wben_o      (traceport_exec_wben_o),
	    .spr_bus_addr_o		(spr_bus_addr_o[15:0]),
	    .spr_bus_we_o		(spr_bus_we_o),
	    .spr_bus_stb_o		(spr_bus_stb_o),
	    .spr_bus_dat_o		(spr_bus_dat_o[OPTION_OPERAND_WIDTH-1:0]),
	    .spr_sr_o			(spr_sr_o[15:0]),
	    // Inputs
	    .clk			(clk),
	    .rst			(rst),
	    .ibus_err_i			(ibus_err_i),
	    .ibus_ack_i			(ibus_ack_i),
	    .ibus_dat_i			(ibus_dat_i[`OR1K_INSN_WIDTH-1:0]),
	    .dbus_err_i			(dbus_err_i),
	    .dbus_ack_i			(dbus_ack_i),
	    .dbus_dat_i			(dbus_dat_i[OPTION_OPERAND_WIDTH-1:0]),
	    .irq_i			(irq_i[31:0]),
	    .du_addr_i			(du_addr_i[15:0]),
	    .du_stb_i			(du_stb_i),
	    .du_dat_i			(du_dat_i[OPTION_OPERAND_WIDTH-1:0]),
	    .du_we_i			(du_we_i),
	    .du_stall_i			(du_stall_i),
	    .spr_bus_dat_mac_i		(spr_bus_dat_mac_i[OPTION_OPERAND_WIDTH-1:0]),
	    .spr_bus_ack_mac_i		(spr_bus_ack_mac_i),
	    .spr_bus_dat_pmu_i		(spr_bus_dat_pmu_i[OPTION_OPERAND_WIDTH-1:0]),
	    .spr_bus_ack_pmu_i		(spr_bus_ack_pmu_i),
	    .spr_bus_dat_pcu_i		(spr_bus_dat_pcu_i[OPTION_OPERAND_WIDTH-1:0]),
	    .spr_bus_ack_pcu_i		(spr_bus_ack_pcu_i),
	    .spr_bus_dat_fpu_i		(spr_bus_dat_fpu_i[OPTION_OPERAND_WIDTH-1:0]),
	    .spr_bus_ack_fpu_i		(spr_bus_ack_fpu_i),
	    .multicore_coreid_i		(multicore_coreid_i[OPTION_OPERAND_WIDTH-1:0]),
	    .multicore_numcores_i	(multicore_numcores_i[OPTION_OPERAND_WIDTH-1:0]),
	    .snoop_adr_i		(snoop_adr_i[31:0]),
	    .snoop_en_i			(snoop_en_i));

	// synthesis translate_off
`ifndef SYNTHESIS

	 assign monitor_flag =  monitor_flag_set ? 1 :
			        monitor_flag_clear ? 0 :
				monitor_flag_sr;
	 assign monitor_clk = clk;

	 assign monitor_execute_advance = cappuccino.mor1kx_cpu.padv_execute_o;
 	 assign monitor_flag_set = cappuccino.mor1kx_cpu.mor1kx_execute_ctrl_cappuccino.flag_set_i;
	 assign monitor_flag_clear = cappuccino.mor1kx_cpu.mor1kx_execute_ctrl_cappuccino.flag_clear_i;
	 assign monitor_flag_sr = cappuccino.mor1kx_cpu.mor1kx_ctrl_cappuccino.ctrl_flag_o;
	 assign monitor_spr_sr = {16'd0,cappuccino.mor1kx_cpu.mor1kx_ctrl_cappuccino.spr_sr[15:`OR1K_SPR_SR_F+1],cappuccino.mor1kx_cpu.mor1kx_ctrl_cappuccino.ctrl_flag_o,cappuccino.mor1kx_cpu.mor1kx_ctrl_cappuccino.spr_sr[`OR1K_SPR_SR_F-1:0]};
	 assign monitor_execute_pc = cappuccino.mor1kx_cpu.pc_decode_to_execute;
	 assign monitor_rf_result_in = cappuccino.mor1kx_cpu.mor1kx_rf_cappuccino.result_i;
	 assign monitor_spr_esr = {16'd0,cappuccino.mor1kx_cpu.mor1kx_ctrl_cappuccino.spr_esr};
	 assign monitor_spr_epcr = cappuccino.mor1kx_cpu.mor1kx_ctrl_cappuccino.spr_epcr;
	 assign monitor_spr_eear = cappuccino.mor1kx_cpu.mor1kx_ctrl_cappuccino.spr_eear;
	 assign monitor_branch_mispredict = cappuccino.mor1kx_cpu.branch_mispredict_o;

        reg [`OR1K_INSN_WIDTH-1:0]          monitor_execute_insn_reg;
        always @(posedge clk)
          if (cappuccino.mor1kx_cpu.padv_decode_o)
            monitor_execute_insn_reg <= cappuccino.mor1kx_cpu.mor1kx_decode.decode_insn_i;

        assign monitor_execute_insn = monitor_execute_insn_reg;


`endif
	// synthesis translate_on


      end // block: cappuccino
      /* verilator lint_off WIDTH */
      if (OPTION_CPU=="ESPRESSO") begin : espresso
	 /* verilator lint_on WIDTH */
	 mor1kx_cpu_espresso
	   #(
	     .OPTION_OPERAND_WIDTH(OPTION_OPERAND_WIDTH),
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
	     .FEATURE_PIC(FEATURE_PIC),
	     .FEATURE_TIMER(FEATURE_TIMER),
	     .FEATURE_DEBUGUNIT(FEATURE_DEBUGUNIT),
	     .FEATURE_PERFCOUNTERS(FEATURE_PERFCOUNTERS),
	     .FEATURE_MAC(FEATURE_MAC),
	     .FEATURE_MULTICORE(FEATURE_MULTICORE),
	     .FEATURE_SYSCALL(FEATURE_SYSCALL),
	     .FEATURE_TRAP(FEATURE_TRAP),
	     .FEATURE_RANGE(FEATURE_RANGE),
	     .OPTION_PIC_TRIGGER(OPTION_PIC_TRIGGER),
	     .OPTION_PIC_NMI_WIDTH(OPTION_PIC_NMI_WIDTH),
	     .FEATURE_DSX(FEATURE_DSX),
	     .FEATURE_FASTCONTEXTS(FEATURE_FASTCONTEXTS),
	     .FEATURE_OVERFLOW(FEATURE_OVERFLOW),
	     .FEATURE_CARRY_FLAG(FEATURE_CARRY_FLAG),
	     .OPTION_RF_ADDR_WIDTH(OPTION_RF_ADDR_WIDTH),
	     .OPTION_RF_WORDS(OPTION_RF_WORDS),
	     .OPTION_RESET_PC(OPTION_RESET_PC),
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
	     .FEATURE_CUST8(FEATURE_CUST8),
	     .OPTION_SHIFTER(OPTION_SHIFTER)
	     )
	   mor1kx_cpu
	   (/*AUTOINST*/
	    // Outputs
	    .ibus_adr_o			(ibus_adr_o[OPTION_OPERAND_WIDTH-1:0]),
	    .ibus_req_o			(ibus_req_o),
	    .ibus_burst_o		(ibus_burst_o),
	    .dbus_adr_o			(dbus_adr_o[OPTION_OPERAND_WIDTH-1:0]),
	    .dbus_dat_o			(dbus_dat_o[OPTION_OPERAND_WIDTH-1:0]),
	    .dbus_req_o			(dbus_req_o),
	    .dbus_bsel_o		(dbus_bsel_o[3:0]),
	    .dbus_we_o			(dbus_we_o),
	    .dbus_burst_o		(dbus_burst_o),
	    .du_dat_o			(du_dat_o[OPTION_OPERAND_WIDTH-1:0]),
	    .du_ack_o			(du_ack_o),
	    .du_stall_o			(du_stall_o),
	    .spr_bus_addr_o		(spr_bus_addr_o[15:0]),
	    .spr_bus_we_o		(spr_bus_we_o),
	    .spr_bus_stb_o		(spr_bus_stb_o),
	    .spr_bus_dat_o		(spr_bus_dat_o[OPTION_OPERAND_WIDTH-1:0]),
	    .spr_sr_o			(spr_sr_o[15:0]),
	    // Inputs
	    .clk			(clk),
	    .rst			(rst),
	    .ibus_err_i			(ibus_err_i),
	    .ibus_ack_i			(ibus_ack_i),
	    .ibus_dat_i			(ibus_dat_i[`OR1K_INSN_WIDTH-1:0]),
	    .dbus_err_i			(dbus_err_i),
	    .dbus_ack_i			(dbus_ack_i),
	    .dbus_dat_i			(dbus_dat_i[OPTION_OPERAND_WIDTH-1:0]),
	    .irq_i			(irq_i[31:0]),
	    .du_addr_i			(du_addr_i[15:0]),
	    .du_stb_i			(du_stb_i),
	    .du_dat_i			(du_dat_i[OPTION_OPERAND_WIDTH-1:0]),
	    .du_we_i			(du_we_i),
	    .du_stall_i			(du_stall_i),
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
	    .multicore_coreid_i		(multicore_coreid_i[OPTION_OPERAND_WIDTH-1:0]));

	 // synthesis translate_off
`ifndef SYNTHESIS
	 assign monitor_flag =  monitor_flag_set ? 1 :
			        monitor_flag_clear ? 0 :
				monitor_flag_sr;
	 assign monitor_clk = clk;
	 assign monitor_execute_insn = espresso.mor1kx_cpu.mor1kx_fetch_espresso.decode_insn_o;
	 assign monitor_execute_advance = espresso.mor1kx_cpu.mor1kx_ctrl_espresso.execute_done;
	 assign monitor_flag_set = espresso.mor1kx_cpu.mor1kx_ctrl_espresso.ctrl_flag_set_i;
	 assign monitor_flag_clear = espresso.mor1kx_cpu.mor1kx_ctrl_espresso.ctrl_flag_clear_i;
	 assign monitor_flag_sr = espresso.mor1kx_cpu.mor1kx_ctrl_espresso.flag;
	 assign monitor_spr_sr = {16'd0,espresso.mor1kx_cpu.mor1kx_ctrl_espresso.spr_sr[15:`OR1K_SPR_SR_F+1],
				  // Use the locally calculated flag value
				  monitor_flag,
				  espresso.mor1kx_cpu.mor1kx_ctrl_espresso.spr_sr[`OR1K_SPR_SR_F-1:0]};
	 assign monitor_execute_pc = espresso.mor1kx_cpu.mor1kx_ctrl_espresso.spr_ppc;
	 assign monitor_rf_result_in = espresso.mor1kx_cpu.mor1kx_rf_espresso.result_i;
	 assign monitor_spr_esr = {16'd0,espresso.mor1kx_cpu.mor1kx_ctrl_espresso.spr_esr};
	 assign monitor_spr_epcr = espresso.mor1kx_cpu.mor1kx_ctrl_espresso.spr_epcr;
	 assign monitor_spr_eear = espresso.mor1kx_cpu.mor1kx_ctrl_espresso.spr_eear;
	 assign monitor_branch_mispredict = 0;
`endif
	 // synthesis translate_on

      end // block: espresso
      /* verilator lint_off WIDTH */
      if (OPTION_CPU=="PRONTO_ESPRESSO") begin : prontoespresso
	 /* verilator lint_on WIDTH */
	 mor1kx_cpu_prontoespresso
	   #(
	     .OPTION_OPERAND_WIDTH(OPTION_OPERAND_WIDTH),
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
	     .FEATURE_PIC(FEATURE_PIC),
	     .FEATURE_TIMER(FEATURE_TIMER),
	     .FEATURE_DEBUGUNIT(FEATURE_DEBUGUNIT),
	     .FEATURE_PERFCOUNTERS(FEATURE_PERFCOUNTERS),
	     .FEATURE_MAC(FEATURE_MAC),
	     .FEATURE_MULTICORE(FEATURE_MULTICORE),
	     .FEATURE_SYSCALL(FEATURE_SYSCALL),
	     .FEATURE_TRAP(FEATURE_TRAP),
	     .FEATURE_RANGE(FEATURE_RANGE),
	     .OPTION_PIC_TRIGGER(OPTION_PIC_TRIGGER),
	     .OPTION_PIC_NMI_WIDTH(OPTION_PIC_NMI_WIDTH),
	     .FEATURE_DSX(FEATURE_DSX),
	     .FEATURE_FASTCONTEXTS(FEATURE_FASTCONTEXTS),
	     .FEATURE_OVERFLOW(FEATURE_OVERFLOW),
	     .FEATURE_CARRY_FLAG(FEATURE_CARRY_FLAG),
	     .OPTION_RF_ADDR_WIDTH(OPTION_RF_ADDR_WIDTH),
	     .OPTION_RF_WORDS(OPTION_RF_WORDS),
	     .OPTION_RESET_PC(OPTION_RESET_PC),
	     .OPTION_TCM_FETCHER(OPTION_TCM_FETCHER),
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
	     .FEATURE_CUST8(FEATURE_CUST8),
	     .OPTION_SHIFTER(OPTION_SHIFTER)
	     )
	   mor1kx_cpu
	   (/*AUTOINST*/
	    // Outputs
	    .ibus_adr_o			(ibus_adr_o[OPTION_OPERAND_WIDTH-1:0]),
	    .ibus_req_o			(ibus_req_o),
	    .ibus_burst_o		(ibus_burst_o),
	    .dbus_adr_o			(dbus_adr_o[OPTION_OPERAND_WIDTH-1:0]),
	    .dbus_dat_o			(dbus_dat_o[OPTION_OPERAND_WIDTH-1:0]),
	    .dbus_req_o			(dbus_req_o),
	    .dbus_bsel_o		(dbus_bsel_o[3:0]),
	    .dbus_we_o			(dbus_we_o),
	    .dbus_burst_o		(dbus_burst_o),
	    .du_dat_o			(du_dat_o[OPTION_OPERAND_WIDTH-1:0]),
	    .du_ack_o			(du_ack_o),
	    .du_stall_o			(du_stall_o),
	    .spr_bus_addr_o		(spr_bus_addr_o[15:0]),
	    .spr_bus_we_o		(spr_bus_we_o),
	    .spr_bus_stb_o		(spr_bus_stb_o),
	    .spr_bus_dat_o		(spr_bus_dat_o[OPTION_OPERAND_WIDTH-1:0]),
	    .spr_sr_o			(spr_sr_o[15:0]),
	    // Inputs
	    .clk			(clk),
	    .rst			(rst),
	    .ibus_err_i			(ibus_err_i),
	    .ibus_ack_i			(ibus_ack_i),
	    .ibus_dat_i			(ibus_dat_i[`OR1K_INSN_WIDTH-1:0]),
	    .dbus_err_i			(dbus_err_i),
	    .dbus_ack_i			(dbus_ack_i),
	    .dbus_dat_i			(dbus_dat_i[OPTION_OPERAND_WIDTH-1:0]),
	    .irq_i			(irq_i[31:0]),
	    .du_addr_i			(du_addr_i[15:0]),
	    .du_stb_i			(du_stb_i),
	    .du_dat_i			(du_dat_i[OPTION_OPERAND_WIDTH-1:0]),
	    .du_we_i			(du_we_i),
	    .du_stall_i			(du_stall_i),
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
	    .multicore_coreid_i		(multicore_coreid_i[OPTION_OPERAND_WIDTH-1:0]));

	 // synthesis translate_off
`ifndef SYNTHESIS
	 assign monitor_flag =  monitor_flag_set ? 1 :
			        monitor_flag_clear ? 0 :
				monitor_flag_sr;
	 assign monitor_clk = clk;
	 assign monitor_execute_insn = prontoespresso.mor1kx_cpu.insn_fetch_to_decode;
	 assign monitor_execute_advance = prontoespresso.mor1kx_cpu.mor1kx_ctrl_prontoespresso.execute_done;
	 assign monitor_flag_set = prontoespresso.mor1kx_cpu.mor1kx_ctrl_prontoespresso.ctrl_flag_set_i;
	 assign monitor_flag_clear = prontoespresso.mor1kx_cpu.mor1kx_ctrl_prontoespresso.ctrl_flag_clear_i;
	 assign monitor_flag_sr = prontoespresso.mor1kx_cpu.mor1kx_ctrl_prontoespresso.flag;
	 assign monitor_spr_sr = {16'd0,prontoespresso.mor1kx_cpu.mor1kx_ctrl_prontoespresso.spr_sr[15:`OR1K_SPR_SR_F+1],
				  // Use the locally calculated flag value
				  monitor_flag,
				  prontoespresso.mor1kx_cpu.mor1kx_ctrl_prontoespresso.spr_sr[`OR1K_SPR_SR_F-1:0]};
	 assign monitor_execute_pc = prontoespresso.mor1kx_cpu.mor1kx_ctrl_prontoespresso.spr_ppc;
	 assign monitor_rf_result_in = prontoespresso.mor1kx_cpu.mor1kx_rf_espresso.result_i;
	 assign monitor_spr_esr = {16'd0,prontoespresso.mor1kx_cpu.mor1kx_ctrl_prontoespresso.spr_esr};
	 assign monitor_spr_epcr = prontoespresso.mor1kx_cpu.mor1kx_ctrl_prontoespresso.spr_epcr;
	 assign monitor_spr_eear = prontoespresso.mor1kx_cpu.mor1kx_ctrl_prontoespresso.spr_eear;
	 assign monitor_branch_mispredict = 0;
`endif
	 // synthesis translate_on

      end
      /* verilator lint_off WIDTH */
      if (OPTION_CPU!="CAPPUCCINO" && OPTION_CPU!="ESPRESSO" &&
	  OPTION_CPU!="PRONTO_ESPRESSO")
	/* verilator lint_on WIDTH */
	begin
	   initial begin
	      $display("Error: OPTION_CPU, %s, not valid", OPTION_CPU);
	      $finish();
	   end
	end // else: !if(OPTION_CPU=="ESPRESSO")
   endgenerate

endmodule // mor1kx_cpu
