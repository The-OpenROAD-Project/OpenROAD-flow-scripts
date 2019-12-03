/* EXPECTED-FAILURE: Too many top-level pins

   We want to see that we're getting the correct error messages here, there's no
   way this can work.
*/
module LargePinCount(input clock, input [10000:0] io_wide_bus);
  reg reduce_it;
  assign reduced = reduce_it;
  always @(posedge clock) begin
    reduce_it = |io_wide_bus;
  end
endmodule
