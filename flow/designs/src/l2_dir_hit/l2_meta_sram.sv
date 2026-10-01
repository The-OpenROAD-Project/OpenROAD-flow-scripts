// The L2 directory's meta array: 1024 sets of eight ways, each way a
// 16-bit coherence entry (state, dirty, clients, prefetch and error
// bits), single-ported, synchronous read. XiangShan's CoupledL2 builds
// one of exactly this macro (array_1024x128): coupledL2/Directory.scala:198,
// an SRAMTemplate of MetaEntry, read latency 1.
//
// Port convention and fixed size as in l2_tag_sram.sv.
module l2_meta_sram (
    input  logic         RW0_clk,
    input  logic         RW0_en,
    input  logic         RW0_wmode,  // 1 write, 0 read
    input  logic [  9:0] RW0_addr,
    input  logic [  7:0] RW0_wmask,  // one bit per way
    input  logic [127:0] RW0_wdata,
    output logic [127:0] RW0_rdata
);
  logic [127:0] mem[1024];
  logic         ren_q;
  logic [  9:0] raddr_q;
  always_ff @(posedge RW0_clk) begin
    ren_q   <= RW0_en && !RW0_wmode;
    raddr_q <= RW0_addr;
    for (int w = 0; w < 8; w++)
      if (RW0_en && RW0_wmode && RW0_wmask[w]) mem[RW0_addr][w*16+:16] <= RW0_wdata[w*16+:16];
  end
  assign RW0_rdata = ren_q ? mem[raddr_q] : 'x;
endmodule
