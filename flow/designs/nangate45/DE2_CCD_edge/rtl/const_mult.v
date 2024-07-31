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
// Constant Mutliplier for RGB to YCbCr Conversion
//
// Benoit Payette, Xilinx AE, Montreal 
// July 09, 2002
// 
// SynplifyPRO v7.1 for synthesis
// MTI v5.6 for simulation
//
// This file is the Verilog const_mult
//
// Description: This is a parameterizable constant multiplier
//
//

`timescale 1ns / 10ps

module const_mult 
(
  Clock,
  //ClockEnable,
  Reset,
  Color,
  Color_Out
);

  parameter IN_SIZE   =  8;
  parameter OUT_SIZE  = 16;  // output size width (integer)
  parameter CST_MULT  = 66;  // constant multiplicand (integer)

  input Clock; 
  //input ClockEnable; 
  input Reset; 
  input [ (IN_SIZE - 1):0] Color; 
  output[(OUT_SIZE - 1):0] Color_Out; 

  reg   [(OUT_SIZE - 1):0] Color_Out;

// ------------------------------
// RTL code for COLOR_KCM process
// ------------------------------
  always @(posedge Clock or negedge Reset)
  begin : COLOR_KCM
    if (!Reset)
      Color_Out <= 0; 
    else 
      Color_Out <= CST_MULT * Color; 
   end 


endmodule
