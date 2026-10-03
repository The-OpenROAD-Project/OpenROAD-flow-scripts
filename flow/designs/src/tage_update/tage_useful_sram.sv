// One bank of one way of a TAGE table's useful counters: 64 rows of
// eight 2-bit counters, the 512 sets folded eight to a row. XiangShan's
// Frontend has 64 of this macro (array_64x16) beside the 64 entry SRAMs
// (NumUsefulCtrSramFolds = 8 in xiangshan/frontend/bpu/tage/Parameters.scala).
//
// Same firtool port convention and fixed size as tage_entry_sram.sv,
// for the same reasons.
module tage_useful_sram (
    input  logic        RW0_clk,
    input  logic        RW0_en,
    input  logic        RW0_wmode,  // 1 write, 0 read
    input  logic [ 5:0] RW0_addr,
    input  logic [15:0] RW0_wdata,
    output logic [15:0] RW0_rdata
);
  logic [15:0] mem[64];
  logic        ren_q;
  logic [ 5:0] raddr_q;
  always_ff @(posedge RW0_clk) begin
    ren_q   <= RW0_en && !RW0_wmode;
    raddr_q <= RW0_addr;
    if (RW0_en && RW0_wmode) mem[RW0_addr] <= RW0_wdata;
  end
  assign RW0_rdata = ren_q ? mem[raddr_q] : 'x;
endmodule
