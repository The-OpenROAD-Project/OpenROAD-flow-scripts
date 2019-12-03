module MuxTest_width_1_inputs_16_outputs_4_pipeline_5( // @[:@3.2]
  input        clock, // @[:@4.4]
  input        reset, // @[:@5.4]
  input  [3:0] io_selects_0_0, // @[:@6.4]
  input  [3:0] io_selects_0_1, // @[:@6.4]
  input  [3:0] io_selects_1_0, // @[:@6.4]
  input  [3:0] io_selects_1_1, // @[:@6.4]
  input  [3:0] io_selects_2_0, // @[:@6.4]
  input  [3:0] io_selects_2_1, // @[:@6.4]
  input  [3:0] io_selects_3_0, // @[:@6.4]
  input  [3:0] io_selects_3_1, // @[:@6.4]
  input  [2:0] io_operation_0, // @[:@6.4]
  input  [2:0] io_operation_1, // @[:@6.4]
  input  [2:0] io_operation_2, // @[:@6.4]
  input  [2:0] io_operation_3, // @[:@6.4]
  input        io_inputs_0, // @[:@6.4]
  input        io_inputs_1, // @[:@6.4]
  input        io_inputs_2, // @[:@6.4]
  input        io_inputs_3, // @[:@6.4]
  input        io_inputs_4, // @[:@6.4]
  input        io_inputs_5, // @[:@6.4]
  input        io_inputs_6, // @[:@6.4]
  input        io_inputs_7, // @[:@6.4]
  input        io_inputs_8, // @[:@6.4]
  input        io_inputs_9, // @[:@6.4]
  input        io_inputs_10, // @[:@6.4]
  input        io_inputs_11, // @[:@6.4]
  input        io_inputs_12, // @[:@6.4]
  input        io_inputs_13, // @[:@6.4]
  input        io_inputs_14, // @[:@6.4]
  input        io_inputs_15, // @[:@6.4]
  output       io_outputs_0, // @[:@6.4]
  output       io_outputs_1, // @[:@6.4]
  output       io_outputs_2, // @[:@6.4]
  output       io_outputs_3 // @[:@6.4]
);
  wire  _GEN_1; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_2; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_3; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_4; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_5; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_6; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_7; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_8; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_9; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_10; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_11; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_12; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_13; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_14; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_15; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_17; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_18; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_19; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_20; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_21; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_22; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_23; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_24; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_25; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_26; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_27; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_28; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_29; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_30; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _GEN_31; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire [1:0] _T_266; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  wire  _T_267; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@9.4]
  wire [1:0] _T_269; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 33:58:@10.4]
  wire  _T_271; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 34:56:@11.4]
  wire  _T_272; // @[Mux.scala 46:19:@12.4]
  wire  _T_273; // @[Mux.scala 46:16:@13.4]
  wire  _T_274; // @[Mux.scala 46:19:@14.4]
  wire [1:0] _T_275; // @[Mux.scala 46:16:@15.4]
  wire  _T_276; // @[Mux.scala 46:19:@16.4]
  wire [1:0] _T_277; // @[Mux.scala 46:16:@17.4]
  wire  _T_278; // @[Mux.scala 46:19:@18.4]
  wire  _GEN_33; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_34; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_35; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_36; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_37; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_38; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_39; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_40; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_41; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_42; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_43; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_44; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_45; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_46; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_47; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_49; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_50; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_51; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_52; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_53; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_54; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_55; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_56; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_57; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_58; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_59; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_60; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_61; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_62; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _GEN_63; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire [1:0] _T_283; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  wire  _T_284; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@21.4]
  wire [1:0] _T_286; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 33:58:@22.4]
  wire  _T_288; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 34:56:@23.4]
  wire  _T_289; // @[Mux.scala 46:19:@24.4]
  wire  _T_290; // @[Mux.scala 46:16:@25.4]
  wire  _T_291; // @[Mux.scala 46:19:@26.4]
  wire [1:0] _T_292; // @[Mux.scala 46:16:@27.4]
  wire  _T_293; // @[Mux.scala 46:19:@28.4]
  wire [1:0] _T_294; // @[Mux.scala 46:16:@29.4]
  wire  _T_295; // @[Mux.scala 46:19:@30.4]
  wire  _GEN_65; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_66; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_67; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_68; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_69; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_70; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_71; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_72; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_73; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_74; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_75; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_76; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_77; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_78; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_79; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_81; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_82; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_83; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_84; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_85; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_86; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_87; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_88; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_89; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_90; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_91; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_92; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_93; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_94; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _GEN_95; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire [1:0] _T_300; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  wire  _T_301; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@33.4]
  wire [1:0] _T_303; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 33:58:@34.4]
  wire  _T_305; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 34:56:@35.4]
  wire  _T_306; // @[Mux.scala 46:19:@36.4]
  wire  _T_307; // @[Mux.scala 46:16:@37.4]
  wire  _T_308; // @[Mux.scala 46:19:@38.4]
  wire [1:0] _T_309; // @[Mux.scala 46:16:@39.4]
  wire  _T_310; // @[Mux.scala 46:19:@40.4]
  wire [1:0] _T_311; // @[Mux.scala 46:16:@41.4]
  wire  _T_312; // @[Mux.scala 46:19:@42.4]
  wire  _GEN_97; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_98; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_99; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_100; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_101; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_102; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_103; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_104; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_105; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_106; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_107; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_108; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_109; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_110; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_111; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_113; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_114; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_115; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_116; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_117; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_118; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_119; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_120; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_121; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_122; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_123; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_124; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_125; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_126; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _GEN_127; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire [1:0] _T_317; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  wire  _T_318; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@45.4]
  wire [1:0] _T_320; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 33:58:@46.4]
  wire  _T_322; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 34:56:@47.4]
  wire  _T_323; // @[Mux.scala 46:19:@48.4]
  wire  _T_324; // @[Mux.scala 46:16:@49.4]
  wire  _T_325; // @[Mux.scala 46:19:@50.4]
  wire [1:0] _T_326; // @[Mux.scala 46:16:@51.4]
  wire  _T_327; // @[Mux.scala 46:19:@52.4]
  wire [1:0] _T_328; // @[Mux.scala 46:16:@53.4]
  wire  _T_329; // @[Mux.scala 46:19:@54.4]
  reg [1:0] _T_333; // @[Reg.scala 11:16:@56.4]
  reg [31:0] _RAND_0;
  reg [1:0] _T_335; // @[Reg.scala 11:16:@60.4]
  reg [31:0] _RAND_1;
  reg [1:0] _T_337; // @[Reg.scala 11:16:@64.4]
  reg [31:0] _RAND_2;
  reg [1:0] _T_339; // @[Reg.scala 11:16:@68.4]
  reg [31:0] _RAND_3;
  reg [1:0] _T_341; // @[Reg.scala 11:16:@72.4]
  reg [31:0] _RAND_4;
  reg [1:0] _T_344; // @[Reg.scala 11:16:@76.4]
  reg [31:0] _RAND_5;
  reg [1:0] _T_346; // @[Reg.scala 11:16:@80.4]
  reg [31:0] _RAND_6;
  reg [1:0] _T_348; // @[Reg.scala 11:16:@84.4]
  reg [31:0] _RAND_7;
  reg [1:0] _T_350; // @[Reg.scala 11:16:@88.4]
  reg [31:0] _RAND_8;
  reg [1:0] _T_352; // @[Reg.scala 11:16:@92.4]
  reg [31:0] _RAND_9;
  reg [1:0] _T_355; // @[Reg.scala 11:16:@96.4]
  reg [31:0] _RAND_10;
  reg [1:0] _T_357; // @[Reg.scala 11:16:@100.4]
  reg [31:0] _RAND_11;
  reg [1:0] _T_359; // @[Reg.scala 11:16:@104.4]
  reg [31:0] _RAND_12;
  reg [1:0] _T_361; // @[Reg.scala 11:16:@108.4]
  reg [31:0] _RAND_13;
  reg [1:0] _T_363; // @[Reg.scala 11:16:@112.4]
  reg [31:0] _RAND_14;
  reg [1:0] _T_366; // @[Reg.scala 11:16:@116.4]
  reg [31:0] _RAND_15;
  reg [1:0] _T_368; // @[Reg.scala 11:16:@120.4]
  reg [31:0] _RAND_16;
  reg [1:0] _T_370; // @[Reg.scala 11:16:@124.4]
  reg [31:0] _RAND_17;
  reg [1:0] _T_372; // @[Reg.scala 11:16:@128.4]
  reg [31:0] _RAND_18;
  reg [1:0] _T_374; // @[Reg.scala 11:16:@132.4]
  reg [31:0] _RAND_19;
  assign _GEN_1 = 4'h1 == io_selects_0_0 ? io_inputs_1 : io_inputs_0; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_2 = 4'h2 == io_selects_0_0 ? io_inputs_2 : _GEN_1; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_3 = 4'h3 == io_selects_0_0 ? io_inputs_3 : _GEN_2; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_4 = 4'h4 == io_selects_0_0 ? io_inputs_4 : _GEN_3; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_5 = 4'h5 == io_selects_0_0 ? io_inputs_5 : _GEN_4; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_6 = 4'h6 == io_selects_0_0 ? io_inputs_6 : _GEN_5; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_7 = 4'h7 == io_selects_0_0 ? io_inputs_7 : _GEN_6; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_8 = 4'h8 == io_selects_0_0 ? io_inputs_8 : _GEN_7; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_9 = 4'h9 == io_selects_0_0 ? io_inputs_9 : _GEN_8; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_10 = 4'ha == io_selects_0_0 ? io_inputs_10 : _GEN_9; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_11 = 4'hb == io_selects_0_0 ? io_inputs_11 : _GEN_10; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_12 = 4'hc == io_selects_0_0 ? io_inputs_12 : _GEN_11; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_13 = 4'hd == io_selects_0_0 ? io_inputs_13 : _GEN_12; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_14 = 4'he == io_selects_0_0 ? io_inputs_14 : _GEN_13; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_15 = 4'hf == io_selects_0_0 ? io_inputs_15 : _GEN_14; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_17 = 4'h1 == io_selects_0_1 ? io_inputs_1 : io_inputs_0; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_18 = 4'h2 == io_selects_0_1 ? io_inputs_2 : _GEN_17; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_19 = 4'h3 == io_selects_0_1 ? io_inputs_3 : _GEN_18; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_20 = 4'h4 == io_selects_0_1 ? io_inputs_4 : _GEN_19; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_21 = 4'h5 == io_selects_0_1 ? io_inputs_5 : _GEN_20; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_22 = 4'h6 == io_selects_0_1 ? io_inputs_6 : _GEN_21; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_23 = 4'h7 == io_selects_0_1 ? io_inputs_7 : _GEN_22; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_24 = 4'h8 == io_selects_0_1 ? io_inputs_8 : _GEN_23; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_25 = 4'h9 == io_selects_0_1 ? io_inputs_9 : _GEN_24; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_26 = 4'ha == io_selects_0_1 ? io_inputs_10 : _GEN_25; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_27 = 4'hb == io_selects_0_1 ? io_inputs_11 : _GEN_26; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_28 = 4'hc == io_selects_0_1 ? io_inputs_12 : _GEN_27; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_29 = 4'hd == io_selects_0_1 ? io_inputs_13 : _GEN_28; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_30 = 4'he == io_selects_0_1 ? io_inputs_14 : _GEN_29; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_31 = 4'hf == io_selects_0_1 ? io_inputs_15 : _GEN_30; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _T_266 = _GEN_15 + _GEN_31; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@8.4]
  assign _T_267 = _GEN_15 + _GEN_31; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@9.4]
  assign _T_269 = _GEN_15 * _GEN_31; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 33:58:@10.4]
  assign _T_271 = _GEN_15 / _GEN_31; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 34:56:@11.4]
  assign _T_272 = 3'h3 == io_operation_0; // @[Mux.scala 46:19:@12.4]
  assign _T_273 = _T_272 ? _T_271 : 1'h0; // @[Mux.scala 46:16:@13.4]
  assign _T_274 = 3'h2 == io_operation_0; // @[Mux.scala 46:19:@14.4]
  assign _T_275 = _T_274 ? _T_269 : {{1'd0}, _T_273}; // @[Mux.scala 46:16:@15.4]
  assign _T_276 = 3'h1 == io_operation_0; // @[Mux.scala 46:19:@16.4]
  assign _T_277 = _T_276 ? {{1'd0}, _T_267} : _T_275; // @[Mux.scala 46:16:@17.4]
  assign _T_278 = 3'h0 == io_operation_0; // @[Mux.scala 46:19:@18.4]
  assign _GEN_33 = 4'h1 == io_selects_1_0 ? io_inputs_1 : io_inputs_0; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_34 = 4'h2 == io_selects_1_0 ? io_inputs_2 : _GEN_33; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_35 = 4'h3 == io_selects_1_0 ? io_inputs_3 : _GEN_34; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_36 = 4'h4 == io_selects_1_0 ? io_inputs_4 : _GEN_35; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_37 = 4'h5 == io_selects_1_0 ? io_inputs_5 : _GEN_36; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_38 = 4'h6 == io_selects_1_0 ? io_inputs_6 : _GEN_37; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_39 = 4'h7 == io_selects_1_0 ? io_inputs_7 : _GEN_38; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_40 = 4'h8 == io_selects_1_0 ? io_inputs_8 : _GEN_39; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_41 = 4'h9 == io_selects_1_0 ? io_inputs_9 : _GEN_40; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_42 = 4'ha == io_selects_1_0 ? io_inputs_10 : _GEN_41; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_43 = 4'hb == io_selects_1_0 ? io_inputs_11 : _GEN_42; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_44 = 4'hc == io_selects_1_0 ? io_inputs_12 : _GEN_43; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_45 = 4'hd == io_selects_1_0 ? io_inputs_13 : _GEN_44; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_46 = 4'he == io_selects_1_0 ? io_inputs_14 : _GEN_45; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_47 = 4'hf == io_selects_1_0 ? io_inputs_15 : _GEN_46; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_49 = 4'h1 == io_selects_1_1 ? io_inputs_1 : io_inputs_0; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_50 = 4'h2 == io_selects_1_1 ? io_inputs_2 : _GEN_49; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_51 = 4'h3 == io_selects_1_1 ? io_inputs_3 : _GEN_50; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_52 = 4'h4 == io_selects_1_1 ? io_inputs_4 : _GEN_51; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_53 = 4'h5 == io_selects_1_1 ? io_inputs_5 : _GEN_52; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_54 = 4'h6 == io_selects_1_1 ? io_inputs_6 : _GEN_53; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_55 = 4'h7 == io_selects_1_1 ? io_inputs_7 : _GEN_54; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_56 = 4'h8 == io_selects_1_1 ? io_inputs_8 : _GEN_55; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_57 = 4'h9 == io_selects_1_1 ? io_inputs_9 : _GEN_56; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_58 = 4'ha == io_selects_1_1 ? io_inputs_10 : _GEN_57; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_59 = 4'hb == io_selects_1_1 ? io_inputs_11 : _GEN_58; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_60 = 4'hc == io_selects_1_1 ? io_inputs_12 : _GEN_59; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_61 = 4'hd == io_selects_1_1 ? io_inputs_13 : _GEN_60; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_62 = 4'he == io_selects_1_1 ? io_inputs_14 : _GEN_61; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _GEN_63 = 4'hf == io_selects_1_1 ? io_inputs_15 : _GEN_62; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _T_283 = _GEN_47 + _GEN_63; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@20.4]
  assign _T_284 = _GEN_47 + _GEN_63; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@21.4]
  assign _T_286 = _GEN_47 * _GEN_63; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 33:58:@22.4]
  assign _T_288 = _GEN_47 / _GEN_63; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 34:56:@23.4]
  assign _T_289 = 3'h3 == io_operation_1; // @[Mux.scala 46:19:@24.4]
  assign _T_290 = _T_289 ? _T_288 : 1'h0; // @[Mux.scala 46:16:@25.4]
  assign _T_291 = 3'h2 == io_operation_1; // @[Mux.scala 46:19:@26.4]
  assign _T_292 = _T_291 ? _T_286 : {{1'd0}, _T_290}; // @[Mux.scala 46:16:@27.4]
  assign _T_293 = 3'h1 == io_operation_1; // @[Mux.scala 46:19:@28.4]
  assign _T_294 = _T_293 ? {{1'd0}, _T_284} : _T_292; // @[Mux.scala 46:16:@29.4]
  assign _T_295 = 3'h0 == io_operation_1; // @[Mux.scala 46:19:@30.4]
  assign _GEN_65 = 4'h1 == io_selects_2_0 ? io_inputs_1 : io_inputs_0; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_66 = 4'h2 == io_selects_2_0 ? io_inputs_2 : _GEN_65; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_67 = 4'h3 == io_selects_2_0 ? io_inputs_3 : _GEN_66; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_68 = 4'h4 == io_selects_2_0 ? io_inputs_4 : _GEN_67; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_69 = 4'h5 == io_selects_2_0 ? io_inputs_5 : _GEN_68; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_70 = 4'h6 == io_selects_2_0 ? io_inputs_6 : _GEN_69; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_71 = 4'h7 == io_selects_2_0 ? io_inputs_7 : _GEN_70; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_72 = 4'h8 == io_selects_2_0 ? io_inputs_8 : _GEN_71; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_73 = 4'h9 == io_selects_2_0 ? io_inputs_9 : _GEN_72; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_74 = 4'ha == io_selects_2_0 ? io_inputs_10 : _GEN_73; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_75 = 4'hb == io_selects_2_0 ? io_inputs_11 : _GEN_74; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_76 = 4'hc == io_selects_2_0 ? io_inputs_12 : _GEN_75; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_77 = 4'hd == io_selects_2_0 ? io_inputs_13 : _GEN_76; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_78 = 4'he == io_selects_2_0 ? io_inputs_14 : _GEN_77; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_79 = 4'hf == io_selects_2_0 ? io_inputs_15 : _GEN_78; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_81 = 4'h1 == io_selects_2_1 ? io_inputs_1 : io_inputs_0; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_82 = 4'h2 == io_selects_2_1 ? io_inputs_2 : _GEN_81; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_83 = 4'h3 == io_selects_2_1 ? io_inputs_3 : _GEN_82; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_84 = 4'h4 == io_selects_2_1 ? io_inputs_4 : _GEN_83; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_85 = 4'h5 == io_selects_2_1 ? io_inputs_5 : _GEN_84; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_86 = 4'h6 == io_selects_2_1 ? io_inputs_6 : _GEN_85; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_87 = 4'h7 == io_selects_2_1 ? io_inputs_7 : _GEN_86; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_88 = 4'h8 == io_selects_2_1 ? io_inputs_8 : _GEN_87; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_89 = 4'h9 == io_selects_2_1 ? io_inputs_9 : _GEN_88; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_90 = 4'ha == io_selects_2_1 ? io_inputs_10 : _GEN_89; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_91 = 4'hb == io_selects_2_1 ? io_inputs_11 : _GEN_90; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_92 = 4'hc == io_selects_2_1 ? io_inputs_12 : _GEN_91; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_93 = 4'hd == io_selects_2_1 ? io_inputs_13 : _GEN_92; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_94 = 4'he == io_selects_2_1 ? io_inputs_14 : _GEN_93; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _GEN_95 = 4'hf == io_selects_2_1 ? io_inputs_15 : _GEN_94; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _T_300 = _GEN_79 + _GEN_95; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@32.4]
  assign _T_301 = _GEN_79 + _GEN_95; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@33.4]
  assign _T_303 = _GEN_79 * _GEN_95; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 33:58:@34.4]
  assign _T_305 = _GEN_79 / _GEN_95; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 34:56:@35.4]
  assign _T_306 = 3'h3 == io_operation_2; // @[Mux.scala 46:19:@36.4]
  assign _T_307 = _T_306 ? _T_305 : 1'h0; // @[Mux.scala 46:16:@37.4]
  assign _T_308 = 3'h2 == io_operation_2; // @[Mux.scala 46:19:@38.4]
  assign _T_309 = _T_308 ? _T_303 : {{1'd0}, _T_307}; // @[Mux.scala 46:16:@39.4]
  assign _T_310 = 3'h1 == io_operation_2; // @[Mux.scala 46:19:@40.4]
  assign _T_311 = _T_310 ? {{1'd0}, _T_301} : _T_309; // @[Mux.scala 46:16:@41.4]
  assign _T_312 = 3'h0 == io_operation_2; // @[Mux.scala 46:19:@42.4]
  assign _GEN_97 = 4'h1 == io_selects_3_0 ? io_inputs_1 : io_inputs_0; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_98 = 4'h2 == io_selects_3_0 ? io_inputs_2 : _GEN_97; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_99 = 4'h3 == io_selects_3_0 ? io_inputs_3 : _GEN_98; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_100 = 4'h4 == io_selects_3_0 ? io_inputs_4 : _GEN_99; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_101 = 4'h5 == io_selects_3_0 ? io_inputs_5 : _GEN_100; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_102 = 4'h6 == io_selects_3_0 ? io_inputs_6 : _GEN_101; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_103 = 4'h7 == io_selects_3_0 ? io_inputs_7 : _GEN_102; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_104 = 4'h8 == io_selects_3_0 ? io_inputs_8 : _GEN_103; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_105 = 4'h9 == io_selects_3_0 ? io_inputs_9 : _GEN_104; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_106 = 4'ha == io_selects_3_0 ? io_inputs_10 : _GEN_105; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_107 = 4'hb == io_selects_3_0 ? io_inputs_11 : _GEN_106; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_108 = 4'hc == io_selects_3_0 ? io_inputs_12 : _GEN_107; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_109 = 4'hd == io_selects_3_0 ? io_inputs_13 : _GEN_108; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_110 = 4'he == io_selects_3_0 ? io_inputs_14 : _GEN_109; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_111 = 4'hf == io_selects_3_0 ? io_inputs_15 : _GEN_110; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_113 = 4'h1 == io_selects_3_1 ? io_inputs_1 : io_inputs_0; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_114 = 4'h2 == io_selects_3_1 ? io_inputs_2 : _GEN_113; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_115 = 4'h3 == io_selects_3_1 ? io_inputs_3 : _GEN_114; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_116 = 4'h4 == io_selects_3_1 ? io_inputs_4 : _GEN_115; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_117 = 4'h5 == io_selects_3_1 ? io_inputs_5 : _GEN_116; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_118 = 4'h6 == io_selects_3_1 ? io_inputs_6 : _GEN_117; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_119 = 4'h7 == io_selects_3_1 ? io_inputs_7 : _GEN_118; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_120 = 4'h8 == io_selects_3_1 ? io_inputs_8 : _GEN_119; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_121 = 4'h9 == io_selects_3_1 ? io_inputs_9 : _GEN_120; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_122 = 4'ha == io_selects_3_1 ? io_inputs_10 : _GEN_121; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_123 = 4'hb == io_selects_3_1 ? io_inputs_11 : _GEN_122; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_124 = 4'hc == io_selects_3_1 ? io_inputs_12 : _GEN_123; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_125 = 4'hd == io_selects_3_1 ? io_inputs_13 : _GEN_124; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_126 = 4'he == io_selects_3_1 ? io_inputs_14 : _GEN_125; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _GEN_127 = 4'hf == io_selects_3_1 ? io_inputs_15 : _GEN_126; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _T_317 = _GEN_111 + _GEN_127; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@44.4]
  assign _T_318 = _GEN_111 + _GEN_127; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 32:53:@45.4]
  assign _T_320 = _GEN_111 * _GEN_127; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 33:58:@46.4]
  assign _T_322 = _GEN_111 / _GEN_127; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 34:56:@47.4]
  assign _T_323 = 3'h3 == io_operation_3; // @[Mux.scala 46:19:@48.4]
  assign _T_324 = _T_323 ? _T_322 : 1'h0; // @[Mux.scala 46:16:@49.4]
  assign _T_325 = 3'h2 == io_operation_3; // @[Mux.scala 46:19:@50.4]
  assign _T_326 = _T_325 ? _T_320 : {{1'd0}, _T_324}; // @[Mux.scala 46:16:@51.4]
  assign _T_327 = 3'h1 == io_operation_3; // @[Mux.scala 46:19:@52.4]
  assign _T_328 = _T_327 ? {{1'd0}, _T_318} : _T_326; // @[Mux.scala 46:16:@53.4]
  assign _T_329 = 3'h0 == io_operation_3; // @[Mux.scala 46:19:@54.4]
  assign io_outputs_0 = _T_341[0]; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 23:14:@136.4]
  assign io_outputs_1 = _T_352[0]; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 23:14:@137.4]
  assign io_outputs_2 = _T_363[0]; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 23:14:@138.4]
  assign io_outputs_3 = _T_374[0]; // @[MuxTest_width_1_inputs_16_outputs_4_pipeline_5s.scala 23:14:@139.4]
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
  _RAND_0 = {1{`RANDOM}};
  _T_333 = _RAND_0[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  _T_335 = _RAND_1[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  _T_337 = _RAND_2[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  _T_339 = _RAND_3[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  _T_341 = _RAND_4[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {1{`RANDOM}};
  _T_344 = _RAND_5[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_6 = {1{`RANDOM}};
  _T_346 = _RAND_6[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_7 = {1{`RANDOM}};
  _T_348 = _RAND_7[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_8 = {1{`RANDOM}};
  _T_350 = _RAND_8[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_9 = {1{`RANDOM}};
  _T_352 = _RAND_9[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_10 = {1{`RANDOM}};
  _T_355 = _RAND_10[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_11 = {1{`RANDOM}};
  _T_357 = _RAND_11[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_12 = {1{`RANDOM}};
  _T_359 = _RAND_12[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_13 = {1{`RANDOM}};
  _T_361 = _RAND_13[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_14 = {1{`RANDOM}};
  _T_363 = _RAND_14[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_15 = {1{`RANDOM}};
  _T_366 = _RAND_15[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_16 = {1{`RANDOM}};
  _T_368 = _RAND_16[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_17 = {1{`RANDOM}};
  _T_370 = _RAND_17[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_18 = {1{`RANDOM}};
  _T_372 = _RAND_18[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_19 = {1{`RANDOM}};
  _T_374 = _RAND_19[1:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (_T_278) begin
      _T_333 <= {{1'd0}, _GEN_15};
    end else begin
      _T_333 <= _T_277;
    end
    _T_335 <= _T_333;
    _T_337 <= _T_335;
    _T_339 <= _T_337;
    _T_341 <= _T_339;
    if (_T_295) begin
      _T_344 <= {{1'd0}, _GEN_47};
    end else begin
      _T_344 <= _T_294;
    end
    _T_346 <= _T_344;
    _T_348 <= _T_346;
    _T_350 <= _T_348;
    _T_352 <= _T_350;
    if (_T_312) begin
      _T_355 <= {{1'd0}, _GEN_79};
    end else begin
      _T_355 <= _T_311;
    end
    _T_357 <= _T_355;
    _T_359 <= _T_357;
    _T_361 <= _T_359;
    _T_363 <= _T_361;
    if (_T_329) begin
      _T_366 <= {{1'd0}, _GEN_111};
    end else begin
      _T_366 <= _T_328;
    end
    _T_368 <= _T_366;
    _T_370 <= _T_368;
    _T_372 <= _T_370;
    _T_374 <= _T_372;
  end
endmodule
