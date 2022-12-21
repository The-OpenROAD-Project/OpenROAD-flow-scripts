module Microwatt_FP_DFFRFile (
`ifdef USE_POWER_PINS
    inout VPWR,
    inout VGND,
`endif
    input [6:0]   R1, R2, R3, RW,
    input [63:0]  DW,
    output [63:0] D1, D2, D3,
    input CLK,
    input WE
);

endmodule
