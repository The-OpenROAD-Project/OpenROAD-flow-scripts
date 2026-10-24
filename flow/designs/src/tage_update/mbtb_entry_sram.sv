// One way of one internal bank of one align bank of the main BTB: 256
// sets of a 46-bit entry, single-ported, synchronous read. XiangShan's
// Frontend has 32 of exactly this macro (array_256x46), generated from
// SRAMTemplate in xiangshan/frontend/bpu/mbtb/MainBtbInternalBank.scala.
//
// An entry (MainBtbEntry, mbtb/Bundles.scala) is {tag[15:0],
// attribute[3:0], position[3:0], target carry[1:0], target[19:0]}.
//
// Same firtool port convention and fixed size as tage_entry_sram.sv,
// for the same reasons.
module mbtb_entry_sram (
    input  logic        RW0_clk,
    input  logic        RW0_en,
    input  logic        RW0_wmode,  // 1 write, 0 read
    input  logic [ 7:0] RW0_addr,
    input  logic [45:0] RW0_wdata,
    output logic [45:0] RW0_rdata
);
  logic [45:0] mem[256];
  logic        ren_q;
  logic [ 7:0] raddr_q;
  always_ff @(posedge RW0_clk) begin
    ren_q   <= RW0_en && !RW0_wmode;
    raddr_q <= RW0_addr;
    if (RW0_en && RW0_wmode) mem[RW0_addr] <= RW0_wdata;
  end
  assign RW0_rdata = ren_q ? mem[raddr_q] : 'x;
endmodule
