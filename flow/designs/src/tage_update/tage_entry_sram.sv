// One bank of one way of a TAGE table: 512 sets of a 17-bit entry
// (valid, 13-bit tag, 3-bit taken counter), single-ported, synchronous
// read. XiangShan's Frontend has 64 of exactly this macro
// (array_512x17), generated from SRAMTemplate in
// xiangshan/frontend/bpu/tage/TageTable.scala.
//
// Every port follows the firtool memory convention (RW0_<function>), so
// ORFS's AUTO_MEMORIES detects this module and replaces it with a
// generated macro; the body below is its behavioural model. The size is
// fixed on purpose: the detector names the macro after the module, and
// a parameterised module would be renamed by the frontend.
module tage_entry_sram (
    input  logic        RW0_clk,
    input  logic        RW0_en,
    input  logic        RW0_wmode,  // 1 write, 0 read
    input  logic [ 8:0] RW0_addr,
    input  logic [16:0] RW0_wdata,
    output logic [16:0] RW0_rdata
);
  // firtool's own form for a read-write port: the address is registered
  // on the clock and the array is read from the registered address, which
  // is a clocked read port to yosys and to AUTO_MEMORIES's detector.
  logic [16:0] mem[512];
  logic        ren_q;
  logic [ 8:0] raddr_q;
  always_ff @(posedge RW0_clk) begin
    ren_q   <= RW0_en && !RW0_wmode;
    raddr_q <= RW0_addr;
    if (RW0_en && RW0_wmode) mem[RW0_addr] <= RW0_wdata;
  end
  assign RW0_rdata = ren_q ? mem[raddr_q] : 'x;
endmodule
