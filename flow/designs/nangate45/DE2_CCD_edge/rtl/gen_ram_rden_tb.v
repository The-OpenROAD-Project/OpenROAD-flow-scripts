`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   08:15:36 05/29/2007
// Design Name:   gen_ram_rden
// Module Name:   D:/altera_work/CCD/gen_ram_rden_tb.v
// Project Name:  CCD
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: gen_ram_rden
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module gen_ram_rden_tb_v;

	// Inputs
	reg clk;
	reg aclr;
	reg rama_wren;
	reg ramb_wren;

	// Outputs
	wire [1:0] sel_row1_out;
	wire [1:0] sel_row2_out;
	wire frame_end;
	wire rama_rden;
	wire ramb_rden;

	// Instantiate the Unit Under Test (UUT)
	gen_ram_rden uut (
		.clk(clk), 
		.aclr(aclr), 
		.rama_wren(rama_wren), 
		.ramb_wren(ramb_wren), 
		.sel_row1_out(sel_row1_out), 
		.sel_row2_out(sel_row2_out), 
		.frame_end(frame_end), 
		.rama_rden(rama_rden), 
		.ramb_rden(ramb_rden)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		aclr = 1;
		rama_wren = 0;
		ramb_wren = 0;

		// Wait 100 ns for global reset to finish
		#100;
      aclr = 0;  
		// Add stimulus here
      #30
      rama_wren = 1;	
      #240
		rama_wren = 0;
		ramb_wren = 1;
		#240
		rama_wren = 1;
		ramb_wren = 0;
		#240
		rama_wren = 0;
		ramb_wren = 1;
		#240
		rama_wren = 1;
		ramb_wren = 0;
		#240
		rama_wren = 0;
		ramb_wren = 1;
		#240
		rama_wren = 1;
		ramb_wren = 0;
		#240
		rama_wren = 0;
		ramb_wren = 1;
		#240
		rama_wren = 1;
		ramb_wren = 0;
		#240
		rama_wren = 0;
		ramb_wren = 1;
		#240
		rama_wren = 0;
		ramb_wren = 0;
		#400
		
      
		rama_wren = 1;
		ramb_wren = 0;
		#240
		rama_wren = 0;
		ramb_wren = 1;
		#240
		rama_wren = 1;
		ramb_wren = 0;
		#240
		rama_wren = 0;
		ramb_wren = 1;
		#240
		rama_wren = 1;
		ramb_wren = 0;
		#240
		rama_wren = 0;
		ramb_wren = 1;
		#240
		rama_wren = 1;
		ramb_wren = 0;
		#240
		rama_wren = 0;
		ramb_wren = 1;
		#240
		rama_wren = 1;
		ramb_wren = 0;
		#240
		rama_wren = 0;
		ramb_wren = 1;
	end
   always #10 clk=~clk;   
endmodule

