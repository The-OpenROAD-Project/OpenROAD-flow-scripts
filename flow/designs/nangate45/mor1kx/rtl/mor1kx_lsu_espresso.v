/* ****************************************************************************
  SPDX-License-Identifier: CERN-OHL-W-2.0

  Description:  Load, store unit for espresso pipeline

  All combinatorial outputs to pipeline
  Dbus interface request signal out synchronous

  32-bit specific due to sign extension of results

  Copyright (C) 2012 Authors

   Author(s): Julius Baxter <juliusbaxter@gmail.com>

***************************************************************************** */

`include "mor1kx-defines.v"

module mor1kx_lsu_espresso
  (/*AUTOARG*/
   // Outputs
   lsu_result_o, lsu_valid_o, lsu_except_dbus_o, lsu_except_align_o,
   dbus_adr_o, dbus_req_o, dbus_dat_o, dbus_bsel_o, dbus_we_o,
   dbus_burst_o,
   // Inputs
   clk, rst, padv_fetch_i, lsu_adr_i, rfb_i, op_lsu_load_i,
   op_lsu_store_i, lsu_length_i, lsu_zext_i, exception_taken_i,
   du_restart_i, stepping_i, next_fetch_done_i, dbus_err_i,
   dbus_ack_i, dbus_dat_i
   );

   parameter OPTION_OPERAND_WIDTH = 32;
   parameter OPTION_REGISTERED_IO = "NO";

   input clk, rst;

   input padv_fetch_i;
   // calculated address from ALU
   input [OPTION_OPERAND_WIDTH-1:0] lsu_adr_i;

   // register file B in (store operand)
   input [OPTION_OPERAND_WIDTH-1:0] rfb_i;
   // from decode stage regs, indicate if load or store
   input 			    op_lsu_load_i;
   input 			    op_lsu_store_i;
   input [1:0] 			    lsu_length_i;
   input 			    lsu_zext_i;

   input 			    exception_taken_i;
   input 			    du_restart_i;
   input 			    stepping_i;
   input 			    next_fetch_done_i;


   output [OPTION_OPERAND_WIDTH-1:0] lsu_result_o;
   output 			     lsu_valid_o;
   // exception output
   output 			     lsu_except_dbus_o;
   output 			     lsu_except_align_o;

   // interface to data bus
   output [OPTION_OPERAND_WIDTH-1:0] dbus_adr_o;
   output 			     dbus_req_o;
   output [OPTION_OPERAND_WIDTH-1:0] dbus_dat_o;
   output [3:0] 		     dbus_bsel_o;
   output 			     dbus_we_o;
   output 			     dbus_burst_o;
   input 			     dbus_err_i;
   input 			     dbus_ack_i;
   input [OPTION_OPERAND_WIDTH-1:0]  dbus_dat_i;

   reg [OPTION_OPERAND_WIDTH-1:0]    dbus_dat_aligned;  // comb.
   reg [OPTION_OPERAND_WIDTH-1:0]    dbus_dat_extended; // comb.


   reg [OPTION_OPERAND_WIDTH-1:0]    dbus_adr_r;

   reg [3:0] 			     dbus_bsel;

   reg 				     dbus_err_r;

   reg 				     access_done;

   reg [OPTION_OPERAND_WIDTH-1:0]    lsu_result_r;

   reg 				     op_lsu;

   wire 			     align_err_word;
   wire 			     align_err_short;

   wire 			     align_err;

   wire 			     except_align;
   reg 				     except_align_r;

   reg 				     except_dbus;
   reg 				     execute_go;

   assign dbus_dat_o = (lsu_length_i == 2'b00) ? // byte access
		       {rfb_i[7:0],rfb_i[7:0],rfb_i[7:0],rfb_i[7:0]} :
		       (lsu_length_i == 2'b01) ? // halfword access
		       {rfb_i[15:0],rfb_i[15:0]} :
		       rfb_i;                    // word access

   assign align_err_word = |dbus_adr_o[1:0];
   assign align_err_short = dbus_adr_o[0];


   assign lsu_valid_o = dbus_ack_i | dbus_err_r| access_done;
   assign lsu_except_dbus_o = dbus_err_r | except_dbus;

   assign align_err = (lsu_length_i == 2'b10) & align_err_word |
		      (lsu_length_i == 2'b01) & align_err_short;

   assign lsu_except_align_o = except_align_r;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       execute_go <= 0;
     else
       execute_go <= padv_fetch_i | (stepping_i & next_fetch_done_i);

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       access_done <= 0;
     else if (padv_fetch_i | du_restart_i)
       access_done <= 0;
     else if (dbus_ack_i | dbus_err_r | lsu_except_align_o)
       access_done <= 1;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       except_align_r <= 0;
     else if (exception_taken_i)
       except_align_r <= 0;
     else
       except_align_r <= except_align;

   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       except_dbus <= 0;
     else if (exception_taken_i)
       except_dbus <= 0;
     else if (dbus_err_r)
       except_dbus <= 1;

   // Need to register address due to behavior of RF when source register is
   // same as destination register - value changes after one cycle to the
   // forwarding register's value, which is incorrect.
   // So we save it on first cycle.
   // TODO - perhaps detect in RF when this is case, and make it keep the
   // output steady to avoid an extra address registering stage here.
   always @(posedge clk `OR_ASYNC_RST)
     if (rst)
       dbus_adr_r <= 0;
     else if (execute_go & (op_lsu_load_i | op_lsu_store_i))
       dbus_adr_r <= lsu_adr_i;

   // Big endian bus mapping
   always @(*)
     case (lsu_length_i)
       2'b00: // byte access
	 case(dbus_adr_o[1:0])
	   2'b00:
	     dbus_bsel = 4'b1000;
	   2'b01:
	     dbus_bsel = 4'b0100;
	   2'b10:
	     dbus_bsel = 4'b0010;
	   2'b11:
	     dbus_bsel = 4'b0001;
	 endcase
       2'b01: // halfword access
	    case(dbus_adr_o[1])
	      1'b0:
		dbus_bsel = 4'b1100;
	      1'b1:
		dbus_bsel = 4'b0011;
	    endcase
       2'b10,
       2'b11:
	 dbus_bsel = 4'b1111;
     endcase

   assign dbus_bsel_o = dbus_bsel;

   assign dbus_we_o =  op_lsu_store_i;

   // Select part of read word
   // Can use registered address here, as it'll take at least one cycle for
   // the data to come back, and by that time dbus_adr_r has the address
   always @*
     case(dbus_adr_r[1:0])
       2'b00:
	 dbus_dat_aligned = dbus_dat_i;
       2'b01:
	 dbus_dat_aligned = {dbus_dat_i[23:0],8'd0};
       2'b10:
	 dbus_dat_aligned = {dbus_dat_i[15:0],16'd0};
       2'b11:
	 dbus_dat_aligned = {dbus_dat_i[7:0],24'd0};
     endcase // case (dbus_adr_r[1:0])

   // Do appropriate extension
   always @(*)
     case({lsu_zext_i, lsu_length_i})
       3'b100: // lbz
	 dbus_dat_extended = {24'd0,dbus_dat_aligned[31:24]};
       3'b101: // lhz
	 dbus_dat_extended = {16'd0,dbus_dat_aligned[31:16]};
       3'b000: // lbs
	 dbus_dat_extended = {{24{dbus_dat_aligned[31]}},
			      dbus_dat_aligned[31:24]};
       3'b001: // lhs
	 dbus_dat_extended = {{16{dbus_dat_aligned[31]}},
			      dbus_dat_aligned[31:16]};
       default:
	 dbus_dat_extended = dbus_dat_aligned;
     endcase

   // Register result incase writeback doesn't occur for a few cycles
   // TODO - remove this - we should write straight into the RF!
   always @(posedge clk)
     if (dbus_ack_i & op_lsu_load_i)
       lsu_result_r <= dbus_dat_extended;

   assign dbus_burst_o = 0;

   // Break up paths of signals which are usually pretty long
   generate
      if (OPTION_REGISTERED_IO!="NO")
	begin : registered_io

	   assign dbus_adr_o = dbus_adr_r;

	   always @(posedge clk)
	     begin
		dbus_err_r <= dbus_err_i;
		op_lsu <=  op_lsu_load_i | op_lsu_store_i;
	     end

	   // Make sure padv_i isn't high because we'll be registering the
	   // fact that this cycle is an LSU op while it is
	   assign dbus_req_o = !execute_go & op_lsu &
			       !(except_align | except_align_r) &
			       !access_done;

	   assign except_align = op_lsu & (op_lsu_load_i | op_lsu_store_i) &
				 align_err & !execute_go;

	end
      else
	begin : nonregistered_io

	   assign dbus_adr_o = execute_go ? lsu_adr_i : dbus_adr_r;

	   always @*
	     begin
		dbus_err_r = dbus_err_i;
		op_lsu =  op_lsu_load_i | op_lsu_store_i;
	     end

	   assign dbus_req_o = op_lsu & !except_align & !access_done;

	   assign except_align = op_lsu & align_err;

	end
   endgenerate

   assign lsu_result_o = access_done ? lsu_result_r : dbus_dat_extended;

endmodule // mor1kx_lsu
