module MockArray(
  input         clock,
  input         reset,
  input  [63:0] io_ins_down_0,
  input  [63:0] io_ins_down_1,
  input  [63:0] io_ins_down_2,
  input  [63:0] io_ins_down_3,
  input  [63:0] io_ins_down_4,
  input  [63:0] io_ins_down_5,
  input  [63:0] io_ins_down_6,
  input  [63:0] io_ins_down_7,
  input  [63:0] io_ins_up_0,
  input  [63:0] io_ins_up_1,
  input  [63:0] io_ins_up_2,
  input  [63:0] io_ins_up_3,
  input  [63:0] io_ins_up_4,
  input  [63:0] io_ins_up_5,
  input  [63:0] io_ins_up_6,
  input  [63:0] io_ins_up_7,
  input  [63:0] io_ins_right_0,
  input  [63:0] io_ins_left_0,
  output [63:0] io_outs_down_0,
  output [63:0] io_outs_down_1,
  output [63:0] io_outs_down_2,
  output [63:0] io_outs_down_3,
  output [63:0] io_outs_down_4,
  output [63:0] io_outs_down_5,
  output [63:0] io_outs_down_6,
  output [63:0] io_outs_down_7,
  output [63:0] io_outs_up_0,
  output [63:0] io_outs_up_1,
  output [63:0] io_outs_up_2,
  output [63:0] io_outs_up_3,
  output [63:0] io_outs_up_4,
  output [63:0] io_outs_up_5,
  output [63:0] io_outs_up_6,
  output [63:0] io_outs_up_7,
  output [63:0] io_outs_right_0,
  output [63:0] io_outs_left_0,
  output        io_lsbs_0,
  output        io_lsbs_1,
  output        io_lsbs_2,
  output        io_lsbs_3,
  output        io_lsbs_4,
  output        io_lsbs_5,
  output        io_lsbs_6,
  output        io_lsbs_7
);
  wire  ces_0_0_clock;
  wire [63:0] ces_0_0_io_ins_down;
  wire [63:0] ces_0_0_io_ins_right;
  wire [63:0] ces_0_0_io_ins_up;
  wire [63:0] ces_0_0_io_ins_left;
  wire [63:0] ces_0_0_io_outs_down;
  wire [63:0] ces_0_0_io_outs_right;
  wire [63:0] ces_0_0_io_outs_up;
  wire [63:0] ces_0_0_io_outs_left;
  wire  ces_0_0_io_lsbIns_1;
  wire  ces_0_0_io_lsbIns_2;
  wire  ces_0_0_io_lsbIns_3;
  wire  ces_0_0_io_lsbIns_4;
  wire  ces_0_0_io_lsbIns_5;
  wire  ces_0_0_io_lsbIns_6;
  wire  ces_0_0_io_lsbIns_7;
  wire  ces_0_0_io_lsbOuts_0;
  wire  ces_0_0_io_lsbOuts_1;
  wire  ces_0_0_io_lsbOuts_2;
  wire  ces_0_0_io_lsbOuts_3;
  wire  ces_0_0_io_lsbOuts_4;
  wire  ces_0_0_io_lsbOuts_5;
  wire  ces_0_0_io_lsbOuts_6;
  wire  ces_0_0_io_lsbOuts_7;
  wire  ces_0_1_clock;
  wire [63:0] ces_0_1_io_ins_down;
  wire [63:0] ces_0_1_io_ins_right;
  wire [63:0] ces_0_1_io_ins_up;
  wire [63:0] ces_0_1_io_ins_left;
  wire [63:0] ces_0_1_io_outs_down;
  wire [63:0] ces_0_1_io_outs_right;
  wire [63:0] ces_0_1_io_outs_up;
  wire [63:0] ces_0_1_io_outs_left;
  wire  ces_0_1_io_lsbIns_1;
  wire  ces_0_1_io_lsbIns_2;
  wire  ces_0_1_io_lsbIns_3;
  wire  ces_0_1_io_lsbIns_4;
  wire  ces_0_1_io_lsbIns_5;
  wire  ces_0_1_io_lsbIns_6;
  wire  ces_0_1_io_lsbIns_7;
  wire  ces_0_1_io_lsbOuts_0;
  wire  ces_0_1_io_lsbOuts_1;
  wire  ces_0_1_io_lsbOuts_2;
  wire  ces_0_1_io_lsbOuts_3;
  wire  ces_0_1_io_lsbOuts_4;
  wire  ces_0_1_io_lsbOuts_5;
  wire  ces_0_1_io_lsbOuts_6;
  wire  ces_0_1_io_lsbOuts_7;
  wire  ces_0_2_clock;
  wire [63:0] ces_0_2_io_ins_down;
  wire [63:0] ces_0_2_io_ins_right;
  wire [63:0] ces_0_2_io_ins_up;
  wire [63:0] ces_0_2_io_ins_left;
  wire [63:0] ces_0_2_io_outs_down;
  wire [63:0] ces_0_2_io_outs_right;
  wire [63:0] ces_0_2_io_outs_up;
  wire [63:0] ces_0_2_io_outs_left;
  wire  ces_0_2_io_lsbIns_1;
  wire  ces_0_2_io_lsbIns_2;
  wire  ces_0_2_io_lsbIns_3;
  wire  ces_0_2_io_lsbIns_4;
  wire  ces_0_2_io_lsbIns_5;
  wire  ces_0_2_io_lsbIns_6;
  wire  ces_0_2_io_lsbIns_7;
  wire  ces_0_2_io_lsbOuts_0;
  wire  ces_0_2_io_lsbOuts_1;
  wire  ces_0_2_io_lsbOuts_2;
  wire  ces_0_2_io_lsbOuts_3;
  wire  ces_0_2_io_lsbOuts_4;
  wire  ces_0_2_io_lsbOuts_5;
  wire  ces_0_2_io_lsbOuts_6;
  wire  ces_0_2_io_lsbOuts_7;
  wire  ces_0_3_clock;
  wire [63:0] ces_0_3_io_ins_down;
  wire [63:0] ces_0_3_io_ins_right;
  wire [63:0] ces_0_3_io_ins_up;
  wire [63:0] ces_0_3_io_ins_left;
  wire [63:0] ces_0_3_io_outs_down;
  wire [63:0] ces_0_3_io_outs_right;
  wire [63:0] ces_0_3_io_outs_up;
  wire [63:0] ces_0_3_io_outs_left;
  wire  ces_0_3_io_lsbIns_1;
  wire  ces_0_3_io_lsbIns_2;
  wire  ces_0_3_io_lsbIns_3;
  wire  ces_0_3_io_lsbIns_4;
  wire  ces_0_3_io_lsbIns_5;
  wire  ces_0_3_io_lsbIns_6;
  wire  ces_0_3_io_lsbIns_7;
  wire  ces_0_3_io_lsbOuts_0;
  wire  ces_0_3_io_lsbOuts_1;
  wire  ces_0_3_io_lsbOuts_2;
  wire  ces_0_3_io_lsbOuts_3;
  wire  ces_0_3_io_lsbOuts_4;
  wire  ces_0_3_io_lsbOuts_5;
  wire  ces_0_3_io_lsbOuts_6;
  wire  ces_0_3_io_lsbOuts_7;
  wire  ces_0_4_clock;
  wire [63:0] ces_0_4_io_ins_down;
  wire [63:0] ces_0_4_io_ins_right;
  wire [63:0] ces_0_4_io_ins_up;
  wire [63:0] ces_0_4_io_ins_left;
  wire [63:0] ces_0_4_io_outs_down;
  wire [63:0] ces_0_4_io_outs_right;
  wire [63:0] ces_0_4_io_outs_up;
  wire [63:0] ces_0_4_io_outs_left;
  wire  ces_0_4_io_lsbIns_1;
  wire  ces_0_4_io_lsbIns_2;
  wire  ces_0_4_io_lsbIns_3;
  wire  ces_0_4_io_lsbIns_4;
  wire  ces_0_4_io_lsbIns_5;
  wire  ces_0_4_io_lsbIns_6;
  wire  ces_0_4_io_lsbIns_7;
  wire  ces_0_4_io_lsbOuts_0;
  wire  ces_0_4_io_lsbOuts_1;
  wire  ces_0_4_io_lsbOuts_2;
  wire  ces_0_4_io_lsbOuts_3;
  wire  ces_0_4_io_lsbOuts_4;
  wire  ces_0_4_io_lsbOuts_5;
  wire  ces_0_4_io_lsbOuts_6;
  wire  ces_0_4_io_lsbOuts_7;
  wire  ces_0_5_clock;
  wire [63:0] ces_0_5_io_ins_down;
  wire [63:0] ces_0_5_io_ins_right;
  wire [63:0] ces_0_5_io_ins_up;
  wire [63:0] ces_0_5_io_ins_left;
  wire [63:0] ces_0_5_io_outs_down;
  wire [63:0] ces_0_5_io_outs_right;
  wire [63:0] ces_0_5_io_outs_up;
  wire [63:0] ces_0_5_io_outs_left;
  wire  ces_0_5_io_lsbIns_1;
  wire  ces_0_5_io_lsbIns_2;
  wire  ces_0_5_io_lsbIns_3;
  wire  ces_0_5_io_lsbIns_4;
  wire  ces_0_5_io_lsbIns_5;
  wire  ces_0_5_io_lsbIns_6;
  wire  ces_0_5_io_lsbIns_7;
  wire  ces_0_5_io_lsbOuts_0;
  wire  ces_0_5_io_lsbOuts_1;
  wire  ces_0_5_io_lsbOuts_2;
  wire  ces_0_5_io_lsbOuts_3;
  wire  ces_0_5_io_lsbOuts_4;
  wire  ces_0_5_io_lsbOuts_5;
  wire  ces_0_5_io_lsbOuts_6;
  wire  ces_0_5_io_lsbOuts_7;
  wire  ces_0_6_clock;
  wire [63:0] ces_0_6_io_ins_down;
  wire [63:0] ces_0_6_io_ins_right;
  wire [63:0] ces_0_6_io_ins_up;
  wire [63:0] ces_0_6_io_ins_left;
  wire [63:0] ces_0_6_io_outs_down;
  wire [63:0] ces_0_6_io_outs_right;
  wire [63:0] ces_0_6_io_outs_up;
  wire [63:0] ces_0_6_io_outs_left;
  wire  ces_0_6_io_lsbIns_1;
  wire  ces_0_6_io_lsbIns_2;
  wire  ces_0_6_io_lsbIns_3;
  wire  ces_0_6_io_lsbIns_4;
  wire  ces_0_6_io_lsbIns_5;
  wire  ces_0_6_io_lsbIns_6;
  wire  ces_0_6_io_lsbIns_7;
  wire  ces_0_6_io_lsbOuts_0;
  wire  ces_0_6_io_lsbOuts_1;
  wire  ces_0_6_io_lsbOuts_2;
  wire  ces_0_6_io_lsbOuts_3;
  wire  ces_0_6_io_lsbOuts_4;
  wire  ces_0_6_io_lsbOuts_5;
  wire  ces_0_6_io_lsbOuts_6;
  wire  ces_0_6_io_lsbOuts_7;
  wire  ces_0_7_clock;
  wire [63:0] ces_0_7_io_ins_down;
  wire [63:0] ces_0_7_io_ins_right;
  wire [63:0] ces_0_7_io_ins_up;
  wire [63:0] ces_0_7_io_ins_left;
  wire [63:0] ces_0_7_io_outs_down;
  wire [63:0] ces_0_7_io_outs_right;
  wire [63:0] ces_0_7_io_outs_up;
  wire [63:0] ces_0_7_io_outs_left;
  wire  ces_0_7_io_lsbIns_1;
  wire  ces_0_7_io_lsbIns_2;
  wire  ces_0_7_io_lsbIns_3;
  wire  ces_0_7_io_lsbIns_4;
  wire  ces_0_7_io_lsbIns_5;
  wire  ces_0_7_io_lsbIns_6;
  wire  ces_0_7_io_lsbIns_7;
  wire  ces_0_7_io_lsbOuts_0;
  wire  ces_0_7_io_lsbOuts_1;
  wire  ces_0_7_io_lsbOuts_2;
  wire  ces_0_7_io_lsbOuts_3;
  wire  ces_0_7_io_lsbOuts_4;
  wire  ces_0_7_io_lsbOuts_5;
  wire  ces_0_7_io_lsbOuts_6;
  wire  ces_0_7_io_lsbOuts_7;
  reg  REG_0;
  reg  REG_1;
  reg  REG_2;
  reg  REG_3;
  reg  REG_4;
  reg  REG_5;
  reg  REG_6;
  reg  REG_7;
  Element ces_0_0 (
    .clock(ces_0_0_clock),
    .io_ins_down(ces_0_0_io_ins_down),
    .io_ins_right(ces_0_0_io_ins_right),
    .io_ins_up(ces_0_0_io_ins_up),
    .io_ins_left(ces_0_0_io_ins_left),
    .io_outs_down(ces_0_0_io_outs_down),
    .io_outs_right(ces_0_0_io_outs_right),
    .io_outs_up(ces_0_0_io_outs_up),
    .io_outs_left(ces_0_0_io_outs_left),
    .io_lsbIns_1(ces_0_0_io_lsbIns_1),
    .io_lsbIns_2(ces_0_0_io_lsbIns_2),
    .io_lsbIns_3(ces_0_0_io_lsbIns_3),
    .io_lsbIns_4(ces_0_0_io_lsbIns_4),
    .io_lsbIns_5(ces_0_0_io_lsbIns_5),
    .io_lsbIns_6(ces_0_0_io_lsbIns_6),
    .io_lsbIns_7(ces_0_0_io_lsbIns_7),
    .io_lsbOuts_0(ces_0_0_io_lsbOuts_0),
    .io_lsbOuts_1(ces_0_0_io_lsbOuts_1),
    .io_lsbOuts_2(ces_0_0_io_lsbOuts_2),
    .io_lsbOuts_3(ces_0_0_io_lsbOuts_3),
    .io_lsbOuts_4(ces_0_0_io_lsbOuts_4),
    .io_lsbOuts_5(ces_0_0_io_lsbOuts_5),
    .io_lsbOuts_6(ces_0_0_io_lsbOuts_6),
    .io_lsbOuts_7(ces_0_0_io_lsbOuts_7)
  );
  Element ces_0_1 (
    .clock(ces_0_1_clock),
    .io_ins_down(ces_0_1_io_ins_down),
    .io_ins_right(ces_0_1_io_ins_right),
    .io_ins_up(ces_0_1_io_ins_up),
    .io_ins_left(ces_0_1_io_ins_left),
    .io_outs_down(ces_0_1_io_outs_down),
    .io_outs_right(ces_0_1_io_outs_right),
    .io_outs_up(ces_0_1_io_outs_up),
    .io_outs_left(ces_0_1_io_outs_left),
    .io_lsbIns_1(ces_0_1_io_lsbIns_1),
    .io_lsbIns_2(ces_0_1_io_lsbIns_2),
    .io_lsbIns_3(ces_0_1_io_lsbIns_3),
    .io_lsbIns_4(ces_0_1_io_lsbIns_4),
    .io_lsbIns_5(ces_0_1_io_lsbIns_5),
    .io_lsbIns_6(ces_0_1_io_lsbIns_6),
    .io_lsbIns_7(ces_0_1_io_lsbIns_7),
    .io_lsbOuts_0(ces_0_1_io_lsbOuts_0),
    .io_lsbOuts_1(ces_0_1_io_lsbOuts_1),
    .io_lsbOuts_2(ces_0_1_io_lsbOuts_2),
    .io_lsbOuts_3(ces_0_1_io_lsbOuts_3),
    .io_lsbOuts_4(ces_0_1_io_lsbOuts_4),
    .io_lsbOuts_5(ces_0_1_io_lsbOuts_5),
    .io_lsbOuts_6(ces_0_1_io_lsbOuts_6),
    .io_lsbOuts_7(ces_0_1_io_lsbOuts_7)
  );
  Element ces_0_2 (
    .clock(ces_0_2_clock),
    .io_ins_down(ces_0_2_io_ins_down),
    .io_ins_right(ces_0_2_io_ins_right),
    .io_ins_up(ces_0_2_io_ins_up),
    .io_ins_left(ces_0_2_io_ins_left),
    .io_outs_down(ces_0_2_io_outs_down),
    .io_outs_right(ces_0_2_io_outs_right),
    .io_outs_up(ces_0_2_io_outs_up),
    .io_outs_left(ces_0_2_io_outs_left),
    .io_lsbIns_1(ces_0_2_io_lsbIns_1),
    .io_lsbIns_2(ces_0_2_io_lsbIns_2),
    .io_lsbIns_3(ces_0_2_io_lsbIns_3),
    .io_lsbIns_4(ces_0_2_io_lsbIns_4),
    .io_lsbIns_5(ces_0_2_io_lsbIns_5),
    .io_lsbIns_6(ces_0_2_io_lsbIns_6),
    .io_lsbIns_7(ces_0_2_io_lsbIns_7),
    .io_lsbOuts_0(ces_0_2_io_lsbOuts_0),
    .io_lsbOuts_1(ces_0_2_io_lsbOuts_1),
    .io_lsbOuts_2(ces_0_2_io_lsbOuts_2),
    .io_lsbOuts_3(ces_0_2_io_lsbOuts_3),
    .io_lsbOuts_4(ces_0_2_io_lsbOuts_4),
    .io_lsbOuts_5(ces_0_2_io_lsbOuts_5),
    .io_lsbOuts_6(ces_0_2_io_lsbOuts_6),
    .io_lsbOuts_7(ces_0_2_io_lsbOuts_7)
  );
  Element ces_0_3 (
    .clock(ces_0_3_clock),
    .io_ins_down(ces_0_3_io_ins_down),
    .io_ins_right(ces_0_3_io_ins_right),
    .io_ins_up(ces_0_3_io_ins_up),
    .io_ins_left(ces_0_3_io_ins_left),
    .io_outs_down(ces_0_3_io_outs_down),
    .io_outs_right(ces_0_3_io_outs_right),
    .io_outs_up(ces_0_3_io_outs_up),
    .io_outs_left(ces_0_3_io_outs_left),
    .io_lsbIns_1(ces_0_3_io_lsbIns_1),
    .io_lsbIns_2(ces_0_3_io_lsbIns_2),
    .io_lsbIns_3(ces_0_3_io_lsbIns_3),
    .io_lsbIns_4(ces_0_3_io_lsbIns_4),
    .io_lsbIns_5(ces_0_3_io_lsbIns_5),
    .io_lsbIns_6(ces_0_3_io_lsbIns_6),
    .io_lsbIns_7(ces_0_3_io_lsbIns_7),
    .io_lsbOuts_0(ces_0_3_io_lsbOuts_0),
    .io_lsbOuts_1(ces_0_3_io_lsbOuts_1),
    .io_lsbOuts_2(ces_0_3_io_lsbOuts_2),
    .io_lsbOuts_3(ces_0_3_io_lsbOuts_3),
    .io_lsbOuts_4(ces_0_3_io_lsbOuts_4),
    .io_lsbOuts_5(ces_0_3_io_lsbOuts_5),
    .io_lsbOuts_6(ces_0_3_io_lsbOuts_6),
    .io_lsbOuts_7(ces_0_3_io_lsbOuts_7)
  );
  Element ces_0_4 (
    .clock(ces_0_4_clock),
    .io_ins_down(ces_0_4_io_ins_down),
    .io_ins_right(ces_0_4_io_ins_right),
    .io_ins_up(ces_0_4_io_ins_up),
    .io_ins_left(ces_0_4_io_ins_left),
    .io_outs_down(ces_0_4_io_outs_down),
    .io_outs_right(ces_0_4_io_outs_right),
    .io_outs_up(ces_0_4_io_outs_up),
    .io_outs_left(ces_0_4_io_outs_left),
    .io_lsbIns_1(ces_0_4_io_lsbIns_1),
    .io_lsbIns_2(ces_0_4_io_lsbIns_2),
    .io_lsbIns_3(ces_0_4_io_lsbIns_3),
    .io_lsbIns_4(ces_0_4_io_lsbIns_4),
    .io_lsbIns_5(ces_0_4_io_lsbIns_5),
    .io_lsbIns_6(ces_0_4_io_lsbIns_6),
    .io_lsbIns_7(ces_0_4_io_lsbIns_7),
    .io_lsbOuts_0(ces_0_4_io_lsbOuts_0),
    .io_lsbOuts_1(ces_0_4_io_lsbOuts_1),
    .io_lsbOuts_2(ces_0_4_io_lsbOuts_2),
    .io_lsbOuts_3(ces_0_4_io_lsbOuts_3),
    .io_lsbOuts_4(ces_0_4_io_lsbOuts_4),
    .io_lsbOuts_5(ces_0_4_io_lsbOuts_5),
    .io_lsbOuts_6(ces_0_4_io_lsbOuts_6),
    .io_lsbOuts_7(ces_0_4_io_lsbOuts_7)
  );
  Element ces_0_5 (
    .clock(ces_0_5_clock),
    .io_ins_down(ces_0_5_io_ins_down),
    .io_ins_right(ces_0_5_io_ins_right),
    .io_ins_up(ces_0_5_io_ins_up),
    .io_ins_left(ces_0_5_io_ins_left),
    .io_outs_down(ces_0_5_io_outs_down),
    .io_outs_right(ces_0_5_io_outs_right),
    .io_outs_up(ces_0_5_io_outs_up),
    .io_outs_left(ces_0_5_io_outs_left),
    .io_lsbIns_1(ces_0_5_io_lsbIns_1),
    .io_lsbIns_2(ces_0_5_io_lsbIns_2),
    .io_lsbIns_3(ces_0_5_io_lsbIns_3),
    .io_lsbIns_4(ces_0_5_io_lsbIns_4),
    .io_lsbIns_5(ces_0_5_io_lsbIns_5),
    .io_lsbIns_6(ces_0_5_io_lsbIns_6),
    .io_lsbIns_7(ces_0_5_io_lsbIns_7),
    .io_lsbOuts_0(ces_0_5_io_lsbOuts_0),
    .io_lsbOuts_1(ces_0_5_io_lsbOuts_1),
    .io_lsbOuts_2(ces_0_5_io_lsbOuts_2),
    .io_lsbOuts_3(ces_0_5_io_lsbOuts_3),
    .io_lsbOuts_4(ces_0_5_io_lsbOuts_4),
    .io_lsbOuts_5(ces_0_5_io_lsbOuts_5),
    .io_lsbOuts_6(ces_0_5_io_lsbOuts_6),
    .io_lsbOuts_7(ces_0_5_io_lsbOuts_7)
  );
  Element ces_0_6 (
    .clock(ces_0_6_clock),
    .io_ins_down(ces_0_6_io_ins_down),
    .io_ins_right(ces_0_6_io_ins_right),
    .io_ins_up(ces_0_6_io_ins_up),
    .io_ins_left(ces_0_6_io_ins_left),
    .io_outs_down(ces_0_6_io_outs_down),
    .io_outs_right(ces_0_6_io_outs_right),
    .io_outs_up(ces_0_6_io_outs_up),
    .io_outs_left(ces_0_6_io_outs_left),
    .io_lsbIns_1(ces_0_6_io_lsbIns_1),
    .io_lsbIns_2(ces_0_6_io_lsbIns_2),
    .io_lsbIns_3(ces_0_6_io_lsbIns_3),
    .io_lsbIns_4(ces_0_6_io_lsbIns_4),
    .io_lsbIns_5(ces_0_6_io_lsbIns_5),
    .io_lsbIns_6(ces_0_6_io_lsbIns_6),
    .io_lsbIns_7(ces_0_6_io_lsbIns_7),
    .io_lsbOuts_0(ces_0_6_io_lsbOuts_0),
    .io_lsbOuts_1(ces_0_6_io_lsbOuts_1),
    .io_lsbOuts_2(ces_0_6_io_lsbOuts_2),
    .io_lsbOuts_3(ces_0_6_io_lsbOuts_3),
    .io_lsbOuts_4(ces_0_6_io_lsbOuts_4),
    .io_lsbOuts_5(ces_0_6_io_lsbOuts_5),
    .io_lsbOuts_6(ces_0_6_io_lsbOuts_6),
    .io_lsbOuts_7(ces_0_6_io_lsbOuts_7)
  );
  Element ces_0_7 (
    .clock(ces_0_7_clock),
    .io_ins_down(ces_0_7_io_ins_down),
    .io_ins_right(ces_0_7_io_ins_right),
    .io_ins_up(ces_0_7_io_ins_up),
    .io_ins_left(ces_0_7_io_ins_left),
    .io_outs_down(ces_0_7_io_outs_down),
    .io_outs_right(ces_0_7_io_outs_right),
    .io_outs_up(ces_0_7_io_outs_up),
    .io_outs_left(ces_0_7_io_outs_left),
    .io_lsbIns_1(ces_0_7_io_lsbIns_1),
    .io_lsbIns_2(ces_0_7_io_lsbIns_2),
    .io_lsbIns_3(ces_0_7_io_lsbIns_3),
    .io_lsbIns_4(ces_0_7_io_lsbIns_4),
    .io_lsbIns_5(ces_0_7_io_lsbIns_5),
    .io_lsbIns_6(ces_0_7_io_lsbIns_6),
    .io_lsbIns_7(ces_0_7_io_lsbIns_7),
    .io_lsbOuts_0(ces_0_7_io_lsbOuts_0),
    .io_lsbOuts_1(ces_0_7_io_lsbOuts_1),
    .io_lsbOuts_2(ces_0_7_io_lsbOuts_2),
    .io_lsbOuts_3(ces_0_7_io_lsbOuts_3),
    .io_lsbOuts_4(ces_0_7_io_lsbOuts_4),
    .io_lsbOuts_5(ces_0_7_io_lsbOuts_5),
    .io_lsbOuts_6(ces_0_7_io_lsbOuts_6),
    .io_lsbOuts_7(ces_0_7_io_lsbOuts_7)
  );
  assign io_outs_down_0 = ces_0_0_io_outs_down;
  assign io_outs_down_1 = ces_0_1_io_outs_down;
  assign io_outs_down_2 = ces_0_2_io_outs_down;
  assign io_outs_down_3 = ces_0_3_io_outs_down;
  assign io_outs_down_4 = ces_0_4_io_outs_down;
  assign io_outs_down_5 = ces_0_5_io_outs_down;
  assign io_outs_down_6 = ces_0_6_io_outs_down;
  assign io_outs_down_7 = ces_0_7_io_outs_down;
  assign io_outs_up_0 = ces_0_0_io_outs_up;
  assign io_outs_up_1 = ces_0_1_io_outs_up;
  assign io_outs_up_2 = ces_0_2_io_outs_up;
  assign io_outs_up_3 = ces_0_3_io_outs_up;
  assign io_outs_up_4 = ces_0_4_io_outs_up;
  assign io_outs_up_5 = ces_0_5_io_outs_up;
  assign io_outs_up_6 = ces_0_6_io_outs_up;
  assign io_outs_up_7 = ces_0_7_io_outs_up;
  assign io_outs_right_0 = ces_0_7_io_outs_right;
  assign io_outs_left_0 = ces_0_0_io_outs_left;
  assign io_lsbs_0 = REG_0;
  assign io_lsbs_1 = REG_1;
  assign io_lsbs_2 = REG_2;
  assign io_lsbs_3 = REG_3;
  assign io_lsbs_4 = REG_4;
  assign io_lsbs_5 = REG_5;
  assign io_lsbs_6 = REG_6;
  assign io_lsbs_7 = REG_7;
  assign ces_0_0_clock = clock;
  assign ces_0_0_io_ins_down = io_ins_down_0;
  assign ces_0_0_io_ins_right = io_ins_right_0;
  assign ces_0_0_io_ins_up = io_ins_up_0;
  assign ces_0_0_io_ins_left = ces_0_1_io_outs_left;
  assign ces_0_0_io_lsbIns_1 = 1'h0;
  assign ces_0_0_io_lsbIns_2 = 1'h0;
  assign ces_0_0_io_lsbIns_3 = 1'h0;
  assign ces_0_0_io_lsbIns_4 = 1'h0;
  assign ces_0_0_io_lsbIns_5 = 1'h0;
  assign ces_0_0_io_lsbIns_6 = 1'h0;
  assign ces_0_0_io_lsbIns_7 = 1'h0;
  assign ces_0_1_clock = clock;
  assign ces_0_1_io_ins_down = io_ins_down_1;
  assign ces_0_1_io_ins_right = ces_0_0_io_outs_right;
  assign ces_0_1_io_ins_up = io_ins_up_1;
  assign ces_0_1_io_ins_left = ces_0_2_io_outs_left;
  assign ces_0_1_io_lsbIns_1 = ces_0_0_io_lsbOuts_1;
  assign ces_0_1_io_lsbIns_2 = ces_0_0_io_lsbOuts_2;
  assign ces_0_1_io_lsbIns_3 = ces_0_0_io_lsbOuts_3;
  assign ces_0_1_io_lsbIns_4 = ces_0_0_io_lsbOuts_4;
  assign ces_0_1_io_lsbIns_5 = ces_0_0_io_lsbOuts_5;
  assign ces_0_1_io_lsbIns_6 = ces_0_0_io_lsbOuts_6;
  assign ces_0_1_io_lsbIns_7 = ces_0_0_io_lsbOuts_7;
  assign ces_0_2_clock = clock;
  assign ces_0_2_io_ins_down = io_ins_down_2;
  assign ces_0_2_io_ins_right = ces_0_1_io_outs_right;
  assign ces_0_2_io_ins_up = io_ins_up_2;
  assign ces_0_2_io_ins_left = ces_0_3_io_outs_left;
  assign ces_0_2_io_lsbIns_1 = ces_0_1_io_lsbOuts_1;
  assign ces_0_2_io_lsbIns_2 = ces_0_1_io_lsbOuts_2;
  assign ces_0_2_io_lsbIns_3 = ces_0_1_io_lsbOuts_3;
  assign ces_0_2_io_lsbIns_4 = ces_0_1_io_lsbOuts_4;
  assign ces_0_2_io_lsbIns_5 = ces_0_1_io_lsbOuts_5;
  assign ces_0_2_io_lsbIns_6 = ces_0_1_io_lsbOuts_6;
  assign ces_0_2_io_lsbIns_7 = ces_0_1_io_lsbOuts_7;
  assign ces_0_3_clock = clock;
  assign ces_0_3_io_ins_down = io_ins_down_3;
  assign ces_0_3_io_ins_right = ces_0_2_io_outs_right;
  assign ces_0_3_io_ins_up = io_ins_up_3;
  assign ces_0_3_io_ins_left = ces_0_4_io_outs_left;
  assign ces_0_3_io_lsbIns_1 = ces_0_2_io_lsbOuts_1;
  assign ces_0_3_io_lsbIns_2 = ces_0_2_io_lsbOuts_2;
  assign ces_0_3_io_lsbIns_3 = ces_0_2_io_lsbOuts_3;
  assign ces_0_3_io_lsbIns_4 = ces_0_2_io_lsbOuts_4;
  assign ces_0_3_io_lsbIns_5 = ces_0_2_io_lsbOuts_5;
  assign ces_0_3_io_lsbIns_6 = ces_0_2_io_lsbOuts_6;
  assign ces_0_3_io_lsbIns_7 = ces_0_2_io_lsbOuts_7;
  assign ces_0_4_clock = clock;
  assign ces_0_4_io_ins_down = io_ins_down_4;
  assign ces_0_4_io_ins_right = ces_0_3_io_outs_right;
  assign ces_0_4_io_ins_up = io_ins_up_4;
  assign ces_0_4_io_ins_left = ces_0_5_io_outs_left;
  assign ces_0_4_io_lsbIns_1 = ces_0_3_io_lsbOuts_1;
  assign ces_0_4_io_lsbIns_2 = ces_0_3_io_lsbOuts_2;
  assign ces_0_4_io_lsbIns_3 = ces_0_3_io_lsbOuts_3;
  assign ces_0_4_io_lsbIns_4 = ces_0_3_io_lsbOuts_4;
  assign ces_0_4_io_lsbIns_5 = ces_0_3_io_lsbOuts_5;
  assign ces_0_4_io_lsbIns_6 = ces_0_3_io_lsbOuts_6;
  assign ces_0_4_io_lsbIns_7 = ces_0_3_io_lsbOuts_7;
  assign ces_0_5_clock = clock;
  assign ces_0_5_io_ins_down = io_ins_down_5;
  assign ces_0_5_io_ins_right = ces_0_4_io_outs_right;
  assign ces_0_5_io_ins_up = io_ins_up_5;
  assign ces_0_5_io_ins_left = ces_0_6_io_outs_left;
  assign ces_0_5_io_lsbIns_1 = ces_0_4_io_lsbOuts_1;
  assign ces_0_5_io_lsbIns_2 = ces_0_4_io_lsbOuts_2;
  assign ces_0_5_io_lsbIns_3 = ces_0_4_io_lsbOuts_3;
  assign ces_0_5_io_lsbIns_4 = ces_0_4_io_lsbOuts_4;
  assign ces_0_5_io_lsbIns_5 = ces_0_4_io_lsbOuts_5;
  assign ces_0_5_io_lsbIns_6 = ces_0_4_io_lsbOuts_6;
  assign ces_0_5_io_lsbIns_7 = ces_0_4_io_lsbOuts_7;
  assign ces_0_6_clock = clock;
  assign ces_0_6_io_ins_down = io_ins_down_6;
  assign ces_0_6_io_ins_right = ces_0_5_io_outs_right;
  assign ces_0_6_io_ins_up = io_ins_up_6;
  assign ces_0_6_io_ins_left = ces_0_7_io_outs_left;
  assign ces_0_6_io_lsbIns_1 = ces_0_5_io_lsbOuts_1;
  assign ces_0_6_io_lsbIns_2 = ces_0_5_io_lsbOuts_2;
  assign ces_0_6_io_lsbIns_3 = ces_0_5_io_lsbOuts_3;
  assign ces_0_6_io_lsbIns_4 = ces_0_5_io_lsbOuts_4;
  assign ces_0_6_io_lsbIns_5 = ces_0_5_io_lsbOuts_5;
  assign ces_0_6_io_lsbIns_6 = ces_0_5_io_lsbOuts_6;
  assign ces_0_6_io_lsbIns_7 = ces_0_5_io_lsbOuts_7;
  assign ces_0_7_clock = clock;
  assign ces_0_7_io_ins_down = io_ins_down_7;
  assign ces_0_7_io_ins_right = ces_0_6_io_outs_right;
  assign ces_0_7_io_ins_up = io_ins_up_7;
  assign ces_0_7_io_ins_left = io_ins_left_0;
  assign ces_0_7_io_lsbIns_1 = ces_0_6_io_lsbOuts_1;
  assign ces_0_7_io_lsbIns_2 = ces_0_6_io_lsbOuts_2;
  assign ces_0_7_io_lsbIns_3 = ces_0_6_io_lsbOuts_3;
  assign ces_0_7_io_lsbIns_4 = ces_0_6_io_lsbOuts_4;
  assign ces_0_7_io_lsbIns_5 = ces_0_6_io_lsbOuts_5;
  assign ces_0_7_io_lsbIns_6 = ces_0_6_io_lsbOuts_6;
  assign ces_0_7_io_lsbIns_7 = ces_0_6_io_lsbOuts_7;
  always @(posedge clock) begin
    REG_0 <= ces_0_7_io_lsbOuts_0;
    REG_1 <= ces_0_7_io_lsbOuts_1;
    REG_2 <= ces_0_7_io_lsbOuts_2;
    REG_3 <= ces_0_7_io_lsbOuts_3;
    REG_4 <= ces_0_7_io_lsbOuts_4;
    REG_5 <= ces_0_7_io_lsbOuts_5;
    REG_6 <= ces_0_7_io_lsbOuts_6;
    REG_7 <= ces_0_7_io_lsbOuts_7;
  end
endmodule
