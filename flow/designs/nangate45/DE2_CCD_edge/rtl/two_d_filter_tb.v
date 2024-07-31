`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:42:36 06/06/2007
// Design Name:   two_d_filter
// Module Name:   D:/altera_work/two_d_fir/2_d_fir/two_d_filter_tb.v
// Project Name:  2_d_fir
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: two_d_filter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module two_d_filter_tb_v;

	// Inputs
	reg aclr;
	reg data_valid_in;
	reg clk;
	//reg clken;
	reg [8:0] coef1_1;
	reg [8:0] coef1_2;
	reg [8:0] coef1_3;
	reg [8:0] coef2_1;
	reg [8:0] coef2_2;
	reg [8:0] coef2_3;
	reg [8:0] coef3_1;
	reg [8:0] coef3_2;
	reg [8:0] coef3_3;
	reg [29:0] data;
	
	//reg result;

	// Outputs
	wire [29:0] row1_1;
	wire [29:0] row1_2;
	wire [29:0] row1_3;
	wire [29:0] row2_1;
	wire [29:0] row2_2;
	wire [29:0] row2_3;
	wire [29:0] row3_1;
	wire [29:0] row3_2;
	wire [29:0] row3_3;
	wire data_valid_out;
	// Instantiate the Unit Under Test (UUT)
	two_d_filter uut (
		.aclr(aclr), 
		.data_valid_in(data_valid_in), 
		.clk(clk), 
		//.clken(clken), 
		.coef1_1(coef1_1), 
		.coef1_2(coef1_2), 
		.coef1_3(coef1_3), 
		.coef2_1(coef2_1), 
		.coef2_2(coef2_2), 
		.coef2_3(coef2_3), 
		.coef3_1(coef3_1), 
		.coef3_2(coef3_2), 
		.coef3_3(coef3_3), 
		.data(data), 
		.row1_1(row1_1), 
		.row1_2(row1_2), 
		.row1_3(row1_3), 
		.row2_1(row2_1), 
		.row2_2(row2_2), 
		.row2_3(row2_3), 
		.row3_1(row3_1), 
		.row3_2(row3_2), 
		.row3_3(row3_3),
		.data_valid_out(data_valid_out)
		//.result(result)
	);
	
	parameter p=6;//仿真时用
	parameter a=12;//仿真时用
	parameter q=3;//仿真时用
	parameter v=10;//仿真时用
	parameter column_size=12;
	parameter row_size=16;
	//parameter column_size=1280,row_size=1024;
	
	reg [10:0] i,j;
	
	initial begin
		// Initialize Inputs
		aclr = 0;
		data_valid_in = 0;
		clk = 0;
		//clken = 0;
		coef1_1 = 0;
		coef1_2 = 0;
		coef1_3 = 0;
		coef2_1 = 0;
		coef2_2 = 0;
		coef2_3 = 0;
		coef3_1 = 0;
		coef3_2 = 0;
		coef3_3 = 0;
		data = 0;
		//data_valid_out = 0;
		//result = 0;

		// Wait 100 ns for global reset to finish
		#100;
      aclr = 1;  
		// Add stimulus here
		for(i=1;i<=p;i=i+1)//p=6
		begin
			# 20;
			data_valid_in = 0;
		end
		for(i=1;i<=row_size/2-1;i=i+1)
		begin
			for(j=1;j<=a/2;j=j+1)
			begin
				#20;
				data_valid_in = 1;
				data=2*j-1+2*a*(i-1);
				#20;
				data_valid_in = 0;
				
			end
			repeat(q)
			begin
				#20;
				data_valid_in = 0;
				data=0;
			end
		end
		for(j=1;j<=a/2;j=j+1)
			begin
				#20;
				data_valid_in = 1;
				data=2*j-1+2*a*(row_size/2-1);
				#20;
				data_valid_in = 0;
				
			end
		repeat(p)
		begin
			# 20;
			data_valid_in = 0;
			data=0;
		end
		repeat(v)
		begin
			# 20;
			data_valid_in = 0;
			data=0;
		end//一帧图像传送
		#120
		repeat(p)
		begin
			# 20;
			data_valid_in = 0;
			data=0;
		end
		for(i=1;i<=row_size/2-1;i=i+1)
		begin
			for(j=1;j<=a/2;j=j+1)
			begin
				#20;
				data_valid_in = 1;
				data=2*j-1+2*a*(i-1);
				#20;
				data_valid_in = 0;
			end
			repeat(q)
			begin
				#20;
				data_valid_in = 0;
				data=0;
			end
		end
	end
	
   always #10 clk=~clk; 
      
endmodule

