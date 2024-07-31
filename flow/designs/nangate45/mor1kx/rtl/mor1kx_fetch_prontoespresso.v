/* ****************************************************************************
  SPDX-License-Identifier: CERN-OHL-W-2.0

  Description: mor1kx pronto espresso fetch unit

  Fetch insn, advance PC (or take new branch address) on padv_i.

  What we might want to do is have a 1-insn buffer here, so when the current
  insn is fetched, but the main pipeline doesn't want it yet

  indicate ibus errors

  Copyright (C) 2012 Authors

  Author(s): Julius Baxter <juliusbaxter@gmail.com>

***************************************************************************** */

`include "mor1kx-defines.v"

module mor1kx_fetch_prontoespresso
  (/*AUTOARG*/
   // Outputs
   ibus_adr_o, ibus_req_o, ibus_burst_o, decode_insn_o, fetched_pc_o,
   fetch_ready_o, fetch_rfa_adr_o, fetch_rfb_adr_o, fetch_rf_re_o,
   pc_fetch_next_o, decode_except_ibus_err_o, fetch_sleep_o,
   fetch_quick_branch_o, spr_bus_dat_ic_o, spr_bus_ack_ic_o,
   // Inputs
   clk, rst, ibus_err_i, ibus_ack_i, ibus_dat_i, ic_enable, padv_i,
   branch_occur_i, branch_dest_i, ctrl_insn_done_i, du_restart_i,
   du_restart_pc_i, fetch_take_exception_branch_i, execute_waiting_i,
   du_stall_i, stepping_i, flag_i, flag_clear_i, flag_set_i,
   spr_bus_addr_i, spr_bus_we_i, spr_bus_stb_i, spr_bus_dat_i
   );

   parameter OPTION_OPERAND_WIDTH = 32;
   parameter OPTION_RF_ADDR_WIDTH = 5;
   parameter OPTION_RESET_PC = {{(OPTION_OPERAND_WIDTH-13){1'b0}},
				`OR1K_RESET_VECTOR,8'd0};
   // Mini cache registers, signals
   parameter FEATURE_INSTRUCTIONCACHE = "NONE";
   parameter OPTION_ICACHE_BLOCK_WIDTH = 3; // 3 for 8 words
   parameter FEATURE_QUICK_BRANCH_DETECTION = "NONE";

   input clk, rst;

   // interface to ibus
   output [OPTION_OPERAND_WIDTH-1:0] ibus_adr_o;
   output 			     ibus_req_o;
   output 			     ibus_burst_o;
   input 			     ibus_err_i;
   input 			     ibus_ack_i;
   input [`OR1K_INSN_WIDTH-1:0]      ibus_dat_i;
   input 			     ic_enable;

   // pipeline control input
   input 			      padv_i;

   // interface to decode unit
   output reg [`OR1K_INSN_WIDTH-1:0]  decode_insn_o;

   // PC of the current instruction, SPR_PPC basically
   output     [OPTION_OPERAND_WIDTH-1:0] fetched_pc_o;

   // Indication to pipeline control that the fetch stage is ready
   output 				 fetch_ready_o;

   // Signals going to register file to do the read access as we
   // register the instruction out to the decode stage
   output [OPTION_RF_ADDR_WIDTH-1:0] 	 fetch_rfa_adr_o;
   output [OPTION_RF_ADDR_WIDTH-1:0] 	 fetch_rfb_adr_o;
   output 				 fetch_rf_re_o;

   // Signal back to the control
   output [OPTION_OPERAND_WIDTH-1:0] 	 pc_fetch_next_o;


   // branch/jump indication
   input 				  branch_occur_i;
   input [OPTION_OPERAND_WIDTH-1:0] 	  branch_dest_i;

   // Instruction "retire" indication from control stage
   input 				  ctrl_insn_done_i;

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

   // Indicate to the control stage that we had zero delay fetching
   // the branch target address
   output 				  fetch_quick_branch_o;

   // SPR interface
   input [15:0] 			  spr_bus_addr_i;
   input 				  spr_bus_we_i;
   input 				  spr_bus_stb_i;
   input [OPTION_OPERAND_WIDTH-1:0] 	  spr_bus_dat_i;
   output [OPTION_OPERAND_WIDTH-1:0] 	  spr_bus_dat_ic_o;
   output 				  spr_bus_ack_ic_o;


   // Registers
   reg [OPTION_OPERAND_WIDTH-1:0] 	  pc;
   reg [OPTION_OPERAND_WIDTH-1:0]         fetched_pc;
   reg 					  fetch_req;
   reg 					  next_insn_will_branch;
   reg 					  have_early_pc_next;
   reg 					  jump_insn_in_decode;
   reg 					  took_early_calc_pc;
   reg [1:0]				  took_early_calc_pc_r;
   reg 					  padv_r;
   reg 					  took_branch;
   reg 					  took_branch_r;
   reg 					  execute_waiting_r;
   reg 					  sleep;
   reg 					  complete_current_req;
   reg   				  no_rf_read;
   reg 					  new_insn_wasnt_ready;
   reg 					  took_early_pc_onto_cache_hit;
   reg 					  waited_with_early_pc_onto_cache_hit;

   // Wires
   wire [`OR1K_INSN_WIDTH-1:0] 		  new_insn;
   wire 				  new_insn_ready;
   wire [OPTION_OPERAND_WIDTH-1:0] 	  pc_fetch_next;
   wire [OPTION_OPERAND_WIDTH-1:0] 	  pc_plus_four;
   wire [OPTION_OPERAND_WIDTH-1:0] 	  early_pc_next;
   wire 				  padv_deasserted;
   wire 				  padv_asserted;
   wire [`OR1K_OPCODE_WIDTH-1:0] 	  next_insn_opcode;
   wire 				  will_go_to_sleep;
   wire 				  mini_cache_hit;
   wire 				  mini_cache_hit_ungated;
   wire [`OR1K_INSN_WIDTH-1:0] 		  mini_cache_insn;
   wire 				  hold_decode_output;
   wire 				  next_instruction_to_decode_condition;

   assign pc_plus_four		= pc + 4;

   assign pc_fetch_next         = have_early_pc_next ?
				  early_pc_next : pc_plus_four;

   assign ibus_adr_o		= pc;
   assign ibus_req_o		= (fetch_req & !(fetch_take_exception_branch_i/* | branch_occur_i*/)
				  // This is needed in the case that:
				  // 1. a burst just finished and ack in went low because of this
				  // 2. the instruction we just ACKed is a multicycle insn so the
				  //    execute_waiting_i goes high, but the bus interface will have
				  //    already put out the request onto the bus. It causes a bug
				  //    if we deassert the req from here 1 cycle later, so put this
				  //    signal into the assign logic so that the first cycle of it
				  //    causes req to go low, after which fetch_req is deasserted
				  //    and should handle it
				  & !(execute_waiting_i & fetch_req)
				  & !mini_cache_hit_ungated) |
				  complete_current_req;
   assign ibus_burst_o		= 0;

   assign fetch_ready_o		= new_insn_ready | jump_insn_in_decode | ibus_err_i;

   assign pc_fetch_next_o       = pc_fetch_next;

   assign new_insn              = mini_cache_hit ? mini_cache_insn : ibus_dat_i;

   assign new_insn_ready        = mini_cache_hit | ibus_ack_i;

   // Register file control
   assign fetch_rfa_adr_o	= new_insn_ready ? new_insn[`OR1K_RA_SELECT] : 0;
   assign fetch_rfb_adr_o	= new_insn_ready ? new_insn[`OR1K_RB_SELECT] : 0;
   assign fetch_rf_re_o		= new_insn_ready & (padv_i | stepping_i) &
				  !(no_rf_read | hold_decode_output);

   // Pick out opcode of next instruction to go to decode stage
   assign next_insn_opcode      = new_insn[`OR1K_OPCODE_SELECT];

   // Can calculate next PC based on instruction coming in
   assign early_pc_next = {OPTION_OPERAND_WIDTH{have_early_pc_next}} &
			  ({{4{new_insn[25]}},
			    new_insn[`OR1K_JUMPBRANCH_IMMEDIATE_SELECT],
			    2'b00} + pc);

   assign will_go_to_sleep = have_early_pc_next &
			     (early_pc_next == pc);

   assign fetch_sleep_o = sleep;

   // The pipeline advance signal deasserted for the instruction
   // we just put out, and we're still attempting to fetch. This should
   // result in a deassert cycle on the request signal out to the bus.
   // But, we don't want this to indicate when padv_i was deasserted for
   // a branch, because we will know about that, we just want this to
   // indicate it was deasserted for other reasons.
   assign padv_deasserted = padv_r & !padv_i & fetch_req & !took_branch;

   assign padv_asserted = !padv_r & padv_i;

   // This makes us hold the decode stage output for an additional
   // cycle when we've already got the next instruction in the
   // register output to the decode stage, but the pipeline has
   // stalled.
   assign hold_decode_output = (padv_asserted &
				mini_cache_hit & took_branch_r &
				!new_insn_wasnt_ready &
				took_early_calc_pc_r[1]) ||
			       waited_with_early_pc_onto_cache_hit;
   always @*
     if (new_insn_ready)
       case (next_insn_opcode)
	 `OR1K_OPCODE_J,
	 `OR1K_OPCODE_JAL: begin
	    have_early_pc_next		= 1;
	    next_insn_will_branch	= 1;
	    no_rf_read                  = 1;
	 end
	 `OR1K_OPCODE_JR,
	 `OR1K_OPCODE_JALR: begin
	    have_early_pc_next		= 0;
	    next_insn_will_branch	= 1;
	    no_rf_read                  = 0;
	 end
	 `OR1K_OPCODE_BNF: begin
	    have_early_pc_next		= !(flag_i | flag_set_i) | flag_clear_i;
	    next_insn_will_branch	= !(flag_i | flag_set_i) | flag_clear_i;
	    no_rf_read                  = 1;
	 end
	 `OR1K_OPCODE_BF: begin
	    have_early_pc_next		= !(!flag_i | flag_clear_i) |flag_set_i;
	    next_insn_will_branch	= !(!flag_i | flag_clear_i) |flag_set_i;
	    no_rf_read                  = 1;
	 end
	 `OR1K_OPCODE_SYSTRAPSYNC,
	 `OR1K_OPCODE_RFE: begin
	    have_early_pc_next		= 0;
	    next_insn_will_branch	= 1;
	    no_rf_read                  = 1;
	 end
	 default: begin
	   have_early_pc_next		= 0;
	   next_insn_will_branch	= 0;
	   no_rf_read                   = 0;
	 end
       endcase // case (next_insn_opcode)
     else
       begin
	  have_early_pc_next		= 0;
	  next_insn_will_branch		= 0;
	  no_rf_read                    = 0;
       end

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       begin
	  pc		<= OPTION_RESET_PC;
	  fetched_pc  	<= OPTION_RESET_PC;
       end
     else if (branch_occur_i & !took_early_calc_pc)
       begin
	  pc		<= branch_dest_i;
       end
     else if (fetch_take_exception_branch_i & !du_stall_i)
       begin
	  pc		<= branch_dest_i;
       end
     else if (new_insn_ready & (padv_i | stepping_i) &
	      !hold_decode_output)
       begin
	  pc		<= pc_fetch_next_o;
	  fetched_pc  	<= pc;
       end
     else if (du_restart_i)
       begin
	  pc		<= du_restart_pc_i;
       end
     else if (fetch_take_exception_branch_i & du_stall_i)
       begin
	  pc		<= du_restart_pc_i;
       end

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       new_insn_wasnt_ready <= 0;
     else if (branch_occur_i & !took_early_calc_pc)
       new_insn_wasnt_ready <= !new_insn_ready;
     else if (new_insn_ready & (padv_i | stepping_i) & !padv_deasserted)
       new_insn_wasnt_ready <= 0;

   assign fetched_pc_o = fetched_pc;

   assign next_instruction_to_decode_condition = new_insn_ready &
						 (padv_i | stepping_i) &
						 !padv_deasserted &
						 !hold_decode_output &
						 !((branch_occur_i & padv_i &
						    !took_early_calc_pc) |
						   fetch_take_exception_branch_i);


   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       decode_insn_o <= {`OR1K_OPCODE_NOP,26'd0};
     else if (sleep | du_stall_i)
       decode_insn_o <= {`OR1K_OPCODE_NOP,26'd0};
     else if (next_instruction_to_decode_condition)
       decode_insn_o <= new_insn;
     else if (branch_occur_i & padv_i)
       // We've just taken a branch, put a nop on the
       // instruction to the rest of the pipeline
       decode_insn_o <= {`OR1K_OPCODE_NOP,26'd0};
     else if (fetch_take_exception_branch_i)
       // Exception was just taken, get rid of whatever
       // we're outputting
       decode_insn_o <= {`OR1K_OPCODE_NOP,26'd0};
     else if (took_early_calc_pc)
       // This covers the case where, for some reason,
       // we don't get the branch_occur_i
       decode_insn_o <= {`OR1K_OPCODE_NOP,26'd0};
     else if (ctrl_insn_done_i & !new_insn_ready)
       // If the current instruction in the decode stage is retired
       // then let's put a no-op back in the pipeline
       decode_insn_o <= {`OR1K_OPCODE_NOP,26'd0};

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       fetch_req <= 1'b1;
     else if (fetch_req & stepping_i & new_insn_ready)
       // Deassert on ack
       fetch_req <= 1'b0;
     else if (!fetch_req & du_stall_i)
       fetch_req <= 1'b0;
     else if (ibus_err_i)
       fetch_req <= 1'b0;
     else if (sleep)
       fetch_req <= 1'b0;
     else if (next_insn_will_branch)
       fetch_req <= 1'b0;
     else if (execute_waiting_i)
       /*
        Put the execute wait signal through this register to break any long
        chains of logic from the execute stage (LSU, ALU) which could result
        from using it to just gate the req signal out.
        TODO - actually check the impact of gating fetch_req_o with
               execute_waiting_i
        */
       fetch_req <= 1'b0;
     else if (padv_deasserted)
       fetch_req <= 1'b0;
     else if (mini_cache_hit_ungated)
       // We'll get this ungated signal immediately after we've
       // terminated a burst, so we'll know if we really should
       // fetch the branch target or whether it's in cache.
       fetch_req <= 1'b0;
     else
       fetch_req <= 1'b1;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       took_early_pc_onto_cache_hit <= 0;
     else if (padv_i)
       took_early_pc_onto_cache_hit <= took_early_calc_pc & mini_cache_hit &
					!fetch_take_exception_branch_i;
     else if (ctrl_insn_done_i)
       took_early_pc_onto_cache_hit <= 0;

   // This register signifies when:
   // a) we had a branch to somewhere where we took the early calculated PC and
   //    that branch location was a hit in the cache
   // b) the subsequent instruction wasn't in the cache, so we put the
   //    insn out to the decode stage, but wasn't immediately retired by the
   //    control stage, so we must wait until the next instruction is ready
   //    before it will be completed by the control stage
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       waited_with_early_pc_onto_cache_hit <= 0;
     else if (took_branch_r | padv_i)
       waited_with_early_pc_onto_cache_hit <= took_early_pc_onto_cache_hit &
					       !fetch_ready_o;
     else if (ctrl_insn_done_i)
       waited_with_early_pc_onto_cache_hit <= 0;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       jump_insn_in_decode <= 0;
     else if (sleep)
       jump_insn_in_decode <= 0;
     else if (!jump_insn_in_decode & next_insn_will_branch & new_insn_ready & padv_i)
       jump_insn_in_decode <= 1;
     else
       jump_insn_in_decode <= 0;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       took_early_calc_pc <= 0;
     else if (sleep)
       took_early_calc_pc <= 0;
     else if (next_insn_will_branch & have_early_pc_next & padv_i)
       took_early_calc_pc <= 1;
     else
       took_early_calc_pc <= 0;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       took_early_calc_pc_r <= 0;
     else
       took_early_calc_pc_r <= {took_early_calc_pc_r[0], took_early_calc_pc};

   always @(posedge clk)
     padv_r <= padv_i;

   /* Whether it was early branch or not, we've branched, and this
    signal will be asserted the cycle after. */
   always @(posedge clk)
     begin
        took_branch <= (branch_occur_i | fetch_take_exception_branch_i) &
                       fetch_ready_o;
        took_branch_r <= took_branch;
     end

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       decode_except_ibus_err_o <= 0;
     else if ((padv_i | fetch_take_exception_branch_i) &
	      branch_occur_i | du_stall_i)
       decode_except_ibus_err_o <= 0;
     else if (fetch_req)
       decode_except_ibus_err_o <= ibus_err_i;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       sleep <= 1'b0;
     else if (fetch_take_exception_branch_i | du_stall_i)
       sleep <= 1'b0;
     else if (will_go_to_sleep & !stepping_i)
       sleep <= 1'b1;

   // A signal to make sure the request out line stays high
   // if we've already issued an instruction request and padv_i
   // goes low.
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       complete_current_req <= 0;
     else if (fetch_req & padv_deasserted & !new_insn_ready)
      complete_current_req  <= 1;
     else if (new_insn_ready & complete_current_req)
       complete_current_req <= 0;

   // Mini cache logic
   genvar 					     i;
   generate
      /* verilator lint_off WIDTH */
      if (FEATURE_INSTRUCTIONCACHE != "ENABLED")
      /* verilator lint_on WIDTH */
	begin : no_mini_cache
	   assign mini_cache_hit = 0;
	   assign mini_cache_hit_ungated = 0;
	   assign mini_cache_insn = {`OR1K_INSN_WIDTH{1'b0}};
	   assign fetch_quick_branch_o = 0;
	end
      else
	begin : mini_cache
	   localparam NUMBER_MINI_CACHE_WORDS =  (1<<OPTION_ICACHE_BLOCK_WIDTH);
	   localparam MINI_CACHE_TAG_END      = OPTION_ICACHE_BLOCK_WIDTH+2;

	   reg mini_cache_tag_valid [0:NUMBER_MINI_CACHE_WORDS-1];
	   wire mini_cache_fill_condition;
	   wire invalidate;
	   reg [`OR1K_INSN_WIDTH-1:0] mini_cache [0:NUMBER_MINI_CACHE_WORDS-1];
	   reg [OPTION_OPERAND_WIDTH-1:MINI_CACHE_TAG_END] mini_cache_tag [0:NUMBER_MINI_CACHE_WORDS-1];
	   wire [OPTION_OPERAND_WIDTH-1:MINI_CACHE_TAG_END] pc_tag;
	   wire [OPTION_ICACHE_BLOCK_WIDTH-1:0] 	    pc_word_sel;
	   wire [`OR1K_INSN_WIDTH-1:0] 		    mini_cache_branch_dest_insn;

	   // This is the address we'll write into the tag
	   assign pc_word_sel    = pc[OPTION_ICACHE_BLOCK_WIDTH+1:2];
	   assign pc_tag         = pc[OPTION_OPERAND_WIDTH-1:MINI_CACHE_TAG_END];

	   assign mini_cache_hit_ungated = mini_cache_tag_valid[pc_word_sel] &
					   mini_cache_tag[pc_word_sel]==pc_tag;

	   assign mini_cache_hit      = mini_cache_hit_ungated & !took_branch &
					!fetch_take_exception_branch_i;

	   assign mini_cache_insn     = mini_cache[pc_word_sel];

	   assign mini_cache_fill_condition = ibus_ack_i & !ibus_err_i &
					      !will_go_to_sleep;

	   assign invalidate = spr_bus_stb_i & spr_bus_we_i &
			       (spr_bus_addr_i == `OR1K_SPR_ICBIR_ADDR);

	   assign fetch_quick_branch_o = took_branch & mini_cache_hit;

	   assign spr_bus_ack_ic_o     = 1'b1;

	   for (i=0;i<NUMBER_MINI_CACHE_WORDS;i=i+1)
	     begin : flop_cache_control
		always @(posedge clk `OR_ASYNC_RST)
		  if (rst)
		    begin
		       mini_cache_tag[i]	<= 'd0;
		       mini_cache_tag_valid[i]	<= 1'b0;
		    end
		  else if (invalidate/* | !ic_enable*/ | du_stall_i)
		    begin
		       // Invalidate all tags on:
		       // 1) any write to the block-invalidate register
		       // 2) when the cache isn't enabled
		       // 3) whenever we're stalled - things may change
		       //    under our feet and it helps make things
		       //    easy when coming out of stall or stepping
		       mini_cache_tag_valid[i]	<= 1'b0;
		    end
		  else if (mini_cache_fill_condition &
			   pc_word_sel==i[OPTION_ICACHE_BLOCK_WIDTH-1:0])
		    begin
		       mini_cache_tag[i]	<= pc_tag;
		       mini_cache_tag_valid[i]	<= 1'b1;
		       mini_cache[i]		<= ibus_dat_i;
		    end
	     end

	end // block: mini_cache
   endgenerate

   assign spr_bus_ack_ic_o = 1'b1;
   assign spr_bus_dat_ic_o = {OPTION_OPERAND_WIDTH{1'b0}};

endmodule // mor1kx_fetch_prontoespresso
