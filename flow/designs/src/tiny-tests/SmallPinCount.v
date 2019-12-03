module SmallPinCount(input clock,
    input [5:0] io_wide_bus,
    output reduced);
  reg reduce_it;
  assign reduced = reduce_it;
  always @(posedge clock) begin
    reduce_it = |io_wide_bus;
  end
endmodule
