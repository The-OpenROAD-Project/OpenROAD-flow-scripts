module ram_32x64(
  input  [4:0]  R0_addr,
  input         R0_en,
                R0_clk,
  input  [4:0]  R1_addr,
  input         R1_en,
                R1_clk,
  input  [4:0]  R2_addr,
  input         R2_en,
                R2_clk,
  input  [4:0]  R3_addr,
  input         R3_en,
                R3_clk,
  input  [4:0]  R4_addr,
  input         R4_en,
                R4_clk,
  input  [4:0]  R5_addr,
  input         R5_en,
                R5_clk,
  input  [4:0]  R6_addr,
  input         R6_en,
                R6_clk,
  input  [4:0]  R7_addr,
  input         R7_en,
                R7_clk,
  input  [4:0]  W0_addr,
  input         W0_en,
                W0_clk,
  input  [63:0] W0_data,
  input  [7:0]  W0_mask,
  input  [4:0]  W1_addr,
  input         W1_en,
                W1_clk,
  input  [63:0] W1_data,
  input  [7:0]  W1_mask,
  input  [4:0]  W2_addr,
  input         W2_en,
                W2_clk,
  input  [63:0] W2_data,
  input  [7:0]  W2_mask,
  input  [4:0]  W3_addr,
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

  reg [63:0] Memory[0:31];
  reg        _R0_en_d0;
  reg [4:0]  _R0_addr_d0;
  always @(posedge R0_clk) begin
    _R0_en_d0 <= R0_en;
    _R0_addr_d0 <= R0_addr;
  end // always @(posedge)
  reg        _R1_en_d0;
  reg [4:0]  _R1_addr_d0;
  always @(posedge R1_clk) begin
    _R1_en_d0 <= R1_en;
    _R1_addr_d0 <= R1_addr;
  end // always @(posedge)
  reg        _R2_en_d0;
  reg [4:0]  _R2_addr_d0;
  always @(posedge R2_clk) begin
    _R2_en_d0 <= R2_en;
    _R2_addr_d0 <= R2_addr;
  end // always @(posedge)
  reg        _R3_en_d0;
  reg [4:0]  _R3_addr_d0;
  always @(posedge R3_clk) begin
    _R3_en_d0 <= R3_en;
    _R3_addr_d0 <= R3_addr;
  end // always @(posedge)
  reg        _R4_en_d0;
  reg [4:0]  _R4_addr_d0;
  always @(posedge R4_clk) begin
    _R4_en_d0 <= R4_en;
    _R4_addr_d0 <= R4_addr;
  end // always @(posedge)
  reg        _R5_en_d0;
  reg [4:0]  _R5_addr_d0;
  always @(posedge R5_clk) begin
    _R5_en_d0 <= R5_en;
    _R5_addr_d0 <= R5_addr;
  end // always @(posedge)
  reg        _R6_en_d0;
  reg [4:0]  _R6_addr_d0;
  always @(posedge R6_clk) begin
    _R6_en_d0 <= R6_en;
    _R6_addr_d0 <= R6_addr;
  end // always @(posedge)
  reg        _R7_en_d0;
  reg [4:0]  _R7_addr_d0;
  always @(posedge R7_clk) begin
    _R7_en_d0 <= R7_en;
    _R7_addr_d0 <= R7_addr;
  end // always @(posedge)
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
  assign R0_data = _R0_en_d0 ? Memory[_R0_addr_d0] : 64'bx;
  assign R1_data = _R1_en_d0 ? Memory[_R1_addr_d0] : 64'bx;
  assign R2_data = _R2_en_d0 ? Memory[_R2_addr_d0] : 64'bx;
  assign R3_data = _R3_en_d0 ? Memory[_R3_addr_d0] : 64'bx;
  assign R4_data = _R4_en_d0 ? Memory[_R4_addr_d0] : 64'bx;
  assign R5_data = _R5_en_d0 ? Memory[_R5_addr_d0] : 64'bx;
  assign R6_data = _R6_en_d0 ? Memory[_R6_addr_d0] : 64'bx;
  assign R7_data = _R7_en_d0 ? Memory[_R7_addr_d0] : 64'bx;
endmodule

