module OPENROAD_CLKGATE (CK, E, GCK);
  input CK;
  input E;
  output GCK;

sg13g2_lgcp_1 latch (.CLK (CK), .GATE(E), .GCLK(GCK));

endmodule
