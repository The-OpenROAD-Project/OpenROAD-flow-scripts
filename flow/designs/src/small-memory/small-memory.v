// 1024 bits of SRAM is a small SRAM where flip-flops
// might be just as good as hardened SRAM depending on
// context.
module SmallMemory(
  input        clock,
  input  [3:0] io_readAddress_0,
  input  [3:0] io_readAddress_1,
  input        io_readEnable_0,
  input        io_readEnable_1,
  output [7:0] io_readData_0,
  output [7:0] io_readData_1,
  input  [3:0] io_writeAddress,
  input        io_writeEnable,
  input  [7:0] io_writeData
);
  wire  DualPortNewRegisterReadAddressDataRAM_clk;
  wire [3:0] DualPortNewRegisterReadAddressDataRAM_ram_wr_addr;
  wire  DualPortNewRegisterReadAddressDataRAM_ram_we;
  wire [7:0] DualPortNewRegisterReadAddressDataRAM_ram_din;
  wire  DualPortNewRegisterReadAddressDataRAM_ram_re;
  wire [7:0] DualPortNewRegisterReadAddressDataRAM_ram_dout;
  wire [3:0] DualPortNewRegisterReadAddressDataRAM_ram_rd_addr;
  wire  DualPortNewRegisterReadAddressDataRAM_ram_re2;
  wire [7:0] DualPortNewRegisterReadAddressDataRAM_ram_dout2;
  wire [3:0] DualPortNewRegisterReadAddressDataRAM_ram_rd_addr2;
  DualPortNewRegisterReadAddressDataRAM #(.WIDTH(8), .ADDR(4)) DualPortNewRegisterReadAddressDataRAM (
    .clk(DualPortNewRegisterReadAddressDataRAM_clk),
    .ram_wr_addr(DualPortNewRegisterReadAddressDataRAM_ram_wr_addr),
    .ram_we(DualPortNewRegisterReadAddressDataRAM_ram_we),
    .ram_din(DualPortNewRegisterReadAddressDataRAM_ram_din),
    .ram_re(DualPortNewRegisterReadAddressDataRAM_ram_re),
    .ram_dout(DualPortNewRegisterReadAddressDataRAM_ram_dout),
    .ram_rd_addr(DualPortNewRegisterReadAddressDataRAM_ram_rd_addr),
    .ram_re2(DualPortNewRegisterReadAddressDataRAM_ram_re2),
    .ram_dout2(DualPortNewRegisterReadAddressDataRAM_ram_dout2),
    .ram_rd_addr2(DualPortNewRegisterReadAddressDataRAM_ram_rd_addr2)
  );
  assign io_readData_0 = DualPortNewRegisterReadAddressDataRAM_ram_dout;
  assign io_readData_1 = DualPortNewRegisterReadAddressDataRAM_ram_dout2;
  assign DualPortNewRegisterReadAddressDataRAM_clk = clock;
  assign DualPortNewRegisterReadAddressDataRAM_ram_wr_addr = io_writeAddress;
  assign DualPortNewRegisterReadAddressDataRAM_ram_we = io_writeEnable;
  assign DualPortNewRegisterReadAddressDataRAM_ram_din = io_writeData;
  assign DualPortNewRegisterReadAddressDataRAM_ram_re = io_readEnable_0;
  assign DualPortNewRegisterReadAddressDataRAM_ram_rd_addr = io_readAddress_0;
  assign DualPortNewRegisterReadAddressDataRAM_ram_re2 = io_readEnable_1;
  assign DualPortNewRegisterReadAddressDataRAM_ram_rd_addr2 = io_readAddress_1;
endmodule
