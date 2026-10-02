//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// Processing element (PE) for the weight-stationary systolic array (TPU MXU).
//
// Each PE holds one stationary signed weight 'w'. Two independent datapaths
// share the cell:
//
//   Weight load (ld): the weights form a per-column shift register that loads
//   from the top. On each ld cycle the PE captures the weight from the PE above
//   (w_north) and presents its stored weight downward (w_south). After N load
//   cycles every PE in a column holds its final stationary weight.
//
//   Compute (en): the activation flows west to east (registered, one hop per
//   cycle) and the partial sum flows north to south, accumulating the local
//   product a_west * w. This is the only arithmetic cell in the array: one
//   signed DW x DW multiply plus an ACCW-bit add.
//
//#############################################################################

module tpu_pe
  #(parameter DW = 8,	 // operand width (signed)
    parameter ACCW = 32) // accumulator / partial-sum width (signed)
   (
    input		  clk,
    input		  rst,	      // synchronous, active high
    input		  ld,	      // weight-load shift enable
    input		  en,	      // compute enable
    input [DW-1:0]	  w_north,    // weight in from PE above
    input [DW-1:0]	  a_west,     // activation in from west
    input [ACCW-1:0]	  psum_north, // partial sum in from above
    output [DW-1:0]	  w_south,    // stored weight out to PE below
    output reg [DW-1:0]	  a_east,     // activation out to east
    output reg [ACCW-1:0] psum_south  // partial sum out to below
    );

   // stationary weight register; presented downward for the load shift chain
   reg [DW-1:0] w;
   assign w_south = w;

   // local product: the ONLY signed operation. Operands are interpreted as
   // signed here via $signed; the 2*DW-bit result holds the two's-complement
   // product, which is then sign-extended to the accumulator width below.
   wire [2*DW-1:0] prod = $signed(a_west) * $signed(w);

   always @(posedge clk) begin
      if (rst) begin
         w          <= {DW{1'b0}};
         a_east     <= {DW{1'b0}};
         psum_south <= {ACCW{1'b0}};
      end
      else begin
         if (ld)
           w <= w_north;
         if (en) begin
            a_east     <= a_west;
            psum_south <= psum_north +
                          {{(ACCW-2*DW){prod[2*DW-1]}}, prod};
         end
      end
   end

endmodule
