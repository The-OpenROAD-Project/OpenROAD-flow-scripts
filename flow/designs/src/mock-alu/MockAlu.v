module MockAlu(
  input         clock,
  input         reset,
  input  [3:0]  io_op,
  input  [63:0] io_a,
  input  [63:0] io_b,
  output [63:0] io_out
);
  wire [63:0] barrel_io_data;
  wire [5:0] barrel_io_shiftAmount;
  wire [3:0] barrel_io_dir;
  wire [63:0] barrel_io_out;
  wire [63:0] mult_a;
  wire [63:0] mult_b;
  wire [127:0] mult_o;
  wire  mult_clk;
  wire  mult_rst;
  wire [63:0] io_out_operand_io_a;
  wire [63:0] io_out_operand_io_b;
  wire [63:0] io_out_operand_io_out;
  wire [63:0] io_out_operand_1_io_a;
  wire [63:0] io_out_operand_1_io_b;
  wire [63:0] io_out_operand_1_io_out;
  wire [63:0] io_out_operand_2_io_a;
  wire [63:0] io_out_operand_2_io_b;
  wire [63:0] io_out_operand_2_io_out;
  reg [3:0] op;
  reg [63:0] a;
  reg [63:0] b;
  wire  isSubtraction = op == 4'h1 | op == 4'h8 | op == 4'h9 | op == 4'ha | op == 4'hc | op == 4'hb | op == 4'hd;
  wire [63:0] _modifiedB_T = ~b;
  wire [63:0] modifiedB = isSubtraction ? _modifiedB_T : b;
  wire [64:0] _extendedResult_T = a + modifiedB;
  wire [64:0] _GEN_0 = {{64'd0}, isSubtraction};
  wire [65:0] _extendedResult_T_1 = _extendedResult_T + _GEN_0;
  wire [64:0] extendedResult = _extendedResult_T_1[64:0];
  wire [63:0] result = extendedResult[63:0];
  wire  carryOut = extendedResult[64];
  wire  isTrueZero = ~(|result);
  wire  isNegative = result[63];
  wire  _io_out_T_1 = ~isTrueZero;
  wire  _io_out_T_2 = isTrueZero | isNegative;
  wire  _io_out_T_3 = ~carryOut;
  wire  _io_out_T_5 = isTrueZero | _io_out_T_3;
  wire [63:0] _io_out_T_22 = 4'h2 == op ? io_out_operand_io_out : 64'h0;
  wire [63:0] _io_out_T_24 = 4'h3 == op ? io_out_operand_1_io_out : _io_out_T_22;
  wire [63:0] _io_out_T_26 = 4'h4 == op ? io_out_operand_2_io_out : _io_out_T_24;
  wire [63:0] _io_out_T_28 = 4'h0 == op ? result : _io_out_T_26;
  wire [63:0] _io_out_T_30 = 4'h1 == op ? result : _io_out_T_28;
  wire [63:0] _io_out_T_32 = 4'h8 == op ? {{63'd0}, isTrueZero} : _io_out_T_30;
  wire [63:0] _io_out_T_34 = 4'h9 == op ? {{63'd0}, _io_out_T_1} : _io_out_T_32;
  wire [63:0] _io_out_T_36 = 4'ha == op ? {{63'd0}, isNegative} : _io_out_T_34;
  wire [63:0] _io_out_T_38 = 4'hc == op ? {{63'd0}, _io_out_T_2} : _io_out_T_36;
  wire [63:0] _io_out_T_40 = 4'hb == op ? {{63'd0}, _io_out_T_3} : _io_out_T_38;
  wire [63:0] _io_out_T_42 = 4'hd == op ? {{63'd0}, _io_out_T_5} : _io_out_T_40;
  wire [63:0] _io_out_T_44 = 4'h5 == op ? barrel_io_out : _io_out_T_42;
  wire [63:0] _io_out_T_46 = 4'h6 == op ? barrel_io_out : _io_out_T_44;
  wire [63:0] _io_out_T_48 = 4'h7 == op ? barrel_io_out : _io_out_T_46;
  reg [127:0] io_out_REG;
  BarrelShifter barrel (
    .io_data(barrel_io_data),
    .io_shiftAmount(barrel_io_shiftAmount),
    .io_dir(barrel_io_dir),
    .io_out(barrel_io_out)
  );
  multiplier mult (
    .a(mult_a),
    .b(mult_b),
    .o(mult_o),
    .clk(mult_clk),
    .rst(mult_rst)
  );
  assign io_out_operand_io_out = io_out_operand_io_a & io_out_operand_io_b;
  assign io_out_operand_1_io_out = io_out_operand_1_io_a | io_out_operand_1_io_b;
  assign io_out_operand_2_io_out = io_out_operand_2_io_a ^ io_out_operand_2_io_b;
  assign io_out = io_out_REG[63:0];
  assign barrel_io_data = a;
  assign barrel_io_shiftAmount = b[5:0];
  assign barrel_io_dir = io_op;
  assign mult_a = a;
  assign mult_b = b;
  assign mult_clk = clock;
  assign mult_rst = reset;
  assign io_out_operand_io_a = a;
  assign io_out_operand_io_b = b;
  assign io_out_operand_1_io_a = a;
  assign io_out_operand_1_io_b = b;
  assign io_out_operand_2_io_a = a;
  assign io_out_operand_2_io_b = b;
  always @(posedge clock) begin
    op <= io_op;
    a <= io_a;
    b <= io_b;
    if (4'he == op) begin
      io_out_REG <= mult_o;
    end else begin
      io_out_REG <= {{64'd0}, _io_out_T_48};
    end
  end
endmodule
