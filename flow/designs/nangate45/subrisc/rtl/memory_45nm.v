module sram16x8192_async_high(
  input CLK,
  input REN1,
  input WEN1,
  input[12:0] ADDR1,
  input[15:0] WDATA1,
  output[15:0] RDATA1
);
    
reg[15:0] rfs[0:8191];
initial $readmemh("../hdl/hex/motion_h.hex", rfs);
assign RDATA1 = REN1 ? rfs[ADDR1] : 16'd0;
always @(posedge CLK) begin
	if (WEN1) begin
		rfs[ADDR1] <= WDATA1;
	end
end
endmodule

module sram16x8192_async_low(
  input CLK,
  input REN1,
  input WEN1,
  input[12:0] ADDR1,
  input[15:0] WDATA1,
  output[15:0] RDATA1
);
    
reg[15:0] rfs[0:8191];
initial $readmemh("../hdl/hex/motion_l.hex", rfs);
assign RDATA1 = REN1 ? rfs[ADDR1] : 16'd0;
always @(posedge CLK) begin
	if (WEN1) begin
		rfs[ADDR1] <= WDATA1;
	end
end
endmodule

