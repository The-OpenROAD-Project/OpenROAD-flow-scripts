module MuxTest_width_256_inputs_4_outputs_1_pipeline_5( // @[:@3.2]
  input          clock, // @[:@4.4]
  input          reset, // @[:@5.4]
  input  [1:0]   io_selects_0_0, // @[:@6.4]
  input  [1:0]   io_selects_0_1, // @[:@6.4]
  input  [2:0]   io_operation_0, // @[:@6.4]
  input  [255:0] io_inputs_0, // @[:@6.4]
  input  [255:0] io_inputs_1, // @[:@6.4]
  input  [255:0] io_inputs_2, // @[:@6.4]
  input  [255:0] io_inputs_3, // @[:@6.4]
  output [255:0] io_outputs_0 // @[:@6.4]
);
  wire [255:0] _GEN_1; // @[MuxTest_width_256_inputs_4_outputs_1_pipeline_5s.scala 32:53:@8.4]
  wire [255:0] _GEN_2; // @[MuxTest_width_256_inputs_4_outputs_1_pipeline_5s.scala 32:53:@8.4]
  wire [255:0] _GEN_3; // @[MuxTest_width_256_inputs_4_outputs_1_pipeline_5s.scala 32:53:@8.4]
  wire [255:0] _GEN_5; // @[MuxTest_width_256_inputs_4_outputs_1_pipeline_5s.scala 32:53:@8.4]
  wire [255:0] _GEN_6; // @[MuxTest_width_256_inputs_4_outputs_1_pipeline_5s.scala 32:53:@8.4]
  wire [255:0] _GEN_7; // @[MuxTest_width_256_inputs_4_outputs_1_pipeline_5s.scala 32:53:@8.4]
  wire [256:0] _T_128; // @[MuxTest_width_256_inputs_4_outputs_1_pipeline_5s.scala 32:53:@8.4]
  wire [255:0] _T_129; // @[MuxTest_width_256_inputs_4_outputs_1_pipeline_5s.scala 32:53:@9.4]
  wire [511:0] _T_131; // @[MuxTest_width_256_inputs_4_outputs_1_pipeline_5s.scala 33:58:@10.4]
  wire [255:0] _T_133; // @[MuxTest_width_256_inputs_4_outputs_1_pipeline_5s.scala 34:56:@11.4]
  wire  _T_134; // @[Mux.scala 46:19:@12.4]
  wire [255:0] _T_135; // @[Mux.scala 46:16:@13.4]
  wire  _T_136; // @[Mux.scala 46:19:@14.4]
  wire [511:0] _T_137; // @[Mux.scala 46:16:@15.4]
  wire  _T_138; // @[Mux.scala 46:19:@16.4]
  wire [511:0] _T_139; // @[Mux.scala 46:16:@17.4]
  wire  _T_140; // @[Mux.scala 46:19:@18.4]
  reg [511:0] _T_144; // @[Reg.scala 11:16:@20.4]
  reg [511:0] _RAND_0;
  reg [511:0] _T_146; // @[Reg.scala 11:16:@24.4]
  reg [511:0] _RAND_1;
  reg [511:0] _T_148; // @[Reg.scala 11:16:@28.4]
  reg [511:0] _RAND_2;
  reg [511:0] _T_150; // @[Reg.scala 11:16:@32.4]
  reg [511:0] _RAND_3;
  reg [511:0] _T_152; // @[Reg.scala 11:16:@36.4]
  reg [511:0] _RAND_4;
  assign _GEN_1 = 2'h1 == io_selects_0_0 ? io_inputs_1 : io_inputs_0; // @[MuxTest_width_256_inputs_4_outputs_1_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_2 = 2'h2 == io_selects_0_0 ? io_inputs_2 : _GEN_1; // @[MuxTest_width_256_inputs_4_outputs_1_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_3 = 2'h3 == io_selects_0_0 ? io_inputs_3 : _GEN_2; // @[MuxTest_width_256_inputs_4_outputs_1_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_5 = 2'h1 == io_selects_0_1 ? io_inputs_1 : io_inputs_0; // @[MuxTest_width_256_inputs_4_outputs_1_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_6 = 2'h2 == io_selects_0_1 ? io_inputs_2 : _GEN_5; // @[MuxTest_width_256_inputs_4_outputs_1_pipeline_5s.scala 32:53:@8.4]
  assign _GEN_7 = 2'h3 == io_selects_0_1 ? io_inputs_3 : _GEN_6; // @[MuxTest_width_256_inputs_4_outputs_1_pipeline_5s.scala 32:53:@8.4]
  assign _T_128 = _GEN_3 + _GEN_7; // @[MuxTest_width_256_inputs_4_outputs_1_pipeline_5s.scala 32:53:@8.4]
  assign _T_129 = _GEN_3 + _GEN_7; // @[MuxTest_width_256_inputs_4_outputs_1_pipeline_5s.scala 32:53:@9.4]
  assign _T_131 = _GEN_3 * _GEN_7; // @[MuxTest_width_256_inputs_4_outputs_1_pipeline_5s.scala 33:58:@10.4]
  assign _T_133 = _GEN_3 / _GEN_7; // @[MuxTest_width_256_inputs_4_outputs_1_pipeline_5s.scala 34:56:@11.4]
  assign _T_134 = 3'h3 == io_operation_0; // @[Mux.scala 46:19:@12.4]
  assign _T_135 = _T_134 ? _T_133 : 256'h0; // @[Mux.scala 46:16:@13.4]
  assign _T_136 = 3'h2 == io_operation_0; // @[Mux.scala 46:19:@14.4]
  assign _T_137 = _T_136 ? _T_131 : {{256'd0}, _T_135}; // @[Mux.scala 46:16:@15.4]
  assign _T_138 = 3'h1 == io_operation_0; // @[Mux.scala 46:19:@16.4]
  assign _T_139 = _T_138 ? {{256'd0}, _T_129} : _T_137; // @[Mux.scala 46:16:@17.4]
  assign _T_140 = 3'h0 == io_operation_0; // @[Mux.scala 46:19:@18.4]
  assign io_outputs_0 = _T_152[255:0]; // @[MuxTest_width_256_inputs_4_outputs_1_pipeline_5s.scala 23:14:@40.4]
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
  _RAND_0 = {16{`RANDOM}};
  _T_144 = _RAND_0[511:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {16{`RANDOM}};
  _T_146 = _RAND_1[511:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {16{`RANDOM}};
  _T_148 = _RAND_2[511:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {16{`RANDOM}};
  _T_150 = _RAND_3[511:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {16{`RANDOM}};
  _T_152 = _RAND_4[511:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (_T_140) begin
      _T_144 <= {{256'd0}, _GEN_3};
    end else begin
      _T_144 <= _T_139;
    end
    _T_146 <= _T_144;
    _T_148 <= _T_146;
    _T_150 <= _T_148;
    _T_152 <= _T_150;
  end
endmodule
