`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:33:17 05/25/2015
// Design Name:   OneShot
// Module Name:   C:/Users/dagosttv.ROSE-HULMAN/Documents/School/ECE/ECE398/CAN-Bus-Controller-/One-ShotTest.v
// Project Name:  CAN_Controller
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: OneShot
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module OneShotTest;

	// Inputs
	reg pulse;
	reg clk;
	reg rst;

	// Outputs
	wire out;

	// Instantiate the Unit Under Test (UUT)
	OneShot uut (
		.pulse(pulse), 
		.clk(clk), 
		.rst(rst), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		pulse = 0;
		clk = 0;
		rst = 1;

		// Wait 100 ns for global reset to finish
		#100;
        rst = 0;
		#10;
		pulse = 1;
		#100; $stop;
		// Add stimulus here

	end
	always #1.25 clk=~clk;
      
endmodule

