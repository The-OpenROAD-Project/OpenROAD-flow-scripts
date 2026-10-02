//#############################################################################
// Copyright: Zero ASIC. All rights Reserved.
// Author: Andreas Olofsson
// License:  MIT (see LICENSE file in LogikBench repository)
//#############################################################################
//
// N x N weight-stationary systolic array (the TPU MXU core).
//
// One tpu_pe per grid element, wired as a 2D mesh (per CLAUDE.md: replicated
// hardware via generate, never a procedural unroll):
//
//   - weights load from the top: w_top[j] feeds column j; each column is a
//     vertical shift register (w_south of PE(i,j) -> w_north of PE(i+1,j)).
//   - activations flow west to east: a_left[i] enters row i; a_east of PE(i,j)
//     feeds a_west of PE(i,j+1).
//   - partial sums flow north to south and accumulate; the top row's psum_north
//     is tied to zero (fresh accumulation), and c_bot[j] is the column-j result
//     leaving the bottom row.
//
// With weight B[i][j] held at PE(i,j) and activation A[m][i] entering row i,
// column j computes C[m][j] = sum_i A[m][i] * B[i][j]. Input/output skew (which
// time-aligns rows and columns) lives in the tpu top, not here.
//
//#############################################################################

module tpu_array
  #(parameter N = 8,	 // array dimension (N x N PEs)
    parameter DW = 8,	 // operand width (signed)
    parameter ACCW = 32) // accumulator width (signed)
   (
    input		clk,
    input		rst,	// synchronous, active high
    input		ld,	// weight-load shift enable
    input		en,	// compute enable
    input [N*DW-1:0]	w_top,	// weight inputs, one per column (load)
    input [N*DW-1:0]	a_left,	// activation inputs, one per row
    output [N*ACCW-1:0]	c_bot	// column results, one per column
    );

   // mesh nets: a_h carries activations east, psum_v carries sums south,
   // w_v carries weights south during load.
   wire [DW-1:0]   a_h    [0:N-1][0:N];
   wire [ACCW-1:0] psum_v [0:N][0:N-1];
   wire [DW-1:0]   w_v    [0:N][0:N-1];

   genvar	   i, j;
   generate
      // west edge: activation inputs into column 0 of each row
      for (i = 0; i < N; i = i + 1) begin : g_west
         assign a_h[i][0] = a_left[i*DW +: DW];
      end
      // top edge: zero partial sums, weight inputs; bottom edge: results out
      for (j = 0; j < N; j = j + 1) begin : g_edge
         assign psum_v[0][j] = {ACCW{1'b0}};
         assign w_v[0][j]    = w_top[j*DW +: DW];
         assign c_bot[j*ACCW +: ACCW] = psum_v[N][j];
      end
      // the PE mesh
      for (i = 0; i < N; i = i + 1) begin : g_pe_row
         for (j = 0; j < N; j = j + 1) begin : g_pe_col
            tpu_pe #(.DW(DW), .ACCW(ACCW)) u_pe
              (.clk        (clk),
               .rst        (rst),
               .ld         (ld),
               .en         (en),
               .w_north    (w_v[i][j]),
               .a_west     (a_h[i][j]),
               .psum_north (psum_v[i][j]),
               .w_south    (w_v[i+1][j]),
               .a_east     (a_h[i][j+1]),
               .psum_south (psum_v[i+1][j]));
         end
      end
   endgenerate

endmodule
