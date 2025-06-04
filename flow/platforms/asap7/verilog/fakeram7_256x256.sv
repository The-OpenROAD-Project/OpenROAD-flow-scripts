(* blackbox *)
module fakeram7_256x256 (
   output reg [255:0] rd_out,
   input [7:0] addr_in,
   input we_in,
   input [255:0] wd_in,
   input clk,
   input ce_in
);
endmodule
