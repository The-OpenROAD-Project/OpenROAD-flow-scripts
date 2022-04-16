module RAM512 #(
    parameter BITS=9,
) (
`ifdef USE_POWER_PINS
    inout VPWR,
    inout VGND,
`endif
    input CLK,
    input [7:0] WE0,
    input EN0,
    input [63:0] Di0,
    output reg [63:0] Do0,
    input [BITS-1:0] A0
);

endmodule
