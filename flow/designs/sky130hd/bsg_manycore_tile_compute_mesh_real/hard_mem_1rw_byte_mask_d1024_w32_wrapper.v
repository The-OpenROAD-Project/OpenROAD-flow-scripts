module hard_mem_1rw_byte_mask_d1024_w32_wrapper(	
`ifdef USE_POWER_PINS
    vccd1,  // User area 1 1.8V power
    vssd1,  // User area 1 digital ground
`endif
    clk_i,
    reset_i,
    v_i,
    w_i,
    addr_i,
    data_i,
    write_mask_i,
    data_o
);

 parameter NUM_WMASKS = 4 ;
  parameter DATA_WIDTH = 32 ;
  parameter ADDR_WIDTH = 10 ;
  parameter RAM_DEPTH = 1 << ADDR_WIDTH;
`ifdef USE_POWER_PINS
    inout vccd1;
    inout vssd1;
`endif

  input reset_i;
  input  clk_i; // clock
  input   v_i; // active low chip select
  input  w_i; // active low write control
  input [NUM_WMASKS-1:0]   write_mask_i; // write mask
  input [ADDR_WIDTH-1:0]  addr_i;
  input [DATA_WIDTH-1:0]  data_i;
  output [DATA_WIDTH-1:0] data_o;
  wire [ADDR_WIDTH-1:0]  addr1;
  reg [DATA_WIDTH-1:0] dout1;
  assign csb1 = 1'b1;

sky130_sram_1kbyte_1rw1r_8x1024_8 sram8x1024_1 (
`ifdef USE_POWER_PINS
    .vccd1(vccd1),
    .vssd1(vccd1),
`endif
// Port 0: RW
    .clk0(clk_i),
    .csb0(v_i),
    .web0(w_i),
    .wmask0(write_mask_i[0]),
    .addr0(addr_i),
    .din0(data_i[7:0]),
    .dout0(data_o[7:0]),
// Port 1: R
    .clk1(clk_i),
    .csb1(csb1),
    .addr1(addr_i),
    .dout1(dout1)
);

sky130_sram_1kbyte_1rw1r_8x1024_8 sram8x1024_2 (
`ifdef USE_POWER_PINS
    .vccd1(vccd1),
    .vssd1(vssd1),
`endif
// Port 0: RW
    .clk0(clk_i),
    .csb0(v_i),
    .web0(w_i),
    .wmask0(write_mask_i[1]),
    .addr0(addr_i),
    .din0(data_i[15:8]),
    .dout0(data_o[15:8]),
// Port 1: R
    .clk1(clk_i),
    .csb1(csb1),
    .addr1(addr_i),
    .dout1(dout1)
);

sky130_sram_1kbyte_1rw1r_8x1024_8 sram8x1024_3 (
`ifdef USE_POWER_PINS
    .vccd1(vccd1),
    .vssd1(vssd1),
`endif
// Port 0: RW
    .clk0(clk_i),
    .csb0(v_i),
    .web0(w_i),
    .wmask0(write_mask_i[2]),
    .addr0(addr_i),
    .din0(data_i[23:16]),
    .dout0(data_o[23:16]),
// Port 1: R
    .clk1(clk_i),
    .csb1(csb1),
    .addr1(addr_i),
    .dout1(dout1)
);

sky130_sram_1kbyte_1rw1r_8x1024_8 sram8x1024_4 (
`ifdef USE_POWER_PINS
    .vccd1(vccd1),
    .vssd1(vssd1),
`endif
// Port 0: RW
    .clk0(clk_i),
    .csb0(v_i),
    .web0(w_i),
    .wmask0(write_mask_i[3]),
    .addr0(addr_i),
    .din0(data_i[31:24]),
    .dout0(data_o[31:24]),
// Port 1: R
    .clk1(clk_i),
    .csb1(csb1),
    .addr1(addr_i),
    .dout1(dout1)
);


endmodule
