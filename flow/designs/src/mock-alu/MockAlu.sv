module MockAlu(
  input         clock,
                reset,
  input  [5:0]  io_op,
  input  [63:0] io_a,
                io_b,
  output [63:0] io_out
);

  wire [127:0] _multResult_mult_o;
  wire [63:0]  _barrel_io_out;
  reg  [5:0]   op;
  reg  [63:0]  a;
  reg  [63:0]  b;
  reg  [127:0] io_out_REG;
  wire         isSubtraction =
    op == 6'h7 | op == 6'hE | op == 6'hF | op == 6'h10 | op == 6'h12 | op == 6'h11
    | op == 6'h13;
  wire [64:0]  extendedResult =
    {1'h0, a} + {1'h0, {64{isSubtraction}} ^ b} + {64'h0, isSubtraction};
  always @(posedge clock) begin
    op <= io_op;
    a <= io_a;
    b <= io_b;
    if (op == 6'h14)
      io_out_REG <= _multResult_mult_o;
    else
      io_out_REG <=
        {64'h0,
         op == 6'hD | op == 6'hC | op == 6'hB
           ? _barrel_io_out
           : op == 6'h13
               ? {63'h0, ~(|(extendedResult[63:0])) | ~(extendedResult[64])}
               : op == 6'h11
                   ? {63'h0, ~(extendedResult[64])}
                   : op == 6'h12
                       ? {63'h0, ~(|(extendedResult[63:0])) | extendedResult[63]}
                       : op == 6'h10
                           ? {63'h0, extendedResult[63]}
                           : op == 6'hF
                               ? {63'h0, |(extendedResult[63:0])}
                               : op == 6'hE
                                   ? {63'h0, ~(|(extendedResult[63:0]))}
                                   : op == 6'h7 | op == 6'h0
                                       ? extendedResult[63:0]
                                       : op == 6'hA
                                           ? a ^ b
                                           : op == 6'h9
                                               ? a | b
                                               : op == 6'h8 ? a & b : 64'h0};
  end // always @(posedge)
  BarrelShifter barrel (
    .io_data        (a),
    .io_shiftAmount (b[5:0]),
    .io_dir         (io_op),
    .io_out         (_barrel_io_out)
  );
  multiplier multResult_mult (
    .a   (a),
    .b   (b),
    .clk (clock),
    .rst (reset),
    .o   (_multResult_mult_o)
  );
  assign io_out = io_out_REG[63:0];
endmodule

