module BarrelShifter(
  input  [63:0] io_data,
  input  [5:0]  io_shiftAmount,
                io_dir,
  output [63:0] io_out
);

  wire         _rotateInput_T_13 = io_dir == 6'hB;
  wire [6:0]   _GEN = {1'h0, io_shiftAmount};
  wire [127:0] _io_out_T =
    {io_dir == 6'hC
       ? 64'h0
       : io_dir == 6'hB ? io_data : {64{io_dir == 6'hD & io_data[63]}},
     _rotateInput_T_13 ? 64'h0 : io_data} >> (_rotateInput_T_13 ? 7'h40 - _GEN : _GEN);
  assign io_out = _io_out_T[63:0];
endmodule

