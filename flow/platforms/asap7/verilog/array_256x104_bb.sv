(* blackbox *)
module array_256x104 (
  input [7:0] RW0_addr,
  input RW0_en,
  input RW0_clk,
  input RW0_wmode,
  input [103:0] RW0_wdata,
  output [103:0] RW0_rdata,
  input [7:0] RW0_wmask
);
endmodule
