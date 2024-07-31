`timescale 1ns / 1ps
module INSTRUCTION_FETCH(
    input clk,
	 input rst,
	 input [15:0] pc,
    output reg [7:0] data1,
    output reg [7:0] data2,
    output reg [7:0] data3
    );

	
	
//ROM Module
	wire [1:0] sel;
	//wire [1:0] sela;
	wire [13:0] addr;
	wire [13:0] addrt;
	
	wire [7:0] tdata0;
	wire [7:0] tdata1;
	wire [7:0] tdata2;
	wire [7:0] tdata3;
	wire [13:0] addr0;
	wire [13:0] addr1;
	wire [13:0] addr2;
	wire [13:0] addr3;

	//program store
	ROM program_rom(
		.clk(clk),
		.addr0(addr0),
		.addr1(addr1),
		.addr2(addr2),
		.addr3(addr3),
		.data0(tdata0),
		.data1(tdata1),
		.data2(tdata2),
		.data3(tdata3));

	
	assign sel = pc[1:0];
	assign addr = pc[15:2];
	assign addrt = addr + 13'b1;
	
	assign addr0 = (sel==2'b00) ? addr : addrt;
	assign addr1 = (sel==2'b00 || sel==2'b01) ? addr : addrt;
	assign addr2 = (sel==2'b11) ? addrt : addr;
	assign addr3 = addr;	
	

	always@(posedge clk) begin
		if (rst) begin
			data1 <= 8'h0;
			data2 <= 8'h0;
			data3 <= 8'h0;
		end else begin
			data1 <= ((sel==2'b00) ? tdata0 : ((sel==2'b01) ? tdata1 : ((sel==2'b10) ? tdata2 : tdata3))); 
			data2 <= ((sel==2'b00) ? tdata1 : ((sel==2'b01) ? tdata2 : ((sel==2'b10) ? tdata3 : tdata0))); 
			data3 <= ((sel==2'b00) ? tdata2 : ((sel==2'b01) ? tdata3 : ((sel==2'b10) ? tdata0 : tdata1))); 		
		end
	end
	
//-------------
endmodule
