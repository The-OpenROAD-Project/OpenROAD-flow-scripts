// Behavioral models of the memories the Rocket Chip generator leaves as
// black boxes (`*_ext`, firtool's read-write port convention), so the
// generic sources elaborate and AUTO_MEMORIES detects each memory and
// replaces it with a generated macro. nangate45 maps the same modules
// onto hand-made fakeram macros instead.
//
// One read-write port, written as firtool writes one: a write on the
// clock when enabled and in write mode, under the write mask; a read
// registers its address on the clock and reads from it, which yosys
// infers as a clocked read port, the SRAM shape AUTO_MEMORIES converts.

module data_arrays_0_ext(
  input RW0_clk,
  input [5:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [3:0] RW0_wmask,
  input [31:0] RW0_wdata,
  output [31:0] RW0_rdata
);
  reg [31:0] Memory [0:63];
  reg [5:0] raddr;
  integer i;
  always @(posedge RW0_clk) begin
    if (RW0_en && !RW0_wmode) raddr <= RW0_addr;
    if (RW0_en && RW0_wmode)
      for (i = 0; i < 4; i = i + 1)
        if (RW0_wmask[i]) Memory[RW0_addr][i*8 +: 8] <= RW0_wdata[i*8 +: 8];
  end
  assign RW0_rdata = Memory[raddr];
endmodule

module data_arrays_0_0_ext(
  input RW0_clk,
  input [5:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [0:0] RW0_wmask,
  input [31:0] RW0_wdata,
  output [31:0] RW0_rdata
);
  reg [31:0] Memory [0:63];
  reg [5:0] raddr;
  always @(posedge RW0_clk) begin
    if (RW0_en && !RW0_wmode) raddr <= RW0_addr;
    if (RW0_en && RW0_wmode && RW0_wmask[0]) Memory[RW0_addr] <= RW0_wdata;
  end
  assign RW0_rdata = Memory[raddr];
endmodule

module tag_array_ext(
  input RW0_clk,
  input [1:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [0:0] RW0_wmask,
  input [24:0] RW0_wdata,
  output [24:0] RW0_rdata
);
  reg [24:0] Memory [0:3];
  reg [1:0] raddr;
  always @(posedge RW0_clk) begin
    if (RW0_en && !RW0_wmode) raddr <= RW0_addr;
    if (RW0_en && RW0_wmode && RW0_wmask[0]) Memory[RW0_addr] <= RW0_wdata;
  end
  assign RW0_rdata = Memory[raddr];
endmodule
