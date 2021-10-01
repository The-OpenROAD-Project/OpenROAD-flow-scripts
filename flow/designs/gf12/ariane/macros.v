module SyncSpRamBeNx64_00000008_00000100_0_2
(
  Clk_CI,
  Rst_RBI,
  CSel_SI,
  WrEn_SI,
  BEn_SI,
  WrData_DI,
  Addr_DI,
  RdData_DO
);

  input [7:0] BEn_SI;
  input [63:0] WrData_DI;
  input [7:0] Addr_DI;
  output [63:0] RdData_DO;
  input Clk_CI;
  input Rst_RBI;
  input CSel_SI;
  input WrEn_SI;
  wire [63:0] RdData_DO;
  wire n_0_net_,n_1_net_;

  gf12lp_1rf_lg8_w64_byte
  macro_mem
  (
    .CLK(Clk_CI),
    .Q(RdData_DO),
    .CEN(n_0_net_),
    .GWEN(n_1_net_),
    .A(Addr_DI),
    .D(WrData_DI),
    .EMA({ 1'b0, 1'b1, 1'b1 }),
    .EMAW({ 1'b0, 1'b1 }),
    .RET1N(1'b1)
  );

  assign n_1_net_ = ~WrEn_SI;
  assign n_0_net_ = ~CSel_SI;

endmodule
