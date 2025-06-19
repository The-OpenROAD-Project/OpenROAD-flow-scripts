(* blackbox *)
module fakeram7_64x256 (
   output reg [255:0] rd_out,
   input [5:0] addr_in,
   input we_in,
   input [255:0] wd_in,
   input clk,
   input ce_in
);
endmodule
