module MockArray(
  input        clock,
  input        reset,
  input  [7:0] io_insHorizontal_0_0,
  input  [7:0] io_insHorizontal_1_0,
  output [7:0] io_outsHorizontal_0_0,
  output [7:0] io_outsHorizontal_1_0,
  input  [7:0] io_insVertical_0_0,
  input  [7:0] io_insVertical_1_0,
  output [7:0] io_outsVertical_0_0,
  output [7:0] io_outsVertical_1_0,
  output       io_lsbs_0
);
  wire  ces_0_0_clock; // @[MockArray.scala 36:52]
  wire [7:0] ces_0_0_io_ins_0; // @[MockArray.scala 36:52]
  wire [7:0] ces_0_0_io_ins_1; // @[MockArray.scala 36:52]
  wire [7:0] ces_0_0_io_ins_2; // @[MockArray.scala 36:52]
  wire [7:0] ces_0_0_io_ins_3; // @[MockArray.scala 36:52]
  wire [7:0] ces_0_0_io_outs_0; // @[MockArray.scala 36:52]
  wire [7:0] ces_0_0_io_outs_1; // @[MockArray.scala 36:52]
  wire [7:0] ces_0_0_io_outs_2; // @[MockArray.scala 36:52]
  wire [7:0] ces_0_0_io_outs_3; // @[MockArray.scala 36:52]
  Element ces_0_0 ( // @[MockArray.scala 36:52]
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
  assign io_outsHorizontal_0_0 = ces_0_0_io_outs_0; // @[MockArray.scala 49:89]
  assign io_outsHorizontal_1_0 = ces_0_0_io_outs_2; // @[MockArray.scala 51:89]
  assign io_outsVertical_0_0 = ces_0_0_io_outs_1; // @[MockArray.scala 50:89]
  assign io_outsVertical_1_0 = ces_0_0_io_outs_3; // @[MockArray.scala 52:89]
  assign io_lsbs_0 = ces_0_0_io_outs_0[0]; // @[MockArray.scala 38:44]
  assign ces_0_0_clock = clock;
  assign ces_0_0_io_ins_0 = io_insHorizontal_0_0; // @[MockArray.scala 44:87]
  assign ces_0_0_io_ins_1 = io_insVertical_0_0; // @[MockArray.scala 45:87]
  assign ces_0_0_io_ins_2 = io_insHorizontal_1_0; // @[MockArray.scala 46:87]
  assign ces_0_0_io_ins_3 = io_insVertical_1_0; // @[MockArray.scala 47:87]
endmodule
