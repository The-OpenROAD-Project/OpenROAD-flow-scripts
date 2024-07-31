/* ****************************************************************************
  SPDX-License-Identifier: CERN-OHL-W-2.0

  Description:
  Simple single clocked dual port ram (separate read and write ports),
  with optional bypass logic.

  Copyright (C) 2012 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>

 ******************************************************************************/

module mor1kx_simple_dpram_sclk
  #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter CLEAR_ON_INIT = 0,
    parameter ENABLE_BYPASS = 1
    )
   (
    input 		    clk,
    input [ADDR_WIDTH-1:0]  raddr,
    input 		    re,
    input [ADDR_WIDTH-1:0]  waddr,
    input 		    we,
    input [DATA_WIDTH-1:0]  din,
    output [DATA_WIDTH-1:0] dout
    );

   reg [DATA_WIDTH-1:0]     mem[(1<<ADDR_WIDTH)-1:0];
   reg [DATA_WIDTH-1:0]     rdata;

generate
if(CLEAR_ON_INIT) begin :clear_on_init
   integer 		    idx;
   initial
     for(idx=0; idx < (1<<ADDR_WIDTH); idx=idx+1)
       mem[idx] = {DATA_WIDTH{1'b0}};
end
endgenerate

generate
if (ENABLE_BYPASS) begin : bypass_gen
   reg [DATA_WIDTH-1:0]     din_r;
   reg 			    bypass;

   assign dout = bypass ? din_r : rdata;

   always @(posedge clk)
     if (re)
       din_r <= din;

   always @(posedge clk)
     if (waddr == raddr && we && re)
       bypass <= 1;
     else if (re)
       bypass <= 0;
end else begin
   assign dout = rdata;
end
endgenerate

   always @(posedge clk) begin
      if (we)
	mem[waddr] <= din;
      if (re)
	rdata <= mem[raddr];
   end

/*--------------Formal checking---------------*/

`ifdef FORMAL

   reg f_past_valid;
   wire f_bypass;

   initial f_past_valid = 1'b0;
   always @(posedge clk)
      f_past_valid <= 1'b1;

   assign f_bypass = waddr == raddr && we && re && ENABLE_BYPASS;

`ifdef SDPRAM

   (* anyconst *) wire [ADDR_WIDTH-1:0] f_addr;
   reg [DATA_WIDTH-1:0] f_data;

   initial assume (f_data == mem[f_addr]);
   always @(*)
	assert(mem[f_addr] == f_data);

   //Writing f_data at address f_addr
   always @(posedge clk)
      if (we && waddr == f_addr)
         f_data <= din;

   //Read access for the non bypass case
   always @(posedge clk)
      if (f_past_valid && $past(re) && $past(raddr == f_addr)
          && $past(!f_bypass))
         assert (dout == $past(f_data));

   always @(posedge clk) begin
       c0_write: cover (f_past_valid && we);
       c1_read: cover (f_past_valid && re);
       c2_bypass: cover (f_past_valid && waddr == raddr && we && re);
   end

`endif

   //Read access for the bypass case
   always @(posedge clk)
      if (f_past_valid && $past(f_bypass))
         assert (dout == $past(din));

   //Output data should remain unchanged if there is no read enable
   always @(posedge clk)
      if (f_past_valid && !$past(re))
         assert ($stable(dout));

   //Output data changes only if there is read or write enable
   always @(posedge clk)
      if (f_past_valid && $changed(dout))
         assert ($past(re) | $past(we));
`endif

endmodule
