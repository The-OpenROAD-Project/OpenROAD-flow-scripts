// banked wrapper (bitline-limited): array_2048x137 = 8 x array_2048x137_bk
module array_2048x137 (
  input [10:0] RW0_addr,
  input RW0_en,
  input RW0_clk,
  input RW0_wmode,
  input [136:0] RW0_wdata,
  output [136:0] RW0_rdata
);
  wire [2:0] RW0_bsel = RW0_addr[10:8];
  reg [2:0] RW0_bsel_q;
  always @(posedge RW0_clk) RW0_bsel_q <= RW0_bsel;
  wire [136:0] RW0_rd0;
  wire [136:0] RW0_rd1;
  wire [136:0] RW0_rd2;
  wire [136:0] RW0_rd3;
  wire [136:0] RW0_rd4;
  wire [136:0] RW0_rd5;
  wire [136:0] RW0_rd6;
  wire [136:0] RW0_rd7;
  assign RW0_rdata = (RW0_bsel_q == 3'd0) ? RW0_rd0 : (RW0_bsel_q == 3'd1) ? RW0_rd1 : (RW0_bsel_q == 3'd2) ? RW0_rd2 : (RW0_bsel_q == 3'd3) ? RW0_rd3 : (RW0_bsel_q == 3'd4) ? RW0_rd4 : (RW0_bsel_q == 3'd5) ? RW0_rd5 : (RW0_bsel_q == 3'd6) ? RW0_rd6 : RW0_rd7;
  array_2048x137_bk bank0 (
    .RW0_addr(RW0_addr[7:0]),
    .RW0_en(RW0_en & (RW0_bsel == 3'd0)),
    .RW0_clk(RW0_clk),
    .RW0_wmode(RW0_wmode),
    .RW0_wdata(RW0_wdata),
    .RW0_rdata(RW0_rd0)
  );
  array_2048x137_bk bank1 (
    .RW0_addr(RW0_addr[7:0]),
    .RW0_en(RW0_en & (RW0_bsel == 3'd1)),
    .RW0_clk(RW0_clk),
    .RW0_wmode(RW0_wmode),
    .RW0_wdata(RW0_wdata),
    .RW0_rdata(RW0_rd1)
  );
  array_2048x137_bk bank2 (
    .RW0_addr(RW0_addr[7:0]),
    .RW0_en(RW0_en & (RW0_bsel == 3'd2)),
    .RW0_clk(RW0_clk),
    .RW0_wmode(RW0_wmode),
    .RW0_wdata(RW0_wdata),
    .RW0_rdata(RW0_rd2)
  );
  array_2048x137_bk bank3 (
    .RW0_addr(RW0_addr[7:0]),
    .RW0_en(RW0_en & (RW0_bsel == 3'd3)),
    .RW0_clk(RW0_clk),
    .RW0_wmode(RW0_wmode),
    .RW0_wdata(RW0_wdata),
    .RW0_rdata(RW0_rd3)
  );
  array_2048x137_bk bank4 (
    .RW0_addr(RW0_addr[7:0]),
    .RW0_en(RW0_en & (RW0_bsel == 3'd4)),
    .RW0_clk(RW0_clk),
    .RW0_wmode(RW0_wmode),
    .RW0_wdata(RW0_wdata),
    .RW0_rdata(RW0_rd4)
  );
  array_2048x137_bk bank5 (
    .RW0_addr(RW0_addr[7:0]),
    .RW0_en(RW0_en & (RW0_bsel == 3'd5)),
    .RW0_clk(RW0_clk),
    .RW0_wmode(RW0_wmode),
    .RW0_wdata(RW0_wdata),
    .RW0_rdata(RW0_rd5)
  );
  array_2048x137_bk bank6 (
    .RW0_addr(RW0_addr[7:0]),
    .RW0_en(RW0_en & (RW0_bsel == 3'd6)),
    .RW0_clk(RW0_clk),
    .RW0_wmode(RW0_wmode),
    .RW0_wdata(RW0_wdata),
    .RW0_rdata(RW0_rd6)
  );
  array_2048x137_bk bank7 (
    .RW0_addr(RW0_addr[7:0]),
    .RW0_en(RW0_en & (RW0_bsel == 3'd7)),
    .RW0_clk(RW0_clk),
    .RW0_wmode(RW0_wmode),
    .RW0_wdata(RW0_wdata),
    .RW0_rdata(RW0_rd7)
  );
endmodule
