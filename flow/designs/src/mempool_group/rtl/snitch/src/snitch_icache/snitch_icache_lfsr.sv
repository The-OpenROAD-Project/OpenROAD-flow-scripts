// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Fabian Schuiki <fschuiki@iis.ee.ethz.ch>

/// A linear feedback shift register.
///
/// The register provides a maximum length sequence for N <= 32. For larger N,
/// multiple LFSR are instantiated. Note that the generated sequence is forced
/// to include the value 0, making it length 2**N instead of the usual 2**N-1.
module snitch_icache_lfsr #(
    parameter int N = -1
)(
    input  logic         clk_i,
    input  logic         rst_ni,
    output logic [N-1:0] value_o,
    input  logic         enable_i
);

    `ifndef SYNTHESIS
    initial assert(N > 0);
    `endif

    if (N > 32) begin : g_split

        localparam int N0 = N/2;
        localparam int N1 = N-N0;

        snitch_icache_lfsr #(N0) i_lo (
            .clk_i    ( clk_i           ),
            .rst_ni   ( rst_ni          ),
            .value_o  ( value_o[N0-1:0] ),
            .enable_i ( enable_i        )
        );

        snitch_icache_lfsr #(N1) i_hi (
            .clk_i    ( clk_i                            ),
            .rst_ni   ( rst_ni                           ),
            .value_o  ( value_o[N-1:N0]                  ),
            .enable_i ( enable_i && value_o[N0-1:0] == 0 )
        );

    end else if (N == 1) begin : g_toggle

        logic q;

        always_ff @(posedge clk_i, negedge rst_ni) begin
            if (!rst_ni)
                q <= 0;
            else if (enable_i)
                q <= ~q;
        end

        assign value_o = q;

    end else begin : g_impl

        logic [N-1:0] q, d, taps;

        assign value_o = q;

        always_ff @(posedge clk_i, negedge rst_ni) begin
            if (!rst_ni)
                q <= 0;
            else if (enable_i)
                q <= d;
        end

        always_comb begin
            if (q == '0) begin
                d = '1;
            end else begin
                d = {1'b0, q[N-1:1]};
                if (q[0]) d ^= taps;
                if (d == '1) d = '0;
            end
        end

        // A lookup table for the taps.
        always_comb begin
            taps = 1 << (N-1);
            case (N)
                2:  taps = $unsigned( 1<< 1 | 1<< 0                 );
                3:  taps = $unsigned( 1<< 2 | 1<< 1                 );
                4:  taps = $unsigned( 1<< 3 | 1<< 2                 );
                5:  taps = $unsigned( 1<< 4 | 1<< 2                 );
                6:  taps = $unsigned( 1<< 5 | 1<< 4                 );
                7:  taps = $unsigned( 1<< 6 | 1<< 5                 );
                8:  taps = $unsigned( 1<< 7 | 1<< 5 | 1<< 4 | 1<< 3 );
                9:  taps = $unsigned( 1<< 8 | 1<< 4                 );
                10: taps = $unsigned( 1<< 9 | 1<< 6                 );
                11: taps = $unsigned( 1<<10 | 1<< 8                 );
                12: taps = $unsigned( 1<<11 | 1<<10 | 1<< 9 | 1<< 3 );
                13: taps = $unsigned( 1<<12 | 1<<11 | 1<<10 | 1<< 7 );
                14: taps = $unsigned( 1<<13 | 1<<12 | 1<<11 | 1<< 1 );
                15: taps = $unsigned( 1<<14 | 1<<13                 );
                16: taps = $unsigned( 1<<15 | 1<<14 | 1<<12 | 1<< 3 );
                17: taps = $unsigned( 1<<16 | 1<<13                 );
                18: taps = $unsigned( 1<<17 | 1<<10                 );
                19: taps = $unsigned( 1<<18 | 1<<17 | 1<<16 | 1<<13 );
                20: taps = $unsigned( 1<<19 | 1<<16                 );
                21: taps = $unsigned( 1<<20 | 1<<18                 );
                22: taps = $unsigned( 1<<21 | 1<<20                 );
                23: taps = $unsigned( 1<<22 | 1<<17                 );
                24: taps = $unsigned( 1<<23 | 1<<22 | 1<<21 | 1<<16 );
                25: taps = $unsigned( 1<<24 | 1<<21                 );
                26: taps = $unsigned( 1<<25 | 1<< 5 | 1<< 1 | 1<< 0 );
                27: taps = $unsigned( 1<<26 | 1<< 4 | 1<< 1 | 1<< 0 );
                28: taps = $unsigned( 1<<27 | 1<<24                 );
                29: taps = $unsigned( 1<<28 | 1<<26                 );
                30: taps = $unsigned( 1<<29 | 1<< 5 | 1<< 3 | 1<< 0 );
                31: taps = $unsigned( 1<<30 | 1<<27                 );
                32: taps = $unsigned( 1<<31 | 1<<21 | 1<< 1 | 1<< 0 );
            endcase;
        end

    end

endmodule
