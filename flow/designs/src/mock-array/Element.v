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
  reg  REG_4;
  assign io_outs_down = REG_3;
  assign io_outs_right = REG_2;
  assign io_outs_up = REG_1;
  assign io_outs_left = REG;
  assign io_lsbOuts_0 = io_lsbIns_1;
  assign io_lsbOuts_1 = io_lsbIns_2;
  assign io_lsbOuts_2 = io_lsbIns_3;
  assign io_lsbOuts_3 = REG_4;
  assign io_lsbOuts_4 = io_lsbIns_5;
  assign io_lsbOuts_5 = io_lsbIns_6;
  assign io_lsbOuts_6 = io_lsbIns_7;
  assign io_lsbOuts_7 = io_outs_left[0];
  always @(posedge clock) begin
    REG <= io_ins_down;
    REG_1 <= io_ins_right;
    REG_2 <= io_ins_up;
    REG_3 <= io_ins_left;
    REG_4 <= io_lsbIns_4;
  end
endmodule
