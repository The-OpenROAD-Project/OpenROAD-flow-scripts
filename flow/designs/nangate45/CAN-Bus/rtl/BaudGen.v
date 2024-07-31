`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Rose-Hulman Institute of Technology
// Tom D'Agostino
// ECE398 CAN Controller Design
// 
// Create Date:    21:29:50 03/13/2015 
// Module Name:    BaudGen
// Project Name:   Serial
// Target Devices: Nexys 3 running a Xilinx Spartan6 XC6LX16-CS324
// Description: Generates the required baud rate for communication.
//////////////////////////////////////////////////////////////////////////////////
module BaudGen(clk,rst,baud_clk);
input clk,rst;
output reg baud_clk;

//EndCount is equal to clk frequency/baud frequency
// Therefore 400MHz/500kHz = 800
parameter EndCount = 10'd800;
reg[9:0] count = 0;

always@(posedge clk)begin
	if(rst == 1) begin
		count <=10'd0;
		baud_clk <= 10'd0;
	end
	else if(count == EndCount) begin
		count <= 10'd0; 
		baud_clk <= ~baud_clk;
		end
	else begin
		count <= count + 10'd1;
		baud_clk <= baud_clk;
		end
	end

endmodule
