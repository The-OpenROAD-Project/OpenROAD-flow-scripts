`timescale 1ns / 1ps
module gen_ram_wradd (
	clk,
	aclr,
	rama_wren, 
	ramb_wren,
	rama_wradd,
	ramb_wradd
	);

	input clk, aclr;
	input rama_wren, ramb_wren;
	output [10:0] rama_wradd, ramb_wradd;
	
	//parameter column_size=12,row_size=10;
	parameter column_size=1280,row_size=1024;
	
	//Register Declaration
	reg [10:0] rama_wradd, ramb_wradd;
	
always @ (posedge clk or negedge aclr)
begin
	if (!aclr)
		rama_wradd <= 0;
	else if (rama_wren)
		if(rama_wradd==column_size-1)
         rama_wradd<=0;
		else
			rama_wradd <= rama_wradd + 1;
end
	
always @ (posedge clk or negedge aclr)
begin
	if (!aclr)
		ramb_wradd <= 0;
	else if (ramb_wren)
		if(ramb_wradd==column_size-1)
         ramb_wradd<=0;
		else
			ramb_wradd <= ramb_wradd + 1;
end
endmodule
