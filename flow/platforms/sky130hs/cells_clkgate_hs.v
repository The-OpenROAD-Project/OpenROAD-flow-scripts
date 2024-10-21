module OPENROAD_CLKGATE (CK, E, GCK);
  input CK;
  input E;
  output GCK;

sky130_fd_sc_hs__dlclkp_1 latch (.CLK (CK), .GATE(E), .GCLK(GCK));

endmodule
