module Element(
  input         clock,
  input  [63:0] io_ins_0,
  input  [63:0] io_ins_1,
  input  [63:0] io_ins_2,
  input  [63:0] io_ins_3,
  output [63:0] io_outs_0,
  output [63:0] io_outs_1,
  output [63:0] io_outs_2,
  output [63:0] io_outs_3
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
  reg [63:0] _RAND_1;
  reg [63:0] _RAND_2;
  reg [63:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] REG; // @[MockArray.scala 34:42]
  reg [63:0] REG_1; // @[MockArray.scala 34:42]
  reg [63:0] REG_2; // @[MockArray.scala 34:42]
  reg [63:0] REG_3; // @[MockArray.scala 34:42]
  assign io_outs_0 = REG; // @[MockArray.scala 34:13]
  assign io_outs_1 = REG_1; // @[MockArray.scala 34:13]
  assign io_outs_2 = REG_2; // @[MockArray.scala 34:13]
  assign io_outs_3 = REG_3; // @[MockArray.scala 34:13]
  always @(posedge clock) begin
    REG <= io_ins_3; // @[MockArray.scala 34:42]
    REG_1 <= io_ins_2; // @[MockArray.scala 34:42]
    REG_2 <= io_ins_1; // @[MockArray.scala 34:42]
    REG_3 <= io_ins_0; // @[MockArray.scala 34:42]
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
  _RAND_0 = {2{`RANDOM}};
  REG = _RAND_0[63:0];
  _RAND_1 = {2{`RANDOM}};
  REG_1 = _RAND_1[63:0];
  _RAND_2 = {2{`RANDOM}};
  REG_2 = _RAND_2[63:0];
  _RAND_3 = {2{`RANDOM}};
  REG_3 = _RAND_3[63:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
