module MockAlu(
  input         clock,
  input         reset,
  input  [3:0]  io_op,
  input  [63:0] io_a,
  input  [63:0] io_b,
  output [63:0] io_out
);
  reg [3:0] op;
  reg [63:0] a;
  reg [63:0] b;
  wire [63:0] _out_T_1 = a + b;
  wire [63:0] _out_T_3 = a - b;
  wire [63:0] _out_T_4 = a & b;
  wire [63:0] _out_T_5 = a | b;
  wire [63:0] _out_T_6 = a ^ b;
  wire  _out_T_16 = a <= b;
  wire  _GEN_1 = 4'hb == op ? a < b : _out_T_16;
  wire  _GEN_2 = 4'hc == op ? $signed(a) <= $signed(b) : _GEN_1;
  wire  _GEN_3 = 4'ha == op ? $signed(a) < $signed(b) : _GEN_2;
  wire  _GEN_4 = 4'h9 == op ? a != b : _GEN_3;
  wire  _GEN_5 = 4'h8 == op ? a == b : _GEN_4;
  wire [63:0] _GEN_6 = 4'h4 == op ? _out_T_6 : {{63'd0}, _GEN_5};
  reg [63:0] io_out_REG;
  assign io_out = io_out_REG;
  always @(posedge clock) begin
    op <= io_op;
    a <= io_a;
    b <= io_b;
    if (4'h0 == op) begin
      io_out_REG <= _out_T_1;
    end else if (4'h1 == op) begin
      io_out_REG <= _out_T_3;
    end else if (4'h2 == op) begin
      io_out_REG <= _out_T_4;
    end else if (4'h3 == op) begin
      io_out_REG <= _out_T_5;
    end else begin
      io_out_REG <= _GEN_6;
    end
  end
endmodule
