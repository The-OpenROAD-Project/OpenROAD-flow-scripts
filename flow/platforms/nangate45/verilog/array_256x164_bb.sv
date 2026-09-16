(* blackbox *)
module array_256x164 (
  input [7:0] RW0_addr,
  input RW0_en,
  input RW0_clk,
  input RW0_wmode,
  input [163:0] RW0_wdata,
  output [163:0] RW0_rdata,
  input [3:0] RW0_wmask
);
endmodule
