/* ****************************************************************************
  SPDX-License-Identifier: CERN-OHL-W-2.0

  Description: mor1kx espresso fetch unit

  Fetch insn, advance PC (or take new branch address) on padv_i.

  What we might want to do is have a 1-insn buffer here, so when the current
  insn is fetched, but the main pipeline doesn't want it yet

  indicate ibus errors

  Copyright (C) 2012 Authors

  Author(s): Julius Baxter <juliusbaxter@gmail.com>

***************************************************************************** */

`include "mor1kx-defines.v"

module mor1kx_fetch_espresso
  (/*AUTOARG*/
   // Outputs
   ibus_adr_o, ibus_req_o, ibus_burst_o, decode_insn_o,
   next_fetch_done_o, fetch_rfa_adr_o, fetch_rfb_adr_o, pc_fetch_o,
   pc_fetch_next_o, decode_except_ibus_err_o, fetch_advancing_o,
   // Inputs
   clk, rst, ibus_err_i, ibus_ack_i, ibus_dat_i, padv_i,
   branch_occur_i, branch_dest_i, du_restart_i, du_restart_pc_i,
   fetch_take_exception_branch_i, execute_waiting_i, du_stall_i,
   stepping_i
   );

   parameter OPTION_OPERAND_WIDTH = 32;
   parameter OPTION_RF_ADDR_WIDTH = 5;
   parameter OPTION_RESET_PC = {{(OPTION_OPERAND_WIDTH-13){1'b0}},
				`OR1K_RESET_VECTOR,8'd0};


   input clk, rst;

   // interface to ibus
   output [OPTION_OPERAND_WIDTH-1:0] ibus_adr_o;
   output 			      ibus_req_o;
   output 			      ibus_burst_o;
   input 			      ibus_err_i;
   input 			      ibus_ack_i;
   input [`OR1K_INSN_WIDTH-1:0]       ibus_dat_i;

   // pipeline control input
   input 			      padv_i;

   // interface to decode unit
   output reg [`OR1K_INSN_WIDTH-1:0] 	 decode_insn_o;
   // Indication to pipeline control that the fetch is valid
   output  				 next_fetch_done_o;

   output [OPTION_RF_ADDR_WIDTH-1:0] 	 fetch_rfa_adr_o;
   output [OPTION_RF_ADDR_WIDTH-1:0] 	 fetch_rfb_adr_o;

   // Signal back to the control
   output [OPTION_OPERAND_WIDTH-1:0] 	 pc_fetch_o;
   output [OPTION_OPERAND_WIDTH-1:0] 	 pc_fetch_next_o;


   // branch/jump indication
   input 				  branch_occur_i;
   input [OPTION_OPERAND_WIDTH-1:0] 	  branch_dest_i;

   // restart signals from debug unit
   input 				  du_restart_i;
   input [OPTION_OPERAND_WIDTH-1:0] 	  du_restart_pc_i;

   input 				  fetch_take_exception_branch_i;

   input 				  execute_waiting_i;

   // CPU is stalled
   input 				  du_stall_i;

   // We're single stepping - this should cause us to fetch only a single insn
   input 				  stepping_i;


   // instruction ibus error indication out
   output reg 				  decode_except_ibus_err_o;

   output 				  fetch_advancing_o;

   // registers
   reg [OPTION_OPERAND_WIDTH-1:0] 	  pc_fetch;
   reg 					  fetch_req;
   reg 					  next_insn_buffered;
   reg [OPTION_OPERAND_WIDTH-1:0] 	  insn_buffer;
   reg 					  branch_occur_r;
   reg 					  bus_access_done_re_r;
   reg 					  advancing_into_branch;
   reg 					  bus_access_done_r;
   reg 					  wait_for_exception_after_ibus_err;

   wire [OPTION_OPERAND_WIDTH-1:0] 	  pc_fetch_next;
   wire 				  bus_access_done;
   wire 				  bus_access_done_fe;
   wire 				  branch_occur_re;
   wire 				  awkward_transition_to_branch_target;
   wire 				  taking_branch;
   wire					  jal_buffered;
   wire 				  retain_fetch_pc;

   assign taking_branch = branch_occur_i & padv_i;

   assign bus_access_done =  (ibus_ack_i | ibus_err_i) & !(taking_branch);

   assign pc_fetch_next = pc_fetch + 4;

   assign ibus_adr_o = pc_fetch;
   assign ibus_req_o = fetch_req;
   assign ibus_burst_o = 0;

   assign fetch_advancing_o = (padv_i | fetch_take_exception_branch_i |
			       stepping_i) &
			      next_fetch_done_o;

   // Early RF address fetch
   assign fetch_rfa_adr_o = insn_buffer[`OR1K_RA_SELECT];
   assign fetch_rfb_adr_o = insn_buffer[`OR1K_RB_SELECT];

   assign jal_buffered = insn_buffer[`OR1K_OPCODE_SELECT]==`OR1K_OPCODE_JALR ||
			 insn_buffer[`OR1K_OPCODE_SELECT]==`OR1K_OPCODE_JAL;

   assign retain_fetch_pc = jal_buffered & bus_access_done;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       pc_fetch <= OPTION_RESET_PC;
     else if (fetch_take_exception_branch_i |
	      (((bus_access_done & !ibus_err_i) | taking_branch) &
	       (!execute_waiting_i | !next_insn_buffered) &
	       !retain_fetch_pc) |
	      awkward_transition_to_branch_target |
	      du_restart_i)
       // next PC - are we going somewhere else or advancing?
       pc_fetch <= du_restart_i ? du_restart_pc_i :
		   (fetch_take_exception_branch_i | taking_branch) ?
		   branch_dest_i : pc_fetch_next;

   // Actually goes to pipeline control
   assign pc_fetch_o = pc_fetch;
   assign pc_fetch_next_o = pc_fetch_next;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       fetch_req <= 1;
     else if (fetch_take_exception_branch_i | du_restart_i)
       fetch_req <= 1;
     else if (padv_i)
       // Force de-assert of req signal when branching.
       // This is to stop (ironically) the case where we've got the
       // instruction we're branching to already coming in on the bus,
       // which we usually don't assume will happen.
       // TODO: fix things so that we don't have to force a penalty to make
       // it work properly.
       fetch_req <= !branch_occur_i & !du_stall_i;
     else if (du_stall_i)
       fetch_req <= fetch_req & !bus_access_done;
     else if (!fetch_req & !execute_waiting_i &
	      !wait_for_exception_after_ibus_err & !retain_fetch_pc &
	      !du_stall_i & !stepping_i)
       fetch_req <= 1;
     else if (bus_access_done & (fetch_take_exception_branch_i |
				 execute_waiting_i | ibus_err_i | stepping_i))
       fetch_req <= 0;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       begin
	  bus_access_done_r <= 0;
	  branch_occur_r <= 0;
       end
     else
       begin
	  bus_access_done_r <= bus_access_done;
	  branch_occur_r <= branch_occur_i;
       end

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       advancing_into_branch <= 0;
     else
       advancing_into_branch <= fetch_advancing_o & branch_occur_i;

   assign next_fetch_done_o = (bus_access_done_r | next_insn_buffered) &
			      // Whenever we've just changed the fetch PC to
			      // take a branch this will gate off any ACKs we
			      // might get (legit or otherwise) from where we're
			      // getting our instructions from (bus/cache).
			      !(advancing_into_branch);

   assign branch_occur_re = branch_occur_i & !branch_occur_r;

   /* When this occurs we had the insn burst stream finish just as we
    had a new branch address requested. Because the control logic will
    immediately continue onto the delay slot instruction, the branch target
    is only valid for 1 cycle. The PC out to the bus/cache will then need
    to change 1 cycle after it requested the insn after the delay slot.
    This is annoying for the bus control/cache logic, but should result in
    less cycles wasted fetching something we don't need, and as well reduce
    the number of flops as we don't need to save the target PC which we had
    for only 1 cycle */
   assign awkward_transition_to_branch_target = branch_occur_re &
						bus_access_done_fe;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       decode_insn_o <= {`OR1K_OPCODE_NOP,26'd0};
     else if (fetch_take_exception_branch_i | (du_stall_i & !execute_waiting_i))
       // Put a NOP in the pipeline when starting exception - remove any state
       // which may be causing the exception
       decode_insn_o <= {`OR1K_OPCODE_NOP,26'd0};
     else if ((padv_i & (
			 bus_access_done_r |
			 bus_access_done |
			 next_insn_buffered
			 ) &
	       !branch_occur_r ) |
	      // This case is when we stalled to get the delay-slot instruction
	      // and we don't get enough padv to push it through the buffer
	      (branch_occur_i & padv_i & bus_access_done_re_r) |
	      (bus_access_done_fe & stepping_i))
       decode_insn_o <= insn_buffer;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       decode_except_ibus_err_o <= 0;
     else if ((padv_i | fetch_take_exception_branch_i) & branch_occur_i |
	      du_stall_i)
       decode_except_ibus_err_o <= 0;
     else if (fetch_req)
       decode_except_ibus_err_o <= ibus_err_i;

   // Register rising edge on bus_access_done
    always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       bus_access_done_re_r <= 0;
     else
       bus_access_done_re_r <= bus_access_done & !bus_access_done_r;

   assign bus_access_done_fe = !bus_access_done & bus_access_done_r;

   /* If insn_buffer contains the next insn we need, save that information
    here */
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       next_insn_buffered <= 0;
     else if (fetch_take_exception_branch_i)
       next_insn_buffered <= 0;
     else if (padv_i)
       // Next instruction is usually buffered when we've got bus ack and
       // pipeline advance, except when we're branching (usually throw
       // away the fetch when branch is being indicated)
       next_insn_buffered <= ibus_ack_i & !branch_occur_i;
     else if (ibus_ack_i & execute_waiting_i)
       next_insn_buffered <= 1;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       insn_buffer <= {`OR1K_OPCODE_NOP,26'd0};
     else if (ibus_ack_i & (!execute_waiting_i | !next_insn_buffered) &
	      // Don't buffer instruction after delay slot instruction
	      // (usually we're receiving it as taking branch is asserted)
	      // it could be another jump instruction and having it in
	      // the insn_buffer has annoying side-effects.
	      !taking_branch)
       insn_buffer <= ibus_dat_i;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       wait_for_exception_after_ibus_err <= 0;
     else if (fetch_take_exception_branch_i)
       wait_for_exception_after_ibus_err <= 0;
     else if (ibus_err_i)
       wait_for_exception_after_ibus_err <= 1;

endmodule // mor1kx_fetch_espresso
