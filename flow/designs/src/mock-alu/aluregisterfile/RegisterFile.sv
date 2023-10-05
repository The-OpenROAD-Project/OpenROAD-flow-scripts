module RegisterFile(
  input         clock,
  input  [6:0]  io_read_0_address,
                io_read_1_address,
                io_read_2_address,
                io_read_3_address,
                io_read_4_address,
                io_read_5_address,
                io_read_6_address,
                io_read_7_address,
  input         io_write_0_write,
  input  [6:0]  io_write_0_address,
  input  [63:0] io_write_0_value,
  input         io_write_0_byteMask_0,
                io_write_0_byteMask_1,
                io_write_0_byteMask_2,
                io_write_0_byteMask_3,
                io_write_0_byteMask_4,
                io_write_0_byteMask_5,
                io_write_0_byteMask_6,
                io_write_0_byteMask_7,
                io_write_1_write,
  input  [6:0]  io_write_1_address,
  input  [63:0] io_write_1_value,
  input         io_write_1_byteMask_0,
                io_write_1_byteMask_1,
                io_write_1_byteMask_2,
                io_write_1_byteMask_3,
                io_write_1_byteMask_4,
                io_write_1_byteMask_5,
                io_write_1_byteMask_6,
                io_write_1_byteMask_7,
                io_write_2_write,
  input  [6:0]  io_write_2_address,
  input  [63:0] io_write_2_value,
  input         io_write_2_byteMask_0,
                io_write_2_byteMask_1,
                io_write_2_byteMask_2,
                io_write_2_byteMask_3,
                io_write_2_byteMask_4,
                io_write_2_byteMask_5,
                io_write_2_byteMask_6,
                io_write_2_byteMask_7,
                io_write_3_write,
  input  [6:0]  io_write_3_address,
  input  [63:0] io_write_3_value,
  input         io_write_3_byteMask_0,
                io_write_3_byteMask_1,
                io_write_3_byteMask_2,
                io_write_3_byteMask_3,
                io_write_3_byteMask_4,
                io_write_3_byteMask_5,
                io_write_3_byteMask_6,
                io_write_3_byteMask_7,
  output [63:0] io_read_0_value,
                io_read_1_value,
                io_read_2_value,
                io_read_3_value,
                io_read_4_value,
                io_read_5_value,
                io_read_6_value,
                io_read_7_value
);

  wire [63:0] _registers_3_io_read_0_value;
  wire [63:0] _registers_3_io_read_1_value;
  wire [63:0] _registers_3_io_read_2_value;
  wire [63:0] _registers_3_io_read_3_value;
  wire [63:0] _registers_3_io_read_4_value;
  wire [63:0] _registers_3_io_read_5_value;
  wire [63:0] _registers_3_io_read_6_value;
  wire [63:0] _registers_3_io_read_7_value;
  wire [63:0] _registers_2_io_read_0_value;
  wire [63:0] _registers_2_io_read_1_value;
  wire [63:0] _registers_2_io_read_2_value;
  wire [63:0] _registers_2_io_read_3_value;
  wire [63:0] _registers_2_io_read_4_value;
  wire [63:0] _registers_2_io_read_5_value;
  wire [63:0] _registers_2_io_read_6_value;
  wire [63:0] _registers_2_io_read_7_value;
  wire [63:0] _registers_1_io_read_0_value;
  wire [63:0] _registers_1_io_read_1_value;
  wire [63:0] _registers_1_io_read_2_value;
  wire [63:0] _registers_1_io_read_3_value;
  wire [63:0] _registers_1_io_read_4_value;
  wire [63:0] _registers_1_io_read_5_value;
  wire [63:0] _registers_1_io_read_6_value;
  wire [63:0] _registers_1_io_read_7_value;
  wire [63:0] _registers_0_io_read_0_value;
  wire [63:0] _registers_0_io_read_1_value;
  wire [63:0] _registers_0_io_read_2_value;
  wire [63:0] _registers_0_io_read_3_value;
  wire [63:0] _registers_0_io_read_4_value;
  wire [63:0] _registers_0_io_read_5_value;
  wire [63:0] _registers_0_io_read_6_value;
  wire [63:0] _registers_0_io_read_7_value;
  reg  [63:0] casez_tmp;
  reg  [63:0] casez_tmp_0;
  reg  [63:0] casez_tmp_1;
  reg  [63:0] casez_tmp_2;
  reg  [63:0] casez_tmp_3;
  reg  [63:0] casez_tmp_4;
  reg  [63:0] casez_tmp_5;
  reg  [63:0] casez_tmp_6;
  wire [6:0]  _registers_3_io_write_0_write_T = io_write_0_address / 7'h20;
  wire [6:0]  _registers_3_io_write_1_write_T = io_write_1_address / 7'h20;
  wire [6:0]  _registers_3_io_write_2_write_T = io_write_2_address / 7'h20;
  wire [6:0]  _registers_3_io_write_3_write_T = io_write_3_address / 7'h20;
  wire [6:0]  _io_read_0_value_T = io_read_0_address / 7'h20;
  always @(*) begin
    casez (_io_read_0_value_T[1:0])
      2'b00:
        casez_tmp = _registers_0_io_read_0_value;
      2'b01:
        casez_tmp = _registers_1_io_read_0_value;
      2'b10:
        casez_tmp = _registers_2_io_read_0_value;
      default:
        casez_tmp = _registers_3_io_read_0_value;
    endcase
  end // always @(*)
  wire [6:0]  _io_read_1_value_T = io_read_1_address / 7'h20;
  always @(*) begin
    casez (_io_read_1_value_T[1:0])
      2'b00:
        casez_tmp_0 = _registers_0_io_read_1_value;
      2'b01:
        casez_tmp_0 = _registers_1_io_read_1_value;
      2'b10:
        casez_tmp_0 = _registers_2_io_read_1_value;
      default:
        casez_tmp_0 = _registers_3_io_read_1_value;
    endcase
  end // always @(*)
  wire [6:0]  _io_read_2_value_T = io_read_2_address / 7'h20;
  always @(*) begin
    casez (_io_read_2_value_T[1:0])
      2'b00:
        casez_tmp_1 = _registers_0_io_read_2_value;
      2'b01:
        casez_tmp_1 = _registers_1_io_read_2_value;
      2'b10:
        casez_tmp_1 = _registers_2_io_read_2_value;
      default:
        casez_tmp_1 = _registers_3_io_read_2_value;
    endcase
  end // always @(*)
  wire [6:0]  _io_read_3_value_T = io_read_3_address / 7'h20;
  always @(*) begin
    casez (_io_read_3_value_T[1:0])
      2'b00:
        casez_tmp_2 = _registers_0_io_read_3_value;
      2'b01:
        casez_tmp_2 = _registers_1_io_read_3_value;
      2'b10:
        casez_tmp_2 = _registers_2_io_read_3_value;
      default:
        casez_tmp_2 = _registers_3_io_read_3_value;
    endcase
  end // always @(*)
  wire [6:0]  _io_read_4_value_T = io_read_4_address / 7'h20;
  always @(*) begin
    casez (_io_read_4_value_T[1:0])
      2'b00:
        casez_tmp_3 = _registers_0_io_read_4_value;
      2'b01:
        casez_tmp_3 = _registers_1_io_read_4_value;
      2'b10:
        casez_tmp_3 = _registers_2_io_read_4_value;
      default:
        casez_tmp_3 = _registers_3_io_read_4_value;
    endcase
  end // always @(*)
  wire [6:0]  _io_read_5_value_T = io_read_5_address / 7'h20;
  always @(*) begin
    casez (_io_read_5_value_T[1:0])
      2'b00:
        casez_tmp_4 = _registers_0_io_read_5_value;
      2'b01:
        casez_tmp_4 = _registers_1_io_read_5_value;
      2'b10:
        casez_tmp_4 = _registers_2_io_read_5_value;
      default:
        casez_tmp_4 = _registers_3_io_read_5_value;
    endcase
  end // always @(*)
  wire [6:0]  _io_read_6_value_T = io_read_6_address / 7'h20;
  always @(*) begin
    casez (_io_read_6_value_T[1:0])
      2'b00:
        casez_tmp_5 = _registers_0_io_read_6_value;
      2'b01:
        casez_tmp_5 = _registers_1_io_read_6_value;
      2'b10:
        casez_tmp_5 = _registers_2_io_read_6_value;
      default:
        casez_tmp_5 = _registers_3_io_read_6_value;
    endcase
  end // always @(*)
  wire [6:0]  _io_read_7_value_T = io_read_7_address / 7'h20;
  always @(*) begin
    casez (_io_read_7_value_T[1:0])
      2'b00:
        casez_tmp_6 = _registers_0_io_read_7_value;
      2'b01:
        casez_tmp_6 = _registers_1_io_read_7_value;
      2'b10:
        casez_tmp_6 = _registers_2_io_read_7_value;
      default:
        casez_tmp_6 = _registers_3_io_read_7_value;
    endcase
  end // always @(*)
  RegisterSRAM registers_0 (
    .clock                 (clock),
    .io_read_0_address     (io_read_0_address),
    .io_read_1_address     (io_read_1_address),
    .io_read_2_address     (io_read_2_address),
    .io_read_3_address     (io_read_3_address),
    .io_read_4_address     (io_read_4_address),
    .io_read_5_address     (io_read_5_address),
    .io_read_6_address     (io_read_6_address),
    .io_read_7_address     (io_read_7_address),
    .io_write_0_write      (io_write_0_write & _registers_3_io_write_0_write_T == 7'h0),
    .io_write_0_address    (io_write_0_address),
    .io_write_0_value      (io_write_0_value),
    .io_write_0_byteMask_0 (io_write_0_byteMask_0),
    .io_write_0_byteMask_1 (io_write_0_byteMask_1),
    .io_write_0_byteMask_2 (io_write_0_byteMask_2),
    .io_write_0_byteMask_3 (io_write_0_byteMask_3),
    .io_write_0_byteMask_4 (io_write_0_byteMask_4),
    .io_write_0_byteMask_5 (io_write_0_byteMask_5),
    .io_write_0_byteMask_6 (io_write_0_byteMask_6),
    .io_write_0_byteMask_7 (io_write_0_byteMask_7),
    .io_write_1_write      (io_write_1_write & _registers_3_io_write_1_write_T == 7'h0),
    .io_write_1_address    (io_write_1_address),
    .io_write_1_value      (io_write_1_value),
    .io_write_1_byteMask_0 (io_write_1_byteMask_0),
    .io_write_1_byteMask_1 (io_write_1_byteMask_1),
    .io_write_1_byteMask_2 (io_write_1_byteMask_2),
    .io_write_1_byteMask_3 (io_write_1_byteMask_3),
    .io_write_1_byteMask_4 (io_write_1_byteMask_4),
    .io_write_1_byteMask_5 (io_write_1_byteMask_5),
    .io_write_1_byteMask_6 (io_write_1_byteMask_6),
    .io_write_1_byteMask_7 (io_write_1_byteMask_7),
    .io_write_2_write      (io_write_2_write & _registers_3_io_write_2_write_T == 7'h0),
    .io_write_2_address    (io_write_2_address),
    .io_write_2_value      (io_write_2_value),
    .io_write_2_byteMask_0 (io_write_2_byteMask_0),
    .io_write_2_byteMask_1 (io_write_2_byteMask_1),
    .io_write_2_byteMask_2 (io_write_2_byteMask_2),
    .io_write_2_byteMask_3 (io_write_2_byteMask_3),
    .io_write_2_byteMask_4 (io_write_2_byteMask_4),
    .io_write_2_byteMask_5 (io_write_2_byteMask_5),
    .io_write_2_byteMask_6 (io_write_2_byteMask_6),
    .io_write_2_byteMask_7 (io_write_2_byteMask_7),
    .io_write_3_write      (io_write_3_write & _registers_3_io_write_3_write_T == 7'h0),
    .io_write_3_address    (io_write_3_address),
    .io_write_3_value      (io_write_3_value),
    .io_write_3_byteMask_0 (io_write_3_byteMask_0),
    .io_write_3_byteMask_1 (io_write_3_byteMask_1),
    .io_write_3_byteMask_2 (io_write_3_byteMask_2),
    .io_write_3_byteMask_3 (io_write_3_byteMask_3),
    .io_write_3_byteMask_4 (io_write_3_byteMask_4),
    .io_write_3_byteMask_5 (io_write_3_byteMask_5),
    .io_write_3_byteMask_6 (io_write_3_byteMask_6),
    .io_write_3_byteMask_7 (io_write_3_byteMask_7),
    .io_read_0_value       (_registers_0_io_read_0_value),
    .io_read_1_value       (_registers_0_io_read_1_value),
    .io_read_2_value       (_registers_0_io_read_2_value),
    .io_read_3_value       (_registers_0_io_read_3_value),
    .io_read_4_value       (_registers_0_io_read_4_value),
    .io_read_5_value       (_registers_0_io_read_5_value),
    .io_read_6_value       (_registers_0_io_read_6_value),
    .io_read_7_value       (_registers_0_io_read_7_value)
  );
  RegisterSRAM registers_1 (
    .clock                 (clock),
    .io_read_0_address     (io_read_0_address),
    .io_read_1_address     (io_read_1_address),
    .io_read_2_address     (io_read_2_address),
    .io_read_3_address     (io_read_3_address),
    .io_read_4_address     (io_read_4_address),
    .io_read_5_address     (io_read_5_address),
    .io_read_6_address     (io_read_6_address),
    .io_read_7_address     (io_read_7_address),
    .io_write_0_write      (io_write_0_write & _registers_3_io_write_0_write_T == 7'h1),
    .io_write_0_address    (io_write_0_address),
    .io_write_0_value      (io_write_0_value),
    .io_write_0_byteMask_0 (io_write_0_byteMask_0),
    .io_write_0_byteMask_1 (io_write_0_byteMask_1),
    .io_write_0_byteMask_2 (io_write_0_byteMask_2),
    .io_write_0_byteMask_3 (io_write_0_byteMask_3),
    .io_write_0_byteMask_4 (io_write_0_byteMask_4),
    .io_write_0_byteMask_5 (io_write_0_byteMask_5),
    .io_write_0_byteMask_6 (io_write_0_byteMask_6),
    .io_write_0_byteMask_7 (io_write_0_byteMask_7),
    .io_write_1_write      (io_write_1_write & _registers_3_io_write_1_write_T == 7'h1),
    .io_write_1_address    (io_write_1_address),
    .io_write_1_value      (io_write_1_value),
    .io_write_1_byteMask_0 (io_write_1_byteMask_0),
    .io_write_1_byteMask_1 (io_write_1_byteMask_1),
    .io_write_1_byteMask_2 (io_write_1_byteMask_2),
    .io_write_1_byteMask_3 (io_write_1_byteMask_3),
    .io_write_1_byteMask_4 (io_write_1_byteMask_4),
    .io_write_1_byteMask_5 (io_write_1_byteMask_5),
    .io_write_1_byteMask_6 (io_write_1_byteMask_6),
    .io_write_1_byteMask_7 (io_write_1_byteMask_7),
    .io_write_2_write      (io_write_2_write & _registers_3_io_write_2_write_T == 7'h1),
    .io_write_2_address    (io_write_2_address),
    .io_write_2_value      (io_write_2_value),
    .io_write_2_byteMask_0 (io_write_2_byteMask_0),
    .io_write_2_byteMask_1 (io_write_2_byteMask_1),
    .io_write_2_byteMask_2 (io_write_2_byteMask_2),
    .io_write_2_byteMask_3 (io_write_2_byteMask_3),
    .io_write_2_byteMask_4 (io_write_2_byteMask_4),
    .io_write_2_byteMask_5 (io_write_2_byteMask_5),
    .io_write_2_byteMask_6 (io_write_2_byteMask_6),
    .io_write_2_byteMask_7 (io_write_2_byteMask_7),
    .io_write_3_write      (io_write_3_write & _registers_3_io_write_3_write_T == 7'h1),
    .io_write_3_address    (io_write_3_address),
    .io_write_3_value      (io_write_3_value),
    .io_write_3_byteMask_0 (io_write_3_byteMask_0),
    .io_write_3_byteMask_1 (io_write_3_byteMask_1),
    .io_write_3_byteMask_2 (io_write_3_byteMask_2),
    .io_write_3_byteMask_3 (io_write_3_byteMask_3),
    .io_write_3_byteMask_4 (io_write_3_byteMask_4),
    .io_write_3_byteMask_5 (io_write_3_byteMask_5),
    .io_write_3_byteMask_6 (io_write_3_byteMask_6),
    .io_write_3_byteMask_7 (io_write_3_byteMask_7),
    .io_read_0_value       (_registers_1_io_read_0_value),
    .io_read_1_value       (_registers_1_io_read_1_value),
    .io_read_2_value       (_registers_1_io_read_2_value),
    .io_read_3_value       (_registers_1_io_read_3_value),
    .io_read_4_value       (_registers_1_io_read_4_value),
    .io_read_5_value       (_registers_1_io_read_5_value),
    .io_read_6_value       (_registers_1_io_read_6_value),
    .io_read_7_value       (_registers_1_io_read_7_value)
  );
  RegisterSRAM registers_2 (
    .clock                 (clock),
    .io_read_0_address     (io_read_0_address),
    .io_read_1_address     (io_read_1_address),
    .io_read_2_address     (io_read_2_address),
    .io_read_3_address     (io_read_3_address),
    .io_read_4_address     (io_read_4_address),
    .io_read_5_address     (io_read_5_address),
    .io_read_6_address     (io_read_6_address),
    .io_read_7_address     (io_read_7_address),
    .io_write_0_write      (io_write_0_write & _registers_3_io_write_0_write_T == 7'h2),
    .io_write_0_address    (io_write_0_address),
    .io_write_0_value      (io_write_0_value),
    .io_write_0_byteMask_0 (io_write_0_byteMask_0),
    .io_write_0_byteMask_1 (io_write_0_byteMask_1),
    .io_write_0_byteMask_2 (io_write_0_byteMask_2),
    .io_write_0_byteMask_3 (io_write_0_byteMask_3),
    .io_write_0_byteMask_4 (io_write_0_byteMask_4),
    .io_write_0_byteMask_5 (io_write_0_byteMask_5),
    .io_write_0_byteMask_6 (io_write_0_byteMask_6),
    .io_write_0_byteMask_7 (io_write_0_byteMask_7),
    .io_write_1_write      (io_write_1_write & _registers_3_io_write_1_write_T == 7'h2),
    .io_write_1_address    (io_write_1_address),
    .io_write_1_value      (io_write_1_value),
    .io_write_1_byteMask_0 (io_write_1_byteMask_0),
    .io_write_1_byteMask_1 (io_write_1_byteMask_1),
    .io_write_1_byteMask_2 (io_write_1_byteMask_2),
    .io_write_1_byteMask_3 (io_write_1_byteMask_3),
    .io_write_1_byteMask_4 (io_write_1_byteMask_4),
    .io_write_1_byteMask_5 (io_write_1_byteMask_5),
    .io_write_1_byteMask_6 (io_write_1_byteMask_6),
    .io_write_1_byteMask_7 (io_write_1_byteMask_7),
    .io_write_2_write      (io_write_2_write & _registers_3_io_write_2_write_T == 7'h2),
    .io_write_2_address    (io_write_2_address),
    .io_write_2_value      (io_write_2_value),
    .io_write_2_byteMask_0 (io_write_2_byteMask_0),
    .io_write_2_byteMask_1 (io_write_2_byteMask_1),
    .io_write_2_byteMask_2 (io_write_2_byteMask_2),
    .io_write_2_byteMask_3 (io_write_2_byteMask_3),
    .io_write_2_byteMask_4 (io_write_2_byteMask_4),
    .io_write_2_byteMask_5 (io_write_2_byteMask_5),
    .io_write_2_byteMask_6 (io_write_2_byteMask_6),
    .io_write_2_byteMask_7 (io_write_2_byteMask_7),
    .io_write_3_write      (io_write_3_write & _registers_3_io_write_3_write_T == 7'h2),
    .io_write_3_address    (io_write_3_address),
    .io_write_3_value      (io_write_3_value),
    .io_write_3_byteMask_0 (io_write_3_byteMask_0),
    .io_write_3_byteMask_1 (io_write_3_byteMask_1),
    .io_write_3_byteMask_2 (io_write_3_byteMask_2),
    .io_write_3_byteMask_3 (io_write_3_byteMask_3),
    .io_write_3_byteMask_4 (io_write_3_byteMask_4),
    .io_write_3_byteMask_5 (io_write_3_byteMask_5),
    .io_write_3_byteMask_6 (io_write_3_byteMask_6),
    .io_write_3_byteMask_7 (io_write_3_byteMask_7),
    .io_read_0_value       (_registers_2_io_read_0_value),
    .io_read_1_value       (_registers_2_io_read_1_value),
    .io_read_2_value       (_registers_2_io_read_2_value),
    .io_read_3_value       (_registers_2_io_read_3_value),
    .io_read_4_value       (_registers_2_io_read_4_value),
    .io_read_5_value       (_registers_2_io_read_5_value),
    .io_read_6_value       (_registers_2_io_read_6_value),
    .io_read_7_value       (_registers_2_io_read_7_value)
  );
  RegisterSRAM registers_3 (
    .clock                 (clock),
    .io_read_0_address     (io_read_0_address),
    .io_read_1_address     (io_read_1_address),
    .io_read_2_address     (io_read_2_address),
    .io_read_3_address     (io_read_3_address),
    .io_read_4_address     (io_read_4_address),
    .io_read_5_address     (io_read_5_address),
    .io_read_6_address     (io_read_6_address),
    .io_read_7_address     (io_read_7_address),
    .io_write_0_write      (io_write_0_write & _registers_3_io_write_0_write_T == 7'h3),
    .io_write_0_address    (io_write_0_address),
    .io_write_0_value      (io_write_0_value),
    .io_write_0_byteMask_0 (io_write_0_byteMask_0),
    .io_write_0_byteMask_1 (io_write_0_byteMask_1),
    .io_write_0_byteMask_2 (io_write_0_byteMask_2),
    .io_write_0_byteMask_3 (io_write_0_byteMask_3),
    .io_write_0_byteMask_4 (io_write_0_byteMask_4),
    .io_write_0_byteMask_5 (io_write_0_byteMask_5),
    .io_write_0_byteMask_6 (io_write_0_byteMask_6),
    .io_write_0_byteMask_7 (io_write_0_byteMask_7),
    .io_write_1_write      (io_write_1_write & _registers_3_io_write_1_write_T == 7'h3),
    .io_write_1_address    (io_write_1_address),
    .io_write_1_value      (io_write_1_value),
    .io_write_1_byteMask_0 (io_write_1_byteMask_0),
    .io_write_1_byteMask_1 (io_write_1_byteMask_1),
    .io_write_1_byteMask_2 (io_write_1_byteMask_2),
    .io_write_1_byteMask_3 (io_write_1_byteMask_3),
    .io_write_1_byteMask_4 (io_write_1_byteMask_4),
    .io_write_1_byteMask_5 (io_write_1_byteMask_5),
    .io_write_1_byteMask_6 (io_write_1_byteMask_6),
    .io_write_1_byteMask_7 (io_write_1_byteMask_7),
    .io_write_2_write      (io_write_2_write & _registers_3_io_write_2_write_T == 7'h3),
    .io_write_2_address    (io_write_2_address),
    .io_write_2_value      (io_write_2_value),
    .io_write_2_byteMask_0 (io_write_2_byteMask_0),
    .io_write_2_byteMask_1 (io_write_2_byteMask_1),
    .io_write_2_byteMask_2 (io_write_2_byteMask_2),
    .io_write_2_byteMask_3 (io_write_2_byteMask_3),
    .io_write_2_byteMask_4 (io_write_2_byteMask_4),
    .io_write_2_byteMask_5 (io_write_2_byteMask_5),
    .io_write_2_byteMask_6 (io_write_2_byteMask_6),
    .io_write_2_byteMask_7 (io_write_2_byteMask_7),
    .io_write_3_write      (io_write_3_write & _registers_3_io_write_3_write_T == 7'h3),
    .io_write_3_address    (io_write_3_address),
    .io_write_3_value      (io_write_3_value),
    .io_write_3_byteMask_0 (io_write_3_byteMask_0),
    .io_write_3_byteMask_1 (io_write_3_byteMask_1),
    .io_write_3_byteMask_2 (io_write_3_byteMask_2),
    .io_write_3_byteMask_3 (io_write_3_byteMask_3),
    .io_write_3_byteMask_4 (io_write_3_byteMask_4),
    .io_write_3_byteMask_5 (io_write_3_byteMask_5),
    .io_write_3_byteMask_6 (io_write_3_byteMask_6),
    .io_write_3_byteMask_7 (io_write_3_byteMask_7),
    .io_read_0_value       (_registers_3_io_read_0_value),
    .io_read_1_value       (_registers_3_io_read_1_value),
    .io_read_2_value       (_registers_3_io_read_2_value),
    .io_read_3_value       (_registers_3_io_read_3_value),
    .io_read_4_value       (_registers_3_io_read_4_value),
    .io_read_5_value       (_registers_3_io_read_5_value),
    .io_read_6_value       (_registers_3_io_read_6_value),
    .io_read_7_value       (_registers_3_io_read_7_value)
  );
  assign io_read_0_value = casez_tmp;
  assign io_read_1_value = casez_tmp_0;
  assign io_read_2_value = casez_tmp_1;
  assign io_read_3_value = casez_tmp_2;
  assign io_read_4_value = casez_tmp_3;
  assign io_read_5_value = casez_tmp_4;
  assign io_read_6_value = casez_tmp_5;
  assign io_read_7_value = casez_tmp_6;
endmodule

