// Copyright (C) 1991-2002 Altera Corporation
// Any  megafunction  design,  and related netlist (encrypted  or  decrypted),
// support information,  device programming or simulation file,  and any other
// associated  documentation or information  provided by  Altera  or a partner
// under  Altera's   Megafunction   Partnership   Program  may  be  used  only
// to program  PLD  devices (but not masked  PLD  devices) from  Altera.   Any
// other  use  of such  megafunction  design,  netlist,  support  information,
// device programming or simulation file,  or any other  related documentation
// or information  is prohibited  for  any  other purpose,  including, but not
// limited to  modification,  reverse engineering,  de-compiling, or use  with
// any other  silicon devices,  unless such use is  explicitly  licensed under
// a separate agreement with  Altera  or a megafunction partner.  Title to the
// intellectual property,  including patents,  copyrights,  trademarks,  trade
// secrets,  or maskworks,  embodied in any such megafunction design, netlist,
// support  information,  device programming or simulation file,  or any other
// related documentation or information provided by  Altera  or a megafunction
// partner, remains with Altera, the megafunction partner, or their respective
// licensors. No other licenses, including any licenses needed under any third
// party's intellectual property, are provided herein.
`timescale 1ns/1ps
module control(
	aclr,
	data_valid,
	clk,
	frame_end,
	rama_rden,
	ramb_rden,

	rama_wren,
	ramb_wren,

	row_end,
	rama_rdadd,
	rama_wradd,
	ramb_rdadd,
	ramb_wradd,

	sel_row1,
	sel_row2

);

	input	aclr;
	input	data_valid;
	input	clk;
	output	frame_end;
	output	rama_rden;
	output	ramb_rden;

	output	rama_wren;
	output	ramb_wren;

	output	row_end;
	output	[10:0] rama_rdadd;
	output	[10:0] rama_wradd;
	output	[10:0] ramb_rdadd;
	output	[10:0] ramb_wradd;
	output  sel_row1,sel_row2;

	gen_ram_rdadd	b2v_gen_ram_rdadd_u1(.clk(clk),
													.aclr(aclr),
													.rama_rden(rama_rden),
													.ramb_rden(ramb_rden),
													.rama_rdadd(rama_rdadd),
													.ramb_rdadd(ramb_rdadd));

	gen_ram_rden	b2v_gen_ram_rden_u1(.clk(clk),
												  .aclr(aclr),
												  .rama_wren(rama_wren),
												  .ramb_wren(ramb_wren),
												  .rama_rden(rama_rden),
												  .ramb_rden(ramb_rden),
												  .frame_end(frame_end),
												  .sel_row1_out(sel_row1),
												  .sel_row2_out(sel_row2),
												  .row_end(row_end));

	gen_ram_wradd	b2v_gen_ram_wradd_u1(.clk(clk),
													.aclr(aclr),
													.rama_wren(rama_wren),
													.ramb_wren(ramb_wren),
													.rama_wradd(rama_wradd),
													.ramb_wradd(ramb_wradd));

	gen_ram_wren	b2v_gen_ram_wren_u1(.clk(clk),
												  .aclr(aclr),
												  .data_valid(data_valid),
												  .rama_wren(rama_wren),
												  .ramb_wren(ramb_wren));

endmodule
