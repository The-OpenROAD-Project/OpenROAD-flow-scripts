`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:32:35 05/28/2007
// Design Name:   gen_ram_wren
// Module Name:   D:/altera_work/CCD/gen_ram_wren_tb.v
// Project Name:  CCD
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: gen_ram_wren
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module gen_ram_wren_tb_v;

	// Inputs
	reg clk;
	reg aclr;
	reg data_valid;

	// Outputs
	wire rama_wren;
	wire ramb_wren;

	// Instantiate the Unit Under Test (UUT)
	gen_ram_wren uut (
		.clk(clk), 
		.aclr(aclr), 
		.data_valid(data_valid), 
		.rama_wren(rama_wren), 
		.ramb_wren(ramb_wren)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		aclr = 1;
		data_valid = 0;

		// Wait 100 ns for global reset to finish
		#100;
      aclr = 0;   
		// Add stimulus here
      #30
		//#20
		data_valid=1;
	end
   always #10 clk=~clk;   
endmodule

