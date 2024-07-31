/* ****************************************************************************
  SPDX-License-Identifier: CERN-OHL-W-2.0

  Description: mor1kx espresso pipeline control unit

  inputs from execute stage

  generate pipeline controls

  manage SPRs

  issue addresses for exceptions to fetch stage
  control branches going to fetch stage

  contains tick timer

  contains PIC logic

  Copyright (C) 2012 Authors

  Author(s): Julius Baxter <juliusbaxter@gmail.com>

***************************************************************************** */

`include "mor1kx-defines.v"

module mor1kx_ctrl_espresso
  (/*AUTOARG*/
   // Outputs
   flag_o, spr_npc_o, spr_ppc_o, mfspr_dat_o, ctrl_mfspr_we_o,
   carry_o, pipeline_flush_o, padv_fetch_o, padv_decode_o,
   padv_execute_o, fetch_take_exception_branch_o, exception_taken_o,
   execute_waiting_o, stepping_o, du_dat_o, du_ack_o, du_stall_o,
   du_restart_pc_o, du_restart_o, spr_bus_addr_o, spr_bus_we_o,
   spr_bus_stb_o, spr_bus_dat_o, spr_sr_o, ctrl_branch_target_o,
   ctrl_branch_occur_o, rf_we_o,
   // Inputs
   clk, rst, ctrl_alu_result_i, ctrl_rfb_i, ctrl_flag_set_i,
   ctrl_flag_clear_i, ctrl_opc_insn_i, pc_fetch_i, fetch_advancing_i,
   except_ibus_err_i, except_illegal_i, except_syscall_i,
   except_dbus_i, except_trap_i, except_align_i, next_fetch_done_i,
   alu_valid_i, lsu_valid_i, op_lsu_load_i, op_lsu_store_i, op_jr_i,
   op_jbr_i, irq_i, carry_set_i, carry_clear_i, overflow_set_i,
   overflow_clear_i, du_addr_i, du_stb_i, du_dat_i, du_we_i,
   du_stall_i, spr_bus_dat_dc_i, spr_bus_ack_dc_i, spr_bus_dat_ic_i,
   spr_bus_ack_ic_i, spr_bus_dat_dmmu_i, spr_bus_ack_dmmu_i,
   spr_bus_dat_immu_i, spr_bus_ack_immu_i, spr_bus_dat_mac_i,
   spr_bus_ack_mac_i, spr_bus_dat_pmu_i, spr_bus_ack_pmu_i,
   spr_bus_dat_pcu_i, spr_bus_ack_pcu_i, spr_bus_dat_fpu_i,
   spr_bus_ack_fpu_i, multicore_coreid_i, rf_wb_i
   );

   parameter OPTION_OPERAND_WIDTH       = 32;
   parameter OPTION_RESET_PC            = {{(OPTION_OPERAND_WIDTH-13){1'b0}},
                                `OR1K_RESET_VECTOR,8'd0};

   parameter FEATURE_SYSCALL            = "ENABLED";
   parameter FEATURE_TRAP               = "ENABLED";
   parameter FEATURE_RANGE              = "ENABLED";

   parameter FEATURE_DATACACHE          = "NONE";
   parameter OPTION_DCACHE_BLOCK_WIDTH  = 5;
   parameter OPTION_DCACHE_SET_WIDTH    = 9;
   parameter OPTION_DCACHE_WAYS         = 2;
   parameter FEATURE_DMMU               = "NONE";
   parameter FEATURE_INSTRUCTIONCACHE   = "NONE";
   parameter OPTION_ICACHE_BLOCK_WIDTH  = 5;
   parameter OPTION_ICACHE_SET_WIDTH    = 9;
   parameter OPTION_ICACHE_WAYS         = 2;
   parameter FEATURE_IMMU               = "NONE";
   parameter FEATURE_TIMER              = "ENABLED";
   parameter FEATURE_DEBUGUNIT          = "NONE";
   parameter FEATURE_PERFCOUNTERS       = "NONE";
   parameter FEATURE_PMU                = "NONE";
   parameter FEATURE_MAC                = "NONE";
   parameter FEATURE_FPU                = "NONE";

   parameter FEATURE_MULTICORE          = "NONE";

   parameter FEATURE_PIC                = "ENABLED";
   parameter OPTION_PIC_TRIGGER         = "LEVEL";
   parameter OPTION_PIC_NMI_WIDTH       = 0;

   parameter FEATURE_DSX                = "NONE";
   parameter FEATURE_FASTCONTEXTS       = "NONE";
   parameter FEATURE_OVERFLOW           = "NONE";

   parameter SPR_SR_WIDTH               = 16;
   parameter SPR_SR_RESET_VALUE         = 16'h8001;

   input clk, rst;

   // ALU result - either jump target, SPR address
   input [OPTION_OPERAND_WIDTH-1:0] ctrl_alu_result_i;

   // Operand B from RF might be jump address, might be value for SPR
   input [OPTION_OPERAND_WIDTH-1:0] ctrl_rfb_i;

   input                            ctrl_flag_set_i, ctrl_flag_clear_i;
   output                           flag_o;

   output [OPTION_OPERAND_WIDTH-1:0] spr_npc_o;
   output [OPTION_OPERAND_WIDTH-1:0] spr_ppc_o;

   input [`OR1K_OPCODE_WIDTH-1:0]   ctrl_opc_insn_i;

   // PC of execute stage (NPC)
   input [OPTION_OPERAND_WIDTH-1:0] pc_fetch_i;
   input                            fetch_advancing_i;


   // Exception inputs, registered on output of execute stage
   input                            except_ibus_err_i,
                                    except_illegal_i,
                                    except_syscall_i, except_dbus_i,
                                    except_trap_i, except_align_i;

   // Inputs from two units that can stall proceedings
   input                            next_fetch_done_i;

   input                            alu_valid_i, lsu_valid_i;

   input                            op_lsu_load_i, op_lsu_store_i;
   input                            op_jr_i, op_jbr_i;

   // External IRQ lines in
   input [31:0]                     irq_i;

   // SPR data out
   output [OPTION_OPERAND_WIDTH-1:0] mfspr_dat_o;

   // WE to RF for l.mfspr
   output                            ctrl_mfspr_we_o;

   // Flag out to branch control, combinatorial
   reg                               flag;

   // Arithmetic flags to and from ALU
   output 			     carry_o;
   input 			     carry_set_i;
   input 			     carry_clear_i;
   input 			     overflow_set_i;
   input 			     overflow_clear_i;

   // Branch indicator from control unit (l.rfe/exception)
   wire                              ctrl_branch_exception;
   // PC out to fetch stage for l.rfe, exceptions
   wire [OPTION_OPERAND_WIDTH-1:0] ctrl_branch_except_pc;

   // Clear instructions from decode and fetch stage
   output                            pipeline_flush_o;

   output                            padv_fetch_o;
   output                            padv_decode_o;
   output                            padv_execute_o;

   // This indicates to the fetch unit only that it should basically interrupt
   // whatever it's doing and start fetching the exception
   output                            fetch_take_exception_branch_o;
   // This indicates to other parts of the CPU that we've handled an excption
   // so can be used to clear exception indication registers
   output                            exception_taken_o;

   output                            execute_waiting_o;
   output                            stepping_o;

   // Debug bus
   input [15:0]                      du_addr_i;
   input                             du_stb_i;
   input [OPTION_OPERAND_WIDTH-1:0]  du_dat_i;
   input                             du_we_i;
   output [OPTION_OPERAND_WIDTH-1:0] du_dat_o;
   output                            du_ack_o;
   // Stall control from debug interface
   input                             du_stall_i;
   output                            du_stall_o;
   output [OPTION_OPERAND_WIDTH-1:0] du_restart_pc_o;
   output                            du_restart_o;

   // SPR accesses to external units (cache, mmu, etc.)
   output [15:0]                     spr_bus_addr_o;
   output                            spr_bus_we_o;
   output                            spr_bus_stb_o;
   output [OPTION_OPERAND_WIDTH-1:0] spr_bus_dat_o;
   input [OPTION_OPERAND_WIDTH-1:0]  spr_bus_dat_dc_i;
   input                             spr_bus_ack_dc_i;
   input [OPTION_OPERAND_WIDTH-1:0]  spr_bus_dat_ic_i;
   input                             spr_bus_ack_ic_i;
   input [OPTION_OPERAND_WIDTH-1:0]  spr_bus_dat_dmmu_i;
   input                             spr_bus_ack_dmmu_i;
   input [OPTION_OPERAND_WIDTH-1:0]  spr_bus_dat_immu_i;
   input                             spr_bus_ack_immu_i;
   input [OPTION_OPERAND_WIDTH-1:0]  spr_bus_dat_mac_i;
   input                             spr_bus_ack_mac_i;
   input [OPTION_OPERAND_WIDTH-1:0]  spr_bus_dat_pmu_i;
   input                             spr_bus_ack_pmu_i;
   input [OPTION_OPERAND_WIDTH-1:0]  spr_bus_dat_pcu_i;
   input                             spr_bus_ack_pcu_i;
   input [OPTION_OPERAND_WIDTH-1:0]  spr_bus_dat_fpu_i;
   input                             spr_bus_ack_fpu_i;
   output [15:0]             spr_sr_o;

   // The multicore core identifier
   input [OPTION_OPERAND_WIDTH-1:0] multicore_coreid_i;

   // Internal signals
   reg [SPR_SR_WIDTH-1:0]            spr_sr;
   reg [SPR_SR_WIDTH-1:0]            spr_esr;
   reg [OPTION_OPERAND_WIDTH-1:0]    spr_epcr;
   reg [OPTION_OPERAND_WIDTH-1:0]    spr_eear;

   // Programmable Interrupt Control SPRs
   wire [31:0] 			     spr_picmr;
   wire [31:0] 			     spr_picsr;

   // Tick Timer SPRs
   wire [31:0]                       spr_ttmr;
   wire [31:0]                       spr_ttcr;

   reg [OPTION_OPERAND_WIDTH-1:0]    spr_ppc;
   reg [OPTION_OPERAND_WIDTH-1:0]    spr_npc;
   reg                               execute_delay_slot;
   reg                               delay_slot_rf_we_done;

   output [OPTION_OPERAND_WIDTH-1:0] ctrl_branch_target_o;

   reg                               execute_go;
   wire                              execute_done;

   reg                               execute_waiting_r;

   reg                               decode_execute_halt;

   reg                               exception_taken;

   reg [OPTION_OPERAND_WIDTH-1:0]    last_branch_insn_pc;
   reg [OPTION_OPERAND_WIDTH-1:0]    last_branch_target_pc;

   reg                               take_exception;
   reg                               exception_r;

   reg [OPTION_OPERAND_WIDTH-1:0]    exception_pc_addr;

   reg                               waiting_for_fetch;
   reg                               branched_and_waiting_for_fetch;

   reg                               doing_rfe_r;
   wire                              doing_rfe;
   wire                              deassert_doing_rfe;

   wire                              exception, exception_pending;

   wire                              execute_stage_exceptions;
   wire                              decode_stage_exceptions;

   wire                              exception_re;

   wire                              except_ticktimer;
   wire                              except_pic;

   wire                              except_ticktimer_nonsrmasked;
   wire                              except_pic_nonsrmasked;

   wire 			     except_range;

   wire [15:0]                       spr_addr;

   wire                              op_mtspr;
   wire                              op_mfspr;
   wire                              op_rfe;

   wire [OPTION_OPERAND_WIDTH-1:0]   b;

   wire                              execute_waiting;

   wire                              execute_valid;

   wire                              deassert_decode_execute_halt;

   wire                              ctrl_branch_occur;
   wire                              new_branch;
   output                            ctrl_branch_occur_o;
   output                            rf_we_o;
   input                             rf_wb_i;
   wire                              except_ibus_align;
   wire                              fetch_advance;
   wire                              rfete;
   wire 			     stall_on_trap;

   /* Debug SPRs */
   reg [31:0]                        spr_dmr1;
   reg [31:0]                        spr_dmr2;
   reg [31:0]                        spr_dsr;
   reg [31:0]                        spr_drr;

   /* DU internal control signals */
   wire                              du_access;
   wire                              cpu_stall;
   wire                              du_restart_from_stall;
   wire [1:0]                        pstep;
   wire                              stepping;
   wire                              stepped_into_delay_slot;
   wire                              du_npc_write;
   reg                               du_npc_written;
   reg [OPTION_OPERAND_WIDTH-1:0]    du_spr_npc;

   /* Wires for SPR management */
   wire                              spr_group_present;
   wire [3:0]                        spr_group;
   wire                              spr_we;
   wire                              spr_read;
   wire [OPTION_OPERAND_WIDTH-1:0]   spr_write_dat;
   wire [11:0]                       spr_access_ack;
   wire [31:0]                       spr_internal_read_dat [0:12];
   wire                              spr_read_access;
   wire                              spr_write_access;
   wire                              spr_bus_access;
   reg [OPTION_OPERAND_WIDTH-1:0]    spr_sys_group_read;

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
   wire [31:0] 			     spr_fpcsr = 0;
   wire [31:0] 			     spr_isr [0:7];

   assign b = ctrl_rfb_i;

   assign ctrl_branch_exception = (exception_r | (op_rfe | doing_rfe)) &
                                  !exception_taken;
   assign exception_pending = (except_ibus_err_i | except_ibus_align |
                               except_illegal_i | except_syscall_i |
                               except_dbus_i | except_align_i |
                               except_ticktimer | except_range |
                               except_pic | except_trap_i );

   assign exception = exception_pending;

   assign fetch_take_exception_branch_o =  (take_exception | op_rfe) &
                                           !stepping;

   assign execute_stage_exceptions = except_dbus_i | except_align_i |
				     except_range;
   assign decode_stage_exceptions = except_trap_i | except_illegal_i;

   assign exception_re = exception & !exception_r & !exception_taken;

   assign deassert_decode_execute_halt = ctrl_branch_occur &
                                         decode_execute_halt;

   assign ctrl_branch_except_pc = (op_rfe | doing_rfe) & !rfete ? spr_epcr :
                                  exception_pc_addr;

   // Exceptions take precedence
   assign ctrl_branch_occur = // instruction is branch, and flag is right
                              (op_jbr_i &
                               // is l.j or l.jal
                               (!(|ctrl_opc_insn_i[2:1]) |
                                // is l.bf/bnf and flag is right
                                (ctrl_opc_insn_i[2]==flag))) |
                              (op_jr_i & !(except_ibus_align));

   assign ctrl_branch_occur_o = // Usual branch signaling
                                ((ctrl_branch_occur | ctrl_branch_exception) &
                                fetch_advance) |
                                // Need to tell the fetch stage to branch
                                // when it gets the next instruction because
                                // there was fetch stalls between the branch
                                // and the delay slot insn
                                (execute_delay_slot);

   assign ctrl_branch_target_o = ctrl_branch_exception ?
                                 ctrl_branch_except_pc :
                                 // jump or branch?
                                 op_jbr_i ? ctrl_alu_result_i :
                                 ctrl_rfb_i;

   // Do writeback when we register our output to the next stage, or if
   // we're doing mfspr
   assign rf_we_o = (execute_done & !delay_slot_rf_we_done) &
                    ((rf_wb_i & !op_mfspr
                      & !((op_lsu_load_i | op_lsu_store_i) &
                          except_dbus_i | except_align_i)) |
                     (op_mfspr));

   assign except_range = (FEATURE_RANGE!="NONE") ? spr_sr[`OR1K_SPR_SR_OVE] &&
			 (spr_sr[`OR1K_SPR_SR_OV] | overflow_set_i & 
			  execute_done)  & !doing_rfe : 0;

   // Check for unaligned jump address from register
   assign except_ibus_align = op_jr_i & (|ctrl_rfb_i[1:0]);

   // Return from exception to exception (if pending tick or PIC ints)
   assign rfete = (spr_esr[`OR1K_SPR_SR_IEE] & except_pic_nonsrmasked) |
                  (spr_esr[`OR1K_SPR_SR_TEE] & except_ticktimer_nonsrmasked);

   always @(posedge clk)
     if (rst)
       exception_pc_addr <= OPTION_RESET_PC;
     else if (exception_re | (rfete & execute_done))
       casez(
             {except_ibus_err_i,
              except_illegal_i,
              except_align_i,
              except_ibus_align,
              except_syscall_i,
              except_trap_i,
              except_dbus_i,
              except_range,
              except_pic_nonsrmasked,
              except_ticktimer_nonsrmasked
              }
             )
         10'b1?????????:
           exception_pc_addr <= {19'd0,`OR1K_BERR_VECTOR,8'd0};
         10'b01????????:
           exception_pc_addr <= {19'd0,`OR1K_ILLEGAL_VECTOR,8'd0};
         10'b001???????,
           10'b0001??????:
             exception_pc_addr <= {19'd0,`OR1K_ALIGN_VECTOR,8'd0};
         10'b00001?????:
           exception_pc_addr <= {19'd0,`OR1K_SYSCALL_VECTOR,8'd0};
         10'b000001????:
           exception_pc_addr <= {19'd0,`OR1K_TRAP_VECTOR,8'd0};
         10'b0000001???:
           exception_pc_addr <= {19'd0,`OR1K_BERR_VECTOR,8'd0};
         10'b00000001??:
           exception_pc_addr <= {19'd0,`OR1K_RANGE_VECTOR,8'd0};
         10'b000000001?:
           exception_pc_addr <= {19'd0,`OR1K_INT_VECTOR,8'd0};
         //10'b0000000001:
         default:
           exception_pc_addr <= {19'd0,`OR1K_TT_VECTOR,8'd0};
       endcase // casex (...

   assign op_mtspr = ctrl_opc_insn_i==`OR1K_OPCODE_MTSPR;
   assign op_mfspr = ctrl_opc_insn_i==`OR1K_OPCODE_MFSPR;
   assign op_rfe = ctrl_opc_insn_i==`OR1K_OPCODE_RFE;

   reg                               waiting_for_except_fetch;
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       waiting_for_except_fetch <= 0;
     else if (waiting_for_except_fetch & next_fetch_done_i)
       waiting_for_except_fetch <= 0;
     else if (fetch_take_exception_branch_o)
       waiting_for_except_fetch <= 1;

   assign fetch_advance = (next_fetch_done_i | except_ibus_err_i) &
                          !execute_waiting & !cpu_stall &
                          (!stepping |
                           (stepping & pstep[0] & !next_fetch_done_i));

   assign padv_fetch_o = fetch_advance & !exception_pending & !doing_rfe_r &
                         !cpu_stall;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       take_exception <= 0;
     else
       take_exception <= (exception_pending | exception_r) &
                         (fetch_advance |
                          // Cause exception to always be 'taken' if stepping
                          (stepping & execute_done)
                          ) &
                         // Would like this as only a single pulse
                         !take_exception;

   reg                               padv_decode_r;
   // Some bits of the pipeline (execute_alu for instance) require a falling
   // edge of the decode signal to start work on multi-cycle ops.
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       padv_decode_r <= 0;
     else
       padv_decode_r <= padv_fetch_o;

   assign padv_decode_o = padv_decode_r;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       execute_go <= 0;
     else
       execute_go <= padv_fetch_o | execute_waiting |
                     (stepping & next_fetch_done_i);

   assign execute_done = execute_go & !execute_waiting;

   // ALU or LSU stall execution, nothing else can
   assign execute_valid = !((op_lsu_load_i | op_lsu_store_i) & !lsu_valid_i |
			    !alu_valid_i);

   assign execute_waiting = !execute_valid & !waiting_for_fetch;
   assign execute_waiting_o = execute_waiting;


   assign padv_execute_o = execute_done;

   assign spr_addr = du_access ? du_addr_i : ctrl_alu_result_i[15:0];
   assign ctrl_mfspr_we_o = op_mfspr & execute_go;

   // Pipeline flush
   assign pipeline_flush_o = (execute_done & op_rfe) |
                             (exception_re) |
                             cpu_stall;

   // Flag
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       flag <= 0;
     else if (execute_done)
       flag <= ctrl_flag_clear_i ? 0 :
               ctrl_flag_set_i ? 1 : flag;

   assign flag_o = flag;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       execute_waiting_r <= 0;
     else if (!execute_waiting)
       execute_waiting_r <= 0;
     else if (execute_waiting)
       execute_waiting_r <= 1;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       decode_execute_halt <= 0;
     else if (du_restart_from_stall)
       decode_execute_halt <= 0;
     else if (decode_execute_halt & deassert_decode_execute_halt)
       decode_execute_halt <= 0;
     else if ((op_rfe | exception) & !decode_execute_halt & !exception_taken)
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
     else if (exception_r & take_exception)
       exception_taken <= 1;

   assign exception_taken_o = exception_taken;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       last_branch_insn_pc <= 0;
     else if (fetch_advance & ctrl_branch_occur)
       last_branch_insn_pc <= spr_ppc;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       last_branch_target_pc <= 0;
     else if (execute_done & ctrl_branch_occur & stepping)
       last_branch_target_pc <= ctrl_branch_target_o;

   // Used to gate execute stage's advance signal in the case where a LSU op has
   // finished before the next instruction has been fetched. Typically this
   // occurs when not using icache and doing lots of memory accesses.
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       waiting_for_fetch <= 0;
     else if (next_fetch_done_i)
       waiting_for_fetch <= 0;
     else if (!execute_waiting & execute_waiting_r & !next_fetch_done_i)
       waiting_for_fetch <= 1;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       branched_and_waiting_for_fetch <= 0;
     else if (exception_re)
       branched_and_waiting_for_fetch <= 0;
     else if (padv_fetch_o & ctrl_branch_occur_o)
       branched_and_waiting_for_fetch <= 1;
     else if (branched_and_waiting_for_fetch)
       branched_and_waiting_for_fetch <= !next_fetch_done_i;



   assign doing_rfe = ((execute_done & op_rfe) | doing_rfe_r) &
                      !deassert_doing_rfe;

   // Basically, the fetch stage should always take the rfe immediately
   assign deassert_doing_rfe =  doing_rfe_r;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       doing_rfe_r <= 0;
     else if (deassert_doing_rfe)
       doing_rfe_r <= 0;
     else if (execute_done)
       doing_rfe_r <= op_rfe;

   assign spr_sr_o = spr_sr;

   // Supervision register
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       spr_sr <= SPR_SR_RESET_VALUE;
     else if (fetch_take_exception_branch_o)
       begin
          if (op_rfe & !rfete)
            begin
               spr_sr <= spr_esr;
            end
          else
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
	       if (FEATURE_OVERFLOW!="NONE")
		 spr_sr[`OR1K_SPR_SR_OVE ] <= 1'b0;
            end
       end
     else if (execute_done)
       begin
	  spr_sr[`OR1K_SPR_SR_F   ] <= ctrl_flag_set_i ? 1 :
				       ctrl_flag_clear_i ? 0 :
				       spr_sr[`OR1K_SPR_SR_F   ];
	  spr_sr[`OR1K_SPR_SR_CY   ] <= carry_set_i ? 1 :
					carry_clear_i ? 0 :
					spr_sr[`OR1K_SPR_SR_CY   ];

	  if (FEATURE_OVERFLOW!="NONE")
	    spr_sr[`OR1K_SPR_SR_OV   ] <= overflow_set_i ? 1 :
				overflow_clear_i ? 0 :
				spr_sr[`OR1K_SPR_SR_OV   ];

	  if ((spr_we & (spr_sr[`OR1K_SPR_SR_SM] | du_access)) &&
              spr_addr==`OR1K_SPR_SR_ADDR)
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

               spr_sr[`OR1K_SPR_SR_CY  ] <= spr_write_dat[`OR1K_SPR_SR_CY  ];

               if (FEATURE_OVERFLOW!="NONE") begin
                  spr_sr[`OR1K_SPR_SR_OV  ] <= spr_write_dat[`OR1K_SPR_SR_OV  ];
                  spr_sr[`OR1K_SPR_SR_OVE ] <= spr_write_dat[`OR1K_SPR_SR_OVE ];
               end

               if (FEATURE_DSX!="NONE")
                 spr_sr[`OR1K_SPR_SR_DSX ] <= spr_write_dat[`OR1K_SPR_SR_DSX ];

               spr_sr[`OR1K_SPR_SR_EPH ] <= spr_write_dat[`OR1K_SPR_SR_EPH ];

            end // if ((spr_we & (spr_sr[`OR1K_SPR_SR_SM] | du_access)) &&...

          /* Need to check for DSX being set on exception entry on execute_done
           as the delay slot information is gone after it goes high */
          if (FEATURE_DSX!="NONE")
            if (exception_r || exception_re)
              spr_sr[`OR1K_SPR_SR_DSX ] <= execute_delay_slot;

       end // if (execute_done)

   assign carry_o = spr_sr[`OR1K_SPR_SR_CY];

   // Exception SR
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       spr_esr <= SPR_SR_RESET_VALUE;
     else if (exception_re)
       begin
          spr_esr <= spr_sr;
          /*
           A bit odd, but if we had a l.sf instruction on an exception rising
           edge, EPCR will point to the insn past the l.sf but the flag will
           not have been saved to the SR properly. So we must put it in here
           so it can be restored correctly.
	   Ditto for the other flags which may have been changed in a similar
	   fashion.
           */
          if (execute_done)
	    begin
               if (ctrl_flag_set_i)
		 spr_esr[`OR1K_SPR_SR_F   ] <= 1'b1;
               else if (ctrl_flag_clear_i)
		 spr_esr[`OR1K_SPR_SR_F   ] <= 1'b0;
	       if (FEATURE_OVERFLOW!="NONE")
		 begin
		    if (overflow_set_i)
		      spr_esr[`OR1K_SPR_SR_OV   ] <= 1'b1;
		    else if (overflow_clear_i)
		      spr_esr[`OR1K_SPR_SR_OV   ] <= 1'b0;
		 end
	       if (carry_set_i)
		 spr_esr[`OR1K_SPR_SR_CY   ] <= 1'b1;
	       else if (carry_clear_i)
		 spr_esr[`OR1K_SPR_SR_CY   ] <= 1'b0;
	    end
       end
     else if (spr_we & spr_addr==`OR1K_SPR_ESR0_ADDR)
       spr_esr <= spr_write_dat[SPR_SR_WIDTH-1:0];

   // Exception PC
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       spr_epcr <= OPTION_RESET_PC;
     else if (exception_re & !(rfete & (op_rfe | deassert_doing_rfe)))
       begin
          if (except_ibus_err_i)
            spr_epcr <= spr_ppc-4;
          else if (except_syscall_i)
            // EPCR after syscall is address of next not executed insn.
            spr_epcr <= spr_npc;
          else if (except_ticktimer | except_pic)
            spr_epcr <= branched_and_waiting_for_fetch ? spr_npc :
			execute_delay_slot ? spr_ppc-4 : spr_ppc+4;
          else if (execute_stage_exceptions |
		   // Don't update EPCR on software breakpoint
		   (decode_stage_exceptions & !(stall_on_trap & except_trap_i)))
            spr_epcr <= execute_delay_slot ? spr_ppc-4 : spr_ppc;
          else if (!(stall_on_trap & except_trap_i))
            spr_epcr <= execute_delay_slot ? spr_ppc-4 : spr_ppc;
       end
     else if (spr_we && spr_addr==`OR1K_SPR_EPCR0_ADDR)
       spr_epcr <= spr_write_dat;

   // Exception Effective Address
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       spr_eear <= {OPTION_OPERAND_WIDTH{1'b0}};
     else if (exception_re)
       begin
          if (except_ibus_err_i)
            spr_eear <= pc_fetch_i;
          else
            spr_eear <= ctrl_alu_result_i;
       end

   // Next PC (NPC)
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       spr_npc <= OPTION_RESET_PC;
     else if (deassert_doing_rfe)
       spr_npc <= rfete ? exception_pc_addr : spr_epcr;
     else if (du_restart_o)
       spr_npc <= du_restart_pc_o;
     else if (stepping & next_fetch_done_i)
       spr_npc <= execute_delay_slot ? last_branch_target_pc : pc_fetch_i;
     else if (stepping & exception_r)
       spr_npc <= exception_pc_addr;
     else if (fetch_advance)
       // PC we're now executing
       spr_npc <= fetch_take_exception_branch_o ? exception_pc_addr :
                  ctrl_branch_occur ? ctrl_branch_target_o : pc_fetch_i;

   // Previous PC (PPC)
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       spr_ppc <= OPTION_RESET_PC;
     else if (padv_fetch_o | (stepping & next_fetch_done_i))
       spr_ppc <= spr_npc; // PC we've got in execute stage (about to finish)

   assign spr_npc_o = spr_npc;
   assign spr_ppc_o = spr_ppc;

   // Remember when we're in a delay slot in execute stage.
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
        execute_delay_slot <= 0;
     else if (execute_done)
       execute_delay_slot <= execute_delay_slot ? 0 :
                             ctrl_branch_occur;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       delay_slot_rf_we_done <= 0;
     else
       delay_slot_rf_we_done <= rf_we_o & execute_delay_slot;

   mor1kx_cfgrs
     #(.FEATURE_PIC			(FEATURE_PIC),
       .FEATURE_TIMER			(FEATURE_TIMER),
       .OPTION_PIC_TRIGGER		(OPTION_PIC_TRIGGER),
       .FEATURE_DSX			(FEATURE_DSX),
       .FEATURE_FASTCONTEXTS		(FEATURE_FASTCONTEXTS),
       .FEATURE_OVERFLOW		(FEATURE_OVERFLOW),
       .FEATURE_DATACACHE		(FEATURE_DATACACHE),
       .OPTION_DCACHE_BLOCK_WIDTH	(OPTION_DCACHE_BLOCK_WIDTH),
       .OPTION_DCACHE_SET_WIDTH		(OPTION_DCACHE_SET_WIDTH),
       .OPTION_DCACHE_WAYS		(OPTION_DCACHE_WAYS),
       .FEATURE_DMMU			(FEATURE_DMMU),
       .FEATURE_INSTRUCTIONCACHE	(FEATURE_INSTRUCTIONCACHE),
       .OPTION_ICACHE_BLOCK_WIDTH	(OPTION_ICACHE_BLOCK_WIDTH),
       .OPTION_ICACHE_SET_WIDTH		(OPTION_ICACHE_SET_WIDTH),
       .OPTION_ICACHE_WAYS		(OPTION_ICACHE_WAYS),
       .FEATURE_IMMU			(FEATURE_IMMU),
       .FEATURE_DEBUGUNIT		(FEATURE_DEBUGUNIT),
       .FEATURE_PERFCOUNTERS		(FEATURE_PERFCOUNTERS),
       .FEATURE_MAC			(FEATURE_MAC),
       .FEATURE_SYSCALL			(FEATURE_SYSCALL),
       .FEATURE_TRAP			(FEATURE_TRAP),
       .FEATURE_RANGE			(FEATURE_RANGE),
       .FEATURE_DELAYSLOT               ("ENABLED")
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
   always @*
     case(spr_addr)
       `OR1K_SPR_VR_ADDR:
         spr_sys_group_read = spr_vr;
       `OR1K_SPR_VR2_ADDR:
	 spr_sys_group_read = {spr_vr2[31:8], `MOR1KX_PIPEID_ESPRESSO};
       `OR1K_SPR_AVR_ADDR:
	 spr_sys_group_read = spr_avr;
       `OR1K_SPR_UPR_ADDR:
         spr_sys_group_read = spr_upr;
       `OR1K_SPR_CPUCFGR_ADDR:
         spr_sys_group_read = spr_cpucfgr;
       `OR1K_SPR_DMMUCFGR_ADDR:
         spr_sys_group_read = spr_dmmucfgr;
       `OR1K_SPR_IMMUCFGR_ADDR:
         spr_sys_group_read = spr_immucfgr;
       `OR1K_SPR_DCCFGR_ADDR:
         spr_sys_group_read = spr_dccfgr;
       `OR1K_SPR_ICCFGR_ADDR:
         spr_sys_group_read = spr_iccfgr;
       `OR1K_SPR_DCFGR_ADDR:
         spr_sys_group_read = spr_dcfgr;
       `OR1K_SPR_PCCFGR_ADDR:
         spr_sys_group_read = spr_pccfgr;
       `OR1K_SPR_NPC_ADDR:
         spr_sys_group_read = spr_npc;
       `OR1K_SPR_SR_ADDR:
         spr_sys_group_read = {{(OPTION_OPERAND_WIDTH-SPR_SR_WIDTH){1'b0}},
                               spr_sr};

       `OR1K_SPR_PPC_ADDR:
         spr_sys_group_read = spr_ppc;
       `OR1K_SPR_FPCSR_ADDR:
         spr_sys_group_read = spr_fpcsr;
       `OR1K_SPR_EPCR0_ADDR:
         spr_sys_group_read = spr_epcr;
       `OR1K_SPR_EEAR0_ADDR:
         spr_sys_group_read = spr_eear;
       `OR1K_SPR_ESR0_ADDR:
         spr_sys_group_read = {{(OPTION_OPERAND_WIDTH-SPR_SR_WIDTH){1'b0}},
                               spr_esr};
       `OR1K_SPR_ISR0_ADDR:
	 spr_sys_group_read = spr_isr[0];
       `OR1K_SPR_ISR0_ADDR +1:
	 spr_sys_group_read = spr_isr[1];
       `OR1K_SPR_ISR0_ADDR +2:
	 spr_sys_group_read = spr_isr[2];
       `OR1K_SPR_ISR0_ADDR +3:
	 spr_sys_group_read = spr_isr[3];
       `OR1K_SPR_ISR0_ADDR +4:
	 spr_sys_group_read = spr_isr[4];
       `OR1K_SPR_ISR0_ADDR +5:
	 spr_sys_group_read = spr_isr[5];
       `OR1K_SPR_ISR0_ADDR +6:
	 spr_sys_group_read = spr_isr[6];
       `OR1K_SPR_ISR0_ADDR +7:
	 spr_sys_group_read = spr_isr[7];

       `OR1K_SPR_COREID_ADDR:
         // If the multicore feature is activated this address returns the
         // core identifier, 0 otherwise
         spr_sys_group_read = (FEATURE_MULTICORE != "NONE") ?
                              multicore_coreid_i : 0;

       default: begin
          /* GPR read */
          if (spr_addr >= `OR1K_SPR_GPR0_ADDR &&
              spr_addr <= (`OR1K_SPR_GPR0_ADDR + 32))
            spr_sys_group_read = b; /* Register file */
          else
            /* Invalid address - read as zero*/
            spr_sys_group_read = 0;
       end
     endcase // case (spr_addr)

   /* System group read data MUX in */
   assign spr_internal_read_dat[0] = spr_sys_group_read;
   /* System group ack generation */
   /* TODO - might be delay for register file reads! */
   assign spr_access_ack[0] = 1;



   /* Generate data to the register file for mfspr operations */
   assign mfspr_dat_o = spr_internal_read_dat[spr_addr[14:11]];

   // PIC SPR control
   generate
      if (FEATURE_PIC !="NONE") begin : pic

	 /* mor1kx_pic AUTO_TEMPLATE (
	  .spr_picsr_o		(spr_picsr),
	  .spr_picmr_o		(spr_picmr),
	  .spr_bus_ack		(spr_access_ack[9]),
	  .spr_dat_o		(spr_internal_read_dat[9]),
	  // Inputs
	  .spr_we_i		(spr_we),
          .spr_access_i         (1'b1),
	  .spr_addr_i		(spr_addr),
	  .spr_dat_i		(spr_write_dat),
	  );*/
	 mor1kx_pic
	  #(
	    .OPTION_PIC_TRIGGER(OPTION_PIC_TRIGGER),
	    .OPTION_PIC_NMI_WIDTH(OPTION_PIC_NMI_WIDTH)
	    )
	 mor1kx_pic
	   (/*AUTOINST*/
	    // Outputs
	    .spr_picmr_o		(spr_picmr),		 // Templated
	    .spr_picsr_o		(spr_picsr),		 // Templated
	    .spr_bus_ack		(spr_access_ack[9]),	 // Templated
	    .spr_dat_o			(spr_internal_read_dat[9]), // Templated
	    // Inputs
	    .clk			(clk),
	    .rst			(rst),
	    .irq_i			(irq_i[31:0]),
	    .spr_access_i		(1'b1),			 // Templated
	    .spr_we_i			(spr_we),		 // Templated
	    .spr_addr_i			(spr_addr),		 // Templated
	    .spr_dat_i			(spr_write_dat));	 // Templated

         assign except_pic_nonsrmasked = (|spr_picsr) &
                             !op_mtspr &
                             // Stops back-to-back branch addresses going to
                             // fetch stage
                             !ctrl_branch_occur &
                             // Stops issues with PC when branching
                             !execute_delay_slot;

         assign except_pic = spr_sr[`OR1K_SPR_SR_IEE] & except_pic_nonsrmasked &
                             !doing_rfe;
      end
      else begin
	 assign except_pic_nonsrmasked = 0;
	 assign except_pic = 0;
	 assign spr_picsr = 0;
	 assign spr_picmr = 0;
	 assign spr_access_ack[9] = 0;
	 assign spr_internal_read_dat[9] = 0;
      end // else: !if(FEATURE_PIC !="NONE")
   endgenerate


   generate
      if (FEATURE_TIMER!="NONE") begin : tt

	 /* mor1kx_ticktimer AUTO_TEMPLATE (
	  .spr_ttmr_o		(spr_ttmr),
	  .spr_ttcr_o		(spr_ttcr),
	  .spr_bus_ack		(spr_access_ack[10]),
	  .spr_dat_o		(spr_internal_read_dat[10]),
	  // Inputs
	  .spr_we_i		(spr_we),
          .spr_access_i         (1'b1),
	  .spr_addr_i		(spr_addr),
	  .spr_dat_i		(spr_write_dat),
	  );*/
	 mor1kx_ticktimer mor1kx_ticktimer
			 (/*AUTOINST*/
			  // Outputs
			  .spr_ttmr_o		(spr_ttmr),	 // Templated
			  .spr_ttcr_o		(spr_ttcr),	 // Templated
			  .spr_bus_ack		(spr_access_ack[10]), // Templated
			  .spr_dat_o		(spr_internal_read_dat[10]), // Templated
			  // Inputs
			  .clk			(clk),
			  .rst			(rst),
			  .spr_access_i		(1'b1),		 // Templated
			  .spr_we_i		(spr_we),	 // Templated
			  .spr_addr_i		(spr_addr),	 // Templated
			  .spr_dat_i		(spr_write_dat)); // Templated

         assign except_ticktimer_nonsrmasked = spr_ttmr[28] &
                                   (!op_mtspr & !(spr_esr[`OR1K_SPR_SR_TEE] & execute_done)) &
                                   // Stops back-to-back branch addresses to
                                   // fetch stage.
                                   !ctrl_branch_occur &
                                   // Stops issues with PC when branching
                                   !execute_delay_slot;

         assign except_ticktimer = except_ticktimer_nonsrmasked &
                                   spr_sr[`OR1K_SPR_SR_TEE] & !doing_rfe;
      end // if (FEATURE_TIMER!="NONE")
      else begin
	 assign except_ticktimer_nonsrmasked = 0;
	 assign except_ticktimer = 0;
	 assign spr_ttmr = 0;
	 assign spr_ttcr = 0;
	 assign spr_access_ack[10] = 0;
	 assign spr_internal_read_dat[10] = 0;
      end // else: !if(FEATURE_TIMER!="NONE")
   endgenerate

   /* SPR access control - allow accesses from either the instructions or from
    the debug interface */
   assign spr_read_access = (op_mfspr | (du_access & !du_we_i));
   assign spr_write_access = ((execute_done & op_mtspr) | (du_access & du_we_i));

   assign spr_write_dat = du_access ? du_dat_i : b;
   assign spr_we = spr_write_access & spr_group_present;
   assign spr_read = spr_read_access & spr_group_present;

   /* A bus out to other units that live outside of the control unit */
   assign spr_bus_addr_o = spr_addr;
   assign spr_bus_we_o = spr_write_access & spr_group_present & spr_bus_access;
   assign spr_bus_stb_o = (spr_read_access | spr_write_access) &
                          spr_group_present & spr_bus_access;
   assign spr_bus_dat_o = spr_write_dat;

   /* Is the SPR in the design? */
   assign spr_group_present = (// System group
                               (spr_addr[15:11]==5'h00) ||
                               // DMMU
                               (spr_addr[15:11]==5'h01 &&
                                FEATURE_DMMU!="NONE") ||
                               // IMMU
                               (spr_addr[15:11]==5'h02 &&
                                FEATURE_IMMU!="NONE") ||
                               // Data cache
                               (spr_addr[15:11]==5'h03 &&
                                FEATURE_DATACACHE!="NONE") ||
                               // Instruction cache
                               (spr_addr[15:11]==5'h04 &&
                                FEATURE_INSTRUCTIONCACHE!= "NONE") ||
                               // MAC unit
                               (spr_addr[15:11]==5'h05 &&
                                FEATURE_MAC!="NONE") ||
                               // Debug unit
                               (spr_addr[15:11]==5'h06 &&
                                FEATURE_DEBUGUNIT!="NONE") ||
                               // Performance counters
                               (spr_addr[15:11]==5'h07 &&
                                FEATURE_PERFCOUNTERS!="NONE") ||
                               // Power Management
                               (spr_addr[15:11]==5'h08 &&
                                FEATURE_PMU!="NONE") ||
                               // PIC
                               (spr_addr[15:11]==5'h09 &&
                                FEATURE_PIC!="NONE") ||
                               // Tick timer
                               (spr_addr[15:11]==5'h0a &&
                                FEATURE_TIMER!="NONE") ||
                               // FPU
                               (spr_addr[15:11]==5'h0b &&
                                FEATURE_FPU!="NONE")
                               );

   /* Generate a SPR group signal - generate invalid if the group is not
    present in the design */
   assign spr_group = (spr_group_present) ? spr_addr[14:11] : 4'd12;

   /* Default group when a selected one is not present - it reads as zero */
   assign spr_internal_read_dat[12] = 0;

   /* Is a SPR bus access needed, or is the requested SPR in this file? */
   assign spr_bus_access = /* Any of the units we don't have in this file */
                           /* System group */
                           !(spr_addr[15:11]==5'h00 ||
                             /* Debug Group */
                             spr_addr[15:11]==5'h06 ||
                             /* PIC Group */
                             spr_addr[15:11]==5'h09 ||
                             /* Tick Group */
                             spr_addr[15:11]==5'h0a);

   assign stepping_o = stepping;

   generate
      if (FEATURE_DEBUGUNIT!="NONE") begin : du

         reg [OPTION_OPERAND_WIDTH-1:0] du_read_dat;

         reg                            du_ack;
         reg                            du_stall_r;
         reg [1:0]                      pstep_r;
         reg [1:0]                      branch_step;
         reg                            stepped_into_exception;
         reg                            stepped_into_rfe;

         assign du_access = du_stb_i;

         // Generate ack back to the debug interface bus
         always @(posedge clk `OR_ASYNC_RST)
           if (rst)
             du_ack <= 0;
           else if (du_ack)
             du_ack <= 0;
           else if (du_stb_i) begin
              if (!spr_group_present)
                /* Unit doesn't exist, ACK to clear the access, nothing done */
                du_ack <= 1;
              else if (spr_access_ack[spr_group])
                /* actual access occurred */
                du_ack <= 1;
           end

         assign du_ack_o = du_ack;

         /* Data back to the debug bus */
         always @(posedge clk `OR_ASYNC_RST)
           if (rst)
             du_read_dat <= 0;
           else if (spr_access_ack[spr_group]) begin
              du_read_dat <= spr_internal_read_dat[spr_group];
           end

         assign du_dat_o = du_read_dat;
         /* TODO: check into only letting stall go high when we've gracefully
          completed the instruction currently in the ctrl stage.
          Why? Potentially an instruction like l.mfspr from an external unit
          hasn't completed fully, gets interrupted, and it's assumed it's
          completed, but actually hasn't. */
         assign cpu_stall = du_stall_i | du_restart_from_stall;

         /* goes out to the debug interface and comes back 1 cycle later
          via du_stall_i */
         assign du_stall_o = (stepping & execute_done)|
			     (stall_on_trap & execute_done & except_trap_i);

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
             du_spr_npc <= 0;
           else if (du_npc_write)
             du_spr_npc <= du_dat_i;

         always @(posedge clk `OR_ASYNC_RST)
           if (rst)
             stepped_into_exception <= 0;
           else if (du_restart_from_stall)
             stepped_into_exception <= 0;
           else if (stepping & execute_done)
             stepped_into_exception <= exception;

         always @(posedge clk `OR_ASYNC_RST)
           if (rst)
             stepped_into_rfe <= 0;
           else if (du_restart_from_stall)
             stepped_into_rfe <= 0;
           else if (stepping & execute_done)
             stepped_into_rfe <= op_rfe;

         assign du_restart_pc_o = du_npc_written ? du_spr_npc :
                                  stepped_into_rfe ? spr_epcr :
                                  stepped_into_delay_slot ?
                                  last_branch_target_pc : spr_npc;

         assign du_restart_o = du_restart_from_stall;

         /* Indicate when we're stepping */
         assign stepping = spr_dmr1[`OR1K_SPR_DMR1_ST] &
                           spr_dsr[`OR1K_SPR_DSR_TE];

         always @(posedge clk `OR_ASYNC_RST)
           if (rst)
             pstep_r <= 0;
           else if (du_restart_from_stall & stepping)
             pstep_r <= 2'd1;
           else if ((pstep[0] & next_fetch_done_i) |
                    /* decode is always single cycle */
                    (pstep[1] & execute_done))
             pstep_r <= {pstep_r[0],1'b0};

         assign pstep = pstep_r;

         always @(posedge clk `OR_ASYNC_RST)
           if (rst)
             branch_step <= 0;
           else if (stepping & pstep[1])
             branch_step <= {branch_step[0], ctrl_branch_occur};
           else if (!stepping & execute_done)
             branch_step <= {branch_step[0], execute_delay_slot};

         assign stepped_into_delay_slot = branch_step[1];

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
         assign spr_access_ack[6] = 1;
         assign spr_internal_read_dat[6] = (spr_addr==`OR1K_SPR_DMR1_ADDR) ?
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
	   else if (stall_on_trap & execute_done & except_trap_i)
	     spr_drr[`OR1K_SPR_DRR_TE] <= 1;

      end // block: du
      else
        begin : no_du
           assign du_access = 0;
           assign cpu_stall = 0;
           assign du_stall_o = 0;
           assign du_ack_o = 0;
           assign du_restart_o = 0;
           assign du_restart_pc_o = 0;
           assign stepping = 0;
           assign du_npc_write = 0;
           assign stepped_into_delay_slot = 0;
           assign du_dat_o = 0;
           assign du_restart_from_stall = 0;
           assign spr_access_ack[6] = 0;

	   always @(posedge clk)
	     begin
		spr_dmr1 <= 0;
		spr_dmr2 <= 0;
		spr_dsr <= 0;
		spr_drr <= 0;
		du_npc_written <= 0;
	     end
        end
   endgenerate

   /* Controls to generate ACKs from units that are external to this module */
   generate
      if (FEATURE_DMMU!="NONE") begin : dmmu_ctrl
         assign spr_access_ack[1] = spr_bus_ack_dmmu_i;
         assign spr_internal_read_dat[1] = spr_bus_dat_dmmu_i;
      end
      else begin
         assign spr_access_ack[1] = 0;
         assign spr_internal_read_dat[1] = 0;
      end
   endgenerate

   generate
      if (FEATURE_IMMU!="NONE") begin : immu_ctrl
         assign spr_access_ack[2] = spr_bus_ack_immu_i;
         assign spr_internal_read_dat[2] = spr_bus_dat_immu_i;
      end
      else begin
         assign spr_access_ack[2] = 0;
         assign spr_internal_read_dat[2] = 0;
      end
   endgenerate

   generate
      if (FEATURE_DATACACHE!="NONE") begin : datacache_ctrl
         assign spr_access_ack[3] = spr_bus_ack_dc_i;
         assign spr_internal_read_dat[3] = spr_bus_dat_dc_i;
      end
      else begin
         assign spr_access_ack[3] = 0;
         assign spr_internal_read_dat[3] = 0;
      end
   endgenerate

   generate
      if (FEATURE_INSTRUCTIONCACHE!="NONE") begin : instructioncache_ctrl
         assign spr_access_ack[4] = spr_bus_ack_ic_i;
         assign spr_internal_read_dat[4] = spr_bus_dat_ic_i;
      end
      else begin
         assign spr_access_ack[4] = 0;
         assign spr_internal_read_dat[4] = 0;
      end
   endgenerate

   generate
      if (FEATURE_MAC!="NONE") begin : mac_ctrl
         assign spr_access_ack[5] = spr_bus_ack_mac_i;
         assign spr_internal_read_dat[5] = spr_bus_dat_mac_i;
      end
      else begin
         assign spr_access_ack[5] = 0;
         assign spr_internal_read_dat[5] = 0;
      end
   endgenerate

   generate
      if (FEATURE_PERFCOUNTERS!="NONE") begin : perfcounters_ctrl
         assign spr_access_ack[7] = spr_bus_ack_pcu_i;
         assign spr_internal_read_dat[7] = spr_bus_dat_pcu_i;
      end
      else begin
         assign spr_access_ack[7] = 0;
         assign spr_internal_read_dat[7] = 0;
      end
   endgenerate

   generate
      if (FEATURE_PMU!="NONE") begin : pmu_ctrl
         assign spr_access_ack[8] = spr_bus_ack_pmu_i;
         assign spr_internal_read_dat[8] = spr_bus_dat_pcu_i;
      end
      else begin
         assign spr_access_ack[8] = 0;
         assign spr_internal_read_dat[8] = 0;
      end
   endgenerate

   generate
      if (FEATURE_FPU!="NONE") begin : fpu_ctrl
         assign spr_access_ack[11] = spr_bus_ack_fpu_i;
         assign spr_internal_read_dat[11] = spr_bus_dat_fpu_i;
      end
      else begin
         assign spr_access_ack[11] = 0;
         assign spr_internal_read_dat[11] = 0;
      end
   endgenerate

endmodule // mor1kx_ctrl_espresso
