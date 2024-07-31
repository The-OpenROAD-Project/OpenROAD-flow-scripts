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
    One memory block, which stores four separate one bit per pixel
    scanlines.  The bank selector distinguishes between the scanlines.
*/
module LineBuffer (
    input clk,

    input [1:0] read_bank,
    input [9:0] read_index,
    output read_color,

    input write_enable,
    input [1:0] write_bank,
    input [9:0] write_index,
    input write_color
);
    reg buffer [0:4095];

    always @(posedge clk)
    begin
        read_color <= buffer[{read_bank, read_index}];

        if (write_enable)
        begin
            buffer[{write_bank, write_index}] <= write_color;
        end
    end
endmodule


/*
    Manage buffering between the scanlines stored in LineBuffer.

    At a particular time, three scanlines are being operated upon:

    - One scanline is being sent to the display as a sequence of color values
    - The next scanline is being drawn into using pixel coordinates from the 
      EdgeStepper
    - A third scanline is being cleared in preparation for drawing
*/
module RasterLine #(
    parameter integer scan_height = 524
) (
    input clk,

    output frame_step,
    output line_step,
    input edge_available,
    input [9:0] edge_x,

    input [9:0] raster_x,
    input [9:0] raster_y,
    output color
);
    wire [1:0] buff_read_bank;
    wire [1:0] buff_write_bank;
    wire [9:0] buff_write_index;
    wire buff_write_color;

    /*  Storage for the scanlines we operate on  */
    LineBuffer buff (
        .clk(clk),

        .read_index(raster_x),
        .read_bank(buff_read_bank),
        .read_color(color),

        .write_enable(1),
        .write_bank(buff_write_bank),
        .write_index(buff_write_index),
        .write_color(buff_write_color)
    );

    /*
        Signals consumed by the EdgeStepper to know when it should
        move to the next line, or move to the next frame.
    */
    reg reg_line_step;
    reg reg_frame_step;
    assign line_step = reg_line_step;
    assign frame_step = reg_frame_step;

    /*  The raster coordinate from the previous cycle  */
    reg [9:0] reg_raster_x;

    /*  Signal line_step and frame_step from the display coordinates  */
    always @(posedge clk)
    begin
        reg_raster_x <= raster_x;

        /*
            Compare with the previous cycle to ensure line_step
            is only signalled for one cycle
        */
        if (reg_raster_x != 0 && raster_x == 0)
        begin
            reg_line_step <= 1;

            if (raster_y == scan_height - 1)
            begin
                reg_frame_step <= 1;
            end else begin
                reg_frame_step <= 0;
            end
        end else begin
            reg_line_step <= 0;
            reg_frame_step <= 0;
        end
    end

    /*  Track which scanline is being transmitted, drawn and cleared  */
    reg [1:0] scan_bank = 2'b00;
    reg [1:0] draw_bank = 2'b01;
    reg [1:0] clear_bank = 2'b10;

    /*  When we switch lines, rotate the banks used for each operation  */
    always @(posedge clk)
    begin
        if (line_step)
        begin
            scan_bank <= draw_bank;
            draw_bank <= clear_bank;
            clear_bank <= scan_bank;
        end
    end

    assign buff_read_bank = scan_bank;

    /*  The current x position in the line we are clearing  */
    reg [9:0] clear_x;

    /*
        We want to write to the drawn line if an edge coordinate is available
        from the edgestepper.  If none is available, we will use this cycle
        to clear a pixel in the clearing scanline.
    */
    assign buff_write_bank = edge_available ? draw_bank : clear_bank;
    assign buff_write_index = edge_available ? edge_x : clear_x;
    assign buff_write_color = edge_available;

    /*  Reset and advance of the clear coordinate  */
    always @(posedge clk)
    begin
        if (line_step)
        begin
            clear_x <= 0;
        end else if (!edge_available)
        begin
            clear_x <= clear_x + 1;
        end
    end
endmodule
