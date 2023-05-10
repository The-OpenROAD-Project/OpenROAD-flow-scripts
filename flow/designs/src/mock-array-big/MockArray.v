module MockArray(
  input        clock,
  input        reset,
  input  [7:0] io_insLeft_0, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insLeft_1, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insLeft_2, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insLeft_3, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insLeft_4, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insLeft_5, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insLeft_6, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insLeft_7, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insUp_0, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insUp_1, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insUp_2, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insUp_3, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insUp_4, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insUp_5, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insUp_6, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insUp_7, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insRight_0, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insRight_1, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insRight_2, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insRight_3, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insRight_4, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insRight_5, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insRight_6, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insRight_7, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insDown_0, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insDown_1, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insDown_2, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insDown_3, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insDown_4, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insDown_5, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insDown_6, // @[src/test/scala/MockArray.scala 34:14]
  input  [7:0] io_insDown_7, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsLeft_0, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsLeft_1, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsLeft_2, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsLeft_3, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsLeft_4, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsLeft_5, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsLeft_6, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsLeft_7, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsUp_0, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsUp_1, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsUp_2, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsUp_3, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsUp_4, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsUp_5, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsUp_6, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsUp_7, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsRight_0, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsRight_1, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsRight_2, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsRight_3, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsRight_4, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsRight_5, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsRight_6, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsRight_7, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsDown_0, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsDown_1, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsDown_2, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsDown_3, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsDown_4, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsDown_5, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsDown_6, // @[src/test/scala/MockArray.scala 34:14]
  output [7:0] io_outsDown_7, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_0, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_1, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_2, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_3, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_4, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_5, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_6, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_7, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_8, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_9, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_10, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_11, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_12, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_13, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_14, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_15, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_16, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_17, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_18, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_19, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_20, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_21, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_22, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_23, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_24, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_25, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_26, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_27, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_28, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_29, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_30, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_31, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_32, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_33, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_34, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_35, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_36, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_37, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_38, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_39, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_40, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_41, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_42, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_43, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_44, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_45, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_46, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_47, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_48, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_49, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_50, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_51, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_52, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_53, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_54, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_55, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_56, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_57, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_58, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_59, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_60, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_61, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_62, // @[src/test/scala/MockArray.scala 34:14]
  output       io_lsbs_63 // @[src/test/scala/MockArray.scala 34:14]
);
  wire  ces_0_0_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_0_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_0_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_0_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_0_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_0_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_0_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_0_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_0_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_0_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_0_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_0_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_0_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_0_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_0_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_0_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_0_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_0_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_0_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_0_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_0_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_0_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_0_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_0_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_1_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_1_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_1_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_1_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_1_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_1_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_1_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_1_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_1_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_1_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_1_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_1_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_1_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_1_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_1_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_1_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_1_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_1_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_1_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_1_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_1_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_1_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_1_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_1_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_2_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_2_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_2_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_2_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_2_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_2_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_2_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_2_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_2_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_2_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_2_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_2_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_2_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_2_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_2_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_2_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_2_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_2_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_2_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_2_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_2_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_2_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_2_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_2_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_3_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_3_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_3_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_3_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_3_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_3_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_3_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_3_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_3_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_3_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_3_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_3_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_3_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_3_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_3_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_3_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_3_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_3_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_3_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_3_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_3_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_3_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_3_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_3_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_4_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_4_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_4_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_4_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_4_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_4_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_4_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_4_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_4_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_4_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_4_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_4_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_4_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_4_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_4_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_4_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_4_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_4_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_4_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_4_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_4_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_4_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_4_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_4_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_5_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_5_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_5_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_5_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_5_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_5_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_5_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_5_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_5_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_5_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_5_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_5_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_5_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_5_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_5_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_5_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_5_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_5_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_5_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_5_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_5_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_5_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_5_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_5_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_6_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_6_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_6_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_6_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_6_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_6_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_6_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_6_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_6_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_6_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_6_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_6_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_6_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_6_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_6_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_6_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_6_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_6_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_6_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_6_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_6_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_6_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_6_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_6_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_7_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_7_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_7_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_7_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_7_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_7_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_7_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_7_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_0_7_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_7_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_7_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_7_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_7_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_7_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_7_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_7_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_7_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_7_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_7_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_7_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_7_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_7_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_7_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_0_7_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_0_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_0_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_0_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_0_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_0_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_0_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_0_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_0_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_0_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_0_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_0_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_0_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_0_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_0_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_0_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_0_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_0_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_0_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_0_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_0_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_0_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_0_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_0_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_0_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_1_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_1_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_1_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_1_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_1_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_1_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_1_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_1_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_1_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_1_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_1_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_1_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_1_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_1_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_1_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_1_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_1_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_1_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_1_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_1_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_1_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_1_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_1_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_1_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_2_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_2_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_2_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_2_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_2_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_2_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_2_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_2_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_2_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_2_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_2_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_2_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_2_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_2_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_2_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_2_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_2_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_2_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_2_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_2_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_2_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_2_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_2_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_2_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_3_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_3_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_3_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_3_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_3_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_3_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_3_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_3_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_3_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_3_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_3_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_3_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_3_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_3_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_3_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_3_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_3_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_3_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_3_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_3_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_3_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_3_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_3_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_3_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_4_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_4_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_4_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_4_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_4_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_4_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_4_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_4_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_4_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_4_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_4_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_4_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_4_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_4_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_4_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_4_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_4_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_4_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_4_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_4_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_4_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_4_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_4_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_4_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_5_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_5_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_5_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_5_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_5_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_5_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_5_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_5_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_5_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_5_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_5_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_5_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_5_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_5_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_5_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_5_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_5_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_5_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_5_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_5_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_5_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_5_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_5_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_5_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_6_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_6_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_6_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_6_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_6_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_6_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_6_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_6_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_6_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_6_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_6_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_6_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_6_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_6_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_6_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_6_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_6_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_6_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_6_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_6_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_6_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_6_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_6_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_6_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_7_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_7_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_7_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_7_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_7_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_7_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_7_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_7_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_1_7_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_7_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_7_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_7_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_7_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_7_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_7_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_7_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_7_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_7_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_7_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_7_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_7_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_7_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_7_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_1_7_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_0_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_0_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_0_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_0_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_0_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_0_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_0_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_0_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_0_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_0_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_0_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_0_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_0_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_0_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_0_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_0_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_0_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_0_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_0_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_0_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_0_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_0_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_0_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_0_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_1_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_1_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_1_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_1_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_1_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_1_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_1_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_1_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_1_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_1_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_1_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_1_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_1_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_1_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_1_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_1_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_1_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_1_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_1_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_1_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_1_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_1_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_1_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_1_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_2_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_2_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_2_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_2_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_2_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_2_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_2_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_2_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_2_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_2_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_2_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_2_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_2_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_2_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_2_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_2_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_2_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_2_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_2_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_2_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_2_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_2_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_2_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_2_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_3_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_3_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_3_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_3_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_3_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_3_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_3_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_3_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_3_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_3_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_3_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_3_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_3_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_3_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_3_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_3_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_3_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_3_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_3_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_3_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_3_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_3_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_3_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_3_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_4_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_4_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_4_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_4_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_4_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_4_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_4_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_4_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_4_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_4_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_4_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_4_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_4_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_4_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_4_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_4_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_4_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_4_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_4_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_4_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_4_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_4_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_4_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_4_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_5_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_5_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_5_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_5_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_5_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_5_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_5_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_5_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_5_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_5_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_5_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_5_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_5_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_5_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_5_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_5_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_5_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_5_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_5_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_5_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_5_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_5_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_5_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_5_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_6_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_6_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_6_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_6_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_6_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_6_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_6_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_6_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_6_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_6_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_6_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_6_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_6_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_6_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_6_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_6_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_6_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_6_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_6_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_6_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_6_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_6_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_6_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_6_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_7_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_7_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_7_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_7_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_7_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_7_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_7_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_7_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_2_7_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_7_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_7_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_7_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_7_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_7_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_7_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_7_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_7_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_7_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_7_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_7_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_7_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_7_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_7_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_2_7_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_0_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_0_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_0_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_0_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_0_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_0_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_0_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_0_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_0_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_0_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_0_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_0_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_0_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_0_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_0_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_0_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_0_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_0_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_0_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_0_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_0_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_0_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_0_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_0_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_1_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_1_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_1_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_1_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_1_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_1_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_1_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_1_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_1_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_1_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_1_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_1_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_1_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_1_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_1_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_1_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_1_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_1_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_1_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_1_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_1_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_1_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_1_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_1_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_2_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_2_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_2_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_2_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_2_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_2_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_2_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_2_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_2_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_2_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_2_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_2_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_2_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_2_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_2_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_2_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_2_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_2_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_2_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_2_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_2_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_2_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_2_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_2_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_3_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_3_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_3_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_3_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_3_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_3_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_3_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_3_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_3_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_3_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_3_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_3_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_3_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_3_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_3_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_3_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_3_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_3_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_3_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_3_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_3_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_3_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_3_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_3_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_4_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_4_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_4_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_4_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_4_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_4_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_4_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_4_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_4_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_4_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_4_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_4_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_4_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_4_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_4_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_4_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_4_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_4_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_4_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_4_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_4_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_4_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_4_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_4_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_5_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_5_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_5_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_5_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_5_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_5_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_5_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_5_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_5_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_5_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_5_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_5_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_5_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_5_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_5_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_5_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_5_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_5_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_5_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_5_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_5_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_5_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_5_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_5_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_6_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_6_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_6_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_6_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_6_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_6_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_6_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_6_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_6_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_6_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_6_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_6_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_6_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_6_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_6_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_6_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_6_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_6_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_6_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_6_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_6_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_6_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_6_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_6_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_7_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_7_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_7_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_7_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_7_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_7_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_7_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_7_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_3_7_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_7_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_7_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_7_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_7_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_7_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_7_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_7_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_7_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_7_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_7_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_7_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_7_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_7_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_7_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_3_7_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_0_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_0_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_0_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_0_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_0_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_0_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_0_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_0_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_0_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_0_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_0_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_0_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_0_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_0_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_0_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_0_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_0_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_0_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_0_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_0_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_0_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_0_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_0_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_0_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_1_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_1_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_1_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_1_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_1_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_1_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_1_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_1_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_1_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_1_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_1_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_1_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_1_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_1_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_1_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_1_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_1_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_1_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_1_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_1_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_1_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_1_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_1_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_1_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_2_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_2_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_2_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_2_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_2_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_2_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_2_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_2_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_2_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_2_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_2_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_2_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_2_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_2_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_2_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_2_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_2_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_2_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_2_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_2_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_2_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_2_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_2_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_2_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_3_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_3_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_3_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_3_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_3_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_3_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_3_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_3_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_3_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_3_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_3_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_3_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_3_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_3_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_3_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_3_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_3_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_3_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_3_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_3_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_3_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_3_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_3_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_3_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_4_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_4_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_4_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_4_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_4_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_4_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_4_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_4_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_4_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_4_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_4_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_4_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_4_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_4_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_4_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_4_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_4_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_4_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_4_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_4_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_4_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_4_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_4_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_4_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_5_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_5_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_5_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_5_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_5_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_5_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_5_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_5_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_5_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_5_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_5_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_5_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_5_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_5_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_5_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_5_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_5_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_5_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_5_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_5_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_5_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_5_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_5_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_5_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_6_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_6_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_6_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_6_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_6_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_6_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_6_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_6_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_6_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_6_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_6_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_6_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_6_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_6_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_6_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_6_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_6_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_6_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_6_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_6_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_6_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_6_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_6_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_6_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_7_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_7_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_7_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_7_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_7_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_7_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_7_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_7_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_4_7_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_7_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_7_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_7_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_7_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_7_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_7_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_7_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_7_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_7_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_7_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_7_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_7_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_7_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_7_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_4_7_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_0_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_0_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_0_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_0_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_0_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_0_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_0_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_0_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_0_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_0_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_0_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_0_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_0_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_0_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_0_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_0_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_0_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_0_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_0_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_0_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_0_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_0_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_0_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_0_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_1_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_1_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_1_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_1_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_1_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_1_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_1_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_1_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_1_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_1_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_1_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_1_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_1_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_1_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_1_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_1_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_1_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_1_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_1_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_1_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_1_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_1_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_1_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_1_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_2_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_2_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_2_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_2_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_2_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_2_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_2_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_2_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_2_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_2_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_2_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_2_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_2_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_2_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_2_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_2_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_2_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_2_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_2_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_2_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_2_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_2_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_2_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_2_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_3_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_3_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_3_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_3_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_3_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_3_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_3_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_3_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_3_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_3_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_3_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_3_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_3_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_3_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_3_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_3_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_3_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_3_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_3_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_3_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_3_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_3_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_3_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_3_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_4_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_4_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_4_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_4_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_4_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_4_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_4_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_4_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_4_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_4_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_4_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_4_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_4_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_4_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_4_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_4_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_4_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_4_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_4_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_4_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_4_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_4_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_4_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_4_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_5_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_5_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_5_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_5_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_5_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_5_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_5_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_5_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_5_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_5_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_5_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_5_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_5_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_5_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_5_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_5_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_5_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_5_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_5_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_5_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_5_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_5_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_5_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_5_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_6_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_6_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_6_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_6_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_6_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_6_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_6_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_6_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_6_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_6_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_6_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_6_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_6_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_6_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_6_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_6_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_6_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_6_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_6_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_6_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_6_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_6_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_6_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_6_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_7_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_7_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_7_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_7_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_7_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_7_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_7_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_7_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_5_7_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_7_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_7_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_7_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_7_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_7_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_7_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_7_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_7_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_7_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_7_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_7_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_7_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_7_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_7_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_5_7_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_0_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_0_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_0_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_0_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_0_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_0_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_0_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_0_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_0_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_0_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_0_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_0_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_0_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_0_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_0_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_0_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_0_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_0_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_0_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_0_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_0_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_0_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_0_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_0_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_1_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_1_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_1_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_1_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_1_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_1_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_1_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_1_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_1_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_1_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_1_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_1_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_1_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_1_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_1_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_1_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_1_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_1_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_1_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_1_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_1_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_1_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_1_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_1_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_2_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_2_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_2_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_2_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_2_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_2_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_2_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_2_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_2_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_2_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_2_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_2_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_2_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_2_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_2_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_2_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_2_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_2_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_2_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_2_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_2_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_2_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_2_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_2_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_3_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_3_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_3_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_3_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_3_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_3_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_3_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_3_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_3_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_3_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_3_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_3_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_3_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_3_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_3_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_3_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_3_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_3_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_3_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_3_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_3_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_3_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_3_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_3_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_4_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_4_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_4_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_4_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_4_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_4_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_4_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_4_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_4_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_4_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_4_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_4_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_4_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_4_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_4_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_4_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_4_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_4_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_4_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_4_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_4_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_4_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_4_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_4_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_5_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_5_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_5_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_5_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_5_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_5_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_5_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_5_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_5_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_5_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_5_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_5_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_5_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_5_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_5_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_5_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_5_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_5_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_5_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_5_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_5_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_5_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_5_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_5_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_6_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_6_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_6_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_6_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_6_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_6_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_6_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_6_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_6_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_6_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_6_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_6_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_6_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_6_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_6_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_6_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_6_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_6_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_6_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_6_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_6_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_6_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_6_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_6_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_7_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_7_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_7_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_7_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_7_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_7_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_7_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_7_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_6_7_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_7_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_7_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_7_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_7_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_7_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_7_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_7_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_7_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_7_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_7_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_7_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_7_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_7_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_7_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_6_7_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_0_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_0_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_0_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_0_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_0_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_0_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_0_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_0_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_0_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_0_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_0_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_0_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_0_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_0_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_0_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_0_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_0_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_0_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_0_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_0_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_0_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_0_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_0_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_0_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_1_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_1_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_1_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_1_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_1_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_1_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_1_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_1_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_1_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_1_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_1_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_1_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_1_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_1_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_1_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_1_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_1_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_1_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_1_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_1_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_1_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_1_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_1_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_1_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_2_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_2_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_2_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_2_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_2_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_2_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_2_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_2_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_2_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_2_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_2_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_2_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_2_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_2_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_2_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_2_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_2_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_2_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_2_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_2_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_2_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_2_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_2_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_2_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_3_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_3_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_3_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_3_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_3_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_3_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_3_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_3_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_3_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_3_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_3_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_3_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_3_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_3_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_3_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_3_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_3_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_3_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_3_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_3_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_3_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_3_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_3_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_3_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_4_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_4_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_4_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_4_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_4_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_4_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_4_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_4_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_4_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_4_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_4_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_4_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_4_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_4_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_4_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_4_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_4_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_4_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_4_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_4_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_4_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_4_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_4_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_4_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_5_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_5_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_5_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_5_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_5_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_5_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_5_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_5_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_5_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_5_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_5_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_5_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_5_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_5_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_5_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_5_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_5_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_5_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_5_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_5_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_5_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_5_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_5_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_5_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_6_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_6_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_6_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_6_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_6_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_6_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_6_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_6_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_6_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_6_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_6_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_6_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_6_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_6_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_6_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_6_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_6_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_6_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_6_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_6_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_6_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_6_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_6_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_6_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_7_clock; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_7_io_ins_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_7_io_ins_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_7_io_ins_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_7_io_ins_left; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_7_io_outs_down; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_7_io_outs_right; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_7_io_outs_up; // @[src/test/scala/MockArray.scala 66:52]
  wire [7:0] ces_7_7_io_outs_left; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_7_io_lsbIns_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_7_io_lsbIns_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_7_io_lsbIns_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_7_io_lsbIns_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_7_io_lsbIns_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_7_io_lsbIns_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_7_io_lsbIns_7; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_7_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_7_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_7_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_7_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_7_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_7_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_7_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 66:52]
  wire  ces_7_7_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 66:52]
  Element ces_0_0 ( // @[src/test/scala/MockArray.scala 66:52]
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
  Element ces_0_1 ( // @[src/test/scala/MockArray.scala 66:52]
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
  Element ces_0_2 ( // @[src/test/scala/MockArray.scala 66:52]
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
  Element ces_0_3 ( // @[src/test/scala/MockArray.scala 66:52]
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
  Element ces_0_4 ( // @[src/test/scala/MockArray.scala 66:52]
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
  Element ces_0_5 ( // @[src/test/scala/MockArray.scala 66:52]
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
  Element ces_0_6 ( // @[src/test/scala/MockArray.scala 66:52]
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
  Element ces_0_7 ( // @[src/test/scala/MockArray.scala 66:52]
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
  Element ces_1_0 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_1_0_clock),
    .io_ins_down(ces_1_0_io_ins_down),
    .io_ins_right(ces_1_0_io_ins_right),
    .io_ins_up(ces_1_0_io_ins_up),
    .io_ins_left(ces_1_0_io_ins_left),
    .io_outs_down(ces_1_0_io_outs_down),
    .io_outs_right(ces_1_0_io_outs_right),
    .io_outs_up(ces_1_0_io_outs_up),
    .io_outs_left(ces_1_0_io_outs_left),
    .io_lsbIns_1(ces_1_0_io_lsbIns_1),
    .io_lsbIns_2(ces_1_0_io_lsbIns_2),
    .io_lsbIns_3(ces_1_0_io_lsbIns_3),
    .io_lsbIns_4(ces_1_0_io_lsbIns_4),
    .io_lsbIns_5(ces_1_0_io_lsbIns_5),
    .io_lsbIns_6(ces_1_0_io_lsbIns_6),
    .io_lsbIns_7(ces_1_0_io_lsbIns_7),
    .io_lsbOuts_0(ces_1_0_io_lsbOuts_0),
    .io_lsbOuts_1(ces_1_0_io_lsbOuts_1),
    .io_lsbOuts_2(ces_1_0_io_lsbOuts_2),
    .io_lsbOuts_3(ces_1_0_io_lsbOuts_3),
    .io_lsbOuts_4(ces_1_0_io_lsbOuts_4),
    .io_lsbOuts_5(ces_1_0_io_lsbOuts_5),
    .io_lsbOuts_6(ces_1_0_io_lsbOuts_6),
    .io_lsbOuts_7(ces_1_0_io_lsbOuts_7)
  );
  Element ces_1_1 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_1_1_clock),
    .io_ins_down(ces_1_1_io_ins_down),
    .io_ins_right(ces_1_1_io_ins_right),
    .io_ins_up(ces_1_1_io_ins_up),
    .io_ins_left(ces_1_1_io_ins_left),
    .io_outs_down(ces_1_1_io_outs_down),
    .io_outs_right(ces_1_1_io_outs_right),
    .io_outs_up(ces_1_1_io_outs_up),
    .io_outs_left(ces_1_1_io_outs_left),
    .io_lsbIns_1(ces_1_1_io_lsbIns_1),
    .io_lsbIns_2(ces_1_1_io_lsbIns_2),
    .io_lsbIns_3(ces_1_1_io_lsbIns_3),
    .io_lsbIns_4(ces_1_1_io_lsbIns_4),
    .io_lsbIns_5(ces_1_1_io_lsbIns_5),
    .io_lsbIns_6(ces_1_1_io_lsbIns_6),
    .io_lsbIns_7(ces_1_1_io_lsbIns_7),
    .io_lsbOuts_0(ces_1_1_io_lsbOuts_0),
    .io_lsbOuts_1(ces_1_1_io_lsbOuts_1),
    .io_lsbOuts_2(ces_1_1_io_lsbOuts_2),
    .io_lsbOuts_3(ces_1_1_io_lsbOuts_3),
    .io_lsbOuts_4(ces_1_1_io_lsbOuts_4),
    .io_lsbOuts_5(ces_1_1_io_lsbOuts_5),
    .io_lsbOuts_6(ces_1_1_io_lsbOuts_6),
    .io_lsbOuts_7(ces_1_1_io_lsbOuts_7)
  );
  Element ces_1_2 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_1_2_clock),
    .io_ins_down(ces_1_2_io_ins_down),
    .io_ins_right(ces_1_2_io_ins_right),
    .io_ins_up(ces_1_2_io_ins_up),
    .io_ins_left(ces_1_2_io_ins_left),
    .io_outs_down(ces_1_2_io_outs_down),
    .io_outs_right(ces_1_2_io_outs_right),
    .io_outs_up(ces_1_2_io_outs_up),
    .io_outs_left(ces_1_2_io_outs_left),
    .io_lsbIns_1(ces_1_2_io_lsbIns_1),
    .io_lsbIns_2(ces_1_2_io_lsbIns_2),
    .io_lsbIns_3(ces_1_2_io_lsbIns_3),
    .io_lsbIns_4(ces_1_2_io_lsbIns_4),
    .io_lsbIns_5(ces_1_2_io_lsbIns_5),
    .io_lsbIns_6(ces_1_2_io_lsbIns_6),
    .io_lsbIns_7(ces_1_2_io_lsbIns_7),
    .io_lsbOuts_0(ces_1_2_io_lsbOuts_0),
    .io_lsbOuts_1(ces_1_2_io_lsbOuts_1),
    .io_lsbOuts_2(ces_1_2_io_lsbOuts_2),
    .io_lsbOuts_3(ces_1_2_io_lsbOuts_3),
    .io_lsbOuts_4(ces_1_2_io_lsbOuts_4),
    .io_lsbOuts_5(ces_1_2_io_lsbOuts_5),
    .io_lsbOuts_6(ces_1_2_io_lsbOuts_6),
    .io_lsbOuts_7(ces_1_2_io_lsbOuts_7)
  );
  Element ces_1_3 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_1_3_clock),
    .io_ins_down(ces_1_3_io_ins_down),
    .io_ins_right(ces_1_3_io_ins_right),
    .io_ins_up(ces_1_3_io_ins_up),
    .io_ins_left(ces_1_3_io_ins_left),
    .io_outs_down(ces_1_3_io_outs_down),
    .io_outs_right(ces_1_3_io_outs_right),
    .io_outs_up(ces_1_3_io_outs_up),
    .io_outs_left(ces_1_3_io_outs_left),
    .io_lsbIns_1(ces_1_3_io_lsbIns_1),
    .io_lsbIns_2(ces_1_3_io_lsbIns_2),
    .io_lsbIns_3(ces_1_3_io_lsbIns_3),
    .io_lsbIns_4(ces_1_3_io_lsbIns_4),
    .io_lsbIns_5(ces_1_3_io_lsbIns_5),
    .io_lsbIns_6(ces_1_3_io_lsbIns_6),
    .io_lsbIns_7(ces_1_3_io_lsbIns_7),
    .io_lsbOuts_0(ces_1_3_io_lsbOuts_0),
    .io_lsbOuts_1(ces_1_3_io_lsbOuts_1),
    .io_lsbOuts_2(ces_1_3_io_lsbOuts_2),
    .io_lsbOuts_3(ces_1_3_io_lsbOuts_3),
    .io_lsbOuts_4(ces_1_3_io_lsbOuts_4),
    .io_lsbOuts_5(ces_1_3_io_lsbOuts_5),
    .io_lsbOuts_6(ces_1_3_io_lsbOuts_6),
    .io_lsbOuts_7(ces_1_3_io_lsbOuts_7)
  );
  Element ces_1_4 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_1_4_clock),
    .io_ins_down(ces_1_4_io_ins_down),
    .io_ins_right(ces_1_4_io_ins_right),
    .io_ins_up(ces_1_4_io_ins_up),
    .io_ins_left(ces_1_4_io_ins_left),
    .io_outs_down(ces_1_4_io_outs_down),
    .io_outs_right(ces_1_4_io_outs_right),
    .io_outs_up(ces_1_4_io_outs_up),
    .io_outs_left(ces_1_4_io_outs_left),
    .io_lsbIns_1(ces_1_4_io_lsbIns_1),
    .io_lsbIns_2(ces_1_4_io_lsbIns_2),
    .io_lsbIns_3(ces_1_4_io_lsbIns_3),
    .io_lsbIns_4(ces_1_4_io_lsbIns_4),
    .io_lsbIns_5(ces_1_4_io_lsbIns_5),
    .io_lsbIns_6(ces_1_4_io_lsbIns_6),
    .io_lsbIns_7(ces_1_4_io_lsbIns_7),
    .io_lsbOuts_0(ces_1_4_io_lsbOuts_0),
    .io_lsbOuts_1(ces_1_4_io_lsbOuts_1),
    .io_lsbOuts_2(ces_1_4_io_lsbOuts_2),
    .io_lsbOuts_3(ces_1_4_io_lsbOuts_3),
    .io_lsbOuts_4(ces_1_4_io_lsbOuts_4),
    .io_lsbOuts_5(ces_1_4_io_lsbOuts_5),
    .io_lsbOuts_6(ces_1_4_io_lsbOuts_6),
    .io_lsbOuts_7(ces_1_4_io_lsbOuts_7)
  );
  Element ces_1_5 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_1_5_clock),
    .io_ins_down(ces_1_5_io_ins_down),
    .io_ins_right(ces_1_5_io_ins_right),
    .io_ins_up(ces_1_5_io_ins_up),
    .io_ins_left(ces_1_5_io_ins_left),
    .io_outs_down(ces_1_5_io_outs_down),
    .io_outs_right(ces_1_5_io_outs_right),
    .io_outs_up(ces_1_5_io_outs_up),
    .io_outs_left(ces_1_5_io_outs_left),
    .io_lsbIns_1(ces_1_5_io_lsbIns_1),
    .io_lsbIns_2(ces_1_5_io_lsbIns_2),
    .io_lsbIns_3(ces_1_5_io_lsbIns_3),
    .io_lsbIns_4(ces_1_5_io_lsbIns_4),
    .io_lsbIns_5(ces_1_5_io_lsbIns_5),
    .io_lsbIns_6(ces_1_5_io_lsbIns_6),
    .io_lsbIns_7(ces_1_5_io_lsbIns_7),
    .io_lsbOuts_0(ces_1_5_io_lsbOuts_0),
    .io_lsbOuts_1(ces_1_5_io_lsbOuts_1),
    .io_lsbOuts_2(ces_1_5_io_lsbOuts_2),
    .io_lsbOuts_3(ces_1_5_io_lsbOuts_3),
    .io_lsbOuts_4(ces_1_5_io_lsbOuts_4),
    .io_lsbOuts_5(ces_1_5_io_lsbOuts_5),
    .io_lsbOuts_6(ces_1_5_io_lsbOuts_6),
    .io_lsbOuts_7(ces_1_5_io_lsbOuts_7)
  );
  Element ces_1_6 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_1_6_clock),
    .io_ins_down(ces_1_6_io_ins_down),
    .io_ins_right(ces_1_6_io_ins_right),
    .io_ins_up(ces_1_6_io_ins_up),
    .io_ins_left(ces_1_6_io_ins_left),
    .io_outs_down(ces_1_6_io_outs_down),
    .io_outs_right(ces_1_6_io_outs_right),
    .io_outs_up(ces_1_6_io_outs_up),
    .io_outs_left(ces_1_6_io_outs_left),
    .io_lsbIns_1(ces_1_6_io_lsbIns_1),
    .io_lsbIns_2(ces_1_6_io_lsbIns_2),
    .io_lsbIns_3(ces_1_6_io_lsbIns_3),
    .io_lsbIns_4(ces_1_6_io_lsbIns_4),
    .io_lsbIns_5(ces_1_6_io_lsbIns_5),
    .io_lsbIns_6(ces_1_6_io_lsbIns_6),
    .io_lsbIns_7(ces_1_6_io_lsbIns_7),
    .io_lsbOuts_0(ces_1_6_io_lsbOuts_0),
    .io_lsbOuts_1(ces_1_6_io_lsbOuts_1),
    .io_lsbOuts_2(ces_1_6_io_lsbOuts_2),
    .io_lsbOuts_3(ces_1_6_io_lsbOuts_3),
    .io_lsbOuts_4(ces_1_6_io_lsbOuts_4),
    .io_lsbOuts_5(ces_1_6_io_lsbOuts_5),
    .io_lsbOuts_6(ces_1_6_io_lsbOuts_6),
    .io_lsbOuts_7(ces_1_6_io_lsbOuts_7)
  );
  Element ces_1_7 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_1_7_clock),
    .io_ins_down(ces_1_7_io_ins_down),
    .io_ins_right(ces_1_7_io_ins_right),
    .io_ins_up(ces_1_7_io_ins_up),
    .io_ins_left(ces_1_7_io_ins_left),
    .io_outs_down(ces_1_7_io_outs_down),
    .io_outs_right(ces_1_7_io_outs_right),
    .io_outs_up(ces_1_7_io_outs_up),
    .io_outs_left(ces_1_7_io_outs_left),
    .io_lsbIns_1(ces_1_7_io_lsbIns_1),
    .io_lsbIns_2(ces_1_7_io_lsbIns_2),
    .io_lsbIns_3(ces_1_7_io_lsbIns_3),
    .io_lsbIns_4(ces_1_7_io_lsbIns_4),
    .io_lsbIns_5(ces_1_7_io_lsbIns_5),
    .io_lsbIns_6(ces_1_7_io_lsbIns_6),
    .io_lsbIns_7(ces_1_7_io_lsbIns_7),
    .io_lsbOuts_0(ces_1_7_io_lsbOuts_0),
    .io_lsbOuts_1(ces_1_7_io_lsbOuts_1),
    .io_lsbOuts_2(ces_1_7_io_lsbOuts_2),
    .io_lsbOuts_3(ces_1_7_io_lsbOuts_3),
    .io_lsbOuts_4(ces_1_7_io_lsbOuts_4),
    .io_lsbOuts_5(ces_1_7_io_lsbOuts_5),
    .io_lsbOuts_6(ces_1_7_io_lsbOuts_6),
    .io_lsbOuts_7(ces_1_7_io_lsbOuts_7)
  );
  Element ces_2_0 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_2_0_clock),
    .io_ins_down(ces_2_0_io_ins_down),
    .io_ins_right(ces_2_0_io_ins_right),
    .io_ins_up(ces_2_0_io_ins_up),
    .io_ins_left(ces_2_0_io_ins_left),
    .io_outs_down(ces_2_0_io_outs_down),
    .io_outs_right(ces_2_0_io_outs_right),
    .io_outs_up(ces_2_0_io_outs_up),
    .io_outs_left(ces_2_0_io_outs_left),
    .io_lsbIns_1(ces_2_0_io_lsbIns_1),
    .io_lsbIns_2(ces_2_0_io_lsbIns_2),
    .io_lsbIns_3(ces_2_0_io_lsbIns_3),
    .io_lsbIns_4(ces_2_0_io_lsbIns_4),
    .io_lsbIns_5(ces_2_0_io_lsbIns_5),
    .io_lsbIns_6(ces_2_0_io_lsbIns_6),
    .io_lsbIns_7(ces_2_0_io_lsbIns_7),
    .io_lsbOuts_0(ces_2_0_io_lsbOuts_0),
    .io_lsbOuts_1(ces_2_0_io_lsbOuts_1),
    .io_lsbOuts_2(ces_2_0_io_lsbOuts_2),
    .io_lsbOuts_3(ces_2_0_io_lsbOuts_3),
    .io_lsbOuts_4(ces_2_0_io_lsbOuts_4),
    .io_lsbOuts_5(ces_2_0_io_lsbOuts_5),
    .io_lsbOuts_6(ces_2_0_io_lsbOuts_6),
    .io_lsbOuts_7(ces_2_0_io_lsbOuts_7)
  );
  Element ces_2_1 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_2_1_clock),
    .io_ins_down(ces_2_1_io_ins_down),
    .io_ins_right(ces_2_1_io_ins_right),
    .io_ins_up(ces_2_1_io_ins_up),
    .io_ins_left(ces_2_1_io_ins_left),
    .io_outs_down(ces_2_1_io_outs_down),
    .io_outs_right(ces_2_1_io_outs_right),
    .io_outs_up(ces_2_1_io_outs_up),
    .io_outs_left(ces_2_1_io_outs_left),
    .io_lsbIns_1(ces_2_1_io_lsbIns_1),
    .io_lsbIns_2(ces_2_1_io_lsbIns_2),
    .io_lsbIns_3(ces_2_1_io_lsbIns_3),
    .io_lsbIns_4(ces_2_1_io_lsbIns_4),
    .io_lsbIns_5(ces_2_1_io_lsbIns_5),
    .io_lsbIns_6(ces_2_1_io_lsbIns_6),
    .io_lsbIns_7(ces_2_1_io_lsbIns_7),
    .io_lsbOuts_0(ces_2_1_io_lsbOuts_0),
    .io_lsbOuts_1(ces_2_1_io_lsbOuts_1),
    .io_lsbOuts_2(ces_2_1_io_lsbOuts_2),
    .io_lsbOuts_3(ces_2_1_io_lsbOuts_3),
    .io_lsbOuts_4(ces_2_1_io_lsbOuts_4),
    .io_lsbOuts_5(ces_2_1_io_lsbOuts_5),
    .io_lsbOuts_6(ces_2_1_io_lsbOuts_6),
    .io_lsbOuts_7(ces_2_1_io_lsbOuts_7)
  );
  Element ces_2_2 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_2_2_clock),
    .io_ins_down(ces_2_2_io_ins_down),
    .io_ins_right(ces_2_2_io_ins_right),
    .io_ins_up(ces_2_2_io_ins_up),
    .io_ins_left(ces_2_2_io_ins_left),
    .io_outs_down(ces_2_2_io_outs_down),
    .io_outs_right(ces_2_2_io_outs_right),
    .io_outs_up(ces_2_2_io_outs_up),
    .io_outs_left(ces_2_2_io_outs_left),
    .io_lsbIns_1(ces_2_2_io_lsbIns_1),
    .io_lsbIns_2(ces_2_2_io_lsbIns_2),
    .io_lsbIns_3(ces_2_2_io_lsbIns_3),
    .io_lsbIns_4(ces_2_2_io_lsbIns_4),
    .io_lsbIns_5(ces_2_2_io_lsbIns_5),
    .io_lsbIns_6(ces_2_2_io_lsbIns_6),
    .io_lsbIns_7(ces_2_2_io_lsbIns_7),
    .io_lsbOuts_0(ces_2_2_io_lsbOuts_0),
    .io_lsbOuts_1(ces_2_2_io_lsbOuts_1),
    .io_lsbOuts_2(ces_2_2_io_lsbOuts_2),
    .io_lsbOuts_3(ces_2_2_io_lsbOuts_3),
    .io_lsbOuts_4(ces_2_2_io_lsbOuts_4),
    .io_lsbOuts_5(ces_2_2_io_lsbOuts_5),
    .io_lsbOuts_6(ces_2_2_io_lsbOuts_6),
    .io_lsbOuts_7(ces_2_2_io_lsbOuts_7)
  );
  Element ces_2_3 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_2_3_clock),
    .io_ins_down(ces_2_3_io_ins_down),
    .io_ins_right(ces_2_3_io_ins_right),
    .io_ins_up(ces_2_3_io_ins_up),
    .io_ins_left(ces_2_3_io_ins_left),
    .io_outs_down(ces_2_3_io_outs_down),
    .io_outs_right(ces_2_3_io_outs_right),
    .io_outs_up(ces_2_3_io_outs_up),
    .io_outs_left(ces_2_3_io_outs_left),
    .io_lsbIns_1(ces_2_3_io_lsbIns_1),
    .io_lsbIns_2(ces_2_3_io_lsbIns_2),
    .io_lsbIns_3(ces_2_3_io_lsbIns_3),
    .io_lsbIns_4(ces_2_3_io_lsbIns_4),
    .io_lsbIns_5(ces_2_3_io_lsbIns_5),
    .io_lsbIns_6(ces_2_3_io_lsbIns_6),
    .io_lsbIns_7(ces_2_3_io_lsbIns_7),
    .io_lsbOuts_0(ces_2_3_io_lsbOuts_0),
    .io_lsbOuts_1(ces_2_3_io_lsbOuts_1),
    .io_lsbOuts_2(ces_2_3_io_lsbOuts_2),
    .io_lsbOuts_3(ces_2_3_io_lsbOuts_3),
    .io_lsbOuts_4(ces_2_3_io_lsbOuts_4),
    .io_lsbOuts_5(ces_2_3_io_lsbOuts_5),
    .io_lsbOuts_6(ces_2_3_io_lsbOuts_6),
    .io_lsbOuts_7(ces_2_3_io_lsbOuts_7)
  );
  Element ces_2_4 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_2_4_clock),
    .io_ins_down(ces_2_4_io_ins_down),
    .io_ins_right(ces_2_4_io_ins_right),
    .io_ins_up(ces_2_4_io_ins_up),
    .io_ins_left(ces_2_4_io_ins_left),
    .io_outs_down(ces_2_4_io_outs_down),
    .io_outs_right(ces_2_4_io_outs_right),
    .io_outs_up(ces_2_4_io_outs_up),
    .io_outs_left(ces_2_4_io_outs_left),
    .io_lsbIns_1(ces_2_4_io_lsbIns_1),
    .io_lsbIns_2(ces_2_4_io_lsbIns_2),
    .io_lsbIns_3(ces_2_4_io_lsbIns_3),
    .io_lsbIns_4(ces_2_4_io_lsbIns_4),
    .io_lsbIns_5(ces_2_4_io_lsbIns_5),
    .io_lsbIns_6(ces_2_4_io_lsbIns_6),
    .io_lsbIns_7(ces_2_4_io_lsbIns_7),
    .io_lsbOuts_0(ces_2_4_io_lsbOuts_0),
    .io_lsbOuts_1(ces_2_4_io_lsbOuts_1),
    .io_lsbOuts_2(ces_2_4_io_lsbOuts_2),
    .io_lsbOuts_3(ces_2_4_io_lsbOuts_3),
    .io_lsbOuts_4(ces_2_4_io_lsbOuts_4),
    .io_lsbOuts_5(ces_2_4_io_lsbOuts_5),
    .io_lsbOuts_6(ces_2_4_io_lsbOuts_6),
    .io_lsbOuts_7(ces_2_4_io_lsbOuts_7)
  );
  Element ces_2_5 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_2_5_clock),
    .io_ins_down(ces_2_5_io_ins_down),
    .io_ins_right(ces_2_5_io_ins_right),
    .io_ins_up(ces_2_5_io_ins_up),
    .io_ins_left(ces_2_5_io_ins_left),
    .io_outs_down(ces_2_5_io_outs_down),
    .io_outs_right(ces_2_5_io_outs_right),
    .io_outs_up(ces_2_5_io_outs_up),
    .io_outs_left(ces_2_5_io_outs_left),
    .io_lsbIns_1(ces_2_5_io_lsbIns_1),
    .io_lsbIns_2(ces_2_5_io_lsbIns_2),
    .io_lsbIns_3(ces_2_5_io_lsbIns_3),
    .io_lsbIns_4(ces_2_5_io_lsbIns_4),
    .io_lsbIns_5(ces_2_5_io_lsbIns_5),
    .io_lsbIns_6(ces_2_5_io_lsbIns_6),
    .io_lsbIns_7(ces_2_5_io_lsbIns_7),
    .io_lsbOuts_0(ces_2_5_io_lsbOuts_0),
    .io_lsbOuts_1(ces_2_5_io_lsbOuts_1),
    .io_lsbOuts_2(ces_2_5_io_lsbOuts_2),
    .io_lsbOuts_3(ces_2_5_io_lsbOuts_3),
    .io_lsbOuts_4(ces_2_5_io_lsbOuts_4),
    .io_lsbOuts_5(ces_2_5_io_lsbOuts_5),
    .io_lsbOuts_6(ces_2_5_io_lsbOuts_6),
    .io_lsbOuts_7(ces_2_5_io_lsbOuts_7)
  );
  Element ces_2_6 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_2_6_clock),
    .io_ins_down(ces_2_6_io_ins_down),
    .io_ins_right(ces_2_6_io_ins_right),
    .io_ins_up(ces_2_6_io_ins_up),
    .io_ins_left(ces_2_6_io_ins_left),
    .io_outs_down(ces_2_6_io_outs_down),
    .io_outs_right(ces_2_6_io_outs_right),
    .io_outs_up(ces_2_6_io_outs_up),
    .io_outs_left(ces_2_6_io_outs_left),
    .io_lsbIns_1(ces_2_6_io_lsbIns_1),
    .io_lsbIns_2(ces_2_6_io_lsbIns_2),
    .io_lsbIns_3(ces_2_6_io_lsbIns_3),
    .io_lsbIns_4(ces_2_6_io_lsbIns_4),
    .io_lsbIns_5(ces_2_6_io_lsbIns_5),
    .io_lsbIns_6(ces_2_6_io_lsbIns_6),
    .io_lsbIns_7(ces_2_6_io_lsbIns_7),
    .io_lsbOuts_0(ces_2_6_io_lsbOuts_0),
    .io_lsbOuts_1(ces_2_6_io_lsbOuts_1),
    .io_lsbOuts_2(ces_2_6_io_lsbOuts_2),
    .io_lsbOuts_3(ces_2_6_io_lsbOuts_3),
    .io_lsbOuts_4(ces_2_6_io_lsbOuts_4),
    .io_lsbOuts_5(ces_2_6_io_lsbOuts_5),
    .io_lsbOuts_6(ces_2_6_io_lsbOuts_6),
    .io_lsbOuts_7(ces_2_6_io_lsbOuts_7)
  );
  Element ces_2_7 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_2_7_clock),
    .io_ins_down(ces_2_7_io_ins_down),
    .io_ins_right(ces_2_7_io_ins_right),
    .io_ins_up(ces_2_7_io_ins_up),
    .io_ins_left(ces_2_7_io_ins_left),
    .io_outs_down(ces_2_7_io_outs_down),
    .io_outs_right(ces_2_7_io_outs_right),
    .io_outs_up(ces_2_7_io_outs_up),
    .io_outs_left(ces_2_7_io_outs_left),
    .io_lsbIns_1(ces_2_7_io_lsbIns_1),
    .io_lsbIns_2(ces_2_7_io_lsbIns_2),
    .io_lsbIns_3(ces_2_7_io_lsbIns_3),
    .io_lsbIns_4(ces_2_7_io_lsbIns_4),
    .io_lsbIns_5(ces_2_7_io_lsbIns_5),
    .io_lsbIns_6(ces_2_7_io_lsbIns_6),
    .io_lsbIns_7(ces_2_7_io_lsbIns_7),
    .io_lsbOuts_0(ces_2_7_io_lsbOuts_0),
    .io_lsbOuts_1(ces_2_7_io_lsbOuts_1),
    .io_lsbOuts_2(ces_2_7_io_lsbOuts_2),
    .io_lsbOuts_3(ces_2_7_io_lsbOuts_3),
    .io_lsbOuts_4(ces_2_7_io_lsbOuts_4),
    .io_lsbOuts_5(ces_2_7_io_lsbOuts_5),
    .io_lsbOuts_6(ces_2_7_io_lsbOuts_6),
    .io_lsbOuts_7(ces_2_7_io_lsbOuts_7)
  );
  Element ces_3_0 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_3_0_clock),
    .io_ins_down(ces_3_0_io_ins_down),
    .io_ins_right(ces_3_0_io_ins_right),
    .io_ins_up(ces_3_0_io_ins_up),
    .io_ins_left(ces_3_0_io_ins_left),
    .io_outs_down(ces_3_0_io_outs_down),
    .io_outs_right(ces_3_0_io_outs_right),
    .io_outs_up(ces_3_0_io_outs_up),
    .io_outs_left(ces_3_0_io_outs_left),
    .io_lsbIns_1(ces_3_0_io_lsbIns_1),
    .io_lsbIns_2(ces_3_0_io_lsbIns_2),
    .io_lsbIns_3(ces_3_0_io_lsbIns_3),
    .io_lsbIns_4(ces_3_0_io_lsbIns_4),
    .io_lsbIns_5(ces_3_0_io_lsbIns_5),
    .io_lsbIns_6(ces_3_0_io_lsbIns_6),
    .io_lsbIns_7(ces_3_0_io_lsbIns_7),
    .io_lsbOuts_0(ces_3_0_io_lsbOuts_0),
    .io_lsbOuts_1(ces_3_0_io_lsbOuts_1),
    .io_lsbOuts_2(ces_3_0_io_lsbOuts_2),
    .io_lsbOuts_3(ces_3_0_io_lsbOuts_3),
    .io_lsbOuts_4(ces_3_0_io_lsbOuts_4),
    .io_lsbOuts_5(ces_3_0_io_lsbOuts_5),
    .io_lsbOuts_6(ces_3_0_io_lsbOuts_6),
    .io_lsbOuts_7(ces_3_0_io_lsbOuts_7)
  );
  Element ces_3_1 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_3_1_clock),
    .io_ins_down(ces_3_1_io_ins_down),
    .io_ins_right(ces_3_1_io_ins_right),
    .io_ins_up(ces_3_1_io_ins_up),
    .io_ins_left(ces_3_1_io_ins_left),
    .io_outs_down(ces_3_1_io_outs_down),
    .io_outs_right(ces_3_1_io_outs_right),
    .io_outs_up(ces_3_1_io_outs_up),
    .io_outs_left(ces_3_1_io_outs_left),
    .io_lsbIns_1(ces_3_1_io_lsbIns_1),
    .io_lsbIns_2(ces_3_1_io_lsbIns_2),
    .io_lsbIns_3(ces_3_1_io_lsbIns_3),
    .io_lsbIns_4(ces_3_1_io_lsbIns_4),
    .io_lsbIns_5(ces_3_1_io_lsbIns_5),
    .io_lsbIns_6(ces_3_1_io_lsbIns_6),
    .io_lsbIns_7(ces_3_1_io_lsbIns_7),
    .io_lsbOuts_0(ces_3_1_io_lsbOuts_0),
    .io_lsbOuts_1(ces_3_1_io_lsbOuts_1),
    .io_lsbOuts_2(ces_3_1_io_lsbOuts_2),
    .io_lsbOuts_3(ces_3_1_io_lsbOuts_3),
    .io_lsbOuts_4(ces_3_1_io_lsbOuts_4),
    .io_lsbOuts_5(ces_3_1_io_lsbOuts_5),
    .io_lsbOuts_6(ces_3_1_io_lsbOuts_6),
    .io_lsbOuts_7(ces_3_1_io_lsbOuts_7)
  );
  Element ces_3_2 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_3_2_clock),
    .io_ins_down(ces_3_2_io_ins_down),
    .io_ins_right(ces_3_2_io_ins_right),
    .io_ins_up(ces_3_2_io_ins_up),
    .io_ins_left(ces_3_2_io_ins_left),
    .io_outs_down(ces_3_2_io_outs_down),
    .io_outs_right(ces_3_2_io_outs_right),
    .io_outs_up(ces_3_2_io_outs_up),
    .io_outs_left(ces_3_2_io_outs_left),
    .io_lsbIns_1(ces_3_2_io_lsbIns_1),
    .io_lsbIns_2(ces_3_2_io_lsbIns_2),
    .io_lsbIns_3(ces_3_2_io_lsbIns_3),
    .io_lsbIns_4(ces_3_2_io_lsbIns_4),
    .io_lsbIns_5(ces_3_2_io_lsbIns_5),
    .io_lsbIns_6(ces_3_2_io_lsbIns_6),
    .io_lsbIns_7(ces_3_2_io_lsbIns_7),
    .io_lsbOuts_0(ces_3_2_io_lsbOuts_0),
    .io_lsbOuts_1(ces_3_2_io_lsbOuts_1),
    .io_lsbOuts_2(ces_3_2_io_lsbOuts_2),
    .io_lsbOuts_3(ces_3_2_io_lsbOuts_3),
    .io_lsbOuts_4(ces_3_2_io_lsbOuts_4),
    .io_lsbOuts_5(ces_3_2_io_lsbOuts_5),
    .io_lsbOuts_6(ces_3_2_io_lsbOuts_6),
    .io_lsbOuts_7(ces_3_2_io_lsbOuts_7)
  );
  Element ces_3_3 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_3_3_clock),
    .io_ins_down(ces_3_3_io_ins_down),
    .io_ins_right(ces_3_3_io_ins_right),
    .io_ins_up(ces_3_3_io_ins_up),
    .io_ins_left(ces_3_3_io_ins_left),
    .io_outs_down(ces_3_3_io_outs_down),
    .io_outs_right(ces_3_3_io_outs_right),
    .io_outs_up(ces_3_3_io_outs_up),
    .io_outs_left(ces_3_3_io_outs_left),
    .io_lsbIns_1(ces_3_3_io_lsbIns_1),
    .io_lsbIns_2(ces_3_3_io_lsbIns_2),
    .io_lsbIns_3(ces_3_3_io_lsbIns_3),
    .io_lsbIns_4(ces_3_3_io_lsbIns_4),
    .io_lsbIns_5(ces_3_3_io_lsbIns_5),
    .io_lsbIns_6(ces_3_3_io_lsbIns_6),
    .io_lsbIns_7(ces_3_3_io_lsbIns_7),
    .io_lsbOuts_0(ces_3_3_io_lsbOuts_0),
    .io_lsbOuts_1(ces_3_3_io_lsbOuts_1),
    .io_lsbOuts_2(ces_3_3_io_lsbOuts_2),
    .io_lsbOuts_3(ces_3_3_io_lsbOuts_3),
    .io_lsbOuts_4(ces_3_3_io_lsbOuts_4),
    .io_lsbOuts_5(ces_3_3_io_lsbOuts_5),
    .io_lsbOuts_6(ces_3_3_io_lsbOuts_6),
    .io_lsbOuts_7(ces_3_3_io_lsbOuts_7)
  );
  Element ces_3_4 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_3_4_clock),
    .io_ins_down(ces_3_4_io_ins_down),
    .io_ins_right(ces_3_4_io_ins_right),
    .io_ins_up(ces_3_4_io_ins_up),
    .io_ins_left(ces_3_4_io_ins_left),
    .io_outs_down(ces_3_4_io_outs_down),
    .io_outs_right(ces_3_4_io_outs_right),
    .io_outs_up(ces_3_4_io_outs_up),
    .io_outs_left(ces_3_4_io_outs_left),
    .io_lsbIns_1(ces_3_4_io_lsbIns_1),
    .io_lsbIns_2(ces_3_4_io_lsbIns_2),
    .io_lsbIns_3(ces_3_4_io_lsbIns_3),
    .io_lsbIns_4(ces_3_4_io_lsbIns_4),
    .io_lsbIns_5(ces_3_4_io_lsbIns_5),
    .io_lsbIns_6(ces_3_4_io_lsbIns_6),
    .io_lsbIns_7(ces_3_4_io_lsbIns_7),
    .io_lsbOuts_0(ces_3_4_io_lsbOuts_0),
    .io_lsbOuts_1(ces_3_4_io_lsbOuts_1),
    .io_lsbOuts_2(ces_3_4_io_lsbOuts_2),
    .io_lsbOuts_3(ces_3_4_io_lsbOuts_3),
    .io_lsbOuts_4(ces_3_4_io_lsbOuts_4),
    .io_lsbOuts_5(ces_3_4_io_lsbOuts_5),
    .io_lsbOuts_6(ces_3_4_io_lsbOuts_6),
    .io_lsbOuts_7(ces_3_4_io_lsbOuts_7)
  );
  Element ces_3_5 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_3_5_clock),
    .io_ins_down(ces_3_5_io_ins_down),
    .io_ins_right(ces_3_5_io_ins_right),
    .io_ins_up(ces_3_5_io_ins_up),
    .io_ins_left(ces_3_5_io_ins_left),
    .io_outs_down(ces_3_5_io_outs_down),
    .io_outs_right(ces_3_5_io_outs_right),
    .io_outs_up(ces_3_5_io_outs_up),
    .io_outs_left(ces_3_5_io_outs_left),
    .io_lsbIns_1(ces_3_5_io_lsbIns_1),
    .io_lsbIns_2(ces_3_5_io_lsbIns_2),
    .io_lsbIns_3(ces_3_5_io_lsbIns_3),
    .io_lsbIns_4(ces_3_5_io_lsbIns_4),
    .io_lsbIns_5(ces_3_5_io_lsbIns_5),
    .io_lsbIns_6(ces_3_5_io_lsbIns_6),
    .io_lsbIns_7(ces_3_5_io_lsbIns_7),
    .io_lsbOuts_0(ces_3_5_io_lsbOuts_0),
    .io_lsbOuts_1(ces_3_5_io_lsbOuts_1),
    .io_lsbOuts_2(ces_3_5_io_lsbOuts_2),
    .io_lsbOuts_3(ces_3_5_io_lsbOuts_3),
    .io_lsbOuts_4(ces_3_5_io_lsbOuts_4),
    .io_lsbOuts_5(ces_3_5_io_lsbOuts_5),
    .io_lsbOuts_6(ces_3_5_io_lsbOuts_6),
    .io_lsbOuts_7(ces_3_5_io_lsbOuts_7)
  );
  Element ces_3_6 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_3_6_clock),
    .io_ins_down(ces_3_6_io_ins_down),
    .io_ins_right(ces_3_6_io_ins_right),
    .io_ins_up(ces_3_6_io_ins_up),
    .io_ins_left(ces_3_6_io_ins_left),
    .io_outs_down(ces_3_6_io_outs_down),
    .io_outs_right(ces_3_6_io_outs_right),
    .io_outs_up(ces_3_6_io_outs_up),
    .io_outs_left(ces_3_6_io_outs_left),
    .io_lsbIns_1(ces_3_6_io_lsbIns_1),
    .io_lsbIns_2(ces_3_6_io_lsbIns_2),
    .io_lsbIns_3(ces_3_6_io_lsbIns_3),
    .io_lsbIns_4(ces_3_6_io_lsbIns_4),
    .io_lsbIns_5(ces_3_6_io_lsbIns_5),
    .io_lsbIns_6(ces_3_6_io_lsbIns_6),
    .io_lsbIns_7(ces_3_6_io_lsbIns_7),
    .io_lsbOuts_0(ces_3_6_io_lsbOuts_0),
    .io_lsbOuts_1(ces_3_6_io_lsbOuts_1),
    .io_lsbOuts_2(ces_3_6_io_lsbOuts_2),
    .io_lsbOuts_3(ces_3_6_io_lsbOuts_3),
    .io_lsbOuts_4(ces_3_6_io_lsbOuts_4),
    .io_lsbOuts_5(ces_3_6_io_lsbOuts_5),
    .io_lsbOuts_6(ces_3_6_io_lsbOuts_6),
    .io_lsbOuts_7(ces_3_6_io_lsbOuts_7)
  );
  Element ces_3_7 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_3_7_clock),
    .io_ins_down(ces_3_7_io_ins_down),
    .io_ins_right(ces_3_7_io_ins_right),
    .io_ins_up(ces_3_7_io_ins_up),
    .io_ins_left(ces_3_7_io_ins_left),
    .io_outs_down(ces_3_7_io_outs_down),
    .io_outs_right(ces_3_7_io_outs_right),
    .io_outs_up(ces_3_7_io_outs_up),
    .io_outs_left(ces_3_7_io_outs_left),
    .io_lsbIns_1(ces_3_7_io_lsbIns_1),
    .io_lsbIns_2(ces_3_7_io_lsbIns_2),
    .io_lsbIns_3(ces_3_7_io_lsbIns_3),
    .io_lsbIns_4(ces_3_7_io_lsbIns_4),
    .io_lsbIns_5(ces_3_7_io_lsbIns_5),
    .io_lsbIns_6(ces_3_7_io_lsbIns_6),
    .io_lsbIns_7(ces_3_7_io_lsbIns_7),
    .io_lsbOuts_0(ces_3_7_io_lsbOuts_0),
    .io_lsbOuts_1(ces_3_7_io_lsbOuts_1),
    .io_lsbOuts_2(ces_3_7_io_lsbOuts_2),
    .io_lsbOuts_3(ces_3_7_io_lsbOuts_3),
    .io_lsbOuts_4(ces_3_7_io_lsbOuts_4),
    .io_lsbOuts_5(ces_3_7_io_lsbOuts_5),
    .io_lsbOuts_6(ces_3_7_io_lsbOuts_6),
    .io_lsbOuts_7(ces_3_7_io_lsbOuts_7)
  );
  Element ces_4_0 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_4_0_clock),
    .io_ins_down(ces_4_0_io_ins_down),
    .io_ins_right(ces_4_0_io_ins_right),
    .io_ins_up(ces_4_0_io_ins_up),
    .io_ins_left(ces_4_0_io_ins_left),
    .io_outs_down(ces_4_0_io_outs_down),
    .io_outs_right(ces_4_0_io_outs_right),
    .io_outs_up(ces_4_0_io_outs_up),
    .io_outs_left(ces_4_0_io_outs_left),
    .io_lsbIns_1(ces_4_0_io_lsbIns_1),
    .io_lsbIns_2(ces_4_0_io_lsbIns_2),
    .io_lsbIns_3(ces_4_0_io_lsbIns_3),
    .io_lsbIns_4(ces_4_0_io_lsbIns_4),
    .io_lsbIns_5(ces_4_0_io_lsbIns_5),
    .io_lsbIns_6(ces_4_0_io_lsbIns_6),
    .io_lsbIns_7(ces_4_0_io_lsbIns_7),
    .io_lsbOuts_0(ces_4_0_io_lsbOuts_0),
    .io_lsbOuts_1(ces_4_0_io_lsbOuts_1),
    .io_lsbOuts_2(ces_4_0_io_lsbOuts_2),
    .io_lsbOuts_3(ces_4_0_io_lsbOuts_3),
    .io_lsbOuts_4(ces_4_0_io_lsbOuts_4),
    .io_lsbOuts_5(ces_4_0_io_lsbOuts_5),
    .io_lsbOuts_6(ces_4_0_io_lsbOuts_6),
    .io_lsbOuts_7(ces_4_0_io_lsbOuts_7)
  );
  Element ces_4_1 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_4_1_clock),
    .io_ins_down(ces_4_1_io_ins_down),
    .io_ins_right(ces_4_1_io_ins_right),
    .io_ins_up(ces_4_1_io_ins_up),
    .io_ins_left(ces_4_1_io_ins_left),
    .io_outs_down(ces_4_1_io_outs_down),
    .io_outs_right(ces_4_1_io_outs_right),
    .io_outs_up(ces_4_1_io_outs_up),
    .io_outs_left(ces_4_1_io_outs_left),
    .io_lsbIns_1(ces_4_1_io_lsbIns_1),
    .io_lsbIns_2(ces_4_1_io_lsbIns_2),
    .io_lsbIns_3(ces_4_1_io_lsbIns_3),
    .io_lsbIns_4(ces_4_1_io_lsbIns_4),
    .io_lsbIns_5(ces_4_1_io_lsbIns_5),
    .io_lsbIns_6(ces_4_1_io_lsbIns_6),
    .io_lsbIns_7(ces_4_1_io_lsbIns_7),
    .io_lsbOuts_0(ces_4_1_io_lsbOuts_0),
    .io_lsbOuts_1(ces_4_1_io_lsbOuts_1),
    .io_lsbOuts_2(ces_4_1_io_lsbOuts_2),
    .io_lsbOuts_3(ces_4_1_io_lsbOuts_3),
    .io_lsbOuts_4(ces_4_1_io_lsbOuts_4),
    .io_lsbOuts_5(ces_4_1_io_lsbOuts_5),
    .io_lsbOuts_6(ces_4_1_io_lsbOuts_6),
    .io_lsbOuts_7(ces_4_1_io_lsbOuts_7)
  );
  Element ces_4_2 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_4_2_clock),
    .io_ins_down(ces_4_2_io_ins_down),
    .io_ins_right(ces_4_2_io_ins_right),
    .io_ins_up(ces_4_2_io_ins_up),
    .io_ins_left(ces_4_2_io_ins_left),
    .io_outs_down(ces_4_2_io_outs_down),
    .io_outs_right(ces_4_2_io_outs_right),
    .io_outs_up(ces_4_2_io_outs_up),
    .io_outs_left(ces_4_2_io_outs_left),
    .io_lsbIns_1(ces_4_2_io_lsbIns_1),
    .io_lsbIns_2(ces_4_2_io_lsbIns_2),
    .io_lsbIns_3(ces_4_2_io_lsbIns_3),
    .io_lsbIns_4(ces_4_2_io_lsbIns_4),
    .io_lsbIns_5(ces_4_2_io_lsbIns_5),
    .io_lsbIns_6(ces_4_2_io_lsbIns_6),
    .io_lsbIns_7(ces_4_2_io_lsbIns_7),
    .io_lsbOuts_0(ces_4_2_io_lsbOuts_0),
    .io_lsbOuts_1(ces_4_2_io_lsbOuts_1),
    .io_lsbOuts_2(ces_4_2_io_lsbOuts_2),
    .io_lsbOuts_3(ces_4_2_io_lsbOuts_3),
    .io_lsbOuts_4(ces_4_2_io_lsbOuts_4),
    .io_lsbOuts_5(ces_4_2_io_lsbOuts_5),
    .io_lsbOuts_6(ces_4_2_io_lsbOuts_6),
    .io_lsbOuts_7(ces_4_2_io_lsbOuts_7)
  );
  Element ces_4_3 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_4_3_clock),
    .io_ins_down(ces_4_3_io_ins_down),
    .io_ins_right(ces_4_3_io_ins_right),
    .io_ins_up(ces_4_3_io_ins_up),
    .io_ins_left(ces_4_3_io_ins_left),
    .io_outs_down(ces_4_3_io_outs_down),
    .io_outs_right(ces_4_3_io_outs_right),
    .io_outs_up(ces_4_3_io_outs_up),
    .io_outs_left(ces_4_3_io_outs_left),
    .io_lsbIns_1(ces_4_3_io_lsbIns_1),
    .io_lsbIns_2(ces_4_3_io_lsbIns_2),
    .io_lsbIns_3(ces_4_3_io_lsbIns_3),
    .io_lsbIns_4(ces_4_3_io_lsbIns_4),
    .io_lsbIns_5(ces_4_3_io_lsbIns_5),
    .io_lsbIns_6(ces_4_3_io_lsbIns_6),
    .io_lsbIns_7(ces_4_3_io_lsbIns_7),
    .io_lsbOuts_0(ces_4_3_io_lsbOuts_0),
    .io_lsbOuts_1(ces_4_3_io_lsbOuts_1),
    .io_lsbOuts_2(ces_4_3_io_lsbOuts_2),
    .io_lsbOuts_3(ces_4_3_io_lsbOuts_3),
    .io_lsbOuts_4(ces_4_3_io_lsbOuts_4),
    .io_lsbOuts_5(ces_4_3_io_lsbOuts_5),
    .io_lsbOuts_6(ces_4_3_io_lsbOuts_6),
    .io_lsbOuts_7(ces_4_3_io_lsbOuts_7)
  );
  Element ces_4_4 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_4_4_clock),
    .io_ins_down(ces_4_4_io_ins_down),
    .io_ins_right(ces_4_4_io_ins_right),
    .io_ins_up(ces_4_4_io_ins_up),
    .io_ins_left(ces_4_4_io_ins_left),
    .io_outs_down(ces_4_4_io_outs_down),
    .io_outs_right(ces_4_4_io_outs_right),
    .io_outs_up(ces_4_4_io_outs_up),
    .io_outs_left(ces_4_4_io_outs_left),
    .io_lsbIns_1(ces_4_4_io_lsbIns_1),
    .io_lsbIns_2(ces_4_4_io_lsbIns_2),
    .io_lsbIns_3(ces_4_4_io_lsbIns_3),
    .io_lsbIns_4(ces_4_4_io_lsbIns_4),
    .io_lsbIns_5(ces_4_4_io_lsbIns_5),
    .io_lsbIns_6(ces_4_4_io_lsbIns_6),
    .io_lsbIns_7(ces_4_4_io_lsbIns_7),
    .io_lsbOuts_0(ces_4_4_io_lsbOuts_0),
    .io_lsbOuts_1(ces_4_4_io_lsbOuts_1),
    .io_lsbOuts_2(ces_4_4_io_lsbOuts_2),
    .io_lsbOuts_3(ces_4_4_io_lsbOuts_3),
    .io_lsbOuts_4(ces_4_4_io_lsbOuts_4),
    .io_lsbOuts_5(ces_4_4_io_lsbOuts_5),
    .io_lsbOuts_6(ces_4_4_io_lsbOuts_6),
    .io_lsbOuts_7(ces_4_4_io_lsbOuts_7)
  );
  Element ces_4_5 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_4_5_clock),
    .io_ins_down(ces_4_5_io_ins_down),
    .io_ins_right(ces_4_5_io_ins_right),
    .io_ins_up(ces_4_5_io_ins_up),
    .io_ins_left(ces_4_5_io_ins_left),
    .io_outs_down(ces_4_5_io_outs_down),
    .io_outs_right(ces_4_5_io_outs_right),
    .io_outs_up(ces_4_5_io_outs_up),
    .io_outs_left(ces_4_5_io_outs_left),
    .io_lsbIns_1(ces_4_5_io_lsbIns_1),
    .io_lsbIns_2(ces_4_5_io_lsbIns_2),
    .io_lsbIns_3(ces_4_5_io_lsbIns_3),
    .io_lsbIns_4(ces_4_5_io_lsbIns_4),
    .io_lsbIns_5(ces_4_5_io_lsbIns_5),
    .io_lsbIns_6(ces_4_5_io_lsbIns_6),
    .io_lsbIns_7(ces_4_5_io_lsbIns_7),
    .io_lsbOuts_0(ces_4_5_io_lsbOuts_0),
    .io_lsbOuts_1(ces_4_5_io_lsbOuts_1),
    .io_lsbOuts_2(ces_4_5_io_lsbOuts_2),
    .io_lsbOuts_3(ces_4_5_io_lsbOuts_3),
    .io_lsbOuts_4(ces_4_5_io_lsbOuts_4),
    .io_lsbOuts_5(ces_4_5_io_lsbOuts_5),
    .io_lsbOuts_6(ces_4_5_io_lsbOuts_6),
    .io_lsbOuts_7(ces_4_5_io_lsbOuts_7)
  );
  Element ces_4_6 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_4_6_clock),
    .io_ins_down(ces_4_6_io_ins_down),
    .io_ins_right(ces_4_6_io_ins_right),
    .io_ins_up(ces_4_6_io_ins_up),
    .io_ins_left(ces_4_6_io_ins_left),
    .io_outs_down(ces_4_6_io_outs_down),
    .io_outs_right(ces_4_6_io_outs_right),
    .io_outs_up(ces_4_6_io_outs_up),
    .io_outs_left(ces_4_6_io_outs_left),
    .io_lsbIns_1(ces_4_6_io_lsbIns_1),
    .io_lsbIns_2(ces_4_6_io_lsbIns_2),
    .io_lsbIns_3(ces_4_6_io_lsbIns_3),
    .io_lsbIns_4(ces_4_6_io_lsbIns_4),
    .io_lsbIns_5(ces_4_6_io_lsbIns_5),
    .io_lsbIns_6(ces_4_6_io_lsbIns_6),
    .io_lsbIns_7(ces_4_6_io_lsbIns_7),
    .io_lsbOuts_0(ces_4_6_io_lsbOuts_0),
    .io_lsbOuts_1(ces_4_6_io_lsbOuts_1),
    .io_lsbOuts_2(ces_4_6_io_lsbOuts_2),
    .io_lsbOuts_3(ces_4_6_io_lsbOuts_3),
    .io_lsbOuts_4(ces_4_6_io_lsbOuts_4),
    .io_lsbOuts_5(ces_4_6_io_lsbOuts_5),
    .io_lsbOuts_6(ces_4_6_io_lsbOuts_6),
    .io_lsbOuts_7(ces_4_6_io_lsbOuts_7)
  );
  Element ces_4_7 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_4_7_clock),
    .io_ins_down(ces_4_7_io_ins_down),
    .io_ins_right(ces_4_7_io_ins_right),
    .io_ins_up(ces_4_7_io_ins_up),
    .io_ins_left(ces_4_7_io_ins_left),
    .io_outs_down(ces_4_7_io_outs_down),
    .io_outs_right(ces_4_7_io_outs_right),
    .io_outs_up(ces_4_7_io_outs_up),
    .io_outs_left(ces_4_7_io_outs_left),
    .io_lsbIns_1(ces_4_7_io_lsbIns_1),
    .io_lsbIns_2(ces_4_7_io_lsbIns_2),
    .io_lsbIns_3(ces_4_7_io_lsbIns_3),
    .io_lsbIns_4(ces_4_7_io_lsbIns_4),
    .io_lsbIns_5(ces_4_7_io_lsbIns_5),
    .io_lsbIns_6(ces_4_7_io_lsbIns_6),
    .io_lsbIns_7(ces_4_7_io_lsbIns_7),
    .io_lsbOuts_0(ces_4_7_io_lsbOuts_0),
    .io_lsbOuts_1(ces_4_7_io_lsbOuts_1),
    .io_lsbOuts_2(ces_4_7_io_lsbOuts_2),
    .io_lsbOuts_3(ces_4_7_io_lsbOuts_3),
    .io_lsbOuts_4(ces_4_7_io_lsbOuts_4),
    .io_lsbOuts_5(ces_4_7_io_lsbOuts_5),
    .io_lsbOuts_6(ces_4_7_io_lsbOuts_6),
    .io_lsbOuts_7(ces_4_7_io_lsbOuts_7)
  );
  Element ces_5_0 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_5_0_clock),
    .io_ins_down(ces_5_0_io_ins_down),
    .io_ins_right(ces_5_0_io_ins_right),
    .io_ins_up(ces_5_0_io_ins_up),
    .io_ins_left(ces_5_0_io_ins_left),
    .io_outs_down(ces_5_0_io_outs_down),
    .io_outs_right(ces_5_0_io_outs_right),
    .io_outs_up(ces_5_0_io_outs_up),
    .io_outs_left(ces_5_0_io_outs_left),
    .io_lsbIns_1(ces_5_0_io_lsbIns_1),
    .io_lsbIns_2(ces_5_0_io_lsbIns_2),
    .io_lsbIns_3(ces_5_0_io_lsbIns_3),
    .io_lsbIns_4(ces_5_0_io_lsbIns_4),
    .io_lsbIns_5(ces_5_0_io_lsbIns_5),
    .io_lsbIns_6(ces_5_0_io_lsbIns_6),
    .io_lsbIns_7(ces_5_0_io_lsbIns_7),
    .io_lsbOuts_0(ces_5_0_io_lsbOuts_0),
    .io_lsbOuts_1(ces_5_0_io_lsbOuts_1),
    .io_lsbOuts_2(ces_5_0_io_lsbOuts_2),
    .io_lsbOuts_3(ces_5_0_io_lsbOuts_3),
    .io_lsbOuts_4(ces_5_0_io_lsbOuts_4),
    .io_lsbOuts_5(ces_5_0_io_lsbOuts_5),
    .io_lsbOuts_6(ces_5_0_io_lsbOuts_6),
    .io_lsbOuts_7(ces_5_0_io_lsbOuts_7)
  );
  Element ces_5_1 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_5_1_clock),
    .io_ins_down(ces_5_1_io_ins_down),
    .io_ins_right(ces_5_1_io_ins_right),
    .io_ins_up(ces_5_1_io_ins_up),
    .io_ins_left(ces_5_1_io_ins_left),
    .io_outs_down(ces_5_1_io_outs_down),
    .io_outs_right(ces_5_1_io_outs_right),
    .io_outs_up(ces_5_1_io_outs_up),
    .io_outs_left(ces_5_1_io_outs_left),
    .io_lsbIns_1(ces_5_1_io_lsbIns_1),
    .io_lsbIns_2(ces_5_1_io_lsbIns_2),
    .io_lsbIns_3(ces_5_1_io_lsbIns_3),
    .io_lsbIns_4(ces_5_1_io_lsbIns_4),
    .io_lsbIns_5(ces_5_1_io_lsbIns_5),
    .io_lsbIns_6(ces_5_1_io_lsbIns_6),
    .io_lsbIns_7(ces_5_1_io_lsbIns_7),
    .io_lsbOuts_0(ces_5_1_io_lsbOuts_0),
    .io_lsbOuts_1(ces_5_1_io_lsbOuts_1),
    .io_lsbOuts_2(ces_5_1_io_lsbOuts_2),
    .io_lsbOuts_3(ces_5_1_io_lsbOuts_3),
    .io_lsbOuts_4(ces_5_1_io_lsbOuts_4),
    .io_lsbOuts_5(ces_5_1_io_lsbOuts_5),
    .io_lsbOuts_6(ces_5_1_io_lsbOuts_6),
    .io_lsbOuts_7(ces_5_1_io_lsbOuts_7)
  );
  Element ces_5_2 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_5_2_clock),
    .io_ins_down(ces_5_2_io_ins_down),
    .io_ins_right(ces_5_2_io_ins_right),
    .io_ins_up(ces_5_2_io_ins_up),
    .io_ins_left(ces_5_2_io_ins_left),
    .io_outs_down(ces_5_2_io_outs_down),
    .io_outs_right(ces_5_2_io_outs_right),
    .io_outs_up(ces_5_2_io_outs_up),
    .io_outs_left(ces_5_2_io_outs_left),
    .io_lsbIns_1(ces_5_2_io_lsbIns_1),
    .io_lsbIns_2(ces_5_2_io_lsbIns_2),
    .io_lsbIns_3(ces_5_2_io_lsbIns_3),
    .io_lsbIns_4(ces_5_2_io_lsbIns_4),
    .io_lsbIns_5(ces_5_2_io_lsbIns_5),
    .io_lsbIns_6(ces_5_2_io_lsbIns_6),
    .io_lsbIns_7(ces_5_2_io_lsbIns_7),
    .io_lsbOuts_0(ces_5_2_io_lsbOuts_0),
    .io_lsbOuts_1(ces_5_2_io_lsbOuts_1),
    .io_lsbOuts_2(ces_5_2_io_lsbOuts_2),
    .io_lsbOuts_3(ces_5_2_io_lsbOuts_3),
    .io_lsbOuts_4(ces_5_2_io_lsbOuts_4),
    .io_lsbOuts_5(ces_5_2_io_lsbOuts_5),
    .io_lsbOuts_6(ces_5_2_io_lsbOuts_6),
    .io_lsbOuts_7(ces_5_2_io_lsbOuts_7)
  );
  Element ces_5_3 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_5_3_clock),
    .io_ins_down(ces_5_3_io_ins_down),
    .io_ins_right(ces_5_3_io_ins_right),
    .io_ins_up(ces_5_3_io_ins_up),
    .io_ins_left(ces_5_3_io_ins_left),
    .io_outs_down(ces_5_3_io_outs_down),
    .io_outs_right(ces_5_3_io_outs_right),
    .io_outs_up(ces_5_3_io_outs_up),
    .io_outs_left(ces_5_3_io_outs_left),
    .io_lsbIns_1(ces_5_3_io_lsbIns_1),
    .io_lsbIns_2(ces_5_3_io_lsbIns_2),
    .io_lsbIns_3(ces_5_3_io_lsbIns_3),
    .io_lsbIns_4(ces_5_3_io_lsbIns_4),
    .io_lsbIns_5(ces_5_3_io_lsbIns_5),
    .io_lsbIns_6(ces_5_3_io_lsbIns_6),
    .io_lsbIns_7(ces_5_3_io_lsbIns_7),
    .io_lsbOuts_0(ces_5_3_io_lsbOuts_0),
    .io_lsbOuts_1(ces_5_3_io_lsbOuts_1),
    .io_lsbOuts_2(ces_5_3_io_lsbOuts_2),
    .io_lsbOuts_3(ces_5_3_io_lsbOuts_3),
    .io_lsbOuts_4(ces_5_3_io_lsbOuts_4),
    .io_lsbOuts_5(ces_5_3_io_lsbOuts_5),
    .io_lsbOuts_6(ces_5_3_io_lsbOuts_6),
    .io_lsbOuts_7(ces_5_3_io_lsbOuts_7)
  );
  Element ces_5_4 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_5_4_clock),
    .io_ins_down(ces_5_4_io_ins_down),
    .io_ins_right(ces_5_4_io_ins_right),
    .io_ins_up(ces_5_4_io_ins_up),
    .io_ins_left(ces_5_4_io_ins_left),
    .io_outs_down(ces_5_4_io_outs_down),
    .io_outs_right(ces_5_4_io_outs_right),
    .io_outs_up(ces_5_4_io_outs_up),
    .io_outs_left(ces_5_4_io_outs_left),
    .io_lsbIns_1(ces_5_4_io_lsbIns_1),
    .io_lsbIns_2(ces_5_4_io_lsbIns_2),
    .io_lsbIns_3(ces_5_4_io_lsbIns_3),
    .io_lsbIns_4(ces_5_4_io_lsbIns_4),
    .io_lsbIns_5(ces_5_4_io_lsbIns_5),
    .io_lsbIns_6(ces_5_4_io_lsbIns_6),
    .io_lsbIns_7(ces_5_4_io_lsbIns_7),
    .io_lsbOuts_0(ces_5_4_io_lsbOuts_0),
    .io_lsbOuts_1(ces_5_4_io_lsbOuts_1),
    .io_lsbOuts_2(ces_5_4_io_lsbOuts_2),
    .io_lsbOuts_3(ces_5_4_io_lsbOuts_3),
    .io_lsbOuts_4(ces_5_4_io_lsbOuts_4),
    .io_lsbOuts_5(ces_5_4_io_lsbOuts_5),
    .io_lsbOuts_6(ces_5_4_io_lsbOuts_6),
    .io_lsbOuts_7(ces_5_4_io_lsbOuts_7)
  );
  Element ces_5_5 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_5_5_clock),
    .io_ins_down(ces_5_5_io_ins_down),
    .io_ins_right(ces_5_5_io_ins_right),
    .io_ins_up(ces_5_5_io_ins_up),
    .io_ins_left(ces_5_5_io_ins_left),
    .io_outs_down(ces_5_5_io_outs_down),
    .io_outs_right(ces_5_5_io_outs_right),
    .io_outs_up(ces_5_5_io_outs_up),
    .io_outs_left(ces_5_5_io_outs_left),
    .io_lsbIns_1(ces_5_5_io_lsbIns_1),
    .io_lsbIns_2(ces_5_5_io_lsbIns_2),
    .io_lsbIns_3(ces_5_5_io_lsbIns_3),
    .io_lsbIns_4(ces_5_5_io_lsbIns_4),
    .io_lsbIns_5(ces_5_5_io_lsbIns_5),
    .io_lsbIns_6(ces_5_5_io_lsbIns_6),
    .io_lsbIns_7(ces_5_5_io_lsbIns_7),
    .io_lsbOuts_0(ces_5_5_io_lsbOuts_0),
    .io_lsbOuts_1(ces_5_5_io_lsbOuts_1),
    .io_lsbOuts_2(ces_5_5_io_lsbOuts_2),
    .io_lsbOuts_3(ces_5_5_io_lsbOuts_3),
    .io_lsbOuts_4(ces_5_5_io_lsbOuts_4),
    .io_lsbOuts_5(ces_5_5_io_lsbOuts_5),
    .io_lsbOuts_6(ces_5_5_io_lsbOuts_6),
    .io_lsbOuts_7(ces_5_5_io_lsbOuts_7)
  );
  Element ces_5_6 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_5_6_clock),
    .io_ins_down(ces_5_6_io_ins_down),
    .io_ins_right(ces_5_6_io_ins_right),
    .io_ins_up(ces_5_6_io_ins_up),
    .io_ins_left(ces_5_6_io_ins_left),
    .io_outs_down(ces_5_6_io_outs_down),
    .io_outs_right(ces_5_6_io_outs_right),
    .io_outs_up(ces_5_6_io_outs_up),
    .io_outs_left(ces_5_6_io_outs_left),
    .io_lsbIns_1(ces_5_6_io_lsbIns_1),
    .io_lsbIns_2(ces_5_6_io_lsbIns_2),
    .io_lsbIns_3(ces_5_6_io_lsbIns_3),
    .io_lsbIns_4(ces_5_6_io_lsbIns_4),
    .io_lsbIns_5(ces_5_6_io_lsbIns_5),
    .io_lsbIns_6(ces_5_6_io_lsbIns_6),
    .io_lsbIns_7(ces_5_6_io_lsbIns_7),
    .io_lsbOuts_0(ces_5_6_io_lsbOuts_0),
    .io_lsbOuts_1(ces_5_6_io_lsbOuts_1),
    .io_lsbOuts_2(ces_5_6_io_lsbOuts_2),
    .io_lsbOuts_3(ces_5_6_io_lsbOuts_3),
    .io_lsbOuts_4(ces_5_6_io_lsbOuts_4),
    .io_lsbOuts_5(ces_5_6_io_lsbOuts_5),
    .io_lsbOuts_6(ces_5_6_io_lsbOuts_6),
    .io_lsbOuts_7(ces_5_6_io_lsbOuts_7)
  );
  Element ces_5_7 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_5_7_clock),
    .io_ins_down(ces_5_7_io_ins_down),
    .io_ins_right(ces_5_7_io_ins_right),
    .io_ins_up(ces_5_7_io_ins_up),
    .io_ins_left(ces_5_7_io_ins_left),
    .io_outs_down(ces_5_7_io_outs_down),
    .io_outs_right(ces_5_7_io_outs_right),
    .io_outs_up(ces_5_7_io_outs_up),
    .io_outs_left(ces_5_7_io_outs_left),
    .io_lsbIns_1(ces_5_7_io_lsbIns_1),
    .io_lsbIns_2(ces_5_7_io_lsbIns_2),
    .io_lsbIns_3(ces_5_7_io_lsbIns_3),
    .io_lsbIns_4(ces_5_7_io_lsbIns_4),
    .io_lsbIns_5(ces_5_7_io_lsbIns_5),
    .io_lsbIns_6(ces_5_7_io_lsbIns_6),
    .io_lsbIns_7(ces_5_7_io_lsbIns_7),
    .io_lsbOuts_0(ces_5_7_io_lsbOuts_0),
    .io_lsbOuts_1(ces_5_7_io_lsbOuts_1),
    .io_lsbOuts_2(ces_5_7_io_lsbOuts_2),
    .io_lsbOuts_3(ces_5_7_io_lsbOuts_3),
    .io_lsbOuts_4(ces_5_7_io_lsbOuts_4),
    .io_lsbOuts_5(ces_5_7_io_lsbOuts_5),
    .io_lsbOuts_6(ces_5_7_io_lsbOuts_6),
    .io_lsbOuts_7(ces_5_7_io_lsbOuts_7)
  );
  Element ces_6_0 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_6_0_clock),
    .io_ins_down(ces_6_0_io_ins_down),
    .io_ins_right(ces_6_0_io_ins_right),
    .io_ins_up(ces_6_0_io_ins_up),
    .io_ins_left(ces_6_0_io_ins_left),
    .io_outs_down(ces_6_0_io_outs_down),
    .io_outs_right(ces_6_0_io_outs_right),
    .io_outs_up(ces_6_0_io_outs_up),
    .io_outs_left(ces_6_0_io_outs_left),
    .io_lsbIns_1(ces_6_0_io_lsbIns_1),
    .io_lsbIns_2(ces_6_0_io_lsbIns_2),
    .io_lsbIns_3(ces_6_0_io_lsbIns_3),
    .io_lsbIns_4(ces_6_0_io_lsbIns_4),
    .io_lsbIns_5(ces_6_0_io_lsbIns_5),
    .io_lsbIns_6(ces_6_0_io_lsbIns_6),
    .io_lsbIns_7(ces_6_0_io_lsbIns_7),
    .io_lsbOuts_0(ces_6_0_io_lsbOuts_0),
    .io_lsbOuts_1(ces_6_0_io_lsbOuts_1),
    .io_lsbOuts_2(ces_6_0_io_lsbOuts_2),
    .io_lsbOuts_3(ces_6_0_io_lsbOuts_3),
    .io_lsbOuts_4(ces_6_0_io_lsbOuts_4),
    .io_lsbOuts_5(ces_6_0_io_lsbOuts_5),
    .io_lsbOuts_6(ces_6_0_io_lsbOuts_6),
    .io_lsbOuts_7(ces_6_0_io_lsbOuts_7)
  );
  Element ces_6_1 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_6_1_clock),
    .io_ins_down(ces_6_1_io_ins_down),
    .io_ins_right(ces_6_1_io_ins_right),
    .io_ins_up(ces_6_1_io_ins_up),
    .io_ins_left(ces_6_1_io_ins_left),
    .io_outs_down(ces_6_1_io_outs_down),
    .io_outs_right(ces_6_1_io_outs_right),
    .io_outs_up(ces_6_1_io_outs_up),
    .io_outs_left(ces_6_1_io_outs_left),
    .io_lsbIns_1(ces_6_1_io_lsbIns_1),
    .io_lsbIns_2(ces_6_1_io_lsbIns_2),
    .io_lsbIns_3(ces_6_1_io_lsbIns_3),
    .io_lsbIns_4(ces_6_1_io_lsbIns_4),
    .io_lsbIns_5(ces_6_1_io_lsbIns_5),
    .io_lsbIns_6(ces_6_1_io_lsbIns_6),
    .io_lsbIns_7(ces_6_1_io_lsbIns_7),
    .io_lsbOuts_0(ces_6_1_io_lsbOuts_0),
    .io_lsbOuts_1(ces_6_1_io_lsbOuts_1),
    .io_lsbOuts_2(ces_6_1_io_lsbOuts_2),
    .io_lsbOuts_3(ces_6_1_io_lsbOuts_3),
    .io_lsbOuts_4(ces_6_1_io_lsbOuts_4),
    .io_lsbOuts_5(ces_6_1_io_lsbOuts_5),
    .io_lsbOuts_6(ces_6_1_io_lsbOuts_6),
    .io_lsbOuts_7(ces_6_1_io_lsbOuts_7)
  );
  Element ces_6_2 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_6_2_clock),
    .io_ins_down(ces_6_2_io_ins_down),
    .io_ins_right(ces_6_2_io_ins_right),
    .io_ins_up(ces_6_2_io_ins_up),
    .io_ins_left(ces_6_2_io_ins_left),
    .io_outs_down(ces_6_2_io_outs_down),
    .io_outs_right(ces_6_2_io_outs_right),
    .io_outs_up(ces_6_2_io_outs_up),
    .io_outs_left(ces_6_2_io_outs_left),
    .io_lsbIns_1(ces_6_2_io_lsbIns_1),
    .io_lsbIns_2(ces_6_2_io_lsbIns_2),
    .io_lsbIns_3(ces_6_2_io_lsbIns_3),
    .io_lsbIns_4(ces_6_2_io_lsbIns_4),
    .io_lsbIns_5(ces_6_2_io_lsbIns_5),
    .io_lsbIns_6(ces_6_2_io_lsbIns_6),
    .io_lsbIns_7(ces_6_2_io_lsbIns_7),
    .io_lsbOuts_0(ces_6_2_io_lsbOuts_0),
    .io_lsbOuts_1(ces_6_2_io_lsbOuts_1),
    .io_lsbOuts_2(ces_6_2_io_lsbOuts_2),
    .io_lsbOuts_3(ces_6_2_io_lsbOuts_3),
    .io_lsbOuts_4(ces_6_2_io_lsbOuts_4),
    .io_lsbOuts_5(ces_6_2_io_lsbOuts_5),
    .io_lsbOuts_6(ces_6_2_io_lsbOuts_6),
    .io_lsbOuts_7(ces_6_2_io_lsbOuts_7)
  );
  Element ces_6_3 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_6_3_clock),
    .io_ins_down(ces_6_3_io_ins_down),
    .io_ins_right(ces_6_3_io_ins_right),
    .io_ins_up(ces_6_3_io_ins_up),
    .io_ins_left(ces_6_3_io_ins_left),
    .io_outs_down(ces_6_3_io_outs_down),
    .io_outs_right(ces_6_3_io_outs_right),
    .io_outs_up(ces_6_3_io_outs_up),
    .io_outs_left(ces_6_3_io_outs_left),
    .io_lsbIns_1(ces_6_3_io_lsbIns_1),
    .io_lsbIns_2(ces_6_3_io_lsbIns_2),
    .io_lsbIns_3(ces_6_3_io_lsbIns_3),
    .io_lsbIns_4(ces_6_3_io_lsbIns_4),
    .io_lsbIns_5(ces_6_3_io_lsbIns_5),
    .io_lsbIns_6(ces_6_3_io_lsbIns_6),
    .io_lsbIns_7(ces_6_3_io_lsbIns_7),
    .io_lsbOuts_0(ces_6_3_io_lsbOuts_0),
    .io_lsbOuts_1(ces_6_3_io_lsbOuts_1),
    .io_lsbOuts_2(ces_6_3_io_lsbOuts_2),
    .io_lsbOuts_3(ces_6_3_io_lsbOuts_3),
    .io_lsbOuts_4(ces_6_3_io_lsbOuts_4),
    .io_lsbOuts_5(ces_6_3_io_lsbOuts_5),
    .io_lsbOuts_6(ces_6_3_io_lsbOuts_6),
    .io_lsbOuts_7(ces_6_3_io_lsbOuts_7)
  );
  Element ces_6_4 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_6_4_clock),
    .io_ins_down(ces_6_4_io_ins_down),
    .io_ins_right(ces_6_4_io_ins_right),
    .io_ins_up(ces_6_4_io_ins_up),
    .io_ins_left(ces_6_4_io_ins_left),
    .io_outs_down(ces_6_4_io_outs_down),
    .io_outs_right(ces_6_4_io_outs_right),
    .io_outs_up(ces_6_4_io_outs_up),
    .io_outs_left(ces_6_4_io_outs_left),
    .io_lsbIns_1(ces_6_4_io_lsbIns_1),
    .io_lsbIns_2(ces_6_4_io_lsbIns_2),
    .io_lsbIns_3(ces_6_4_io_lsbIns_3),
    .io_lsbIns_4(ces_6_4_io_lsbIns_4),
    .io_lsbIns_5(ces_6_4_io_lsbIns_5),
    .io_lsbIns_6(ces_6_4_io_lsbIns_6),
    .io_lsbIns_7(ces_6_4_io_lsbIns_7),
    .io_lsbOuts_0(ces_6_4_io_lsbOuts_0),
    .io_lsbOuts_1(ces_6_4_io_lsbOuts_1),
    .io_lsbOuts_2(ces_6_4_io_lsbOuts_2),
    .io_lsbOuts_3(ces_6_4_io_lsbOuts_3),
    .io_lsbOuts_4(ces_6_4_io_lsbOuts_4),
    .io_lsbOuts_5(ces_6_4_io_lsbOuts_5),
    .io_lsbOuts_6(ces_6_4_io_lsbOuts_6),
    .io_lsbOuts_7(ces_6_4_io_lsbOuts_7)
  );
  Element ces_6_5 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_6_5_clock),
    .io_ins_down(ces_6_5_io_ins_down),
    .io_ins_right(ces_6_5_io_ins_right),
    .io_ins_up(ces_6_5_io_ins_up),
    .io_ins_left(ces_6_5_io_ins_left),
    .io_outs_down(ces_6_5_io_outs_down),
    .io_outs_right(ces_6_5_io_outs_right),
    .io_outs_up(ces_6_5_io_outs_up),
    .io_outs_left(ces_6_5_io_outs_left),
    .io_lsbIns_1(ces_6_5_io_lsbIns_1),
    .io_lsbIns_2(ces_6_5_io_lsbIns_2),
    .io_lsbIns_3(ces_6_5_io_lsbIns_3),
    .io_lsbIns_4(ces_6_5_io_lsbIns_4),
    .io_lsbIns_5(ces_6_5_io_lsbIns_5),
    .io_lsbIns_6(ces_6_5_io_lsbIns_6),
    .io_lsbIns_7(ces_6_5_io_lsbIns_7),
    .io_lsbOuts_0(ces_6_5_io_lsbOuts_0),
    .io_lsbOuts_1(ces_6_5_io_lsbOuts_1),
    .io_lsbOuts_2(ces_6_5_io_lsbOuts_2),
    .io_lsbOuts_3(ces_6_5_io_lsbOuts_3),
    .io_lsbOuts_4(ces_6_5_io_lsbOuts_4),
    .io_lsbOuts_5(ces_6_5_io_lsbOuts_5),
    .io_lsbOuts_6(ces_6_5_io_lsbOuts_6),
    .io_lsbOuts_7(ces_6_5_io_lsbOuts_7)
  );
  Element ces_6_6 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_6_6_clock),
    .io_ins_down(ces_6_6_io_ins_down),
    .io_ins_right(ces_6_6_io_ins_right),
    .io_ins_up(ces_6_6_io_ins_up),
    .io_ins_left(ces_6_6_io_ins_left),
    .io_outs_down(ces_6_6_io_outs_down),
    .io_outs_right(ces_6_6_io_outs_right),
    .io_outs_up(ces_6_6_io_outs_up),
    .io_outs_left(ces_6_6_io_outs_left),
    .io_lsbIns_1(ces_6_6_io_lsbIns_1),
    .io_lsbIns_2(ces_6_6_io_lsbIns_2),
    .io_lsbIns_3(ces_6_6_io_lsbIns_3),
    .io_lsbIns_4(ces_6_6_io_lsbIns_4),
    .io_lsbIns_5(ces_6_6_io_lsbIns_5),
    .io_lsbIns_6(ces_6_6_io_lsbIns_6),
    .io_lsbIns_7(ces_6_6_io_lsbIns_7),
    .io_lsbOuts_0(ces_6_6_io_lsbOuts_0),
    .io_lsbOuts_1(ces_6_6_io_lsbOuts_1),
    .io_lsbOuts_2(ces_6_6_io_lsbOuts_2),
    .io_lsbOuts_3(ces_6_6_io_lsbOuts_3),
    .io_lsbOuts_4(ces_6_6_io_lsbOuts_4),
    .io_lsbOuts_5(ces_6_6_io_lsbOuts_5),
    .io_lsbOuts_6(ces_6_6_io_lsbOuts_6),
    .io_lsbOuts_7(ces_6_6_io_lsbOuts_7)
  );
  Element ces_6_7 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_6_7_clock),
    .io_ins_down(ces_6_7_io_ins_down),
    .io_ins_right(ces_6_7_io_ins_right),
    .io_ins_up(ces_6_7_io_ins_up),
    .io_ins_left(ces_6_7_io_ins_left),
    .io_outs_down(ces_6_7_io_outs_down),
    .io_outs_right(ces_6_7_io_outs_right),
    .io_outs_up(ces_6_7_io_outs_up),
    .io_outs_left(ces_6_7_io_outs_left),
    .io_lsbIns_1(ces_6_7_io_lsbIns_1),
    .io_lsbIns_2(ces_6_7_io_lsbIns_2),
    .io_lsbIns_3(ces_6_7_io_lsbIns_3),
    .io_lsbIns_4(ces_6_7_io_lsbIns_4),
    .io_lsbIns_5(ces_6_7_io_lsbIns_5),
    .io_lsbIns_6(ces_6_7_io_lsbIns_6),
    .io_lsbIns_7(ces_6_7_io_lsbIns_7),
    .io_lsbOuts_0(ces_6_7_io_lsbOuts_0),
    .io_lsbOuts_1(ces_6_7_io_lsbOuts_1),
    .io_lsbOuts_2(ces_6_7_io_lsbOuts_2),
    .io_lsbOuts_3(ces_6_7_io_lsbOuts_3),
    .io_lsbOuts_4(ces_6_7_io_lsbOuts_4),
    .io_lsbOuts_5(ces_6_7_io_lsbOuts_5),
    .io_lsbOuts_6(ces_6_7_io_lsbOuts_6),
    .io_lsbOuts_7(ces_6_7_io_lsbOuts_7)
  );
  Element ces_7_0 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_7_0_clock),
    .io_ins_down(ces_7_0_io_ins_down),
    .io_ins_right(ces_7_0_io_ins_right),
    .io_ins_up(ces_7_0_io_ins_up),
    .io_ins_left(ces_7_0_io_ins_left),
    .io_outs_down(ces_7_0_io_outs_down),
    .io_outs_right(ces_7_0_io_outs_right),
    .io_outs_up(ces_7_0_io_outs_up),
    .io_outs_left(ces_7_0_io_outs_left),
    .io_lsbIns_1(ces_7_0_io_lsbIns_1),
    .io_lsbIns_2(ces_7_0_io_lsbIns_2),
    .io_lsbIns_3(ces_7_0_io_lsbIns_3),
    .io_lsbIns_4(ces_7_0_io_lsbIns_4),
    .io_lsbIns_5(ces_7_0_io_lsbIns_5),
    .io_lsbIns_6(ces_7_0_io_lsbIns_6),
    .io_lsbIns_7(ces_7_0_io_lsbIns_7),
    .io_lsbOuts_0(ces_7_0_io_lsbOuts_0),
    .io_lsbOuts_1(ces_7_0_io_lsbOuts_1),
    .io_lsbOuts_2(ces_7_0_io_lsbOuts_2),
    .io_lsbOuts_3(ces_7_0_io_lsbOuts_3),
    .io_lsbOuts_4(ces_7_0_io_lsbOuts_4),
    .io_lsbOuts_5(ces_7_0_io_lsbOuts_5),
    .io_lsbOuts_6(ces_7_0_io_lsbOuts_6),
    .io_lsbOuts_7(ces_7_0_io_lsbOuts_7)
  );
  Element ces_7_1 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_7_1_clock),
    .io_ins_down(ces_7_1_io_ins_down),
    .io_ins_right(ces_7_1_io_ins_right),
    .io_ins_up(ces_7_1_io_ins_up),
    .io_ins_left(ces_7_1_io_ins_left),
    .io_outs_down(ces_7_1_io_outs_down),
    .io_outs_right(ces_7_1_io_outs_right),
    .io_outs_up(ces_7_1_io_outs_up),
    .io_outs_left(ces_7_1_io_outs_left),
    .io_lsbIns_1(ces_7_1_io_lsbIns_1),
    .io_lsbIns_2(ces_7_1_io_lsbIns_2),
    .io_lsbIns_3(ces_7_1_io_lsbIns_3),
    .io_lsbIns_4(ces_7_1_io_lsbIns_4),
    .io_lsbIns_5(ces_7_1_io_lsbIns_5),
    .io_lsbIns_6(ces_7_1_io_lsbIns_6),
    .io_lsbIns_7(ces_7_1_io_lsbIns_7),
    .io_lsbOuts_0(ces_7_1_io_lsbOuts_0),
    .io_lsbOuts_1(ces_7_1_io_lsbOuts_1),
    .io_lsbOuts_2(ces_7_1_io_lsbOuts_2),
    .io_lsbOuts_3(ces_7_1_io_lsbOuts_3),
    .io_lsbOuts_4(ces_7_1_io_lsbOuts_4),
    .io_lsbOuts_5(ces_7_1_io_lsbOuts_5),
    .io_lsbOuts_6(ces_7_1_io_lsbOuts_6),
    .io_lsbOuts_7(ces_7_1_io_lsbOuts_7)
  );
  Element ces_7_2 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_7_2_clock),
    .io_ins_down(ces_7_2_io_ins_down),
    .io_ins_right(ces_7_2_io_ins_right),
    .io_ins_up(ces_7_2_io_ins_up),
    .io_ins_left(ces_7_2_io_ins_left),
    .io_outs_down(ces_7_2_io_outs_down),
    .io_outs_right(ces_7_2_io_outs_right),
    .io_outs_up(ces_7_2_io_outs_up),
    .io_outs_left(ces_7_2_io_outs_left),
    .io_lsbIns_1(ces_7_2_io_lsbIns_1),
    .io_lsbIns_2(ces_7_2_io_lsbIns_2),
    .io_lsbIns_3(ces_7_2_io_lsbIns_3),
    .io_lsbIns_4(ces_7_2_io_lsbIns_4),
    .io_lsbIns_5(ces_7_2_io_lsbIns_5),
    .io_lsbIns_6(ces_7_2_io_lsbIns_6),
    .io_lsbIns_7(ces_7_2_io_lsbIns_7),
    .io_lsbOuts_0(ces_7_2_io_lsbOuts_0),
    .io_lsbOuts_1(ces_7_2_io_lsbOuts_1),
    .io_lsbOuts_2(ces_7_2_io_lsbOuts_2),
    .io_lsbOuts_3(ces_7_2_io_lsbOuts_3),
    .io_lsbOuts_4(ces_7_2_io_lsbOuts_4),
    .io_lsbOuts_5(ces_7_2_io_lsbOuts_5),
    .io_lsbOuts_6(ces_7_2_io_lsbOuts_6),
    .io_lsbOuts_7(ces_7_2_io_lsbOuts_7)
  );
  Element ces_7_3 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_7_3_clock),
    .io_ins_down(ces_7_3_io_ins_down),
    .io_ins_right(ces_7_3_io_ins_right),
    .io_ins_up(ces_7_3_io_ins_up),
    .io_ins_left(ces_7_3_io_ins_left),
    .io_outs_down(ces_7_3_io_outs_down),
    .io_outs_right(ces_7_3_io_outs_right),
    .io_outs_up(ces_7_3_io_outs_up),
    .io_outs_left(ces_7_3_io_outs_left),
    .io_lsbIns_1(ces_7_3_io_lsbIns_1),
    .io_lsbIns_2(ces_7_3_io_lsbIns_2),
    .io_lsbIns_3(ces_7_3_io_lsbIns_3),
    .io_lsbIns_4(ces_7_3_io_lsbIns_4),
    .io_lsbIns_5(ces_7_3_io_lsbIns_5),
    .io_lsbIns_6(ces_7_3_io_lsbIns_6),
    .io_lsbIns_7(ces_7_3_io_lsbIns_7),
    .io_lsbOuts_0(ces_7_3_io_lsbOuts_0),
    .io_lsbOuts_1(ces_7_3_io_lsbOuts_1),
    .io_lsbOuts_2(ces_7_3_io_lsbOuts_2),
    .io_lsbOuts_3(ces_7_3_io_lsbOuts_3),
    .io_lsbOuts_4(ces_7_3_io_lsbOuts_4),
    .io_lsbOuts_5(ces_7_3_io_lsbOuts_5),
    .io_lsbOuts_6(ces_7_3_io_lsbOuts_6),
    .io_lsbOuts_7(ces_7_3_io_lsbOuts_7)
  );
  Element ces_7_4 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_7_4_clock),
    .io_ins_down(ces_7_4_io_ins_down),
    .io_ins_right(ces_7_4_io_ins_right),
    .io_ins_up(ces_7_4_io_ins_up),
    .io_ins_left(ces_7_4_io_ins_left),
    .io_outs_down(ces_7_4_io_outs_down),
    .io_outs_right(ces_7_4_io_outs_right),
    .io_outs_up(ces_7_4_io_outs_up),
    .io_outs_left(ces_7_4_io_outs_left),
    .io_lsbIns_1(ces_7_4_io_lsbIns_1),
    .io_lsbIns_2(ces_7_4_io_lsbIns_2),
    .io_lsbIns_3(ces_7_4_io_lsbIns_3),
    .io_lsbIns_4(ces_7_4_io_lsbIns_4),
    .io_lsbIns_5(ces_7_4_io_lsbIns_5),
    .io_lsbIns_6(ces_7_4_io_lsbIns_6),
    .io_lsbIns_7(ces_7_4_io_lsbIns_7),
    .io_lsbOuts_0(ces_7_4_io_lsbOuts_0),
    .io_lsbOuts_1(ces_7_4_io_lsbOuts_1),
    .io_lsbOuts_2(ces_7_4_io_lsbOuts_2),
    .io_lsbOuts_3(ces_7_4_io_lsbOuts_3),
    .io_lsbOuts_4(ces_7_4_io_lsbOuts_4),
    .io_lsbOuts_5(ces_7_4_io_lsbOuts_5),
    .io_lsbOuts_6(ces_7_4_io_lsbOuts_6),
    .io_lsbOuts_7(ces_7_4_io_lsbOuts_7)
  );
  Element ces_7_5 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_7_5_clock),
    .io_ins_down(ces_7_5_io_ins_down),
    .io_ins_right(ces_7_5_io_ins_right),
    .io_ins_up(ces_7_5_io_ins_up),
    .io_ins_left(ces_7_5_io_ins_left),
    .io_outs_down(ces_7_5_io_outs_down),
    .io_outs_right(ces_7_5_io_outs_right),
    .io_outs_up(ces_7_5_io_outs_up),
    .io_outs_left(ces_7_5_io_outs_left),
    .io_lsbIns_1(ces_7_5_io_lsbIns_1),
    .io_lsbIns_2(ces_7_5_io_lsbIns_2),
    .io_lsbIns_3(ces_7_5_io_lsbIns_3),
    .io_lsbIns_4(ces_7_5_io_lsbIns_4),
    .io_lsbIns_5(ces_7_5_io_lsbIns_5),
    .io_lsbIns_6(ces_7_5_io_lsbIns_6),
    .io_lsbIns_7(ces_7_5_io_lsbIns_7),
    .io_lsbOuts_0(ces_7_5_io_lsbOuts_0),
    .io_lsbOuts_1(ces_7_5_io_lsbOuts_1),
    .io_lsbOuts_2(ces_7_5_io_lsbOuts_2),
    .io_lsbOuts_3(ces_7_5_io_lsbOuts_3),
    .io_lsbOuts_4(ces_7_5_io_lsbOuts_4),
    .io_lsbOuts_5(ces_7_5_io_lsbOuts_5),
    .io_lsbOuts_6(ces_7_5_io_lsbOuts_6),
    .io_lsbOuts_7(ces_7_5_io_lsbOuts_7)
  );
  Element ces_7_6 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_7_6_clock),
    .io_ins_down(ces_7_6_io_ins_down),
    .io_ins_right(ces_7_6_io_ins_right),
    .io_ins_up(ces_7_6_io_ins_up),
    .io_ins_left(ces_7_6_io_ins_left),
    .io_outs_down(ces_7_6_io_outs_down),
    .io_outs_right(ces_7_6_io_outs_right),
    .io_outs_up(ces_7_6_io_outs_up),
    .io_outs_left(ces_7_6_io_outs_left),
    .io_lsbIns_1(ces_7_6_io_lsbIns_1),
    .io_lsbIns_2(ces_7_6_io_lsbIns_2),
    .io_lsbIns_3(ces_7_6_io_lsbIns_3),
    .io_lsbIns_4(ces_7_6_io_lsbIns_4),
    .io_lsbIns_5(ces_7_6_io_lsbIns_5),
    .io_lsbIns_6(ces_7_6_io_lsbIns_6),
    .io_lsbIns_7(ces_7_6_io_lsbIns_7),
    .io_lsbOuts_0(ces_7_6_io_lsbOuts_0),
    .io_lsbOuts_1(ces_7_6_io_lsbOuts_1),
    .io_lsbOuts_2(ces_7_6_io_lsbOuts_2),
    .io_lsbOuts_3(ces_7_6_io_lsbOuts_3),
    .io_lsbOuts_4(ces_7_6_io_lsbOuts_4),
    .io_lsbOuts_5(ces_7_6_io_lsbOuts_5),
    .io_lsbOuts_6(ces_7_6_io_lsbOuts_6),
    .io_lsbOuts_7(ces_7_6_io_lsbOuts_7)
  );
  Element ces_7_7 ( // @[src/test/scala/MockArray.scala 66:52]
    .clock(ces_7_7_clock),
    .io_ins_down(ces_7_7_io_ins_down),
    .io_ins_right(ces_7_7_io_ins_right),
    .io_ins_up(ces_7_7_io_ins_up),
    .io_ins_left(ces_7_7_io_ins_left),
    .io_outs_down(ces_7_7_io_outs_down),
    .io_outs_right(ces_7_7_io_outs_right),
    .io_outs_up(ces_7_7_io_outs_up),
    .io_outs_left(ces_7_7_io_outs_left),
    .io_lsbIns_1(ces_7_7_io_lsbIns_1),
    .io_lsbIns_2(ces_7_7_io_lsbIns_2),
    .io_lsbIns_3(ces_7_7_io_lsbIns_3),
    .io_lsbIns_4(ces_7_7_io_lsbIns_4),
    .io_lsbIns_5(ces_7_7_io_lsbIns_5),
    .io_lsbIns_6(ces_7_7_io_lsbIns_6),
    .io_lsbIns_7(ces_7_7_io_lsbIns_7),
    .io_lsbOuts_0(ces_7_7_io_lsbOuts_0),
    .io_lsbOuts_1(ces_7_7_io_lsbOuts_1),
    .io_lsbOuts_2(ces_7_7_io_lsbOuts_2),
    .io_lsbOuts_3(ces_7_7_io_lsbOuts_3),
    .io_lsbOuts_4(ces_7_7_io_lsbOuts_4),
    .io_lsbOuts_5(ces_7_7_io_lsbOuts_5),
    .io_lsbOuts_6(ces_7_7_io_lsbOuts_6),
    .io_lsbOuts_7(ces_7_7_io_lsbOuts_7)
  );
  assign io_outsLeft_0 = ces_0_0_io_outs_left; // @[src/test/scala/MockArray.scala 83:98]
  assign io_outsLeft_1 = ces_1_0_io_outs_left; // @[src/test/scala/MockArray.scala 83:98]
  assign io_outsLeft_2 = ces_2_0_io_outs_left; // @[src/test/scala/MockArray.scala 83:98]
  assign io_outsLeft_3 = ces_3_0_io_outs_left; // @[src/test/scala/MockArray.scala 83:98]
  assign io_outsLeft_4 = ces_4_0_io_outs_left; // @[src/test/scala/MockArray.scala 83:98]
  assign io_outsLeft_5 = ces_5_0_io_outs_left; // @[src/test/scala/MockArray.scala 83:98]
  assign io_outsLeft_6 = ces_6_0_io_outs_left; // @[src/test/scala/MockArray.scala 83:98]
  assign io_outsLeft_7 = ces_7_0_io_outs_left; // @[src/test/scala/MockArray.scala 83:98]
  assign io_outsUp_0 = ces_7_0_io_outs_up; // @[src/test/scala/MockArray.scala 84:87]
  assign io_outsUp_1 = ces_7_1_io_outs_up; // @[src/test/scala/MockArray.scala 84:87]
  assign io_outsUp_2 = ces_7_2_io_outs_up; // @[src/test/scala/MockArray.scala 84:87]
  assign io_outsUp_3 = ces_7_3_io_outs_up; // @[src/test/scala/MockArray.scala 84:87]
  assign io_outsUp_4 = ces_7_4_io_outs_up; // @[src/test/scala/MockArray.scala 84:87]
  assign io_outsUp_5 = ces_7_5_io_outs_up; // @[src/test/scala/MockArray.scala 84:87]
  assign io_outsUp_6 = ces_7_6_io_outs_up; // @[src/test/scala/MockArray.scala 84:87]
  assign io_outsUp_7 = ces_7_7_io_outs_up; // @[src/test/scala/MockArray.scala 84:87]
  assign io_outsRight_0 = ces_0_7_io_outs_right; // @[src/test/scala/MockArray.scala 85:100]
  assign io_outsRight_1 = ces_1_7_io_outs_right; // @[src/test/scala/MockArray.scala 85:100]
  assign io_outsRight_2 = ces_2_7_io_outs_right; // @[src/test/scala/MockArray.scala 85:100]
  assign io_outsRight_3 = ces_3_7_io_outs_right; // @[src/test/scala/MockArray.scala 85:100]
  assign io_outsRight_4 = ces_4_7_io_outs_right; // @[src/test/scala/MockArray.scala 85:100]
  assign io_outsRight_5 = ces_5_7_io_outs_right; // @[src/test/scala/MockArray.scala 85:100]
  assign io_outsRight_6 = ces_6_7_io_outs_right; // @[src/test/scala/MockArray.scala 85:100]
  assign io_outsRight_7 = ces_7_7_io_outs_right; // @[src/test/scala/MockArray.scala 85:100]
  assign io_outsDown_0 = ces_0_0_io_outs_down; // @[src/test/scala/MockArray.scala 86:91]
  assign io_outsDown_1 = ces_0_1_io_outs_down; // @[src/test/scala/MockArray.scala 86:91]
  assign io_outsDown_2 = ces_0_2_io_outs_down; // @[src/test/scala/MockArray.scala 86:91]
  assign io_outsDown_3 = ces_0_3_io_outs_down; // @[src/test/scala/MockArray.scala 86:91]
  assign io_outsDown_4 = ces_0_4_io_outs_down; // @[src/test/scala/MockArray.scala 86:91]
  assign io_outsDown_5 = ces_0_5_io_outs_down; // @[src/test/scala/MockArray.scala 86:91]
  assign io_outsDown_6 = ces_0_6_io_outs_down; // @[src/test/scala/MockArray.scala 86:91]
  assign io_outsDown_7 = ces_0_7_io_outs_down; // @[src/test/scala/MockArray.scala 86:91]
  assign io_lsbs_0 = ces_0_7_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_1 = ces_0_7_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_2 = ces_0_7_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_3 = ces_0_7_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_4 = ces_0_7_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_5 = ces_0_7_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_6 = ces_0_7_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_7 = ces_0_7_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_8 = ces_1_7_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_9 = ces_1_7_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_10 = ces_1_7_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_11 = ces_1_7_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_12 = ces_1_7_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_13 = ces_1_7_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_14 = ces_1_7_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_15 = ces_1_7_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_16 = ces_2_7_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_17 = ces_2_7_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_18 = ces_2_7_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_19 = ces_2_7_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_20 = ces_2_7_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_21 = ces_2_7_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_22 = ces_2_7_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_23 = ces_2_7_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_24 = ces_3_7_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_25 = ces_3_7_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_26 = ces_3_7_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_27 = ces_3_7_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_28 = ces_3_7_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_29 = ces_3_7_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_30 = ces_3_7_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_31 = ces_3_7_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_32 = ces_4_7_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_33 = ces_4_7_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_34 = ces_4_7_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_35 = ces_4_7_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_36 = ces_4_7_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_37 = ces_4_7_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_38 = ces_4_7_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_39 = ces_4_7_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_40 = ces_5_7_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_41 = ces_5_7_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_42 = ces_5_7_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_43 = ces_5_7_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_44 = ces_5_7_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_45 = ces_5_7_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_46 = ces_5_7_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_47 = ces_5_7_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_48 = ces_6_7_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_49 = ces_6_7_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_50 = ces_6_7_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_51 = ces_6_7_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_52 = ces_6_7_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_53 = ces_6_7_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_54 = ces_6_7_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_55 = ces_6_7_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_56 = ces_7_7_io_lsbOuts_0; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_57 = ces_7_7_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_58 = ces_7_7_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_59 = ces_7_7_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_60 = ces_7_7_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_61 = ces_7_7_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_62 = ces_7_7_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 74:11]
  assign io_lsbs_63 = ces_7_7_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 74:11]
  assign ces_0_0_clock = clock;
  assign ces_0_0_io_ins_down = ces_1_0_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_0_0_io_ins_right = io_insRight_0; // @[src/test/scala/MockArray.scala 77:98]
  assign ces_0_0_io_ins_up = io_insUp_0; // @[src/test/scala/MockArray.scala 80:85]
  assign ces_0_0_io_ins_left = ces_0_1_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_0_0_io_lsbIns_1 = 1'h0;
  assign ces_0_0_io_lsbIns_2 = 1'h0;
  assign ces_0_0_io_lsbIns_3 = 1'h0;
  assign ces_0_0_io_lsbIns_4 = 1'h0;
  assign ces_0_0_io_lsbIns_5 = 1'h0;
  assign ces_0_0_io_lsbIns_6 = 1'h0;
  assign ces_0_0_io_lsbIns_7 = 1'h0;
  assign ces_0_1_clock = clock;
  assign ces_0_1_io_ins_down = ces_1_1_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_0_1_io_ins_right = ces_0_0_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_0_1_io_ins_up = io_insUp_1; // @[src/test/scala/MockArray.scala 80:85]
  assign ces_0_1_io_ins_left = ces_0_2_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_0_1_io_lsbIns_1 = ces_0_0_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_1_io_lsbIns_2 = ces_0_0_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_1_io_lsbIns_3 = ces_0_0_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_1_io_lsbIns_4 = ces_0_0_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_1_io_lsbIns_5 = ces_0_0_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_1_io_lsbIns_6 = ces_0_0_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_1_io_lsbIns_7 = ces_0_0_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_2_clock = clock;
  assign ces_0_2_io_ins_down = ces_1_2_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_0_2_io_ins_right = ces_0_1_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_0_2_io_ins_up = io_insUp_2; // @[src/test/scala/MockArray.scala 80:85]
  assign ces_0_2_io_ins_left = ces_0_3_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_0_2_io_lsbIns_1 = ces_0_1_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_2_io_lsbIns_2 = ces_0_1_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_2_io_lsbIns_3 = ces_0_1_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_2_io_lsbIns_4 = ces_0_1_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_2_io_lsbIns_5 = ces_0_1_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_2_io_lsbIns_6 = ces_0_1_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_2_io_lsbIns_7 = ces_0_1_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_3_clock = clock;
  assign ces_0_3_io_ins_down = ces_1_3_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_0_3_io_ins_right = ces_0_2_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_0_3_io_ins_up = io_insUp_3; // @[src/test/scala/MockArray.scala 80:85]
  assign ces_0_3_io_ins_left = ces_0_4_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_0_3_io_lsbIns_1 = ces_0_2_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_3_io_lsbIns_2 = ces_0_2_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_3_io_lsbIns_3 = ces_0_2_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_3_io_lsbIns_4 = ces_0_2_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_3_io_lsbIns_5 = ces_0_2_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_3_io_lsbIns_6 = ces_0_2_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_3_io_lsbIns_7 = ces_0_2_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_4_clock = clock;
  assign ces_0_4_io_ins_down = ces_1_4_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_0_4_io_ins_right = ces_0_3_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_0_4_io_ins_up = io_insUp_4; // @[src/test/scala/MockArray.scala 80:85]
  assign ces_0_4_io_ins_left = ces_0_5_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_0_4_io_lsbIns_1 = ces_0_3_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_4_io_lsbIns_2 = ces_0_3_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_4_io_lsbIns_3 = ces_0_3_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_4_io_lsbIns_4 = ces_0_3_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_4_io_lsbIns_5 = ces_0_3_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_4_io_lsbIns_6 = ces_0_3_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_4_io_lsbIns_7 = ces_0_3_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_5_clock = clock;
  assign ces_0_5_io_ins_down = ces_1_5_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_0_5_io_ins_right = ces_0_4_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_0_5_io_ins_up = io_insUp_5; // @[src/test/scala/MockArray.scala 80:85]
  assign ces_0_5_io_ins_left = ces_0_6_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_0_5_io_lsbIns_1 = ces_0_4_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_5_io_lsbIns_2 = ces_0_4_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_5_io_lsbIns_3 = ces_0_4_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_5_io_lsbIns_4 = ces_0_4_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_5_io_lsbIns_5 = ces_0_4_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_5_io_lsbIns_6 = ces_0_4_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_5_io_lsbIns_7 = ces_0_4_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_6_clock = clock;
  assign ces_0_6_io_ins_down = ces_1_6_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_0_6_io_ins_right = ces_0_5_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_0_6_io_ins_up = io_insUp_6; // @[src/test/scala/MockArray.scala 80:85]
  assign ces_0_6_io_ins_left = ces_0_7_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_0_6_io_lsbIns_1 = ces_0_5_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_6_io_lsbIns_2 = ces_0_5_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_6_io_lsbIns_3 = ces_0_5_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_6_io_lsbIns_4 = ces_0_5_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_6_io_lsbIns_5 = ces_0_5_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_6_io_lsbIns_6 = ces_0_5_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_6_io_lsbIns_7 = ces_0_5_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_7_clock = clock;
  assign ces_0_7_io_ins_down = ces_1_7_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_0_7_io_ins_right = ces_0_6_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_0_7_io_ins_up = io_insUp_7; // @[src/test/scala/MockArray.scala 80:85]
  assign ces_0_7_io_ins_left = io_insLeft_0; // @[src/test/scala/MockArray.scala 79:96]
  assign ces_0_7_io_lsbIns_1 = ces_0_6_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_7_io_lsbIns_2 = ces_0_6_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_7_io_lsbIns_3 = ces_0_6_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_7_io_lsbIns_4 = ces_0_6_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_7_io_lsbIns_5 = ces_0_6_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_7_io_lsbIns_6 = ces_0_6_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_0_7_io_lsbIns_7 = ces_0_6_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_0_clock = clock;
  assign ces_1_0_io_ins_down = ces_2_0_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_1_0_io_ins_right = io_insRight_1; // @[src/test/scala/MockArray.scala 77:98]
  assign ces_1_0_io_ins_up = ces_0_0_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_1_0_io_ins_left = ces_1_1_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_1_0_io_lsbIns_1 = 1'h0;
  assign ces_1_0_io_lsbIns_2 = 1'h0;
  assign ces_1_0_io_lsbIns_3 = 1'h0;
  assign ces_1_0_io_lsbIns_4 = 1'h0;
  assign ces_1_0_io_lsbIns_5 = 1'h0;
  assign ces_1_0_io_lsbIns_6 = 1'h0;
  assign ces_1_0_io_lsbIns_7 = 1'h0;
  assign ces_1_1_clock = clock;
  assign ces_1_1_io_ins_down = ces_2_1_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_1_1_io_ins_right = ces_1_0_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_1_1_io_ins_up = ces_0_1_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_1_1_io_ins_left = ces_1_2_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_1_1_io_lsbIns_1 = ces_1_0_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_1_io_lsbIns_2 = ces_1_0_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_1_io_lsbIns_3 = ces_1_0_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_1_io_lsbIns_4 = ces_1_0_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_1_io_lsbIns_5 = ces_1_0_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_1_io_lsbIns_6 = ces_1_0_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_1_io_lsbIns_7 = ces_1_0_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_2_clock = clock;
  assign ces_1_2_io_ins_down = ces_2_2_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_1_2_io_ins_right = ces_1_1_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_1_2_io_ins_up = ces_0_2_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_1_2_io_ins_left = ces_1_3_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_1_2_io_lsbIns_1 = ces_1_1_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_2_io_lsbIns_2 = ces_1_1_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_2_io_lsbIns_3 = ces_1_1_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_2_io_lsbIns_4 = ces_1_1_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_2_io_lsbIns_5 = ces_1_1_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_2_io_lsbIns_6 = ces_1_1_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_2_io_lsbIns_7 = ces_1_1_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_3_clock = clock;
  assign ces_1_3_io_ins_down = ces_2_3_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_1_3_io_ins_right = ces_1_2_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_1_3_io_ins_up = ces_0_3_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_1_3_io_ins_left = ces_1_4_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_1_3_io_lsbIns_1 = ces_1_2_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_3_io_lsbIns_2 = ces_1_2_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_3_io_lsbIns_3 = ces_1_2_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_3_io_lsbIns_4 = ces_1_2_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_3_io_lsbIns_5 = ces_1_2_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_3_io_lsbIns_6 = ces_1_2_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_3_io_lsbIns_7 = ces_1_2_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_4_clock = clock;
  assign ces_1_4_io_ins_down = ces_2_4_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_1_4_io_ins_right = ces_1_3_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_1_4_io_ins_up = ces_0_4_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_1_4_io_ins_left = ces_1_5_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_1_4_io_lsbIns_1 = ces_1_3_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_4_io_lsbIns_2 = ces_1_3_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_4_io_lsbIns_3 = ces_1_3_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_4_io_lsbIns_4 = ces_1_3_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_4_io_lsbIns_5 = ces_1_3_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_4_io_lsbIns_6 = ces_1_3_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_4_io_lsbIns_7 = ces_1_3_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_5_clock = clock;
  assign ces_1_5_io_ins_down = ces_2_5_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_1_5_io_ins_right = ces_1_4_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_1_5_io_ins_up = ces_0_5_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_1_5_io_ins_left = ces_1_6_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_1_5_io_lsbIns_1 = ces_1_4_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_5_io_lsbIns_2 = ces_1_4_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_5_io_lsbIns_3 = ces_1_4_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_5_io_lsbIns_4 = ces_1_4_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_5_io_lsbIns_5 = ces_1_4_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_5_io_lsbIns_6 = ces_1_4_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_5_io_lsbIns_7 = ces_1_4_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_6_clock = clock;
  assign ces_1_6_io_ins_down = ces_2_6_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_1_6_io_ins_right = ces_1_5_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_1_6_io_ins_up = ces_0_6_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_1_6_io_ins_left = ces_1_7_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_1_6_io_lsbIns_1 = ces_1_5_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_6_io_lsbIns_2 = ces_1_5_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_6_io_lsbIns_3 = ces_1_5_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_6_io_lsbIns_4 = ces_1_5_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_6_io_lsbIns_5 = ces_1_5_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_6_io_lsbIns_6 = ces_1_5_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_6_io_lsbIns_7 = ces_1_5_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_7_clock = clock;
  assign ces_1_7_io_ins_down = ces_2_7_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_1_7_io_ins_right = ces_1_6_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_1_7_io_ins_up = ces_0_7_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_1_7_io_ins_left = io_insLeft_1; // @[src/test/scala/MockArray.scala 79:96]
  assign ces_1_7_io_lsbIns_1 = ces_1_6_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_7_io_lsbIns_2 = ces_1_6_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_7_io_lsbIns_3 = ces_1_6_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_7_io_lsbIns_4 = ces_1_6_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_7_io_lsbIns_5 = ces_1_6_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_7_io_lsbIns_6 = ces_1_6_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_1_7_io_lsbIns_7 = ces_1_6_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_0_clock = clock;
  assign ces_2_0_io_ins_down = ces_3_0_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_2_0_io_ins_right = io_insRight_2; // @[src/test/scala/MockArray.scala 77:98]
  assign ces_2_0_io_ins_up = ces_1_0_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_2_0_io_ins_left = ces_2_1_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_2_0_io_lsbIns_1 = 1'h0;
  assign ces_2_0_io_lsbIns_2 = 1'h0;
  assign ces_2_0_io_lsbIns_3 = 1'h0;
  assign ces_2_0_io_lsbIns_4 = 1'h0;
  assign ces_2_0_io_lsbIns_5 = 1'h0;
  assign ces_2_0_io_lsbIns_6 = 1'h0;
  assign ces_2_0_io_lsbIns_7 = 1'h0;
  assign ces_2_1_clock = clock;
  assign ces_2_1_io_ins_down = ces_3_1_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_2_1_io_ins_right = ces_2_0_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_2_1_io_ins_up = ces_1_1_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_2_1_io_ins_left = ces_2_2_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_2_1_io_lsbIns_1 = ces_2_0_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_1_io_lsbIns_2 = ces_2_0_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_1_io_lsbIns_3 = ces_2_0_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_1_io_lsbIns_4 = ces_2_0_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_1_io_lsbIns_5 = ces_2_0_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_1_io_lsbIns_6 = ces_2_0_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_1_io_lsbIns_7 = ces_2_0_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_2_clock = clock;
  assign ces_2_2_io_ins_down = ces_3_2_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_2_2_io_ins_right = ces_2_1_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_2_2_io_ins_up = ces_1_2_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_2_2_io_ins_left = ces_2_3_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_2_2_io_lsbIns_1 = ces_2_1_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_2_io_lsbIns_2 = ces_2_1_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_2_io_lsbIns_3 = ces_2_1_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_2_io_lsbIns_4 = ces_2_1_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_2_io_lsbIns_5 = ces_2_1_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_2_io_lsbIns_6 = ces_2_1_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_2_io_lsbIns_7 = ces_2_1_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_3_clock = clock;
  assign ces_2_3_io_ins_down = ces_3_3_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_2_3_io_ins_right = ces_2_2_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_2_3_io_ins_up = ces_1_3_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_2_3_io_ins_left = ces_2_4_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_2_3_io_lsbIns_1 = ces_2_2_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_3_io_lsbIns_2 = ces_2_2_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_3_io_lsbIns_3 = ces_2_2_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_3_io_lsbIns_4 = ces_2_2_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_3_io_lsbIns_5 = ces_2_2_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_3_io_lsbIns_6 = ces_2_2_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_3_io_lsbIns_7 = ces_2_2_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_4_clock = clock;
  assign ces_2_4_io_ins_down = ces_3_4_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_2_4_io_ins_right = ces_2_3_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_2_4_io_ins_up = ces_1_4_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_2_4_io_ins_left = ces_2_5_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_2_4_io_lsbIns_1 = ces_2_3_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_4_io_lsbIns_2 = ces_2_3_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_4_io_lsbIns_3 = ces_2_3_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_4_io_lsbIns_4 = ces_2_3_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_4_io_lsbIns_5 = ces_2_3_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_4_io_lsbIns_6 = ces_2_3_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_4_io_lsbIns_7 = ces_2_3_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_5_clock = clock;
  assign ces_2_5_io_ins_down = ces_3_5_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_2_5_io_ins_right = ces_2_4_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_2_5_io_ins_up = ces_1_5_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_2_5_io_ins_left = ces_2_6_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_2_5_io_lsbIns_1 = ces_2_4_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_5_io_lsbIns_2 = ces_2_4_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_5_io_lsbIns_3 = ces_2_4_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_5_io_lsbIns_4 = ces_2_4_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_5_io_lsbIns_5 = ces_2_4_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_5_io_lsbIns_6 = ces_2_4_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_5_io_lsbIns_7 = ces_2_4_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_6_clock = clock;
  assign ces_2_6_io_ins_down = ces_3_6_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_2_6_io_ins_right = ces_2_5_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_2_6_io_ins_up = ces_1_6_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_2_6_io_ins_left = ces_2_7_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_2_6_io_lsbIns_1 = ces_2_5_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_6_io_lsbIns_2 = ces_2_5_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_6_io_lsbIns_3 = ces_2_5_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_6_io_lsbIns_4 = ces_2_5_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_6_io_lsbIns_5 = ces_2_5_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_6_io_lsbIns_6 = ces_2_5_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_6_io_lsbIns_7 = ces_2_5_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_7_clock = clock;
  assign ces_2_7_io_ins_down = ces_3_7_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_2_7_io_ins_right = ces_2_6_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_2_7_io_ins_up = ces_1_7_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_2_7_io_ins_left = io_insLeft_2; // @[src/test/scala/MockArray.scala 79:96]
  assign ces_2_7_io_lsbIns_1 = ces_2_6_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_7_io_lsbIns_2 = ces_2_6_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_7_io_lsbIns_3 = ces_2_6_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_7_io_lsbIns_4 = ces_2_6_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_7_io_lsbIns_5 = ces_2_6_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_7_io_lsbIns_6 = ces_2_6_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_2_7_io_lsbIns_7 = ces_2_6_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_0_clock = clock;
  assign ces_3_0_io_ins_down = ces_4_0_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_3_0_io_ins_right = io_insRight_3; // @[src/test/scala/MockArray.scala 77:98]
  assign ces_3_0_io_ins_up = ces_2_0_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_3_0_io_ins_left = ces_3_1_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_3_0_io_lsbIns_1 = 1'h0;
  assign ces_3_0_io_lsbIns_2 = 1'h0;
  assign ces_3_0_io_lsbIns_3 = 1'h0;
  assign ces_3_0_io_lsbIns_4 = 1'h0;
  assign ces_3_0_io_lsbIns_5 = 1'h0;
  assign ces_3_0_io_lsbIns_6 = 1'h0;
  assign ces_3_0_io_lsbIns_7 = 1'h0;
  assign ces_3_1_clock = clock;
  assign ces_3_1_io_ins_down = ces_4_1_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_3_1_io_ins_right = ces_3_0_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_3_1_io_ins_up = ces_2_1_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_3_1_io_ins_left = ces_3_2_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_3_1_io_lsbIns_1 = ces_3_0_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_1_io_lsbIns_2 = ces_3_0_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_1_io_lsbIns_3 = ces_3_0_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_1_io_lsbIns_4 = ces_3_0_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_1_io_lsbIns_5 = ces_3_0_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_1_io_lsbIns_6 = ces_3_0_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_1_io_lsbIns_7 = ces_3_0_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_2_clock = clock;
  assign ces_3_2_io_ins_down = ces_4_2_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_3_2_io_ins_right = ces_3_1_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_3_2_io_ins_up = ces_2_2_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_3_2_io_ins_left = ces_3_3_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_3_2_io_lsbIns_1 = ces_3_1_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_2_io_lsbIns_2 = ces_3_1_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_2_io_lsbIns_3 = ces_3_1_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_2_io_lsbIns_4 = ces_3_1_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_2_io_lsbIns_5 = ces_3_1_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_2_io_lsbIns_6 = ces_3_1_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_2_io_lsbIns_7 = ces_3_1_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_3_clock = clock;
  assign ces_3_3_io_ins_down = ces_4_3_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_3_3_io_ins_right = ces_3_2_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_3_3_io_ins_up = ces_2_3_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_3_3_io_ins_left = ces_3_4_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_3_3_io_lsbIns_1 = ces_3_2_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_3_io_lsbIns_2 = ces_3_2_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_3_io_lsbIns_3 = ces_3_2_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_3_io_lsbIns_4 = ces_3_2_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_3_io_lsbIns_5 = ces_3_2_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_3_io_lsbIns_6 = ces_3_2_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_3_io_lsbIns_7 = ces_3_2_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_4_clock = clock;
  assign ces_3_4_io_ins_down = ces_4_4_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_3_4_io_ins_right = ces_3_3_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_3_4_io_ins_up = ces_2_4_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_3_4_io_ins_left = ces_3_5_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_3_4_io_lsbIns_1 = ces_3_3_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_4_io_lsbIns_2 = ces_3_3_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_4_io_lsbIns_3 = ces_3_3_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_4_io_lsbIns_4 = ces_3_3_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_4_io_lsbIns_5 = ces_3_3_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_4_io_lsbIns_6 = ces_3_3_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_4_io_lsbIns_7 = ces_3_3_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_5_clock = clock;
  assign ces_3_5_io_ins_down = ces_4_5_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_3_5_io_ins_right = ces_3_4_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_3_5_io_ins_up = ces_2_5_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_3_5_io_ins_left = ces_3_6_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_3_5_io_lsbIns_1 = ces_3_4_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_5_io_lsbIns_2 = ces_3_4_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_5_io_lsbIns_3 = ces_3_4_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_5_io_lsbIns_4 = ces_3_4_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_5_io_lsbIns_5 = ces_3_4_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_5_io_lsbIns_6 = ces_3_4_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_5_io_lsbIns_7 = ces_3_4_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_6_clock = clock;
  assign ces_3_6_io_ins_down = ces_4_6_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_3_6_io_ins_right = ces_3_5_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_3_6_io_ins_up = ces_2_6_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_3_6_io_ins_left = ces_3_7_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_3_6_io_lsbIns_1 = ces_3_5_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_6_io_lsbIns_2 = ces_3_5_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_6_io_lsbIns_3 = ces_3_5_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_6_io_lsbIns_4 = ces_3_5_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_6_io_lsbIns_5 = ces_3_5_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_6_io_lsbIns_6 = ces_3_5_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_6_io_lsbIns_7 = ces_3_5_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_7_clock = clock;
  assign ces_3_7_io_ins_down = ces_4_7_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_3_7_io_ins_right = ces_3_6_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_3_7_io_ins_up = ces_2_7_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_3_7_io_ins_left = io_insLeft_3; // @[src/test/scala/MockArray.scala 79:96]
  assign ces_3_7_io_lsbIns_1 = ces_3_6_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_7_io_lsbIns_2 = ces_3_6_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_7_io_lsbIns_3 = ces_3_6_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_7_io_lsbIns_4 = ces_3_6_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_7_io_lsbIns_5 = ces_3_6_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_7_io_lsbIns_6 = ces_3_6_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_3_7_io_lsbIns_7 = ces_3_6_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_0_clock = clock;
  assign ces_4_0_io_ins_down = ces_5_0_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_4_0_io_ins_right = io_insRight_4; // @[src/test/scala/MockArray.scala 77:98]
  assign ces_4_0_io_ins_up = ces_3_0_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_4_0_io_ins_left = ces_4_1_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_4_0_io_lsbIns_1 = 1'h0;
  assign ces_4_0_io_lsbIns_2 = 1'h0;
  assign ces_4_0_io_lsbIns_3 = 1'h0;
  assign ces_4_0_io_lsbIns_4 = 1'h0;
  assign ces_4_0_io_lsbIns_5 = 1'h0;
  assign ces_4_0_io_lsbIns_6 = 1'h0;
  assign ces_4_0_io_lsbIns_7 = 1'h0;
  assign ces_4_1_clock = clock;
  assign ces_4_1_io_ins_down = ces_5_1_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_4_1_io_ins_right = ces_4_0_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_4_1_io_ins_up = ces_3_1_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_4_1_io_ins_left = ces_4_2_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_4_1_io_lsbIns_1 = ces_4_0_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_1_io_lsbIns_2 = ces_4_0_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_1_io_lsbIns_3 = ces_4_0_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_1_io_lsbIns_4 = ces_4_0_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_1_io_lsbIns_5 = ces_4_0_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_1_io_lsbIns_6 = ces_4_0_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_1_io_lsbIns_7 = ces_4_0_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_2_clock = clock;
  assign ces_4_2_io_ins_down = ces_5_2_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_4_2_io_ins_right = ces_4_1_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_4_2_io_ins_up = ces_3_2_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_4_2_io_ins_left = ces_4_3_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_4_2_io_lsbIns_1 = ces_4_1_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_2_io_lsbIns_2 = ces_4_1_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_2_io_lsbIns_3 = ces_4_1_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_2_io_lsbIns_4 = ces_4_1_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_2_io_lsbIns_5 = ces_4_1_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_2_io_lsbIns_6 = ces_4_1_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_2_io_lsbIns_7 = ces_4_1_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_3_clock = clock;
  assign ces_4_3_io_ins_down = ces_5_3_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_4_3_io_ins_right = ces_4_2_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_4_3_io_ins_up = ces_3_3_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_4_3_io_ins_left = ces_4_4_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_4_3_io_lsbIns_1 = ces_4_2_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_3_io_lsbIns_2 = ces_4_2_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_3_io_lsbIns_3 = ces_4_2_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_3_io_lsbIns_4 = ces_4_2_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_3_io_lsbIns_5 = ces_4_2_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_3_io_lsbIns_6 = ces_4_2_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_3_io_lsbIns_7 = ces_4_2_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_4_clock = clock;
  assign ces_4_4_io_ins_down = ces_5_4_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_4_4_io_ins_right = ces_4_3_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_4_4_io_ins_up = ces_3_4_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_4_4_io_ins_left = ces_4_5_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_4_4_io_lsbIns_1 = ces_4_3_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_4_io_lsbIns_2 = ces_4_3_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_4_io_lsbIns_3 = ces_4_3_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_4_io_lsbIns_4 = ces_4_3_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_4_io_lsbIns_5 = ces_4_3_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_4_io_lsbIns_6 = ces_4_3_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_4_io_lsbIns_7 = ces_4_3_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_5_clock = clock;
  assign ces_4_5_io_ins_down = ces_5_5_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_4_5_io_ins_right = ces_4_4_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_4_5_io_ins_up = ces_3_5_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_4_5_io_ins_left = ces_4_6_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_4_5_io_lsbIns_1 = ces_4_4_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_5_io_lsbIns_2 = ces_4_4_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_5_io_lsbIns_3 = ces_4_4_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_5_io_lsbIns_4 = ces_4_4_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_5_io_lsbIns_5 = ces_4_4_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_5_io_lsbIns_6 = ces_4_4_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_5_io_lsbIns_7 = ces_4_4_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_6_clock = clock;
  assign ces_4_6_io_ins_down = ces_5_6_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_4_6_io_ins_right = ces_4_5_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_4_6_io_ins_up = ces_3_6_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_4_6_io_ins_left = ces_4_7_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_4_6_io_lsbIns_1 = ces_4_5_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_6_io_lsbIns_2 = ces_4_5_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_6_io_lsbIns_3 = ces_4_5_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_6_io_lsbIns_4 = ces_4_5_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_6_io_lsbIns_5 = ces_4_5_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_6_io_lsbIns_6 = ces_4_5_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_6_io_lsbIns_7 = ces_4_5_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_7_clock = clock;
  assign ces_4_7_io_ins_down = ces_5_7_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_4_7_io_ins_right = ces_4_6_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_4_7_io_ins_up = ces_3_7_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_4_7_io_ins_left = io_insLeft_4; // @[src/test/scala/MockArray.scala 79:96]
  assign ces_4_7_io_lsbIns_1 = ces_4_6_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_7_io_lsbIns_2 = ces_4_6_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_7_io_lsbIns_3 = ces_4_6_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_7_io_lsbIns_4 = ces_4_6_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_7_io_lsbIns_5 = ces_4_6_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_7_io_lsbIns_6 = ces_4_6_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_4_7_io_lsbIns_7 = ces_4_6_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_0_clock = clock;
  assign ces_5_0_io_ins_down = ces_6_0_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_5_0_io_ins_right = io_insRight_5; // @[src/test/scala/MockArray.scala 77:98]
  assign ces_5_0_io_ins_up = ces_4_0_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_5_0_io_ins_left = ces_5_1_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_5_0_io_lsbIns_1 = 1'h0;
  assign ces_5_0_io_lsbIns_2 = 1'h0;
  assign ces_5_0_io_lsbIns_3 = 1'h0;
  assign ces_5_0_io_lsbIns_4 = 1'h0;
  assign ces_5_0_io_lsbIns_5 = 1'h0;
  assign ces_5_0_io_lsbIns_6 = 1'h0;
  assign ces_5_0_io_lsbIns_7 = 1'h0;
  assign ces_5_1_clock = clock;
  assign ces_5_1_io_ins_down = ces_6_1_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_5_1_io_ins_right = ces_5_0_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_5_1_io_ins_up = ces_4_1_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_5_1_io_ins_left = ces_5_2_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_5_1_io_lsbIns_1 = ces_5_0_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_1_io_lsbIns_2 = ces_5_0_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_1_io_lsbIns_3 = ces_5_0_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_1_io_lsbIns_4 = ces_5_0_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_1_io_lsbIns_5 = ces_5_0_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_1_io_lsbIns_6 = ces_5_0_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_1_io_lsbIns_7 = ces_5_0_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_2_clock = clock;
  assign ces_5_2_io_ins_down = ces_6_2_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_5_2_io_ins_right = ces_5_1_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_5_2_io_ins_up = ces_4_2_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_5_2_io_ins_left = ces_5_3_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_5_2_io_lsbIns_1 = ces_5_1_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_2_io_lsbIns_2 = ces_5_1_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_2_io_lsbIns_3 = ces_5_1_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_2_io_lsbIns_4 = ces_5_1_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_2_io_lsbIns_5 = ces_5_1_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_2_io_lsbIns_6 = ces_5_1_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_2_io_lsbIns_7 = ces_5_1_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_3_clock = clock;
  assign ces_5_3_io_ins_down = ces_6_3_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_5_3_io_ins_right = ces_5_2_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_5_3_io_ins_up = ces_4_3_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_5_3_io_ins_left = ces_5_4_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_5_3_io_lsbIns_1 = ces_5_2_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_3_io_lsbIns_2 = ces_5_2_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_3_io_lsbIns_3 = ces_5_2_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_3_io_lsbIns_4 = ces_5_2_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_3_io_lsbIns_5 = ces_5_2_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_3_io_lsbIns_6 = ces_5_2_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_3_io_lsbIns_7 = ces_5_2_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_4_clock = clock;
  assign ces_5_4_io_ins_down = ces_6_4_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_5_4_io_ins_right = ces_5_3_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_5_4_io_ins_up = ces_4_4_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_5_4_io_ins_left = ces_5_5_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_5_4_io_lsbIns_1 = ces_5_3_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_4_io_lsbIns_2 = ces_5_3_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_4_io_lsbIns_3 = ces_5_3_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_4_io_lsbIns_4 = ces_5_3_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_4_io_lsbIns_5 = ces_5_3_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_4_io_lsbIns_6 = ces_5_3_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_4_io_lsbIns_7 = ces_5_3_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_5_clock = clock;
  assign ces_5_5_io_ins_down = ces_6_5_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_5_5_io_ins_right = ces_5_4_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_5_5_io_ins_up = ces_4_5_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_5_5_io_ins_left = ces_5_6_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_5_5_io_lsbIns_1 = ces_5_4_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_5_io_lsbIns_2 = ces_5_4_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_5_io_lsbIns_3 = ces_5_4_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_5_io_lsbIns_4 = ces_5_4_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_5_io_lsbIns_5 = ces_5_4_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_5_io_lsbIns_6 = ces_5_4_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_5_io_lsbIns_7 = ces_5_4_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_6_clock = clock;
  assign ces_5_6_io_ins_down = ces_6_6_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_5_6_io_ins_right = ces_5_5_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_5_6_io_ins_up = ces_4_6_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_5_6_io_ins_left = ces_5_7_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_5_6_io_lsbIns_1 = ces_5_5_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_6_io_lsbIns_2 = ces_5_5_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_6_io_lsbIns_3 = ces_5_5_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_6_io_lsbIns_4 = ces_5_5_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_6_io_lsbIns_5 = ces_5_5_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_6_io_lsbIns_6 = ces_5_5_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_6_io_lsbIns_7 = ces_5_5_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_7_clock = clock;
  assign ces_5_7_io_ins_down = ces_6_7_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_5_7_io_ins_right = ces_5_6_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_5_7_io_ins_up = ces_4_7_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_5_7_io_ins_left = io_insLeft_5; // @[src/test/scala/MockArray.scala 79:96]
  assign ces_5_7_io_lsbIns_1 = ces_5_6_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_7_io_lsbIns_2 = ces_5_6_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_7_io_lsbIns_3 = ces_5_6_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_7_io_lsbIns_4 = ces_5_6_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_7_io_lsbIns_5 = ces_5_6_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_7_io_lsbIns_6 = ces_5_6_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_5_7_io_lsbIns_7 = ces_5_6_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_0_clock = clock;
  assign ces_6_0_io_ins_down = ces_7_0_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_6_0_io_ins_right = io_insRight_6; // @[src/test/scala/MockArray.scala 77:98]
  assign ces_6_0_io_ins_up = ces_5_0_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_6_0_io_ins_left = ces_6_1_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_6_0_io_lsbIns_1 = 1'h0;
  assign ces_6_0_io_lsbIns_2 = 1'h0;
  assign ces_6_0_io_lsbIns_3 = 1'h0;
  assign ces_6_0_io_lsbIns_4 = 1'h0;
  assign ces_6_0_io_lsbIns_5 = 1'h0;
  assign ces_6_0_io_lsbIns_6 = 1'h0;
  assign ces_6_0_io_lsbIns_7 = 1'h0;
  assign ces_6_1_clock = clock;
  assign ces_6_1_io_ins_down = ces_7_1_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_6_1_io_ins_right = ces_6_0_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_6_1_io_ins_up = ces_5_1_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_6_1_io_ins_left = ces_6_2_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_6_1_io_lsbIns_1 = ces_6_0_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_1_io_lsbIns_2 = ces_6_0_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_1_io_lsbIns_3 = ces_6_0_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_1_io_lsbIns_4 = ces_6_0_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_1_io_lsbIns_5 = ces_6_0_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_1_io_lsbIns_6 = ces_6_0_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_1_io_lsbIns_7 = ces_6_0_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_2_clock = clock;
  assign ces_6_2_io_ins_down = ces_7_2_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_6_2_io_ins_right = ces_6_1_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_6_2_io_ins_up = ces_5_2_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_6_2_io_ins_left = ces_6_3_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_6_2_io_lsbIns_1 = ces_6_1_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_2_io_lsbIns_2 = ces_6_1_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_2_io_lsbIns_3 = ces_6_1_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_2_io_lsbIns_4 = ces_6_1_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_2_io_lsbIns_5 = ces_6_1_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_2_io_lsbIns_6 = ces_6_1_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_2_io_lsbIns_7 = ces_6_1_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_3_clock = clock;
  assign ces_6_3_io_ins_down = ces_7_3_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_6_3_io_ins_right = ces_6_2_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_6_3_io_ins_up = ces_5_3_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_6_3_io_ins_left = ces_6_4_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_6_3_io_lsbIns_1 = ces_6_2_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_3_io_lsbIns_2 = ces_6_2_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_3_io_lsbIns_3 = ces_6_2_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_3_io_lsbIns_4 = ces_6_2_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_3_io_lsbIns_5 = ces_6_2_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_3_io_lsbIns_6 = ces_6_2_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_3_io_lsbIns_7 = ces_6_2_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_4_clock = clock;
  assign ces_6_4_io_ins_down = ces_7_4_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_6_4_io_ins_right = ces_6_3_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_6_4_io_ins_up = ces_5_4_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_6_4_io_ins_left = ces_6_5_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_6_4_io_lsbIns_1 = ces_6_3_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_4_io_lsbIns_2 = ces_6_3_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_4_io_lsbIns_3 = ces_6_3_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_4_io_lsbIns_4 = ces_6_3_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_4_io_lsbIns_5 = ces_6_3_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_4_io_lsbIns_6 = ces_6_3_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_4_io_lsbIns_7 = ces_6_3_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_5_clock = clock;
  assign ces_6_5_io_ins_down = ces_7_5_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_6_5_io_ins_right = ces_6_4_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_6_5_io_ins_up = ces_5_5_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_6_5_io_ins_left = ces_6_6_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_6_5_io_lsbIns_1 = ces_6_4_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_5_io_lsbIns_2 = ces_6_4_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_5_io_lsbIns_3 = ces_6_4_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_5_io_lsbIns_4 = ces_6_4_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_5_io_lsbIns_5 = ces_6_4_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_5_io_lsbIns_6 = ces_6_4_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_5_io_lsbIns_7 = ces_6_4_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_6_clock = clock;
  assign ces_6_6_io_ins_down = ces_7_6_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_6_6_io_ins_right = ces_6_5_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_6_6_io_ins_up = ces_5_6_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_6_6_io_ins_left = ces_6_7_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_6_6_io_lsbIns_1 = ces_6_5_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_6_io_lsbIns_2 = ces_6_5_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_6_io_lsbIns_3 = ces_6_5_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_6_io_lsbIns_4 = ces_6_5_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_6_io_lsbIns_5 = ces_6_5_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_6_io_lsbIns_6 = ces_6_5_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_6_io_lsbIns_7 = ces_6_5_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_7_clock = clock;
  assign ces_6_7_io_ins_down = ces_7_7_io_outs_down; // @[src/test/scala/MockArray.scala 98:35]
  assign ces_6_7_io_ins_right = ces_6_6_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_6_7_io_ins_up = ces_5_7_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_6_7_io_ins_left = io_insLeft_6; // @[src/test/scala/MockArray.scala 79:96]
  assign ces_6_7_io_lsbIns_1 = ces_6_6_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_7_io_lsbIns_2 = ces_6_6_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_7_io_lsbIns_3 = ces_6_6_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_7_io_lsbIns_4 = ces_6_6_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_7_io_lsbIns_5 = ces_6_6_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_7_io_lsbIns_6 = ces_6_6_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_6_7_io_lsbIns_7 = ces_6_6_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_0_clock = clock;
  assign ces_7_0_io_ins_down = io_insDown_0; // @[src/test/scala/MockArray.scala 78:89]
  assign ces_7_0_io_ins_right = io_insRight_7; // @[src/test/scala/MockArray.scala 77:98]
  assign ces_7_0_io_ins_up = ces_6_0_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_7_0_io_ins_left = ces_7_1_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_7_0_io_lsbIns_1 = 1'h0;
  assign ces_7_0_io_lsbIns_2 = 1'h0;
  assign ces_7_0_io_lsbIns_3 = 1'h0;
  assign ces_7_0_io_lsbIns_4 = 1'h0;
  assign ces_7_0_io_lsbIns_5 = 1'h0;
  assign ces_7_0_io_lsbIns_6 = 1'h0;
  assign ces_7_0_io_lsbIns_7 = 1'h0;
  assign ces_7_1_clock = clock;
  assign ces_7_1_io_ins_down = io_insDown_1; // @[src/test/scala/MockArray.scala 78:89]
  assign ces_7_1_io_ins_right = ces_7_0_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_7_1_io_ins_up = ces_6_1_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_7_1_io_ins_left = ces_7_2_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_7_1_io_lsbIns_1 = ces_7_0_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_1_io_lsbIns_2 = ces_7_0_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_1_io_lsbIns_3 = ces_7_0_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_1_io_lsbIns_4 = ces_7_0_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_1_io_lsbIns_5 = ces_7_0_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_1_io_lsbIns_6 = ces_7_0_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_1_io_lsbIns_7 = ces_7_0_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_2_clock = clock;
  assign ces_7_2_io_ins_down = io_insDown_2; // @[src/test/scala/MockArray.scala 78:89]
  assign ces_7_2_io_ins_right = ces_7_1_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_7_2_io_ins_up = ces_6_2_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_7_2_io_ins_left = ces_7_3_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_7_2_io_lsbIns_1 = ces_7_1_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_2_io_lsbIns_2 = ces_7_1_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_2_io_lsbIns_3 = ces_7_1_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_2_io_lsbIns_4 = ces_7_1_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_2_io_lsbIns_5 = ces_7_1_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_2_io_lsbIns_6 = ces_7_1_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_2_io_lsbIns_7 = ces_7_1_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_3_clock = clock;
  assign ces_7_3_io_ins_down = io_insDown_3; // @[src/test/scala/MockArray.scala 78:89]
  assign ces_7_3_io_ins_right = ces_7_2_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_7_3_io_ins_up = ces_6_3_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_7_3_io_ins_left = ces_7_4_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_7_3_io_lsbIns_1 = ces_7_2_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_3_io_lsbIns_2 = ces_7_2_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_3_io_lsbIns_3 = ces_7_2_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_3_io_lsbIns_4 = ces_7_2_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_3_io_lsbIns_5 = ces_7_2_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_3_io_lsbIns_6 = ces_7_2_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_3_io_lsbIns_7 = ces_7_2_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_4_clock = clock;
  assign ces_7_4_io_ins_down = io_insDown_4; // @[src/test/scala/MockArray.scala 78:89]
  assign ces_7_4_io_ins_right = ces_7_3_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_7_4_io_ins_up = ces_6_4_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_7_4_io_ins_left = ces_7_5_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_7_4_io_lsbIns_1 = ces_7_3_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_4_io_lsbIns_2 = ces_7_3_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_4_io_lsbIns_3 = ces_7_3_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_4_io_lsbIns_4 = ces_7_3_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_4_io_lsbIns_5 = ces_7_3_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_4_io_lsbIns_6 = ces_7_3_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_4_io_lsbIns_7 = ces_7_3_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_5_clock = clock;
  assign ces_7_5_io_ins_down = io_insDown_5; // @[src/test/scala/MockArray.scala 78:89]
  assign ces_7_5_io_ins_right = ces_7_4_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_7_5_io_ins_up = ces_6_5_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_7_5_io_ins_left = ces_7_6_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_7_5_io_lsbIns_1 = ces_7_4_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_5_io_lsbIns_2 = ces_7_4_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_5_io_lsbIns_3 = ces_7_4_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_5_io_lsbIns_4 = ces_7_4_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_5_io_lsbIns_5 = ces_7_4_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_5_io_lsbIns_6 = ces_7_4_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_5_io_lsbIns_7 = ces_7_4_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_6_clock = clock;
  assign ces_7_6_io_ins_down = io_insDown_6; // @[src/test/scala/MockArray.scala 78:89]
  assign ces_7_6_io_ins_right = ces_7_5_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_7_6_io_ins_up = ces_6_6_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_7_6_io_ins_left = ces_7_7_io_outs_left; // @[src/test/scala/MockArray.scala 91:35]
  assign ces_7_6_io_lsbIns_1 = ces_7_5_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_6_io_lsbIns_2 = ces_7_5_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_6_io_lsbIns_3 = ces_7_5_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_6_io_lsbIns_4 = ces_7_5_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_6_io_lsbIns_5 = ces_7_5_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_6_io_lsbIns_6 = ces_7_5_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_6_io_lsbIns_7 = ces_7_5_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_7_clock = clock;
  assign ces_7_7_io_ins_down = io_insDown_7; // @[src/test/scala/MockArray.scala 78:89]
  assign ces_7_7_io_ins_right = ces_7_6_io_outs_right; // @[src/test/scala/MockArray.scala 92:36]
  assign ces_7_7_io_ins_up = ces_6_7_io_outs_up; // @[src/test/scala/MockArray.scala 99:33]
  assign ces_7_7_io_ins_left = io_insLeft_7; // @[src/test/scala/MockArray.scala 79:96]
  assign ces_7_7_io_lsbIns_1 = ces_7_6_io_lsbOuts_1; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_7_io_lsbIns_2 = ces_7_6_io_lsbOuts_2; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_7_io_lsbIns_3 = ces_7_6_io_lsbOuts_3; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_7_io_lsbIns_4 = ces_7_6_io_lsbOuts_4; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_7_io_lsbIns_5 = ces_7_6_io_lsbOuts_5; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_7_io_lsbIns_6 = ces_7_6_io_lsbOuts_6; // @[src/test/scala/MockArray.scala 71:25]
  assign ces_7_7_io_lsbIns_7 = ces_7_6_io_lsbOuts_7; // @[src/test/scala/MockArray.scala 71:25]
endmodule
