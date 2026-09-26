module fakeram7_64x256 (
  output [255:0] rd_out,
  input [5:0] addr_in,
  input we_in,
  input [255:0] wd_in,
  input clk,
  input ce_in
);
  fakeram45_64x256 mem (
    .rd_out(rd_out),
    .addr_in(addr_in),
    .we_in(we_in),
    .wd_in(wd_in),
    .w_mask_in({256{1'b1}}),
    .clk(clk),
    .ce_in(ce_in)
  );
endmodule

module fakeram7_128x64 (
  output [63:0] rd_out,
  input [6:0] addr_in,
  input we_in,
  input [63:0] wd_in,
  input clk,
  input ce_in
);
  fakeram45_128x64 mem (
    .rd_out(rd_out),
    .addr_in(addr_in),
    .we_in(we_in),
    .wd_in(wd_in),
    .w_mask_in({64{1'b1}}),
    .clk(clk),
    .ce_in(ce_in)
  );
endmodule

module fakeram7_64x28 (
  output [27:0] rd_out,
  input [5:0] addr_in,
  input we_in,
  input [27:0] wd_in,
  input clk,
  input ce_in
);
  fakeram45_64x28 mem (
    .rd_out(rd_out),
    .addr_in(addr_in),
    .we_in(we_in),
    .wd_in(wd_in),
    .w_mask_in({28{1'b1}}),
    .clk(clk),
    .ce_in(ce_in)
  );
endmodule

module fakeram7_64x25 (
  output [24:0] rd_out,
  input [5:0] addr_in,
  input we_in,
  input [24:0] wd_in,
  input clk,
  input ce_in
);
  fakeram45_64x25 mem (
    .rd_out(rd_out),
    .addr_in(addr_in),
    .we_in(we_in),
    .wd_in(wd_in),
    .w_mask_in({25{1'b1}}),
    .clk(clk),
    .ce_in(ce_in)
  );
endmodule
