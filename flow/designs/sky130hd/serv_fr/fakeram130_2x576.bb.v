module fakeram130_2x576
(
`ifdef USE_POWER_PINS
	vccd1,
	vssd1,
`endif
   rd_out,
   addr_in,
   we_in,
   wd_in,
   w_mask_in,
   clk,
   ce_in
);
   parameter BITS = 2;
   parameter WORD_DEPTH = 576;
   parameter ADDR_WIDTH = 10;
   parameter corrupt_mem_on_X_p = 1;

   output reg [BITS-1:0]    rd_out;
   input  [ADDR_WIDTH-1:0]  addr_in;
   input                    we_in;
   input  [BITS-1:0]        wd_in;
   input  [BITS-1:0]        w_mask_in;
   input                    clk;
   input                    ce_in;
   `ifdef USE_POWER_PINS
	inout	vccd1;
	inout	vssd1;
`endif
endmodule
