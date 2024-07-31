/* ****************************************************************************
  SPDX-License-Identifier: CERN-OHL-W-2.0

  Description: Register file for cappuccino pipeline
  Handles reading the register file rams and register bypassing.

  Copyright (C) 2012 Authors

  Author(s): Julius Baxter <juliusbaxter@gmail.com>
             Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>

***************************************************************************** */

`include "mor1kx-defines.v"

module mor1kx_rf_cappuccino
  #(
    parameter FEATURE_FASTCONTEXTS = "NONE",
    parameter OPTION_RF_CLEAR_ON_INIT = 0,
    parameter OPTION_RF_NUM_SHADOW_GPR = 0,
    parameter OPTION_RF_ADDR_WIDTH = 5,
    parameter OPTION_RF_WORDS = 32,
    parameter FEATURE_DEBUGUNIT = "NONE",
    parameter OPTION_OPERAND_WIDTH = 32
    )
   (
    input 			      clk,
    input 			      rst,

    // pipeline control signal in
    input 			      padv_decode_i,
    input 			      padv_ctrl_i,


    input 			      decode_valid_i,

    input 			      fetch_rf_adr_valid_i,

    // GPR numbers
    input [OPTION_RF_ADDR_WIDTH-1:0]  fetch_rfa_adr_i,
    input [OPTION_RF_ADDR_WIDTH-1:0]  fetch_rfb_adr_i,

    input [OPTION_RF_ADDR_WIDTH-1:0]  decode_rfa_adr_i,
    input [OPTION_RF_ADDR_WIDTH-1:0]  decode_rfb_adr_i,

    input [OPTION_RF_ADDR_WIDTH-1:0]  execute_rfd_adr_i,
    input [OPTION_RF_ADDR_WIDTH-1:0]  ctrl_rfd_adr_i,
    input [OPTION_RF_ADDR_WIDTH-1:0]  wb_rfd_adr_i,

    // SPR interface
    input [15:0] 		      spr_bus_addr_i,
    input 			      spr_bus_stb_i,
    input 			      spr_bus_we_i,
    input [OPTION_OPERAND_WIDTH-1:0]  spr_bus_dat_i,
    output 			      spr_gpr_ack_o,
    output [OPTION_OPERAND_WIDTH-1:0] spr_gpr_dat_o,

    // Write back signal indications
    input 			      execute_rf_wb_i,
    input 			      ctrl_rf_wb_i,
    input 			      wb_rf_wb_i,

    input [OPTION_OPERAND_WIDTH-1:0]  result_i,
    input [OPTION_OPERAND_WIDTH-1:0]  ctrl_alu_result_i,

    input 			      pipeline_flush_i,

    output [OPTION_OPERAND_WIDTH-1:0] decode_rfa_o,
    output [OPTION_OPERAND_WIDTH-1:0] decode_rfb_o,
    output [OPTION_OPERAND_WIDTH-1:0] execute_rfa_o,
    output [OPTION_OPERAND_WIDTH-1:0] execute_rfb_o
    );

`include "mor1kx_utils.vh"
   localparam RF_ADDR_WIDTH = calc_rf_addr_width(OPTION_RF_ADDR_WIDTH,
                                                 OPTION_RF_NUM_SHADOW_GPR);

   wire [OPTION_OPERAND_WIDTH-1:0]    rfa_ram_o;
   wire [OPTION_OPERAND_WIDTH-1:0]    rfb_ram_o;

   reg [OPTION_OPERAND_WIDTH-1:0]     wb_hazard_result;
   reg [OPTION_OPERAND_WIDTH-1:0]     execute_rfa;
   reg [OPTION_OPERAND_WIDTH-1:0]     execute_rfb;

   wire [RF_ADDR_WIDTH-1:0]           rfa_rdad;
   wire [RF_ADDR_WIDTH-1:0]           rfb_rdad;

   wire 			      rfa_rden;
   wire 			      rfb_rden;

   wire 			      rf_wren;
   wire [RF_ADDR_WIDTH-1:0] 	      rf_wradr;
   wire [OPTION_OPERAND_WIDTH-1:0]    rf_wrdat;

   reg 				      flushing;

   // Keep track of the flush signal, this is needed to not wrongly assert
   // execute_hazard after an exception (or rfe) has happened.
   // What happens in that case is that the instruction in execute stage is
   // invalid until the next padv_decode, so it's execute_rfd_adr can not be
   // used to evaluate the execute_hazard.
   always @(posedge clk)
     if (pipeline_flush_i)
       flushing <= 1;
     else if (padv_decode_i)
       flushing <= 0;

   // Detect hazards
   reg execute_hazard_a;
   reg execute_hazard_b;
   always @(posedge clk)
     if (pipeline_flush_i) begin
	execute_hazard_a <= 0;
	execute_hazard_b <= 0;
     end else if (padv_decode_i & !flushing) begin
	execute_hazard_a <= execute_rf_wb_i &
			    (execute_rfd_adr_i == decode_rfa_adr_i);
	execute_hazard_b <= execute_rf_wb_i &
			    (execute_rfd_adr_i == decode_rfb_adr_i);
     end

   reg [OPTION_OPERAND_WIDTH-1:0] execute_hazard_result_r;
   always @(posedge clk)
     if (decode_valid_i)
       execute_hazard_result_r <= ctrl_alu_result_i;

   wire [OPTION_OPERAND_WIDTH-1:0] execute_hazard_result;
   assign execute_hazard_result = decode_valid_i ? ctrl_alu_result_i :
				  execute_hazard_result_r;

   reg ctrl_hazard_a;
   reg ctrl_hazard_b;
   always @(posedge clk)
      if (padv_decode_i) begin
	 ctrl_hazard_a <= ctrl_rf_wb_i & (ctrl_rfd_adr_i == decode_rfa_adr_i);
	 ctrl_hazard_b <= ctrl_rf_wb_i & (ctrl_rfd_adr_i == decode_rfb_adr_i);
     end

   reg [OPTION_OPERAND_WIDTH-1:0] ctrl_hazard_result_r;
   always @(posedge clk)
     if (decode_valid_i)
       ctrl_hazard_result_r <= result_i;

   wire [OPTION_OPERAND_WIDTH-1:0] ctrl_hazard_result;
   assign ctrl_hazard_result = decode_valid_i ? result_i : ctrl_hazard_result_r;

   reg wb_hazard_a;
   reg wb_hazard_b;
   always @(posedge clk `OR_ASYNC_RST)
     if (rst) begin
	wb_hazard_a <= 0;
	wb_hazard_b <= 0;
     end else if (padv_decode_i) begin
	wb_hazard_a <= wb_rf_wb_i & (wb_rfd_adr_i == decode_rfa_adr_i);
	wb_hazard_b <= wb_rf_wb_i & (wb_rfd_adr_i == decode_rfb_adr_i);
     end

   always @(posedge clk)
     if (padv_decode_i)
       wb_hazard_result <= result_i;

   // Bypassing to decode stage
   //
   // Since the decode stage doesn't read from the register file, we have to
   // save any writes to the current read addresses in decode stage until
   // fetch latch in new values.
   // When fetch latch in the new values, and a writeback happens at the
   // same time, we bypass that value too.

   // Port A
   reg 				  use_last_wb_a;
   reg 				  wb_to_decode_bypass_a;
   reg [OPTION_OPERAND_WIDTH-1:0] wb_to_decode_result_a;
   always @(posedge clk)
     if (fetch_rf_adr_valid_i) begin
	wb_to_decode_result_a <= result_i;
	wb_to_decode_bypass_a <= wb_rf_wb_i & (wb_rfd_adr_i == fetch_rfa_adr_i);
	use_last_wb_a <= 0;
     end else if (wb_rf_wb_i) begin
	if (decode_rfa_adr_i == wb_rfd_adr_i) begin
	   wb_to_decode_result_a <= result_i;
	   use_last_wb_a <= 1;
	end
     end

   wire execute_to_decode_bypass_a;
   assign execute_to_decode_bypass_a = ctrl_rf_wb_i &
				       (ctrl_rfd_adr_i == decode_rfa_adr_i);

   wire ctrl_to_decode_bypass_a;
   assign ctrl_to_decode_bypass_a = use_last_wb_a | wb_rf_wb_i &
				    (wb_rfd_adr_i == decode_rfa_adr_i);

   wire [OPTION_OPERAND_WIDTH-1:0] ctrl_to_decode_result_a;
   assign ctrl_to_decode_result_a = use_last_wb_a ?
				  wb_to_decode_result_a : result_i;

   // Port B
   reg 				  use_last_wb_b;
   reg 				  wb_to_decode_bypass_b;
   reg [OPTION_OPERAND_WIDTH-1:0] wb_to_decode_result_b;
   always @(posedge clk)
     if (fetch_rf_adr_valid_i) begin
	wb_to_decode_result_b <= result_i;
	wb_to_decode_bypass_b <= wb_rf_wb_i & (wb_rfd_adr_i == fetch_rfb_adr_i);
	use_last_wb_b <= 0;
     end else if (wb_rf_wb_i) begin
	if (decode_rfb_adr_i == wb_rfd_adr_i) begin
	   wb_to_decode_result_b <= result_i;
	   use_last_wb_b <= 1;
	end
     end

   wire execute_to_decode_bypass_b;
   assign execute_to_decode_bypass_b = ctrl_rf_wb_i &
				       (ctrl_rfd_adr_i == decode_rfb_adr_i);

   wire ctrl_to_decode_bypass_b;
   assign ctrl_to_decode_bypass_b = use_last_wb_b | wb_rf_wb_i &
				    (wb_rfd_adr_i == decode_rfb_adr_i);

   wire [OPTION_OPERAND_WIDTH-1:0] ctrl_to_decode_result_b;
   assign ctrl_to_decode_result_b = use_last_wb_b ?
				  wb_to_decode_result_b : result_i;


   assign decode_rfa_o = execute_to_decode_bypass_a ? ctrl_alu_result_i :
			 ctrl_to_decode_bypass_a ? ctrl_to_decode_result_a :
			 wb_to_decode_bypass_a ? wb_to_decode_result_a :
			 rfa_ram_o;

   assign decode_rfb_o = execute_to_decode_bypass_b ? ctrl_alu_result_i :
			 ctrl_to_decode_bypass_b ? ctrl_to_decode_result_b :
			 wb_to_decode_bypass_b ? wb_to_decode_result_b :
			 rfb_ram_o;

   assign execute_rfa_o = execute_hazard_a ? execute_hazard_result :
			  ctrl_hazard_a ? ctrl_hazard_result :
			  wb_hazard_a ? wb_hazard_result :
			  execute_rfa;

   assign execute_rfb_o = execute_hazard_b ? execute_hazard_result :
			  ctrl_hazard_b ? ctrl_hazard_result :
			  wb_hazard_b ? wb_hazard_result :
			  execute_rfb;

   always @(posedge clk)
     if (padv_decode_i) begin
	execute_rfa <= decode_rfa_o;
	execute_rfb <= decode_rfb_o;
     end

generate
if (FEATURE_DEBUGUNIT!="NONE" || FEATURE_FASTCONTEXTS!="NONE" ||
    OPTION_RF_NUM_SHADOW_GPR > 0) begin
   wire 			   spr_gpr_we;
   wire 			   spr_gpr_re;
   assign spr_gpr_we = (spr_bus_addr_i[15:9] == 7'h2) &
		       spr_bus_stb_i & spr_bus_we_i;
   assign spr_gpr_re = (spr_bus_addr_i[15:9] == 7'h2) &
		       spr_bus_stb_i & !spr_bus_we_i & !padv_ctrl_i;

   reg 	spr_gpr_read_ack;
   always @(posedge clk)
     spr_gpr_read_ack <= spr_gpr_re;

   assign spr_gpr_ack_o = spr_gpr_we & !wb_rf_wb_i |
			  spr_gpr_re & spr_gpr_read_ack;

   wire [RF_ADDR_WIDTH-1:0] wb_rfd_adr_expand;
   assign wb_rfd_adr_expand[OPTION_RF_ADDR_WIDTH-1:0] = wb_rfd_adr_i;

   assign rf_wren =  wb_rf_wb_i | spr_gpr_we;
   assign rf_wradr = wb_rf_wb_i ? wb_rfd_adr_expand : spr_bus_addr_i[RF_ADDR_WIDTH-1:0];
   assign rf_wrdat = wb_rf_wb_i ? result_i : spr_bus_dat_i;

   // Zero-pad unused parts of vector
   if (OPTION_RF_NUM_SHADOW_GPR > 0) begin
      assign wb_rfd_adr_expand[RF_ADDR_WIDTH-1:OPTION_RF_ADDR_WIDTH] =
             {(RF_ADDR_WIDTH-OPTION_RF_ADDR_WIDTH){1'b0}};
      assign rfa_rdad[RF_ADDR_WIDTH-1:OPTION_RF_ADDR_WIDTH] =
             {(RF_ADDR_WIDTH-OPTION_RF_ADDR_WIDTH){1'b0}};
      assign rfb_rdad[RF_ADDR_WIDTH-1:OPTION_RF_ADDR_WIDTH] =
             {(RF_ADDR_WIDTH-OPTION_RF_ADDR_WIDTH){1'b0}};
   end

end else begin
   assign spr_gpr_ack_o = 1;

   assign rf_wren =  wb_rf_wb_i;
   assign rf_wradr = wb_rfd_adr_i;
   assign rf_wrdat = result_i;
end
endgenerate

   assign rfa_rdad[OPTION_RF_ADDR_WIDTH-1:0] = fetch_rfa_adr_i;
   assign rfb_rdad[OPTION_RF_ADDR_WIDTH-1:0] = fetch_rfb_adr_i;
   assign rfa_rden = fetch_rf_adr_valid_i;
   assign rfb_rden = fetch_rf_adr_valid_i;

   mor1kx_simple_dpram_sclk
     #(
       .ADDR_WIDTH	(RF_ADDR_WIDTH),
       .DATA_WIDTH	(OPTION_OPERAND_WIDTH),
       .CLEAR_ON_INIT   (OPTION_RF_CLEAR_ON_INIT),
       .ENABLE_BYPASS	(0)
       )
   rfa
     (
      .clk		(clk),
      .dout		(rfa_ram_o),
      .raddr		(rfa_rdad),
      .re		(rfa_rden),
      .waddr		(rf_wradr),
      .we		(rf_wren),
      .din		(rf_wrdat)
      );

   mor1kx_simple_dpram_sclk
     #(
       .ADDR_WIDTH	(RF_ADDR_WIDTH),
       .DATA_WIDTH	(OPTION_OPERAND_WIDTH),
       .CLEAR_ON_INIT   (OPTION_RF_CLEAR_ON_INIT),
       .ENABLE_BYPASS	(0)
       )
   rfb
     (
      .clk		(clk),
      .dout		(rfb_ram_o),
      .raddr		(rfb_rdad),
      .re		(rfb_rden),
      .waddr		(rf_wradr),
      .we		(rf_wren),
      .din		(rf_wrdat)
      );

generate
if (FEATURE_DEBUGUNIT!="NONE" || FEATURE_FASTCONTEXTS!="NONE" ||
    OPTION_RF_NUM_SHADOW_GPR > 0) begin : rfspr_gen
   mor1kx_simple_dpram_sclk
     #(
       .ADDR_WIDTH	(RF_ADDR_WIDTH),
       .DATA_WIDTH	(OPTION_OPERAND_WIDTH),
       .CLEAR_ON_INIT   (OPTION_RF_CLEAR_ON_INIT),
       .ENABLE_BYPASS	(0)
       )
   rfspr
     (
      .clk		(clk),
      .dout		(spr_gpr_dat_o),
      .raddr		(spr_bus_addr_i[RF_ADDR_WIDTH-1:0]),
      .re		(1'b1),
      .waddr		(rf_wradr),
      .we		(rf_wren),
      .din		(rf_wrdat)
      );
end else begin
   assign spr_gpr_dat_o = 0;
end
endgenerate

/*--------------Formal Checking---------------*/

`ifdef FORMAL

   reg f_past_valid;
   initial f_past_valid = 0;
   initial assume(rst);
   always @(posedge clk)
      f_past_valid <= 1;
   always @(*)
      if (!f_past_valid)
         assume (rst);

   //Execute register file should hold decode rf data if no hazards observed
   always @(posedge clk)
      if (f_past_valid && !$past(rst) && $past(padv_decode_i) &&
          !execute_hazard_a && !ctrl_hazard_a && !wb_hazard_a &&
          !execute_hazard_b && !ctrl_hazard_b && !wb_hazard_b) begin
         assert (execute_rfa_o == $past(decode_rfa_o));
         assert (execute_rfb_o == $past(decode_rfb_o));
      end

`endif
endmodule // mor1kx_rf_cappuccino
