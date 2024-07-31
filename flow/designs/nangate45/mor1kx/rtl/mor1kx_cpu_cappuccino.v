/* ****************************************************************************
  SPDX-License-Identifier: CERN-OHL-W-2.0

  Description: "Cappuccino" pipeline CPU module

  Copyright (C) 2012 Authors

   Author(s): Julius Baxter <juliusbaxter@gmail.com>

***************************************************************************** */

`include "mor1kx-defines.v"

module mor1kx_cpu_cappuccino
  #(
    parameter OPTION_OPERAND_WIDTH = 32,

    parameter FEATURE_DATACACHE = "NONE",
    parameter OPTION_DCACHE_BLOCK_WIDTH = 5,
    parameter OPTION_DCACHE_SET_WIDTH = 9,
    parameter OPTION_DCACHE_WAYS = 2,
    parameter OPTION_DCACHE_LIMIT_WIDTH = 32,
    parameter OPTION_DCACHE_SNOOP = "NONE",
    parameter FEATURE_DMMU = "NONE",
    parameter FEATURE_DMMU_HW_TLB_RELOAD = "NONE",
    parameter OPTION_DMMU_SET_WIDTH = 6,
    parameter OPTION_DMMU_WAYS = 1,
    parameter FEATURE_INSTRUCTIONCACHE = "NONE",
    parameter OPTION_ICACHE_BLOCK_WIDTH = 5,
    parameter OPTION_ICACHE_SET_WIDTH = 9,
    parameter OPTION_ICACHE_WAYS = 2,
    parameter OPTION_ICACHE_LIMIT_WIDTH = 32,
    parameter FEATURE_IMMU = "NONE",
    parameter FEATURE_IMMU_HW_TLB_RELOAD = "NONE",
    parameter OPTION_IMMU_SET_WIDTH = 6,
    parameter OPTION_IMMU_WAYS = 1,
    parameter FEATURE_TIMER = "ENABLED",
    parameter FEATURE_DEBUGUNIT = "NONE",
    parameter FEATURE_PERFCOUNTERS = "NONE",
    parameter OPTION_PERFCOUNTERS_NUM = 0,
    parameter FEATURE_MAC = "NONE",

    parameter FEATURE_SYSCALL = "ENABLED",
    parameter FEATURE_TRAP = "ENABLED",
    parameter FEATURE_RANGE = "ENABLED",

    parameter FEATURE_PIC = "ENABLED",
    parameter OPTION_PIC_TRIGGER = "LEVEL",
    parameter OPTION_PIC_NMI_WIDTH = 0,

    parameter FEATURE_DSX = "NONE",
    parameter FEATURE_OVERFLOW = "NONE",
    parameter FEATURE_CARRY_FLAG = "ENABLED",

    parameter FEATURE_FASTCONTEXTS = "NONE",
    parameter OPTION_RF_CLEAR_ON_INIT = 0,
    parameter OPTION_RF_NUM_SHADOW_GPR = 0,
    parameter OPTION_RF_ADDR_WIDTH = 5,
    parameter OPTION_RF_WORDS = 32,

    parameter OPTION_RESET_PC = {{(OPTION_OPERAND_WIDTH-13){1'b0}},
				 `OR1K_RESET_VECTOR,8'd0},

    parameter FEATURE_MULTIPLIER = "THREESTAGE",
    parameter FEATURE_DIVIDER = "NONE",

    parameter OPTION_SHIFTER = "BARREL",

    parameter FEATURE_ADDC = "NONE",
    parameter FEATURE_SRA = "ENABLED",
    parameter FEATURE_ROR = "NONE",
    parameter FEATURE_EXT = "NONE",
    parameter FEATURE_CMOV = "NONE",
    parameter FEATURE_FFL1 = "NONE",
    parameter FEATURE_MSYNC = "ENABLED",
    parameter FEATURE_PSYNC = "NONE",
    parameter FEATURE_CSYNC = "NONE",

    parameter FEATURE_ATOMIC = "ENABLED",

    parameter FEATURE_FPU   = "NONE", // ENABLED|NONE

    parameter FEATURE_CUST1 = "NONE",
    parameter FEATURE_CUST2 = "NONE",
    parameter FEATURE_CUST3 = "NONE",
    parameter FEATURE_CUST4 = "NONE",
    parameter FEATURE_CUST5 = "NONE",
    parameter FEATURE_CUST6 = "NONE",
    parameter FEATURE_CUST7 = "NONE",
    parameter FEATURE_CUST8 = "NONE",

    parameter FEATURE_STORE_BUFFER = "ENABLED",
    parameter OPTION_STORE_BUFFER_DEPTH_WIDTH = 8,

    parameter FEATURE_MULTICORE = "NONE",

    parameter FEATURE_TRACEPORT_EXEC = "NONE",
    parameter FEATURE_BRANCH_PREDICTOR = "SIMPLE"  // SIMPLE|SAT_COUNTER|GSHARE
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

    output reg	                      traceport_exec_valid_o,
    output reg [31:0]                 traceport_exec_pc_o,
    output reg                        traceport_exec_jb_o,
    output reg                        traceport_exec_jal_o,
    output reg                        traceport_exec_jr_o,
    output reg [31:0]                 traceport_exec_jbtarget_o,
    output reg [`OR1K_INSN_WIDTH-1:0] traceport_exec_insn_o,
    output [OPTION_OPERAND_WIDTH-1:0] traceport_exec_wbdata_o,
    output [OPTION_RF_ADDR_WIDTH-1:0] traceport_exec_wbreg_o,
    output                            traceport_exec_wben_o,

    // SPR accesses to external units (cache, mmu, etc.)
    output [15:0] 		      spr_bus_addr_o,
    output 			      spr_bus_we_o,
    output 			      spr_bus_stb_o,
    output [OPTION_OPERAND_WIDTH-1:0] spr_bus_dat_o,
    input [OPTION_OPERAND_WIDTH-1:0]  spr_bus_dat_mac_i,
    input 			      spr_bus_ack_mac_i,
    input [OPTION_OPERAND_WIDTH-1:0]  spr_bus_dat_pmu_i,
    input 			      spr_bus_ack_pmu_i,
    input [OPTION_OPERAND_WIDTH-1:0]  spr_bus_dat_pcu_i,
    input 			      spr_bus_ack_pcu_i,
    input [OPTION_OPERAND_WIDTH-1:0]  spr_bus_dat_fpu_i,
    input 			      spr_bus_ack_fpu_i,
    output [15:0] 		      spr_sr_o,

    input [OPTION_OPERAND_WIDTH-1:0]  multicore_coreid_i,
    input [OPTION_OPERAND_WIDTH-1:0]  multicore_numcores_i,

    input [31:0] 		     snoop_adr_i,
    input 			     snoop_en_i
    );

   wire [OPTION_OPERAND_WIDTH-1:0]   pc_fetch_to_decode;
   wire [`OR1K_INSN_WIDTH-1:0] 	     insn_fetch_to_decode;
   wire [OPTION_OPERAND_WIDTH-1:0]   pc_decode_to_execute;
   wire [OPTION_OPERAND_WIDTH-1:0]   pc_execute_to_ctrl;

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [OPTION_OPERAND_WIDTH-1:0] adder_result_o;// From mor1kx_execute_alu of mor1kx_execute_alu.v
   wire [OPTION_OPERAND_WIDTH-1:0] alu_result_o;// From mor1kx_execute_alu of mor1kx_execute_alu.v
   wire                 alu_valid_o;            // From mor1kx_execute_alu of mor1kx_execute_alu.v
   wire                 atomic_flag_clear_o;    // From mor1kx_lsu_cappuccino of mor1kx_lsu_cappuccino.v
   wire                 atomic_flag_set_o;      // From mor1kx_lsu_cappuccino of mor1kx_lsu_cappuccino.v
   wire                 branch_mispredict_o;    // From mor1kx_branch_prediction of mor1kx_branch_prediction.v
   wire                 carry_clear_o;          // From mor1kx_execute_alu of mor1kx_execute_alu.v
   wire                 carry_set_o;            // From mor1kx_execute_alu of mor1kx_execute_alu.v
   wire [OPTION_OPERAND_WIDTH-1:0] ctrl_alu_result_o;// From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire [OPTION_OPERAND_WIDTH-1:0] ctrl_branch_except_pc_o;// From mor1kx_ctrl_cappuccino of mor1kx_ctrl_cappuccino.v
   wire                 ctrl_branch_exception_o;// From mor1kx_ctrl_cappuccino of mor1kx_ctrl_cappuccino.v
   wire                 ctrl_bubble_o;          // From mor1kx_ctrl_cappuccino of mor1kx_ctrl_cappuccino.v
   wire                 ctrl_carry_clear_o;     // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire                 ctrl_carry_o;           // From mor1kx_ctrl_cappuccino of mor1kx_ctrl_cappuccino.v
   wire                 ctrl_carry_set_o;       // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire [OPTION_OPERAND_WIDTH-1:0] ctrl_epcr_o; // From mor1kx_ctrl_cappuccino of mor1kx_ctrl_cappuccino.v
   wire                 ctrl_except_align_o;    // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire                 ctrl_except_dbus_o;     // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire                 ctrl_except_dpagefault_o;// From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire                 ctrl_except_dtlb_miss_o;// From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire                 ctrl_except_ibus_align_o;// From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire                 ctrl_except_ibus_err_o; // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire                 ctrl_except_illegal_o;  // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire                 ctrl_except_ipagefault_o;// From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire                 ctrl_except_itlb_miss_o;// From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire                 ctrl_except_syscall_o;  // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire                 ctrl_except_trap_o;     // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire                 ctrl_flag_clear_o;      // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire                 ctrl_flag_o;            // From mor1kx_ctrl_cappuccino of mor1kx_ctrl_cappuccino.v
   wire                 ctrl_flag_set_o;        // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire [OPTION_OPERAND_WIDTH-1:0] ctrl_lsu_adr_o;// From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire [1:0]           ctrl_lsu_length_o;      // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire                 ctrl_lsu_zext_o;        // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire                 ctrl_mfspr_ack_o;       // From mor1kx_ctrl_cappuccino of mor1kx_ctrl_cappuccino.v
   wire                 ctrl_mtspr_ack_o;       // From mor1kx_ctrl_cappuccino of mor1kx_ctrl_cappuccino.v
   wire                 ctrl_op_lsu_atomic_o;   // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire                 ctrl_op_lsu_load_o;     // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire                 ctrl_op_lsu_store_o;    // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire                 ctrl_op_mfspr_o;        // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire                 ctrl_op_msync_o;        // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire                 ctrl_op_mtspr_o;        // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire                 ctrl_op_mul_o;          // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire                 ctrl_op_rfe_o;          // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire                 ctrl_overflow_clear_o;  // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire                 ctrl_overflow_set_o;    // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire [`OR1K_FPCSR_WIDTH-1:0]   ctrl_fpcsr_o; // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire                           ctrl_fpcsr_set_o; // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire [`OR1K_FPCSR_RM_SIZE-1:0] ctrl_fpu_round_mode_o; // From mor1kx_ctrl_cappuccino of mor1kx_ctrl_cappuccino.v 
   wire                 ctrl_rf_wb_o;           // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire [OPTION_OPERAND_WIDTH-1:0] ctrl_rfb_o;  // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire [OPTION_RF_ADDR_WIDTH-1:0] ctrl_rfd_adr_o;// From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire                 ctrl_valid_o;           // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire                 decode_adder_do_carry_o;// From mor1kx_decode of mor1kx_decode.v
   wire                 decode_adder_do_sub_o;  // From mor1kx_decode of mor1kx_decode.v
   wire                 decode_branch_o;        // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire [OPTION_OPERAND_WIDTH-1:0] decode_branch_target_o;// From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 decode_bubble_o;        // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 decode_except_ibus_err_o;// From mor1kx_fetch_cappuccino of mor1kx_fetch_cappuccino.v
   wire                 decode_except_illegal_o;// From mor1kx_decode of mor1kx_decode.v
   wire                 decode_except_ipagefault_o;// From mor1kx_fetch_cappuccino of mor1kx_fetch_cappuccino.v
   wire                 decode_except_itlb_miss_o;// From mor1kx_fetch_cappuccino of mor1kx_fetch_cappuccino.v
   wire                 decode_except_syscall_o;// From mor1kx_decode of mor1kx_decode.v
   wire                 decode_except_trap_o;   // From mor1kx_decode of mor1kx_decode.v
   wire [`OR1K_IMM_WIDTH-1:0] decode_imm16_o;   // From mor1kx_decode of mor1kx_decode.v
   wire [OPTION_OPERAND_WIDTH-1:0] decode_immediate_o;// From mor1kx_decode of mor1kx_decode.v
   wire                 decode_immediate_sel_o; // From mor1kx_decode of mor1kx_decode.v
   wire [9:0]           decode_immjbr_upper_o;  // From mor1kx_decode of mor1kx_decode.v
   wire [1:0]           decode_lsu_length_o;    // From mor1kx_decode of mor1kx_decode.v
   wire                 decode_lsu_zext_o;      // From mor1kx_decode of mor1kx_decode.v
   wire                 decode_op_add_o;        // From mor1kx_decode of mor1kx_decode.v
   wire                 decode_op_alu_o;        // From mor1kx_decode of mor1kx_decode.v
   wire                 decode_op_bf_o;         // From mor1kx_decode of mor1kx_decode.v
   wire                 decode_op_bnf_o;        // From mor1kx_decode of mor1kx_decode.v
   wire                 decode_op_branch_o;     // From mor1kx_decode of mor1kx_decode.v
   wire                 decode_op_brcond_o;     // From mor1kx_decode of mor1kx_decode.v
   wire                 decode_op_div_o;        // From mor1kx_decode of mor1kx_decode.v
   wire                 decode_op_div_signed_o; // From mor1kx_decode of mor1kx_decode.v
   wire                 decode_op_div_unsigned_o;// From mor1kx_decode of mor1kx_decode.v
   wire                 decode_op_ffl1_o;       // From mor1kx_decode of mor1kx_decode.v
   wire                 decode_op_jal_o;        // From mor1kx_decode of mor1kx_decode.v
   wire                 decode_op_jbr_o;        // From mor1kx_decode of mor1kx_decode.v
   wire                 decode_op_jr_o;         // From mor1kx_decode of mor1kx_decode.v
   wire                 decode_op_lsu_atomic_o; // From mor1kx_decode of mor1kx_decode.v
   wire                 decode_op_lsu_load_o;   // From mor1kx_decode of mor1kx_decode.v
   wire                 decode_op_lsu_store_o;  // From mor1kx_decode of mor1kx_decode.v
   wire                 decode_op_mfspr_o;      // From mor1kx_decode of mor1kx_decode.v
   wire                 decode_op_movhi_o;      // From mor1kx_decode of mor1kx_decode.v
   wire                 decode_op_ext_o;      // From mor1kx_decode of mor1kx_decode.v
   wire                 decode_op_msync_o;      // From mor1kx_decode of mor1kx_decode.v
   wire [`OR1K_FPUOP_WIDTH-1:0] decode_op_fpu_o; // From mor1kx_decode of mor1kx_decode.v
   wire                 decode_op_mtspr_o;      // From mor1kx_decode of mor1kx_decode.v
   wire                 decode_op_mul_o;        // From mor1kx_decode of mor1kx_decode.v
   wire                 decode_op_mul_signed_o; // From mor1kx_decode of mor1kx_decode.v
   wire                 decode_op_mul_unsigned_o;// From mor1kx_decode of mor1kx_decode.v
   wire                 decode_op_rfe_o;        // From mor1kx_decode of mor1kx_decode.v
   wire                 decode_op_setflag_o;    // From mor1kx_decode of mor1kx_decode.v
   wire                 decode_op_shift_o;      // From mor1kx_decode of mor1kx_decode.v
   wire [`OR1K_ALU_OPC_WIDTH-1:0] decode_opc_alu_o;// From mor1kx_decode of mor1kx_decode.v
   wire [`OR1K_ALU_OPC_WIDTH-1:0] decode_opc_alu_secondary_o;// From mor1kx_decode of mor1kx_decode.v
   wire [`OR1K_OPCODE_WIDTH-1:0] decode_opc_insn_o;// From mor1kx_decode of mor1kx_decode.v
   wire                 decode_rf_wb_o;         // From mor1kx_decode of mor1kx_decode.v
   wire [OPTION_RF_ADDR_WIDTH-1:0] decode_rfa_adr_o;// From mor1kx_decode of mor1kx_decode.v
   wire [OPTION_OPERAND_WIDTH-1:0] decode_rfa_o;// From mor1kx_rf_cappuccino of mor1kx_rf_cappuccino.v
   wire [OPTION_RF_ADDR_WIDTH-1:0] decode_rfb_adr_o;// From mor1kx_decode of mor1kx_decode.v
   wire [OPTION_OPERAND_WIDTH-1:0] decode_rfb_o;// From mor1kx_rf_cappuccino of mor1kx_rf_cappuccino.v
   wire [OPTION_RF_ADDR_WIDTH-1:0] decode_rfd_adr_o;// From mor1kx_decode of mor1kx_decode.v
   wire                 decode_valid_o;         // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 doing_rfe_o;            // From mor1kx_ctrl_cappuccino of mor1kx_ctrl_cappuccino.v
   wire                 du_restart_o;           // From mor1kx_ctrl_cappuccino of mor1kx_ctrl_cappuccino.v
   wire [OPTION_OPERAND_WIDTH-1:0] du_restart_pc_o;// From mor1kx_ctrl_cappuccino of mor1kx_ctrl_cappuccino.v
   wire                 execute_adder_do_carry_o;// From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_adder_do_sub_o; // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_bubble_o;       // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_except_ibus_align_o;// From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_except_ibus_err_o;// From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_except_illegal_o;// From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_except_ipagefault_o;// From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_except_itlb_miss_o;// From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_except_syscall_o;// From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_except_trap_o;  // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire [`OR1K_IMM_WIDTH-1:0] execute_imm16_o;  // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire [OPTION_OPERAND_WIDTH-1:0] execute_immediate_o;// From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_immediate_sel_o;// From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire [9:0]           execute_immjbr_upper_o; // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire [OPTION_OPERAND_WIDTH-1:0] execute_jal_result_o;// From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire [1:0]           execute_lsu_length_o;   // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_lsu_zext_o;     // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire [OPTION_OPERAND_WIDTH-1:0] execute_mispredict_target_o;// From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_op_add_o;       // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_op_alu_o;       // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_op_bf_o;
   wire                 execute_op_bnf_o;
   wire                 execute_op_branch_o;    // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_op_brcond_o;    // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_op_div_o;       // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_op_div_signed_o;// From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_op_div_unsigned_o;// From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_op_ffl1_o;      // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_op_jal_o;       // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_op_jbr_o;       // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_op_jr_o;        // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_op_lsu_atomic_o;// From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_op_lsu_load_o;  // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_op_lsu_store_o; // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_op_mfspr_o;     // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_op_movhi_o;     // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_op_ext_o;     // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_op_msync_o;     // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire [`OR1K_FPUOP_WIDTH-1:0] execute_op_fpu_o; // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_op_mtspr_o;     // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_op_mul_o;       // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_op_mul_signed_o;// From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_op_mul_unsigned_o;// From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_op_rfe_o;       // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_op_setflag_o;   // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_op_shift_o;     // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire [`OR1K_ALU_OPC_WIDTH-1:0] execute_opc_alu_o;// From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire [`OR1K_ALU_OPC_WIDTH-1:0] execute_opc_alu_secondary_o;// From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire [`OR1K_OPCODE_WIDTH-1:0] execute_opc_insn_o;// From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_predicted_flag_o;// From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_rf_wb_o;        // From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire [OPTION_OPERAND_WIDTH-1:0] execute_rfa_o;// From mor1kx_rf_cappuccino of mor1kx_rf_cappuccino.v
   wire [OPTION_OPERAND_WIDTH-1:0] execute_rfb_o;// From mor1kx_rf_cappuccino of mor1kx_rf_cappuccino.v
   wire [OPTION_RF_ADDR_WIDTH-1:0] execute_rfd_adr_o;// From mor1kx_decode_execute_cappuccino of mor1kx_decode_execute_cappuccino.v
   wire                 execute_valid_o;        // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire                 fetch_exception_taken_o;// From mor1kx_fetch_cappuccino of mor1kx_fetch_cappuccino.v
   wire                 fetch_rf_adr_valid_o;   // From mor1kx_fetch_cappuccino of mor1kx_fetch_cappuccino.v
   wire [OPTION_RF_ADDR_WIDTH-1:0] fetch_rfa_adr_o;// From mor1kx_fetch_cappuccino of mor1kx_fetch_cappuccino.v
   wire [OPTION_RF_ADDR_WIDTH-1:0] fetch_rfb_adr_o;// From mor1kx_fetch_cappuccino of mor1kx_fetch_cappuccino.v
   wire                 fetch_valid_o;          // From mor1kx_fetch_cappuccino of mor1kx_fetch_cappuccino.v
   wire                 flag_clear_o;           // From mor1kx_execute_alu of mor1kx_execute_alu.v
   wire                 flag_set_o;             // From mor1kx_execute_alu of mor1kx_execute_alu.v
   wire                 icache_hit_o;           // From mor1kx_fetch_cappuccino of mor1kx_fetch_cappuccino.v
   wire                 dcache_hit_o;           // From mor1kx_lsu_cappuccino of mor1kx_lsu_cappuccino.v
   wire                 lsu_except_align_o;     // From mor1kx_lsu_cappuccino of mor1kx_lsu_cappuccino.v
   wire                 lsu_except_dbus_o;      // From mor1kx_lsu_cappuccino of mor1kx_lsu_cappuccino.v
   wire                 lsu_except_dpagefault_o;// From mor1kx_lsu_cappuccino of mor1kx_lsu_cappuccino.v
   wire                 lsu_except_dtlb_miss_o; // From mor1kx_lsu_cappuccino of mor1kx_lsu_cappuccino.v
   wire [OPTION_OPERAND_WIDTH-1:0] lsu_result_o;// From mor1kx_lsu_cappuccino of mor1kx_lsu_cappuccino.v
   wire                 lsu_valid_o;            // From mor1kx_lsu_cappuccino of mor1kx_lsu_cappuccino.v
   wire [OPTION_OPERAND_WIDTH-1:0] mfspr_dat_o; // From mor1kx_ctrl_cappuccino of mor1kx_ctrl_cappuccino.v
   wire                 msync_stall_o;          // From mor1kx_lsu_cappuccino of mor1kx_lsu_cappuccino.v
   wire [OPTION_OPERAND_WIDTH-1:0] mul_result_o;// From mor1kx_execute_alu of mor1kx_execute_alu.v
   wire                 overflow_clear_o;       // From mor1kx_execute_alu of mor1kx_execute_alu.v
   wire                 overflow_set_o;         // From mor1kx_execute_alu of mor1kx_execute_alu.v
   wire[`OR1K_FPCSR_WIDTH-1:0] fpcsr_o; // From mor1kx_execute_alu of mor1kx_execute_alu.v
   wire                        fpcsr_set_o; // From mor1kx_execute_alu of mor1kx_execute_alu.v
   wire                 padv_ctrl_o;            // From mor1kx_ctrl_cappuccino of mor1kx_ctrl_cappuccino.v
   wire                 padv_decode_o;          // From mor1kx_ctrl_cappuccino of mor1kx_ctrl_cappuccino.v
   wire                 padv_execute_o;         // From mor1kx_ctrl_cappuccino of mor1kx_ctrl_cappuccino.v
   wire                 padv_fetch_o;           // From mor1kx_ctrl_cappuccino of mor1kx_ctrl_cappuccino.v
   wire                 pipeline_flush_o;       // From mor1kx_ctrl_cappuccino of mor1kx_ctrl_cappuccino.v
   wire                 predicted_flag_o;       // From mor1kx_branch_prediction of mor1kx_branch_prediction.v
   wire [OPTION_OPERAND_WIDTH-1:0] rf_result_o; // From mor1kx_wb_mux_cappuccino of mor1kx_wb_mux_cappuccino.v
   wire                 spr_bus_ack_dc_i;       // From mor1kx_lsu_cappuccino of mor1kx_lsu_cappuccino.v
   wire                 spr_bus_ack_dmmu_i;     // From mor1kx_lsu_cappuccino of mor1kx_lsu_cappuccino.v
   wire                 spr_bus_ack_ic_i;       // From mor1kx_fetch_cappuccino of mor1kx_fetch_cappuccino.v
   wire                 spr_bus_ack_immu_i;     // From mor1kx_fetch_cappuccino of mor1kx_fetch_cappuccino.v
   wire [OPTION_OPERAND_WIDTH-1:0] spr_bus_dat_dc_i;// From mor1kx_lsu_cappuccino of mor1kx_lsu_cappuccino.v
   wire [OPTION_OPERAND_WIDTH-1:0] spr_bus_dat_dmmu_i;// From mor1kx_lsu_cappuccino of mor1kx_lsu_cappuccino.v
   wire [OPTION_OPERAND_WIDTH-1:0] spr_bus_dat_ic_i;// From mor1kx_fetch_cappuccino of mor1kx_fetch_cappuccino.v
   wire [OPTION_OPERAND_WIDTH-1:0] spr_bus_dat_immu_i;// From mor1kx_fetch_cappuccino of mor1kx_fetch_cappuccino.v
   wire                 spr_gpr_ack_o;          // From mor1kx_rf_cappuccino of mor1kx_rf_cappuccino.v
   wire [OPTION_OPERAND_WIDTH-1:0] spr_gpr_dat_o;// From mor1kx_rf_cappuccino of mor1kx_rf_cappuccino.v
   wire [OPTION_OPERAND_WIDTH-1:0] store_buffer_epcr_o;// From mor1kx_lsu_cappuccino of mor1kx_lsu_cappuccino.v
   wire                 store_buffer_err_o;     // From mor1kx_lsu_cappuccino of mor1kx_lsu_cappuccino.v
   wire                 wb_rf_wb_o;             // From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   wire [OPTION_RF_ADDR_WIDTH-1:0] wb_rfd_adr_o;// From mor1kx_execute_ctrl_cappuccino of mor1kx_execute_ctrl_cappuccino.v
   // End of automatics

   /* mor1kx_fetch_cappuccino AUTO_TEMPLATE (
    .padv_i				(padv_fetch_o),
    .padv_ctrl_i			(padv_ctrl_o),
    .decode_branch_i			(decode_branch_o),
    .decode_branch_target_i		(decode_branch_target_o),
    .ctrl_branch_exception_i		(ctrl_branch_exception_o),
    .ctrl_branch_except_pc_i		(ctrl_branch_except_pc_o),
    .doing_rfe_i			(doing_rfe_o),
    .pipeline_flush_i			(pipeline_flush_o),
    .pc_decode_o			(pc_fetch_to_decode),
    .decode_insn_o			(insn_fetch_to_decode),
    .du_restart_pc_i			(du_restart_pc_o),
    .du_restart_i			(du_restart_o),
    .decode_op_brcond_i			(decode_op_brcond_o),
    .branch_mispredict_i		(branch_mispredict_o),
    .execute_mispredict_target_i	(execute_mispredict_target_o),
    .spr_bus_dat_ic_o			(spr_bus_dat_ic_i[OPTION_OPERAND_WIDTH-1:0]),
    .spr_bus_ack_ic_o			(spr_bus_ack_ic_i),
    .spr_bus_dat_immu_o			(spr_bus_dat_immu_i[OPTION_OPERAND_WIDTH-1:0]),
    .spr_bus_ack_immu_o			(spr_bus_ack_immu_i),
    .spr_bus_addr_i			(spr_bus_addr_o[15:0]),
    .spr_bus_we_i			(spr_bus_we_o),
    .spr_bus_stb_i			(spr_bus_stb_o),
    .spr_bus_dat_i			(spr_bus_dat_o[OPTION_OPERAND_WIDTH-1:0]),
    .ic_enable				(spr_sr_o[`OR1K_SPR_SR_ICE]),
    .immu_enable_i			(spr_sr_o[`OR1K_SPR_SR_IME]),
    .supervisor_mode_i			(spr_sr_o[`OR1K_SPR_SR_SM]),
    ); */
   mor1kx_fetch_cappuccino
     #(
       .OPTION_OPERAND_WIDTH(OPTION_OPERAND_WIDTH),
       .OPTION_RESET_PC(OPTION_RESET_PC),
       .FEATURE_INSTRUCTIONCACHE(FEATURE_INSTRUCTIONCACHE),
       .OPTION_ICACHE_BLOCK_WIDTH(OPTION_ICACHE_BLOCK_WIDTH),
       .OPTION_ICACHE_SET_WIDTH(OPTION_ICACHE_SET_WIDTH),
       .OPTION_ICACHE_WAYS(OPTION_ICACHE_WAYS),
       .OPTION_ICACHE_LIMIT_WIDTH(OPTION_ICACHE_LIMIT_WIDTH),
       .FEATURE_IMMU(FEATURE_IMMU),
       .FEATURE_IMMU_HW_TLB_RELOAD(FEATURE_IMMU_HW_TLB_RELOAD),
       .OPTION_IMMU_SET_WIDTH(OPTION_IMMU_SET_WIDTH),
       .OPTION_IMMU_WAYS(OPTION_IMMU_WAYS)
       )
     mor1kx_fetch_cappuccino
     (/*AUTOINST*/
      // Outputs
      .spr_bus_dat_ic_o                 (spr_bus_dat_ic_i[OPTION_OPERAND_WIDTH-1:0]), // Templated
      .spr_bus_ack_ic_o                 (spr_bus_ack_ic_i),      // Templated
      .spr_bus_dat_immu_o               (spr_bus_dat_immu_i[OPTION_OPERAND_WIDTH-1:0]), // Templated
      .spr_bus_ack_immu_o               (spr_bus_ack_immu_i),    // Templated
      .ibus_req_o                       (ibus_req_o),
      .ibus_adr_o                       (ibus_adr_o[OPTION_OPERAND_WIDTH-1:0]),
      .ibus_burst_o                     (ibus_burst_o),
      .pc_decode_o                      (pc_fetch_to_decode),    // Templated
      .decode_insn_o                    (insn_fetch_to_decode),  // Templated
      .fetch_valid_o                    (fetch_valid_o),
      .fetch_rfa_adr_o                  (fetch_rfa_adr_o[OPTION_RF_ADDR_WIDTH-1:0]),
      .fetch_rfb_adr_o                  (fetch_rfb_adr_o[OPTION_RF_ADDR_WIDTH-1:0]),
      .fetch_rf_adr_valid_o             (fetch_rf_adr_valid_o),
      .decode_except_ibus_err_o         (decode_except_ibus_err_o),
      .decode_except_itlb_miss_o        (decode_except_itlb_miss_o),
      .decode_except_ipagefault_o       (decode_except_ipagefault_o),
      .fetch_exception_taken_o          (fetch_exception_taken_o),
      .ic_hit_o                         (icache_hit_o),
      // Inputs
      .clk                              (clk),
      .rst                              (rst),
      .spr_bus_addr_i                   (spr_bus_addr_o[15:0]),  // Templated
      .spr_bus_we_i                     (spr_bus_we_o),          // Templated
      .spr_bus_stb_i                    (spr_bus_stb_o),         // Templated
      .spr_bus_dat_i                    (spr_bus_dat_o[OPTION_OPERAND_WIDTH-1:0]), // Templated
      .ic_enable                        (spr_sr_o[`OR1K_SPR_SR_ICE]), // Templated
      .immu_enable_i                    (spr_sr_o[`OR1K_SPR_SR_IME]), // Templated
      .supervisor_mode_i                (spr_sr_o[`OR1K_SPR_SR_SM]), // Templated
      .ibus_err_i                       (ibus_err_i),
      .ibus_ack_i                       (ibus_ack_i),
      .ibus_dat_i                       (ibus_dat_i[`OR1K_INSN_WIDTH-1:0]),
      .padv_i                           (padv_fetch_o),          // Templated
      .padv_ctrl_i                      (padv_ctrl_o),           // Templated
      .decode_branch_i                  (decode_branch_o),       // Templated
      .decode_branch_target_i           (decode_branch_target_o), // Templated
      .ctrl_branch_exception_i          (ctrl_branch_exception_o), // Templated
      .ctrl_branch_except_pc_i          (ctrl_branch_except_pc_o), // Templated
      .du_restart_i                     (du_restart_o),          // Templated
      .du_restart_pc_i                  (du_restart_pc_o),       // Templated
      .decode_op_brcond_i               (decode_op_brcond_o),    // Templated
      .branch_mispredict_i              (branch_mispredict_o),   // Templated
      .execute_mispredict_target_i      (execute_mispredict_target_o), // Templated
      .pipeline_flush_i                 (pipeline_flush_o),      // Templated
      .doing_rfe_i                      (doing_rfe_o));           // Templated

   /* mor1kx_decode AUTO_TEMPLATE (
    .decode_insn_i			(insn_fetch_to_decode),
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
       .FEATURE_ATOMIC(FEATURE_ATOMIC),
       .FEATURE_FPU(FEATURE_FPU), // pipeline cappuccino: decode instance
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
      .decode_opc_alu_o                 (decode_opc_alu_o[`OR1K_ALU_OPC_WIDTH-1:0]),
      .decode_opc_alu_secondary_o       (decode_opc_alu_secondary_o[`OR1K_ALU_OPC_WIDTH-1:0]),
      .decode_imm16_o                   (decode_imm16_o[`OR1K_IMM_WIDTH-1:0]),
      .decode_immediate_o               (decode_immediate_o[OPTION_OPERAND_WIDTH-1:0]),
      .decode_immediate_sel_o           (decode_immediate_sel_o),
      .decode_immjbr_upper_o            (decode_immjbr_upper_o[9:0]),
      .decode_rfd_adr_o                 (decode_rfd_adr_o[OPTION_RF_ADDR_WIDTH-1:0]),
      .decode_rfa_adr_o                 (decode_rfa_adr_o[OPTION_RF_ADDR_WIDTH-1:0]),
      .decode_rfb_adr_o                 (decode_rfb_adr_o[OPTION_RF_ADDR_WIDTH-1:0]),
      .decode_rf_wb_o                   (decode_rf_wb_o),
      .decode_op_jbr_o                  (decode_op_jbr_o),
      .decode_op_jr_o                   (decode_op_jr_o),
      .decode_op_jal_o                  (decode_op_jal_o),
      .decode_op_bf_o                   (decode_op_bf_o),
      .decode_op_bnf_o                  (decode_op_bnf_o),
      .decode_op_brcond_o               (decode_op_brcond_o),
      .decode_op_branch_o               (decode_op_branch_o),
      .decode_op_alu_o                  (decode_op_alu_o),
      .decode_op_lsu_load_o             (decode_op_lsu_load_o),
      .decode_op_lsu_store_o            (decode_op_lsu_store_o),
      .decode_op_lsu_atomic_o           (decode_op_lsu_atomic_o),
      .decode_lsu_length_o              (decode_lsu_length_o[1:0]),
      .decode_lsu_zext_o                (decode_lsu_zext_o),
      .decode_op_mfspr_o                (decode_op_mfspr_o),
      .decode_op_mtspr_o                (decode_op_mtspr_o),
      .decode_op_rfe_o                  (decode_op_rfe_o),
      .decode_op_setflag_o              (decode_op_setflag_o),
      .decode_op_add_o                  (decode_op_add_o),
      .decode_op_mul_o                  (decode_op_mul_o),
      .decode_op_mul_signed_o           (decode_op_mul_signed_o),
      .decode_op_mul_unsigned_o         (decode_op_mul_unsigned_o),
      .decode_op_div_o                  (decode_op_div_o),
      .decode_op_div_signed_o           (decode_op_div_signed_o),
      .decode_op_div_unsigned_o         (decode_op_div_unsigned_o),
      .decode_op_shift_o                (decode_op_shift_o),
      .decode_op_ffl1_o                 (decode_op_ffl1_o),
      .decode_op_movhi_o                (decode_op_movhi_o),
      .decode_op_ext_o                  (decode_op_ext_o),
      .decode_op_msync_o                (decode_op_msync_o),
      .decode_op_fpu_o                  (decode_op_fpu_o),
      .decode_adder_do_sub_o            (decode_adder_do_sub_o),
      .decode_adder_do_carry_o          (decode_adder_do_carry_o),
      .decode_except_illegal_o          (decode_except_illegal_o),
      .decode_except_syscall_o          (decode_except_syscall_o),
      .decode_except_trap_o             (decode_except_trap_o),
      .decode_opc_insn_o                (decode_opc_insn_o[`OR1K_OPCODE_WIDTH-1:0]),
      // Inputs
      .clk                              (clk),
      .rst                              (rst),
      .decode_insn_i                    (insn_fetch_to_decode));  // Templated

   /* mor1kx_decode_execute_cappuccino AUTO_TEMPLATE (
      .padv_i				(padv_decode_o),
      .pc_decode_i			(pc_fetch_to_decode),
      .decode_rfb_i			(decode_rfb_o),
      .execute_rfb_i			(execute_rfb_o),
      .predicted_flag_i			(predicted_flag_o),
      .flag_i				(ctrl_flag_o),
      .pc_execute_o			(pc_decode_to_execute),
      .pipeline_flush_i			(pipeline_flush_o),
      .decode_opc_alu_i			(decode_opc_alu_o),
      .decode_opc_alu_secondary_i	(decode_opc_alu_secondary_o),
      .decode_imm16_i			(decode_imm16_o),
      .decode_immediate_i		(decode_immediate_o),
      .decode_immediate_sel_i		(decode_immediate_sel_o),
      .decode_immjbr_upper_i		(decode_immjbr_upper_o),
      .decode_adder_do_sub_i		(decode_adder_do_sub_o),
      .decode_adder_do_carry_i		(decode_adder_do_carry_o),
      .decode_rfd_adr_i			(decode_rfd_adr_o),
      .decode_rfa_adr_i			(decode_rfa_adr_o),
      .decode_rfb_adr_i			(decode_rfb_adr_o),
      .ctrl_rfd_adr_i			(ctrl_rfd_adr_o),
      .ctrl_op_lsu_load_i		(ctrl_op_lsu_load_o),
      .ctrl_op_mfspr_i			(ctrl_op_mfspr_o),
      .ctrl_op_mul_i			(ctrl_op_mul_o),
      .decode_rf_wb_i			(decode_rf_wb_o),
      .decode_op_alu_i			(decode_op_alu_o),
      .decode_op_setflag_i		(decode_op_setflag_o),
      .decode_op_jbr_i			(decode_op_jbr_o),
      .decode_op_jr_i			(decode_op_jr_o),
      .decode_op_jal_i			(decode_op_jal_o),
      .decode_op_bf_i			(decode_op_bf_o),
      .decode_op_bnf_i			(decode_op_bnf_o),
      .decode_op_brcond_i		(decode_op_brcond_o),
      .decode_op_branch_i		(decode_op_branch_o),
      .decode_op_lsu_load_i		(decode_op_lsu_load_o),
      .decode_op_lsu_store_i		(decode_op_lsu_store_o),
      .decode_op_lsu_atomic_i		(decode_op_lsu_atomic_o),
      .decode_lsu_length_i		(decode_lsu_length_o[1:0]),
      .decode_lsu_zext_i		(decode_lsu_zext_o),
      .decode_op_mfspr_i		(decode_op_mfspr_o),
      .decode_op_mtspr_i		(decode_op_mtspr_o),
      .decode_op_rfe_i			(decode_op_rfe_o),
      .decode_op_add_i			(decode_op_add_o),
      .decode_op_mul_i			(decode_op_mul_o),
      .decode_op_mul_signed_i		(decode_op_mul_signed_o),
      .decode_op_mul_unsigned_i		(decode_op_mul_unsigned_o),
      .decode_op_div_i			(decode_op_div_o),
      .decode_op_div_signed_i		(decode_op_div_signed_o),
      .decode_op_div_unsigned_i		(decode_op_div_unsigned_o),
      .decode_op_shift_i		(decode_op_shift_o),
      .decode_op_ffl1_i			(decode_op_ffl1_o),
      .decode_op_movhi_i		(decode_op_movhi_o),
      .decode_op_msync_i                (decode_op_msync_o),
      .decode_op_fpu_i		  (decode_op_fpu_o),
      .decode_opc_insn_i		(decode_opc_insn_o[`OR1K_OPCODE_WIDTH-1:0]),
      .decode_except_ibus_err_i		(decode_except_ibus_err_o),
      .decode_except_itlb_miss_i	(decode_except_itlb_miss_o),
      .decode_except_ipagefault_i	(decode_except_ipagefault_o),
      .decode_except_illegal_i		(decode_except_illegal_o),
      .decode_except_syscall_i		(decode_except_syscall_o),
      .decode_except_trap_i		(decode_except_trap_o),
    ); */
   mor1kx_decode_execute_cappuccino
     #(
       .OPTION_OPERAND_WIDTH(OPTION_OPERAND_WIDTH),
       .OPTION_RESET_PC(OPTION_RESET_PC),
       .OPTION_RF_ADDR_WIDTH(OPTION_RF_ADDR_WIDTH),
       .FEATURE_SYSCALL(FEATURE_SYSCALL),
       .FEATURE_TRAP(FEATURE_TRAP),
       .FEATURE_FPU(FEATURE_FPU), // pipeline cappuccino: decode_execute instance
       .FEATURE_MULTIPLIER(FEATURE_MULTIPLIER)
       )
     mor1kx_decode_execute_cappuccino
     (/*AUTOINST*/
      // Outputs
      .execute_predicted_flag_o         (execute_predicted_flag_o),
      .execute_mispredict_target_o      (execute_mispredict_target_o[OPTION_OPERAND_WIDTH-1:0]),
      .execute_opc_alu_o                (execute_opc_alu_o[`OR1K_ALU_OPC_WIDTH-1:0]),
      .execute_opc_alu_secondary_o      (execute_opc_alu_secondary_o[`OR1K_ALU_OPC_WIDTH-1:0]),
      .execute_imm16_o                  (execute_imm16_o[`OR1K_IMM_WIDTH-1:0]),
      .execute_immediate_o              (execute_immediate_o[OPTION_OPERAND_WIDTH-1:0]),
      .execute_immediate_sel_o          (execute_immediate_sel_o),
      .execute_adder_do_sub_o           (execute_adder_do_sub_o),
      .execute_adder_do_carry_o         (execute_adder_do_carry_o),
      .execute_immjbr_upper_o           (execute_immjbr_upper_o[9:0]),
      .execute_rfd_adr_o                (execute_rfd_adr_o[OPTION_RF_ADDR_WIDTH-1:0]),
      .execute_rf_wb_o                  (execute_rf_wb_o),
      .execute_op_alu_o                 (execute_op_alu_o),
      .execute_op_setflag_o             (execute_op_setflag_o),
      .execute_op_jbr_o                 (execute_op_jbr_o),
      .execute_op_jr_o                  (execute_op_jr_o),
      .execute_op_jal_o                 (execute_op_jal_o),
      .execute_op_brcond_o              (execute_op_brcond_o),
      .execute_op_branch_o              (execute_op_branch_o),
      .execute_op_lsu_load_o            (execute_op_lsu_load_o),
      .execute_op_lsu_store_o           (execute_op_lsu_store_o),
      .execute_op_lsu_atomic_o          (execute_op_lsu_atomic_o),
      .execute_lsu_length_o             (execute_lsu_length_o[1:0]),
      .execute_lsu_zext_o               (execute_lsu_zext_o),
      .execute_op_mfspr_o               (execute_op_mfspr_o),
      .execute_op_mtspr_o               (execute_op_mtspr_o),
      .execute_op_rfe_o                 (execute_op_rfe_o),
      .execute_op_add_o                 (execute_op_add_o),
      .execute_op_mul_o                 (execute_op_mul_o),
      .execute_op_mul_signed_o          (execute_op_mul_signed_o),
      .execute_op_mul_unsigned_o        (execute_op_mul_unsigned_o),
      .execute_op_div_o                 (execute_op_div_o),
      .execute_op_div_signed_o          (execute_op_div_signed_o),
      .execute_op_div_unsigned_o        (execute_op_div_unsigned_o),
      .execute_op_shift_o               (execute_op_shift_o),
      .execute_op_ffl1_o                (execute_op_ffl1_o),
      .execute_op_movhi_o               (execute_op_movhi_o),
      .execute_op_ext_o                 (execute_op_ext_o),
      .execute_op_msync_o               (execute_op_msync_o),
      .execute_op_fpu_o                 (execute_op_fpu_o),
      .execute_op_bf_o                  (execute_op_bf_o),
      .execute_op_bnf_o                 (execute_op_bnf_o),
      .execute_jal_result_o             (execute_jal_result_o[OPTION_OPERAND_WIDTH-1:0]),
      .execute_opc_insn_o               (execute_opc_insn_o[`OR1K_OPCODE_WIDTH-1:0]),
      .decode_branch_o                  (decode_branch_o),
      .decode_branch_target_o           (decode_branch_target_o[OPTION_OPERAND_WIDTH-1:0]),
      .execute_except_ibus_err_o        (execute_except_ibus_err_o),
      .execute_except_itlb_miss_o       (execute_except_itlb_miss_o),
      .execute_except_ipagefault_o      (execute_except_ipagefault_o),
      .execute_except_illegal_o         (execute_except_illegal_o),
      .execute_except_ibus_align_o      (execute_except_ibus_align_o),
      .execute_except_syscall_o         (execute_except_syscall_o),
      .execute_except_trap_o            (execute_except_trap_o),
      .pc_execute_o                     (pc_decode_to_execute),  // Templated
      .decode_valid_o                   (decode_valid_o),
      .decode_bubble_o                  (decode_bubble_o),
      .execute_bubble_o                 (execute_bubble_o),
      // Inputs
      .clk                              (clk),
      .rst                              (rst),
      .padv_i                           (padv_decode_o),         // Templated
      .pc_decode_i                      (pc_fetch_to_decode),    // Templated
      .decode_rfb_i                     (decode_rfb_o),          // Templated
      .execute_rfb_i                    (execute_rfb_o),         // Templated
      .predicted_flag_i                 (predicted_flag_o),      // Templated
      .pipeline_flush_i                 (pipeline_flush_o),      // Templated
      .decode_opc_alu_i                 (decode_opc_alu_o),      // Templated
      .decode_opc_alu_secondary_i       (decode_opc_alu_secondary_o), // Templated
      .decode_imm16_i                   (decode_imm16_o),        // Templated
      .decode_immediate_i               (decode_immediate_o),    // Templated
      .decode_immediate_sel_i           (decode_immediate_sel_o), // Templated
      .decode_adder_do_sub_i            (decode_adder_do_sub_o), // Templated
      .decode_adder_do_carry_i          (decode_adder_do_carry_o), // Templated
      .decode_immjbr_upper_i            (decode_immjbr_upper_o), // Templated
      .decode_rfd_adr_i                 (decode_rfd_adr_o),      // Templated
      .decode_rfa_adr_i                 (decode_rfa_adr_o),      // Templated
      .decode_rfb_adr_i                 (decode_rfb_adr_o),      // Templated
      .ctrl_rfd_adr_i                   (ctrl_rfd_adr_o),        // Templated
      .ctrl_op_lsu_load_i               (ctrl_op_lsu_load_o),    // Templated
      .ctrl_op_mfspr_i                  (ctrl_op_mfspr_o),       // Templated
      .ctrl_op_mul_i                    (ctrl_op_mul_o),         // Templated
      .decode_rf_wb_i                   (decode_rf_wb_o),        // Templated
      .decode_op_alu_i                  (decode_op_alu_o),       // Templated
      .decode_op_setflag_i              (decode_op_setflag_o),   // Templated
      .decode_op_jbr_i                  (decode_op_jbr_o),       // Templated
      .decode_op_jr_i                   (decode_op_jr_o),        // Templated
      .decode_op_jal_i                  (decode_op_jal_o),       // Templated
      .decode_op_bf_i                   (decode_op_bf_o),        // Templated
      .decode_op_bnf_i                  (decode_op_bnf_o),       // Templated
      .decode_op_brcond_i               (decode_op_brcond_o),    // Templated
      .decode_op_branch_i               (decode_op_branch_o),    // Templated
      .decode_op_lsu_load_i             (decode_op_lsu_load_o),  // Templated
      .decode_op_lsu_store_i            (decode_op_lsu_store_o), // Templated
      .decode_op_lsu_atomic_i           (decode_op_lsu_atomic_o), // Templated
      .decode_lsu_length_i              (decode_lsu_length_o[1:0]), // Templated
      .decode_lsu_zext_i                (decode_lsu_zext_o),     // Templated
      .decode_op_mfspr_i                (decode_op_mfspr_o),     // Templated
      .decode_op_mtspr_i                (decode_op_mtspr_o),     // Templated
      .decode_op_rfe_i                  (decode_op_rfe_o),       // Templated
      .decode_op_add_i                  (decode_op_add_o),       // Templated
      .decode_op_mul_i                  (decode_op_mul_o),       // Templated
      .decode_op_mul_signed_i           (decode_op_mul_signed_o), // Templated
      .decode_op_mul_unsigned_i         (decode_op_mul_unsigned_o), // Templated
      .decode_op_div_i                  (decode_op_div_o),       // Templated
      .decode_op_div_signed_i           (decode_op_div_signed_o), // Templated
      .decode_op_div_unsigned_i         (decode_op_div_unsigned_o), // Templated
      .decode_op_shift_i                (decode_op_shift_o),     // Templated
      .decode_op_ffl1_i                 (decode_op_ffl1_o),      // Templated
      .decode_op_movhi_i                (decode_op_movhi_o),     // Templated
      .decode_op_ext_i                  (decode_op_ext_o),     // Templated
      .decode_op_msync_i                (decode_op_msync_o),     // Templated
      .decode_op_fpu_i                  (decode_op_fpu_o), // Templated
      .decode_opc_insn_i                (decode_opc_insn_o[`OR1K_OPCODE_WIDTH-1:0]), // Templated
      .decode_except_ibus_err_i         (decode_except_ibus_err_o), // Templated
      .decode_except_itlb_miss_i        (decode_except_itlb_miss_o), // Templated
      .decode_except_ipagefault_i       (decode_except_ipagefault_o), // Templated
      .decode_except_illegal_i          (decode_except_illegal_o), // Templated
      .decode_except_syscall_i          (decode_except_syscall_o), // Templated
      .decode_except_trap_i             (decode_except_trap_o));  // Templated

   /* mor1kx_branch_prediction AUTO_TEMPLATE (
      .op_bf_i				(decode_op_bf_o),
      .op_bnf_i				(decode_op_bnf_o),
      .execute_bf_i			(execute_op_bf_o),
      .execute_bnf_i			(execute_op_bnf_o),
      .padv_decode_i			(padv_decode_o),
      .immjbr_upper_i			(decode_immjbr_upper_o),
      .prev_op_brcond_i			(execute_op_brcond_o),
      .prev_predicted_flag_i		(execute_predicted_flag_o),
      .brn_pc_i			(pc_fetch_to_decode),
      .flag_i				(ctrl_flag_o),
    );*/
   mor1kx_branch_prediction
     #(
       .FEATURE_BRANCH_PREDICTOR(FEATURE_BRANCH_PREDICTOR),
       .OPTION_OPERAND_WIDTH(OPTION_OPERAND_WIDTH)
       )
   mor1kx_branch_prediction
     (/*AUTOINST*/
      // Outputs
      .predicted_flag_o                 (predicted_flag_o),
      .branch_mispredict_o              (branch_mispredict_o),
      // Inputs
      .clk                              (clk),
      .rst                              (rst),
      .op_bf_i                          (decode_op_bf_o),        // Templated
      .op_bnf_i                         (decode_op_bnf_o),       // Templated
      .execute_bf_i                     (execute_op_bf_o),        // Templated
      .execute_bnf_i                    (execute_op_bnf_o),        // Templated
      .padv_decode_i                    (padv_decode_o),        // Templated
      .immjbr_upper_i                   (decode_immjbr_upper_o), // Templated
      .prev_op_brcond_i                 (execute_op_brcond_o),   // Templated
      .prev_predicted_flag_i            (execute_predicted_flag_o), // Templated
      .brn_pc_i                         (pc_fetch_to_decode),      // Templated
      .flag_i                           (ctrl_flag_o));           // Templated

   /* mor1kx_execute_alu AUTO_TEMPLATE (
    .padv_decode_i			(padv_decode_o),
    .padv_execute_i			(padv_execute_o),
    .opc_alu_i			        (execute_opc_alu_o),
    .opc_alu_secondary_i		(execute_opc_alu_secondary_o),
    .imm16_i				(execute_imm16_o),
    .decode_immediate_i			(decode_immediate_o),
    .decode_immediate_sel_i		(decode_immediate_sel_o),
    .immediate_i			(execute_immediate_o),
    .immediate_sel_i			(execute_immediate_sel_o),
    .decode_valid_i			(decode_valid_o),
    .decode_op_mul_i			(decode_op_mul_o),
    .op_alu_i				(execute_op_alu_o),
    .op_add_i				(execute_op_add_o),
    .op_mul_i				(execute_op_mul_o),
    .op_mul_signed_i			(execute_op_mul_signed_o),
    .op_mul_unsigned_i			(execute_op_mul_unsigned_o),
    .op_div_i				(execute_op_div_o),
    .op_div_signed_i			(execute_op_div_signed_o),
    .op_div_unsigned_i			(execute_op_div_unsigned_o),
    .op_shift_i				(execute_op_shift_o),
    .op_ffl1_i				(execute_op_ffl1_o),
    .op_setflag_i			(execute_op_setflag_o),
    .op_mtspr_i				(execute_op_mtspr_o),
    .op_mfspr_i				(execute_op_mfspr_o),
    .op_movhi_i				(execute_op_movhi_o),
    .op_fpu_i				  (execute_op_fpu_o),
    .fpu_round_mode_i (ctrl_fpu_round_mode_o),
    .op_jbr_i				(execute_op_jbr_o),
    .op_jr_i				(execute_op_jr_o),
    .immjbr_upper_i			(execute_immjbr_upper_o),
    .pc_execute_i			(pc_decode_to_execute),
    .adder_do_sub_i			(execute_adder_do_sub_o),
    .adder_do_carry_i			(execute_adder_do_carry_o),
    .decode_rfa_i			(decode_rfa_o),
    .decode_rfb_i			(decode_rfb_o),
    .rfa_i				(execute_rfa_o),
    .rfb_i				(execute_rfb_o),
    .flag_i				(ctrl_flag_o),
    .carry_i                            (ctrl_carry_o),
    ); */
   mor1kx_execute_alu
     #(
       .OPTION_OPERAND_WIDTH(OPTION_OPERAND_WIDTH),
       .FEATURE_OVERFLOW(FEATURE_OVERFLOW),
       .FEATURE_CARRY_FLAG(FEATURE_CARRY_FLAG),
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
       .FEATURE_FPU(FEATURE_FPU), // pipeline cappuccino: execute_alu instance
       .OPTION_SHIFTER(OPTION_SHIFTER),
       .CALCULATE_BRANCH_DEST("FALSE")
       )
     mor1kx_execute_alu
     (/*AUTOINST*/
      // Outputs
      .flag_set_o                       (flag_set_o),
      .flag_clear_o                     (flag_clear_o),
      .carry_set_o                      (carry_set_o),
      .carry_clear_o                    (carry_clear_o),
      .overflow_set_o                   (overflow_set_o),
      .overflow_clear_o                 (overflow_clear_o),
      .fpcsr_o                          (fpcsr_o),
      .fpcsr_set_o                      (fpcsr_set_o),
      .alu_result_o                     (alu_result_o[OPTION_OPERAND_WIDTH-1:0]),
      .alu_valid_o                      (alu_valid_o),
      .mul_result_o                     (mul_result_o[OPTION_OPERAND_WIDTH-1:0]),
      .adder_result_o                   (adder_result_o[OPTION_OPERAND_WIDTH-1:0]),
      // Inputs
      .clk                              (clk),
      .rst                              (rst),
      .padv_decode_i                    (padv_decode_o),         // Templated
      .padv_execute_i                   (padv_execute_o),        // Templated
      .pipeline_flush_i                 (pipeline_flush_o),
      .opc_alu_i                        (execute_opc_alu_o),     // Templated
      .opc_alu_secondary_i              (execute_opc_alu_secondary_o), // Templated
      .imm16_i                          (execute_imm16_o),       // Templated
      .immediate_i                      (execute_immediate_o),   // Templated
      .immediate_sel_i                  (execute_immediate_sel_o), // Templated
      .decode_immediate_i               (decode_immediate_o),    // Templated
      .decode_immediate_sel_i           (decode_immediate_sel_o), // Templated
      .decode_valid_i                   (decode_valid_o),        // Templated
      .decode_op_mul_i                  (decode_op_mul_o),       // Templated
      .op_alu_i                         (execute_op_alu_o),      // Templated
      .op_add_i                         (execute_op_add_o),      // Templated
      .op_mul_i                         (execute_op_mul_o),      // Templated
      .op_mul_signed_i                  (execute_op_mul_signed_o), // Templated
      .op_mul_unsigned_i                (execute_op_mul_unsigned_o), // Templated
      .op_div_i                         (execute_op_div_o),      // Templated
      .op_div_signed_i                  (execute_op_div_signed_o), // Templated
      .op_div_unsigned_i                (execute_op_div_unsigned_o), // Templated
      .op_shift_i                       (execute_op_shift_o),    // Templated
      .op_ffl1_i                        (execute_op_ffl1_o),     // Templated
      .op_setflag_i                     (execute_op_setflag_o),  // Templated
      .op_mtspr_i                       (execute_op_mtspr_o),    // Templated
      .op_mfspr_i                       (execute_op_mfspr_o),    // Templated
      .op_movhi_i                       (execute_op_movhi_o),    // Templated
      .op_ext_i                         (execute_op_ext_o),    // Templated
      .op_fpu_i                         (execute_op_fpu_o), // Templated
      .fpu_round_mode_i                 (ctrl_fpu_round_mode_o), // Templated
      .op_jbr_i                         (execute_op_jbr_o),      // Templated
      .op_jr_i                          (execute_op_jr_o),       // Templated
      .immjbr_upper_i                   (execute_immjbr_upper_o), // Templated
      .pc_execute_i                     (pc_decode_to_execute),  // Templated
      .adder_do_sub_i                   (execute_adder_do_sub_o), // Templated
      .adder_do_carry_i                 (execute_adder_do_carry_o), // Templated
      .decode_rfa_i                     (decode_rfa_o),          // Templated
      .decode_rfb_i                     (decode_rfb_o),          // Templated
      .rfa_i                            (execute_rfa_o),         // Templated
      .rfb_i                            (execute_rfb_o),         // Templated
      .flag_i                           (ctrl_flag_o),           // Templated
      .carry_i                          (ctrl_carry_o));          // Templated


   /* mor1kx_lsu_cappuccino AUTO_TEMPLATE (
    .padv_execute_i			(padv_execute_o),
    .padv_ctrl_i			(padv_ctrl_o),
    .exec_lsu_adr_i			(adder_result_o),
    .ctrl_lsu_adr_i			(ctrl_lsu_adr_o),
    .ctrl_rfb_i				(ctrl_rfb_o),
    .exec_op_lsu_load_i			(execute_op_lsu_load_o),
    .exec_op_lsu_store_i		(execute_op_lsu_store_o),
    .exec_op_lsu_atomic_i		(execute_op_lsu_atomic_o),
    .ctrl_op_lsu_load_i			(ctrl_op_lsu_load_o),
    .ctrl_op_lsu_store_i		(ctrl_op_lsu_store_o),
    .ctrl_op_lsu_atomic_i		(ctrl_op_lsu_atomic_o),
    .ctrl_op_msync_i                    (ctrl_op_msync_o),
    .ctrl_lsu_length_i			(ctrl_lsu_length_o),
    .ctrl_lsu_zext_i			(ctrl_lsu_zext_o),
    .ctrl_epcr_i			(ctrl_epcr_o),
    .pipeline_flush_i			(pipeline_flush_o),
    .dc_enable_i			(spr_sr_o[`OR1K_SPR_SR_DCE]),
    .dmmu_enable_i			(spr_sr_o[`OR1K_SPR_SR_DME]),
    .supervisor_mode_i			(spr_sr_o[`OR1K_SPR_SR_SM]),
    .spr_bus_dat_dc_o			(spr_bus_dat_dc_i[OPTION_OPERAND_WIDTH-1:0]),
    .spr_bus_ack_dc_o			(spr_bus_ack_dc_i),
    .spr_bus_dat_dmmu_o			(spr_bus_dat_dmmu_i[OPTION_OPERAND_WIDTH-1:0]),
    .spr_bus_ack_dmmu_o			(spr_bus_ack_dmmu_i),
    .spr_bus_addr_i			(spr_bus_addr_o[15:0]),
    .spr_bus_we_i			(spr_bus_we_o),
    .spr_bus_stb_i			(spr_bus_stb_o),
    .spr_bus_dat_i			(spr_bus_dat_o[OPTION_OPERAND_WIDTH-1:0]),
    ); */
   mor1kx_lsu_cappuccino
     #(
       .FEATURE_DATACACHE(FEATURE_DATACACHE),
       .OPTION_OPERAND_WIDTH(OPTION_OPERAND_WIDTH),
       .OPTION_DCACHE_BLOCK_WIDTH(OPTION_DCACHE_BLOCK_WIDTH),
       .OPTION_DCACHE_SET_WIDTH(OPTION_DCACHE_SET_WIDTH),
       .OPTION_DCACHE_WAYS(OPTION_DCACHE_WAYS),
       .OPTION_DCACHE_LIMIT_WIDTH(OPTION_DCACHE_LIMIT_WIDTH),
       .OPTION_DCACHE_SNOOP(OPTION_DCACHE_SNOOP),
       .FEATURE_DMMU(FEATURE_DMMU),
       .FEATURE_DMMU_HW_TLB_RELOAD(FEATURE_DMMU_HW_TLB_RELOAD),
       .OPTION_DMMU_SET_WIDTH(OPTION_DMMU_SET_WIDTH),
       .OPTION_DMMU_WAYS(OPTION_DMMU_WAYS),
       .FEATURE_STORE_BUFFER(FEATURE_STORE_BUFFER),
       .OPTION_STORE_BUFFER_DEPTH_WIDTH(OPTION_STORE_BUFFER_DEPTH_WIDTH),
       .FEATURE_ATOMIC(FEATURE_ATOMIC)
       )
     mor1kx_lsu_cappuccino
     (/*AUTOINST*/
      // Outputs
      .store_buffer_epcr_o              (store_buffer_epcr_o[OPTION_OPERAND_WIDTH-1:0]),
      .lsu_result_o                     (lsu_result_o[OPTION_OPERAND_WIDTH-1:0]),
      .lsu_valid_o                      (lsu_valid_o),
      .lsu_except_dbus_o                (lsu_except_dbus_o),
      .lsu_except_align_o               (lsu_except_align_o),
      .lsu_except_dtlb_miss_o           (lsu_except_dtlb_miss_o),
      .lsu_except_dpagefault_o          (lsu_except_dpagefault_o),
      .store_buffer_err_o               (store_buffer_err_o),
      .atomic_flag_set_o                (atomic_flag_set_o),
      .atomic_flag_clear_o              (atomic_flag_clear_o),
      .msync_stall_o                    (msync_stall_o),
      .spr_bus_dat_dc_o                 (spr_bus_dat_dc_i[OPTION_OPERAND_WIDTH-1:0]), // Templated
      .spr_bus_ack_dc_o                 (spr_bus_ack_dc_i),      // Templated
      .spr_bus_dat_dmmu_o               (spr_bus_dat_dmmu_i[OPTION_OPERAND_WIDTH-1:0]), // Templated
      .spr_bus_ack_dmmu_o               (spr_bus_ack_dmmu_i),    // Templated
      .dbus_adr_o                       (dbus_adr_o[OPTION_OPERAND_WIDTH-1:0]),
      .dbus_req_o                       (dbus_req_o),
      .dbus_dat_o                       (dbus_dat_o[OPTION_OPERAND_WIDTH-1:0]),
      .dbus_bsel_o                      (dbus_bsel_o[3:0]),
      .dbus_we_o                        (dbus_we_o),
      .dbus_burst_o                     (dbus_burst_o),
      .dc_hit_o                         (dcache_hit_o),
      // Inputs
      .clk                              (clk),
      .rst                              (rst),
      .padv_execute_i                   (padv_execute_o),        // Templated
      .padv_ctrl_i                      (padv_ctrl_o),           // Templated
      .exec_lsu_adr_i                   (adder_result_o),        // Templated
      .ctrl_lsu_adr_i                   (ctrl_lsu_adr_o),        // Templated
      .ctrl_rfb_i                       (ctrl_rfb_o),            // Templated
      .exec_op_lsu_load_i               (execute_op_lsu_load_o), // Templated
      .exec_op_lsu_store_i              (execute_op_lsu_store_o), // Templated
      .exec_op_lsu_atomic_i             (execute_op_lsu_atomic_o), // Templated
      .ctrl_op_lsu_load_i               (ctrl_op_lsu_load_o),    // Templated
      .ctrl_op_lsu_store_i              (ctrl_op_lsu_store_o),   // Templated
      .ctrl_op_lsu_atomic_i             (ctrl_op_lsu_atomic_o),  // Templated
      .ctrl_op_msync_i                  (ctrl_op_msync_o),       // Templated
      .ctrl_lsu_length_i                (ctrl_lsu_length_o),     // Templated
      .ctrl_lsu_zext_i                  (ctrl_lsu_zext_o),       // Templated
      .ctrl_epcr_i                      (ctrl_epcr_o),           // Templated
      .spr_bus_addr_i                   (spr_bus_addr_o[15:0]),  // Templated
      .spr_bus_we_i                     (spr_bus_we_o),          // Templated
      .spr_bus_stb_i                    (spr_bus_stb_o),         // Templated
      .spr_bus_dat_i                    (spr_bus_dat_o[OPTION_OPERAND_WIDTH-1:0]), // Templated
      .dc_enable_i                      (spr_sr_o[`OR1K_SPR_SR_DCE]), // Templated
      .dmmu_enable_i                    (spr_sr_o[`OR1K_SPR_SR_DME]), // Templated
      .supervisor_mode_i                (spr_sr_o[`OR1K_SPR_SR_SM]), // Templated
      .dbus_err_i                       (dbus_err_i),
      .dbus_ack_i                       (dbus_ack_i),
      .dbus_dat_i                       (dbus_dat_i[OPTION_OPERAND_WIDTH-1:0]),
      .pipeline_flush_i                 (pipeline_flush_o),      // Templated
      .snoop_adr_i                      (snoop_adr_i[31:0]),
      .snoop_en_i                       (snoop_en_i));


   /* mor1kx_wb_mux_cappuccino AUTO_TEMPLATE (
    .alu_result_i			(ctrl_alu_result_o),
    .lsu_result_i			(lsu_result_o),
    .mul_result_i			(mul_result_o),
    .spr_i				(mfspr_dat_o),
    .op_mul_i				(ctrl_op_mul_o),
    .op_lsu_load_i			(ctrl_op_lsu_load_o),
    .pc_i				(pc_execute_to_ctrl),
    .op_mfspr_i			        (ctrl_op_mfspr_o),
    ); */
   mor1kx_wb_mux_cappuccino
     #(
       .OPTION_OPERAND_WIDTH(OPTION_OPERAND_WIDTH)
       )
     mor1kx_wb_mux_cappuccino
     (/*AUTOINST*/
      // Outputs
      .rf_result_o                      (rf_result_o[OPTION_OPERAND_WIDTH-1:0]),
      // Inputs
      .clk                              (clk),
      .rst                              (rst),
      .alu_result_i                     (ctrl_alu_result_o),     // Templated
      .lsu_result_i                     (lsu_result_o),          // Templated
      .mul_result_i                     (mul_result_o),          // Templated
      .spr_i                            (mfspr_dat_o),           // Templated
      .op_mul_i                         (ctrl_op_mul_o),         // Templated
      .op_lsu_load_i                    (ctrl_op_lsu_load_o),    // Templated
      .op_mfspr_i                       (ctrl_op_mfspr_o));       // Templated


   /* mor1kx_rf_cappuccino AUTO_TEMPLATE (
    .padv_decode_i			(padv_decode_o),
    .padv_ctrl_i			(padv_ctrl_o),
    .fetch_rf_adr_valid_i		(fetch_rf_adr_valid_o),
    .fetch_rfa_adr_i			(fetch_rfa_adr_o),
    .fetch_rfb_adr_i			(fetch_rfb_adr_o),
    .decode_valid_i			(decode_valid_o),
    .decode_rfa_adr_i  			(decode_rfa_adr_o),
    .decode_rfb_adr_i  			(decode_rfb_adr_o),
    .execute_rfd_adr_i			(execute_rfd_adr_o),
    .ctrl_rfd_adr_i			(ctrl_rfd_adr_o),
    .wb_rfd_adr_i  			(wb_rfd_adr_o),
    .spr_bus_addr_i			(spr_bus_addr_o[15:0]),
    .spr_bus_stb_i			(spr_bus_stb_o),
    .spr_bus_we_i			(spr_bus_we_o),
    .spr_bus_dat_i			(spr_bus_dat_o),
    .execute_rf_wb_i			(execute_rf_wb_o),
    .ctrl_rf_wb_i			(ctrl_rf_wb_o),
    .wb_rf_wb_i				(wb_rf_wb_o),
    .result_i				(rf_result_o),
    .ctrl_alu_result_i			(ctrl_alu_result_o),
    .pipeline_flush_i			(pipeline_flush_o),
    ); */
   mor1kx_rf_cappuccino
     #(
       .OPTION_OPERAND_WIDTH(OPTION_OPERAND_WIDTH),
       .FEATURE_FASTCONTEXTS(FEATURE_FASTCONTEXTS),
       .OPTION_RF_CLEAR_ON_INIT(OPTION_RF_CLEAR_ON_INIT),
       .OPTION_RF_NUM_SHADOW_GPR(OPTION_RF_NUM_SHADOW_GPR),
       .OPTION_RF_ADDR_WIDTH(OPTION_RF_ADDR_WIDTH),
       .OPTION_RF_WORDS(OPTION_RF_WORDS),
       .FEATURE_DEBUGUNIT(FEATURE_DEBUGUNIT)
       )
     mor1kx_rf_cappuccino
     (/*AUTOINST*/
      // Outputs
      .spr_gpr_ack_o                    (spr_gpr_ack_o),
      .spr_gpr_dat_o                    (spr_gpr_dat_o[OPTION_OPERAND_WIDTH-1:0]),
      .decode_rfa_o                     (decode_rfa_o[OPTION_OPERAND_WIDTH-1:0]),
      .decode_rfb_o                     (decode_rfb_o[OPTION_OPERAND_WIDTH-1:0]),
      .execute_rfa_o                    (execute_rfa_o[OPTION_OPERAND_WIDTH-1:0]),
      .execute_rfb_o                    (execute_rfb_o[OPTION_OPERAND_WIDTH-1:0]),
      // Inputs
      .clk                              (clk),
      .rst                              (rst),
      .padv_decode_i                    (padv_decode_o),         // Templated
      .padv_ctrl_i                      (padv_ctrl_o),           // Templated
      .decode_valid_i                   (decode_valid_o),        // Templated
      .fetch_rf_adr_valid_i             (fetch_rf_adr_valid_o),  // Templated
      .fetch_rfa_adr_i                  (fetch_rfa_adr_o),       // Templated
      .fetch_rfb_adr_i                  (fetch_rfb_adr_o),       // Templated
      .decode_rfa_adr_i                 (decode_rfa_adr_o),      // Templated
      .decode_rfb_adr_i                 (decode_rfb_adr_o),      // Templated
      .execute_rfd_adr_i                (execute_rfd_adr_o),     // Templated
      .ctrl_rfd_adr_i                   (ctrl_rfd_adr_o),        // Templated
      .wb_rfd_adr_i                     (wb_rfd_adr_o),          // Templated
      .spr_bus_addr_i                   (spr_bus_addr_o[15:0]),  // Templated
      .spr_bus_stb_i                    (spr_bus_stb_o),         // Templated
      .spr_bus_we_i                     (spr_bus_we_o),          // Templated
      .spr_bus_dat_i                    (spr_bus_dat_o),         // Templated
      .execute_rf_wb_i                  (execute_rf_wb_o),       // Templated
      .ctrl_rf_wb_i                     (ctrl_rf_wb_o),          // Templated
      .wb_rf_wb_i                       (wb_rf_wb_o),            // Templated
      .result_i                         (rf_result_o),           // Templated
      .ctrl_alu_result_i                (ctrl_alu_result_o),     // Templated
      .pipeline_flush_i                 (pipeline_flush_o));      // Templated


`ifndef SYNTHESIS
// synthesis translate_off
   /* Debug signals required for the debug monitor */

`include "mor1kx_utils.vh"
   localparam RF_ADDR_WIDTH = calc_rf_addr_width(OPTION_RF_ADDR_WIDTH,
                                                 OPTION_RF_NUM_SHADOW_GPR);

   function [OPTION_OPERAND_WIDTH-1:0] get_gpr;
      // verilator public
      input [RF_ADDR_WIDTH-1:0] gpr_num;
      begin
	 // TODO: handle load ops
	 if ((mor1kx_rf_cappuccino.execute_rfd_adr_i == gpr_num[4:0]) &
	     mor1kx_rf_cappuccino.execute_rf_wb_i)
	   get_gpr = alu_result_o;
	 else if ((mor1kx_rf_cappuccino.ctrl_rfd_adr_i == gpr_num[4:0]) &
		  mor1kx_rf_cappuccino.ctrl_rf_wb_i)
	   get_gpr = ctrl_alu_result_o;
	 else if ((mor1kx_rf_cappuccino.wb_rfd_adr_i == gpr_num[4:0]) &
		  mor1kx_rf_cappuccino.wb_rf_wb_i)
	   get_gpr = mor1kx_rf_cappuccino.result_i;
	 else
	   get_gpr = mor1kx_rf_cappuccino.rfa.mem[gpr_num];
      end
   endfunction //


   task set_gpr;
      // verilator public
      input [RF_ADDR_WIDTH-1:0] gpr_num;
      input [OPTION_OPERAND_WIDTH-1:0] gpr_value;
      begin
	 mor1kx_rf_cappuccino.rfa.mem[gpr_num] = gpr_value;
	 mor1kx_rf_cappuccino.rfb.mem[gpr_num] = gpr_value;
      end
   endtask
// synthesis translate_on
`endif


   /* mor1kx_execute_ctrl_cappuccino AUTO_TEMPLATE (
    .padv_i				(padv_execute_o),
    .padv_ctrl_i			(padv_ctrl_o),
    .execute_except_ibus_err_i		(execute_except_ibus_err_o),
    .execute_except_itlb_miss_i		(execute_except_itlb_miss_o),
    .execute_except_ipagefault_i	(execute_except_ipagefault_o),
    .execute_except_illegal_i		(execute_except_illegal_o),
    .execute_except_ibus_align_i	(execute_except_ibus_align_o),
    .execute_except_syscall_i		(execute_except_syscall_o),
    .execute_except_trap_i		(execute_except_trap_o),
    .lsu_except_dbus_i  		(lsu_except_dbus_o),
    .lsu_except_align_i			(lsu_except_align_o),
    .lsu_except_dtlb_miss_i		(lsu_except_dtlb_miss_o),
    .lsu_except_dpagefault_i		(lsu_except_dpagefault_o),
    .op_mul_i				(execute_op_mul_o),
    .op_lsu_load_i			(execute_op_lsu_load_o),
    .op_lsu_store_i			(execute_op_lsu_store_o),
    .op_lsu_atomic_i			(execute_op_lsu_atomic_o),
    .lsu_length_i			(execute_lsu_length_o),
    .lsu_zext_i				(execute_lsu_zext_o),
    .op_msync_i                         (execute_op_msync_o),
    .op_mfspr_i				(execute_op_mfspr_o),
    .op_mtspr_i				(execute_op_mtspr_o),
    .alu_valid_i			(alu_valid_o),
    .lsu_valid_i			(lsu_valid_o),
    .msync_stall_i                      (msync_stall_o),
    .alu_result_i			(alu_result_o),
    .adder_result_i			(adder_result_o),
    .execute_jal_result_i		(execute_jal_result_o),
    .op_jr_i				(execute_op_jr_o),
    .op_jal_i				(execute_op_jal_o),
    .op_rfe_i				(execute_op_rfe_o),
    .rfb_i				(execute_rfb_o),
    .flag_set_i 			(flag_set_o),
    .flag_clear_i			(flag_clear_o),
    .pc_execute_i			(pc_decode_to_execute),
    .execute_rf_wb_i			(execute_rf_wb_o),
    .execute_rfd_adr_i			(execute_rfd_adr_o),
    .ctrl_mfspr_ack_i			(ctrl_mfspr_ack_o),
    .ctrl_mtspr_ack_i			(ctrl_mtspr_ack_o),
    .pipeline_flush_i			(pipeline_flush_o),
    .pc_ctrl_o				(pc_execute_to_ctrl),
    .execute_bubble_i			(execute_bubble_o),
    .carry_set_i		        (carry_set_o),
    .carry_clear_i		        (carry_clear_o),
    .overflow_set_i		        (overflow_set_o),
    .overflow_clear_i		        (overflow_clear_o),
    .fpcsr_i                            (fpcsr_o),
    .fpcsr_set_i                        (fpcsr_set_o),
    ); */
   mor1kx_execute_ctrl_cappuccino
     #(
       .OPTION_OPERAND_WIDTH(OPTION_OPERAND_WIDTH),
       .OPTION_RESET_PC(OPTION_RESET_PC),
       .FEATURE_FPU(FEATURE_FPU), // pipeline cappuccino: execute_ctrl instance
       .FEATURE_MULTIPLIER(FEATURE_MULTIPLIER)
       )
     mor1kx_execute_ctrl_cappuccino
     (/*AUTOINST*/
      // Outputs
      .ctrl_rf_wb_o                     (ctrl_rf_wb_o),
      .wb_rf_wb_o                       (wb_rf_wb_o),
      .ctrl_rfd_adr_o                   (ctrl_rfd_adr_o[OPTION_RF_ADDR_WIDTH-1:0]),
      .wb_rfd_adr_o                     (wb_rfd_adr_o[OPTION_RF_ADDR_WIDTH-1:0]),
      .ctrl_alu_result_o                (ctrl_alu_result_o[OPTION_OPERAND_WIDTH-1:0]),
      .ctrl_lsu_adr_o                   (ctrl_lsu_adr_o[OPTION_OPERAND_WIDTH-1:0]),
      .ctrl_rfb_o                       (ctrl_rfb_o[OPTION_OPERAND_WIDTH-1:0]),
      .ctrl_flag_set_o                  (ctrl_flag_set_o),
      .ctrl_flag_clear_o                (ctrl_flag_clear_o),
      .ctrl_carry_set_o                 (ctrl_carry_set_o),
      .ctrl_carry_clear_o               (ctrl_carry_clear_o),
      .ctrl_overflow_set_o              (ctrl_overflow_set_o),
      .ctrl_overflow_clear_o            (ctrl_overflow_clear_o),
      .ctrl_fpcsr_o                     (ctrl_fpcsr_o),
      .ctrl_fpcsr_set_o                 (ctrl_fpcsr_set_o),
      .pc_ctrl_o                        (pc_execute_to_ctrl),    // Templated
      .ctrl_op_mul_o                    (ctrl_op_mul_o),
      .ctrl_op_lsu_load_o               (ctrl_op_lsu_load_o),
      .ctrl_op_lsu_store_o              (ctrl_op_lsu_store_o),
      .ctrl_op_lsu_atomic_o             (ctrl_op_lsu_atomic_o),
      .ctrl_lsu_length_o                (ctrl_lsu_length_o[1:0]),
      .ctrl_lsu_zext_o                  (ctrl_lsu_zext_o),
      .ctrl_op_msync_o                  (ctrl_op_msync_o),
      .ctrl_op_mfspr_o                  (ctrl_op_mfspr_o),
      .ctrl_op_mtspr_o                  (ctrl_op_mtspr_o),
      .ctrl_op_rfe_o                    (ctrl_op_rfe_o),
      .ctrl_except_ibus_err_o           (ctrl_except_ibus_err_o),
      .ctrl_except_itlb_miss_o          (ctrl_except_itlb_miss_o),
      .ctrl_except_ipagefault_o         (ctrl_except_ipagefault_o),
      .ctrl_except_ibus_align_o         (ctrl_except_ibus_align_o),
      .ctrl_except_illegal_o            (ctrl_except_illegal_o),
      .ctrl_except_syscall_o            (ctrl_except_syscall_o),
      .ctrl_except_dbus_o               (ctrl_except_dbus_o),
      .ctrl_except_dtlb_miss_o          (ctrl_except_dtlb_miss_o),
      .ctrl_except_dpagefault_o         (ctrl_except_dpagefault_o),
      .ctrl_except_align_o              (ctrl_except_align_o),
      .ctrl_except_trap_o               (ctrl_except_trap_o),
      .execute_valid_o                  (execute_valid_o),
      .ctrl_valid_o                     (ctrl_valid_o),
      // Inputs
      .clk                              (clk),
      .rst                              (rst),
      .padv_i                           (padv_execute_o),        // Templated
      .padv_ctrl_i                      (padv_ctrl_o),           // Templated
      .execute_except_ibus_err_i        (execute_except_ibus_err_o), // Templated
      .execute_except_itlb_miss_i       (execute_except_itlb_miss_o), // Templated
      .execute_except_ipagefault_i      (execute_except_ipagefault_o), // Templated
      .execute_except_illegal_i         (execute_except_illegal_o), // Templated
      .execute_except_ibus_align_i      (execute_except_ibus_align_o), // Templated
      .execute_except_syscall_i         (execute_except_syscall_o), // Templated
      .lsu_except_dbus_i                (lsu_except_dbus_o),     // Templated
      .lsu_except_align_i               (lsu_except_align_o),    // Templated
      .lsu_except_dtlb_miss_i           (lsu_except_dtlb_miss_o), // Templated
      .lsu_except_dpagefault_i          (lsu_except_dpagefault_o), // Templated
      .execute_except_trap_i            (execute_except_trap_o), // Templated
      .pipeline_flush_i                 (pipeline_flush_o),      // Templated
      .op_mul_i                         (execute_op_mul_o),      // Templated
      .op_lsu_load_i                    (execute_op_lsu_load_o), // Templated
      .op_lsu_store_i                   (execute_op_lsu_store_o), // Templated
      .op_lsu_atomic_i                  (execute_op_lsu_atomic_o), // Templated
      .lsu_length_i                     (execute_lsu_length_o),  // Templated
      .lsu_zext_i                       (execute_lsu_zext_o),    // Templated
      .op_msync_i                       (execute_op_msync_o),    // Templated
      .op_mfspr_i                       (execute_op_mfspr_o),    // Templated
      .op_mtspr_i                       (execute_op_mtspr_o),    // Templated
      .alu_valid_i                      (alu_valid_o),           // Templated
      .lsu_valid_i                      (lsu_valid_o),           // Templated
      .msync_stall_i                    (msync_stall_o),         // Templated
      .op_jr_i                          (execute_op_jr_o),       // Templated
      .op_jal_i                         (execute_op_jal_o),      // Templated
      .op_rfe_i                         (execute_op_rfe_o),      // Templated
      .alu_result_i                     (alu_result_o),          // Templated
      .adder_result_i                   (adder_result_o),        // Templated
      .rfb_i                            (execute_rfb_o),         // Templated
      .execute_jal_result_i             (execute_jal_result_o),  // Templated
      .flag_set_i                       (flag_set_o),            // Templated
      .flag_clear_i                     (flag_clear_o),          // Templated
      .carry_set_i                      (carry_set_o),           // Templated
      .carry_clear_i                    (carry_clear_o),         // Templated
      .overflow_set_i                   (overflow_set_o),        // Templated
      .overflow_clear_i                 (overflow_clear_o),      // Templated
      .fpcsr_i                          (fpcsr_o),
      .fpcsr_set_i                      (fpcsr_set_o),
      .pc_execute_i                     (pc_decode_to_execute),  // Templated
      .execute_rf_wb_i                  (execute_rf_wb_o),       // Templated
      .execute_rfd_adr_i                (execute_rfd_adr_o),     // Templated
      .execute_bubble_i                 (execute_bubble_o),      // Templated
      .ctrl_mfspr_ack_i                 (ctrl_mfspr_ack_o),      // Templated
      .ctrl_mtspr_ack_i                 (ctrl_mtspr_ack_o));      // Templated

   /* mor1kx_ctrl_cappuccino AUTO_TEMPLATE (
    .ctrl_alu_result_i		(ctrl_alu_result_o),
    .ctrl_lsu_adr_i		(ctrl_lsu_adr_o),
    .ctrl_rfb_i			(ctrl_rfb_o),
    .ctrl_flag_set_i		(ctrl_flag_set_o),
    .ctrl_flag_clear_i		(ctrl_flag_clear_o),
    .atomic_flag_set_i		(atomic_flag_set_o),
    .atomic_flag_clear_i	(atomic_flag_clear_o),
    .pc_ctrl_i			(pc_execute_to_ctrl),
    .pc_execute_i		(pc_decode_to_execute),
    .execute_op_branch_i	(execute_op_branch_o),
    .ctrl_op_mfspr_i		(ctrl_op_mfspr_o),
    .ctrl_op_mtspr_i		(ctrl_op_mtspr_o),
    .ctrl_op_rfe_i		(ctrl_op_rfe_o),
    .decode_branch_i		(decode_branch_o),
    .decode_branch_target_i	(decode_branch_target_o),
    .branch_mispredict_i	(branch_mispredict_o),
    .execute_mispredict_target_i	(execute_mispredict_target_o),
    .except_ibus_err_i		(ctrl_except_ibus_err_o),
    .except_itlb_miss_i		(ctrl_except_itlb_miss_o),
    .except_ipagefault_i	(ctrl_except_ipagefault_o),
    .except_ibus_align_i	(ctrl_except_ibus_align_o),
    .except_illegal_i		(ctrl_except_illegal_o),
    .except_syscall_i		(ctrl_except_syscall_o),
    .except_dbus_i		(ctrl_except_dbus_o),
    .except_dtlb_miss_i		(ctrl_except_dtlb_miss_o),
    .except_dpagefault_i	(ctrl_except_dpagefault_o),
    .except_trap_i		(ctrl_except_trap_o),
    .except_align_i		(ctrl_except_align_o),
    .fetch_valid_i		(fetch_valid_o),
    .decode_valid_i		(decode_valid_o),
    .execute_valid_i		(execute_valid_o),
    .ctrl_valid_i		(ctrl_valid_o),
    .fetch_exception_taken_i	(fetch_exception_taken_o),
    .decode_bubble_i		(decode_bubble_o),
    .execute_bubble_i		(execute_bubble_o),
    .store_buffer_epcr_i	(store_buffer_epcr_o),
    .store_buffer_err_i		(store_buffer_err_o),
    .ctrl_carry_set_i		(ctrl_carry_set_o),
    .ctrl_carry_clear_i		(ctrl_carry_clear_o),
    .ctrl_overflow_set_i       (ctrl_overflow_set_o),
    .ctrl_overflow_clear_i	(ctrl_overflow_clear_o),
    .ctrl_fpcsr_i       (ctrl_fpcsr_o),
    .ctrl_fpcsr_set_i   (ctrl_fpcsr_set_o),      
    .spr_gpr_ack_i		(spr_gpr_ack_o),
    .spr_gpr_dat_i		(spr_gpr_dat_o),
    ) */
   mor1kx_ctrl_cappuccino
     #(
       .OPTION_OPERAND_WIDTH(OPTION_OPERAND_WIDTH),
       .OPTION_RESET_PC(OPTION_RESET_PC),
       .FEATURE_PIC(FEATURE_PIC),
       .FEATURE_TIMER(FEATURE_TIMER),
       .OPTION_PIC_TRIGGER(OPTION_PIC_TRIGGER),
       .OPTION_PIC_NMI_WIDTH(OPTION_PIC_NMI_WIDTH),
       .FEATURE_DATACACHE(FEATURE_DATACACHE),
       .OPTION_DCACHE_BLOCK_WIDTH(OPTION_DCACHE_BLOCK_WIDTH),
       .OPTION_DCACHE_SET_WIDTH(OPTION_DCACHE_SET_WIDTH),
       .OPTION_DCACHE_WAYS(OPTION_DCACHE_WAYS),
       .FEATURE_DMMU(FEATURE_DMMU),
       .OPTION_DMMU_SET_WIDTH(OPTION_DMMU_SET_WIDTH),
       .OPTION_DMMU_WAYS(OPTION_DMMU_WAYS),
       .FEATURE_INSTRUCTIONCACHE(FEATURE_INSTRUCTIONCACHE),
       .OPTION_ICACHE_BLOCK_WIDTH(OPTION_ICACHE_BLOCK_WIDTH),
       .OPTION_ICACHE_SET_WIDTH(OPTION_ICACHE_SET_WIDTH),
       .OPTION_ICACHE_WAYS(OPTION_ICACHE_WAYS),
       .FEATURE_IMMU(FEATURE_IMMU),
       .OPTION_IMMU_SET_WIDTH(OPTION_IMMU_SET_WIDTH),
       .OPTION_IMMU_WAYS(OPTION_IMMU_WAYS),
       .FEATURE_DEBUGUNIT(FEATURE_DEBUGUNIT),
       .FEATURE_PERFCOUNTERS(FEATURE_PERFCOUNTERS),
       .OPTION_PERFCOUNTERS_NUM(OPTION_PERFCOUNTERS_NUM),
       .FEATURE_MAC(FEATURE_MAC),
       .FEATURE_FPU(FEATURE_FPU), // pipeline cappuccino: ctrl instance
       .FEATURE_MULTICORE(FEATURE_MULTICORE),
       .FEATURE_SYSCALL(FEATURE_SYSCALL),
       .FEATURE_TRAP(FEATURE_TRAP),
       .FEATURE_RANGE(FEATURE_RANGE),
       .FEATURE_DSX(FEATURE_DSX),
       .FEATURE_FASTCONTEXTS(FEATURE_FASTCONTEXTS),
       .OPTION_RF_NUM_SHADOW_GPR(OPTION_RF_NUM_SHADOW_GPR),
       .FEATURE_OVERFLOW(FEATURE_OVERFLOW),
       .FEATURE_CARRY_FLAG(FEATURE_CARRY_FLAG)
       )
     mor1kx_ctrl_cappuccino
     (/*AUTOINST*/
      // Outputs
      .ctrl_epcr_o                      (ctrl_epcr_o[OPTION_OPERAND_WIDTH-1:0]),
      .mfspr_dat_o                      (mfspr_dat_o[OPTION_OPERAND_WIDTH-1:0]),
      .ctrl_mfspr_ack_o                 (ctrl_mfspr_ack_o),
      .ctrl_mtspr_ack_o                 (ctrl_mtspr_ack_o),
      .ctrl_flag_o                      (ctrl_flag_o),
      .ctrl_carry_o                     (ctrl_carry_o),
      .ctrl_fpu_round_mode_o            (ctrl_fpu_round_mode_o),
      .ctrl_branch_exception_o          (ctrl_branch_exception_o),
      .ctrl_branch_except_pc_o          (ctrl_branch_except_pc_o[OPTION_OPERAND_WIDTH-1:0]),
      .pipeline_flush_o                 (pipeline_flush_o),
      .doing_rfe_o                      (doing_rfe_o),
      .padv_fetch_o                     (padv_fetch_o),
      .padv_decode_o                    (padv_decode_o),
      .padv_execute_o                   (padv_execute_o),
      .padv_ctrl_o                      (padv_ctrl_o),
      .du_dat_o                         (du_dat_o[OPTION_OPERAND_WIDTH-1:0]),
      .du_ack_o                         (du_ack_o),
      .du_stall_o                       (du_stall_o),
      .du_restart_pc_o                  (du_restart_pc_o[OPTION_OPERAND_WIDTH-1:0]),
      .du_restart_o                     (du_restart_o),
      .spr_bus_addr_o                   (spr_bus_addr_o[15:0]),
      .spr_bus_we_o                     (spr_bus_we_o),
      .spr_bus_stb_o                    (spr_bus_stb_o),
      .spr_bus_dat_o                    (spr_bus_dat_o[OPTION_OPERAND_WIDTH-1:0]),
      .spr_sr_o                         (spr_sr_o[15:0]),
      .ctrl_bubble_o                    (ctrl_bubble_o),
      // Inputs
      .clk                              (clk),
      .rst                              (rst),
      .ctrl_alu_result_i                (ctrl_alu_result_o),     // Templated
      .ctrl_lsu_adr_i                   (ctrl_lsu_adr_o),        // Templated
      .ctrl_rfb_i                       (ctrl_rfb_o),            // Templated
      .ctrl_flag_set_i                  (ctrl_flag_set_o),       // Templated
      .ctrl_flag_clear_i                (ctrl_flag_clear_o),     // Templated
      .atomic_flag_set_i                (atomic_flag_set_o),     // Templated
      .atomic_flag_clear_i              (atomic_flag_clear_o),   // Templated
      .pc_ctrl_i                        (pc_execute_to_ctrl),    // Templated
      .ctrl_op_mfspr_i                  (ctrl_op_mfspr_o),       // Templated
      .ctrl_op_mtspr_i                  (ctrl_op_mtspr_o),       // Templated
      .ctrl_op_rfe_i                    (ctrl_op_rfe_o),         // Templated
      .decode_branch_i                  (decode_branch_o),       // Templated
      .decode_branch_target_i           (decode_branch_target_o), // Templated
      .branch_mispredict_i              (branch_mispredict_o),   // Templated
      .execute_mispredict_target_i      (execute_mispredict_target_o), // Templated
      .pc_execute_i                     (pc_decode_to_execute),  // Templated
      .execute_op_branch_i              (execute_op_branch_o),   // Templated
      .except_ibus_err_i                (ctrl_except_ibus_err_o), // Templated
      .except_itlb_miss_i               (ctrl_except_itlb_miss_o), // Templated
      .except_ipagefault_i              (ctrl_except_ipagefault_o), // Templated
      .except_ibus_align_i              (ctrl_except_ibus_align_o), // Templated
      .except_illegal_i                 (ctrl_except_illegal_o), // Templated
      .except_syscall_i                 (ctrl_except_syscall_o), // Templated
      .except_dbus_i                    (ctrl_except_dbus_o),    // Templated
      .except_dtlb_miss_i               (ctrl_except_dtlb_miss_o), // Templated
      .except_dpagefault_i              (ctrl_except_dpagefault_o), // Templated
      .except_trap_i                    (ctrl_except_trap_o),    // Templated
      .except_align_i                   (ctrl_except_align_o),   // Templated
      .fetch_valid_i                    (fetch_valid_o),         // Templated
      .decode_valid_i                   (decode_valid_o),        // Templated
      .execute_valid_i                  (execute_valid_o),       // Templated
      .execute_op_lsu_load_i            (execute_op_lsu_load_o),
      .execute_op_lsu_store_i           (execute_op_lsu_store_o),
      .ctrl_valid_i                     (ctrl_valid_o),          // Templated
      .fetch_exception_taken_i          (fetch_exception_taken_o), // Templated
      .decode_bubble_i                  (decode_bubble_o),       // Templated
      .execute_bubble_i                 (execute_bubble_o),      // Templated
      .irq_i                            (irq_i[31:0]),
      .store_buffer_epcr_i              (store_buffer_epcr_o),   // Templated
      .store_buffer_err_i               (store_buffer_err_o),    // Templated
      .ctrl_carry_set_i                 (ctrl_carry_set_o),      // Templated
      .ctrl_carry_clear_i               (ctrl_carry_clear_o),    // Templated
      .ctrl_overflow_set_i              (ctrl_overflow_set_o),   // Templated
      .ctrl_overflow_clear_i            (ctrl_overflow_clear_o), // Templated
      .ctrl_fpcsr_i                     (ctrl_fpcsr_o),
      .ctrl_fpcsr_set_i                 (ctrl_fpcsr_set_o),
      .icache_hit_i                     (icache_hit_o),
      .dcache_hit_i                     (dcache_hit_o),
      .du_addr_i                        (du_addr_i[15:0]),
      .du_stb_i                         (du_stb_i),
      .du_dat_i                         (du_dat_i[OPTION_OPERAND_WIDTH-1:0]),
      .du_we_i                          (du_we_i),
      .du_stall_i                       (du_stall_i),
      .spr_bus_dat_dc_i                 (spr_bus_dat_dc_i[OPTION_OPERAND_WIDTH-1:0]),
      .spr_bus_ack_dc_i                 (spr_bus_ack_dc_i),
      .spr_bus_dat_ic_i                 (spr_bus_dat_ic_i[OPTION_OPERAND_WIDTH-1:0]),
      .spr_bus_ack_ic_i                 (spr_bus_ack_ic_i),
      .spr_bus_dat_dmmu_i               (spr_bus_dat_dmmu_i[OPTION_OPERAND_WIDTH-1:0]),
      .spr_bus_ack_dmmu_i               (spr_bus_ack_dmmu_i),
      .spr_bus_dat_immu_i               (spr_bus_dat_immu_i[OPTION_OPERAND_WIDTH-1:0]),
      .spr_bus_ack_immu_i               (spr_bus_ack_immu_i),
      .spr_bus_dat_mac_i                (spr_bus_dat_mac_i[OPTION_OPERAND_WIDTH-1:0]),
      .spr_bus_ack_mac_i                (spr_bus_ack_mac_i),
      .spr_bus_dat_pmu_i                (spr_bus_dat_pmu_i[OPTION_OPERAND_WIDTH-1:0]),
      .spr_bus_ack_pmu_i                (spr_bus_ack_pmu_i),
      .spr_bus_dat_pcu_i                (spr_bus_dat_pcu_i[OPTION_OPERAND_WIDTH-1:0]),
      .spr_bus_ack_pcu_i                (spr_bus_ack_pcu_i),
      .spr_bus_dat_fpu_i                (spr_bus_dat_fpu_i[OPTION_OPERAND_WIDTH-1:0]),
      .spr_bus_ack_fpu_i                (spr_bus_ack_fpu_i),
      .spr_gpr_dat_i                    (spr_gpr_dat_o),         // Templated
      .spr_gpr_ack_i                    (spr_gpr_ack_o),         // Templated
      .multicore_coreid_i               (multicore_coreid_i[OPTION_OPERAND_WIDTH-1:0]),
      .multicore_numcores_i             (multicore_numcores_i[OPTION_OPERAND_WIDTH-1:0]));

   reg [`OR1K_INSN_WIDTH-1:0] traceport_stage_decode_insn;
   reg [`OR1K_INSN_WIDTH-1:0] traceport_stage_exec_insn;

   reg                            traceport_jal_execute_to_ctrl;
   reg                            traceport_jr_execute_to_ctrl;
   reg [31:0]                     traceport_jbtarget_decode_to_execute;
   reg [31:0]                     traceport_jbtarget_execute_to_ctrl;

   reg                        traceport_waitexec;

   always @(posedge clk) begin
      if (FEATURE_TRACEPORT_EXEC != "NONE") begin
         if (rst) begin
            traceport_waitexec <= 0;
         end else begin
            if (padv_decode_o) begin
               traceport_stage_decode_insn <= insn_fetch_to_decode;
               traceport_jbtarget_decode_to_execute <= decode_branch_target_o;
            end

            if (padv_execute_o) begin
               traceport_stage_exec_insn <= traceport_stage_decode_insn;
               traceport_jbtarget_execute_to_ctrl <= traceport_jbtarget_decode_to_execute;
               traceport_jal_execute_to_ctrl <= execute_op_jal_o;
               traceport_jr_execute_to_ctrl <= execute_op_jr_o & !execute_op_jal_o;
            end

            if (padv_ctrl_o) begin
               traceport_exec_jal_o <= traceport_jal_execute_to_ctrl;
               traceport_exec_jr_o <= traceport_jr_execute_to_ctrl;
               traceport_exec_insn_o <= traceport_stage_exec_insn;
               traceport_exec_jbtarget_o <= traceport_jbtarget_execute_to_ctrl;
            end

            traceport_exec_pc_o <= pc_execute_to_ctrl;

            if (!traceport_waitexec) begin
               if (padv_ctrl_o & !ctrl_bubble_o) begin
                  if (execute_valid_o) begin
                     traceport_exec_valid_o <= 1'b1;
                  end else begin
                     traceport_exec_valid_o <= 1'b0;
                     traceport_waitexec <= 1'b1;
                  end
               end else if (ctrl_op_rfe_o) begin
                  traceport_exec_valid_o <= 1'b1;
               end else begin
                  traceport_exec_valid_o <= 1'b0;
               end
            end else begin
               if (execute_valid_o) begin
                  traceport_exec_valid_o <= 1'b1;
                  traceport_waitexec <= 1'b0;
               end else begin
                  traceport_exec_valid_o <= 1'b0;
               end
            end // else: !if(!traceport_waitexec)
         end // else: !if(rst)
      end else begin // if (FEATURE_TRACEPORT_EXEC != "NONE")
         traceport_stage_decode_insn <= {`OR1K_INSN_WIDTH{1'b0}};
         traceport_stage_exec_insn <= {`OR1K_INSN_WIDTH{1'b0}};
         traceport_exec_insn_o <= {`OR1K_INSN_WIDTH{1'b0}};
         traceport_exec_pc_o <= 32'h0;
         traceport_exec_valid_o <= 1'b0;
         traceport_exec_jbtarget_o <= 32'h0;
         traceport_exec_jal_o <= 1'b0;
         traceport_exec_jr_o <= 1'b0;
         traceport_exec_jb_o <= 1'b0;
      end
   end

   generate
      if (FEATURE_TRACEPORT_EXEC != "NONE") begin
         assign traceport_exec_wbreg_o = wb_rfd_adr_o;
         assign traceport_exec_wben_o = wb_rf_wb_o;
         assign traceport_exec_wbdata_o = rf_result_o;
      end else begin
         assign traceport_exec_wbreg_o = {OPTION_RF_ADDR_WIDTH{1'b0}};
         assign traceport_exec_wben_o = 1'b0;
         assign traceport_exec_wbdata_o = {OPTION_OPERAND_WIDTH{1'b0}};
      end
   endgenerate


/*-----------------Formal Checking-------------------*/

`ifdef FORMAL

   reg f_past_valid = 0;
   initial f_past_valid = 1'b0;
   initial assume (rst);

   always @(posedge clk)
      f_past_valid <= 1'b1;

   always @(*)
      if (!f_past_valid)
         assume (rst);

   //Reset Assertions
   always @(posedge clk) begin
      if (f_past_valid && $past(rst) && !rst) begin
         assert (!fetch_valid_o);
         assert (!ibus_req_o);
         assert (!spr_bus_stb_o);
         assert (!ibus_burst_o);
         assert (!spr_bus_ack_ic_i);
         assert (!spr_bus_ack_immu_i);
         assert (!decode_valid_o);
         assert (!decode_bubble_o);
         assert (!execute_bubble_o);
         assert (!padv_decode_o);
         assert (!padv_execute_o);
         assert (!padv_ctrl_o);
         assert (!predicted_flag_o);
         assert (!spr_bus_ack_dc_i);
         assert (!spr_bus_ack_dmmu_i);
         assert (!ctrl_bubble_o);
         assert (!wb_rf_wb_o);
      end
   end

   always @(posedge clk) begin
      if (f_past_valid && padv_decode_o && !$past(rst))
         assert (fetch_valid_o);
   end

   //SPR Property checking
   always @(posedge clk)
      if (f_past_valid && !$past(rst) &&
          ($rose(spr_bus_ack_dmmu_i) || $rose(spr_bus_ack_immu_i) ||
           $rose(spr_bus_ack_dc_i) || $rose(spr_bus_ack_ic_i)))
         assert (spr_bus_stb_o || $past(spr_bus_stb_o));

// Simple interface assumptions when testing cpu_cappuccino alone
`ifdef CPU_CAPPUCCINO
   // DBUS/IBUS inputs
   always @(posedge clk) begin
      // When we send a request we either get back an ack or an error
      if ($past(ibus_req_o) & ibus_req_o)
	 assume ($onehot({ibus_ack_i,ibus_err_i}));
      if ($past(dbus_req_o) & dbus_req_o)
	 assume ($onehot({dbus_ack_i,dbus_err_i}));

      // Don't allow spurious errors and acks when no requests
      if (!dbus_req_o) begin
	 assume (!dbus_ack_i);
	 assume (!dbus_err_i);
      end
      if (!ibus_req_o) begin
	 assume (!ibus_ack_i);
	 assume (!ibus_err_i);
      end
   end
`endif // CPU_CAPPUCCINO

   always @(*)
      case (ibus_dat_i[`OR1K_ALU_OPC_SELECT])
        `OR1K_ALU_OPC_ADDC,
        `OR1K_ALU_OPC_ADD,
        `OR1K_ALU_OPC_SUB,
        `OR1K_ALU_OPC_MUL,
        `OR1K_ALU_OPC_MULU,
        `OR1K_ALU_OPC_DIV,
        `OR1K_ALU_OPC_DIVU,
        `OR1K_ALU_OPC_SHRT,
        `OR1K_ALU_OPC_FFL1,
        `OR1K_ALU_OPC_EXTBH,
        `OR1K_ALU_OPC_EXTW:
          assume (ibus_dat_i[`OR1K_OPCODE_SELECT] == `OR1K_OPCODE_ALU);
      endcase

   fspr_master #(
        .OPTION_OPERAND_WIDTH(OPTION_OPERAND_WIDTH)
        )
        u_spr_master(
        .clk(clk),
        .rst(rst),
        // SPR interface
        .spr_bus_addr_o(spr_bus_addr_o),
        .spr_bus_we_o(spr_bus_we_o),
        .spr_bus_stb_o(spr_bus_stb_o),
        .spr_bus_dat_o(spr_bus_dat_o),
        .spr_bus_ack_ic_i(spr_bus_ack_ic_i),
        .spr_bus_ack_dc_i(spr_bus_ack_dc_i),
        .spr_bus_ack_dmmu_i(spr_bus_ack_dmmu_i),
        .spr_bus_ack_immu_i(spr_bus_ack_immu_i),
        .f_past_valid(f_past_valid)
  );
`endif // FORMAL
endmodule // mor1kx_cpu_cappuccino
