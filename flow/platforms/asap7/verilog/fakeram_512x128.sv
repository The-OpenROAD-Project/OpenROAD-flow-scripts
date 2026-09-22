(* blackbox *)
module fakeram_512x128 (
   output reg [127:0] rd_out,
   input [8:0] addr_in,
   input we_in,
   input [127:0] wd_in,
   input clk,
   input ce_in
);
endmodule
