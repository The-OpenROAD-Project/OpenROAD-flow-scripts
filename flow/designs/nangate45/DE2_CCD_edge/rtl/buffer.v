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

module buffer(
	clk,
	rama_wren,
	rama_rden,
	ramb_wren,
	ramb_rden,

	datain,
	rama_rdadd,
	rama_wradd,
	ramb_rdadd,
	ramb_wradd,

	rama,
	ramb

);

	input	clk;
	input	rama_wren;
	input	rama_rden;
	input	ramb_wren;
	input	ramb_rden;

	input	[9:0] datain;
	input	[10:0] rama_rdadd;
	input	[10:0] rama_wradd;
	input	[10:0] ramb_rdadd;
	input	[10:0] ramb_wradd;

	output	[9:0] rama;
	output	[9:0] ramb;

	reg	[9:0] SYNTHESIZED_WIRE_3;



always@(posedge clk)
begin

	SYNTHESIZED_WIRE_3[9] = datain[9];
	SYNTHESIZED_WIRE_3[8] = datain[8];
	SYNTHESIZED_WIRE_3[7] = datain[7];
	SYNTHESIZED_WIRE_3[6] = datain[6];
	SYNTHESIZED_WIRE_3[5] = datain[5];
	SYNTHESIZED_WIRE_3[4] = datain[4];
	SYNTHESIZED_WIRE_3[3] = datain[3];
	SYNTHESIZED_WIRE_3[2] = datain[2];
	SYNTHESIZED_WIRE_3[1] = datain[1];
	SYNTHESIZED_WIRE_3[0] = datain[0];

end

	ram_blk	b2v_RAM_A(.wren(rama_wren),.rden(rama_rden),.clock(clk),.data(SYNTHESIZED_WIRE_3),.rdaddress(rama_rdadd),.wraddress(rama_wradd),.q(rama));

	ram_blk	b2v_RAM_B(.wren(ramb_wren),.rden(ramb_rden),.clock(clk),.data(SYNTHESIZED_WIRE_3),.rdaddress(ramb_rdadd),.wraddress(ramb_wradd),.q(ramb));

endmodule
