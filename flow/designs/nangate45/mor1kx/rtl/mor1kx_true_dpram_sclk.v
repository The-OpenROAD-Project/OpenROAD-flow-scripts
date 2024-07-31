/* ****************************************************************************
  SPDX-License-Identifier: CERN-OHL-W-2.0

  Description: True dual port ram with dual clock's

  Copyright (C) 2013 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>

 ******************************************************************************/

module mor1kx_true_dpram_sclk
  #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
    )
   (
    /* Port A */
    input                   clk_a,
    input [ADDR_WIDTH-1:0]  addr_a,
    input                   we_a,
    input [DATA_WIDTH-1:0]  din_a,
    output [DATA_WIDTH-1:0] dout_a,

    /* Port B */
    input                   clk_b,
    input [ADDR_WIDTH-1:0]  addr_b,
    input                   we_b,
    input [DATA_WIDTH-1:0]  din_b,
    output [DATA_WIDTH-1:0] dout_b
    );

   reg [DATA_WIDTH-1:0]     mem[(1<<ADDR_WIDTH)-1:0];

   reg [DATA_WIDTH-1:0]     rdata_a;
   reg [DATA_WIDTH-1:0]     rdata_b;

   assign dout_a = rdata_a;
   assign dout_b = rdata_b;

   always @(posedge clk_a) begin
      if (we_a) begin
         mem[addr_a] <= din_a;
         rdata_a <= din_a;
      end else begin
         rdata_a <= mem[addr_a];
      end
   end

   always @(posedge clk_b) begin
      if (we_b) begin
         mem[addr_b] <= din_b;
         rdata_b <= din_b;
      end else begin
         rdata_b <= mem[addr_b];
      end
   end

/*-----------------Formal Checking------------------*/

`ifdef FORMAL

   reg f_past_valid;
   (* gclk *) reg global_clock;
   initial f_past_valid = 1'b0;

   always @(posedge global_clock)
      f_past_valid <= 1'b1;

`ifdef TDPRAM
`define ASSUME assume
`else
`define ASSUME assert
`endif

   // Don't allow write to the same address from both ports
   always @(*)
      if (we_a & we_b)
	 `ASSUME (addr_a != addr_b);

`ifdef TDPRAM

   (* anyconst *) wire [ADDR_WIDTH-1:0] f_addr_a;
   (* anyconst *) wire [ADDR_WIDTH-1:0] f_addr_b;

   reg [DATA_WIDTH-1:0] f_data_a;
   reg [DATA_WIDTH-1:0] f_data_ab; // a port writes to b address
   reg [DATA_WIDTH-1:0] f_data_b;
   reg [DATA_WIDTH-1:0] f_data_ba; // b port writes to a address

   // Setup properties for confirming memory
   initial f_data_ab = 0;
   initial f_data_ba = 0;
   initial assume (f_data_a == mem[f_addr_a]);
   initial assume (f_data_b == mem[f_addr_b]);
   always @(*) begin
      assert (f_data_a == mem[f_addr_a] | f_data_ba == mem[f_addr_a]);
      assert (f_data_b == mem[f_addr_b] | f_data_ab == mem[f_addr_b]);
   end

   // Track writes and reads to port A
   always @(posedge clk_a) begin
      // Port A: Capture writing any data to address f_addr_a
      if (we_a && addr_a == f_addr_a)
	 f_data_a <= din_a;

      // Port A: Capture writing any data to address f_addr_b
      //         this may show up on port B
      if (we_a && addr_a == f_addr_b)
	 f_data_ab <= din_a;

      //Port A: When reading or writing we always get our data on dout
      //        the data may be written from port A or port B
      if ($rose(clk_a) && $past(addr_a) == f_addr_a)
	 assert (dout_a == f_data_a | dout_a == f_data_ba);
   end

   // Track writes and reads to port B
   always @(posedge clk_b) begin
      // Port B: Capture writing any data to address f_addr_b
      if (we_b && addr_b == f_addr_b)
	 f_data_b <= din_b;

      // Port B: Capture writing any data to address f_addr_a
      //         this may show up on port A
      if (we_b && addr_b == f_addr_a)
	 f_data_ba <= din_b;

      // Port B: When reading or writing we always get our data on dout
      //         the data may be written from port A or port B
      if ($rose(clk_b) && $past(addr_b) == f_addr_b)
	 assert (dout_b == f_data_b | dout_b == f_data_ab);
   end

   always @(posedge global_clock) begin
      c0_write_a: cover property (f_past_valid && $rose(clk_a) &&
				  $past(we_a) && $past(addr_a) == f_addr_a);
      c1_read_a: cover property (f_past_valid && $rose(clk_a) &&
				 !$past(we_a) && $past(addr_a) == f_addr_a);

      c2_write_b: cover property (f_past_valid && $rose(clk_b) &&
				  $past(we_b) && $past(addr_b) == f_addr_b);
      c3_read_b: cover property (f_past_valid && $rose(clk_b) &&
				 !$past(we_b) && $past(addr_b) == f_addr_b);
   end
`endif

`endif
endmodule
