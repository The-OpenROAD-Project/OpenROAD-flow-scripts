`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
// Copyright (C) 2009 OutputLogic.com 
// This source file may be used and distributed without restriction 
// provided that this copyright statement is not removed from the file 
// and that any derivative work contains the original copyright notice 
// and the associated disclaimer. 
// 
// THIS SOURCE FILE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS 
// OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED	
// WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE. 
//-----------------------------------------------------------------------------
// CRC module for data[31:0] ,   crc[14:0]=1+x^3+x^4+x^7+x^8+x^10+x^14+x^15;
//-----------------------------------------------------------------------------
module CRC(
  input [63:0] data_in,
  input crc_en,
  output [14:0] crc_out,
  input rst,
  input clk);
//
  reg [14:0] lfsr_q ,lfsr_c ;
//
  assign crc_out[14:0] = lfsr_q[14:0];

  always @(*) begin
     lfsr_c[0] = lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[7] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[14] ^ data_in[17] ^ data_in[19] ^ data_in[20] ^ data_in[21] ^ data_in[27] ^ data_in[29] ^ data_in[33] ^ data_in[37] ^ data_in[38] ^ data_in[43] ^ data_in[45] ^ data_in[48] ^ data_in[49] ^ data_in[51] ^ data_in[52] ^ data_in[57] ^ data_in[58] ^ data_in[61] ^ data_in[62] ^ data_in[63];
    lfsr_c[1] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[14] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[7] ^ data_in[8] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[15] ^ data_in[18] ^ data_in[20] ^ data_in[21] ^ data_in[22] ^ data_in[28] ^ data_in[30] ^ data_in[34] ^ data_in[38] ^ data_in[39] ^ data_in[44] ^ data_in[46] ^ data_in[49] ^ data_in[50] ^ data_in[52] ^ data_in[53] ^ data_in[58] ^ data_in[59] ^ data_in[62] ^ data_in[63];
    lfsr_c[2] = lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[14] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[8] ^ data_in[9] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[14] ^ data_in[16] ^ data_in[19] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[29] ^ data_in[31] ^ data_in[35] ^ data_in[39] ^ data_in[40] ^ data_in[45] ^ data_in[47] ^ data_in[50] ^ data_in[51] ^ data_in[53] ^ data_in[54] ^ data_in[59] ^ data_in[60] ^ data_in[63];
    lfsr_c[3] = lfsr_q[0] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[5] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[19] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[27] ^ data_in[29] ^ data_in[30] ^ data_in[32] ^ data_in[33] ^ data_in[36] ^ data_in[37] ^ data_in[38] ^ data_in[40] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[46] ^ data_in[49] ^ data_in[54] ^ data_in[55] ^ data_in[57] ^ data_in[58] ^ data_in[60] ^ data_in[62] ^ data_in[63];
    lfsr_c[4] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[10] ^ lfsr_q[13] ^ data_in[0] ^ data_in[4] ^ data_in[7] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[16] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[27] ^ data_in[28] ^ data_in[29] ^ data_in[30] ^ data_in[31] ^ data_in[34] ^ data_in[39] ^ data_in[41] ^ data_in[42] ^ data_in[43] ^ data_in[44] ^ data_in[45] ^ data_in[46] ^ data_in[47] ^ data_in[48] ^ data_in[49] ^ data_in[50] ^ data_in[51] ^ data_in[52] ^ data_in[55] ^ data_in[56] ^ data_in[57] ^ data_in[59] ^ data_in[62];
    lfsr_c[5] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[11] ^ lfsr_q[14] ^ data_in[1] ^ data_in[5] ^ data_in[8] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[17] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[28] ^ data_in[29] ^ data_in[30] ^ data_in[31] ^ data_in[32] ^ data_in[35] ^ data_in[40] ^ data_in[42] ^ data_in[43] ^ data_in[44] ^ data_in[45] ^ data_in[46] ^ data_in[47] ^ data_in[48] ^ data_in[49] ^ data_in[50] ^ data_in[51] ^ data_in[52] ^ data_in[53] ^ data_in[56] ^ data_in[57] ^ data_in[58] ^ data_in[60] ^ data_in[63];
    lfsr_c[6] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[12] ^ data_in[2] ^ data_in[6] ^ data_in[9] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[18] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[27] ^ data_in[29] ^ data_in[30] ^ data_in[31] ^ data_in[32] ^ data_in[33] ^ data_in[36] ^ data_in[41] ^ data_in[43] ^ data_in[44] ^ data_in[45] ^ data_in[46] ^ data_in[47] ^ data_in[48] ^ data_in[49] ^ data_in[50] ^ data_in[51] ^ data_in[52] ^ data_in[53] ^ data_in[54] ^ data_in[57] ^ data_in[58] ^ data_in[59] ^ data_in[61];
    lfsr_c[7] = lfsr_q[1] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[17] ^ data_in[21] ^ data_in[22] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[28] ^ data_in[29] ^ data_in[30] ^ data_in[31] ^ data_in[32] ^ data_in[34] ^ data_in[38] ^ data_in[42] ^ data_in[43] ^ data_in[44] ^ data_in[46] ^ data_in[47] ^ data_in[50] ^ data_in[53] ^ data_in[54] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[60] ^ data_in[61] ^ data_in[63];
    lfsr_c[8] = lfsr_q[0] ^ lfsr_q[3] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[11] ^ lfsr_q[14] ^ data_in[0] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[9] ^ data_in[11] ^ data_in[17] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[25] ^ data_in[26] ^ data_in[30] ^ data_in[31] ^ data_in[32] ^ data_in[35] ^ data_in[37] ^ data_in[38] ^ data_in[39] ^ data_in[44] ^ data_in[47] ^ data_in[49] ^ data_in[52] ^ data_in[54] ^ data_in[55] ^ data_in[56] ^ data_in[57] ^ data_in[60] ^ data_in[63];
    lfsr_c[9] = lfsr_q[1] ^ lfsr_q[4] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[12] ^ data_in[1] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[10] ^ data_in[12] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[26] ^ data_in[27] ^ data_in[31] ^ data_in[32] ^ data_in[33] ^ data_in[36] ^ data_in[38] ^ data_in[39] ^ data_in[40] ^ data_in[45] ^ data_in[48] ^ data_in[50] ^ data_in[53] ^ data_in[55] ^ data_in[56] ^ data_in[57] ^ data_in[58] ^ data_in[61];
    lfsr_c[10] = lfsr_q[3] ^ lfsr_q[5] ^ lfsr_q[7] ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[14] ^ data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[12] ^ data_in[13] ^ data_in[14] ^ data_in[17] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[28] ^ data_in[29] ^ data_in[32] ^ data_in[34] ^ data_in[38] ^ data_in[39] ^ data_in[40] ^ data_in[41] ^ data_in[43] ^ data_in[45] ^ data_in[46] ^ data_in[48] ^ data_in[52] ^ data_in[54] ^ data_in[56] ^ data_in[59] ^ data_in[61] ^ data_in[63];
    lfsr_c[11] = lfsr_q[0] ^ lfsr_q[4] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[11] ^ lfsr_q[13] ^ data_in[1] ^ data_in[2] ^ data_in[4] ^ data_in[5] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[13] ^ data_in[14] ^ data_in[15] ^ data_in[18] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[29] ^ data_in[30] ^ data_in[33] ^ data_in[35] ^ data_in[39] ^ data_in[40] ^ data_in[41] ^ data_in[42] ^ data_in[44] ^ data_in[46] ^ data_in[47] ^ data_in[49] ^ data_in[53] ^ data_in[55] ^ data_in[57] ^ data_in[60] ^ data_in[62];
    lfsr_c[12] = lfsr_q[1] ^ lfsr_q[5] ^ lfsr_q[7] ^ lfsr_q[9] ^ lfsr_q[12] ^ lfsr_q[14] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[14] ^ data_in[15] ^ data_in[16] ^ data_in[19] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[27] ^ data_in[30] ^ data_in[31] ^ data_in[34] ^ data_in[36] ^ data_in[40] ^ data_in[41] ^ data_in[42] ^ data_in[43] ^ data_in[45] ^ data_in[47] ^ data_in[48] ^ data_in[50] ^ data_in[54] ^ data_in[56] ^ data_in[58] ^ data_in[61] ^ data_in[63];
    lfsr_c[13] = lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[10] ^ lfsr_q[13] ^ data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[7] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[15] ^ data_in[16] ^ data_in[17] ^ data_in[20] ^ data_in[25] ^ data_in[26] ^ data_in[27] ^ data_in[28] ^ data_in[31] ^ data_in[32] ^ data_in[35] ^ data_in[37] ^ data_in[41] ^ data_in[42] ^ data_in[43] ^ data_in[44] ^ data_in[46] ^ data_in[48] ^ data_in[49] ^ data_in[51] ^ data_in[55] ^ data_in[57] ^ data_in[59] ^ data_in[62];
    lfsr_c[14] = lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[13] ^ data_in[16] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[26] ^ data_in[28] ^ data_in[32] ^ data_in[36] ^ data_in[37] ^ data_in[42] ^ data_in[44] ^ data_in[47] ^ data_in[48] ^ data_in[50] ^ data_in[51] ^ data_in[56] ^ data_in[57] ^ data_in[60] ^ data_in[61] ^ data_in[62];
  end // always

  always @(posedge clk or posedge rst) begin
    if(rst) begin
      lfsr_q <= {15{1'b1}};
    end
    else begin
       lfsr_q[14:0] <= crc_en ? lfsr_c[14:0] : lfsr_q[14:0];
    end
  end // always
endmodule // crc