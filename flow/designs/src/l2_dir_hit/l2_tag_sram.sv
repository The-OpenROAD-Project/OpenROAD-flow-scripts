// Half of the L2 directory's tag array: 1024 sets of four ways, each way
// a 32-bit tag with a 7-bit SECDED code, single-ported, synchronous read.
// XiangShan's CoupledL2 builds two of exactly this macro (array_1024x156)
// for a 512 KiB, 8-way slice: coupledL2/Directory.scala:169-184, a
// SplittedSRAM of 8 ways in two halves (waySplit = 2), read latency 1.
//
// Every port follows the firtool memory convention (RW0_<function>), so
// ORFS's AUTO_MEMORIES detects this module and replaces it with a
// generated macro; the body below is its behavioural model. The size is
// fixed on purpose: the detector names the macro after the module, and a
// parameterised module would be renamed by the frontend.
module l2_tag_sram (
    input  logic         RW0_clk,
    input  logic         RW0_en,
    input  logic         RW0_wmode,  // 1 write, 0 read
    input  logic [  9:0] RW0_addr,
    input  logic [  3:0] RW0_wmask,  // one bit per way
    input  logic [155:0] RW0_wdata,
    output logic [155:0] RW0_rdata
);
  logic [155:0] mem[1024];
  logic         ren_q;
  logic [  9:0] raddr_q;
  always_ff @(posedge RW0_clk) begin
    ren_q   <= RW0_en && !RW0_wmode;
    raddr_q <= RW0_addr;
    for (int w = 0; w < 4; w++)
      if (RW0_en && RW0_wmode && RW0_wmask[w]) mem[RW0_addr][w*39+:39] <= RW0_wdata[w*39+:39];
  end
  assign RW0_rdata = ren_q ? mem[raddr_q] : 'x;
endmodule
