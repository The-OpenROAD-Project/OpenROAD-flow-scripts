// The I-cache tag RAM, behavioural; AUTO_MEMORIES makes it a macro. Its
// last byte enable covers the one bit left over, as tc_sram's does.
module cva6_icache_tag_sram #(
    parameter WORDS = 64,
    parameter AW    = $clog2(WORDS)
) (
    input               clk,
    input               cs,
    input               we,
    input      [AW-1:0] addr,
    input      [24:0]   wdata,
    input      [3:0]    be,
    output reg [24:0]   rdata
);
  reg [24:0] mem [0:WORDS-1];
  always @(posedge clk)
    if (cs) begin
      if (we) begin
        if (be[0]) mem[addr][7:0]   <= wdata[7:0];
        if (be[1]) mem[addr][15:8]  <= wdata[15:8];
        if (be[2]) mem[addr][23:16] <= wdata[23:16];
        if (be[3]) mem[addr][24]    <= wdata[24];
      end
      rdata <= mem[addr];
    end
endmodule
