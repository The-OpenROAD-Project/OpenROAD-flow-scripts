`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Rose-Hulman Institute of Technology
// Tom D'Agostino
// ECE398 CAN Controller Design
// 
// Create Date:    21:29:50 04/13/2015 
// Module Name:    tx_container
// Project Name:   CANBUS
// Target Devices: Nexys 3 running a Xilinx Spartan6 XC6LX16-CS324
// Description: The tx portion of the CAN bus that implements bitstuffing
//////////////////////////////////////////////////////////////////////////////////
module tx_container(
	output reg tx,
	output txing,
	input rx,
	input rxing,
	input[10:0] address,
	input clk,
	input baud_clk,
	input rst,
	input [63:0] data,
	input send_data
    );


	parameter  init = 2'h0,  ones = 2'h1, zeros = 2'h2;
	assign clear_to_tx =1;
	reg bit_stuffing = 0;
	reg[1:0] c_state=0, n_state=0, p_state = 0;
	reg[31:0] bit_stuffing_count = 0;
	wire can_bitstuff;
	
	can_tx tx_block(tx_buf,can_bitstuff,txing,rx,address,clk,baud_clk,rst,data,send_data,tx,clear_to_tx);

	always @ (posedge clk or posedge rst) begin
		if(rst) begin
			bit_stuffing_count<= 0;
			bit_stuffing <= 0;
		end
		else begin
			if(n_state != c_state) begin
				bit_stuffing_count<= 0;
				bit_stuffing <= 0;
			end
			else if(!can_bitstuff) begin
				bit_stuffing_count <= 0;
				bit_stuffing <= 0;
			end 
			else if(bit_stuffing_count >= 5000)begin
				bit_stuffing_count <= 0;
				bit_stuffing <= 0;
			end
			else if(bit_stuffing_count >= 4000)begin
				bit_stuffing_count <= bit_stuffing_count + 1;
				bit_stuffing <= 1;
			end
			else begin
				bit_stuffing_count <= bit_stuffing_count +1;
				bit_stuffing <= 0;
			end
		end
	end

	always @ (posedge clk) begin
		c_state <= n_state;
	end

	always @ (tx_buf) begin
		if(tx_buf == 1) begin
			n_state<= ones;
		end
		else begin
			n_state <= zeros;
		end
	end

	always @ (bit_stuffing or tx_buf) begin
		if(bit_stuffing) begin
			tx <= ~tx_buf;
		end
		else begin
			tx <= tx_buf;
		end
	end
endmodule
