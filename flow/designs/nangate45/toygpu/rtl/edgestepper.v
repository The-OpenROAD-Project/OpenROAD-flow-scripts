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


/*  The Edge Stepper will be in one of the following stages:  */

/*  Clearing the scratch memory between frames  */
`define EDGE_STEP_RESET 0

/*  Setup registers for drawing a particular edge  */
`define EDGE_STEP_SETUP 1

/*  The first draw cycle this scanline for an edge  */
`define EDGE_STEP_DRAW 2 

/*  Carryover, for multiple pixels on this scanline per edge  */
`define EDGE_STEP_CARRY 3

/*  Done with all edges for this scanline  */
`define EDGE_STEP_DONE 4


/*
    Draws model edges  (i.e. lines on screen)

    When a pixel is being draw, edge_available will be high
    and edge_x will be the coordinate of the pixel on the current
    scanline.
*/
module EdgeStepper #(
    parameter integer reset_scanline = 480
) (
    input clk,

    input frame_step,
    input line_step,

    output edge_available,
    output [9:0] edge_x,

    input [10:0] edge_count,
    output [9:0] read_edge_index,
    input [9:0] read_edge_bx,
    input [9:0] read_edge_by,
    input [9:0] read_edge_ex,
    input [9:0] read_edge_ey,
    input [9:0] read_edge_x,
    input [9:0] read_edge_frac,

    output edge_write_enable,
    output [9:0] write_edge_index,
    output [9:0] write_edge_x,
    output [9:0] write_edge_frac
);
    reg [9:0] scan_y;  /*  The y coordinate of the current scanline  */

    /*  Track the current scanline with external notifications */
    always @(posedge clk)
    begin
        if (frame_step)
        begin
            scan_y <= 0;
        end else if (line_step)
        begin
            scan_y <= scan_y + 1;
        end
    end

    /*  Our current state  */
    reg [2:0] stepper_state;

    /*  The index of the edge we are current processing  */
    reg [9:0] reg_edge_index;

    /*  Output for the current pixel draw  */
    reg reg_edge_available;
    reg [9:0] reg_edge_x;
    assign edge_available = reg_edge_available;
    assign edge_x = reg_edge_x;

    /*
        Endpoints (begin, end) for the current edge, along with a
        fractional (subpixel) coordinate value for the current
        fraction of a pixel between scanlines.
    */
    reg [9:0] reg_edge_bx;
    reg [9:0] reg_edge_by;
    reg [9:0] reg_edge_ex;
    reg [9:0] reg_edge_ey;
    reg [9:0] reg_edge_frac;  /*  0 <= edge_frac < dy  */ 

    /*
        Derived edge values:  edge delta, left/right direction, and
        fractional value to add for every horizontal pixel step.
    */
    reg [9:0] edge_dx;
    reg [9:0] edge_dy;
    reg [9:0] direction;
    reg [9:0] add_frac;

    /*
        The x offset and fractional value to write back when we
        are done with this edge of this scanline.
    */
    reg [9:0] carry_x;
    reg [9:0] carry_frac;

    /*  Is this edge moving rightward from one scanline to the next?  */
    wire dx_positive = (read_edge_ex >= read_edge_bx);

    /*  Is the current scaline between the begin and end of this edge?  */
    wire scan_y_in_edge = (read_edge_by <= scan_y)
            && (scan_y <= read_edge_ey);

    /*  Will the subpixel fraction overflow on the next scanline?  */
    wire frac_overflow = (reg_edge_frac + add_frac >= edge_dy);

    /*  
        If the subpixel fraction overflows, we will move horizontally
        for the next scanline.  Otherwise our horizontal position will
        remain the same.
    */
    wire [9:0] next_x = frac_overflow ? reg_edge_x + direction : reg_edge_x;

    /*
        If the subpixel fraction has overflowed, subtract the max
        fractional value (dy) because we've moved horizontally.
        In either case, add the fractional value for one vertical step.
    */
    wire [9:0] next_frac = frac_overflow ? reg_edge_frac + add_frac - edge_dy
        : reg_edge_frac + add_frac;

    /*
        Has the fractional value overflowed enough to need additional
        pixels (beyond the first) on this scanline?
    */
    wire carryover = (reg_edge_x != reg_edge_ex) && (carry_frac >= edge_dy);
    wire [9:0] remaining_frac = carry_frac - edge_dy;

    /*
        Unless we are starting a new scanline, be reading one edge ahead
        of the current edge we are processing.
    */
    assign read_edge_index = line_step ? 0 : reg_edge_index + 1;

    /*
        We only will write to the scratch space during reset or
        when we have completed our work for an edge on this scanline.
    */
    assign edge_write_enable = (stepper_state == `EDGE_STEP_RESET) 
        || (stepper_state == `EDGE_STEP_CARRY && !carryover);
    assign write_edge_index = reg_edge_index;
    assign write_edge_x = (stepper_state == `EDGE_STEP_RESET) ?
        0 : carry_x;
    assign write_edge_frac = (stepper_state == `EDGE_STEP_RESET) ?
        0 : carry_frac;


    always @(posedge clk)
    begin
        /*  When moving to a new line, reset to the start of the edge list  */
        if (line_step)
        begin
            reg_edge_index <= 0;
            reg_edge_available <= 0;

            if (scan_y == reset_scanline)
            begin
                stepper_state <= `EDGE_STEP_RESET;
            end else begin
                stepper_state <= `EDGE_STEP_SETUP;
            end
        end else begin
            case (stepper_state)
                /*  Clear the scratch values, moving through all edges  */
                `EDGE_STEP_RESET: begin
                    reg_edge_index <= reg_edge_index + 1;
                end

                /*
                    Store relevant information about this edge
                    in local registers, in preparation for drawing.
                */
                `EDGE_STEP_SETUP: begin
                    reg_edge_bx <= read_edge_bx;
                    reg_edge_by <= read_edge_by;
                    reg_edge_ex <= read_edge_ex;
                    reg_edge_ey <= read_edge_ey;
                    reg_edge_frac <= read_edge_frac;
                    reg_edge_x <= read_edge_x;
                    reg_edge_frac <= read_edge_frac;
                    edge_dx <= read_edge_ex - read_edge_bx;
                    edge_dy <= read_edge_ey - read_edge_by;

                    /*  Is this edge moving left or right?  */
                    direction <= dx_positive ? 1 : -1;

                    /*  The fractional value per step is abs(dx)  */
                    add_frac <= dx_positive ? read_edge_ex - read_edge_bx
                        : read_edge_bx - read_edge_ex;

                    if (reg_edge_index == edge_count) begin
                        /*  Check if we are done for this scanline  */
                        stepper_state <= `EDGE_STEP_DONE;
                    end else if (scan_y_in_edge) begin
                        /*  If this edge is active this scanline, draw  */
                        stepper_state <= `EDGE_STEP_DRAW;
                    end else begin
                        /*
                            This scanline is outside the edge range,
                            so move on to the next edge.
                        */
                        reg_edge_index <= reg_edge_index + 1;
                    end
                end

                /*  Draw the first pixel for this edge  */
                `EDGE_STEP_DRAW: begin

                    reg_edge_x <= reg_edge_bx + reg_edge_x;
                    carry_x <= next_x;
                    carry_frac <= next_frac;

                    reg_edge_available <= 1;

                    stepper_state <= `EDGE_STEP_CARRY;
                end

                /*
                    Check to see if we need additional pixels for
                    this edge on this scanline.
                */
                `EDGE_STEP_CARRY: begin
                    if (carryover)
                    begin
                        /*
                            If additional pixels are needed,
                            step horizontally and update the
                            fractional value to the remaining
                            fraction after the step.
                        */
                        reg_edge_x <= reg_edge_x + direction;
                        carry_x <= carry_x + direction;
                        carry_frac <= remaining_frac;
                    end else begin
                        /*
                            Otherwise, we are done with this edge,
                            so we will move to setup on the next
                            edge.
                        */
                        reg_edge_available <= 0;

                        reg_edge_index <= reg_edge_index + 1;
                        stepper_state <= `EDGE_STEP_SETUP;
                    end
                end
            endcase
        end
    end
endmodule
