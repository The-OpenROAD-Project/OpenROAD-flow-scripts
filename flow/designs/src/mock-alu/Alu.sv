module Alu(
  input         clock,
                reset,
  input  [5:0]  io_op,
  input  [63:0] io_a,
                io_b,
  output [63:0] io_out
);

  wire [127:0] _multResult_mult_o;
  wire [63:0]  _barrel_io_out;
  wire         isSubtraction =
    io_op == 6'h7 | io_op == 6'hE | io_op == 6'hF | io_op == 6'h10 | io_op == 6'h12
    | io_op == 6'h11 | io_op == 6'h13;
  wire [64:0]  extendedResult =
    {1'h0, io_a} + {1'h0, {64{isSubtraction}} ^ io_b} + {64'h0, isSubtraction};
  BarrelShifter barrel (
    .io_data        (io_a),
    .io_shiftAmount (io_b[5:0]),
    .io_dir         (io_op),
    .io_out         (_barrel_io_out)
  );
  multiplier multResult_mult (
    .a   (io_a),
    .b   (io_b),
    .clk (clock),
    .rst (reset),
    .o   (_multResult_mult_o)
  );
  assign io_out =
    io_op == 6'h14
      ? _multResult_mult_o[63:0]
      : io_op == 6'hD | io_op == 6'hC | io_op == 6'hB
          ? _barrel_io_out
          : io_op == 6'h13
              ? {63'h0, ~(|(extendedResult[63:0])) | ~(extendedResult[64])}
              : io_op == 6'h11
                  ? {63'h0, ~(extendedResult[64])}
                  : io_op == 6'h12
                      ? {63'h0, ~(|(extendedResult[63:0])) | extendedResult[63]}
                      : io_op == 6'h10
                          ? {63'h0, extendedResult[63]}
                          : io_op == 6'hF
                              ? {63'h0, |(extendedResult[63:0])}
                              : io_op == 6'hE
                                  ? {63'h0, ~(|(extendedResult[63:0]))}
                                  : io_op == 6'h7 | io_op == 6'h0
                                      ? extendedResult[63:0]
                                      : io_op == 6'hA
                                          ? io_a ^ io_b
                                          : io_op == 6'h9
                                              ? io_a | io_b
                                              : io_op == 6'h8 ? io_a & io_b : 64'h0;
endmodule

