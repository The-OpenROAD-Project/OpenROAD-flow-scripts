module Alu(
  input  [63:0] io_a,
                io_b,
  output [63:0] io_out
);

  assign io_out = io_a + io_b;
endmodule

