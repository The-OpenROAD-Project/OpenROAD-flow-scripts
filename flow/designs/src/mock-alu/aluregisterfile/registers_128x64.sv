module registers_128x64(
  input  [6:0]  R0_addr,
  input         R0_en,
                R0_clk,
  input  [6:0]  R1_addr,
  input         R1_en,
                R1_clk,
  input  [6:0]  R2_addr,
  input         R2_en,
                R2_clk,
  input  [6:0]  R3_addr,
  input         R3_en,
                R3_clk,
  input  [6:0]  R4_addr,
  input         R4_en,
                R4_clk,
  input  [6:0]  R5_addr,
  input         R5_en,
                R5_clk,
  input  [6:0]  R6_addr,
  input         R6_en,
                R6_clk,
  input  [6:0]  R7_addr,
  input         R7_en,
                R7_clk,
  input  [6:0]  W0_addr,
  input         W0_en,
                W0_clk,
  input  [63:0] W0_data,
  input  [7:0]  W0_mask,
  input  [6:0]  W1_addr,
  input         W1_en,
                W1_clk,
  input  [63:0] W1_data,
  input  [7:0]  W1_mask,
  input  [6:0]  W2_addr,
  input         W2_en,
                W2_clk,
  input  [63:0] W2_data,
  input  [7:0]  W2_mask,
  input  [6:0]  W3_addr,
  input         W3_en,
                W3_clk,
  input  [63:0] W3_data,
  input  [7:0]  W3_mask,
  output [63:0] R0_data,
                R1_data,
                R2_data,
                R3_data,
                R4_data,
                R5_data,
                R6_data,
                R7_data
);

  reg [63:0] Memory[0:127];
  always @(posedge W0_clk) begin
    if (W0_en & W0_mask[0])
      Memory[W0_addr][32'h0 +: 8] <= W0_data[7:0];
    if (W0_en & W0_mask[1])
      Memory[W0_addr][32'h8 +: 8] <= W0_data[15:8];
    if (W0_en & W0_mask[2])
      Memory[W0_addr][32'h10 +: 8] <= W0_data[23:16];
    if (W0_en & W0_mask[3])
      Memory[W0_addr][32'h18 +: 8] <= W0_data[31:24];
    if (W0_en & W0_mask[4])
      Memory[W0_addr][32'h20 +: 8] <= W0_data[39:32];
    if (W0_en & W0_mask[5])
      Memory[W0_addr][32'h28 +: 8] <= W0_data[47:40];
    if (W0_en & W0_mask[6])
      Memory[W0_addr][32'h30 +: 8] <= W0_data[55:48];
    if (W0_en & W0_mask[7])
      Memory[W0_addr][32'h38 +: 8] <= W0_data[63:56];
    if (W1_en & W1_mask[0])
      Memory[W1_addr][32'h0 +: 8] <= W1_data[7:0];
    if (W1_en & W1_mask[1])
      Memory[W1_addr][32'h8 +: 8] <= W1_data[15:8];
    if (W1_en & W1_mask[2])
      Memory[W1_addr][32'h10 +: 8] <= W1_data[23:16];
    if (W1_en & W1_mask[3])
      Memory[W1_addr][32'h18 +: 8] <= W1_data[31:24];
    if (W1_en & W1_mask[4])
      Memory[W1_addr][32'h20 +: 8] <= W1_data[39:32];
    if (W1_en & W1_mask[5])
      Memory[W1_addr][32'h28 +: 8] <= W1_data[47:40];
    if (W1_en & W1_mask[6])
      Memory[W1_addr][32'h30 +: 8] <= W1_data[55:48];
    if (W1_en & W1_mask[7])
      Memory[W1_addr][32'h38 +: 8] <= W1_data[63:56];
    if (W2_en & W2_mask[0])
      Memory[W2_addr][32'h0 +: 8] <= W2_data[7:0];
    if (W2_en & W2_mask[1])
      Memory[W2_addr][32'h8 +: 8] <= W2_data[15:8];
    if (W2_en & W2_mask[2])
      Memory[W2_addr][32'h10 +: 8] <= W2_data[23:16];
    if (W2_en & W2_mask[3])
      Memory[W2_addr][32'h18 +: 8] <= W2_data[31:24];
    if (W2_en & W2_mask[4])
      Memory[W2_addr][32'h20 +: 8] <= W2_data[39:32];
    if (W2_en & W2_mask[5])
      Memory[W2_addr][32'h28 +: 8] <= W2_data[47:40];
    if (W2_en & W2_mask[6])
      Memory[W2_addr][32'h30 +: 8] <= W2_data[55:48];
    if (W2_en & W2_mask[7])
      Memory[W2_addr][32'h38 +: 8] <= W2_data[63:56];
    if (W3_en & W3_mask[0])
      Memory[W3_addr][32'h0 +: 8] <= W3_data[7:0];
    if (W3_en & W3_mask[1])
      Memory[W3_addr][32'h8 +: 8] <= W3_data[15:8];
    if (W3_en & W3_mask[2])
      Memory[W3_addr][32'h10 +: 8] <= W3_data[23:16];
    if (W3_en & W3_mask[3])
      Memory[W3_addr][32'h18 +: 8] <= W3_data[31:24];
    if (W3_en & W3_mask[4])
      Memory[W3_addr][32'h20 +: 8] <= W3_data[39:32];
    if (W3_en & W3_mask[5])
      Memory[W3_addr][32'h28 +: 8] <= W3_data[47:40];
    if (W3_en & W3_mask[6])
      Memory[W3_addr][32'h30 +: 8] <= W3_data[55:48];
    if (W3_en & W3_mask[7])
      Memory[W3_addr][32'h38 +: 8] <= W3_data[63:56];
  end // always @(posedge)
  assign R0_data = R0_en ? Memory[R0_addr] : 64'bx;
  assign R1_data = R1_en ? Memory[R1_addr] : 64'bx;
  assign R2_data = R2_en ? Memory[R2_addr] : 64'bx;
  assign R3_data = R3_en ? Memory[R3_addr] : 64'bx;
  assign R4_data = R4_en ? Memory[R4_addr] : 64'bx;
  assign R5_data = R5_en ? Memory[R5_addr] : 64'bx;
  assign R6_data = R6_en ? Memory[R6_addr] : 64'bx;
  assign R7_data = R7_en ? Memory[R7_addr] : 64'bx;
endmodule

