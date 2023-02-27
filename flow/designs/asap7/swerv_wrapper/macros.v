module ram_2048x39(CLK, ADR, D, Q, WE);
  input CLK, WE;
  input [10:0] ADR;
  input [38:0] D;
  output [38:0] Q;
  wire CLK, WE;
  wire [10:0] ADR;
  wire [38:0] D;
  wire [38:0] Q;

  fakeram7_2048x39 mem (
    .clk      (CLK     ),
    .rd_out   (Q       ),
    .ce_in    (1'b1    ),
    .we_in    (WE      ),
    .addr_in  (ADR     ),
    .wd_in    (D       )
  );


endmodule

module ram_64x21(CLK, ADR, D, Q, WE);
  input CLK, WE;
  input [5:0] ADR;
  input [20:0] D;
  output [20:0] Q;
  wire CLK, WE;
  wire [5:0] ADR;
  wire [20:0] D;
  wire [20:0] Q;

  fakeram7_64x21 mem (
    .clk      (CLK     ),
    .rd_out   (Q       ),
    .ce_in    (1'b1    ),
    .we_in    (WE      ),
    .addr_in  (ADR     ),
    .wd_in    (D       )
  );

endmodule

module ram_256x34(CLK, ADR, D, Q, WE);
  input CLK, WE;
  input [7:0] ADR;
  input [33:0] D;
  output [33:0] Q;
  wire CLK, WE;
  wire [7:0] ADR;
  wire [33:0] D;
  wire [33:0] Q;

  fakeram7_256x34 mem (
    .clk      (CLK     ),
    .rd_out   (Q       ),
    .ce_in    (1'b1    ),
    .we_in    (WE      ),
    .addr_in  (ADR     ),
    .wd_in    (D       )
  );

endmodule
