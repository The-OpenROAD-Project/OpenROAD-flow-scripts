module MuxTest_width_16_inputs_1_outputs_1_pipeline_5( // @[:@3.2]
  input         clock, // @[:@4.4]
  input         reset, // @[:@5.4]
  input  [2:0]  io_operation_0, // @[:@6.4]
  input  [15:0] io_inputs_0, // @[:@6.4]
  output [15:0] io_outputs_0 // @[:@6.4]
);
  wire [16:0] _T_124; // @[MuxTest_width_16_inputs_1_outputs_1_pipeline_5s.scala 32:53:@8.4]
  wire [15:0] _T_125; // @[MuxTest_width_16_inputs_1_outputs_1_pipeline_5s.scala 32:53:@9.4]
  wire [31:0] _T_127; // @[MuxTest_width_16_inputs_1_outputs_1_pipeline_5s.scala 33:58:@10.4]
  wire [15:0] _T_129; // @[MuxTest_width_16_inputs_1_outputs_1_pipeline_5s.scala 34:56:@11.4]
  wire  _T_130; // @[Mux.scala 46:19:@12.4]
  wire [15:0] _T_131; // @[Mux.scala 46:16:@13.4]
  wire  _T_132; // @[Mux.scala 46:19:@14.4]
  wire [31:0] _T_133; // @[Mux.scala 46:16:@15.4]
  wire  _T_134; // @[Mux.scala 46:19:@16.4]
  wire [31:0] _T_135; // @[Mux.scala 46:16:@17.4]
  wire  _T_136; // @[Mux.scala 46:19:@18.4]
  reg [31:0] _T_140; // @[Reg.scala 11:16:@20.4]
  reg [31:0] _RAND_0;
  reg [31:0] _T_142; // @[Reg.scala 11:16:@24.4]
  reg [31:0] _RAND_1;
  reg [31:0] _T_144; // @[Reg.scala 11:16:@28.4]
  reg [31:0] _RAND_2;
  reg [31:0] _T_146; // @[Reg.scala 11:16:@32.4]
  reg [31:0] _RAND_3;
  reg [31:0] _T_148; // @[Reg.scala 11:16:@36.4]
  reg [31:0] _RAND_4;
  assign _T_124 = io_inputs_0 + io_inputs_0; // @[MuxTest_width_16_inputs_1_outputs_1_pipeline_5s.scala 32:53:@8.4]
  assign _T_125 = io_inputs_0 + io_inputs_0; // @[MuxTest_width_16_inputs_1_outputs_1_pipeline_5s.scala 32:53:@9.4]
  assign _T_127 = io_inputs_0 * io_inputs_0; // @[MuxTest_width_16_inputs_1_outputs_1_pipeline_5s.scala 33:58:@10.4]
  assign _T_129 = io_inputs_0 / io_inputs_0; // @[MuxTest_width_16_inputs_1_outputs_1_pipeline_5s.scala 34:56:@11.4]
  assign _T_130 = 3'h3 == io_operation_0; // @[Mux.scala 46:19:@12.4]
  assign _T_131 = _T_130 ? _T_129 : 16'h0; // @[Mux.scala 46:16:@13.4]
  assign _T_132 = 3'h2 == io_operation_0; // @[Mux.scala 46:19:@14.4]
  assign _T_133 = _T_132 ? _T_127 : {{16'd0}, _T_131}; // @[Mux.scala 46:16:@15.4]
  assign _T_134 = 3'h1 == io_operation_0; // @[Mux.scala 46:19:@16.4]
  assign _T_135 = _T_134 ? {{16'd0}, _T_125} : _T_133; // @[Mux.scala 46:16:@17.4]
  assign _T_136 = 3'h0 == io_operation_0; // @[Mux.scala 46:19:@18.4]
  assign io_outputs_0 = _T_148[15:0]; // @[MuxTest_width_16_inputs_1_outputs_1_pipeline_5s.scala 23:14:@40.4]
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
  _T_140 = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  _T_142 = _RAND_1[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  _T_144 = _RAND_2[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  _T_146 = _RAND_3[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  _T_148 = _RAND_4[31:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (_T_136) begin
      _T_140 <= {{16'd0}, io_inputs_0};
    end else begin
      _T_140 <= _T_135;
    end
    _T_142 <= _T_140;
    _T_144 <= _T_142;
    _T_146 <= _T_144;
    _T_148 <= _T_146;
  end
endmodule
