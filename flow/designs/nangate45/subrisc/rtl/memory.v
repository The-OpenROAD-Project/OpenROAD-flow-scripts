//!!!
//Assume ASYNChronus memory
//Because CACTI can simulate only ASYNChronus memory
//If we can simulate SYNChronus one, FetchStage doesn't need to have register output for Instruction.
module LowMemory 
#(
   parameter MEMORY_HALFADDRESS_BITS = 12,
   parameter INSTRUCTION_HALFADDRESS_BITS = 32
)
(
	input wire CLK,
	input wire[MEMORY_HALFADDRESS_BITS-2:0] ADDR,
	input wire WEN,
	output wire[15:0] RDATA,
	input wire[15:0] WDATA
);

sram16x8192_async_low sram(
    .CLK(CLK),
    .RDATA1(RDATA),
    .WDATA1(WDATA),
    .ADDR1(ADDR),
    .WEN1(WEN),
    .REN1(1'b1));

/*reg[15:0] rfs[0:8191];
initial $readmemh("../hdl/a_l.hex", rfs);
assign RDATA = rfs[ADDR];
always @(posedge CLK) begin
	if (WEN) begin
		rfs[ADDR] <= WDATA;
	end
end*/

endmodule

module HighMemory
#(
   parameter MEMORY_HALFADDRESS_BITS = 10,
   parameter INSTRUCTION_HALFADDRESS_BITS = 32
)
(
	input wire CLK,
	input wire[MEMORY_HALFADDRESS_BITS-2:0] ADDR,
	input wire WEN,
	output wire[15:0] RDATA,
	input wire[15:0] WDATA
);

sram16x8192_async_high sram(
    .CLK(CLK),
    .RDATA1(RDATA),
    .WDATA1(WDATA),
    .ADDR1(ADDR),
    .WEN1(WEN),
    .REN1(1'b1));

/*reg[15:0] rfs[0:8191];
initial $readmemh("../hdl/a_h.hex", rfs);
assign RDATA = rfs[ADDR];
always @(posedge CLK) begin
	if (WEN) begin
		rfs[ADDR] <= WDATA;
	end
end*/

endmodule
