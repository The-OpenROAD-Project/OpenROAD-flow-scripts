// One quarter of the L2 data array: 8192 entries (1024 sets of eight
// ways) of a 128-bit word with a 9-bit SECDED code, single-ported.
// XiangShan's CoupledL2 builds four of exactly this macro
// (array_8192x137) for a 64-byte block: coupledL2/DataStorage.scala:68-80,
// a GatedSplittedSRAM with dataSplit = 4 and readMCP2 = true.
//
// The array is a two-cycle macro in XiangShan: its inputs hold for two
// cycles and its read data is captured two cycles after the read edge
// (DataStorage.scala:52-65, 119-131). constraint.sdc declares that
// contract; this model is the ordinary one-cycle form, which is all
// AUTO_MEMORIES needs to generate the macro.
//
// Port convention and fixed size as in l2_tag_sram.sv.
module l2_data_sram (
    input  logic         RW0_clk,
    input  logic         RW0_en,
    input  logic         RW0_wmode,  // 1 write, 0 read
    input  logic [ 12:0] RW0_addr,   // {way, set}
    input  logic [136:0] RW0_wdata,
    output logic [136:0] RW0_rdata
);
  logic [136:0] mem[8192];
  logic         ren_q;
  logic [ 12:0] raddr_q;
  always_ff @(posedge RW0_clk) begin
    ren_q   <= RW0_en && !RW0_wmode;
    raddr_q <= RW0_addr;
    if (RW0_en && RW0_wmode) mem[RW0_addr] <= RW0_wdata;
  end
  assign RW0_rdata = ren_q ? mem[raddr_q] : 'x;
endmodule
