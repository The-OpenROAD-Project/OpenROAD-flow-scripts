
//`timescale 1ns/100fs

module SRAM2RW16x32 (A1,A2,CE1,CE2,WEB1,WEB2,OEB1,OEB2,CSB1,CSB2,I1,I2,O1,O2);

input CE1;
input CE2;
input WEB1;
input WEB2;
input OEB1;
input OEB2;
input CSB1;
input CSB2;

input  [4-1:0]    A1;
input  [4-1:0]    A2;
input  [32-1:0] I1;
input  [32-1:0] I2;
output [32-1:0] O1;
output [32-1:0] O2;

reg     [32-1:0] memory[16-1:0];
reg     [32-1:0] data_out1;
reg     [32-1:0] data_out2;
wire    [32-1:0] O1;
wire    [32-1:0] O2;

wire RE1;
wire RE2;
wire WE1;
wire WE2;
and u1 (RE1, ~CSB1, ~OEB1);
and u2 (RE2, ~CSB2, ~OEB2);
and u3 (WE1, ~CSB1, ~WEB1);
and u4 (WE2, ~CSB2, ~WEB2);

// Initialization for simulation
integer i;
initial begin
    for (i = 0; i < 16; i = i + 1) begin
        memory[i] = {1{$urandom()}};
    end
    data_out1 = {1{$urandom()}};
    data_out2 = {1{$urandom()}};
end

always @ (posedge CE1) begin
    if (RE1)
        data_out1 <= memory[A1];
    if (WE1)
        memory[A1] <= I1;
end

always @ (posedge CE2) begin
    if (RE2)
        data_out2 <= memory[A2];
    if (WE2)
        memory[A2] <= I2;
end

reg NOTIFIER;
specify
$setuphold(posedge CE1, posedge I1[0], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[0], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[0], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[0], 0, 0, NOTIFIER);
(CE1 => O1[0]) = 0;
(CE2 => O2[0]) = 0;
$setuphold(posedge CE1, posedge I1[1], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[1], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[1], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[1], 0, 0, NOTIFIER);
(CE1 => O1[1]) = 0;
(CE2 => O2[1]) = 0;
$setuphold(posedge CE1, posedge I1[2], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[2], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[2], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[2], 0, 0, NOTIFIER);
(CE1 => O1[2]) = 0;
(CE2 => O2[2]) = 0;
$setuphold(posedge CE1, posedge I1[3], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[3], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[3], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[3], 0, 0, NOTIFIER);
(CE1 => O1[3]) = 0;
(CE2 => O2[3]) = 0;
$setuphold(posedge CE1, posedge I1[4], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[4], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[4], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[4], 0, 0, NOTIFIER);
(CE1 => O1[4]) = 0;
(CE2 => O2[4]) = 0;
$setuphold(posedge CE1, posedge I1[5], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[5], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[5], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[5], 0, 0, NOTIFIER);
(CE1 => O1[5]) = 0;
(CE2 => O2[5]) = 0;
$setuphold(posedge CE1, posedge I1[6], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[6], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[6], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[6], 0, 0, NOTIFIER);
(CE1 => O1[6]) = 0;
(CE2 => O2[6]) = 0;
$setuphold(posedge CE1, posedge I1[7], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[7], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[7], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[7], 0, 0, NOTIFIER);
(CE1 => O1[7]) = 0;
(CE2 => O2[7]) = 0;
$setuphold(posedge CE1, posedge I1[8], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[8], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[8], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[8], 0, 0, NOTIFIER);
(CE1 => O1[8]) = 0;
(CE2 => O2[8]) = 0;
$setuphold(posedge CE1, posedge I1[9], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[9], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[9], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[9], 0, 0, NOTIFIER);
(CE1 => O1[9]) = 0;
(CE2 => O2[9]) = 0;
$setuphold(posedge CE1, posedge I1[10], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[10], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[10], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[10], 0, 0, NOTIFIER);
(CE1 => O1[10]) = 0;
(CE2 => O2[10]) = 0;
$setuphold(posedge CE1, posedge I1[11], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[11], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[11], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[11], 0, 0, NOTIFIER);
(CE1 => O1[11]) = 0;
(CE2 => O2[11]) = 0;
$setuphold(posedge CE1, posedge I1[12], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[12], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[12], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[12], 0, 0, NOTIFIER);
(CE1 => O1[12]) = 0;
(CE2 => O2[12]) = 0;
$setuphold(posedge CE1, posedge I1[13], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[13], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[13], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[13], 0, 0, NOTIFIER);
(CE1 => O1[13]) = 0;
(CE2 => O2[13]) = 0;
$setuphold(posedge CE1, posedge I1[14], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[14], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[14], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[14], 0, 0, NOTIFIER);
(CE1 => O1[14]) = 0;
(CE2 => O2[14]) = 0;
$setuphold(posedge CE1, posedge I1[15], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[15], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[15], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[15], 0, 0, NOTIFIER);
(CE1 => O1[15]) = 0;
(CE2 => O2[15]) = 0;
$setuphold(posedge CE1, posedge I1[16], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[16], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[16], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[16], 0, 0, NOTIFIER);
(CE1 => O1[16]) = 0;
(CE2 => O2[16]) = 0;
$setuphold(posedge CE1, posedge I1[17], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[17], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[17], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[17], 0, 0, NOTIFIER);
(CE1 => O1[17]) = 0;
(CE2 => O2[17]) = 0;
$setuphold(posedge CE1, posedge I1[18], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[18], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[18], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[18], 0, 0, NOTIFIER);
(CE1 => O1[18]) = 0;
(CE2 => O2[18]) = 0;
$setuphold(posedge CE1, posedge I1[19], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[19], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[19], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[19], 0, 0, NOTIFIER);
(CE1 => O1[19]) = 0;
(CE2 => O2[19]) = 0;
$setuphold(posedge CE1, posedge I1[20], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[20], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[20], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[20], 0, 0, NOTIFIER);
(CE1 => O1[20]) = 0;
(CE2 => O2[20]) = 0;
$setuphold(posedge CE1, posedge I1[21], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[21], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[21], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[21], 0, 0, NOTIFIER);
(CE1 => O1[21]) = 0;
(CE2 => O2[21]) = 0;
$setuphold(posedge CE1, posedge I1[22], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[22], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[22], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[22], 0, 0, NOTIFIER);
(CE1 => O1[22]) = 0;
(CE2 => O2[22]) = 0;
$setuphold(posedge CE1, posedge I1[23], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[23], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[23], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[23], 0, 0, NOTIFIER);
(CE1 => O1[23]) = 0;
(CE2 => O2[23]) = 0;
$setuphold(posedge CE1, posedge I1[24], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[24], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[24], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[24], 0, 0, NOTIFIER);
(CE1 => O1[24]) = 0;
(CE2 => O2[24]) = 0;
$setuphold(posedge CE1, posedge I1[25], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[25], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[25], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[25], 0, 0, NOTIFIER);
(CE1 => O1[25]) = 0;
(CE2 => O2[25]) = 0;
$setuphold(posedge CE1, posedge I1[26], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[26], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[26], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[26], 0, 0, NOTIFIER);
(CE1 => O1[26]) = 0;
(CE2 => O2[26]) = 0;
$setuphold(posedge CE1, posedge I1[27], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[27], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[27], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[27], 0, 0, NOTIFIER);
(CE1 => O1[27]) = 0;
(CE2 => O2[27]) = 0;
$setuphold(posedge CE1, posedge I1[28], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[28], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[28], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[28], 0, 0, NOTIFIER);
(CE1 => O1[28]) = 0;
(CE2 => O2[28]) = 0;
$setuphold(posedge CE1, posedge I1[29], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[29], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[29], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[29], 0, 0, NOTIFIER);
(CE1 => O1[29]) = 0;
(CE2 => O2[29]) = 0;
$setuphold(posedge CE1, posedge I1[30], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[30], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[30], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[30], 0, 0, NOTIFIER);
(CE1 => O1[30]) = 0;
(CE2 => O2[30]) = 0;
$setuphold(posedge CE1, posedge I1[31], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge I2[31], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge I1[31], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge I2[31], 0, 0, NOTIFIER);
(CE1 => O1[31]) = 0;
(CE2 => O2[31]) = 0;
$setuphold(posedge CE1, posedge A1[0], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge A2[0], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge A1[0], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge A2[0], 0, 0, NOTIFIER);
$setuphold(posedge CE1, posedge A1[1], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge A2[1], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge A1[1], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge A2[1], 0, 0, NOTIFIER);
$setuphold(posedge CE1, posedge A1[2], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge A2[2], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge A1[2], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge A2[2], 0, 0, NOTIFIER);
$setuphold(posedge CE1, posedge A1[3], 0, 0, NOTIFIER);
$setuphold(posedge CE2, posedge A2[3], 0, 0, NOTIFIER);
$setuphold(posedge CE1, negedge A1[3], 0, 0, NOTIFIER);
$setuphold(posedge CE2, negedge A2[3], 0, 0, NOTIFIER);

endspecify

assign O1 = data_out1;
assign O2 = data_out2;

endmodule
