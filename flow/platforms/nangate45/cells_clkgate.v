module OPENROAD_CLKGATE (CK, E, GCK);
  input CK;
  input E;
  output GCK;

CLKGATE_X1 latch (.CK (CK), .E(E), .GCK(GCK));

endmodule
