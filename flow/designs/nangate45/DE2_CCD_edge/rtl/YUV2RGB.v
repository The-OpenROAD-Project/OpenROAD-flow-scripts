`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:55:45 06/04/2007 
// Design Name: 
// Module Name:    YUV2RGB 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
/**************************************************************************
 ** 
 ** Module: ycrcb2rgb
 **
 ** Generic Equations:
 ***************************************************************************/

module YUV2RGB ( R, G, B, clk, rst, Y, Cr, Cb ,data_valid_in,data_valid_out);

output [7:0]  R, G, B;

input clk,rst;
input[9:0] Y, Cr, Cb;
input data_valid_in;
output data_valid_out;
reg data_valid_out;
reg data_valid_dly1,data_valid_dly2;

wire [9:0] R,G,B;
reg [22:0] R_int,G_int,B_int,X_int,A_int,B1_int,B2_int,C_int; 
reg [11:0] const1,const2,const3,const4,const5;
reg[9:0] Y_reg, Cr_reg, Cb_reg;
 
//registering constants
always @ (posedge clk)
begin
 //const1 = 10'b 0100101010; //1.164 = 01.00101010
 //const2 = 10'b 0110011000; //1.596 = 01.10011000
 //const3 = 10'b 0011010000; //0.813 = 00.11010000
 //const4 = 10'b 0001100100; //0.392 = 00.01100100
 //const5 = 10'b 1000000100; //2.017 = 10.00000100
 const1 = 12'b 010010100111;
 const2 = 12'b 011001100010;
 const3 = 12'b 001101000000;
 const4 = 12'b 000110010001;
 const5 = 12'b 100000010001;


end

always @ (posedge clk or negedge rst)
   if (!rst)
      begin
      Y_reg <= 0; Cr_reg <= 0; Cb_reg <= 0;
      end
   else if(data_valid_in) 
      begin
	  Y_reg <= Y; Cr_reg <= Cr; Cb_reg <= Cb;
      end

always @ (posedge clk or negedge rst)
   if (!rst)
      begin
       A_int <= 0; B1_int <= 0; B2_int <= 0; C_int <= 0; X_int <= 0;
      end
   else  
     begin
     X_int <= (const1 * (Y_reg - 'd64)) ;
     A_int <= (const2 * (Cr_reg - 'd512));
     B1_int <= (const3 * (Cr_reg - 'd512));
     B2_int <= (const4 * (Cb_reg - 'd512));
     C_int <= (const5 * (Cb_reg - 'd512));
     end

always @ (posedge clk or negedge rst)
   if (!rst)
      begin
       R_int <= 0; G_int <= 0; B_int <= 0;
      end
   else  
     begin
     R_int <= X_int + A_int;  
     G_int <= X_int - B1_int - B2_int; 
     B_int <= X_int + C_int; 
     end
	 
/*always @ (posedge clk or negedge rst)
   if (!rst)
      begin
       R_int <= 0; G_int <= 0; B_int <= 0;
      end
   else  
     begin
     R_int <= const1 * (Y_reg - 'd64);  
     G_int <= const1 * (Y_reg - 'd64); 
     B_int <= const1 * (Y_reg - 'd64); 
     end*/



/* limit output to 0 - 4095, <0 equals o and >4095 equals 4095 */
assign R = (R_int[22]) ? 0 : (R_int[21:20] == 2'b0) ? R_int[19:10] : 10'b1111111111;
assign G = (G_int[22]) ? 0 : (G_int[21:20] == 2'b0) ? G_int[19:10] : 10'b1111111111;
assign B = (B_int[22]) ? 0 : (B_int[21:20] == 2'b0) ? B_int[19:10] : 10'b1111111111;

always@(posedge clk or negedge rst)
if(!rst)
begin
	data_valid_dly1<=0;
	data_valid_dly2<=0;	
	data_valid_out<=0;	
end
else
begin
	data_valid_dly1<=data_valid_in;
	data_valid_dly2<=data_valid_dly1;
	data_valid_out<=data_valid_dly2;
	//data_valid_out<=data_valid_dly1;
end
endmodule

