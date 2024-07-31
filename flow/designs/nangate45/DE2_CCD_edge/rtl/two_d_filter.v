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

module two_d_filter(
	aclr,
	data_valid_in,
	clk,
	//clken,
	coef1_1,
	coef1_2,
	coef1_3,
	coef2_1,
	coef2_2,
	coef2_3,
	coef3_1,
	coef3_2,
	coef3_3,
	data,
   row1_1,
   row1_2,
   row1_3,
   row2_1,
   row2_2,
   row2_3,
   row3_1,
   row3_2,
   row3_3,
	data_valid_out,
   result
	
);

	input	aclr;
	input	data_valid_in;
	input	clk;
	//input	clken;
	input	[9:0] coef1_1;
	input	[9:0] coef1_2;
	input	[9:0] coef1_3;
	input	[9:0] coef2_1;
	input	[9:0] coef2_2;
	input	[9:0] coef2_3;
	input	[9:0] coef3_1;
	input	[9:0] coef3_2;
	input	[9:0] coef3_3;
	input	[9:0] data;
	output	[23:0] result;
	output [9:0] row1_1, row1_2, row1_3;
	output [9:0] row2_1, row2_2, row2_3;
	output [9:0] row3_1, row3_2, row3_3;
	output data_valid_out;
	
	reg data_valid_out;
	wire	data_end;
	wire	[9:0] rama;
	wire	[9:0] rama_rdadd;
	wire	rama_rden;
	wire	[9:0] rama_wradd;
	wire	rama_wren;
	wire	[9:0] ramb;
	wire	[9:0] ramb_rdadd;
	wire	ramb_rden;
	wire	[9:0] ramb_wradd;
	wire	ramb_wren;
	wire	[9:0] ramc;
	wire	[9:0] ramc_rdadd;
	wire	ramc_rden;
	wire	[9:0] ramc_wradd;
	wire	ramc_wren;
	wire	row_end;
	wire	[1:0] sel_row1;
	wire	[1:0] sel_row2;
	wire	[1:0] sel_row3;
	wire  [9:0] row1_1, row1_2, row1_3;
	wire  [9:0] row2_1, row2_2, row2_3;
	wire  [9:0] row3_1, row3_2, row3_3;



	ctrl b2v_inst (
								.aclr(aclr), 
								.data_valid_in(data_valid_in), 
								.clk(clk), 
								.frame_end_rd(frame_end), 
								.rama_rden(rama_rden), 
								.ramb_rden(ramb_rden), 
								.ramc_rden(ramc_rden), 
								.rama_wren(rama_wren), 
								.ramb_wren(ramb_wren), 
								.ramc_wren(ramc_wren), 
								.row_end_rd(row_end), 
								.rama_rdadd(rama_rdadd), 
								.rama_wradd(rama_wradd), 
								.ramb_rdadd(ramb_rdadd), 
								.ramb_wradd(ramb_wradd), 
								.ramc_rdadd(ramc_rdadd), 
								.ramc_wradd(ramc_wradd), 
								.sel_row1_out(sel_row1), 
								.sel_row2_out(sel_row2), 
								.sel_row3_out(sel_row3)
							);

	ram	b2v_inst2(	.clk(clk),
								.rama_wren(rama_wren),
								.rama_rden(rama_rden),
								.ramb_wren(ramb_wren),
								.ramb_rden(ramb_rden),
								.ramc_wren(ramc_wren),
								.ramc_rden(ramc_rden),
								.datain(data),
								.rama_rdadd(rama_rdadd),
								.rama_wradd(rama_wradd),
								.ramb_rdadd(ramb_rdadd),
								.ramb_wradd(ramb_wradd),
								.ramc_rdadd(ramc_rdadd),
								.ramc_wradd(ramc_wradd),
								.rama(rama),
								.ramb(ramb),
								.ramc(ramc));

	mux_row	b2v_inst1(	.clk(clk),
									.aclr(aclr),
									.row_end(row_end),
									.rama(rama),
									.ramb(ramb),
									.ramc(ramc),
									.sel_row1(sel_row1),
									.sel_row2(sel_row2),
									.sel_row3(sel_row3),
									.row1_1(row1_1),
									.row1_2(row1_2),
									.row1_3(row1_3),
									.row2_1(row2_1),
									.row2_2(row2_2),
									.row2_3(row2_3),
									.row3_1(row3_1),
									.row3_2(row3_2),
									.row3_3(row3_3));


filter	b2v_inst4(.clk(clk),
						 .aclr(!aclr),
						 .clken(1),
						 .coef1_1(coef1_1),
						 .coef1_2(coef1_2),
						 .coef1_3(coef1_3),
						 .coef2_1(coef2_1),
						 .coef2_2(coef2_2),
						 .coef2_3(coef2_3),
						 .coef3_1(coef3_1),
						 .coef3_2(coef3_2),
						 .coef3_3(coef3_3),
						 .row1_1(row1_1),
						 .row1_2(row1_2),
						 .row1_3(row1_3),
						 .row2_1(row2_1),
						 .row2_2(row2_2),
						 .row2_3(row2_3),
						 .row3_1(row3_1),
						 .row3_2(row3_2),
						 .row3_3(row3_3),
						 .result(result));
	reg rama_rden_dly1,rama_rden_dly2,rama_rden_dly3,rama_rden_dly4,rama_rden_dly5,rama_rden_dly6,rama_rden_dly7;
	always@(posedge clk or negedge aclr)
	if(!aclr)
	begin
		rama_rden_dly1<=0;
		rama_rden_dly2<=0;
		rama_rden_dly3<=0;
		rama_rden_dly4<=0;
		data_valid_out<=0;
	end	
	else
	begin
		rama_rden_dly1<=rama_rden;
		rama_rden_dly2<=rama_rden_dly1;
		rama_rden_dly3<=rama_rden_dly2;
		rama_rden_dly4<=rama_rden_dly3;
		rama_rden_dly5<=rama_rden_dly4;
		rama_rden_dly6<=rama_rden_dly5;
		rama_rden_dly7<=rama_rden_dly6;
		data_valid_out<=rama_rden_dly7;
	end


endmodule


