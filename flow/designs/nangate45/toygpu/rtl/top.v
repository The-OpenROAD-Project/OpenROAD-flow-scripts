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


module top (
    input clk,  /* 16MHz clock */
    output USBPU,  /* USB pull-up resistor */

    /*  SPI signals  */
    input SS,
    input SCLK,
    output MISO,
    input MOSI,

    /*  VGA output  */
    output HSYNC,
    output VSYNC,
    output RED,
    output GRN,
    output BLU
);
    /*  Disable USB  */
    assign USBPU = 0;

    

    /*  Generate a 50 MHz internal clock from 16 MHz input clock  */
    /*
    SB_PLL40_CORE #(
        .FEEDBACK_PATH("SIMPLE"),
        .PLLOUT_SELECT("GENCLK"),
        .DIVR(4'b0000),
        .DIVF(7'b0110001),
        .DIVQ(3'b100),
        .FILTER_RANGE(3'b001)
    ) pll (
        .REFERENCECLK(REFCLK),
        .PLLOUTCORE(clk),
        .RESETB(1'b1),
        .BYPASS(1'b0)
    );
    */
    wire swap;
    wire [10:0] write_edge_count;

    wire [10:0] edge_count;
    wire [9:0] edge_read_index;
    wire [9:0] read_bx;
    wire [9:0] read_by;
    wire [9:0] read_ex;
    wire [9:0] read_ey;

    wire enable_edge_write;
    wire [9:0] edge_write_index;
    wire [9:0] write_bx;
    wire [9:0] write_by;
    wire [9:0] write_ex;
    wire [9:0] write_ey;

    /*  Memory for line coordinates to draw  */
    EdgeSwapBuffer edge_buffer (
        .clk(clk),
        .vsync(VSYNC),

        .swap(swap),
        .write_edge_count(write_edge_count),

        .read_edge_count(edge_count),
        .read_index(edge_read_index),
        .read_bx(read_bx),
        .read_by(read_by),
        .read_ex(read_ex),
        .read_ey(read_ey),

        .enable_write(enable_edge_write),
        .write_index(edge_write_index),
        .write_bx(write_bx),
        .write_by(write_by),
        .write_ex(write_ex),
        .write_ey(write_ey)
    );

    wire [9:0] read_x;
    wire [9:0] read_frac;

    wire enable_scratch_write;
    wire [9:0] scratch_write_index;
    wire [9:0] write_x;
    wire [9:0] write_frac;

    /*  Scratch space used by the EdgeStepper during drawing  */
    EdgeScratch edge_scratch (
        .clk(clk),

        .read_index(edge_read_index),
        .read_x(read_x),
        .read_frac(read_frac),

        .enable_write(enable_scratch_write),
        .write_index(scratch_write_index),
        .write_x(write_x),
        .write_frac(write_frac)
    );

    wire frame_step;
    wire line_step;
    wire edge_available;
    wire [9:0] edge_x;

    /*
        Logic for computing pixel coordinates to draw on the current
        scanline given the list of lines in the EdgeSwapBuffer.
    */
    EdgeStepper edge_step (
        .clk(clk),

        .frame_step(frame_step),
        .line_step(line_step),

        .edge_available(edge_available),
        .edge_x(edge_x),

        .edge_count(edge_count),
        .read_edge_index(edge_read_index),
        .read_edge_bx(read_bx),
        .read_edge_by(read_by),
        .read_edge_ex(read_ex),
        .read_edge_ey(read_ey),
        .read_edge_x(read_x),
        .read_edge_frac(read_frac),

        .edge_write_enable(enable_scratch_write),
        .write_edge_index(scratch_write_index),
        .write_edge_x(write_x),
        .write_edge_frac(write_frac)
    );

    wire [9:0] raster_x;
    wire [9:0] raster_y;
    wire raster_color;

    /*
        Buffering for the current scanline being transmitted and
        the scanline being drawn into, which will soon be transmitted.
    */
    RasterLine raster (
        .clk(clk),

        .frame_step(frame_step),
        .line_step(line_step),
        .edge_available(edge_available),
        .edge_x(edge_x),

        .raster_x(raster_x),
        .raster_y(raster_y),
        .color(raster_color)
    );

    /*  Signal generator for VGA 640x480 @ 60 Hz  */
    VGAScan #(
        .CLK_MHZ(50)
    ) vga (
        .clk(clk),
        .hsync(HSYNC),
        .vsync(VSYNC),
        .red(RED),
        .grn(GRN),
        .blu(BLU),

        .scanline_x(raster_x),
        .scanline_y(raster_y),
        .pixel_color(raster_color)
    );

    /*
        Receives edge coordinates to draw in the next frame over
        the SPI bus.
    */
    SPISlave spi (
        .clk(clk),

        .ss(SS),
        .sclk(SCLK),
        .miso(MISO),
        .mosi(MOSI),

        .enable_write(enable_edge_write),
        .write_index(edge_write_index),
        .write_bx(write_bx),
        .write_by(write_by),
        .write_ex(write_ex),
        .write_ey(write_ey),

        .swap(swap),
        .edge_count(write_edge_count)
    );
endmodule
