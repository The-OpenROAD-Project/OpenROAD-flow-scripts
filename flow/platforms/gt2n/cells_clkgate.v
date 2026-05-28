// GT2N has no clock gate cell; provide a passthrough that Yosys can target.
module OPENROAD_CLKGATE (CK, E, GCK);
  input CK;
  input E;
  output GCK;
  assign GCK = CK;
endmodule
