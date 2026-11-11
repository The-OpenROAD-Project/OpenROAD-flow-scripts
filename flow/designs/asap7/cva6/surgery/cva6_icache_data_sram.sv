// The I-cache data RAM, behavioural; AUTO_MEMORIES makes it a macro.
// WORDS is 64 where the techno cut instances it; a check may shrink it.
module cva6_icache_data_sram #(
    parameter WORDS = 64,
    parameter AW    = $clog2(WORDS)
) (
    input               clk,
    input               cs,
    input               we,
    input      [AW-1:0] addr,
    input      [255:0]  wdata,
    input      [31:0]   be,
    output reg [255:0]  rdata
);
  reg [255:0] mem [0:WORDS-1];
  integer j;
  always @(posedge clk)
    if (cs) begin
      if (we)
        for (j = 0; j < 32; j = j + 1)
          if (be[j]) mem[addr][j*8 +: 8] <= wdata[j*8 +: 8];
      rdata <= mem[addr];
    end
endmodule
