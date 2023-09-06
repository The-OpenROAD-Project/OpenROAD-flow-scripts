module MockAlu(
  input         clock,
                reset,
  input  [5:0]  io_op,
  input  [63:0] io_a,
                io_b,
  output [63:0] io_out
);

  wire [63:0] _alu_io_out;
  reg  [63:0] alu_io_a_REG;
  reg  [63:0] alu_io_b_REG;
  reg  [5:0]  alu_io_op_REG;
  reg  [63:0] io_out_REG;
  always @(posedge clock) begin
    alu_io_a_REG <= io_a;
    alu_io_b_REG <= io_b;
    alu_io_op_REG <= io_op;
    io_out_REG <= _alu_io_out;
  end // always @(posedge)
  Alu alu (
    .clock  (clock),
    .reset  (reset),
    .io_op  (alu_io_op_REG),
    .io_a   (alu_io_a_REG),
    .io_b   (alu_io_b_REG),
    .io_out (_alu_io_out)
  );
  assign io_out = io_out_REG;
endmodule

