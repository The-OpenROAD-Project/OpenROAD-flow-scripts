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


/*  Receive coordinates for drawing by acting as an SPI slave  */
module SPISlave(
    input clk,

    input ss,
    input sclk,
    output miso,
    input mosi,

    output enable_write,
    output [9:0] write_index,
    output [9:0] write_bx,
    output [9:0] write_by,
    output [9:0] write_ex,
    output [9:0] write_ey,

    output swap,
    output [10:0] edge_count
);
    reg reg_miso = 0;
    assign miso = reg_miso;

    /*
        Use shift registers for incoming SPI signals, since the SPI
        clock will differ from our clock, and we want stable values
        for logic
    */
    reg [2:0] ss_shift = 0;
    reg [2:0] sclk_shift = 0;
    reg [1:0] mosi_shift = 0;

    /*  Shift in new values from the SPI wires  */
    always @(posedge clk)
    begin
        ss_shift <= { ss_shift[1:0], ss };
        sclk_shift <= { sclk_shift[1:0], sclk };
        mosi_shift <= { mosi_shift[0], mosi };
    end

    /*  Keep track of the number of edges received  */
    reg [10:0] reg_edge_count = 0;
    assign edge_count = reg_edge_count;
    assign write_index = reg_edge_count[9:0];

    /*  Swap edge buffers when an SPI transmission completes  */
    assign swap = (ss_shift[2:1] == 2'b01);

    /*
        We'll receive edges as 40-bit blocks, with 10 bits each
        for begin-x, begin-y, end-x and end-y coordinates
    */
    reg [39:0] edge_shift;
    reg [5:0] edge_bits;

    assign write_bx = edge_shift[39:30];
    assign write_by = edge_shift[29:20];
    assign write_ex = edge_shift[19:10];
    assign write_ey = edge_shift[9:0];

    reg reg_enable_write = 0;
    assign enable_write = reg_enable_write;

    always @(posedge clk)
    begin
        if (ss_shift[2:1] == 2'b10)
        begin
            /*  Reset counters at the start of an SPI transmission  */
            reg_edge_count <= 0;
            edge_bits <= 0;
        end else if (!ss_shift[1] && sclk_shift[2:1] == 2'b01)
        begin
            /*  Shift in a new bit on the positive edge of the SPI clock  */
            edge_shift <= { edge_shift[38:0], mosi_shift[1] };
            edge_bits <= edge_bits + 1;
        end

        if (reg_enable_write)
        begin
            /*  We've finished writing a new edge to the edge buffer  */
            reg_enable_write <= 0;
            reg_edge_count <= reg_edge_count + 1;
        end else if (edge_bits == 40)
        begin
            /*  If we've received 40 bits, write to the edge buffer  */
            reg_enable_write <= 1;
            edge_bits <= 0;
        end
    end
endmodule
