`include "defines.v"
module opReceive(clk,rst,iram_data,eram_data,operand,source2,nop);

input clk,rst;

input [7:0] iram_data;
input [7:0] eram_data;

output reg [7:0] operand;

input [17:0] source2;

input nop;
 
always@(posedge clk)
  if (rst)
    operand <= 8'b0;
	else if 		(source2[17] && !source2[16] && !source2[15])
		operand <= iram_data;
	else if (source2[17] && !source2[16] && source2[15])
		operand <= source2[7:0];
	else if (source2[17] && source2[16] && source2[15])
    operand <= 8'b0;
	//	case (source2[12:8])
	//		5'b01000 : operand <= DPTRL;
	//		5'b01100 : operand <= DPTRH;
	//		5'b10000 : operand <= PCL;
	//		5'b10100 : operand <= PCH;
	//		5'b11100 : operand <= SP;
	//		5'b00001 : operand <= B;
	//		5'b00010 : operand <= ACC;
	//		5'b00011 : operand <= PSW;
	//		default  : operand <= 8'b0;
	//	endcase
	//else operand <= 8'b0;

endmodule



