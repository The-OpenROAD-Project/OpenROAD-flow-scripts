module hard_mem_1rw_d1024_w46_wrapper(
`ifdef USE_POWER_PINS
    vccd1,  // User area 1 1.8V power
    vssd1, // User area 1 digital ground
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

 parameter NUM_WMASKS = 1 ;
  parameter DATA_WIDTH = 46 ;
  parameter ADDR_WIDTH = 9 ;
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
  wire [7:0] data, data1;
  //assign data [7:6] = 2'bz;
  //assign data1 [7:6] = 2'bz;
  assign data [5:0] = data_i[45:40];
  assign data1 [5:0] =data_o[45:40]; 

synthram_512x8 sram8x512_1 (
`ifdef USE_POWER_PINS
    .vccd1(vccd1),
    .vssd1(vccd1),
`endif
// Port 0: RW
    .clk(clk_i),
    .ce_in(v_i),
    .we_in(w_i),
    .w_mask_in({8{write_mask_i}}),
    .addr_in(addr_i),
    .wd_in(data_i[7:0]),
    .rd_out(data_o[7:0]),
);

synthram_512x8 sram8x512_2 (
`ifdef USE_POWER_PINS
    .vccd1(vccd1),
    .vssd1(vccd1),
`endif
// Port 0: RW
    .clk(clk_i),
    .ce_in(v_i),
    .we_in(w_i),
    .w_mask_in({8{write_mask_i}}),
    .addr_in(addr_i),
    .wd_in(data_i[15:8]),
    .rd_out(data_o[15:8]),
);

synthram_512x8 sram8x512_3 (
`ifdef USE_POWER_PINS
    .vccd1(vccd1),
    .vssd1(vccd1),
`endif
// Port 0: RW
    .clk(clk_i),
    .ce_in(v_i),
    .we_in(w_i),
    .w_mask_in({8{write_mask_i}}),
    .addr_in(addr_i),
    .wd_in(data_i[23:16]),
    .rd_out(data_o[23:16]),
);

synthram_512x8 sram8x512_4 (
`ifdef USE_POWER_PINS
    .vccd1(vccd1),
    .vssd1(vccd1),
`endif
// Port 0: RW
    .clk(clk_i),
    .ce_in(v_i),
    .we_in(w_i),
    .w_mask_in({8{write_mask_i}}),
    .addr_in(addr_i),
    .wd_in(data_i[31:24]),
    .rd_out(data_o[31:24]),
);

synthram_512x8 sram8x512_5 (
`ifdef USE_POWER_PINS
    .vccd1(vccd1),
    .vssd1(vccd1),
`endif
// Port 0: RW
    .clk(clk_i),
    .ce_in(v_i),
    .we_in(w_i),
    .w_mask_in({8{write_mask_i}}),
    .addr_in(addr_i),
    .wd_in(data_i[39:32]),
    .rd_out(data_o[39:32]),
);

synthram_512x8 sram8x512_6 (
`ifdef USE_POWER_PINS
    .vccd1(vccd1),
    .vssd1(vccd1),
`endif
// Port 0: RW
    .clk(clk_i),
    .ce_in(v_i),
    .we_in(w_i),
    .w_mask_in({8{write_mask_i}}),
    .addr_in(addr_i),
    .wd_in(data),
    .rd_out(data1),
);

endmodule
