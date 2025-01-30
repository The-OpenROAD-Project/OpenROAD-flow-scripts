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
  wire [31:0] io_outs_left_mult_a;
  wire [31:0] io_outs_left_mult_b;
  wire [31:0] io_outs_left_mult_o;
  wire  io_outs_left_mult_rst;
  wire  io_outs_left_mult_clk;
  wire [31:0] io_outs_up_mult_a;
  wire [31:0] io_outs_up_mult_b;
  wire [31:0] io_outs_up_mult_o;
  wire  io_outs_up_mult_rst;
  wire  io_outs_up_mult_clk;
  wire [31:0] io_outs_right_mult_a;
  wire [31:0] io_outs_right_mult_b;
  wire [31:0] io_outs_right_mult_o;
  wire  io_outs_right_mult_rst;
  wire  io_outs_right_mult_clk;
  wire [31:0] io_outs_down_mult_a;
  wire [31:0] io_outs_down_mult_b;
  wire [31:0] io_outs_down_mult_o;
  wire  io_outs_down_mult_rst;
  wire  io_outs_down_mult_clk;
  reg [63:0] REG;
  reg [63:0] REG_1;
  reg [63:0] REG_2;
  reg [63:0] REG_3;
  reg [63:0] REG_4;
  reg [63:0] REG_5;
  reg [63:0] REG_6;
  reg [63:0] REG_7;
  reg [15:0] io_outs_left_REG;
  reg [15:0] io_outs_up_REG;
  reg [15:0] io_outs_right_REG;
  reg [15:0] io_outs_down_REG;
  reg  REG_8;
  multiplier io_outs_left_mult (
    .a(io_outs_left_mult_a),
    .b(io_outs_left_mult_b),
    .o(io_outs_left_mult_o),
    .rst(io_outs_left_mult_rst),
    .clk(io_outs_left_mult_clk)
  );
  multiplier io_outs_up_mult (
    .a(io_outs_up_mult_a),
    .b(io_outs_up_mult_b),
    .o(io_outs_up_mult_o),
    .rst(io_outs_up_mult_rst),
    .clk(io_outs_up_mult_clk)
  );
  multiplier io_outs_right_mult (
    .a(io_outs_right_mult_a),
    .b(io_outs_right_mult_b),
    .o(io_outs_right_mult_o),
    .rst(io_outs_right_mult_rst),
    .clk(io_outs_right_mult_clk)
  );
  multiplier io_outs_down_mult (
    .a(io_outs_down_mult_a),
    .b(io_outs_down_mult_b),
    .o(io_outs_down_mult_o),
    .rst(io_outs_down_mult_rst),
    .clk(io_outs_down_mult_clk)
  );
  assign io_outs_down = {{48'd0}, io_outs_down_REG};
  assign io_outs_right = {{48'd0}, io_outs_right_REG};
  assign io_outs_up = {{48'd0}, io_outs_up_REG};
  assign io_outs_left = {{48'd0}, io_outs_left_REG};
  assign io_lsbOuts_0 = io_lsbIns_1;
  assign io_lsbOuts_1 = io_lsbIns_2;
  assign io_lsbOuts_2 = io_lsbIns_3;
  assign io_lsbOuts_3 = REG_8;
  assign io_lsbOuts_4 = io_lsbIns_5;
  assign io_lsbOuts_5 = io_lsbIns_6;
  assign io_lsbOuts_6 = io_lsbIns_7;
  assign io_lsbOuts_7 = io_outs_left[0];
  assign io_outs_left_mult_a = REG[31:0];
  assign io_outs_left_mult_b = REG_1[31:0];
  assign io_outs_left_mult_rst = 1'h0;
  assign io_outs_left_mult_clk = clock;
  assign io_outs_up_mult_a = REG_2[31:0];
  assign io_outs_up_mult_b = REG_3[31:0];
  assign io_outs_up_mult_rst = 1'h0;
  assign io_outs_up_mult_clk = clock;
  assign io_outs_right_mult_a = REG_4[31:0];
  assign io_outs_right_mult_b = REG_5[31:0];
  assign io_outs_right_mult_rst = 1'h0;
  assign io_outs_right_mult_clk = clock;
  assign io_outs_down_mult_a = REG_6[31:0];
  assign io_outs_down_mult_b = REG_7[31:0];
  assign io_outs_down_mult_rst = 1'h0;
  assign io_outs_down_mult_clk = clock;
  always @(posedge clock) begin
    REG <= io_ins_down;
    REG_1 <= io_ins_left;
    REG_2 <= io_ins_right;
    REG_3 <= io_ins_down;
    REG_4 <= io_ins_up;
    REG_5 <= io_ins_right;
    REG_6 <= io_ins_left;
    REG_7 <= io_ins_up;
    io_outs_left_REG <= io_outs_left_mult_o[15:0];
    io_outs_up_REG <= io_outs_up_mult_o[15:0];
    io_outs_right_REG <= io_outs_right_mult_o[15:0];
    io_outs_down_REG <= io_outs_down_mult_o[15:0];
    REG_8 <= io_lsbIns_4;
  end
endmodule
