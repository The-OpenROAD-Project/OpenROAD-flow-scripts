`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Rose-Hulman Institute of Technology
// Tom D'Agostino
// ECE398 CAN Controller Design
// 
// Create Date:    23:00 03/26/2015
// Module Name:    main
// Project Name:   CAN_Controller
// Target Devices: Nexys 3 running a Xilinx Spartan6 XC6LX16-CS324
// Description: Implements the CAN Bus protocol.
//////////////////////////////////////////////////////////////////////////////////
module Main(
	output CAN_TX,
	input CAN_RX,
	input RESET,
	input clk,
	input send_data,
	input[7:0] transmit_data
	);
	
	wire[63:0] tx_data;
	wire txing;
	
	assign tx_data = {8{transmit_data}};
	
	//Device address, arbitrarily chosen
	parameter address = 11'h25, rxing = 1'b1;
	
	//Clock Generator (100MHz in, 400MHz out)
	//Clock_gen clock_block(CLOCK_SIGNAL_IN,clk);
	
	//Baud Clk Generator(currently set for baud of 500kHz)
	BaudGen baud_calc(clk,RESET,baud_clk);

	
	//Tx Block
	//can_tx tx_block(CAN_TX,CAN_RX,address,clk,baud_clk,RESET,tx_data,send_data);
	tx_container tx_can(CAN_TX,txing,CAN_RX,rxing,address,clk,baud_clk,RESET,tx_data,send_data);
	//rx_container rx_can(rx_data,rxing,txing,CAN_RX,clk,baud_clk,RESET);
	
	//Rx goes here

	
endmodule
