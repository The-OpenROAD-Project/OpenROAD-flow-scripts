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

module ram(
					clk,
					rama_wren,
					rama_rden,
					ramb_wren,
					ramb_rden,
					ramc_wren,
					ramc_rden,
					datain,
					rama_rdadd,
					rama_wradd,
					ramb_rdadd,
					ramb_wradd,
					ramc_rdadd,
					ramc_wradd,
					rama,
					ramb,
					ramc
				 );

	input	clk;
	input	rama_wren;
	input	rama_rden;
	input	ramb_wren;
	input	ramb_rden;
	input	ramc_wren;
	input	ramc_rden;
	input	[9:0] datain;
	input	[9:0] rama_rdadd;
	input	[9:0] rama_wradd;
	input	[9:0] ramb_rdadd;
	input	[9:0] ramb_wradd;
	input	[9:0] ramc_rdadd;
	input	[9:0] ramc_wradd;
	output [9:0] rama;
	output [9:0] ramb;
	output [9:0] ramc;

	reg	[9:0] SYNTHESIZED_WIRE_3;

	always@(posedge clk)
	begin
		begin
		
		SYNTHESIZED_WIRE_3 <= datain;
		
		end
	end

	ram_block	b2v_RAM_A(	.wren(rama_wren),
								.rden(rama_rden),
								.clock(clk),
								.data(SYNTHESIZED_WIRE_3),
								.rdaddress(rama_rdadd),
								.wraddress(rama_wradd),
								.q(rama));

	ram_block	b2v_RAM_B(	.wren(ramb_wren),
								.rden(ramb_rden),
								.clock(clk),
								.data(SYNTHESIZED_WIRE_3),
								.rdaddress(ramb_rdadd),
								.wraddress(ramb_wradd),
								.q(ramb));

	ram_block	b2v_RAM_C(	.wren(ramc_wren),
								.rden(ramc_rden),
								.clock(clk),
								.data(SYNTHESIZED_WIRE_3),
								.rdaddress(ramc_rdadd),
								.wraddress(ramc_wradd),
								.q(ramc));




endmodule
