/*

Copyright (c) 2018, Matt Kimball
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those
of the authors and should not be interpreted as representing official policies,
either expressed or implied, of the ToyGPU project.

*/

/*
    A buffer with a list of edges (i.e. lines from a model) for drawing.

    The edges are stored as pairs of (x, y) coordinates with a begin point
    and an end point.  For the purposes of the EdgeStepper, the the begin
    y coordinate is assumed to be less than or equal to the end y coordinate,
    but there is no ordering requirement on the x coordinate.
*/
module EdgeBuffer #(
    parameter integer count = 1024
) (
    input clk,

    input [9:0] read_index,
    output [9:0] read_bx,
    output [9:0] read_by,
    output [9:0] read_ex,
    output [9:0] read_ey,

    input enable_write,
    input [9:0] write_index,
    input [9:0] write_bx,
    input [9:0] write_by,
    input [9:0] write_ex,
    input [9:0] write_ey
);
    reg [9:0] bx [0:count - 1];
    reg [9:0] by [0:count - 1];
    reg [9:0] ex [0:count - 1];
    reg [9:0] ey [0:count - 1];

    always @(posedge clk)
    begin
        read_bx <= bx[read_index];
        read_by <= by[read_index];
        read_ex <= ex[read_index];
        read_ey <= ey[read_index];

        if (enable_write)
        begin
            bx[write_index] <= write_bx;
            by[write_index] <= write_by;
            ex[write_index] <= write_ex;
            ey[write_index] <= write_ey;
        end
    end
endmodule


/*
    Scratch space used by the EdgeStepper to track the state of a 
    draw operation of a particular edge between scanlines.

    We store both an x-coordinate offset (from the begin x coordinate)
    and a fractional (i.e. subpixel) value indicating how close the
    stepper is to incrementing the x offset in the next scanline.
*/
module EdgeScratch #(
    parameter integer count = 1024
) (
    input clk,

    input [9:0] read_index,
    output [9:0] read_x,
    output [9:0] read_frac,

    input enable_write,
    input [9:0] write_index,
    input [9:0] write_x,
    input [9:0] write_frac
);
    reg [9:0] x [0:count - 1];
    reg [9:0] frac [0:count - 1];

    always @(posedge clk)
    begin
        read_x <= x[read_index];
        read_frac <= frac[read_index];

        if (enable_write)
        begin
            x[write_index] <= write_x;
            frac[write_index] <= write_frac;
        end
    end
endmodule
