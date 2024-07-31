`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:04:36 05/29/2007 
// Design Name: 
// Module Name:    RAW2RGB 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module RAW2RGB(
	aclr,
	data_valid,
	clk,
	//clken,
	data,
	data_valid_out,
	r_out,
	g_out,
	b_out
);

input	aclr;
input	data_valid;
input	clk;
//input	clken;

input	[9:0] data;

output data_valid_out;
output [9:0] r_out;
output [9:0] g_out;
output [9:0] b_out;


wire	data_end;
wire	[9:0] rama;
wire	[10:0] rama_rdadd;
wire	rama_rden;
wire	[10:0] rama_wradd;
wire	rama_wren;
wire	[9:0] ramb;
wire	[10:0] ramb_rdadd;
wire	ramb_rden;
wire	[10:0] ramb_wradd;
wire	ramb_wren;

wire	row_end;
wire    sel_row1;
wire	sel_row2;

wire    [9:0] row1_1, row1_2;
wire    [9:0] row2_1, row2_2;

reg data_valid_dly1,data_valid_dly2,data_valid_dly3,data_valid_dly4,data_valid_out;
reg [9:0] r,b;
reg [10:0] g;

control	b2v_inst(.clk(clk),
						.aclr(aclr),
						.data_valid(data_valid),
						.rama_wren(rama_wren),
						.ramb_wren(ramb_wren),
						.rama_rden(rama_rden),
						.ramb_rden(ramb_rden),
						.row_end(row_end),
						.rama_rdadd(rama_rdadd),
						.rama_wradd(rama_wradd),
						.ramb_rdadd(ramb_rdadd),
						.ramb_wradd(ramb_wradd),
						.sel_row1(sel_row1),
						.sel_row2(sel_row2));

buffer	b2v_inst2(.clk(clk),
						 .rama_wren(rama_wren),
						 .rama_rden(rama_rden),
						 .ramb_wren(ramb_wren),
						 .ramb_rden(ramb_rden),
						 .datain(data),
						 .rama_rdadd(rama_rdadd),
						 .rama_wradd(rama_wradd),
						 .ramb_rdadd(ramb_rdadd),
						 .ramb_wradd(ramb_wradd),
						 .rama(rama),
						 .ramb(ramb));

mux_ram_row	b2v_inst1(.clk(clk),
							 .aclr(aclr),
							 .row_end(row_end),
							 .rama(rama),
							 .ramb(ramb),
							 .sel_row1(sel_row1),
							 .sel_row2(sel_row2),
							 .row1_1(row1_1),
							 .row1_2(row1_2),
							 .row2_1(row2_1),
							 .row2_2(row2_2));

always@(posedge clk or negedge aclr)
begin
	if(!aclr)
	begin

		data_valid_dly1<=0;
		data_valid_dly2<=0;
		data_valid_dly3<=0;
	end
	else 
	begin
	   data_valid_dly1<=rama_rden;
		data_valid_dly2<=data_valid_dly1;
		data_valid_dly3<=data_valid_dly2;	
	end
end
always@(posedge clk or negedge aclr)
begin
	if(!aclr)
		data_valid_dly4<=0;
	else if(data_valid_dly2)
		data_valid_dly4<=!data_valid_dly4;	
end
always@(posedge clk or negedge aclr)
begin
	if(!aclr)
	begin
		r<=0;
		g<=0;
		b<=0;
		data_valid_out<=0;
	end
	else 
	begin
		r<=row1_2;
		g<=row1_1+row2_2;
		b<=row2_1;
		//r<=row2_2;
		//g<=row1_2+row2_1;
		//b<=row1_1;
		data_valid_out<=data_valid_dly4;
	end
end
assign r_out=r;
assign g_out=g[10:1];
assign b_out=b;
endmodule
