module MockArray(
  input        clock,
  input        reset,
  input  [7:0] io_insHorizontal_0_0,
  input  [7:0] io_insHorizontal_0_1,
  input  [7:0] io_insHorizontal_1_0,
  input  [7:0] io_insHorizontal_1_1,
  output [7:0] io_outsHorizontal_0_0,
  output [7:0] io_outsHorizontal_0_1,
  output [7:0] io_outsHorizontal_1_0,
  output [7:0] io_outsHorizontal_1_1,
  input  [7:0] io_insVertical_0_0,
  input  [7:0] io_insVertical_0_1,
  input  [7:0] io_insVertical_1_0,
  input  [7:0] io_insVertical_1_1,
  output [7:0] io_outsVertical_0_0,
  output [7:0] io_outsVertical_0_1,
  output [7:0] io_outsVertical_1_0,
  output [7:0] io_outsVertical_1_1
);
  wire  ces_0_0_clock; // @[MockArray.scala 43:53]
  wire [7:0] ces_0_0_io_ins_0; // @[MockArray.scala 43:53]
  wire [7:0] ces_0_0_io_ins_1; // @[MockArray.scala 43:53]
  wire [7:0] ces_0_0_io_ins_2; // @[MockArray.scala 43:53]
  wire [7:0] ces_0_0_io_ins_3; // @[MockArray.scala 43:53]
  wire [7:0] ces_0_0_io_outs_0; // @[MockArray.scala 43:53]
  wire [7:0] ces_0_0_io_outs_1; // @[MockArray.scala 43:53]
  wire [7:0] ces_0_0_io_outs_2; // @[MockArray.scala 43:53]
  wire [7:0] ces_0_0_io_outs_3; // @[MockArray.scala 43:53]
  wire  ces_0_1_clock; // @[MockArray.scala 43:53]
  wire [7:0] ces_0_1_io_ins_0; // @[MockArray.scala 43:53]
  wire [7:0] ces_0_1_io_ins_1; // @[MockArray.scala 43:53]
  wire [7:0] ces_0_1_io_ins_2; // @[MockArray.scala 43:53]
  wire [7:0] ces_0_1_io_ins_3; // @[MockArray.scala 43:53]
  wire [7:0] ces_0_1_io_outs_0; // @[MockArray.scala 43:53]
  wire [7:0] ces_0_1_io_outs_1; // @[MockArray.scala 43:53]
  wire [7:0] ces_0_1_io_outs_2; // @[MockArray.scala 43:53]
  wire [7:0] ces_0_1_io_outs_3; // @[MockArray.scala 43:53]
  wire  ces_1_0_clock; // @[MockArray.scala 43:53]
  wire [7:0] ces_1_0_io_ins_0; // @[MockArray.scala 43:53]
  wire [7:0] ces_1_0_io_ins_1; // @[MockArray.scala 43:53]
  wire [7:0] ces_1_0_io_ins_2; // @[MockArray.scala 43:53]
  wire [7:0] ces_1_0_io_ins_3; // @[MockArray.scala 43:53]
  wire [7:0] ces_1_0_io_outs_0; // @[MockArray.scala 43:53]
  wire [7:0] ces_1_0_io_outs_1; // @[MockArray.scala 43:53]
  wire [7:0] ces_1_0_io_outs_2; // @[MockArray.scala 43:53]
  wire [7:0] ces_1_0_io_outs_3; // @[MockArray.scala 43:53]
  wire  ces_1_1_clock; // @[MockArray.scala 43:53]
  wire [7:0] ces_1_1_io_ins_0; // @[MockArray.scala 43:53]
  wire [7:0] ces_1_1_io_ins_1; // @[MockArray.scala 43:53]
  wire [7:0] ces_1_1_io_ins_2; // @[MockArray.scala 43:53]
  wire [7:0] ces_1_1_io_ins_3; // @[MockArray.scala 43:53]
  wire [7:0] ces_1_1_io_outs_0; // @[MockArray.scala 43:53]
  wire [7:0] ces_1_1_io_outs_1; // @[MockArray.scala 43:53]
  wire [7:0] ces_1_1_io_outs_2; // @[MockArray.scala 43:53]
  wire [7:0] ces_1_1_io_outs_3; // @[MockArray.scala 43:53]
  Element ces_0_0 ( // @[MockArray.scala 43:53]
    .clock(ces_0_0_clock),
    .io_ins_0(ces_0_0_io_ins_0),
    .io_ins_1(ces_0_0_io_ins_1),
    .io_ins_2(ces_0_0_io_ins_2),
    .io_ins_3(ces_0_0_io_ins_3),
    .io_outs_0(ces_0_0_io_outs_0),
    .io_outs_1(ces_0_0_io_outs_1),
    .io_outs_2(ces_0_0_io_outs_2),
    .io_outs_3(ces_0_0_io_outs_3)
  );
  Element ces_0_1 ( // @[MockArray.scala 43:53]
    .clock(ces_0_1_clock),
    .io_ins_0(ces_0_1_io_ins_0),
    .io_ins_1(ces_0_1_io_ins_1),
    .io_ins_2(ces_0_1_io_ins_2),
    .io_ins_3(ces_0_1_io_ins_3),
    .io_outs_0(ces_0_1_io_outs_0),
    .io_outs_1(ces_0_1_io_outs_1),
    .io_outs_2(ces_0_1_io_outs_2),
    .io_outs_3(ces_0_1_io_outs_3)
  );
  Element ces_1_0 ( // @[MockArray.scala 43:53]
    .clock(ces_1_0_clock),
    .io_ins_0(ces_1_0_io_ins_0),
    .io_ins_1(ces_1_0_io_ins_1),
    .io_ins_2(ces_1_0_io_ins_2),
    .io_ins_3(ces_1_0_io_ins_3),
    .io_outs_0(ces_1_0_io_outs_0),
    .io_outs_1(ces_1_0_io_outs_1),
    .io_outs_2(ces_1_0_io_outs_2),
    .io_outs_3(ces_1_0_io_outs_3)
  );
  Element ces_1_1 ( // @[MockArray.scala 43:53]
    .clock(ces_1_1_clock),
    .io_ins_0(ces_1_1_io_ins_0),
    .io_ins_1(ces_1_1_io_ins_1),
    .io_ins_2(ces_1_1_io_ins_2),
    .io_ins_3(ces_1_1_io_ins_3),
    .io_outs_0(ces_1_1_io_outs_0),
    .io_outs_1(ces_1_1_io_outs_1),
    .io_outs_2(ces_1_1_io_outs_2),
    .io_outs_3(ces_1_1_io_outs_3)
  );
  assign io_outsHorizontal_0_0 = ces_0_0_io_outs_0; // @[MockArray.scala 54:89]
  assign io_outsHorizontal_0_1 = ces_0_1_io_outs_0; // @[MockArray.scala 54:89]
  assign io_outsHorizontal_1_0 = ces_1_0_io_outs_2; // @[MockArray.scala 56:89]
  assign io_outsHorizontal_1_1 = ces_1_1_io_outs_2; // @[MockArray.scala 56:89]
  assign io_outsVertical_0_0 = ces_0_1_io_outs_1; // @[MockArray.scala 55:89]
  assign io_outsVertical_0_1 = ces_1_1_io_outs_1; // @[MockArray.scala 55:89]
  assign io_outsVertical_1_0 = ces_0_0_io_outs_3; // @[MockArray.scala 57:89]
  assign io_outsVertical_1_1 = ces_1_0_io_outs_3; // @[MockArray.scala 57:89]
  assign ces_0_0_clock = clock;
  assign ces_0_0_io_ins_0 = io_insHorizontal_0_0; // @[MockArray.scala 49:87]
  assign ces_0_0_io_ins_1 = ces_0_1_io_outs_3; // @[MockArray.scala 67:19]
  assign ces_0_0_io_ins_2 = ces_1_0_io_outs_0; // @[MockArray.scala 61:19]
  assign ces_0_0_io_ins_3 = io_insVertical_1_0; // @[MockArray.scala 52:87]
  assign ces_0_1_clock = clock;
  assign ces_0_1_io_ins_0 = io_insHorizontal_0_1; // @[MockArray.scala 49:87]
  assign ces_0_1_io_ins_1 = io_insVertical_0_0; // @[MockArray.scala 50:87]
  assign ces_0_1_io_ins_2 = ces_1_1_io_outs_0; // @[MockArray.scala 61:19]
  assign ces_0_1_io_ins_3 = ces_0_0_io_outs_1; // @[MockArray.scala 68:19]
  assign ces_1_0_clock = clock;
  assign ces_1_0_io_ins_0 = ces_0_0_io_outs_2; // @[MockArray.scala 62:19]
  assign ces_1_0_io_ins_1 = ces_1_1_io_outs_3; // @[MockArray.scala 67:19]
  assign ces_1_0_io_ins_2 = io_insHorizontal_1_0; // @[MockArray.scala 51:87]
  assign ces_1_0_io_ins_3 = io_insVertical_1_1; // @[MockArray.scala 52:87]
  assign ces_1_1_clock = clock;
  assign ces_1_1_io_ins_0 = ces_0_1_io_outs_2; // @[MockArray.scala 62:19]
  assign ces_1_1_io_ins_1 = io_insVertical_0_1; // @[MockArray.scala 50:87]
  assign ces_1_1_io_ins_2 = io_insHorizontal_1_1; // @[MockArray.scala 51:87]
  assign ces_1_1_io_ins_3 = ces_1_0_io_outs_1; // @[MockArray.scala 68:19]
endmodule
