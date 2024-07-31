`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Rose-Hulman Institute of Technology
// Tom D'Agostino
// ECE398 CAN Controller Design
// 
// Create Date:    21:29:50 04/13/2015 
// Module Name:    BaudGen
// Project Name:   CANBUS
// Target Devices: Nexys 3 running a Xilinx Spartan6 XC6LX16-CS324
// Description: The shift register portion of the RX, detects end-of-frame
//////////////////////////////////////////////////////////////////////////////////
module shift_reg(
    input rx,
    output reg[(reg_length-1):0] shifted_bus,
	output reg finished_rx,
    input rst,
    input baud_clk
    );
	
	parameter reg_length = 150;

	initial finished_rx = 0;
	parameter idle = 2'b00, reading = 2'b01, finished = 2'b10, finished_and_waiting = 2'b11;
	reg[1:0] current_state, next_state;
	
	reg [(reg_length-1):0] bitShiftReg = {reg_length{1'b1}};

	always @(posedge baud_clk or posedge rst) begin
		if(rst) begin
			bitShiftReg <= {reg_length{1'b1}};
			current_state <=  idle;
		end
		else begin
			current_state <= next_state;
			bitShiftReg <= {bitShiftReg[(reg_length-2):0],rx};
		end
	end
	always @(rx or bitShiftReg or current_state) begin
		case(current_state) 
			idle: begin
				if(rx == 1)
					next_state <= idle;
				else 
					next_state <= reading;
				end
			reading: begin
				if(bitShiftReg[6:0] == {7{1'b1}})
					next_state <= finished;
				else
					next_state <= reading;
				end
			finished: begin
				next_state<= finished_and_waiting;
			end
			
			default: begin
				next_state<=idle;
			end
		endcase
	end
	
	always @ (current_state) begin
		if(current_state == finished)
			finished_rx <= 1;
		else
			finished_rx <= 0;
	end
	
	always @ (posedge finished_rx or posedge rst) begin
		if(rst) 
			shifted_bus <= {reg_length{1'b1}};
		else
			shifted_bus <= bitShiftReg;
	end

endmodule
