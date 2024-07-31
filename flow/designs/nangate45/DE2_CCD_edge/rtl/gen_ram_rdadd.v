`timescale 1ns / 1ps
module gen_ram_rdadd (
	clk,
	aclr,
	rama_rden, 
	ramb_rden,
	rama_rdadd,
	ramb_rdadd
	);

	input clk, aclr;
	input rama_rden, ramb_rden;
	output [10:0] rama_rdadd, ramb_rdadd;

	//Register Declaration
	reg [10:0] rama_rdadd, ramb_rdadd;
	
	//parameter column_size=12,row_size=10;//·ÂÕæÊ±ÓÃ
	parameter column_size=1280,row_size=1024;
	
always @ (posedge clk or negedge aclr)
begin
	if (!aclr)
		rama_rdadd <= 0;
	else if (rama_rden)
		if(rama_rdadd==column_size-1)
         rama_rdadd<=0;
		else
			rama_rdadd <= rama_rdadd + 1;
end
	
always @ (posedge clk or negedge aclr)
begin
	if (!aclr)
		ramb_rdadd <= 0;
	else if (ramb_rden)
		if(ramb_rdadd==column_size-1)
         ramb_rdadd<=0;
		else
			ramb_rdadd <= ramb_rdadd + 1;
end
endmodule
