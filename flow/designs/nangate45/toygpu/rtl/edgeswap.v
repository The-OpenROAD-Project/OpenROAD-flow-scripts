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
    Keep two buffers of edge coordinates for drawing.
    After we've fininshed receiving a new edge buffer from an SPI
    transmission, swap the buffers at the next VSYNC.
*/
module EdgeSwapBuffer #(
    parameter integer count = 1024
) (
    input clk,
    input vsync,

    input swap,
    input [10:0] write_edge_count,

    output [10:0] read_edge_count,
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
    wire [9:0] read_bx_a;
    wire [9:0] read_by_a;
    wire [9:0] read_ex_a;
    wire [9:0] read_ey_a;
    wire enable_write_a;

    EdgeBuffer buffer_a (
        .clk(clk),

        .read_index(read_index),
        .read_bx(read_bx_a),
        .read_by(read_by_a),
        .read_ex(read_ex_a),
        .read_ey(read_ey_a),

        .enable_write(enable_write_a),
        .write_index(write_index),
        .write_bx(write_bx),
        .write_by(write_by),
        .write_ex(write_ex),
        .write_ey(write_ey)
    );

    wire [9:0] read_bx_b;
    wire [9:0] read_by_b;
    wire [9:0] read_ex_b;
    wire [9:0] read_ey_b;
    wire enable_write_b;

    EdgeBuffer buffer_b (
        .clk(clk),

        .read_index(read_index),
        .read_bx(read_bx_b),
        .read_by(read_by_b),
        .read_ex(read_ex_b),
        .read_ey(read_ey_b),

        .enable_write(enable_write_b),
        .write_index(write_index),
        .write_bx(write_bx),
        .write_by(write_by),
        .write_ex(write_ex),
        .write_ey(write_ey)
    );

    /*  Track which buffer is active (i.e. being read from)  */
    reg active_buffer = 0;

    /*
        The read lines are from the active buffer, and the writes
        go to the inactive buffer
    */
    assign read_bx = active_buffer ? read_bx_b : read_bx_a;
    assign read_by = active_buffer ? read_by_b : read_by_a;
    assign read_ex = active_buffer ? read_ex_b : read_ex_a;
    assign read_ey = active_buffer ? read_ey_b : read_ey_a;
    assign enable_write_a = active_buffer && enable_write;
    assign enable_write_b = ~active_buffer && enable_write;

    /*  The number of edges in the read buffer  */
    reg [10:0] edge_count = 0;
    assign read_edge_count = edge_count;

    /*  The number of edges in the buffer to be swapped to  */
    reg [10:0] swap_edge_count;

    /*  Is a swap pending upon the next VSYNC?  */
    reg swap_pending = 0;

    always @(posedge clk)
    begin
        if (swap)
        begin
            /*  The SPI slave has requested a buffer swap at next VSYNC  */
            swap_pending <= 1;
            swap_edge_count <= write_edge_count;
        end else if (!vsync && swap_pending)
        begin
            /*  Switch active and write buffers  */
            swap_pending <= 0;
            edge_count <= swap_edge_count;
            active_buffer <= ~active_buffer;
        end
    end
endmodule
