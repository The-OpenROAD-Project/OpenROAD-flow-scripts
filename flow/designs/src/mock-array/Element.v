module Element(
  input         clock,
  input  [63:0] io_ins_down,
  input  [63:0] io_ins_right,
  input  [63:0] io_ins_up,
  input  [63:0] io_ins_left,
  output [63:0] io_outs_down,
  output [63:0] io_outs_right,
  output [63:0] io_outs_up,
  output [63:0] io_outs_left,
  input         io_lsbIns_1,
  input         io_lsbIns_2,
  input         io_lsbIns_3,
  input         io_lsbIns_4,
  input         io_lsbIns_5,
  input         io_lsbIns_6,
  input         io_lsbIns_7,
  output        io_lsbOuts_0,
  output        io_lsbOuts_1,
  output        io_lsbOuts_2,
  output        io_lsbOuts_3,
  output        io_lsbOuts_4,
  output        io_lsbOuts_5,
  output        io_lsbOuts_6,
  output        io_lsbOuts_7
);
  reg [63:0] REG;
  reg [63:0] REG_1;
  reg [63:0] REG_2;
  reg [63:0] REG_3;
  reg [63:0] REG_4;
  reg [63:0] REG_5;
  reg [63:0] REG_6;
  reg [63:0] REG_7;
  reg [63:0] io_outs_left_REG;
  reg [63:0] io_outs_up_REG;
  reg [63:0] io_outs_right_REG;
  reg [63:0] io_outs_down_REG;
  reg  REG_8;
  assign io_outs_down = io_outs_down_REG;
  assign io_outs_right = io_outs_right_REG;
  assign io_outs_up = io_outs_up_REG;
  assign io_outs_left = io_outs_left_REG;
  assign io_lsbOuts_0 = io_lsbIns_1;
  assign io_lsbOuts_1 = io_lsbIns_2;
  assign io_lsbOuts_2 = io_lsbIns_3;
  assign io_lsbOuts_3 = REG_8;
  assign io_lsbOuts_4 = io_lsbIns_5;
  assign io_lsbOuts_5 = io_lsbIns_6;
  assign io_lsbOuts_6 = io_lsbIns_7;
  assign io_lsbOuts_7 = io_outs_left[0];
  always @(posedge clock) begin
    REG <= io_ins_down;
    REG_1 <= io_ins_left;
    REG_2 <= io_ins_right;
    REG_3 <= io_ins_down;
    REG_4 <= io_ins_up;
    REG_5 <= io_ins_right;
    REG_6 <= io_ins_left;
    REG_7 <= io_ins_up;
    io_outs_left_REG <= REG ^ REG_1;
    io_outs_up_REG <= REG_2 ^ REG_3;
    io_outs_right_REG <= REG_4 ^ REG_5;
    io_outs_down_REG <= REG_6 ^ REG_7;
    REG_8 <= io_lsbIns_4;
  end
endmodule
