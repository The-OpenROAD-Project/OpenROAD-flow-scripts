module OPENROAD_CLKGATE (CK, E, GCK);
  input CK;
  input E;
  output GCK;

ICGx1_ASAP7_75t_SL latch ( .CLK(CK), .ENA(E), .SE(1'b0), .GCLK(GCK) );

endmodule
