module Mul(
    input clock,
    input  [7:0] io_src_0, io_src_1,
    output reg [7:0] io_dst
);
  always @(posedge clock) begin
    io_dst <= io_src_0 * io_src_1;
  end
endmodule
