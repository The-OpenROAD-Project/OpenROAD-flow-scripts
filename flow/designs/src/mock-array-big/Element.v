module Element(
  input        clock,
  input  [7:0] io_ins_down, // @[src/test/scala/MockArray.scala 50:9]
  input  [7:0] io_ins_right, // @[src/test/scala/MockArray.scala 50:9]
  input  [7:0] io_ins_up, // @[src/test/scala/MockArray.scala 50:9]
  input  [7:0] io_ins_left, // @[src/test/scala/MockArray.scala 50:9]
  output [7:0] io_outs_down, // @[src/test/scala/MockArray.scala 50:9]
  output [7:0] io_outs_right, // @[src/test/scala/MockArray.scala 50:9]
  output [7:0] io_outs_up, // @[src/test/scala/MockArray.scala 50:9]
  output [7:0] io_outs_left, // @[src/test/scala/MockArray.scala 50:9]
  input        io_lsbIns_0, // @[src/test/scala/MockArray.scala 50:9]
  input        io_lsbIns_1, // @[src/test/scala/MockArray.scala 50:9]
  input        io_lsbIns_2, // @[src/test/scala/MockArray.scala 50:9]
  input        io_lsbIns_3, // @[src/test/scala/MockArray.scala 50:9]
  input        io_lsbIns_4, // @[src/test/scala/MockArray.scala 50:9]
  input        io_lsbIns_5, // @[src/test/scala/MockArray.scala 50:9]
  input        io_lsbIns_6, // @[src/test/scala/MockArray.scala 50:9]
  input        io_lsbIns_7, // @[src/test/scala/MockArray.scala 50:9]
  output       io_lsbOuts_0, // @[src/test/scala/MockArray.scala 50:9]
  output       io_lsbOuts_1, // @[src/test/scala/MockArray.scala 50:9]
  output       io_lsbOuts_2, // @[src/test/scala/MockArray.scala 50:9]
  output       io_lsbOuts_3, // @[src/test/scala/MockArray.scala 50:9]
  output       io_lsbOuts_4, // @[src/test/scala/MockArray.scala 50:9]
  output       io_lsbOuts_5, // @[src/test/scala/MockArray.scala 50:9]
  output       io_lsbOuts_6, // @[src/test/scala/MockArray.scala 50:9]
  output       io_lsbOuts_7 // @[src/test/scala/MockArray.scala 50:9]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] REG; // @[src/test/scala/MockArray.scala 61:56]
  reg [7:0] REG_1; // @[src/test/scala/MockArray.scala 61:56]
  reg [7:0] REG_2; // @[src/test/scala/MockArray.scala 61:56]
  reg [7:0] REG_3; // @[src/test/scala/MockArray.scala 61:56]
  assign io_outs_down = REG_3; // @[src/test/scala/MockArray.scala 61:87]
  assign io_outs_right = REG_2; // @[src/test/scala/MockArray.scala 61:87]
  assign io_outs_up = REG_1; // @[src/test/scala/MockArray.scala 61:87]
  assign io_outs_left = REG; // @[src/test/scala/MockArray.scala 61:87]
  assign io_lsbOuts_0 = io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:16]
  assign io_lsbOuts_1 = io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:16]
  assign io_lsbOuts_2 = io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:16]
  assign io_lsbOuts_3 = io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:16]
  assign io_lsbOuts_4 = io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:16]
  assign io_lsbOuts_5 = io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:16]
  assign io_lsbOuts_6 = io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:16]
  assign io_lsbOuts_7 = io_outs_left[0]; // @[src/test/scala/MockArray.scala 66:62]
  always @(posedge clock) begin
    REG <= io_ins_down; // @[src/test/scala/MockArray.scala 61:56]
    REG_1 <= io_ins_right; // @[src/test/scala/MockArray.scala 61:56]
    REG_2 <= io_ins_up; // @[src/test/scala/MockArray.scala 61:56]
    REG_3 <= io_ins_left; // @[src/test/scala/MockArray.scala 61:56]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  REG = _RAND_0[7:0];
  _RAND_1 = {1{`RANDOM}};
  REG_1 = _RAND_1[7:0];
  _RAND_2 = {1{`RANDOM}};
  REG_2 = _RAND_2[7:0];
  _RAND_3 = {1{`RANDOM}};
  REG_3 = _RAND_3[7:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
