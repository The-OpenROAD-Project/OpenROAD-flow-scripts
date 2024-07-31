/* ****************************************************************************
  SPDX-License-Identifier: CERN-OHL-W-2.0

  Description: mor1kx fetch/address stage unit

  basically an interface to the ibus/icache subsystem that can react to
  exception and branch signals.

  Copyright (C) 2012 Authors

  Author(s): Julius Baxter <juliusbaxter@gmail.com>
             Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>

***************************************************************************** */

`include "mor1kx-defines.v"

module mor1kx_fetch_cappuccino
  #(
    parameter OPTION_OPERAND_WIDTH = 32,
    parameter OPTION_RESET_PC = {{(OPTION_OPERAND_WIDTH-13){1'b0}},
				 `OR1K_RESET_VECTOR,8'd0},
    parameter OPTION_RF_ADDR_WIDTH = 5,
    parameter FEATURE_INSTRUCTIONCACHE = "NONE",
    parameter OPTION_ICACHE_BLOCK_WIDTH = 5,
    parameter OPTION_ICACHE_SET_WIDTH = 9,
    parameter OPTION_ICACHE_WAYS = 2,
    parameter OPTION_ICACHE_LIMIT_WIDTH = 32,
    parameter FEATURE_IMMU = "NONE",
    parameter FEATURE_IMMU_HW_TLB_RELOAD = "NONE",
    parameter OPTION_IMMU_SET_WIDTH = 6,
    parameter OPTION_IMMU_WAYS = 1
    )
   (
    input 				  clk,
    input 				  rst,

    // SPR interface
    input [15:0] 			  spr_bus_addr_i,
    input 				  spr_bus_we_i,
    input 				  spr_bus_stb_i,
    input [OPTION_OPERAND_WIDTH-1:0] 	  spr_bus_dat_i,
    output [OPTION_OPERAND_WIDTH-1:0] 	  spr_bus_dat_ic_o,
    output 				  spr_bus_ack_ic_o,
    output [OPTION_OPERAND_WIDTH-1:0] 	  spr_bus_dat_immu_o,
    output 				  spr_bus_ack_immu_o,

    input 				  ic_enable,
    input 				  immu_enable_i,
    input 				  supervisor_mode_i,
    output 				  ic_hit_o,

    // interface to ibus
    input 				  ibus_err_i,
    input 				  ibus_ack_i,
    input [`OR1K_INSN_WIDTH-1:0] 	  ibus_dat_i,
    output 				  ibus_req_o,
    output [OPTION_OPERAND_WIDTH-1:0] 	  ibus_adr_o,
    output 				  ibus_burst_o,

    // pipeline control input
    input 				  padv_i,
    input 				  padv_ctrl_i, // needed for immu spr

    // interface to decode unit
    output reg [OPTION_OPERAND_WIDTH-1:0] pc_decode_o,
    output reg [`OR1K_INSN_WIDTH-1:0] 	  decode_insn_o,
    output reg 				  fetch_valid_o,
    output [OPTION_RF_ADDR_WIDTH-1:0] 	  fetch_rfa_adr_o,
    output [OPTION_RF_ADDR_WIDTH-1:0] 	  fetch_rfb_adr_o,
    output 				  fetch_rf_adr_valid_o,

    // branch/jump indication
    input 				  decode_branch_i,
    input [OPTION_OPERAND_WIDTH-1:0] 	  decode_branch_target_i,
    input 				  ctrl_branch_exception_i,
    input [OPTION_OPERAND_WIDTH-1:0] 	  ctrl_branch_except_pc_i,
    input 				  du_restart_i,
    input [OPTION_OPERAND_WIDTH-1:0] 	  du_restart_pc_i,
    input 				  decode_op_brcond_i,
    input 				  branch_mispredict_i,
    input [OPTION_OPERAND_WIDTH-1:0] 	  execute_mispredict_target_i,

    // pipeline flush input from control unit
    input 				  pipeline_flush_i,

    // rfe instruction is being performed
    input 				  doing_rfe_i,

    // instruction ibus error indication out
    output reg 				  decode_except_ibus_err_o,

    // IMMU exceptions
    output reg 				  decode_except_itlb_miss_o,
    output reg 				  decode_except_ipagefault_o,

    output reg 				  fetch_exception_taken_o
   );

   // registers
   reg [OPTION_OPERAND_WIDTH-1:0] 	  pc_fetch;
   reg [OPTION_OPERAND_WIDTH-1:0] 	  pc_addr;
   reg 					  ctrl_branch_exception_r;

   wire 				  bus_access_done;
   wire 				  ctrl_branch_exception_edge;
   wire					  stall_fetch_valid;
   wire 				  addr_valid;
   reg 					  flush;
   wire					  flushing;

   reg 					  nop_ack;

   reg 					  imem_err;
   wire 				  imem_ack;
   wire [`OR1K_INSN_WIDTH-1:0] 		  imem_dat;

   wire 				  ic_ack;
   wire [`OR1K_INSN_WIDTH-1:0] 		  ic_dat;

   wire 				  ic_refill;
   wire 				  ic_refill_req;
   wire 				  ic_refill_done;
   wire 				  ic_invalidate;
   wire [OPTION_OPERAND_WIDTH-1:0] 	  ic_addr;
   wire [OPTION_OPERAND_WIDTH-1:0] 	  ic_addr_match;

   wire 				  ic_access;


   wire [OPTION_OPERAND_WIDTH-1:0] 	  immu_phys_addr;
   wire 				  immu_cache_inhibit;
   wire 				  pagefault;
   wire 				  tlb_miss;
   wire 				  except_itlb_miss;
   wire 				  except_ipagefault;

   wire 				  immu_busy;

   wire 				  tlb_reload_req;
   reg 					  tlb_reload_ack;
   wire [OPTION_OPERAND_WIDTH-1:0] 	  tlb_reload_addr;
   reg [OPTION_OPERAND_WIDTH-1:0] 	  tlb_reload_data;
   wire 				  tlb_reload_pagefault;
   wire 				  tlb_reload_busy;

   reg 					  fetching_brcond;
   reg 					  fetching_mispredicted_branch;
   wire 				  mispredict_stall;

   reg 					  exception_while_tlb_reload;
   wire 				  except_ipagefault_clear;

   assign bus_access_done = (imem_ack | imem_err | nop_ack) & !immu_busy &
			    !tlb_reload_busy;
   assign ctrl_branch_exception_edge = ctrl_branch_exception_i &
				       !ctrl_branch_exception_r;

   /* used to keep fetch_valid_o high during stall */
   assign stall_fetch_valid = !padv_i & fetch_valid_o;

   assign addr_valid = bus_access_done & padv_i &
		       !(except_itlb_miss | except_ipagefault) |
		       decode_except_itlb_miss_o & ctrl_branch_exception_i |
		       decode_except_ipagefault_o & ctrl_branch_exception_i |
		       doing_rfe_i;

   assign except_itlb_miss = tlb_miss & immu_enable_i & bus_access_done &
			     !mispredict_stall & !doing_rfe_i;
   assign except_ipagefault = pagefault & immu_enable_i & bus_access_done &
			      !mispredict_stall & !doing_rfe_i |
			      tlb_reload_pagefault;

   assign fetch_rfa_adr_o = imem_dat[`OR1K_RA_SELECT];
   assign fetch_rfb_adr_o = imem_dat[`OR1K_RB_SELECT];
   assign fetch_rf_adr_valid_o = bus_access_done & padv_i;

   // Signal to indicate that the ongoing bus access should be flushed
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       flush <= 0;
     else if (bus_access_done & padv_i | du_restart_i)
       flush <= 0;
     else if (pipeline_flush_i)
       flush <= 1;

   // pipeline_flush_i comes on the same edge as branch_except_occur during
   // rfe, but on an edge later when an exception occurs, but we always need
   // to keep on flushing when the branch signal comes in.
   assign flushing = pipeline_flush_i | ctrl_branch_exception_edge | flush;

   // Branch misprediction stall logic
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       fetching_brcond <= 0;
     else if (pipeline_flush_i)
       fetching_brcond <= 0;
     else if (decode_op_brcond_i & addr_valid)
       fetching_brcond <= 1;
     else if (bus_access_done & padv_i | du_restart_i)
       fetching_brcond <= 0;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       fetching_mispredicted_branch <= 0;
     else if (pipeline_flush_i)
       fetching_mispredicted_branch <= 0;
     else if (bus_access_done & padv_i | du_restart_i)
       fetching_mispredicted_branch <= 0;
     else if (fetching_brcond & branch_mispredict_i & padv_i)
       fetching_mispredicted_branch <= 1;

   assign mispredict_stall = fetching_mispredicted_branch |
			     branch_mispredict_i & fetching_brcond;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       ctrl_branch_exception_r <= 1'b0;
     else
       ctrl_branch_exception_r <= ctrl_branch_exception_i;

   // calculate address stage pc
   always @(*)
      if (rst)
	pc_addr = OPTION_RESET_PC;
      else if (du_restart_i)
	pc_addr = du_restart_pc_i;
      else if (ctrl_branch_exception_i & !fetch_exception_taken_o)
	pc_addr = ctrl_branch_except_pc_i;
      else if (branch_mispredict_i | fetching_mispredicted_branch)
	pc_addr = execute_mispredict_target_i;
      else if (decode_branch_i)
	pc_addr = decode_branch_target_i;
      else
	pc_addr = pc_fetch + 4;

   // Register fetch pc from address stage
   always @(posedge clk `OR_ASYNC_RST)
      if (rst)
	pc_fetch <= OPTION_RESET_PC;
      else if (addr_valid | du_restart_i)
	pc_fetch <= pc_addr;

   // fetch_exception_taken_o generation
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       fetch_exception_taken_o <= 1'b0;
     else if (fetch_exception_taken_o)
       fetch_exception_taken_o <= 1'b0;
     else if (ctrl_branch_exception_i & bus_access_done & padv_i)
       fetch_exception_taken_o <= 1'b1;
     else
       fetch_exception_taken_o <= 1'b0;

   // fetch_valid_o generation
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       fetch_valid_o <= 1'b0;
     else if (pipeline_flush_i)
       fetch_valid_o <= 1'b0;
     else if (bus_access_done & padv_i & !mispredict_stall & !immu_busy &
	      !tlb_reload_busy | stall_fetch_valid)
       fetch_valid_o <= 1'b1;
     else
       fetch_valid_o <= 1'b0;

   // Register instruction coming in
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       decode_insn_o <= {`OR1K_OPCODE_NOP,26'd0};
     else if (imem_err | flushing)
       decode_insn_o <= {`OR1K_OPCODE_NOP,26'd0};
     else if (bus_access_done & padv_i & !mispredict_stall)
       decode_insn_o <= imem_dat;

   // Register PC for later stages
   always @(posedge clk)
     if (bus_access_done & padv_i & !mispredict_stall)
       pc_decode_o <= pc_fetch;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       decode_except_ibus_err_o <= 0;
     else if (du_restart_i)
       decode_except_ibus_err_o <= 0;
     else if (imem_err)
       decode_except_ibus_err_o <= 1;
     else if (decode_except_ibus_err_o & ctrl_branch_exception_i)
       decode_except_ibus_err_o <= 0;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       decode_except_itlb_miss_o <= 0;
     else if (du_restart_i)
       decode_except_itlb_miss_o <= 0;
     else if (tlb_reload_busy)
       decode_except_itlb_miss_o <= 0;
     else if (except_itlb_miss)
       decode_except_itlb_miss_o <= 1;
     else if (decode_except_itlb_miss_o & ctrl_branch_exception_i)
       decode_except_itlb_miss_o <= 0;

   assign except_ipagefault_clear = decode_except_ipagefault_o &
				    ctrl_branch_exception_i;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       decode_except_ipagefault_o <= 0;
     else if (du_restart_i)
       decode_except_ipagefault_o <= 0;
     else if (except_ipagefault)
       decode_except_ipagefault_o <= 1;
     else if (except_ipagefault_clear)
       decode_except_ipagefault_o <= 0;

   // Bus access logic
   localparam [2:0]
     IDLE		= 0,
     READ		= 1,
     TLB_RELOAD		= 2,
     IC_REFILL		= 3;

   reg [2:0] state;

   reg [OPTION_OPERAND_WIDTH-1:0] ibus_adr;
   wire [OPTION_OPERAND_WIDTH-1:0] next_ibus_adr;
   reg [`OR1K_INSN_WIDTH-1:0] 	  ibus_dat;
   reg 				  ibus_req;
   reg 				  ibus_ack;

   wire 			  ibus_access;

   //
   // Under certain circumstances, there is a need to insert an nop
   // into the pipeline in order for it to move forward.
   // Here those conditions are handled and an acknowledged signal
   // is generated.
   //
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       nop_ack <= 0;
     else
       nop_ack <= padv_i & !bus_access_done & !(ibus_req & ibus_access) &
		  ((immu_enable_i & (tlb_miss | pagefault) &
		    !tlb_reload_busy) |
		   ctrl_branch_exception_edge & !tlb_reload_busy |
		   exception_while_tlb_reload & !tlb_reload_busy |
		   tlb_reload_pagefault |
		   mispredict_stall);

   assign ibus_access = (!ic_access | tlb_reload_busy | ic_invalidate) &
			!ic_refill |
			(state != IDLE) & (state != IC_REFILL) |
			ibus_ack;
   assign imem_ack = ibus_access ? ibus_ack : ic_ack;
   assign imem_dat = (nop_ack | except_itlb_miss | except_ipagefault) ?
		     {`OR1K_OPCODE_NOP,26'd0} :
		     ibus_access ? ibus_dat : ic_dat;
   assign ibus_adr_o = ibus_adr;
   assign ibus_req_o = ibus_req;
   assign ibus_burst_o = !ibus_access & ic_refill & !ic_refill_done;

   assign next_ibus_adr = (OPTION_ICACHE_BLOCK_WIDTH == 5) ?
			  {ibus_adr[31:5], ibus_adr[4:0] + 5'd4} : // 32 byte
			  {ibus_adr[31:4], ibus_adr[3:0] + 4'd4};  // 16 byte

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       imem_err <= 0;
     else
       imem_err <= ibus_err_i;

   always @(posedge clk) begin
      ibus_ack <= 0;
      exception_while_tlb_reload <= 0;
      tlb_reload_ack <= 0;

      case (state)
	IDLE: begin
	   ibus_req <= 0;
	   if (padv_i & ibus_access & !ibus_ack & !imem_err & !nop_ack) begin
	      if (tlb_reload_req) begin
		 ibus_adr <= tlb_reload_addr;
		 ibus_req <= 1;
		 state <= TLB_RELOAD;
	      end else if (immu_enable_i) begin
		 ibus_adr <= immu_phys_addr;
		 if (!tlb_miss & !pagefault & !immu_busy) begin
		    ibus_req <= 1;
		    state <= READ;
		 end
	      end else if (!ctrl_branch_exception_i | doing_rfe_i) begin
		 ibus_adr <= pc_fetch;
		 ibus_req <= 1;
		 state <= READ;
	      end
	   end else if (ic_refill_req) begin
	      ibus_adr <= ic_addr_match;
	      ibus_req <= 1;
	      state <= IC_REFILL;
	   end
	end

	IC_REFILL: begin
	   ibus_req <= 1;
	   if (ibus_ack_i) begin
	      ibus_adr <= next_ibus_adr;
	      if (ic_refill_done) begin
		 ibus_req <= 0;
		 state <= IDLE;
	      end
	   end
	   if (ibus_err_i) begin
	      ibus_req <= 0;
	      state <= IDLE;
	   end
	end

	READ: begin
	   ibus_ack <= ibus_ack_i;
	   ibus_dat <= ibus_dat_i;
	   if (ibus_ack_i | ibus_err_i) begin
	      ibus_req <= 0;
	      state <= IDLE;
	   end
	end

	TLB_RELOAD: begin
	   if (ctrl_branch_exception_i)
	     exception_while_tlb_reload <= 1;

	   ibus_adr <= tlb_reload_addr;
	   tlb_reload_data <= ibus_dat_i;
	   tlb_reload_ack <= ibus_ack_i & tlb_reload_req;

	   if (!tlb_reload_req)
	     state <= IDLE;

	   ibus_req <= tlb_reload_req;
	   if (ibus_ack_i | tlb_reload_ack)
	     ibus_req <= 0;
	end

	default:
	  state <= IDLE;
      endcase // case (state)

      if (rst) begin
	 ibus_req <= 0;
	 state <= IDLE;
      end
   end


   assign ic_addr = (addr_valid | du_restart_i) ? pc_addr : pc_fetch;
   assign ic_addr_match = immu_enable_i ? immu_phys_addr : pc_fetch;

generate
if (FEATURE_INSTRUCTIONCACHE!="NONE") begin : icache_gen
   reg 					  ic_enable_r;
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       ic_enable_r <= 0;
     else if (ic_enable & !ibus_req)
       ic_enable_r <= 1;
     else if (!ic_enable & !ic_refill)
       ic_enable_r <= 0;
   wire ic_enabled = ic_enable & ic_enable_r;
   wire ic_refill_allowed = (!((tlb_miss | pagefault) & immu_enable_i) &
			      !ctrl_branch_exception_i & !pipeline_flush_i &
			      !mispredict_stall | doing_rfe_i) &
			      !tlb_reload_busy & !immu_busy;
   wire ic_req = padv_i & !decode_except_ibus_err_o &
		   !decode_except_itlb_miss_o & !except_itlb_miss &
		   !decode_except_ipagefault_o & !except_ipagefault &
		   ic_access & ic_refill_allowed;

   if (OPTION_ICACHE_LIMIT_WIDTH == OPTION_OPERAND_WIDTH) begin
      assign ic_access = ic_enabled &
			 !(immu_cache_inhibit & immu_enable_i);
   end else if (OPTION_ICACHE_LIMIT_WIDTH < OPTION_OPERAND_WIDTH) begin
      assign ic_access = ic_enabled &
			 ic_addr_match[OPTION_OPERAND_WIDTH-1:
				       OPTION_ICACHE_LIMIT_WIDTH] == 0 &
			 !(immu_cache_inhibit & immu_enable_i);
   end else begin
      initial begin
	 $display("ERROR: OPTION_ICACHE_LIMIT_WIDTH > OPTION_OPERAND_WIDTH");
	 $finish();
      end
   end

   /* mor1kx_icache AUTO_TEMPLATE (
    // Outputs
    .cpu_ack_o			(ic_ack),
    .cpu_dat_o			(ic_dat[OPTION_OPERAND_WIDTH-1:0]),
    .spr_bus_dat_o		(spr_bus_dat_ic_o),
    .spr_bus_ack_o		(spr_bus_ack_ic_o),
    .refill_o			(ic_refill),
    .refill_req_o		(ic_refill_req),
    .refill_done_o		(ic_refill_done),
    .invalidate_o		(ic_invalidate),
    // Inputs
    .rst			(rst),
    .ic_imem_err_i      (imem_err),
    .ic_access_i		(ic_access),
    .cpu_adr_i			(ic_addr),
    .cpu_adr_match_i		(ic_addr_match),
    .cpu_req_i			(ic_req),
    .wradr_i			(ibus_adr),
    .wrdat_i			(ibus_dat_i),
    .we_i			(ibus_ack_i),
    );*/

   mor1kx_icache
     #(
       .OPTION_ICACHE_BLOCK_WIDTH(OPTION_ICACHE_BLOCK_WIDTH),
       .OPTION_ICACHE_SET_WIDTH(OPTION_ICACHE_SET_WIDTH),
       .OPTION_ICACHE_WAYS(OPTION_ICACHE_WAYS),
       .OPTION_ICACHE_LIMIT_WIDTH(OPTION_ICACHE_LIMIT_WIDTH)
       )
   mor1kx_icache
     (/*AUTOINST*/
      // Outputs
      .refill_o				(ic_refill),		 // Templated
      .refill_req_o			(ic_refill_req),	 // Templated
      .refill_done_o			(ic_refill_done),	 // Templated
      .invalidate_o			(ic_invalidate),	 // Templated
      .cpu_ack_o			(ic_ack),		 // Templated
      .cpu_dat_o			(ic_dat[OPTION_OPERAND_WIDTH-1:0]), // Templated
      .spr_bus_dat_o			(spr_bus_dat_ic_o),	 // Templated
      .spr_bus_ack_o			(spr_bus_ack_ic_o),	 // Templated
      .cache_hit_o			(ic_hit_o),
      // Inputs
      .clk				(clk),
      .rst				(rst),		 // Templated
      .ic_imem_err_i    (imem_err), 
      .ic_access_i			(ic_access),		 // Templated
      .cpu_adr_i			(ic_addr),		 // Templated
      .cpu_adr_match_i			(ic_addr_match),	 // Templated
      .cpu_req_i			(ic_req),		 // Templated
      .wradr_i				(ibus_adr),		 // Templated
      .wrdat_i				(ibus_dat_i),		 // Templated
      .we_i				(ibus_ack_i),		 // Templated
      .spr_bus_addr_i			(spr_bus_addr_i[15:0]),
      .spr_bus_we_i			(spr_bus_we_i),
      .spr_bus_stb_i			(spr_bus_stb_i),
      .spr_bus_dat_i			(spr_bus_dat_i[OPTION_OPERAND_WIDTH-1:0]));
end else begin // block: icache_gen
   assign ic_access = 0;
   assign ic_refill = 0;
   assign ic_refill_req = 1'b0;
   assign ic_refill_done = 0;
   assign ic_ack = 0;
   assign ic_hit_o = 0;
   assign ic_dat = 0;
   assign ic_invalidate = 0;
   assign spr_bus_dat_ic_o = 0;
   assign spr_bus_ack_ic_o = 0;
end
endgenerate

generate
if (FEATURE_IMMU!="NONE") begin : immu_gen
   wire  [OPTION_OPERAND_WIDTH-1:0] virt_addr = ic_addr;
   wire 			    immu_spr_bus_stb;
   wire 			    immu_enable;
   // small hack to delay immu spr reads by one cycle
   // ideally the spr accesses should work so that the address is presented
   // in execute stage and the delayed data should be available in control
   // stage, but this is not how things currently work.
   assign immu_spr_bus_stb = spr_bus_stb_i & (!padv_ctrl_i | spr_bus_we_i);

   assign immu_enable = immu_enable_i & !pipeline_flush_i & !mispredict_stall;

   /* mor1kx_immu AUTO_TEMPLATE (
    .enable_i				(immu_enable),
    .busy_o				(immu_busy),
    .phys_addr_o			(immu_phys_addr),
    .cache_inhibit_o			(immu_cache_inhibit),
    .tlb_miss_o				(tlb_miss),
    .tlb_reload_req_o			(tlb_reload_req),
    .tlb_reload_addr_o			(tlb_reload_addr),
    .tlb_reload_pagefault_o		(tlb_reload_pagefault),
    .tlb_reload_ack_i			(tlb_reload_ack),
    .tlb_reload_data_i			(tlb_reload_data),
    .tlb_reload_busy_o			(tlb_reload_busy),
    .tlb_reload_pagefault_clear_i	(except_ipagefault_clear),
    .pagefault_o			(pagefault),
    .spr_bus_dat_o			(spr_bus_dat_immu_o),
    .spr_bus_ack_o			(spr_bus_ack_immu_o),
    .spr_bus_stb_i			(immu_spr_bus_stb),
    .virt_addr_i			(virt_addr),
    .virt_addr_match_i			(pc_fetch),
    ); */
   mor1kx_immu
     #(
       .FEATURE_IMMU_HW_TLB_RELOAD(FEATURE_IMMU_HW_TLB_RELOAD),
       .OPTION_OPERAND_WIDTH(OPTION_OPERAND_WIDTH),
       .OPTION_IMMU_SET_WIDTH(OPTION_IMMU_SET_WIDTH),
       .OPTION_IMMU_WAYS(OPTION_IMMU_WAYS)
       )
   mor1kx_immu
     (/*AUTOINST*/
      // Outputs
      .busy_o				(immu_busy),		 // Templated
      .phys_addr_o			(immu_phys_addr),	 // Templated
      .cache_inhibit_o			(immu_cache_inhibit),	 // Templated
      .tlb_miss_o			(tlb_miss),		 // Templated
      .pagefault_o			(pagefault),		 // Templated
      .tlb_reload_req_o			(tlb_reload_req),	 // Templated
      .tlb_reload_addr_o		(tlb_reload_addr),	 // Templated
      .tlb_reload_pagefault_o		(tlb_reload_pagefault),	 // Templated
      .tlb_reload_busy_o		(tlb_reload_busy),	 // Templated
      .spr_bus_dat_o			(spr_bus_dat_immu_o),	 // Templated
      .spr_bus_ack_o			(spr_bus_ack_immu_o),	 // Templated
      // Inputs
      .clk				(clk),
      .rst				(rst),
      .enable_i				(immu_enable),		 // Templated
      .virt_addr_i			(virt_addr),		 // Templated
      .virt_addr_match_i		(pc_fetch),		 // Templated
      .supervisor_mode_i		(supervisor_mode_i),
      .tlb_reload_ack_i			(tlb_reload_ack),	 // Templated
      .tlb_reload_data_i		(tlb_reload_data),	 // Templated
      .tlb_reload_pagefault_clear_i	(except_ipagefault_clear), // Templated
      .spr_bus_addr_i			(spr_bus_addr_i[15:0]),
      .spr_bus_we_i			(spr_bus_we_i),
      .spr_bus_stb_i			(immu_spr_bus_stb),	 // Templated
      .spr_bus_dat_i			(spr_bus_dat_i[OPTION_OPERAND_WIDTH-1:0]));
end else begin
   assign immu_cache_inhibit = 0;
   assign immu_busy = 0;
   assign tlb_miss = 0;
   assign pagefault = 0;
   assign tlb_reload_busy = 0;
   assign tlb_reload_req = 0;
   assign tlb_reload_pagefault = 0;
end
endgenerate

/*---------------Formal Checking---------------*/

`ifdef FORMAL

   reg f_past_valid;
   initial f_past_valid = 1'b0;
   initial assume (rst);
   always @(posedge clk)
      f_past_valid <= 1'b1;

   always @(*)
      if (!f_past_valid)
         assume (rst);

//----------------------ASSERTIONS-------------------

   //Reset Conditions
   always @(posedge clk `OR_ASYNC_RST) begin
      if ($past(rst) && f_past_valid) begin
         assert (!fetching_brcond);
         assert (!fetching_mispredicted_branch);
         assert (pc_fetch == OPTION_RESET_PC);
         assert (!fetch_exception_taken_o);
         assert (!fetch_valid_o);
         assert (decode_insn_o == {`OR1K_OPCODE_NOP, 26'd0});
         assert (!decode_except_ipagefault_o);
         assert (!nop_ack);
         assert (!ibus_req_o);
      end
   end

//------------------FETCH PROPERTIES----------------

   //If fetch was valid it will be cleared when we have a branch misprediction
   always @(posedge clk `OR_ASYNC_RST) begin
      if (f_past_valid && $past(fetch_valid_o) && $past(mispredict_stall)
          && !$past(stall_fetch_valid))
         assert (!fetch_valid_o);
   end

   //Fetch valid_o has to be stable if there is stall in pipeline
   always @(posedge clk `OR_ASYNC_RST) begin
      if (f_past_valid && !$past(rst) && $past(fetch_valid_o) &&
          $past(stall_fetch_valid) && !$past(pipeline_flush_i))
         assert (fetch_valid_o == $past(fetch_valid_o));
   end

   //Pipeline flush unsets fetch.
   always @(posedge clk)
      if (f_past_valid && $past(pipeline_flush_i))
         assert (!fetch_valid_o);

   //If pipeline is stalled then pc_decode_o and decode_insn_o are expected not to change.
   always @(posedge clk) begin
      if (f_past_valid && $past(fetch_valid_o) && fetch_valid_o &&
          $past(stall_fetch_valid) && !$past(flushing | imem_err) && !$past(rst)) begin
         assert ($stable(pc_decode_o));
         assert ($stable(decode_insn_o));
      end
   end

   //Checking pc update after every fetch excluding jump instructions.
   reg f_last_pc_valid = 1'b0;
   always @(posedge clk)
      if (rst || pipeline_flush_i || !(bus_access_done & padv_i &&
          !mispredict_stall & !immu_busy & !tlb_reload_busy | stall_fetch_valid))
         f_last_pc_valid <= 1'b0;
      else if (fetch_valid_o)
         f_last_pc_valid <= 1'b1;

   reg [OPTION_OPERAND_WIDTH-1:0] f_last_pc;
   always @(posedge clk)
      if (fetch_valid_o && f_past_valid)
         f_last_pc <= pc_decode_o;
      else if (f_last_pc_valid && f_past_valid)
         assert (pc_decode_o == f_last_pc + 4);

   //Fetched instructions has to be flushed if branch exception occurs.
   always @(posedge clk)
      if (f_past_valid && $rose(ctrl_branch_exception_i) && !$past(rst))
          assert (flushing);

   //Fetch exception has to be taken only for one clock cycle.
   always @(posedge clk)
      if (f_past_valid && $past(fetch_exception_taken_o))
          assert (!fetch_exception_taken_o);

   //Fetch exception is taken only if there is branch exception in the previous clock cycle.
   always @(posedge clk)
      if (fetch_exception_taken_o && f_past_valid)
          assert ($past(ctrl_branch_exception_i));

   //Branch misprediction should insert stall in the pipeline.
   always @(posedge clk)
      if (branch_mispredict_i && fetching_brcond && branch_mispredict_i && f_past_valid)
          assert (mispredict_stall);

`ifdef FETCH

   (* anyconst *) reg [OPTION_OPERAND_WIDTH-1:0] f_const_pc;
   (* anyconst *) reg [`OR1K_INSN_WIDTH-1:0] f_const_insn;

   reg f_fetch_read;
   initial f_fetch_read = 1'b0;

   //Walk through instruction fetch with f_pc_address with mmu enabled.
   always @(posedge clk) begin
      if (f_past_valid && !$past(rst) && $past(f_const_pc == du_restart_pc_i)
          && $past(du_restart_i) && $past(padv_i) && $past(ibus_access) &&
          !$past(ibus_ack) & !$past(imem_err) && !$past(tlb_reload_req) &&
          $past(immu_enable_i) && ibus_dat_i == f_const_insn && !$past(nop_ack)
          && !$past(tlb_miss) && !$past(pagefault) && !$past(immu_busy) &&
          $past(state == IDLE)) begin
         assert (pc_fetch == f_const_pc);
         assert ($past(immu_phys_addr) == ibus_adr);
         assert (state == READ);
         f_fetch_read <= 1'b1;
      end
   end

   reg f_imem_read;
   initial f_imem_read = 1'b0;

   // Expecting imem_dat has the same instruction that we had in ibus.
   always @(posedge clk) begin
      if (f_past_valid && $rose(f_fetch_read) && !except_ipagefault &&
          !except_itlb_miss && !nop_ack && ibus_access) begin
         assert (ibus_dat == f_const_insn);
         f_imem_read = 1'b1;
         assert (imem_dat == f_const_insn);
      end
   end

   always @(posedge clk) begin
      if (f_past_valid && $rose(f_imem_read) && !$past(imem_err) && !$past(flushing)
          && $past(bus_access_done) && $past(padv_i) && !$past(mispredict_stall)
          && !$past(rst) && $past(du_restart_i) && !$past(addr_valid)) begin
         assert (decode_insn_o == f_const_insn);
         assert (pc_decode_o == f_const_pc);
       end
   end

`endif

   // When RFE trap is executed no other exceptions are allowed if HW_TLB_RELOAD disabled
   always @(posedge clk) begin
      if (f_past_valid && $past(doing_rfe_i) && !$past(tlb_reload_pagefault)
          && !$past(rst) && $past(except_ipagefault_clear)) begin
         assert (!decode_except_itlb_miss_o);
         assert (!decode_except_ipagefault_o);
      end
   end

   // ibus_error has to be passed as an input for decode stage.
   always @(posedge clk `OR_ASYNC_RST)
      if (f_past_valid && $past(ibus_err_i,2) && !$past(rst,2) && !$past(rst)
          && !$past(du_restart_i))
         assert (decode_except_ibus_err_o);

   //If immu_cache_inhibit_o is set by mmu, then access should not be given to instruction cache.
   always @(posedge clk)
      if (f_past_valid && immu_cache_inhibit && FEATURE_INSTRUCTIONCACHE != "NONE"
          && immu_enable_i)
         assert (!ic_access);

   //When ICACHE is refilling ibus_burst_o should be high
   always @(posedge clk)
      if (f_past_valid && !$past(rst) && ibus_burst_o)
         assert (!ic_refill_done);

   //Decode instruction should be stable if pipeline has not moved
   always @(posedge clk)
      if (f_past_valid && !$past(rst) && !$past(imem_err) && !$past(flushing) && !$past(padv_i))
         assert ($stable(decode_insn_o));

   //Decode PC shouldn't changed when pipeline hasn't advanced
   always @(posedge clk)
      if (f_past_valid && !$past(rst) && !$past(padv_i))
         assert ($stable(pc_decode_o));

   //Stall should always set padv_i low
   always @*
      if (stall_fetch_valid)
         assert (!padv_i);

   //Pagefault exception should be forwarded to decode stage in the next clock cycle
   always @(posedge clk)
      if (f_past_valid && !$past(rst) && $past(except_ipagefault) && !$past(du_restart_i))
         assert (decode_except_ipagefault_o);

   //ibus_err_i takes two clock cycles to forward error signal to decode
   always @(posedge clk)
      if (f_past_valid && !$past(rst,2) && !$past(rst) && $past(ibus_err_i,2) && !$past(du_restart_i))
         assert (decode_except_ibus_err_o);

`endif
endmodule // mor1kx_fetch_cappuccino
