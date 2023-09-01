module BarrelShifter(
  input  [63:0] io_data,
  input  [5:0]  io_shiftAmount,
  input  [5:0]  io_dir,
  output [63:0] io_out
);
  wire  _rotate_T = io_dir == 6'hb;
  wire [6:0] _GEN_0 = {{1'd0}, io_shiftAmount};
  wire [6:0] _rotate_T_2 = 7'h40 - _GEN_0;
  wire [6:0] rotate = _rotate_T ? _rotate_T_2 : {{1'd0}, io_shiftAmount};
  wire [63:0] _rotateInput_T_3 = io_data[63] ? 64'hffffffffffffffff : 64'h0;
  wire [63:0] _rotateInput_T_8 = 6'hd == io_dir ? _rotateInput_T_3 : 64'h0;
  wire [63:0] _rotateInput_T_10 = 6'hb == io_dir ? io_data : _rotateInput_T_8;
  wire [63:0] _rotateInput_T_12 = 6'hc == io_dir ? 64'h0 : _rotateInput_T_10;
  wire [63:0] _rotateInput_T_14 = _rotate_T ? 64'h0 : io_data;
  wire [127:0] rotateInput = {_rotateInput_T_12,_rotateInput_T_14};
  wire [127:0] _io_out_T = rotateInput >> rotate;
  assign io_out = _io_out_T[63:0];
endmodule
