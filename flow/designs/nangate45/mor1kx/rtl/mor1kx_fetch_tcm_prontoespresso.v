/* ****************************************************************************
  SPDX-License-Identifier: CERN-OHL-W-2.0

  Description: mor1kx pronto espresso fetch unit for TCM memories

  This is the fetch unit for the pipeline, so begins at the reset address and,
  in lock-step with the pipeline, provides the instructions according to the
  program flow.

  It is designed to interface to a single-cycle memory system (usually referred
  to as a tightly-coupled memory, or TCM - a ROM or a RAM). As such, it
  attempts to maximise throughput of the fetch stage to the pipeline.

  It responds to branch/exception indications from the control stage and
  delivers the appropriate instructions to the decode stage when the pipeline
  is ready to advance.

  It will go to "sleep" when it hits a jump-to-self instruction (0x00000000).

  Assumptions:
  Relies _heavily_ on being attached to a single-cycle memory.
  The ibus_adr_o requests byte-addresses, ibus_req_o is analogous to a
  read-enable signal, and the ibus_ack_i should be aligned with the read-data
  coming back.

  indicate ibus errors

  Copyright (C) 2013 Authors

  Author(s): Julius Baxter <juliusbaxter@gmail.com>

***************************************************************************** */

`include "mor1kx-defines.v"

module mor1kx_fetch_tcm_prontoespresso
  (/*AUTOARG*/
   // Outputs
   ibus_adr_o, ibus_req_o, decode_insn_o, fetched_pc_o, fetch_ready_o,
   fetch_rfa_adr_o, fetch_rfb_adr_o, fetch_rf_re_o, pc_fetch_next_o,
   decode_except_ibus_err_o, fetch_sleep_o,
   // Inputs
   clk, rst, ibus_err_i, ibus_ack_i, ibus_dat_i, padv_i,
   branch_occur_i, branch_dest_i, du_restart_i, du_restart_pc_i,
   fetch_take_exception_branch_i, execute_waiting_i, du_stall_i,
   stepping_i, flag_i, flag_clear_i, flag_set_i
   );

   parameter OPTION_OPERAND_WIDTH = 32;
   parameter OPTION_RF_ADDR_WIDTH = 5;
   parameter OPTION_RESET_PC = {{(OPTION_OPERAND_WIDTH-13){1'b0}},
				`OR1K_RESET_VECTOR,8'd0};

   input clk, rst;

   // interface to ibus
   output [OPTION_OPERAND_WIDTH-1:0] ibus_adr_o;
   output 			     ibus_req_o;
   input 			     ibus_err_i;
   input 			     ibus_ack_i;
   input [`OR1K_INSN_WIDTH-1:0]      ibus_dat_i;

   // pipeline control input
   input 			      padv_i;

   // interface to decode unit
   output reg [`OR1K_INSN_WIDTH-1:0]  decode_insn_o;

   // PC of the current instruction, SPR_PPC basically
   output reg [OPTION_OPERAND_WIDTH-1:0] fetched_pc_o;

   // Indication to pipeline control that the fetch stage is ready
   output     				 fetch_ready_o;

   // Signals going to register file to do the read access as we
   // register the instruction out to the decode stage
   output [OPTION_RF_ADDR_WIDTH-1:0] 	 fetch_rfa_adr_o;
   output [OPTION_RF_ADDR_WIDTH-1:0] 	 fetch_rfb_adr_o;
   output 				 fetch_rf_re_o;

   // Signal back to the control which pc we're goint to
   // deliver next
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

   // Flag status information
   input 				  flag_i, flag_clear_i, flag_set_i;

   // instruction ibus error indication out
   output reg 				  decode_except_ibus_err_o;

   // fetch sleep mode enabled (due to jump-to-self instruction
   output 				  fetch_sleep_o;


   reg [OPTION_OPERAND_WIDTH-1:0] 	  current_bus_pc;
   wire [OPTION_OPERAND_WIDTH-1:0] 	  next_bus_pc;
   reg [OPTION_OPERAND_WIDTH-1:0] 	  insn_buffer;

   wire 				  first_bus_req_cycle;
   reg 					  addr_pipelined;
   reg 					  bus_req, bus_req_r;
   wire [`OR1K_OPCODE_WIDTH-1:0] 	  next_insn_opcode;
   reg 					  next_insn_will_branch;
   reg 					  jump_insn_in_decode;
   reg 					  just_took_branch_addr;
   wire 				  taking_branch_addr;
   reg 					  insn_from_branch_on_input;
   reg 					  insn_from_branch_in_pipeline;
   reg 					  execute_waiting_r;
   wire					  execute_waiting_deasserted;
   wire					  execute_waiting_asserted;
   reg 					  execute_waiting_asserted_r;
   wire 				  execute_waited_single_cycle;
   reg      				  just_waited_single_cycle;
   reg      				  just_waited_single_cycle_r;
   reg 					  insn_buffered;
   wire 				  buffered_insn_is_jump;
   reg 					  push_buffered_jump_through_pipeline;
   wire 				  will_go_to_sleep;
   reg 					  sleep;
   reg 					  fetch_take_exception_branch_r;
   reg [3:0] 				  padv_r;
   wire 				  long_stall;


   assign next_bus_pc = current_bus_pc + 4;
   assign ibus_adr_o = addr_pipelined ? next_bus_pc : current_bus_pc;

   assign pc_fetch_next_o = ibus_adr_o;

   assign ibus_req_o = bus_req & !(stepping_i & ibus_ack_i)  |
		       (execute_waiting_deasserted &
			!(insn_buffered & next_insn_will_branch)) |
		       fetch_take_exception_branch_r;

   // Signal rising edge on bus request signal
   assign first_bus_req_cycle = ibus_req_o & !bus_req_r;

   assign taking_branch_addr = (branch_occur_i & padv_i) |
			       fetch_take_exception_branch_i;

   assign buffered_insn_is_jump = insn_buffered & next_insn_will_branch;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       begin
	  current_bus_pc		<= OPTION_RESET_PC;
	  just_took_branch_addr         <= 0;
       end
     else if (du_restart_i)
       begin
	  current_bus_pc <= du_restart_pc_i;
	  just_took_branch_addr         <= 0;
       end
     else if (fetch_take_exception_branch_i)
       begin
	  current_bus_pc <= branch_dest_i;
	  just_took_branch_addr         <= 1;
       end
     else if (branch_occur_i & padv_i)
       begin
	  current_bus_pc <= branch_dest_i;
	  just_took_branch_addr         <= 1;
       end
     else if (ibus_ack_i & (padv_i | (just_waited_single_cycle_r &&
				      !({padv_r[0],padv_i}==2'b00))) &
	      !execute_waited_single_cycle & !stepping_i)
       begin
	  current_bus_pc <= next_bus_pc;
	  just_took_branch_addr         <= 0;
       end
     else if (execute_waiting_asserted & ibus_ack_i & !just_took_branch_addr)
       begin
	  current_bus_pc <= next_bus_pc;
       end
     else if (just_took_branch_addr)
       begin
	  just_took_branch_addr <= 0;
       end

     else if (long_stall)
       begin
	  // Long wait - this is a work around for an annoying bug which
	  // I can't solve any other way!
	  current_bus_pc <= fetched_pc_o + 4;
       end

   // BIG assumptions here - that the read only takes a single cycle!!
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       begin
	  insn_from_branch_on_input <= 0;
	  insn_from_branch_in_pipeline <= 0;
       end
     else
       begin
	  insn_from_branch_on_input <= just_took_branch_addr;
	  insn_from_branch_in_pipeline <= insn_from_branch_on_input;
       end


   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       bus_req <= 1'b0;
     else if (stepping_i & ibus_ack_i)
       // Deassert on ack of stepping
       bus_req <= 1'b0;
     else if (du_stall_i)
       bus_req <= 1'b0;
     else if (ibus_err_i | decode_except_ibus_err_o)
       bus_req <= 1'b0;
     else if (sleep)
       bus_req <= 1'b0;
     else if (execute_waiting_i)
       bus_req <= 1'b0;
     else if (buffered_insn_is_jump)
       bus_req <= 1'b0;
     else
       bus_req <= 1'b1;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       bus_req_r <= 0;
     else
       bus_req_r <= ibus_req_o;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       addr_pipelined <= 0;
     else if (ibus_err_i | decode_except_ibus_err_o |
	      fetch_take_exception_branch_i)
       addr_pipelined <= 0;
     else if (first_bus_req_cycle)
       addr_pipelined <= 1;
     else if (taking_branch_addr)
       addr_pipelined <= 0;
     else if (just_took_branch_addr)
       addr_pipelined <= 1;
     else if (just_waited_single_cycle)
       addr_pipelined <= 1;
     else if (!bus_req)
       addr_pipelined <= 0;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       begin
	  decode_insn_o <= {`OR1K_OPCODE_NOP,26'd0};
	  fetched_pc_o  <= 0;
       end
     else if (sleep | (du_stall_i & !execute_waiting_i))
       begin
	  decode_insn_o <= {`OR1K_OPCODE_NOP,26'd0};
       end
     else if (fetch_take_exception_branch_i & !du_stall_i)
       begin
	  decode_insn_o <= {`OR1K_OPCODE_NOP,26'd0};
       end
     else if ((padv_i | stepping_i) & ibus_ack_i & (ibus_req_o | stepping_i) &
	      ((!jump_insn_in_decode & !just_took_branch_addr) |
	       (insn_from_branch_on_input))
	      & !(execute_waited_single_cycle | just_waited_single_cycle))
       begin
	  decode_insn_o <= ibus_dat_i;
	  fetched_pc_o  <= current_bus_pc;
       end
     else if (just_waited_single_cycle_r & !execute_waiting_i)
       begin
	  decode_insn_o <= ibus_dat_i;
	  fetched_pc_o  <= current_bus_pc;
       end
     else if (execute_waiting_deasserted & insn_buffered)
       begin
	  decode_insn_o <= insn_buffer;
	  fetched_pc_o  <= fetched_pc_o + 4;
       end
     else if ((jump_insn_in_decode | branch_occur_i) & padv_i)
       // About to jump - remove this instruction from the pipeline
       decode_insn_o <= {`OR1K_OPCODE_NOP,26'd0};
     else if (fetch_take_exception_branch_i)
       decode_insn_o <= {`OR1K_OPCODE_NOP,26'd0};
     else if (push_buffered_jump_through_pipeline)
       decode_insn_o <= {`OR1K_OPCODE_NOP,26'd0};

   reg fetch_ready_r;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       fetch_ready_r <= 0;
     else
       fetch_ready_r <= fetch_ready_o;

   assign fetch_ready_o = (ibus_ack_i | insn_buffered ) &
			  !(just_took_branch_addr) &
			  !(just_waited_single_cycle) &
			  !du_stall_i |
			  push_buffered_jump_through_pipeline ;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       decode_except_ibus_err_o <= 0;
     else if ((padv_i | fetch_take_exception_branch_i) &
	      branch_occur_i | du_stall_i)
       decode_except_ibus_err_o <= 0;
     else if (bus_req)
       decode_except_ibus_err_o <= ibus_err_i;

   assign fetch_sleep_o = sleep;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       execute_waiting_r <= 0;
     else
       execute_waiting_r <= execute_waiting_i;

   assign execute_waiting_deasserted = !execute_waiting_i & execute_waiting_r;
   assign execute_waiting_asserted = execute_waiting_i & !execute_waiting_r;


   // Register file control
   assign fetch_rfa_adr_o	= insn_buffered ? insn_buffer[`OR1K_RA_SELECT] :
				  ibus_dat_i[`OR1K_RA_SELECT];
   assign fetch_rfb_adr_o	= insn_buffered ? insn_buffer[`OR1K_RB_SELECT] :
				  ibus_dat_i[`OR1K_RB_SELECT];
   assign fetch_rf_re_o		= (ibus_ack_i | execute_waiting_deasserted) &
				  (padv_i | stepping_i);

   // Pick out opcode of next instruction to go to decode stage
   assign next_insn_opcode      = insn_buffered ?
				  insn_buffer[`OR1K_OPCODE_SELECT] :
				  ibus_dat_i[`OR1K_OPCODE_SELECT];

   always @*
     if ((ibus_ack_i & !just_took_branch_addr) | insn_buffered)
       case (next_insn_opcode)
	 `OR1K_OPCODE_J,
	 `OR1K_OPCODE_JAL: begin
	    next_insn_will_branch	= 1;
	 end
	 `OR1K_OPCODE_JR,
	   `OR1K_OPCODE_JALR: begin
	      next_insn_will_branch	= 1;
	   end
	 `OR1K_OPCODE_BNF: begin
	    next_insn_will_branch	= !(flag_i | flag_set_i) | flag_clear_i;
	 end
	 `OR1K_OPCODE_BF: begin
	    next_insn_will_branch	= !(!flag_i | flag_clear_i) |flag_set_i;
	 end
	 `OR1K_OPCODE_SYSTRAPSYNC,
	   `OR1K_OPCODE_RFE: begin
	      next_insn_will_branch	= 1;
	   end
	 default: begin
	    next_insn_will_branch	= 0;
	 end
       endcase // case (next_insn_opcode)
     else
       begin
	  next_insn_will_branch		= 0;
       end

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       jump_insn_in_decode <= 0;
     else if (sleep)
       jump_insn_in_decode <= 0;
     else if (!jump_insn_in_decode & next_insn_will_branch & ibus_ack_i)
       jump_insn_in_decode <= 1;
     else
       jump_insn_in_decode <= 0;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       insn_buffer <= 0;
     else if (execute_waiting_asserted & ibus_ack_i & !just_took_branch_addr)
       insn_buffer <= ibus_dat_i;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       insn_buffered <= 0;
     else if (execute_waiting_asserted & ibus_ack_i & !just_took_branch_addr)
       insn_buffered <= 1;
     else if (execute_waiting_deasserted)
       insn_buffered <= 0;
     else if (fetch_take_exception_branch_i)
       insn_buffered <= 0;
     else if (long_stall)
       insn_buffered <= 0;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       push_buffered_jump_through_pipeline  <= 0;
     else
       push_buffered_jump_through_pipeline <= buffered_insn_is_jump &
					      execute_waiting_deasserted;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       fetch_take_exception_branch_r <= 0;
     else
       fetch_take_exception_branch_r <= fetch_take_exception_branch_i;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       sleep <= 1'b0;
     else if (fetch_take_exception_branch_i)
       sleep <= 1'b0;
     else if (will_go_to_sleep)
       sleep <= 1'b1;

   assign will_go_to_sleep = ibus_dat_i==0 & padv_i & ibus_ack_i &
			     ibus_req_o & ((!jump_insn_in_decode &
					    !just_took_branch_addr) |
					   (insn_from_branch_on_input));

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       execute_waiting_asserted_r <= 0;
     else
       execute_waiting_asserted_r <= execute_waiting_asserted;

   assign execute_waited_single_cycle =  execute_waiting_asserted_r &
					  !execute_waiting_i;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       begin
	  just_waited_single_cycle <= 0;
	  just_waited_single_cycle_r <= 0;
       end
     else
       begin
	  just_waited_single_cycle <= execute_waited_single_cycle;
	  just_waited_single_cycle_r <= just_waited_single_cycle;
       end

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       padv_r <= 4'd0;
     else
       padv_r <= {padv_r[2:0],padv_i};

   assign long_stall = {padv_r,padv_i}==5'b10000 && execute_waiting_i;

endmodule // mor1kx_fetch_tcm_prontoespresso
