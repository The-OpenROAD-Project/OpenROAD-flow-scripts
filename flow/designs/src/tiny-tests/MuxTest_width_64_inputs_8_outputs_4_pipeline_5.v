module MuxTest_width_64_inputs_8_outputs_4_pipeline_5( // @[:@3.2]
  input         clock, // @[:@4.4]
  input         reset, // @[:@5.4]
  input  [2:0]  io_selects_0_0, // @[:@6.4]
  input  [2:0]  io_selects_0_1, // @[:@6.4]
  input  [2:0]  io_selects_1_0, // @[:@6.4]
  input  [2:0]  io_selects_1_1, // @[:@6.4]
  input  [2:0]  io_selects_2_0, // @[:@6.4]
  input  [2:0]  io_selects_2_1, // @[:@6.4]
  input  [2:0]  io_selects_3_0, // @[:@6.4]
  input  [2:0]  io_selects_3_1, // @[:@6.4]
  input  [2:0]  io_operation_0, // @[:@6.4]
  input  [2:0]  io_operation_1, // @[:@6.4]
  input  [2:0]  io_operation_2, // @[:@6.4]
  input  [2:0]  io_operation_3, // @[:@6.4]
  input  [63:0] io_inputs_0, // @[:@6.4]
  input  [63:0] io_inputs_1, // @[:@6.4]
  input  [63:0] io_inputs_2, // @[:@6.4]
  input  [63:0] io_inputs_3, // @[:@6.4]
  input  [63:0] io_inputs_4, // @[:@6.4]
  input  [63:0] io_inputs_5, // @[:@6.4]
  input  [63:0] io_inputs_6, // @[:@6.4]
  input  [63:0] io_inputs_7, // @[:@6.4]
  output [63:0] io_outputs_0, // @[:@6.4]
  output [63:0] io_outputs_1, // @[:@6.4]
  output [63:0] io_outputs_2, // @[:@6.4]
  output [63:0] io_outputs_3 // @[:@6.4]
);
  wire [63:0] _GEN_1; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire [63:0] _GEN_2; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire [63:0] _GEN_3; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire [63:0] _GEN_4; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire [63:0] _GEN_5; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire [63:0] _GEN_6; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire [63:0] _GEN_7; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire [63:0] _GEN_9; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire [63:0] _GEN_10; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire [63:0] _GEN_11; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire [63:0] _GEN_12; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire [63:0] _GEN_13; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire [63:0] _GEN_14; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire [63:0] _GEN_15; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire [64:0] _T_250; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire [63:0] _T_251; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@9.4]
  wire [127:0] _T_253; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 33:58:@10.4]
  wire [63:0] _T_255; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 34:56:@11.4]
  wire  _T_256; // @[Mux.scala 46:19:@12.4]
  wire [63:0] _T_257; // @[Mux.scala 46:16:@13.4]
  wire  _T_258; // @[Mux.scala 46:19:@14.4]
  wire [127:0] _T_259; // @[Mux.scala 46:16:@15.4]
  wire  _T_260; // @[Mux.scala 46:19:@16.4]
  wire [127:0] _T_261; // @[Mux.scala 46:16:@17.4]
  wire  _T_262; // @[Mux.scala 46:19:@18.4]
  wire [63:0] _GEN_17; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire [63:0] _GEN_18; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire [63:0] _GEN_19; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire [63:0] _GEN_20; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire [63:0] _GEN_21; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire [63:0] _GEN_22; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire [63:0] _GEN_23; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire [63:0] _GEN_25; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire [63:0] _GEN_26; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire [63:0] _GEN_27; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire [63:0] _GEN_28; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire [63:0] _GEN_29; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire [63:0] _GEN_30; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire [63:0] _GEN_31; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire [64:0] _T_267; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire [63:0] _T_268; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@21.4]
  wire [127:0] _T_270; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 33:58:@22.4]
  wire [63:0] _T_272; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 34:56:@23.4]
  wire  _T_273; // @[Mux.scala 46:19:@24.4]
  wire [63:0] _T_274; // @[Mux.scala 46:16:@25.4]
  wire  _T_275; // @[Mux.scala 46:19:@26.4]
  wire [127:0] _T_276; // @[Mux.scala 46:16:@27.4]
  wire  _T_277; // @[Mux.scala 46:19:@28.4]
  wire [127:0] _T_278; // @[Mux.scala 46:16:@29.4]
  wire  _T_279; // @[Mux.scala 46:19:@30.4]
  wire [63:0] _GEN_33; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire [63:0] _GEN_34; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire [63:0] _GEN_35; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire [63:0] _GEN_36; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire [63:0] _GEN_37; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire [63:0] _GEN_38; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire [63:0] _GEN_39; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire [63:0] _GEN_41; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire [63:0] _GEN_42; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire [63:0] _GEN_43; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire [63:0] _GEN_44; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire [63:0] _GEN_45; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire [63:0] _GEN_46; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire [63:0] _GEN_47; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire [64:0] _T_284; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire [63:0] _T_285; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@33.4]
  wire [127:0] _T_287; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 33:58:@34.4]
  wire [63:0] _T_289; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 34:56:@35.4]
  wire  _T_290; // @[Mux.scala 46:19:@36.4]
  wire [63:0] _T_291; // @[Mux.scala 46:16:@37.4]
  wire  _T_292; // @[Mux.scala 46:19:@38.4]
  wire [127:0] _T_293; // @[Mux.scala 46:16:@39.4]
  wire  _T_294; // @[Mux.scala 46:19:@40.4]
  wire [127:0] _T_295; // @[Mux.scala 46:16:@41.4]
  wire  _T_296; // @[Mux.scala 46:19:@42.4]
  wire [63:0] _GEN_49; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire [63:0] _GEN_50; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire [63:0] _GEN_51; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire [63:0] _GEN_52; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire [63:0] _GEN_53; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire [63:0] _GEN_54; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire [63:0] _GEN_55; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire [63:0] _GEN_57; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire [63:0] _GEN_58; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire [63:0] _GEN_59; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire [63:0] _GEN_60; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire [63:0] _GEN_61; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire [63:0] _GEN_62; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire [63:0] _GEN_63; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire [64:0] _T_301; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire [63:0] _T_302; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@45.4]
  wire [127:0] _T_304; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 33:58:@46.4]
  wire [63:0] _T_306; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 34:56:@47.4]
  wire  _T_307; // @[Mux.scala 46:19:@48.4]
  wire [63:0] _T_308; // @[Mux.scala 46:16:@49.4]
  wire  _T_309; // @[Mux.scala 46:19:@50.4]
  wire [127:0] _T_310; // @[Mux.scala 46:16:@51.4]
  wire  _T_311; // @[Mux.scala 46:19:@52.4]
  wire [127:0] _T_312; // @[Mux.scala 46:16:@53.4]
  wire  _T_313; // @[Mux.scala 46:19:@54.4]
  reg [127:0] _T_317; // @[Reg.scala 11:16:@56.4]
  reg [127:0] _RAND_0;
  reg [127:0] _T_319; // @[Reg.scala 11:16:@60.4]
  reg [127:0] _RAND_1;
  reg [127:0] _T_321; // @[Reg.scala 11:16:@64.4]
  reg [127:0] _RAND_2;
  reg [127:0] _T_323; // @[Reg.scala 11:16:@68.4]
  reg [127:0] _RAND_3;
  reg [127:0] _T_325; // @[Reg.scala 11:16:@72.4]
  reg [127:0] _RAND_4;
  reg [127:0] _T_328; // @[Reg.scala 11:16:@76.4]
  reg [127:0] _RAND_5;
  reg [127:0] _T_330; // @[Reg.scala 11:16:@80.4]
  reg [127:0] _RAND_6;
  reg [127:0] _T_332; // @[Reg.scala 11:16:@84.4]
  reg [127:0] _RAND_7;
  reg [127:0] _T_334; // @[Reg.scala 11:16:@88.4]
  reg [127:0] _RAND_8;
  reg [127:0] _T_336; // @[Reg.scala 11:16:@92.4]
  reg [127:0] _RAND_9;
  reg [127:0] _T_339; // @[Reg.scala 11:16:@96.4]
  reg [127:0] _RAND_10;
  reg [127:0] _T_341; // @[Reg.scala 11:16:@100.4]
  reg [127:0] _RAND_11;
  reg [127:0] _T_343; // @[Reg.scala 11:16:@104.4]
  reg [127:0] _RAND_12;
  reg [127:0] _T_345; // @[Reg.scala 11:16:@108.4]
  reg [127:0] _RAND_13;
  reg [127:0] _T_347; // @[Reg.scala 11:16:@112.4]
  reg [127:0] _RAND_14;
  reg [127:0] _T_350; // @[Reg.scala 11:16:@116.4]
  reg [127:0] _RAND_15;
  reg [127:0] _T_352; // @[Reg.scala 11:16:@120.4]
  reg [127:0] _RAND_16;
  reg [127:0] _T_354; // @[Reg.scala 11:16:@124.4]
  reg [127:0] _RAND_17;
  reg [127:0] _T_356; // @[Reg.scala 11:16:@128.4]
  reg [127:0] _RAND_18;
  reg [127:0] _T_358; // @[Reg.scala 11:16:@132.4]
  reg [127:0] _RAND_19;
  assign _GEN_1 = 3'h1 == io_selects_0_0 ? io_inputs_1 : io_inputs_0; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_2 = 3'h2 == io_selects_0_0 ? io_inputs_2 : _GEN_1; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_3 = 3'h3 == io_selects_0_0 ? io_inputs_3 : _GEN_2; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_4 = 3'h4 == io_selects_0_0 ? io_inputs_4 : _GEN_3; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_5 = 3'h5 == io_selects_0_0 ? io_inputs_5 : _GEN_4; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_6 = 3'h6 == io_selects_0_0 ? io_inputs_6 : _GEN_5; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_7 = 3'h7 == io_selects_0_0 ? io_inputs_7 : _GEN_6; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_9 = 3'h1 == io_selects_0_1 ? io_inputs_1 : io_inputs_0; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_10 = 3'h2 == io_selects_0_1 ? io_inputs_2 : _GEN_9; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_11 = 3'h3 == io_selects_0_1 ? io_inputs_3 : _GEN_10; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_12 = 3'h4 == io_selects_0_1 ? io_inputs_4 : _GEN_11; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_13 = 3'h5 == io_selects_0_1 ? io_inputs_5 : _GEN_12; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_14 = 3'h6 == io_selects_0_1 ? io_inputs_6 : _GEN_13; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_15 = 3'h7 == io_selects_0_1 ? io_inputs_7 : _GEN_14; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _T_250 = _GEN_7 + _GEN_15; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _T_251 = _GEN_7 + _GEN_15; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@9.4]
  assign _T_253 = _GEN_7 * _GEN_15; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 33:58:@10.4]
  assign _T_255 = _GEN_7 / _GEN_15; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 34:56:@11.4]
  assign _T_256 = 3'h3 == io_operation_0; // @[Mux.scala 46:19:@12.4]
  assign _T_257 = _T_256 ? _T_255 : 64'h0; // @[Mux.scala 46:16:@13.4]
  assign _T_258 = 3'h2 == io_operation_0; // @[Mux.scala 46:19:@14.4]
  assign _T_259 = _T_258 ? _T_253 : {{64'd0}, _T_257}; // @[Mux.scala 46:16:@15.4]
  assign _T_260 = 3'h1 == io_operation_0; // @[Mux.scala 46:19:@16.4]
  assign _T_261 = _T_260 ? {{64'd0}, _T_251} : _T_259; // @[Mux.scala 46:16:@17.4]
  assign _T_262 = 3'h0 == io_operation_0; // @[Mux.scala 46:19:@18.4]
  assign _GEN_17 = 3'h1 == io_selects_1_0 ? io_inputs_1 : io_inputs_0; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_18 = 3'h2 == io_selects_1_0 ? io_inputs_2 : _GEN_17; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_19 = 3'h3 == io_selects_1_0 ? io_inputs_3 : _GEN_18; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_20 = 3'h4 == io_selects_1_0 ? io_inputs_4 : _GEN_19; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_21 = 3'h5 == io_selects_1_0 ? io_inputs_5 : _GEN_20; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_22 = 3'h6 == io_selects_1_0 ? io_inputs_6 : _GEN_21; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_23 = 3'h7 == io_selects_1_0 ? io_inputs_7 : _GEN_22; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_25 = 3'h1 == io_selects_1_1 ? io_inputs_1 : io_inputs_0; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_26 = 3'h2 == io_selects_1_1 ? io_inputs_2 : _GEN_25; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_27 = 3'h3 == io_selects_1_1 ? io_inputs_3 : _GEN_26; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_28 = 3'h4 == io_selects_1_1 ? io_inputs_4 : _GEN_27; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_29 = 3'h5 == io_selects_1_1 ? io_inputs_5 : _GEN_28; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_30 = 3'h6 == io_selects_1_1 ? io_inputs_6 : _GEN_29; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_31 = 3'h7 == io_selects_1_1 ? io_inputs_7 : _GEN_30; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _T_267 = _GEN_23 + _GEN_31; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _T_268 = _GEN_23 + _GEN_31; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@21.4]
  assign _T_270 = _GEN_23 * _GEN_31; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 33:58:@22.4]
  assign _T_272 = _GEN_23 / _GEN_31; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 34:56:@23.4]
  assign _T_273 = 3'h3 == io_operation_1; // @[Mux.scala 46:19:@24.4]
  assign _T_274 = _T_273 ? _T_272 : 64'h0; // @[Mux.scala 46:16:@25.4]
  assign _T_275 = 3'h2 == io_operation_1; // @[Mux.scala 46:19:@26.4]
  assign _T_276 = _T_275 ? _T_270 : {{64'd0}, _T_274}; // @[Mux.scala 46:16:@27.4]
  assign _T_277 = 3'h1 == io_operation_1; // @[Mux.scala 46:19:@28.4]
  assign _T_278 = _T_277 ? {{64'd0}, _T_268} : _T_276; // @[Mux.scala 46:16:@29.4]
  assign _T_279 = 3'h0 == io_operation_1; // @[Mux.scala 46:19:@30.4]
  assign _GEN_33 = 3'h1 == io_selects_2_0 ? io_inputs_1 : io_inputs_0; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_34 = 3'h2 == io_selects_2_0 ? io_inputs_2 : _GEN_33; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_35 = 3'h3 == io_selects_2_0 ? io_inputs_3 : _GEN_34; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_36 = 3'h4 == io_selects_2_0 ? io_inputs_4 : _GEN_35; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_37 = 3'h5 == io_selects_2_0 ? io_inputs_5 : _GEN_36; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_38 = 3'h6 == io_selects_2_0 ? io_inputs_6 : _GEN_37; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_39 = 3'h7 == io_selects_2_0 ? io_inputs_7 : _GEN_38; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_41 = 3'h1 == io_selects_2_1 ? io_inputs_1 : io_inputs_0; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_42 = 3'h2 == io_selects_2_1 ? io_inputs_2 : _GEN_41; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_43 = 3'h3 == io_selects_2_1 ? io_inputs_3 : _GEN_42; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_44 = 3'h4 == io_selects_2_1 ? io_inputs_4 : _GEN_43; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_45 = 3'h5 == io_selects_2_1 ? io_inputs_5 : _GEN_44; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_46 = 3'h6 == io_selects_2_1 ? io_inputs_6 : _GEN_45; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_47 = 3'h7 == io_selects_2_1 ? io_inputs_7 : _GEN_46; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _T_284 = _GEN_39 + _GEN_47; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _T_285 = _GEN_39 + _GEN_47; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@33.4]
  assign _T_287 = _GEN_39 * _GEN_47; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 33:58:@34.4]
  assign _T_289 = _GEN_39 / _GEN_47; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 34:56:@35.4]
  assign _T_290 = 3'h3 == io_operation_2; // @[Mux.scala 46:19:@36.4]
  assign _T_291 = _T_290 ? _T_289 : 64'h0; // @[Mux.scala 46:16:@37.4]
  assign _T_292 = 3'h2 == io_operation_2; // @[Mux.scala 46:19:@38.4]
  assign _T_293 = _T_292 ? _T_287 : {{64'd0}, _T_291}; // @[Mux.scala 46:16:@39.4]
  assign _T_294 = 3'h1 == io_operation_2; // @[Mux.scala 46:19:@40.4]
  assign _T_295 = _T_294 ? {{64'd0}, _T_285} : _T_293; // @[Mux.scala 46:16:@41.4]
  assign _T_296 = 3'h0 == io_operation_2; // @[Mux.scala 46:19:@42.4]
  assign _GEN_49 = 3'h1 == io_selects_3_0 ? io_inputs_1 : io_inputs_0; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_50 = 3'h2 == io_selects_3_0 ? io_inputs_2 : _GEN_49; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_51 = 3'h3 == io_selects_3_0 ? io_inputs_3 : _GEN_50; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_52 = 3'h4 == io_selects_3_0 ? io_inputs_4 : _GEN_51; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_53 = 3'h5 == io_selects_3_0 ? io_inputs_5 : _GEN_52; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_54 = 3'h6 == io_selects_3_0 ? io_inputs_6 : _GEN_53; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_55 = 3'h7 == io_selects_3_0 ? io_inputs_7 : _GEN_54; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_57 = 3'h1 == io_selects_3_1 ? io_inputs_1 : io_inputs_0; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_58 = 3'h2 == io_selects_3_1 ? io_inputs_2 : _GEN_57; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_59 = 3'h3 == io_selects_3_1 ? io_inputs_3 : _GEN_58; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_60 = 3'h4 == io_selects_3_1 ? io_inputs_4 : _GEN_59; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_61 = 3'h5 == io_selects_3_1 ? io_inputs_5 : _GEN_60; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_62 = 3'h6 == io_selects_3_1 ? io_inputs_6 : _GEN_61; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_63 = 3'h7 == io_selects_3_1 ? io_inputs_7 : _GEN_62; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _T_301 = _GEN_55 + _GEN_63; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _T_302 = _GEN_55 + _GEN_63; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 32:53:@45.4]
  assign _T_304 = _GEN_55 * _GEN_63; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 33:58:@46.4]
  assign _T_306 = _GEN_55 / _GEN_63; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 34:56:@47.4]
  assign _T_307 = 3'h3 == io_operation_3; // @[Mux.scala 46:19:@48.4]
  assign _T_308 = _T_307 ? _T_306 : 64'h0; // @[Mux.scala 46:16:@49.4]
  assign _T_309 = 3'h2 == io_operation_3; // @[Mux.scala 46:19:@50.4]
  assign _T_310 = _T_309 ? _T_304 : {{64'd0}, _T_308}; // @[Mux.scala 46:16:@51.4]
  assign _T_311 = 3'h1 == io_operation_3; // @[Mux.scala 46:19:@52.4]
  assign _T_312 = _T_311 ? {{64'd0}, _T_302} : _T_310; // @[Mux.scala 46:16:@53.4]
  assign _T_313 = 3'h0 == io_operation_3; // @[Mux.scala 46:19:@54.4]
  assign io_outputs_0 = _T_325[63:0]; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 23:14:@136.4]
  assign io_outputs_1 = _T_336[63:0]; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 23:14:@137.4]
  assign io_outputs_2 = _T_347[63:0]; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 23:14:@138.4]
  assign io_outputs_3 = _T_358[63:0]; // @[MuxTest_width_64_inputs_8_outputs_4_pipeline_5s.scala 23:14:@139.4]
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
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {4{`RANDOM}};
  _T_317 = _RAND_0[127:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {4{`RANDOM}};
  _T_319 = _RAND_1[127:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {4{`RANDOM}};
  _T_321 = _RAND_2[127:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {4{`RANDOM}};
  _T_323 = _RAND_3[127:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {4{`RANDOM}};
  _T_325 = _RAND_4[127:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {4{`RANDOM}};
  _T_328 = _RAND_5[127:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_6 = {4{`RANDOM}};
  _T_330 = _RAND_6[127:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_7 = {4{`RANDOM}};
  _T_332 = _RAND_7[127:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_8 = {4{`RANDOM}};
  _T_334 = _RAND_8[127:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_9 = {4{`RANDOM}};
  _T_336 = _RAND_9[127:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_10 = {4{`RANDOM}};
  _T_339 = _RAND_10[127:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_11 = {4{`RANDOM}};
  _T_341 = _RAND_11[127:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_12 = {4{`RANDOM}};
  _T_343 = _RAND_12[127:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_13 = {4{`RANDOM}};
  _T_345 = _RAND_13[127:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_14 = {4{`RANDOM}};
  _T_347 = _RAND_14[127:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_15 = {4{`RANDOM}};
  _T_350 = _RAND_15[127:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_16 = {4{`RANDOM}};
  _T_352 = _RAND_16[127:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_17 = {4{`RANDOM}};
  _T_354 = _RAND_17[127:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_18 = {4{`RANDOM}};
  _T_356 = _RAND_18[127:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_19 = {4{`RANDOM}};
  _T_358 = _RAND_19[127:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (_T_262) begin
      _T_317 <= {{64'd0}, _GEN_7};
    end else begin
      _T_317 <= _T_261;
    end
    _T_319 <= _T_317;
    _T_321 <= _T_319;
    _T_323 <= _T_321;
    _T_325 <= _T_323;
    if (_T_279) begin
      _T_328 <= {{64'd0}, _GEN_23};
    end else begin
      _T_328 <= _T_278;
    end
    _T_330 <= _T_328;
    _T_332 <= _T_330;
    _T_334 <= _T_332;
    _T_336 <= _T_334;
    if (_T_296) begin
      _T_339 <= {{64'd0}, _GEN_39};
    end else begin
      _T_339 <= _T_295;
    end
    _T_341 <= _T_339;
    _T_343 <= _T_341;
    _T_345 <= _T_343;
    _T_347 <= _T_345;
    if (_T_313) begin
      _T_350 <= {{64'd0}, _GEN_55};
    end else begin
      _T_350 <= _T_312;
    end
    _T_352 <= _T_350;
    _T_354 <= _T_352;
    _T_356 <= _T_354;
    _T_358 <= _T_356;
  end
endmodule
