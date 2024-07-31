/* ****************************************************************************
  SPDX-License-Identifier: CERN-OHL-W-2.0

  Description: Register file for espresso pipeline

  We get addresses for A and B read directly in from the instruction bus

  Copyright (C) 2012 Authors

  Author(s): Julius Baxter <juliusbaxter@gmail.com>

***************************************************************************** */

`include "mor1kx-defines.v"

module mor1kx_rf_espresso
  (/*AUTOARG*/
   // Outputs
   rfa_o, rfb_o,
   // Inputs
   clk, rst, rfd_adr_i, rfa_adr_i, rfb_adr_i, rf_we_i, rf_re_i,
   result_i
   );

   parameter OPTION_RF_ADDR_WIDTH = 5;
   parameter OPTION_RF_WORDS = 32;

   parameter OPTION_OPERAND_WIDTH = 32;

   input clk, rst;


   // GPR addresses
   // These two directly from insn bus
   input [OPTION_RF_ADDR_WIDTH-1:0]      rfd_adr_i;
   input [OPTION_RF_ADDR_WIDTH-1:0]      rfa_adr_i;
   // This one from the decode stage
   input [OPTION_RF_ADDR_WIDTH-1:0]      rfb_adr_i;

   // WE strobe from control stage
   input 				 rf_we_i;

   // Read enable strobe
   input 				 rf_re_i;

   input [OPTION_OPERAND_WIDTH-1:0] 	 result_i;


   output [OPTION_OPERAND_WIDTH-1:0] rfa_o;
   output [OPTION_OPERAND_WIDTH-1:0] rfb_o;

   wire [OPTION_OPERAND_WIDTH-1:0]   rfa_o_mux;
   wire [OPTION_OPERAND_WIDTH-1:0]   rfb_o_mux;


   wire [OPTION_OPERAND_WIDTH-1:0]   rfa_ram_o;
   wire [OPTION_OPERAND_WIDTH-1:0]   rfb_ram_o;

   reg [OPTION_OPERAND_WIDTH-1:0]    result_last;
   reg [OPTION_RF_ADDR_WIDTH-1:0]    rfd_last;
   reg [OPTION_RF_ADDR_WIDTH-1:0]    rfd_r;
   reg [OPTION_RF_ADDR_WIDTH-1:0]    rfa_r;
   reg [OPTION_RF_ADDR_WIDTH-1:0]    rfb_r;

   wire 			      rfa_o_use_last;
   wire 			      rfb_o_use_last;
   reg 				      rfa_o_using_last;
   reg 				      rfb_o_using_last;

   wire 			      rfa_rden;
   wire 			      rfb_rden;

   wire 			      rf_wren;

   // Read enables to make sure the last write-while-read propagates through
   // once the use_last signal goes away (we might rely on the value remaining
   // what it was, but the last registered result might get written again) so
   // this forces a read to get that value out.
   wire 			      rfa_rden_for_last;
   wire 			      rfb_rden_for_last;

   // Avoid read-write
   // Use when this instruction actually will write to its destination
   // register.
   assign rfa_o_use_last = (rfd_last == rfa_r);
   assign rfb_o_use_last = (rfd_last == rfb_r);

   assign rfa_o = rfa_o_use_last ? result_last : rfa_ram_o;

   assign rfb_o = rfb_o_use_last ? result_last : rfb_ram_o;

   assign rfa_rden_for_last = (rfa_o_use_last & !rf_re_i);
   assign rfb_rden_for_last = (rfb_o_use_last & !rf_re_i);

   assign rfa_rden = rf_re_i | rfa_rden_for_last;
   assign rfb_rden = rf_re_i | rfb_rden_for_last;

   assign rf_wren = rf_we_i;


   always @(posedge clk `OR_ASYNC_RST)
     if (rst) begin
	rfa_r <= 0;
	rfb_r <= 0;
	rfd_r <= 0;
     end
     else if (rf_re_i)
       begin
	  rfa_r <= rfa_adr_i;
	  rfb_r <= rfb_adr_i;
	  rfd_r <= rfd_adr_i;
       end

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       rfd_last <= 0;
     else if (rf_wren)
       rfd_last <= rfd_adr_i;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       result_last <= 0;
     else if (rf_wren)
       result_last <= result_i;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst) begin
	rfa_o_using_last <= 0;
	rfb_o_using_last <= 0;
     end
     else begin
	if (!rfa_o_using_last)
	  rfa_o_using_last <= rfa_o_use_last & !rfa_rden;
	else if (rfa_rden)
	  rfa_o_using_last <= 0;

	if (!rfb_o_using_last)
	  rfb_o_using_last <= rfb_o_use_last & !rfb_rden;
	else if (rfb_rden)
	  rfb_o_using_last <= 0;
     end

   mor1kx_simple_dpram_sclk
     #(
       .ADDR_WIDTH	(OPTION_RF_ADDR_WIDTH),
       .DATA_WIDTH	(OPTION_OPERAND_WIDTH),
       .ENABLE_BYPASS	(0)
       )
   rfa
     (
      .clk		(clk),
      .dout		(rfa_ram_o),
      .raddr		(rfa_adr_i),
      .re		(rfa_rden),
      .waddr		(rfd_adr_i),
      .we		(rf_wren),
      .din		(result_i)
      );

   mor1kx_simple_dpram_sclk
     #(
       .ADDR_WIDTH	(OPTION_RF_ADDR_WIDTH),
       .DATA_WIDTH	(OPTION_OPERAND_WIDTH),
       .ENABLE_BYPASS	(0)
       )
   rfb
     (
      .clk		(clk),
      .dout		(rfb_ram_o),
      .raddr		(rfb_adr_i),
      .re		(rfb_rden),
      .waddr		(rfd_adr_i),
      .we		(rf_wren),
      .din		(result_i)
      );

endmodule // mor1kx_execute_alu
