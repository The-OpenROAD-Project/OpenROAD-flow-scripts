/* ****************************************************************************
  SPDX-License-Identifier: CERN-OHL-W-2.0

  Description: mor1kx control unit

  inputs from execute stage

  generate pipeline controls

  manage SPRs

  issue addresses for exceptions to fetch stage
  control branches going to fetch stage

  contains tick timer

  contains PIC logic

  Copyright (C) 2012 Julius Baxter <juliusbaxter@gmail.com>
  Copyright (C) 2012-2013 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>

***************************************************************************** */

`include "mor1kx-defines.v"

module mor1kx_ctrl_cappuccino
  #(
    parameter OPTION_OPERAND_WIDTH = 32,
    parameter OPTION_RESET_PC = {{(OPTION_OPERAND_WIDTH-13){1'b0}},
				 `OR1K_RESET_VECTOR,8'd0},

    parameter FEATURE_SYSCALL = "ENABLED",
    parameter FEATURE_TRAP = "ENABLED",
    parameter FEATURE_RANGE = "ENABLED",

    parameter FEATURE_DATACACHE = "NONE",
    parameter OPTION_DCACHE_BLOCK_WIDTH = 5,
    parameter OPTION_DCACHE_SET_WIDTH = 9,
    parameter OPTION_DCACHE_WAYS = 2,
    parameter FEATURE_DMMU = "NONE",
    parameter OPTION_DMMU_SET_WIDTH = 6,
    parameter OPTION_DMMU_WAYS = 1,
    parameter FEATURE_INSTRUCTIONCACHE = "NONE",
    parameter OPTION_ICACHE_BLOCK_WIDTH = 5,
    parameter OPTION_ICACHE_SET_WIDTH = 9,
    parameter OPTION_ICACHE_WAYS = 2,
    parameter FEATURE_IMMU = "NONE",
    parameter OPTION_IMMU_SET_WIDTH = 6,
    parameter OPTION_IMMU_WAYS = 1,
    parameter FEATURE_TIMER = "ENABLED",
    parameter FEATURE_DEBUGUNIT = "NONE",
    parameter FEATURE_PERFCOUNTERS = "NONE",
    parameter OPTION_PERFCOUNTERS_NUM = 0,
    parameter FEATURE_PMU = "NONE",
    parameter FEATURE_MAC = "NONE",
    parameter FEATURE_FPU = "NONE",
    parameter FEATURE_MULTICORE = "NONE",

    parameter FEATURE_PIC = "ENABLED",
    parameter OPTION_PIC_TRIGGER = "LEVEL",
    parameter OPTION_PIC_NMI_WIDTH = 0,

    parameter FEATURE_DSX ="NONE",
    parameter FEATURE_FASTCONTEXTS = "NONE",
    parameter OPTION_RF_NUM_SHADOW_GPR = 0,
    parameter FEATURE_OVERFLOW = "NONE",
    parameter FEATURE_CARRY_FLAG = "ENABLED",

    parameter SPR_SR_WIDTH = 16,
    parameter SPR_SR_RESET_VALUE = 16'h8001
    )
   (
    input 			      clk,
    input 			      rst,

    // ALU result - either jump target, SPR address
    input [OPTION_OPERAND_WIDTH-1:0]  ctrl_alu_result_i,

    // LSU address, needed for effective address
    input [OPTION_OPERAND_WIDTH-1:0]  ctrl_lsu_adr_i,

    // Operand B from RF might be jump address, might be value for SPR
    input [OPTION_OPERAND_WIDTH-1:0]  ctrl_rfb_i,

    input 			      ctrl_flag_set_i,
    input 			      ctrl_flag_clear_i,
    input 			      atomic_flag_set_i,
    input 			      atomic_flag_clear_i,

    input [OPTION_OPERAND_WIDTH-1:0]  pc_ctrl_i,

    input 			      ctrl_op_mfspr_i,
    input 			      ctrl_op_mtspr_i,
    input 			      ctrl_op_rfe_i,

    // Indicate if branch will be taken based on instruction currently in
    // decode stage.
    input 			      decode_branch_i,
    input [OPTION_OPERAND_WIDTH-1:0]  decode_branch_target_i,

    input 			      branch_mispredict_i,
    input [OPTION_OPERAND_WIDTH-1:0]  execute_mispredict_target_i,

    // PC of execute stage (NPC)
    input [OPTION_OPERAND_WIDTH-1:0]  pc_execute_i,

    input 			      execute_op_branch_i,

    // Exception inputs, registered on output of execute stage
    input 			      except_ibus_err_i,
    input 			      except_itlb_miss_i,
    input 			      except_ipagefault_i,
    input 			      except_ibus_align_i,
    input 			      except_illegal_i,
    input 			      except_syscall_i,
    input 			      except_dbus_i,
    input 			      except_dtlb_miss_i,
    input 			      except_dpagefault_i,
    input 			      except_trap_i,
    input 			      except_align_i,

    // Inputs from two units that can stall proceedings
    input 			      fetch_valid_i,
    input 			      decode_valid_i,
    input 			      execute_valid_i,
    input 			      ctrl_valid_i,

    input 			      fetch_exception_taken_i,

    input 			      decode_bubble_i,
    input 			      execute_bubble_i,

    // Inputs from decode-exec stage to PCU
    input               execute_op_lsu_load_i,
    input               execute_op_lsu_store_i,

    // Inputs from icache and dcache
    input               icache_hit_i,
    input               dcache_hit_i,

    // External IRQ lines in
    input [31:0] 		      irq_i,

    // Exception PC output, used in the lsu to properly signal dbus errors that
    // has went through the store buffer
    output [OPTION_OPERAND_WIDTH-1:0] ctrl_epcr_o,
    // Exception PC input coming from the store buffer
    input [OPTION_OPERAND_WIDTH-1:0]  store_buffer_epcr_i,

    input 			      store_buffer_err_i,

    // SPR data out
    output [OPTION_OPERAND_WIDTH-1:0] mfspr_dat_o,

    // WE to RF for l.mfspr
    output 			      ctrl_mfspr_ack_o,
    output 			      ctrl_mtspr_ack_o,

    // Flag out to branch control, combinatorial
    output 			      ctrl_flag_o,

    // Arithmetic flags to and from ALU
    output 			      ctrl_carry_o,
    input 			      ctrl_carry_set_i,
    input 			      ctrl_carry_clear_i,
    input 			      ctrl_overflow_set_i,
    input 			      ctrl_overflow_clear_i,

    // FPU Status flags to and from ALU
    output [`OR1K_FPCSR_RM_SIZE-1:0]  ctrl_fpu_round_mode_o,
    input  [`OR1K_FPCSR_WIDTH-1:0]    ctrl_fpcsr_i,
    input                             ctrl_fpcsr_set_i,

    // Branch indicator from control unit (l.rfe/exception)
    output 			      ctrl_branch_exception_o,
    // PC out to fetch stage for l.rfe, exceptions
    output [OPTION_OPERAND_WIDTH-1:0] ctrl_branch_except_pc_o,

    // Clear instructions from decode and fetch stage
    output 			      pipeline_flush_o,

    // Indicate that a rfe is going on
    output 			      doing_rfe_o,

    output 			      padv_fetch_o,
    output 			      padv_decode_o,
    output 			      padv_execute_o,
    output 			      padv_ctrl_o,

    // Debug bus
    input [15:0] 		      du_addr_i,
    input 			      du_stb_i,
    input [OPTION_OPERAND_WIDTH-1:0]  du_dat_i,
    input 			      du_we_i,
    output [OPTION_OPERAND_WIDTH-1:0] du_dat_o,
    output 			      du_ack_o,
    // Stall control from debug interface
    input 			      du_stall_i,
    output 			      du_stall_o,
    output [OPTION_OPERAND_WIDTH-1:0] du_restart_pc_o,
    output 			      du_restart_o,

    // SPR accesses to external units (cache, mmu, etc.)
    output [15:0] 		      spr_bus_addr_o,
    output 			      spr_bus_we_o,
    output 			      spr_bus_stb_o,
    output [OPTION_OPERAND_WIDTH-1:0] spr_bus_dat_o,
    input [OPTION_OPERAND_WIDTH-1:0]  spr_bus_dat_dc_i,
    input 			      spr_bus_ack_dc_i,
    input [OPTION_OPERAND_WIDTH-1:0]  spr_bus_dat_ic_i,
    input 			      spr_bus_ack_ic_i,
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
    input [OPTION_OPERAND_WIDTH-1:0]  spr_gpr_dat_i,
    input 			      spr_gpr_ack_i,
    output [15:0] 		      spr_sr_o,

    output reg 			      ctrl_bubble_o,

    input [OPTION_OPERAND_WIDTH-1:0]  multicore_coreid_i,
    input [OPTION_OPERAND_WIDTH-1:0]  multicore_numcores_i
    );

   // Internal signals
   reg [SPR_SR_WIDTH-1:0] 	     spr_sr;
   reg [SPR_SR_WIDTH-1:0] 	     spr_esr;
   reg [OPTION_OPERAND_WIDTH-1:0]    spr_epcr;
   reg [OPTION_OPERAND_WIDTH-1:0]    spr_eear;
   reg [OPTION_OPERAND_WIDTH-1:0]    spr_evbar;

   // Programmable Interrupt Control SPRs
   wire [31:0] 			     spr_picmr;
   wire [31:0] 			     spr_picsr;

   // Tick Timer SPRs
   wire [31:0] 			     spr_ttmr;
   wire [31:0] 			     spr_ttcr;

   // FPU Control & Status Register
   // and related exeption signals
   reg [`OR1K_FPCSR_WIDTH-1:0]       spr_fpcsr;
   wire                              except_fpu;

   reg [OPTION_OPERAND_WIDTH-1:0]    spr_ppc;
   reg [OPTION_OPERAND_WIDTH-1:0]    spr_npc;
   reg 				     execute_delay_slot;
   reg 				     ctrl_delay_slot;

   wire				     execute_waiting;
   reg 				     execute_waiting_r;

   reg 				     decode_execute_halt;

   reg 				     exception_taken;

   reg [OPTION_OPERAND_WIDTH-1:0]    last_branch_insn_pc;
   reg [OPTION_OPERAND_WIDTH-1:0]    last_branch_target_pc;
   reg 				     padv_ctrl;

   reg 				     exception_r;

   reg [OPTION_OPERAND_WIDTH-1:0]    exception_pc_addr;

   reg 				     waiting_for_fetch;

   reg 				     doing_rfe_r;
   wire 			     doing_rfe;
   wire 			     deassert_doing_rfe;

   wire 			     exception, exception_pending;

   reg 				     ctrl_stage_exceptions;

   wire 			     exception_re;

   wire 			     except_ticktimer;
   wire 			     except_pic;

   wire 			     except_range;

   wire [15:0] 			     spr_addr;

   wire 			     deassert_decode_execute_halt;

   /* Debug SPRs */
   reg [31:0] 			     spr_dmr1;
   reg [31:0] 			     spr_dmr2;
   reg [31:0] 			     spr_dsr;
   reg [31:0] 			     spr_drr;

   /* DU internal control signals */
   wire 			     du_access;
   reg 				     cpu_stall;
   wire 			     du_restart_from_stall;
   reg [5:0] 			     pstep;
   wire 			     stepping;
   wire 			     stepped_into_delay_slot;
   reg 				     stepped_into_exception;
   reg 				     stepped_into_rfe;
   wire 			     du_npc_write;
   reg 				     du_npc_written;
   wire 			     stall_on_trap;

   /* Wires for SPR management */
   wire                              spr_access_valid;
   wire 			     spr_we;
   wire                              spr_read;
   wire                              spr_ack;
   wire [OPTION_OPERAND_WIDTH-1:0]   spr_write_dat;
   reg [11:0]                        spr_access;
   wire [11:0] 			     spr_access_ack;
   wire [31:0] 			     spr_internal_read_dat [0:11];
   wire 			     spr_read_access;
   wire 			     spr_write_access;
   wire 			     spr_bus_access;
   reg [OPTION_OPERAND_WIDTH-1:0]    spr_sys_group_read;
   wire [3:0] 			     spr_group;

   /* Wires from mor1kx_cfgrs module */
   wire [31:0] 			     spr_vr;
   wire [31:0] 			     spr_vr2;
   wire [31:0] 			     spr_avr;
   wire [31:0] 			     spr_upr;
   wire [31:0] 			     spr_cpucfgr;
   wire [31:0] 			     spr_dmmucfgr;
   wire [31:0] 			     spr_immucfgr;
   wire [31:0] 			     spr_dccfgr;
   wire [31:0] 			     spr_iccfgr;
   wire [31:0] 			     spr_dcfgr;
   wire [31:0] 			     spr_pccfgr;
   wire [31:0] 			     spr_isr [0:7];

   assign ctrl_branch_exception_o = (exception_r | ctrl_op_rfe_i | doing_rfe) &
				    !exception_taken;
   assign exception_pending = (except_ibus_err_i | except_ibus_align_i |
			       except_illegal_i | except_syscall_i |
			       except_dbus_i | except_align_i |
			       except_ticktimer | except_range | except_fpu |
			       except_pic | except_trap_i |
			       except_itlb_miss_i | except_ipagefault_i |
			       except_dtlb_miss_i | except_dpagefault_i);

   assign exception = exception_pending &
		      (padv_ctrl & !ctrl_bubble_o | ctrl_stage_exceptions);

   assign exception_re = exception & !exception_r & !exception_taken;

   assign except_range = (FEATURE_RANGE!="NONE") ? spr_sr[`OR1K_SPR_SR_OVE] &&
			 (spr_sr[`OR1K_SPR_SR_OV] | ctrl_overflow_set_i) &
			 !doing_rfe : 0;

   assign deassert_decode_execute_halt = fetch_exception_taken_i &
					 decode_execute_halt;

   assign ctrl_branch_except_pc_o = (ctrl_op_rfe_i | doing_rfe) ? spr_epcr :
				    exception_pc_addr;

   assign ctrl_epcr_o = ctrl_delay_slot ? pc_ctrl_i - 4 : pc_ctrl_i;

   always @(posedge clk)
     ctrl_stage_exceptions <= except_align_i | except_dbus_i | except_range |
			      except_fpu |
			      except_dtlb_miss_i | except_dpagefault_i;

   always @(posedge clk)
     if (exception & !exception_r)
       casez(
	     {
	      except_itlb_miss_i,
	      except_ipagefault_i,
	      except_ibus_err_i,
	      except_illegal_i,
	      except_align_i,
	      except_ibus_align_i,
	      except_syscall_i,
	      except_dtlb_miss_i,
	      except_dpagefault_i,
	      except_trap_i,
	      except_dbus_i,
	      except_range,
	      except_fpu,
	      except_pic,
	      except_ticktimer
	      }
	     )
	 15'b1??????????????:
	   exception_pc_addr <= spr_evbar |
				{19'd0,`OR1K_ITLB_VECTOR,8'd0};
	 15'b01?????????????:
	   exception_pc_addr <= spr_evbar |
				{19'd0,`OR1K_IPF_VECTOR,8'd0};
	 15'b001????????????:
	   exception_pc_addr <= spr_evbar |
				{19'd0,`OR1K_BERR_VECTOR,8'd0};
	 15'b0001???????????:
	   exception_pc_addr <= spr_evbar |
				{19'd0,`OR1K_ILLEGAL_VECTOR,8'd0};
	 15'b00001??????????,
	 15'b000001?????????:
	     exception_pc_addr <= spr_evbar |
				  {19'd0,`OR1K_ALIGN_VECTOR,8'd0};
	 15'b0000001????????:
	   exception_pc_addr <= spr_evbar |
				{19'd0,`OR1K_SYSCALL_VECTOR,8'd0};
	 15'b00000001???????:
	   exception_pc_addr <= spr_evbar |
				{19'd0,`OR1K_DTLB_VECTOR,8'd0};
	 15'b000000001??????:
	   exception_pc_addr <= spr_evbar |
				{19'd0,`OR1K_DPF_VECTOR,8'd0};
	 15'b0000000001?????:
	   exception_pc_addr <= spr_evbar |
				{19'd0,`OR1K_TRAP_VECTOR,8'd0};
	 15'b00000000001????:
	   exception_pc_addr <= spr_evbar |
				{19'd0,`OR1K_BERR_VECTOR,8'd0};
	 15'b000000000001???:
	   exception_pc_addr <= spr_evbar |
				{19'd0,`OR1K_RANGE_VECTOR,8'd0};
	 15'b0000000000001??:
	   exception_pc_addr <= spr_evbar |
				{19'd0,`OR1K_FP_VECTOR,8'd0};
	 15'b00000000000001?:
	   exception_pc_addr <= spr_evbar |
				{19'd0,`OR1K_INT_VECTOR,8'd0};
	 //15'b00000000000001:
	 default:
	   exception_pc_addr <= spr_evbar |
				{19'd0,`OR1K_TT_VECTOR,8'd0};
       endcase // casex (...

   assign execute_waiting = !execute_valid_i;

   assign padv_fetch_o = !execute_waiting & !cpu_stall & !decode_bubble_i
			 & (!stepping | (stepping & pstep[0] & !fetch_valid_i));

   assign padv_decode_o = fetch_valid_i & !execute_waiting &
			  !decode_execute_halt & !cpu_stall
			  & (!stepping | (stepping & pstep[1]));

   assign padv_execute_o = ((decode_valid_i & !execute_waiting &
			     /* Stop fetch before exception branch continuing */
			     !(exception_r & fetch_exception_taken_i)) |
			    (!execute_waiting & execute_waiting_r &
			     fetch_valid_i) |
			    // Case where execute became ready before fetch
			    // after delay in execute stage
			    (waiting_for_fetch & fetch_valid_i)) &
			   // Not exceptions occurring
			   !decode_execute_halt & !exception_re & !ctrl_op_rfe_i
			   & !cpu_stall & (!stepping | (stepping & pstep[2]));

   assign padv_ctrl_o = padv_ctrl;

   assign spr_addr = du_access ? du_addr_i : ctrl_alu_result_i[15:0];
   assign ctrl_mfspr_ack_o = spr_ack;
   assign ctrl_mtspr_ack_o = spr_ack;

   // Pipeline flush
   assign pipeline_flush_o = (padv_ctrl & ctrl_op_rfe_i) |
			     (exception_re) |
			     cpu_stall;

   // Flag output
   wire ctrl_flag_clear = ctrl_flag_clear_i | atomic_flag_clear_i;
   wire ctrl_flag_set = ctrl_flag_set_i | atomic_flag_set_i;

   assign ctrl_flag_o = (!ctrl_flag_clear & spr_sr[`OR1K_SPR_SR_F]) |
			ctrl_flag_set;

   // Carry output
   assign ctrl_carry_o = FEATURE_CARRY_FLAG!="NONE" &
			 (!ctrl_carry_clear_i & spr_sr[`OR1K_SPR_SR_CY] |
			 ctrl_carry_set_i);

   // Ctrl stage pipeline advance signal is one cycle behind execute stage's
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       padv_ctrl <= 0;
     else
       padv_ctrl <= padv_execute_o;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       execute_waiting_r <= 0;
     else if (!execute_waiting)
       execute_waiting_r <= 0;
     else if (decode_valid_i & execute_waiting)
       execute_waiting_r <= 1;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       decode_execute_halt <= 0;
     else if (du_restart_from_stall)
       decode_execute_halt <= 0;
     else if (decode_execute_halt & deassert_decode_execute_halt)
       decode_execute_halt <= 0;
     else if ((ctrl_op_rfe_i | exception) & !decode_execute_halt &
	      !exception_taken)
       decode_execute_halt <= 1;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       exception_r <= 0;
     else if (exception_taken | du_restart_from_stall)
       exception_r <= 0;
     else if (exception & !exception_r)
       exception_r <= 1;

   // Signal to indicate that the incoming exception or l.rfe has been taken
   // and we're waiting for it to propagate through the pipeline.
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       exception_taken <= 0;
     else if (exception_taken)
       exception_taken <= 0;
     else if (exception_r & fetch_exception_taken_i)
       exception_taken <= 1;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       last_branch_insn_pc <= 0;
     else if (padv_execute_o & execute_op_branch_i)
       last_branch_insn_pc <= pc_execute_i;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       last_branch_target_pc <= 0;
     else if (padv_execute_o & branch_mispredict_i)
       last_branch_target_pc <= execute_mispredict_target_i;
     else if (padv_decode_o & decode_branch_i)
       last_branch_target_pc <= decode_branch_target_i;

   // Used to gate execute stage's advance signal in the case where a LSU op has
   // finished before the next instruction has been fetched. Typically this
   // occurs when not using icache and doing lots of memory accesses.
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       waiting_for_fetch <= 0;
     else if (fetch_valid_i)
       waiting_for_fetch <= 0;
     else if (!execute_waiting & execute_waiting_r & !fetch_valid_i)
       waiting_for_fetch <= 1;


   assign doing_rfe = ((padv_ctrl & ctrl_op_rfe_i) | doing_rfe_r) &
		      !deassert_doing_rfe;

   assign doing_rfe_o = doing_rfe;

   assign deassert_doing_rfe = fetch_exception_taken_i & doing_rfe_r;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       doing_rfe_r <= 0;
     else if (deassert_doing_rfe)
       doing_rfe_r <= 0;
     else if (padv_ctrl)
       doing_rfe_r <= ctrl_op_rfe_i;

   assign spr_sr_o = spr_sr;


   // FPU related: FPCSR and exception
   generate
    `ifdef OR1K_FPCSR_MASK_FLAGS
     reg [`OR1K_FPCSR_ALLF_SIZE-1:0] spr_fpcsr_mf; // mask for FPU flags 
    `endif

     /* verilator lint_off WIDTH */
     if (FEATURE_FPU != "NONE") begin : fpu_csr_ena
     /* verilator lint_on WIDTH */      
       assign ctrl_fpu_round_mode_o = spr_fpcsr[`OR1K_FPCSR_RM];

       // select all flags
      `ifdef OR1K_FPCSR_MASK_FLAGS
       wire [`OR1K_FPCSR_ALLF_SIZE-1:0] masked_fpres_flags =
         ctrl_fpcsr_i[`OR1K_FPCSR_ALLF] & spr_fpcsr_mf;

       wire [`OR1K_FPCSR_ALLF_SIZE-1:0] masked_fpcsr_flags =
         spr_fpcsr[`OR1K_FPCSR_ALLF] & spr_fpcsr_mf;


       wire [`OR1K_FPCSR_ALLF_SIZE-1:0] fpu_allf =
         ctrl_fpcsr_set_i ? masked_fpres_flags :
                            masked_fpcsr_flags;
      `else
       wire [`OR1K_FPCSR_ALLF_SIZE-1:0] fpu_allf =
         ctrl_fpcsr_set_i ? ctrl_fpcsr_i[`OR1K_FPCSR_ALLF] :
                            spr_fpcsr[`OR1K_FPCSR_ALLF];
      `endif

       assign except_fpu = (~doing_rfe) &
                           spr_fpcsr[`OR1K_FPCSR_FPEE] & 
                           (|fpu_allf);
        
       // FPU Control & status register
       always @(posedge clk `OR_ASYNC_RST) begin
         if (rst) begin
           spr_fpcsr <= `OR1K_FPCSR_RESET_VALUE;
          `ifdef OR1K_FPCSR_MASK_FLAGS
           spr_fpcsr_mf <= `OR1K_FPCSR_MASK_RESET_VALUE;
          `endif
         end
         else if (exception_re) begin
           spr_fpcsr[`OR1K_FPCSR_ALLF] <= fpu_allf;
           spr_fpcsr[`OR1K_FPCSR_RM]   <= spr_fpcsr[`OR1K_FPCSR_RM];
           spr_fpcsr[`OR1K_FPCSR_FPEE] <= 1'b0;
         end  
         else if ((spr_we & spr_access[`OR1K_SPR_SYS_BASE] &
                  (padv_ctrl | du_access)) &&
                  `SPR_OFFSET(spr_addr)==`SPR_OFFSET(`OR1K_SPR_FPCSR_ADDR)) begin
           spr_fpcsr <= spr_write_dat[`OR1K_FPCSR_WIDTH-1:0]; // update all fields
          `ifdef OR1K_FPCSR_MASK_FLAGS
           spr_fpcsr_mf <= spr_write_dat[`OR1K_FPCSR_MASK_ALL];
          `endif
         end
         else if (padv_ctrl & ctrl_fpcsr_set_i) begin
           spr_fpcsr[`OR1K_FPCSR_ALLF] <= fpu_allf;
           spr_fpcsr[`OR1K_FPCSR_RM]   <= spr_fpcsr[`OR1K_FPCSR_RM];
           spr_fpcsr[`OR1K_FPCSR_FPEE] <= spr_fpcsr[`OR1K_FPCSR_FPEE];
         end
       end // FPCSR reg's always(@posedge clk)
     end
     else begin : fpu_csr_none
       assign ctrl_fpu_round_mode_o = {`OR1K_FPCSR_RM_SIZE{1'b0}};
       assign except_fpu = 0;
       // FPU Control & status register
       always @(posedge clk `OR_ASYNC_RST) begin
         if (rst) begin
           spr_fpcsr <= {`OR1K_FPCSR_WIDTH{1'b0}};
          `ifdef OR1K_FPCSR_MASK_FLAGS
           spr_fpcsr_mf <= {`OR1K_FPCSR_ALLF_SIZE{1'b0}};
          `endif
         end
       end // FPCSR reg's always(@posedge clk)
     end
   endgenerate // FPU related: FPCSR and exception


   // Supervision register
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       spr_sr <= SPR_SR_RESET_VALUE;
     else if (exception_re)
       begin
	  // Go into supervisor mode, disable interrupts, MMUs
	  spr_sr[`OR1K_SPR_SR_SM  ] <= 1'b1;
	  if (FEATURE_TIMER!="NONE")
	    spr_sr[`OR1K_SPR_SR_TEE ] <= 1'b0;
	  if (FEATURE_PIC!="NONE")
	    spr_sr[`OR1K_SPR_SR_IEE ] <= 1'b0;
	  if (FEATURE_DMMU!="NONE")
	    spr_sr[`OR1K_SPR_SR_DME ] <= 1'b0;
	  if (FEATURE_IMMU!="NONE")
	    spr_sr[`OR1K_SPR_SR_IME ] <= 1'b0;
          if (FEATURE_DSX!="NONE")
	    spr_sr[`OR1K_SPR_SR_DSX ] <= ctrl_delay_slot;
	  if (FEATURE_OVERFLOW!="NONE")
	    spr_sr[`OR1K_SPR_SR_OVE ] <= 1'b0;
       end
     else if ((spr_we & spr_access[`OR1K_SPR_SYS_BASE] &
               (spr_sr[`OR1K_SPR_SR_SM] & padv_ctrl | du_access)) &&
              `SPR_OFFSET(spr_addr)==`SPR_OFFSET(`OR1K_SPR_SR_ADDR))
       begin
	  spr_sr[`OR1K_SPR_SR_SM  ] <= spr_write_dat[`OR1K_SPR_SR_SM  ];

	  spr_sr[`OR1K_SPR_SR_F  ] <= spr_write_dat[`OR1K_SPR_SR_F  ];

	  if (FEATURE_TIMER!="NONE")
	    spr_sr[`OR1K_SPR_SR_TEE ] <= spr_write_dat[`OR1K_SPR_SR_TEE ];

	  if (FEATURE_PIC!="NONE")
	    spr_sr[`OR1K_SPR_SR_IEE ] <= spr_write_dat[`OR1K_SPR_SR_IEE ];

	  if (FEATURE_DATACACHE!="NONE")
	    spr_sr[`OR1K_SPR_SR_DCE ] <= spr_write_dat[`OR1K_SPR_SR_DCE ];

	  if (FEATURE_INSTRUCTIONCACHE!="NONE")
	    spr_sr[`OR1K_SPR_SR_ICE ] <= spr_write_dat[`OR1K_SPR_SR_ICE ];

	  if (FEATURE_DMMU!="NONE")
	    spr_sr[`OR1K_SPR_SR_DME ] <= spr_write_dat[`OR1K_SPR_SR_DME ];

	  if (FEATURE_IMMU!="NONE")
	    spr_sr[`OR1K_SPR_SR_IME ] <= spr_write_dat[`OR1K_SPR_SR_IME ];

	  if (FEATURE_FASTCONTEXTS!="NONE")
	    spr_sr[`OR1K_SPR_SR_CE  ] <= spr_write_dat[`OR1K_SPR_SR_CE  ];

	  if (FEATURE_CARRY_FLAG!="NONE")
	    spr_sr[`OR1K_SPR_SR_CY] <= spr_write_dat[`OR1K_SPR_SR_CY];

	  if (FEATURE_OVERFLOW!="NONE") begin
	     spr_sr[`OR1K_SPR_SR_OV  ] <= spr_write_dat[`OR1K_SPR_SR_OV  ];
	     spr_sr[`OR1K_SPR_SR_OVE ] <= spr_write_dat[`OR1K_SPR_SR_OVE ];
	  end

	  if (FEATURE_DSX!="NONE")
	    spr_sr[`OR1K_SPR_SR_DSX ] <= spr_write_dat[`OR1K_SPR_SR_DSX ];

	  spr_sr[`OR1K_SPR_SR_EPH ] <= spr_write_dat[`OR1K_SPR_SR_EPH ];
       end
     else if (padv_ctrl)
       begin
	  spr_sr[`OR1K_SPR_SR_F   ] <= ctrl_flag_set ? 1 :
				       ctrl_flag_clear ? 0 :
				       spr_sr[`OR1K_SPR_SR_F   ];

	  if (FEATURE_CARRY_FLAG!="NONE")
	    spr_sr[`OR1K_SPR_SR_CY] <= ctrl_carry_set_i ? 1 :
				       ctrl_carry_clear_i ? 0 :
				       spr_sr[`OR1K_SPR_SR_CY];
	  if (FEATURE_OVERFLOW!="NONE")
	    spr_sr[`OR1K_SPR_SR_OV   ] <= ctrl_overflow_set_i ? 1 :
				ctrl_overflow_clear_i ? 0 :
				spr_sr[`OR1K_SPR_SR_OV   ];
	  // Skip FO. TODO: make this even more selective.
	  if (ctrl_op_rfe_i)
	    spr_sr[14:0] <= spr_esr[14:0];
       end


   // Exception SR
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       spr_esr <= SPR_SR_RESET_VALUE;
     else if (exception_re)
       begin
	  spr_esr <= spr_sr;
	  if (FEATURE_OVERFLOW!="NONE")
	    begin
	       if (ctrl_overflow_set_i)
		 spr_esr[`OR1K_SPR_SR_OV] <= 1'b1;
	       else if (ctrl_overflow_clear_i)
		 spr_esr[`OR1K_SPR_SR_OV] <= 1'b0;
	    end
	  if (FEATURE_CARRY_FLAG!="NONE") begin
	     if (ctrl_carry_set_i)
	       spr_esr[`OR1K_SPR_SR_CY] <= 1'b1;
	     else if (ctrl_carry_clear_i)
	       spr_esr[`OR1K_SPR_SR_CY] <= 1'b0;
	  end
       end
     else if (spr_we && spr_access[`OR1K_SPR_SYS_BASE] &&
              `SPR_OFFSET(spr_addr)==`SPR_OFFSET(`OR1K_SPR_ESR0_ADDR))
       begin
	  spr_esr[`OR1K_SPR_SR_SM  ] <= spr_write_dat[`OR1K_SPR_SR_SM  ];

	  spr_esr[`OR1K_SPR_SR_F  ] <= spr_write_dat[`OR1K_SPR_SR_F  ];

	  if (FEATURE_TIMER!="NONE")
	    spr_esr[`OR1K_SPR_SR_TEE ] <= spr_write_dat[`OR1K_SPR_SR_TEE ];

	  if (FEATURE_PIC!="NONE")
	    spr_esr[`OR1K_SPR_SR_IEE ] <= spr_write_dat[`OR1K_SPR_SR_IEE ];

	  if (FEATURE_DATACACHE!="NONE")
	    spr_esr[`OR1K_SPR_SR_DCE ] <= spr_write_dat[`OR1K_SPR_SR_DCE ];

	  if (FEATURE_INSTRUCTIONCACHE!="NONE")
	    spr_esr[`OR1K_SPR_SR_ICE ] <= spr_write_dat[`OR1K_SPR_SR_ICE ];

	  if (FEATURE_DMMU!="NONE")
	    spr_esr[`OR1K_SPR_SR_DME ] <= spr_write_dat[`OR1K_SPR_SR_DME ];

	  if (FEATURE_IMMU!="NONE")
	    spr_esr[`OR1K_SPR_SR_IME ] <= spr_write_dat[`OR1K_SPR_SR_IME ];

	  if (FEATURE_FASTCONTEXTS!="NONE")
	    spr_esr[`OR1K_SPR_SR_CE  ] <= spr_write_dat[`OR1K_SPR_SR_CE  ];

	  if (FEATURE_CARRY_FLAG!="NONE")
	    spr_esr[`OR1K_SPR_SR_CY] <= spr_write_dat[`OR1K_SPR_SR_CY];

	  if (FEATURE_OVERFLOW!="NONE") begin
	     spr_esr[`OR1K_SPR_SR_OV  ] <= spr_write_dat[`OR1K_SPR_SR_OV  ];
	     spr_esr[`OR1K_SPR_SR_OVE ] <= spr_write_dat[`OR1K_SPR_SR_OVE ];
	  end

	  if (FEATURE_DSX!="NONE")
	    spr_esr[`OR1K_SPR_SR_DSX ] <= spr_write_dat[`OR1K_SPR_SR_DSX ];

	  spr_esr[`OR1K_SPR_SR_EPH ] <= spr_write_dat[`OR1K_SPR_SR_EPH ];
       end

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       ctrl_bubble_o <= 0;
     else if (padv_execute_o)
       ctrl_bubble_o <= execute_bubble_i;

   // Exception PC
   always @(posedge clk)
     if (exception_re) begin
	if (except_ibus_err_i)
	  spr_epcr <= last_branch_insn_pc;
	// Syscall is a special case, we return back to the instruction _after_
	// the syscall instruction, unless the syscall was in a delay slot
	else if (except_syscall_i)
	  spr_epcr <= ctrl_delay_slot ? ctrl_epcr_o : pc_ctrl_i + 4;
	else if (store_buffer_err_i)
	  spr_epcr <= store_buffer_epcr_i;
	// Update EPCR unless we are handing over to the debug unit hardware
	// i.e. single stepping.
	else if (!(except_trap_i & stall_on_trap))
	  spr_epcr <= ctrl_epcr_o;
     end else if (spr_we && spr_access[`OR1K_SPR_SYS_BASE] &&
                  `SPR_OFFSET(spr_addr)==`SPR_OFFSET(`OR1K_SPR_EPCR0_ADDR)) begin
	spr_epcr <= spr_write_dat;
     end

   // Exception Effective Address
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       spr_eear <= {OPTION_OPERAND_WIDTH{1'b0}};
     else if (/*padv_ctrl & exception*/ exception_re)
       begin
	  if (except_ibus_err_i | except_itlb_miss_i | except_ipagefault_i)
	    spr_eear <= pc_ctrl_i;
	  else
	    spr_eear <= ctrl_lsu_adr_i;
       end

   // Track the PC
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       spr_ppc <= OPTION_RESET_PC;
     else if (padv_ctrl)
       spr_ppc <= pc_ctrl_i;

   // Generate the NPC for SPR accesses
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       spr_npc <= OPTION_RESET_PC;
     else if (du_npc_write)
       spr_npc <= du_dat_i;
     else if (du_npc_written)
       spr_npc <= spr_npc;
     else if (stepping) begin
	if (stepped_into_rfe)
	  spr_npc <= spr_epcr;
	else if (stepped_into_delay_slot)
	  spr_npc <= last_branch_target_pc;
	else if (stepped_into_exception)
	  spr_npc <= exception_pc_addr;
	else
	  spr_npc <= pc_ctrl_i + 4;
     end else if (stall_on_trap & padv_ctrl & except_trap_i)
       spr_npc <= pc_ctrl_i;
     else if (cpu_stall & padv_ctrl)
       spr_npc <= ctrl_delay_slot ? pc_ctrl_i - 4 : pc_ctrl_i;
     else if (!cpu_stall)
       spr_npc <= pc_execute_i;

   // Exception Vector Address
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       spr_evbar <= {OPTION_OPERAND_WIDTH{1'b0}};
     else if (spr_we && spr_access[`OR1K_SPR_SYS_BASE] &&
              `SPR_OFFSET(spr_addr)==`SPR_OFFSET(`OR1K_SPR_EVBAR_ADDR))
       spr_evbar <= {spr_write_dat[OPTION_OPERAND_WIDTH-1:13], 13'd0};

   // Remember when we're in a delay slot in execute stage.
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       execute_delay_slot <= 0;
     else if (padv_execute_o)
       execute_delay_slot <= execute_op_branch_i;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       ctrl_delay_slot <= 0;
     else if (padv_execute_o)
       ctrl_delay_slot <= execute_delay_slot;

   mor1kx_cfgrs
     #(.FEATURE_PIC			(FEATURE_PIC),
       .FEATURE_TIMER			(FEATURE_TIMER),
       .OPTION_PIC_TRIGGER		(OPTION_PIC_TRIGGER),
       .FEATURE_DSX			(FEATURE_DSX),
       .FEATURE_FASTCONTEXTS		(FEATURE_FASTCONTEXTS),
       .OPTION_RF_NUM_SHADOW_GPR	(OPTION_RF_NUM_SHADOW_GPR),
       .FEATURE_OVERFLOW		(FEATURE_OVERFLOW),
       .FEATURE_DATACACHE		(FEATURE_DATACACHE),
       .OPTION_DCACHE_BLOCK_WIDTH	(OPTION_DCACHE_BLOCK_WIDTH),
       .OPTION_DCACHE_SET_WIDTH		(OPTION_DCACHE_SET_WIDTH),
       .OPTION_DCACHE_WAYS		(OPTION_DCACHE_WAYS),
       .FEATURE_DMMU			(FEATURE_DMMU),
       .OPTION_DMMU_SET_WIDTH		(OPTION_DMMU_SET_WIDTH),
       .OPTION_DMMU_WAYS		(OPTION_DMMU_WAYS),
       .FEATURE_INSTRUCTIONCACHE	(FEATURE_INSTRUCTIONCACHE),
       .OPTION_ICACHE_BLOCK_WIDTH	(OPTION_ICACHE_BLOCK_WIDTH),
       .OPTION_ICACHE_SET_WIDTH		(OPTION_ICACHE_SET_WIDTH),
       .OPTION_ICACHE_WAYS		(OPTION_ICACHE_WAYS),
       .FEATURE_IMMU			(FEATURE_IMMU),
       .OPTION_IMMU_SET_WIDTH		(OPTION_IMMU_SET_WIDTH),
       .OPTION_IMMU_WAYS		(OPTION_IMMU_WAYS),
       .FEATURE_DEBUGUNIT		(FEATURE_DEBUGUNIT),
       .FEATURE_PERFCOUNTERS		(FEATURE_PERFCOUNTERS),
       .OPTION_PERFCOUNTERS_NUM  (OPTION_PERFCOUNTERS_NUM),
       .FEATURE_MAC			(FEATURE_MAC),
       .FEATURE_FPU			(FEATURE_FPU), // mor1kx_cfgrs instance
       .FEATURE_SYSCALL			(FEATURE_SYSCALL),
       .FEATURE_TRAP			(FEATURE_TRAP),
       .FEATURE_RANGE			(FEATURE_RANGE),
       .FEATURE_DELAYSLOT               ("ENABLED"),
       .FEATURE_EVBAR                   ("ENABLED")
       )
   mor1kx_cfgrs
     (/*AUTOINST*/
      // Outputs
      .spr_vr				(spr_vr[31:0]),
      .spr_vr2				(spr_vr2[31:0]),
      .spr_upr				(spr_upr[31:0]),
      .spr_cpucfgr			(spr_cpucfgr[31:0]),
      .spr_dmmucfgr			(spr_dmmucfgr[31:0]),
      .spr_immucfgr			(spr_immucfgr[31:0]),
      .spr_dccfgr			(spr_dccfgr[31:0]),
      .spr_iccfgr			(spr_iccfgr[31:0]),
      .spr_dcfgr			(spr_dcfgr[31:0]),
      .spr_pccfgr			(spr_pccfgr[31:0]),
      .spr_avr				(spr_avr[31:0]));

   /* Implementation-specific registers */
   assign spr_isr[0] = 0;
   assign spr_isr[1] = 0;
   assign spr_isr[2] = 0;
   assign spr_isr[3] = 0;
   assign spr_isr[4] = 0;
   assign spr_isr[5] = 0;
   assign spr_isr[6] = 0;
   assign spr_isr[7] = 0;

   // System group (0) SPR data out
   always @* begin
     spr_sys_group_read = 0;
     if (spr_access[`OR1K_SPR_SYS_BASE])
       case(`SPR_OFFSET(spr_addr))
         `SPR_OFFSET(`OR1K_SPR_VR_ADDR):
           spr_sys_group_read = spr_vr;
         `SPR_OFFSET(`OR1K_SPR_VR2_ADDR):
           spr_sys_group_read = {spr_vr2[31:8], `MOR1KX_PIPEID_CAPPUCCINO};
         `SPR_OFFSET(`OR1K_SPR_AVR_ADDR):
           spr_sys_group_read = spr_avr;
         `SPR_OFFSET(`OR1K_SPR_UPR_ADDR):
           spr_sys_group_read = spr_upr;
         `SPR_OFFSET(`OR1K_SPR_CPUCFGR_ADDR):
           spr_sys_group_read = spr_cpucfgr;
         `SPR_OFFSET(`OR1K_SPR_DMMUCFGR_ADDR):
           spr_sys_group_read = spr_dmmucfgr;
         `SPR_OFFSET(`OR1K_SPR_IMMUCFGR_ADDR):
           spr_sys_group_read = spr_immucfgr;
         `SPR_OFFSET(`OR1K_SPR_DCCFGR_ADDR):
           spr_sys_group_read = spr_dccfgr;
         `SPR_OFFSET(`OR1K_SPR_ICCFGR_ADDR):
           spr_sys_group_read = spr_iccfgr;
         `SPR_OFFSET(`OR1K_SPR_DCFGR_ADDR):
           spr_sys_group_read = spr_dcfgr;
         `SPR_OFFSET(`OR1K_SPR_PCCFGR_ADDR):
           spr_sys_group_read = spr_pccfgr;
         `SPR_OFFSET(`OR1K_SPR_NPC_ADDR):
           spr_sys_group_read = spr_npc;
         `SPR_OFFSET(`OR1K_SPR_SR_ADDR):
           spr_sys_group_read = {{(OPTION_OPERAND_WIDTH-SPR_SR_WIDTH){1'b0}},
                                 spr_sr};

         `SPR_OFFSET(`OR1K_SPR_PPC_ADDR):
           spr_sys_group_read = spr_ppc;
        `ifdef OR1K_FPCSR_MASK_FLAGS
         `SPR_OFFSET(`OR1K_SPR_FPCSR_ADDR):
           spr_sys_group_read =
             {{(OPTION_OPERAND_WIDTH-`OR1K_FPCSR_WIDTH-`OR1K_FPCSR_ALLF_SIZE){1'b0}},
              spr_fpcsr_mf,spr_fpcsr};
        `else
         `SPR_OFFSET(`OR1K_SPR_FPCSR_ADDR):
           spr_sys_group_read = {{(OPTION_OPERAND_WIDTH-`OR1K_FPCSR_WIDTH){1'b0}},
                                 spr_fpcsr};
        `endif
         `SPR_OFFSET(`OR1K_SPR_EPCR0_ADDR):
           spr_sys_group_read = spr_epcr;
         `SPR_OFFSET(`OR1K_SPR_EEAR0_ADDR):
           spr_sys_group_read = spr_eear;
         `SPR_OFFSET(`OR1K_SPR_ESR0_ADDR):
           spr_sys_group_read = {{(OPTION_OPERAND_WIDTH-SPR_SR_WIDTH){1'b0}},
                                 spr_esr};
         `SPR_OFFSET(`OR1K_SPR_EVBAR_ADDR):
           spr_sys_group_read = spr_evbar;
         `SPR_OFFSET(`OR1K_SPR_ISR0_ADDR):
           spr_sys_group_read = spr_isr[0];
         `SPR_OFFSET(`OR1K_SPR_ISR0_ADDR) +1:
           spr_sys_group_read = spr_isr[1];
         `SPR_OFFSET(`OR1K_SPR_ISR0_ADDR) +2:
           spr_sys_group_read = spr_isr[2];
         `SPR_OFFSET(`OR1K_SPR_ISR0_ADDR) +3:
           spr_sys_group_read = spr_isr[3];
         `SPR_OFFSET(`OR1K_SPR_ISR0_ADDR) +4:
           spr_sys_group_read = spr_isr[4];
         `SPR_OFFSET(`OR1K_SPR_ISR0_ADDR) +5:
           spr_sys_group_read = spr_isr[5];
         `SPR_OFFSET(`OR1K_SPR_ISR0_ADDR) +6:
           spr_sys_group_read = spr_isr[6];
         `SPR_OFFSET(`OR1K_SPR_ISR0_ADDR) +7:
           spr_sys_group_read = spr_isr[7];

         `SPR_OFFSET(`OR1K_SPR_COREID_ADDR):
           // If the multicore feature is activated this address returns the
           // core identifier, 0 otherwise
           spr_sys_group_read = (FEATURE_MULTICORE!="NONE") ?
                                multicore_coreid_i : 0;
         `SPR_OFFSET(`OR1K_SPR_NUMCORES_ADDR):
           // If the multicore feature is activated this address returns the
           // core identifier, 0 otherwise
           spr_sys_group_read = (FEATURE_MULTICORE!="NONE") ?
                                multicore_numcores_i : 0;

         default:
            // GPR read
            if (spr_addr[10:9] == 2'h2)
              spr_sys_group_read = spr_gpr_dat_i; // Register file
       endcase
    end

   /* System group read data MUX in */
   assign spr_internal_read_dat[`OR1K_SPR_SYS_BASE] = spr_sys_group_read;
   /* System group ack generation */

   assign spr_access_ack[`OR1K_SPR_SYS_BASE] = spr_access[`OR1K_SPR_SYS_BASE] &
                                               ((spr_addr[10:9] == 2'h2) ?
                                                 spr_gpr_ack_i : 1);

   //
   // Generate data to the register file for mfspr operations
   // Read datas are simply ORed since set to 0 when not
   // concerned by spr access.
   //
   assign mfspr_dat_o = spr_internal_read_dat[`OR1K_SPR_SYS_BASE]  |
                        spr_internal_read_dat[`OR1K_SPR_DMMU_BASE] |
                        spr_internal_read_dat[`OR1K_SPR_IMMU_BASE] |
                        spr_internal_read_dat[`OR1K_SPR_DC_BASE]   |
                        spr_internal_read_dat[`OR1K_SPR_IC_BASE]   |
                        spr_internal_read_dat[`OR1K_SPR_MAC_BASE]  |
                        spr_internal_read_dat[`OR1K_SPR_DU_BASE]   |
                        spr_internal_read_dat[`OR1K_SPR_PC_BASE]   |
                        spr_internal_read_dat[`OR1K_SPR_PM_BASE]   |
                        spr_internal_read_dat[`OR1K_SPR_PIC_BASE]  |
                        spr_internal_read_dat[`OR1K_SPR_TT_BASE]   |
                        spr_internal_read_dat[`OR1K_SPR_FPU_BASE];

   // PIC SPR control
   generate

      if (FEATURE_PIC !="NONE") begin : pic

         /* mor1kx_pic AUTO_TEMPLATE (
          .spr_picsr_o          (spr_picsr),
          .spr_picmr_o          (spr_picmr),
          .spr_bus_ack          (spr_access_ack[`OR1K_SPR_PIC_BASE]),
          .spr_dat_o            (spr_internal_read_dat[`OR1K_SPR_PIC_BASE]),
          // Inputs
          .spr_we_i             (spr_we),
          .spr_access_i         (spr_access[`OR1K_SPR_PIC_BASE])
          .spr_addr_i           (spr_addr),
          .spr_dat_i            (spr_write_dat),
          );*/
         mor1kx_pic
          #(
            .OPTION_PIC_TRIGGER(OPTION_PIC_TRIGGER),
            .OPTION_PIC_NMI_WIDTH(OPTION_PIC_NMI_WIDTH)
            )
         mor1kx_pic
           (/*AUTOINST*/
            // Outputs
            .spr_picmr_o        (spr_picmr),                // Templated
            .spr_picsr_o        (spr_picsr),                // Templated
            .spr_bus_ack        (spr_access_ack[`OR1K_SPR_PIC_BASE]), // Templated
            .spr_dat_o          (spr_internal_read_dat[`OR1K_SPR_PIC_BASE]), // Templated
            // Inputs
            .clk                (clk),
            .rst                (rst),
            .irq_i              (irq_i[31:0]),
            .spr_access_i       (spr_access[`OR1K_SPR_PIC_BASE]), // Templated
            .spr_we_i           (spr_we),                 // Templated
            .spr_addr_i         (spr_addr),               // Templated
            .spr_dat_i          (spr_write_dat));         // Templated


	 assign except_pic = (|spr_picsr) & spr_sr[`OR1K_SPR_SR_IEE] &
			     !ctrl_op_mtspr_i & !doing_rfe;
      end
      else begin
         assign except_pic = 0;
         assign spr_picsr = 0;
         assign spr_picmr = 0;
         assign spr_access_ack[`OR1K_SPR_PIC_BASE] = 0;
         assign spr_internal_read_dat[`OR1K_SPR_PIC_BASE] = 0;
      end // else: !if(FEATURE_PIC !="NONE")
   endgenerate

   // PCU SPR control
   wire dchache_miss = !dcache_hit_i & ((execute_op_lsu_load_i | execute_op_lsu_store_i) & padv_execute_o);
   generate
      if (FEATURE_PERFCOUNTERS !="NONE") begin : pcu

         /* mor1kx_pcu AUTO_TEMPLATE (
          .spr_bus_ack          (spr_access_ack[`OR1K_SPR_PC_BASE]),
          .spr_dat_o            (spr_internal_read_dat[`OR1K_SPR_PC_BASE]),
          // Inputs
          .spr_we_i             (spr_we),
          .spr_re_i             (spr_read),
          .spr_access_i         (spr_access[`OR1K_SPR_PC_BASE])
          .spr_addr_i           (spr_addr),
          .spr_dat_i            (spr_write_dat),
          );*/
         mor1kx_pcu
          #(
            .OPTION_PERFCOUNTERS_NUM(OPTION_PERFCOUNTERS_NUM)
            )
         mor1kx_pcu
           (/*AUTOINST*/
            // Outputs
            .spr_bus_ack        (spr_access_ack[`OR1K_SPR_PC_BASE]), // Templated
            .spr_dat_o          (spr_internal_read_dat[`OR1K_SPR_PC_BASE]), // Templated
            // Inputs
            .clk                (clk),
            .rst                (rst),
            .spr_access_i       (spr_access[`OR1K_SPR_PC_BASE]), // Templated
            .spr_we_i           (spr_we),                 // Templated
            .spr_re_i           (spr_read),               // Templated
            .spr_addr_i         (spr_addr),               // Templated
            .spr_dat_i          (spr_write_dat),          // Templated
            .spr_sys_mode_i     (spr_sr[`OR1K_SPR_SR_SM]),
            .pcu_event_load_i   (execute_op_lsu_load_i & padv_execute_o),
            .pcu_event_store_i  (execute_op_lsu_store_i & padv_execute_o),
            .pcu_event_ifetch_i (fetch_valid_i),
            .pcu_event_dcache_miss_i(dchache_miss),
            .pcu_event_icache_miss_i(!icache_hit_i & !waiting_for_fetch),
            .pcu_event_ifetch_stall_i(!padv_fetch_o),
            .pcu_event_lsu_stall_i(!ctrl_valid_i),
            .pcu_event_brn_stall_i(branch_mispredict_i & padv_decode_o),
            .pcu_event_dtlb_miss_i(except_dtlb_miss_i),
            .pcu_event_itlb_miss_i(except_itlb_miss_i),
            .pcu_event_datadep_stall_i(execute_waiting)
            );
      end
      else begin
         assign spr_access_ack[`OR1K_SPR_PC_BASE] = 0;
         assign spr_internal_read_dat[`OR1K_SPR_PC_BASE] = 0;
      end // else: !if(FEATURE_PERFCOUNTERS !="NONE")
   endgenerate

   generate
      if (FEATURE_TIMER!="NONE") begin : tt

         /* mor1kx_ticktimer AUTO_TEMPLATE (
          .spr_ttmr_o           (spr_ttmr),
          .spr_ttcr_o           (spr_ttcr),
          .spr_bus_ack          (spr_access_ack[`OR1K_SPR_TT_BASE]),
          .spr_dat_o            (spr_internal_read_dat[`OR1K_SPR_TT_BASE]),
          // Inputs
          .spr_access_i         (spr_access[`OR1K_SPR_TT_BASE]),
          .spr_we_i             (spr_we),
          .spr_addr_i           (spr_addr),
          .spr_dat_i            (spr_write_dat),
          );*/
         mor1kx_ticktimer mor1kx_ticktimer
                         (/*AUTOINST*/
                          // Outputs
                          .spr_ttmr_o           (spr_ttmr),                  // Templated
                          .spr_ttcr_o           (spr_ttcr),                  // Templated
                          .spr_bus_ack          (spr_access_ack[`OR1K_SPR_TT_BASE]), // Templated
                          .spr_dat_o            (spr_internal_read_dat[`OR1K_SPR_TT_BASE]), // Templated
                          // Inputs
                          .clk                  (clk),
                          .rst                  (rst),
                          .spr_access_i         (spr_access[`OR1K_SPR_TT_BASE]), // Templated
                          .spr_we_i             (spr_we),         // Templated
                          .spr_addr_i           (spr_addr),       // Templated
                          .spr_dat_i            (spr_write_dat)); // Templated

	 assign except_ticktimer = spr_ttmr[28] & spr_sr[`OR1K_SPR_SR_TEE] &
				   !ctrl_op_mtspr_i & !doing_rfe;

      end // if (FEATURE_TIMER!="NONE")
      else begin
         assign except_ticktimer = 0;
         assign spr_ttmr = 0;
         assign spr_ttcr = 0;
         assign spr_access_ack[`OR1K_SPR_TT_BASE] = 0;
         assign spr_internal_read_dat[`OR1K_SPR_TT_BASE] = 0;
      end // else: !if(FEATURE_TIMER!="NONE")
   endgenerate

   /* SPR access control - allow accesses from either the instructions or from
    the debug interface */
   assign spr_read_access = (ctrl_op_mfspr_i | (du_access & !du_we_i));
   assign spr_write_access = (ctrl_op_mtspr_i | (du_access & du_we_i));

   assign spr_write_dat = du_access ? du_dat_i : ctrl_rfb_i;
   assign spr_we = spr_write_access & spr_access_valid;
   assign spr_read = spr_read_access & spr_access_valid;

   /* A bus out to other units that live outside of the control unit */
   assign spr_bus_addr_o = spr_addr;
   assign spr_bus_we_o = spr_write_access & spr_access_valid & spr_bus_access;
   assign spr_bus_stb_o = (spr_read_access | spr_write_access) &
                          spr_access_valid & spr_bus_access;
   assign spr_bus_dat_o = spr_write_dat;

   assign spr_group = spr_addr[14:11];

   /* Select spr */
   always @(*) begin
     spr_access = 0;
      case(spr_group)
         // System group
         `OR1K_SPR_SYS_BASE:
           spr_access[`OR1K_SPR_SYS_BASE] = 1'b1;
         // DMMU
         `OR1K_SPR_DMMU_BASE:
           spr_access[`OR1K_SPR_DMMU_BASE] = (FEATURE_DMMU!="NONE");
         // IMMU
         `OR1K_SPR_IMMU_BASE:
           spr_access[`OR1K_SPR_IMMU_BASE] = (FEATURE_IMMU!="NONE");
         // Data cache
         `OR1K_SPR_DC_BASE:
           spr_access[`OR1K_SPR_DC_BASE] = (FEATURE_DATACACHE!="NONE");
         // Instruction cache
         `OR1K_SPR_IC_BASE:
           spr_access[`OR1K_SPR_IC_BASE] = (FEATURE_INSTRUCTIONCACHE!= "NONE");
         // MAC unit
         `OR1K_SPR_MAC_BASE:
           spr_access[`OR1K_SPR_MAC_BASE] = (FEATURE_MAC!="NONE");
         // Debug unit
         `OR1K_SPR_DU_BASE:
           spr_access[`OR1K_SPR_DU_BASE] = (FEATURE_DEBUGUNIT!="NONE");
         // Performance counters
         `OR1K_SPR_PC_BASE:
           spr_access[`OR1K_SPR_PC_BASE] = (FEATURE_PERFCOUNTERS!="NONE");
         // Power Management
         `OR1K_SPR_PM_BASE:
           spr_access[`OR1K_SPR_PM_BASE] = (FEATURE_PMU!="NONE");
         // PIC
         `OR1K_SPR_PIC_BASE:
           spr_access[`OR1K_SPR_PIC_BASE] = (FEATURE_PIC!="NONE");
         // Tick timer
         `OR1K_SPR_TT_BASE:
           spr_access[`OR1K_SPR_TT_BASE] = (FEATURE_TIMER!="NONE");
         // FPU
         `OR1K_SPR_FPU_BASE:
           spr_access[`OR1K_SPR_FPU_BASE] = (FEATURE_FPU!="NONE");
         /* generate invalid if the group is not present in the design  */
         default:
           spr_access = 0;
       endcase
    end

    // Is the SPR in the design?
    assign spr_access_valid = |spr_access;

    assign spr_ack = (|spr_access_ack) | !spr_access_valid;

   /* Is a SPR bus access needed, or is the requested SPR in this file? */
   assign spr_bus_access = /* Any of the units we don't have in this file */
                           /* System group */
                           !(spr_access[`OR1K_SPR_SYS_BASE] ||
                             /* Debug Group */
                             spr_access[`OR1K_SPR_DU_BASE] ||
                             /* PIC Group */
                             spr_access[`OR1K_SPR_PIC_BASE] ||
                             /* Tick Group */
                             spr_access[`OR1K_SPR_TT_BASE]) ||
                             // GPR
                             (spr_access[`OR1K_SPR_SYS_BASE] &&
                              spr_addr[10:9]==2'h2);

   generate
      if (FEATURE_DEBUGUNIT!="NONE") begin : du

	 reg [OPTION_OPERAND_WIDTH-1:0] du_read_dat;

	 reg 				du_ack;
	 reg 				du_stall_r;
	 reg [1:0] 			branch_step;

	 assign du_access = du_stb_i;

	 // Generate ack back to the debug interface bus
	 always @(posedge clk `OR_ASYNC_RST)
	   if (rst)
	     du_ack <= 0;
	   else if (du_ack)
	     du_ack <= 0;
	   else if (du_stb_i) begin
           	  du_ack <= spr_ack;
	   end

	 assign du_ack_o = du_ack;

	 /* Data back to the debug bus */
	 always @(posedge clk)
	   du_read_dat <= mfspr_dat_o;

	 assign du_dat_o = du_read_dat;

	 always @(posedge clk)
	   if (rst)
	     cpu_stall <= 0;
	   else if (!du_stall_i)
	     cpu_stall <= 0;
	   else if (padv_execute_o & !execute_bubble_i & du_stall_i |
		    du_stall_o)
	     cpu_stall <= 1;

	 /* goes out to the debug interface and comes back 1 cycle later
	  via du_stall_i */
	 assign du_stall_o = stepping & pstep[4] |
			     (stall_on_trap & padv_ctrl & except_trap_i);

	 /* Pulse to indicate we're restarting after a stall */
	 assign du_restart_from_stall = du_stall_r & !du_stall_i;

	 /* NPC debug control logic */
	 assign du_npc_write = (du_we_i && du_addr_i==`OR1K_SPR_NPC_ADDR &&
				du_ack_o);

	 /* Pick the traps-cause-stall bit out of the DSR */
	 assign stall_on_trap = spr_dsr[`OR1K_SPR_DSR_TE];

	 /* record if NPC was written while we were stalled.
	  If so, we will use this value for restarting */
	 always @(posedge clk `OR_ASYNC_RST)
	   if (rst)
	     du_npc_written <= 0;
	   else if (du_restart_from_stall)
	     du_npc_written <= 0;
	   else if (du_npc_write)
	     du_npc_written <= 1;

	 always @(posedge clk `OR_ASYNC_RST)
	   if (rst)
	     stepped_into_exception <= 0;
	   else if (du_restart_from_stall)
	     stepped_into_exception <= 0;
	   else if (exception & stepping & (padv_ctrl | ctrl_stage_exceptions))
	     stepped_into_exception <= 1;

	 always @(posedge clk `OR_ASYNC_RST)
	   if (rst)
	     stepped_into_rfe <= 0;
	   else if (du_restart_from_stall)
	     stepped_into_rfe <= 0;
	   else if (stepping & padv_ctrl)
	     stepped_into_rfe <= ctrl_op_rfe_i;

	 assign du_restart_pc_o = spr_npc;

	 assign du_restart_o = du_restart_from_stall;

	 /* Indicate when we're stepping */
	 assign stepping = spr_dmr1[`OR1K_SPR_DMR1_ST] &
			   spr_dsr[`OR1K_SPR_DSR_TE];

	 always @(posedge clk `OR_ASYNC_RST)
	   if (rst)
	     pstep <= 0;
	   else if (du_restart_from_stall & stepping)
	     pstep <= 6'h1;
	   else if ((pstep[0] & fetch_valid_i) |
		    /* decode is always single cycle */
		    (pstep[1] & padv_decode_o) |
		    /* execute stage */
		    (pstep[2] & (execute_valid_i | ctrl_stage_exceptions)) |
		    /* ctrl stage */
		    (pstep[3] & (ctrl_valid_i | ctrl_stage_exceptions)) |
		    pstep[4])
	     pstep <= {pstep[4:0],1'b0};

	 always @(posedge clk `OR_ASYNC_RST)
	   if (rst)
	     branch_step <= 0;
	   else if (du_npc_written)
	     branch_step <= 0;
	   else if (stepping & pstep[2])
	     branch_step <= {branch_step[0], decode_branch_i};
	   else if (!stepping & padv_ctrl)
	     branch_step <= {branch_step[0], ctrl_delay_slot};

	 assign stepped_into_delay_slot = branch_step[1] & stepping;

	 /* Signals for waveform debuging */
	 wire [31:0] spr_read_data_group_0;
	 assign spr_read_data_group_0 = spr_internal_read_dat[0];
	 wire [31:0] spr_read_data_group_1;
	 assign spr_read_data_group_1 = spr_internal_read_dat[1];
	 wire [31:0] spr_read_data_group_2;
	 assign spr_read_data_group_2 = spr_internal_read_dat[2];
	 wire [31:0] spr_read_data_group_3;
	 assign spr_read_data_group_3 = spr_internal_read_dat[3];
	 wire [31:0] spr_read_data_group_4;
	 assign spr_read_data_group_4 = spr_internal_read_dat[4];
	 wire [31:0] spr_read_data_group_5;
	 assign spr_read_data_group_5 = spr_internal_read_dat[5];
	 wire [31:0] spr_read_data_group_6;
	 assign spr_read_data_group_6 = spr_internal_read_dat[6];
	 wire [31:0] spr_read_data_group_7;
	 assign spr_read_data_group_7 = spr_internal_read_dat[7];
	 wire [31:0] spr_read_data_group_8;
	 assign spr_read_data_group_8 = spr_internal_read_dat[8];
	 wire [31:0] spr_read_data_group_9;
	 assign spr_read_data_group_9 = spr_internal_read_dat[9];


         /* always single cycle access */
         assign spr_access_ack[`OR1K_SPR_DU_BASE] = spr_access[`OR1K_SPR_DU_BASE];
         assign spr_internal_read_dat[`OR1K_SPR_DU_BASE] =
                                           (spr_addr==`OR1K_SPR_DMR1_ADDR) ?
                                           spr_dmr1 :
                                           (spr_addr==`OR1K_SPR_DMR2_ADDR) ?
                                           spr_dmr2 :
                                           (spr_addr==`OR1K_SPR_DSR_ADDR) ?
                                           spr_dsr :
                                           (spr_addr==`OR1K_SPR_DRR_ADDR) ?
                                           spr_drr : 0;

	 /* Put the incoming stall signal through a register to detect FE */
	 always @(posedge clk `OR_ASYNC_RST)
	   if (rst)
	     du_stall_r <= 0;
	   else
	     du_stall_r <= du_stall_i;

	 /* DMR1 */
	 always @(posedge clk `OR_ASYNC_RST)
	   if (rst)
	     spr_dmr1 <= 0;
	   else if (spr_we && spr_addr==`OR1K_SPR_DMR1_ADDR)
	     spr_dmr1[23:0] <= spr_write_dat[23:0];

	 /* DMR2 */
	 always @(posedge clk)
	   spr_dmr2 <= 0;

	 /* DSR */
	 always @(posedge clk `OR_ASYNC_RST)
	   if (rst)
	     spr_dsr <= 0;
	   else if (spr_we && spr_addr==`OR1K_SPR_DSR_ADDR)
	     spr_dsr[13:0] <= spr_write_dat[13:0];

	 /* DRR */
	 always @(posedge clk `OR_ASYNC_RST)
	   if (rst)
	     spr_drr <= 0;
	   else if (spr_we && spr_addr==`OR1K_SPR_DRR_ADDR)
	     spr_drr[13:0] <= spr_write_dat[13:0];
	   else if (stall_on_trap & padv_ctrl & except_trap_i)
	     spr_drr[`OR1K_SPR_DRR_TE] <= 1;

      end // block: du
      else
	begin : no_du
	   assign du_access = 0;
	   assign du_stall_o = 0;
	   assign du_ack_o = 0;
	   assign du_restart_o = 0;
	   assign du_restart_pc_o = 0;
	   assign stepping = 0;
	   assign du_npc_write = 0;
	   assign stepped_into_delay_slot = 0;
	   assign du_dat_o = 0;
	   assign du_restart_from_stall = 0;
           assign spr_access_ack[`OR1K_SPR_DU_BASE] = 0;
           assign spr_internal_read_dat[`OR1K_SPR_DU_BASE] = 0;
	   assign stall_on_trap = 0;
	   always @(posedge clk)
	     begin
		spr_dmr1 <= 0;
		spr_dmr2 <= 0;
		spr_dsr <= 0;
		spr_drr <= 0;
		du_npc_written <= 0;
		cpu_stall <= 0;

		stepped_into_rfe <= 0;
		stepped_into_exception <= 0;
	     end
	end
   endgenerate

// Controls to generate ACKs from units that are external to this module
generate
if (FEATURE_DMMU!="NONE") begin : dmmu_ctrl
   assign spr_access_ack[`OR1K_SPR_DMMU_BASE] = spr_bus_ack_dmmu_i &
                                                spr_access[`OR1K_SPR_DMMU_BASE];
   assign spr_internal_read_dat[`OR1K_SPR_DMMU_BASE] =
     spr_bus_dat_dmmu_i &
     {OPTION_OPERAND_WIDTH{spr_access[`OR1K_SPR_DMMU_BASE]}};
end else begin
   assign spr_access_ack[`OR1K_SPR_DMMU_BASE] = 0;
   assign spr_internal_read_dat[`OR1K_SPR_DMMU_BASE] = 0;
end
endgenerate

generate
if (FEATURE_IMMU!="NONE") begin : immu_ctrl
   assign spr_access_ack[`OR1K_SPR_IMMU_BASE] = spr_bus_ack_immu_i &
                                                spr_access[`OR1K_SPR_IMMU_BASE];
   assign spr_internal_read_dat[`OR1K_SPR_IMMU_BASE] =
     spr_bus_dat_immu_i &
     {OPTION_OPERAND_WIDTH{spr_access[`OR1K_SPR_IMMU_BASE]}};
end else begin
   assign spr_access_ack[`OR1K_SPR_IMMU_BASE] = 0;
   assign spr_internal_read_dat[`OR1K_SPR_IMMU_BASE] = 0;
end
endgenerate

generate
if (FEATURE_DATACACHE!="NONE") begin : datacache_ctrl
   assign spr_access_ack[`OR1K_SPR_DC_BASE] = spr_bus_ack_dc_i &
                                              spr_access[`OR1K_SPR_DC_BASE];
   assign spr_internal_read_dat[`OR1K_SPR_DC_BASE] =
     spr_bus_dat_dc_i & {OPTION_OPERAND_WIDTH{spr_access[`OR1K_SPR_DC_BASE]}};
end else begin
   assign spr_access_ack[`OR1K_SPR_DC_BASE] = 0;
   assign spr_internal_read_dat[`OR1K_SPR_DC_BASE] = 0;
end
endgenerate

generate
if (FEATURE_INSTRUCTIONCACHE!="NONE") begin : instructioncache_ctrl
   assign spr_access_ack[`OR1K_SPR_IC_BASE] = spr_bus_ack_ic_i &
                                              spr_access[`OR1K_SPR_IC_BASE];
   assign spr_internal_read_dat[`OR1K_SPR_IC_BASE] =
     spr_bus_dat_ic_i & {OPTION_OPERAND_WIDTH{spr_access[`OR1K_SPR_IC_BASE]}};
end else begin
   assign spr_access_ack[`OR1K_SPR_IC_BASE] = 0;
   assign spr_internal_read_dat[`OR1K_SPR_IC_BASE] = 0;
end
endgenerate

generate
if (FEATURE_MAC!="NONE") begin : mac_ctrl
   assign spr_access_ack[`OR1K_SPR_MAC_BASE] = spr_bus_ack_mac_i &
                                               spr_access[`OR1K_SPR_MAC_BASE];
   assign spr_internal_read_dat[`OR1K_SPR_MAC_BASE] =
      spr_bus_dat_mac_i &
      {OPTION_OPERAND_WIDTH{spr_access[`OR1K_SPR_MAC_BASE]}};
end else begin
   assign spr_access_ack[`OR1K_SPR_MAC_BASE] = 0;
   assign spr_internal_read_dat[`OR1K_SPR_MAC_BASE] = 0;
end
endgenerate

generate
if (FEATURE_PMU!="NONE") begin : pmu_ctrl
   assign spr_access_ack[`OR1K_SPR_PM_BASE] = spr_bus_ack_pmu_i &
                                              spr_access[`OR1K_SPR_PM_BASE];
   assign spr_internal_read_dat[`OR1K_SPR_PM_BASE] =
     spr_bus_dat_pmu_i & {OPTION_OPERAND_WIDTH{spr_access[`OR1K_SPR_PM_BASE]}};
end else begin
   assign spr_access_ack[`OR1K_SPR_PM_BASE] = 0;
   assign spr_internal_read_dat[`OR1K_SPR_PM_BASE] = 0;
end
endgenerate

generate
if (FEATURE_FPU!="NONE") begin : fpu_ctrl
   assign spr_access_ack[`OR1K_SPR_FPU_BASE] = spr_bus_ack_fpu_i;
   assign spr_internal_read_dat[`OR1K_SPR_FPU_BASE] =
     spr_bus_dat_fpu_i &
     {OPTION_OPERAND_WIDTH{spr_access[`OR1K_SPR_FPU_BASE]}};
end else begin
   assign spr_access_ack[`OR1K_SPR_FPU_BASE] = 0;
   assign spr_internal_read_dat[`OR1K_SPR_FPU_BASE] = 0;
end
endgenerate


/*-----------------Formal Checking-------------------*/

`ifdef FORMAL

`ifdef CTRL
`define ASSUME assume
`else
`define ASSUME assert
`endif

   reg f_past_valid = 0;
   initial f_past_valid = 0;
   initial assume(rst);

   always @(posedge clk)
      f_past_valid <= 1;

   always @(*)
      if (!f_past_valid)
         assume (rst);

   always @(posedge clk)
      if (f_past_valid && !$past(rst) && $past(padv_execute_o))
         `ASSUME ($onehot0({ctrl_op_mfspr_i, ctrl_op_mtspr_i}));

//--------------Assertions----------------

   //Ctrl always advances after execute stage
   always @(posedge clk)
      if (f_past_valid && $rose(padv_ctrl_o) && !$past(rst))
         assert ($past(padv_execute_o));

   //Execute stage bubbles are passed to ctrl stage
   always @(posedge clk)
      if (f_past_valid && !$past(rst) && $rose(ctrl_bubble_o))
         assert ($past(execute_bubble_i));

`ifndef CTRL
   //SPR shouldn't give more than one acknowledgement
   always @*
      assert ($onehot0(spr_access_ack));
`endif

   //Insn mfspr should always read from spr and
   //insn mtspr should always write to spr.
   always @*
      if (ctrl_op_mfspr_i)
          assert (spr_read_access);
      else if (ctrl_op_mtspr_i)
          assert (spr_write_access);

/* Issue #135: Both spr read and write access stays high when debug unit is
   enabled.
   always @*
      assert ($onehot0({spr_read_access, spr_write_access}));

   always @*
     if (spr_bus_stb_o && spr_read_access)
         assert (!spr_bus_we_o);*/

   //Issue 136: Without spr instruction spr_access should be 0.
   /*always @(posedge clk)
      if (f_past_valid & !ctrl_op_mfspr_i & !ctrl_op_mtspr_i & !$past(rst))
         assert (|spr_access == 0);*/

   always @*
      if (spr_bus_we_o)
         assert (spr_we);

   always @(posedge clk) begin
      if (f_past_valid && !$past(rst) && $past(exception_re)) begin
         assert (spr_sr[`OR1K_SPR_SR_SM]);
         if (FEATURE_IMMU == "ENABLED")
            assert (!spr_sr[`OR1K_SPR_SR_IME]);
         if (FEATURE_DMMU == "ENABLED")
            assert (!spr_sr[`OR1K_SPR_SR_DME]);
         if (FEATURE_TIMER == "ENABLED")
            assert (!spr_sr[`OR1K_SPR_SR_TEE]);
         if (FEATURE_PIC == "ENABLED")
            assert (!spr_sr[`OR1K_SPR_SR_IEE]);
         if (FEATURE_DSX == "ENABLED")
            assert (spr_sr[`OR1K_SPR_SR_DSX] == $past(ctrl_delay_slot));
         if (FEATURE_OVERFLOW== "ENABLED")
            assert (!spr_sr[`OR1K_SPR_SR_OVE]);
      end
   end

   always @*
      if (ctrl_branch_exception_o)
         assert (!exception_taken);

   reg f_exception = 0;
   initial f_exception = 0;

   //Excpetion taken should remain high only for one clock cycle.
   always @(posedge clk) begin
      if (f_past_valid && !$past(rst) && exception_taken) begin
         assert ($changed(exception_taken));
         f_exception <= 1;
      end
      if (f_past_valid && $rose(f_exception) && !$past(rst))
         assert ($fell(exception_taken));
   end

   //spr_ppc should be stable before pipeline advances to ctrl stage
   always @(posedge clk `OR_ASYNC_RST)
      if (f_past_valid && !$past(rst) && !$past(padv_ctrl))
         assert ($stable(spr_ppc));
      else if (f_past_valid && !$past(rst) && $past(padv_ctrl))
         assert (spr_ppc == $past(pc_ctrl_i));

   always @*
      //Don't advance execute if exception occurs
      if (exception_re)
         assert (!padv_execute_o);

   //Assertions on flags and carry
   always @* begin
      assert (!atomic_flag_set_i | !ctrl_flag_set_i || ctrl_flag_o);
      assert (!ctrl_carry_set_i || ctrl_carry_o);
   end

   //PC has to be stable before it's advanced to pipeline execute stage
   always @(posedge clk)
      if (f_past_valid && !$past(rst) && !$past(padv_execute_o))
         assert ($stable(last_branch_insn_pc));

   //Branch target pc is expected to be unchange, if pipeline haven't moved.
   always @(posedge clk)
      if (f_past_valid && !$past(rst) && !$past(padv_execute_o)
          && !$past(padv_decode_o))
         assert ($stable(last_branch_target_pc));

   //Waits for fetch only if fetch delayed to output valid bit
   always @(posedge clk)
      if (f_past_valid && !$past(rst) && $rose(waiting_for_fetch))
         assert (!$past(fetch_valid_i));

   //Return from exception assertion
   always @*
      if (doing_rfe_o)
         assert (!deassert_doing_rfe);

   //Supervision register must be stable if there is no exceptions, or spr write.
   always @(posedge clk)
      if (f_past_valid && !$past(rst) && !$past(exception_re) && !$past(spr_we)
          && !$past(du_access) && !$past(padv_ctrl))
         assert ($stable(spr_sr));

   //Exception SR remain unchanged if there is no exception or spr write.
   always @(posedge clk)
      if (f_past_valid && !$past(rst) && !$past(exception_re) && !$past(spr_we))
         assert ($stable(spr_esr));

   //Exception PC
   always @(posedge clk) begin
      if (f_past_valid && !$past(rst) && !$past(exception_re) &&
          !$past(except_ibus_err_i) && !$past(except_syscall_i) &&
          !$past(store_buffer_err_i) && !$past(stall_on_trap) && !$past(spr_we))
         assert ($stable(spr_epcr));
      if (f_past_valid && !$past(rst) && $past(exception_re)  &&
          !$past(except_ibus_err_i) && $past(except_syscall_i) &&
          !$past(ctrl_delay_slot))
         assert (spr_epcr == $past(pc_ctrl_i) + 4);
   end

   always @(posedge clk) begin
      if (f_past_valid && !$past(rst) && !$past(exception_re))
         assert ($stable(spr_eear));
      if (f_past_valid && !$past(rst) && $past(exception_re)) begin
         if ($past(except_ibus_err_i) | $past(except_itlb_miss_i)
             | $past(except_ipagefault_i))
            assert (spr_eear == $past(pc_ctrl_i));
         else
            assert (spr_eear == $past(ctrl_lsu_adr_i));
      end
   end

   always @(posedge clk)
      if (f_past_valid && !($past(du_npc_write) || $past(du_npc_written)
          || $past(stepping) || ($past(stall_on_trap) & $past(padv_ctrl)
          & $past(except_trap_i)) || ($past(padv_ctrl) & $past(cpu_stall))
          || !$past(cpu_stall) || $past(rst)))
         assert ($stable(spr_npc));

   always @(posedge clk)
      if (f_past_valid && !$past(rst) && !$past(spr_we))
         assert ($stable(spr_evbar));

   always @(posedge clk)
      if (f_past_valid && !$past(rst) && !$past(padv_execute_o))
         assert ($stable(execute_delay_slot) && $stable(execute_delay_slot));

//----------------Debug Interface Assertions---------------

   reg f_debug = 0;
   initial f_debug = 0;

   //Debug ack should be high only for one clock cycle
   always @(posedge clk) begin
      if (f_past_valid && du_ack_o && $past(spr_ack)) begin
         assert ($changed(du_ack_o));
         f_debug <= 1;
      end
      if (f_past_valid && $rose(f_debug) && !$past(rst))
         assert ($fell(du_ack_o));
   end

   always @(posedge clk)
      if (f_past_valid && !$past(rst) && !$past(du_stall_i) && $fell(cpu_stall))
         assert ($past(cpu_stall));

   always @(posedge clk)
      if (f_past_valid && (du_restart_from_stall | du_restart_o))
         assert ($fell(du_stall_i));

   always @(*)
      if (du_stb_i && FEATURE_DEBUGUNIT != "NONE")
         assert (du_access);

   always @(posedge clk)
      if (f_past_valid && !$past(rst)  && $past(du_npc_write) && !$past(du_restart_o))
         assert (du_npc_written);

   always @(posedge clk)
      if (f_past_valid && !$past(rst) && $past(du_restart_o))
         assert (!stepped_into_rfe && !du_npc_written && !stepped_into_exception);

   always @*
      assert (stall_on_trap == spr_dsr[`OR1K_SPR_DSR_TE]);

`endif
endmodule // mor1kx_ctrl_cappuccino
