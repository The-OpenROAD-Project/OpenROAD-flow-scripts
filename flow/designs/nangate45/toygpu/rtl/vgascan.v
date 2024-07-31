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
    Well run the pixel clock for 640x480 at 25 MHz.  (Actually, the spec
    is for 25.175 MHz, but 25 MHz is close enough.)
*/
`define VGA_MHZ 25


/*  640x480 @ 60Hz timing values  */
`define X_ACTIVE_WIDTH 640
`define X_SYNC_BEGIN 656
`define X_SYNC_END 752
`define X_TOTAL_WIDTH 800

`define Y_ACTIVE_HEIGHT 480
`define Y_SYNC_BEGIN 491
`define Y_SYNC_END 493
`define Y_TOTAL_HEIGHT 524


/*  Generate VGA display signals  */
module VGAScan #(
    /*  External clock frequency must be equal to or faster than VGA  */
    parameter [7:0] CLK_MHZ = `VGA_MHZ
) (
    input clk,
    output hsync,
    output vsync,
    output red,
    output grn,
    output blu,

    output [9:0] scanline_y,
    output [9:0] scanline_x,
    input pixel_color
);
    reg [7:0] clk_frac = 0;
    reg vga_tick;

    /*
        Given that the external clock can differ arbitrarily from
        the VGA clock, activate the VGA clock tick by keeping
        a fractional count of clock error.
    */
    always @(posedge clk)
    begin
        if (clk_frac < CLK_MHZ)
        begin
            clk_frac <= clk_frac + `VGA_MHZ;
            vga_tick <= 0;
        end else begin
            clk_frac <= clk_frac + `VGA_MHZ - CLK_MHZ;
            vga_tick <= 1;
        end
    end

    reg [9:0] scan_x = 0;
    reg [9:0] scan_y = 0;
    reg scan_parity = 0;

    assign scanline_x = scan_x;
    assign scanline_y = scan_y;

    /*  Update the scan position every VGA tick  */
    always @(posedge clk)
    begin
        if (vga_tick)
        begin
            if (scan_x != `X_TOTAL_WIDTH - 1)
            begin
                scan_x <= scan_x + 1;
            end else begin
                scan_x <= 0;

                if (scan_y != `Y_TOTAL_HEIGHT - 1)
                begin
                    scan_y <= scan_y + 1;
                end else begin
                    scan_y <= 0;
                end
            end
        end
    end

    reg hsync_reg;
    reg vsync_reg;
    reg color;

    assign hsync = hsync_reg;
    assign vsync = vsync_reg;

    always @(posedge clk)
    begin
        hsync_reg <= !(scan_x >= `X_SYNC_BEGIN && scan_x < `X_SYNC_END);
        vsync_reg <= !(scan_y >= `Y_SYNC_BEGIN && scan_y < `Y_SYNC_END);

        if (scan_x < `X_ACTIVE_WIDTH && scan_y < `Y_ACTIVE_HEIGHT)
        begin
            color <= pixel_color;
        end else begin
            color <= 0;
        end
    end

    assign red = color;
    assign grn = color;
    assign blu = color;
endmodule
