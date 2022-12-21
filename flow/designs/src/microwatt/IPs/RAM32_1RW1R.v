module RAM32_1RW1R #(
    parameter BITS=5
) (
`ifdef USE_POWER_PINS
    inout VPWR,
    inout VGND,
`endif
    input CLK,

    input EN0,
    input [BITS-1:0] A0,
    input [7:0] WE0,
    input [63:0] Di0,
    output reg [63:0] Do0,

    input EN1,
    input [BITS-1:0] A1,
    output reg [63:0] Do1
);

endmodule
