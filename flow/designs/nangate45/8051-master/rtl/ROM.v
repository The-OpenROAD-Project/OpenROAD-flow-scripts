`timescale 1ns / 1ps

module ROM(
	input clk,
	input [13:0] addr0,
	input [13:0] addr1,
	input [13:0] addr2,
	input [13:0] addr3,
	output reg [7:0] data0,
	output reg [7:0] data1,
	output reg [7:0] data2,
	output reg [7:0] data3
	);

//Bank 0
always @(*)
	case (addr0)
		13'h0: data0 = 8'h75;
		13'h1: data0 = 8'h71;
		13'h2: data0 = 8'h09;
		13'h3: data0 = 8'h7D;
		13'h4: data0 = 8'h79;
		13'h5: data0 = 8'hC3;
		13'h6: data0 = 8'h04;
		13'h7: data0 = 8'h1E;
		13'h8: data0 = 8'hF3;
		13'h9: data0 = 8'h60;
		default: data0 = 8'h00;
	endcase

//Bank 1
always @(*)
	case (addr1)
		13'h0: data1 = 8'h70;
		13'h1: data1 = 8'hFD;
		13'h2: data1 = 8'h75;
		13'h3: data1 = 8'h00;
		13'h4: data1 = 8'h70;
		13'h5: data1 = 8'hE7;
		13'h6: data1 = 8'h0D;
		13'h7: data1 = 8'h0E;
		13'h8: data1 = 8'h8D;
		13'h9: data1 = 8'h80;
		default: data1 = 8'h00;
	endcase

//Bank 2
always @(*)
	case (addr2)
		13'h0: data2 = 8'h03;
		13'h1: data2 = 8'h75;
		13'h2: data2 = 8'h73;
		13'h3: data2 = 8'h7E;
		13'h4: data2 = 8'h7A;
		13'h5: data2 = 8'h33;
		13'h6: data2 = 8'h02;
		13'h7: data2 = 8'h09;
		13'h8: data2 = 8'h50;
		13'h9: data2 = 8'hFE;
		default: data2 = 8'h00;
	endcase

//Bank 3
always @(*)
	case (addr3)
		13'h0: data3 = 8'h75;
		13'h1: data3 = 8'h72;
		13'h2: data3 = 8'h71;
		13'h3: data3 = 8'h00;
		13'h4: data3 = 8'h04;
		13'h5: data3 = 8'h50;
		13'h6: data3 = 8'h00;
		13'h7: data3 = 8'hDA;
		13'h8: data3 = 8'h8E;
		default: data3 = 8'h00;
	endcase

endmodule
