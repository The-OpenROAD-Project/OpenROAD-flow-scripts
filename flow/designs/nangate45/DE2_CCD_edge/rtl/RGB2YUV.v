// --------------------------------------------------------------------------------------------
// ?2002 Xilinx, Inc. All rights reserved. All Xilinx trademarks, registered trademarks, 
// patents, and further disclaimers are as listed at http://www.xilinx.com/legal.htm. All 
// other trademarks and registered trademarks are the property of their respective owners. 
// All specifications are subject to change without notice.
// --------------------------------------------------------------------------------------------
// NOTICE OF DISCLAIMER: Xilinx is providing this design, code, or information "as is." 
// By providing the design, code, or information as one possible implementation of this 
// feature, application, or standard, Xilinx makes no representation that this implementation
// is free from any claims of infringement. You are responsible for obtaining any rights
// you may require for your implementation. Xilinx expressly disclaims any warranty whatsoever
// with respect to the adequacy of the implementation, including but not limited to any 
// warranties or representations that this implementation is free from claims of infringement
// and any implied warranties of merchantability or fitness for a particular purpose. 
// --------------------------------------------------------------------------------------------
// 
// 
// Color Space Converter
//
// Benoit Payette, Xilinx AE, Montreal 
// July 09, 2002
// 
// SynplifyPRO v7.1 for synthesis
// MTI v5.6 for simulation
//
// This file is the Verilog csc
//
// Description: This is RGB to YCbCr converter
//
// Assumptions:
//  (a) R,G,B are 8-bit gamma-corrected values with full 0-255 range
//  (b) ITU-R BT.601-2 component video standards (SDTV), 4:4:4 encoding
//  (c) possible YCbCr range is 0-255, but ITU specifies:
//      Y  has a range of 16-235, 8-bit
//      Cb has a range of 16-240, 8-bit
//      Cr has a range of 16-240, 8-bit
//  (d) code 0 and 255 are used for synchronization when 4:2:2
//
//
// Analog Equations (normalized color-difference):
//  Y601 =  16 +    219 * ( 0.299*R + 0.587*G + 0.114*B )
//  Cb   = 128 + 224*Kb * ( B - (0.299*R + 0.587*G + 0.114*B) ), where Kb=0.5/0.886
//  Cr   = 128 + 224*Kr * ( R - (0.299*R + 0.587*G + 0.114*B) ), where Kr=0.5/0.701
// where,
// R,G,B are in [0, +1] range
// Y601 is in [16, 235] range (0-219, offset=16)
// Cb, Cr are in [16, 240] range (+/- 112, offset=16)
// Component valid range:  0 (sync), 1 - 254 (valid video), 255 (sync)
//
// 
// Digital Equations (R,G,B are 8-bit as specified in ITU-R BT.601)
//  Y601 =  16 + ( 0.257*R + 0.504*G + 0.098*B)
//  Cb   = 128 + (-0.148*R - 0.291*G + 0.439*B)
//  Cr   = 128 + ( 0.439*R - 0.368*G - 0.071*B)
// where,
// R,G,B are in [0, 255] range, 8-bit values
// Y601 is in [16, 235] range (0-219, offset=16)
// Cb, Cr are in [16, 240] range (+/- 112, offset=16)
// Component valid range:  0 (sync), 1 - 254 (valid video), 255 (sync)
//
// 
// --------------------------------------------------------------------------------
// [Initially] Implemented CSC function: development of 8-bit quantized equations
// Specific group of terms ease hardware implementation.
// --------------------------------------------------------------------------------
//
//  Y601 =  16 + ( 0.257*R + 0.504*G + 0.098*B)
//       =  16 + (1/256) * [ 256 * (0.257*R + 0.504*G + 0.098*B) ]
//       =  16 + (1/256) * [ 65.792*R + 129.024*G + 25.088*B ]
//       =  16 + (1/256) * [ 66*R + 129*G + 25*B ]  
//       =  (1/256) * [ 16*256 + ( 66*R + 129*G + 25*B ) ]
//       =  (1/256) * [ ( 16*256 + 129*G )+ ( 66*R + 25*B ) ]
//
//  Cb   = 128 + (-0.148*R - 0.291*G + 0.439*B)
//       = 128 + (1/256) * [ 256 * (-0.148*R - 0.291*G + 0.439*B) ]
//       = 128 + (1/256) * [ -37.888*R - 74.496*G + 112.384*B ]
//       = 128 + (1/256) * [ -38*R - 74*G + 112*B ]
//       = (1/256) * [ 128*256 + ( -38*R + -74*G + 112*B ) ]
//       = (1/256) * [ ( 128*256 + 112*B ) - ( 38*R + 74*G ) ]
//
//  Cr   = 128 + ( 0.439*R - 0.368*G - 0.071*B )
//       = 128 + (1/256) * [ 256 * ( 0.439*R - 0.368*G - 0.071*B) ]
//       = 128 + (1/256) * [ 112.384*R - 94.208*G - 18.176*B ]
//       = 128 + (1/256) * [ 112*R - 94*G - 18*B ]
//       = (1/256) * [ 128*256 + ( 112*R + -94*G + -18*B ) ]
//       = (1/256) * [ ( 128*256 + 112*R ) - ( 94*G + 18*B ) ]
//
//  Y601 will need three constant multipliers, three adders
//  Cb   will need three constant multipliers, two adders and one subtractor
//  Cr   will need three constant multipliers, two adders and one subtractor
//  Round up performed to bring output values to 8-bit...
//
// However, the above CSC function suffers from 8-bit quantized coefficients...
// A better accuracy is achieved by increasing the precision of the coefficients.
// That will influence the implemented area used for the core (initial 8-bit 
// coefficient uses 150 slices and runs at 100MHz, but shows last digit error).
// Here's the new precision used for Y Cb and Cr:
// => Y  needs 13 bits for green and blue coefficients, and 10 bits for red coeff
// => Cb needs 11 bits for all coefficients
// => Cr needs 10 bits for all coefficients
// 
//
//

`timescale 1ns / 10ps

module RGB2YUV 
(
  Clock,
  //ClockEnable,
  Reset,
  R,
  G,
  B,
  //data_valid_in,
  Y,
  Cb,
  Cr,
  //data_valid_out
);

//parameter OUT_SIZE  =  8; // uncomment to get  8-bit input & output...
  parameter OUT_SIZE  = 10; // uncomment to get 10-bit input & output...


  input  Clock; 
  //input  ClockEnable; 
  input  Reset; 
  input  [(OUT_SIZE - 1):0] R; 
  input  [(OUT_SIZE - 1):0] G; 
  input  [(OUT_SIZE - 1):0] B; 
  
  //input data_valid_in;
  
  output [(OUT_SIZE - 1):0] Y; 
  output [(OUT_SIZE - 1):0] Cb; 
  output [(OUT_SIZE - 1):0] Cr; 
  
  //output data_valid_out;

  reg [(OUT_SIZE - 1):0] Y;
  reg [(OUT_SIZE - 1):0] Cb;
  reg [(OUT_SIZE - 1):0] Cr;

  // Constants and precision for each coefficients...
  //
  //-- 8-bit for Y601, Cb and Cr...
  //parameter CST_Y601_red   =   66;
  //parameter CST_Y601_green =  129;
  //parameter CST_Y601_blue  =   25;
  //parameter CST_Y601_Prec  =    8; --  8-bit (256)
  //--
  //parameter CST_Cb_red     =   38;
  //parameter CST_Cb_green   =   74;
  //parameter CST_Cb_blue    =  112;
  //parameter CST_Cb_Prec    =    8; --  8-bit (256)
  //--
  //parameter CST_Cr_red     =  112;
  //parameter CST_Cr_green   =   94;
  //parameter CST_Cr_blue    =   18;
  //parameter CST_Cr_Prec    =    8; --  8-bit (256)
  //
  //-- 9-bit for Y601, Cb and Cr...
  //parameter CST_Y601_red   =  132;
  //parameter CST_Y601_green =  258;
  //parameter CST_Y601_blue  =   50;
  //parameter CST_Y601_Prec  =    9; --  9-bit (512)
  //--
  //parameter CST_Cb_red     =   76;
  //parameter CST_Cb_green   =  149;
  //parameter CST_Cb_blue    =  225;
  //parameter CST_Cb_Prec    =    9; --  9-bit (512)
  //--
  //parameter CST_Cr_red     =  225;
  //parameter CST_Cr_green   =  188;
  //parameter CST_Cr_blue    =   36;
  //parameter CST_Cr_Prec    =    9; --  9-bit (512)
  //
  //-- 10-bit for Y601, Cb and Cr...
  //parameter CST_Y601_red   =  263;
  //parameter CST_Y601_green =  516;
  //parameter CST_Y601_blue  =  100;
  //parameter CST_Y601_Prec  =   10; --  10-bit (1024)
  //--
  //parameter CST_Cb_red     =  152;
  //parameter CST_Cb_green   =  298;
  //parameter CST_Cb_blue    =  450;
  //parameter CST_Cb_Prec    =   10; --  10-bit (1024)
  //--
  parameter CST_Cr_red     = 450; 
  parameter CST_Cr_green   = 377; 
  parameter CST_Cr_blue    =  73; 
  parameter CST_Cr_Prec    =  10; //  10-bit (1024)
  //
  //-- 11-bit for Y601, Cb and Cr...
  //parameter CST_Y601_red   =  526;
  //parameter CST_Y601_green = 1032;
  //parameter CST_Y601_blue  =  201;
  //parameter CST_Y601_Prec  =   11; --  11-bit (2048)
  //--
  parameter CST_Cb_red     = 303; 
  parameter CST_Cb_green   = 596; 
  parameter CST_Cb_blue    = 899; 
  parameter CST_Cb_Prec    =  11; //  11-bit (2048)
  //--
  //parameter CST_Cr_red     =  899;
  //parameter CST_Cr_green   =  754;
  //parameter CST_Cr_blue    =  145;
  //parameter CST_Cr_Prec    =   11; --  11-bit (2048)
  //
  //--12-bit for Y601, Cb and Cr...
  //parameter CST_Y601_red   = 1053;
  //parameter CST_Y601_green = 2064;
  //parameter CST_Y601_blue  =  401;
  //parameter CST_Y601_Prec  =   12; --  12-bit (4096)
  //--
  //parameter CST_Cb_red     =  606;
  //parameter CST_Cb_green   = 1192;
  //parameter CST_Cb_blue    = 1798;
  //parameter CST_Cb_Prec    =   12; --  12-bit (4096)
  //--
  //parameter CST_Cr_red     = 1798;
  //parameter CST_Cr_green   = 1507;
  //parameter CST_Cr_blue    =  291;
  //parameter CST_Cr_Prec    =   12; --  12-bit (4096)
  //
  //-- 13-bit for Y601, Cb and Cr...
  parameter CST_Y601_red   = 2105; 
  parameter CST_Y601_green = 4129; 
  parameter CST_Y601_blue  =  803; 
  parameter CST_Y601_Prec  =   13; //  13-bit (8192)
  //--
  //parameter CST_Cb_red     = 1212;
  //parameter CST_Cb_green   = 2384;
  //parameter CST_Cb_blue    = 3596;
  //parameter CST_Cb_Prec    =   13; --  13-bit (8192)
  //--
  //parameter CST_Cr_red     = 3596;
  //parameter CST_Cr_green   = 3015;
  //parameter CST_Cr_blue    =  582;
  //parameter CST_Cr_Prec    =   13; --  13-bit (8192)
  //
  //
  //
  // Combined constants...
  parameter CST_Y601_OutSize = CST_Y601_Prec + OUT_SIZE; 
  parameter CST_Cb_OutSize   = CST_Cb_Prec   + OUT_SIZE; 
  parameter CST_Cr_OutSize   = CST_Cr_Prec   + OUT_SIZE; 
  // Takes care of offset for 8- and 10-bit input/output entity
  parameter CST_Offset_Y601  = ( ( 33 << (OUT_SIZE - 8) ) << (CST_Y601_Prec - 1) );  // (  16 + 0.5 ) * 2 * 2^(CST_Y601_Prec-1)
  parameter CST_Offset_Cb    = ( (257 << (OUT_SIZE - 8) ) << (  CST_Cb_Prec - 1) );  // ( 128 + 0.5 ) * 2 * 2^(CST_Cb_Prec-1)
  parameter CST_Offset_Cr    = ( (257 << (OUT_SIZE - 8) ) << (  CST_Cr_Prec - 1) );  // ( 128 + 0.5 ) * 2 * 2^(CST_Cr_Prec-1)
  //
  //
  // Component Declarations
  // Constant multipliers Y601, Cb and Cr com4ponents...
  // Define internal signals
  wire [(CST_Y601_OutSize - 1):0] Y_R_KCM; 
  wire [(CST_Y601_OutSize - 1):0] Y_G_KCM; 
  wire [(CST_Y601_OutSize - 1):0] Y_B_KCM; 
  wire [  (CST_Cb_OutSize - 1):0] Cb_R_KCM; 
  wire [  (CST_Cb_OutSize - 1):0] Cb_G_KCM; 
  wire [  (CST_Cb_OutSize - 1):0] Cb_B_KCM; 
  wire [  (CST_Cr_OutSize - 1):0] Cr_R_KCM; 
  wire [  (CST_Cr_OutSize - 1):0] Cr_G_KCM; 
  wire [  (CST_Cr_OutSize - 1):0] Cr_B_KCM; 
  //
  reg [ (CST_Y601_OutSize - 1):0] Y_cst_G; 
  reg [   (CST_Cb_OutSize - 1):0] Cb_cst_B; 
  reg [   (CST_Cr_OutSize - 1):0] Cr_cst_R; 
  //
  reg [(CST_Y601_OutSize - 1):0] Y_Red_Blue; 
  reg [(CST_Y601_OutSize - 1):0] Y601_full; 
  reg [  (CST_Cb_OutSize - 1):0] Cb_Red_Green; 
  reg [  (CST_Cb_OutSize - 1):0] Cb_full; 
  reg [  (CST_Cr_OutSize - 1):0] Cr_Green_Blue; 
  reg [  (CST_Cr_OutSize - 1):0] Cr_full; 


  // ---------------------------------
  // Compute the Y601 component...
  // ---------------------------------
  const_mult #(OUT_SIZE, CST_Y601_OutSize, CST_Y601_red)   Y601_KCM_red(.Clock(Clock), .Reset(Reset), .Color(R), .Color_Out(Y_R_KCM)); 

  const_mult #(OUT_SIZE, CST_Y601_OutSize, CST_Y601_green) Y601_KCM_green(.Clock(Clock), .Reset(Reset), .Color(G), .Color_Out(Y_G_KCM)); 

  const_mult #(OUT_SIZE, CST_Y601_OutSize, CST_Y601_blue)  Y601_KCM_blue(.Clock(Clock), .Reset(Reset), .Color(B), .Color_Out(Y_B_KCM)); 

  // Adder for (G + constant), where constant "16" is scaled up by Y601 coefficient precision
  // Constant is also modified to perform rounding (+0.5)
  always @(posedge Clock or negedge Reset)
  begin : CST_Green_Adder
    if (!Reset)
      Y_cst_G <= 0; 
    else 
      Y_cst_G <= Y_G_KCM + CST_Offset_Y601; // add 16.5 (scaled up by coefficient precision)
  end 

  // Adder for (R + B)
  always @(posedge Clock or negedge Reset)
  begin : Y_Red_Blue_Adder
    if (!Reset)
      Y_Red_Blue <= 0; 
    else
      Y_Red_Blue <= Y_R_KCM + Y_B_KCM; 
  end 

  // Adder for Y601 => (R + B) + (G + constant), where constant "16.5" is scaled up by coefficient precision
  always @(posedge Clock or negedge Reset)
  begin : Y601_Adder
    if (!Reset)
      Y601_full <= 0;
    else 
      Y601_full <= Y_Red_Blue + Y_cst_G; 
  end 


  // ---------------------------------
  // Compute the Cb component...
  // ---------------------------------
  const_mult #(OUT_SIZE, CST_Cb_OutSize, CST_Cb_red)   Cb_KCM_red(.Clock(Clock), .Reset(Reset), .Color(R), .Color_Out(Cb_R_KCM)); 

  const_mult #(OUT_SIZE, CST_Cb_OutSize, CST_Cb_green) Cb_KCM_green(.Clock(Clock), .Reset(Reset), .Color(G), .Color_Out(Cb_G_KCM)); 

  const_mult #(OUT_SIZE, CST_Cb_OutSize, CST_Cb_blue)  Cb_KCM_blue(.Clock(Clock), .Reset(Reset), .Color(B), .Color_Out(Cb_B_KCM)); 

  // Adder for (B + constant), where constant "128" is scaled up by Cb coefficient precision
  // Constant is also modified to perform rounding (+0.5)
  always @(posedge Clock or negedge Reset)
  begin : CST_Blue_Adder
    if (!Reset)
      Cb_cst_B <= 0; 
    else 
      Cb_cst_B <= Cb_B_KCM + CST_Offset_Cb; // add 128.5 (scaled up by coefficient precision)
  end 

  // Adder for R + G
  always @(posedge Clock or negedge Reset)
  begin : Cb_Red_Green_Adder
    if (!Reset)
      Cb_Red_Green <= 0;
    else 
      Cb_Red_Green <= Cb_R_KCM + Cb_G_KCM;
  end 

  // Subtractor for Cb => (B + constant) - (R + G), where constant "128.5" is scaled up by coefficient precision
  always @(posedge Clock or negedge Reset)
  begin : Cb_Subt
     if (!Reset)
       Cb_full <= 0;
     else 
       Cb_full <= Cb_cst_B - Cb_Red_Green;
  end 


  // ---------------------------------
  // Compute the Cr component...
  // ---------------------------------
  const_mult #(OUT_SIZE, CST_Cr_OutSize, CST_Cr_red)   Cr_KCM_red(.Clock(Clock), .Reset(Reset), .Color(R), .Color_Out(Cr_R_KCM)); 

  const_mult #(OUT_SIZE, CST_Cr_OutSize, CST_Cr_green) Cr_KCM_green(.Clock(Clock), .Reset(Reset), .Color(G), .Color_Out(Cr_G_KCM)); 

  const_mult #(OUT_SIZE, CST_Cr_OutSize, CST_Cr_blue)  Cr_KCM_blue(.Clock(Clock), .Reset(Reset), .Color(B), .Color_Out(Cr_B_KCM)); 

  // Adder for (R + constant), where constant "128" is scaled up by Cr coefficient precision
  // Constant is also modified to perform rounding (+0.5)
  always @(posedge Clock or negedge Reset)
  begin : CST_Red_Adder
    if (!Reset)
      Cr_cst_R <= 0;
    else 
      Cr_cst_R <= Cr_R_KCM + CST_Offset_Cr; // add 128.5 (scaled up by coefficient precision)
  end 

  // Adder for G + B
  always @(posedge Clock or negedge Reset)
  begin : Cr_Green_Blue_Adder
    if (!Reset)
      Cr_Green_Blue <= 0;
    else 
      Cr_Green_Blue <= Cr_G_KCM + Cr_B_KCM;
  end 

  // Subtractor for Cr => (R + constant) - (G + B), where constant "128.5" is scaled up by coefficient precision
  always @(posedge Clock or negedge Reset)
  begin : Cr_Subt
    if (!Reset)
      Cr_full <= 0; 
    else 
      Cr_full <= Cr_cst_R - Cr_Green_Blue;
  end 


  // Limit and rounding: discard unwanted precision bits
  // Rounding already computed in result...
  always @(Y601_full or Cb_full or Cr_full)
  begin
     Y = Y601_full [(CST_Y601_OutSize - 1):(CST_Y601_OutSize - OUT_SIZE)] ; // divide by 2^(CST_Y601_OutSize-8)...
    Cb =   Cb_full [  (CST_Cb_OutSize - 1):  (CST_Cb_OutSize - OUT_SIZE)] ; // divide by 2^(CST_Cb_OutSize-8)...
    Cr =   Cr_full [  (CST_Cr_OutSize - 1):  (CST_Cr_OutSize - OUT_SIZE)] ; // divide by 2^(CST_Cr_OutSize-8)...
  end

endmodule
