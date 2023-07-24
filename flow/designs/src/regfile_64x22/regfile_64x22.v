
module regfile_64x22(
  input W0_clk,
  input [5:0] W0_addr,
  input W0_en,
  input [87:0] W0_data,
  input [3:0] W0_mask,
  input R0_clk,
  input [5:0] R0_addr,
  input R0_en,
  output [87:0] R0_data
);

  reg [5:0] reg_R0_addr;
  reg [87:0] ram [63:0];
  `ifdef RANDOMIZE
    integer initvar;
    initial begin
      #0.002 begin end
      for (initvar = 0; initvar < 64; initvar = initvar+1)
        ram[initvar] = {3 {$random}};
      reg_R0_addr = {1 {$random}};
    end
  `endif
  integer i;
  always @(posedge R0_clk)
    if (R0_en) reg_R0_addr <= R0_addr;
  always @(posedge W0_clk)
    if (W0_en) begin
      if (W0_mask[0]) ram[W0_addr][21:0] <= W0_data[21:0];
      if (W0_mask[1]) ram[W0_addr][43:22] <= W0_data[43:22];
      if (W0_mask[2]) ram[W0_addr][65:44] <= W0_data[65:44];
      if (W0_mask[3]) ram[W0_addr][87:66] <= W0_data[87:66];
    end
  assign R0_data = ram[reg_R0_addr];

endmodule
