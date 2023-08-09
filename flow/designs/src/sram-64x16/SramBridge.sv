module SramBridge(
  input         io_clk,
  input  [3:0]  io_ram_wr_addr,
  input         io_ram_we,
  input  [63:0] io_ram_din,
  input         io_ram_re,
  input  [3:0]  io_ram_rd_addr,
  input         io_ram_re2,
  input  [3:0]  io_ram_rd_addr2,
  output [63:0] io_ram_dout,
                io_ram_dout2
);

  wire [31:0] _SRAM2RW16x32_3_O2;
  wire [31:0] _SRAM2RW16x32_2_O2;
  wire [31:0] _SRAM2RW16x32_1_O2;
  wire [31:0] _SRAM2RW16x32_O2;
  SRAM2RW16x32 SRAM2RW16x32 (
    .CE1  (io_clk),
    .CE2  (io_clk),
    .WEB1 (1'h0),
    .WEB2 (1'h1),
    .OEB1 (1'h0),
    .OEB2 (1'h0),
    .CSB1 (~io_ram_we),
    .CSB2 (~io_ram_re),
    .A1   (io_ram_wr_addr),
    .A2   (io_ram_rd_addr),
    .I1   (io_ram_din[63:32]),
    .I2   (32'h0),
    .O1   (/* unused */),
    .O2   (_SRAM2RW16x32_O2)
  );
  SRAM2RW16x32 SRAM2RW16x32_1 (
    .CE1  (io_clk),
    .CE2  (io_clk),
    .WEB1 (1'h0),
    .WEB2 (1'h1),
    .OEB1 (1'h0),
    .OEB2 (1'h0),
    .CSB1 (~io_ram_we),
    .CSB2 (~io_ram_re),
    .A1   (io_ram_wr_addr),
    .A2   (io_ram_rd_addr),
    .I1   (io_ram_din[31:0]),
    .I2   (32'h0),
    .O1   (/* unused */),
    .O2   (_SRAM2RW16x32_1_O2)
  );
  SRAM2RW16x32 SRAM2RW16x32_2 (
    .CE1  (io_clk),
    .CE2  (io_clk),
    .WEB1 (1'h0),
    .WEB2 (1'h1),
    .OEB1 (1'h0),
    .OEB2 (1'h0),
    .CSB1 (~io_ram_we),
    .CSB2 (~io_ram_re2),
    .A1   (io_ram_wr_addr),
    .A2   (io_ram_rd_addr2),
    .I1   (io_ram_din[63:32]),
    .I2   (32'h0),
    .O1   (/* unused */),
    .O2   (_SRAM2RW16x32_2_O2)
  );
  SRAM2RW16x32 SRAM2RW16x32_3 (
    .CE1  (io_clk),
    .CE2  (io_clk),
    .WEB1 (1'h0),
    .WEB2 (1'h1),
    .OEB1 (1'h0),
    .OEB2 (1'h0),
    .CSB1 (~io_ram_we),
    .CSB2 (~io_ram_re2),
    .A1   (io_ram_wr_addr),
    .A2   (io_ram_rd_addr2),
    .I1   (io_ram_din[31:0]),
    .I2   (32'h0),
    .O1   (/* unused */),
    .O2   (_SRAM2RW16x32_3_O2)
  );
  reg [63:0] REG;
  reg [63:0] REG2;
  assign io_ram_dout = REG;
  assign io_ram_dout2 = REG2;
  always @(posedge io_clk) begin
    REG <= {_SRAM2RW16x32_O2, _SRAM2RW16x32_1_O2};
    REG2 <= {_SRAM2RW16x32_2_O2, _SRAM2RW16x32_3_O2};
  end
endmodule

