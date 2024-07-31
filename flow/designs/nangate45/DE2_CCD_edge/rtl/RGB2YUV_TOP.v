`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:42:31 05/31/2007 
// Design Name: 
// Module Name:    RGB2YUV 
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
`timescale 1ns / 10ps

module RGB2YUV_TOP
(
  Clock,
  Reset,
  Red,
  Green,
  Blue,
  data_valid_in,
  Y,
  Cb,
  Cr,
  data_valid_out
);

  //parameter TOP_OUT_SIZE  =  8; // uncomment to get  8-bit input & output...
	parameter TOP_OUT_SIZE  = 10; // uncomment to get 10-bit input & output...

  input  Clock; 
  //input  ClockEnable; 
  input  Reset; 
  input  [(TOP_OUT_SIZE - 1):0] Red; 
  input  [(TOP_OUT_SIZE - 1):0] Green; 
  input  [(TOP_OUT_SIZE - 1):0] Blue; 
  input data_valid_in;
  output [(TOP_OUT_SIZE - 1):0] Y; 
  output [(TOP_OUT_SIZE - 1):0] Cb; 
  output [(TOP_OUT_SIZE - 1):0] Cr; 
  output data_valid_out;

  reg [(TOP_OUT_SIZE - 1):0] Y;
  reg [(TOP_OUT_SIZE - 1):0] Cb;
  reg [(TOP_OUT_SIZE - 1):0] Cr;
  reg data_valid_out;
  reg data_valid_dly1,data_valid_dly2,data_valid_dly3,data_valid_dly4;
  // Define internal signals
  reg [(TOP_OUT_SIZE - 1):0] R; 
  reg [(TOP_OUT_SIZE - 1):0] G; 
  reg [(TOP_OUT_SIZE - 1):0] B; 

  wire [(TOP_OUT_SIZE - 1):0] Y_sig; 
  wire [(TOP_OUT_SIZE - 1):0] Cb_sig; 
  wire [(TOP_OUT_SIZE - 1):0] Cr_sig; 

  // Input registers (should be pushed into IOBs)
  always @(posedge Clock or negedge Reset)
  begin : In_Reg
    if (!Reset)
    begin
      R <= 0;
      G <= 0;
      B <= 0;
    end
    else if (data_valid_in)
    begin
      R <= Red ; 
      G <= Green ; 
      B <= Blue ; 
    end 
  end 

  // Output registers (should be pushed into IOBs)
  always @(posedge Clock or negedge Reset)
  begin : Out_Reg
    if (!Reset)
    begin
      Y  <= 0;
      Cb <= 0;
      Cr <= 0;
    end
    else 
    begin
      Y  <= Y_sig ; 
      Cb <= Cb_sig ; 
      Cr <= Cr_sig ; 
    end 
  end 


  // CSC instantiation
  RGB2YUV  #(TOP_OUT_SIZE) RGB2YUV
  (
    .Clock(Clock),
    //.ClockEnable(ClockEnable),
    .Reset(Reset),
    .R(R),
    .G(G),
    .B(B),
    .Y(Y_sig),
    .Cb(Cb_sig),
    .Cr(Cr_sig)
  );

always@(posedge Clock or negedge Reset)
if(!Reset)
begin
	data_valid_dly1<=0;
	data_valid_dly2<=0;
	data_valid_dly3<=0;
	data_valid_dly4<=0;
	data_valid_out<=0;	
end
else
begin
	data_valid_dly1<=data_valid_in;
	data_valid_dly2<=data_valid_dly1;
	data_valid_dly3<=data_valid_dly2;
	data_valid_dly4<=data_valid_dly3;
	data_valid_out<=data_valid_dly4;
end
endmodule
