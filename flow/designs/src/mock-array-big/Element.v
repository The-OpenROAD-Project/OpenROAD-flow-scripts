module Element(
  input        clock,
  input        reset,
  input  [7:0] io_ins_0,
  input  [7:0] io_ins_1,
  input  [7:0] io_ins_2,
  input  [7:0] io_ins_3,
  output [7:0] io_outs_0,
  output [7:0] io_outs_1,
  output [7:0] io_outs_2,
  output [7:0] io_outs_3,
  input        io_softReset
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] counter2; // @[MockArray.scala 35:23]
  wire [7:0] _counter2_T_1 = counter2 + 8'h1; // @[MockArray.scala 36:26]
  wire [10:0] _GEN_0 = io_softReset ? 11'h4d2 : {{3'd0}, _counter2_T_1}; // @[MockArray.scala 36:14 37:25 38:16]
  reg [7:0] counter; // @[MockArray.scala 40:26]
  wire [7:0] _T_1 = io_ins_3 + counter; // @[MockArray.scala 42:58]
  reg [7:0] REG; // @[MockArray.scala 42:51]
  wire [7:0] _T_5 = io_ins_2 + counter; // @[MockArray.scala 42:58]
  reg [7:0] REG_1; // @[MockArray.scala 42:51]
  wire [7:0] _T_9 = io_ins_1 + counter; // @[MockArray.scala 42:58]
  reg [7:0] REG_2; // @[MockArray.scala 42:51]
  wire [7:0] _T_13 = io_ins_0 + counter; // @[MockArray.scala 42:58]
  reg [7:0] REG_3; // @[MockArray.scala 42:51]
  assign io_outs_0 = REG; // @[MockArray.scala 42:13]
  assign io_outs_1 = REG_1; // @[MockArray.scala 42:13]
  assign io_outs_2 = REG_2; // @[MockArray.scala 42:13]
  assign io_outs_3 = REG_3; // @[MockArray.scala 42:13]
  always @(posedge clock) begin
    counter2 <= _GEN_0[7:0];
    REG <= _T_1 + counter2; // @[MockArray.scala 42:68]
    REG_1 <= _T_5 + counter2; // @[MockArray.scala 42:68]
    REG_2 <= _T_9 + counter2; // @[MockArray.scala 42:68]
    REG_3 <= _T_13 + counter2; // @[MockArray.scala 42:68]
  end
  always @(posedge clock or posedge reset) begin
    if (reset) begin // @[MockArray.scala 41:24]
      counter <= 8'h2a;
    end else begin
      counter <= counter + 8'h1;
    end
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
  counter2 = _RAND_0[7:0];
  _RAND_1 = {1{`RANDOM}};
  counter = _RAND_1[7:0];
  _RAND_2 = {1{`RANDOM}};
  REG = _RAND_2[7:0];
  _RAND_3 = {1{`RANDOM}};
  REG_1 = _RAND_3[7:0];
  _RAND_4 = {1{`RANDOM}};
  REG_2 = _RAND_4[7:0];
  _RAND_5 = {1{`RANDOM}};
  REG_3 = _RAND_5[7:0];
`endif // RANDOMIZE_REG_INIT
  if (reset) begin
    counter = 8'h2a;
  end
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
