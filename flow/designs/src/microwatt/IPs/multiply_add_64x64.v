module multiply_add_64x64
#(
    parameter BITS=64
) (
`ifdef USE_POWER_PINS
    inout VPWR,
    inout VGND,
`endif
    input clk,
    input [BITS-1:0] a,
    input [BITS-1:0] b,
    input [BITS*2-1:0] c,
    output [BITS*2-1:0] o
);

endmodule
