module MockRegisterFile(
  input         clock,
                reset,
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
                io_write_4_write,
  input  [6:0]  io_write_4_address,
  input  [63:0] io_write_4_value,
  input         io_write_4_byteMask_0,
                io_write_4_byteMask_1,
                io_write_4_byteMask_2,
                io_write_4_byteMask_3,
                io_write_4_byteMask_4,
                io_write_4_byteMask_5,
                io_write_4_byteMask_6,
                io_write_4_byteMask_7,
                io_write_5_write,
  input  [6:0]  io_write_5_address,
  input  [63:0] io_write_5_value,
  input         io_write_5_byteMask_0,
                io_write_5_byteMask_1,
                io_write_5_byteMask_2,
                io_write_5_byteMask_3,
                io_write_5_byteMask_4,
                io_write_5_byteMask_5,
                io_write_5_byteMask_6,
                io_write_5_byteMask_7,
                io_write_6_write,
  input  [6:0]  io_write_6_address,
  input  [63:0] io_write_6_value,
  input         io_write_6_byteMask_0,
                io_write_6_byteMask_1,
                io_write_6_byteMask_2,
                io_write_6_byteMask_3,
                io_write_6_byteMask_4,
                io_write_6_byteMask_5,
                io_write_6_byteMask_6,
                io_write_6_byteMask_7,
                io_write_7_write,
  input  [6:0]  io_write_7_address,
  input  [63:0] io_write_7_value,
  input         io_write_7_byteMask_0,
                io_write_7_byteMask_1,
                io_write_7_byteMask_2,
                io_write_7_byteMask_3,
                io_write_7_byteMask_4,
                io_write_7_byteMask_5,
                io_write_7_byteMask_6,
                io_write_7_byteMask_7,
  output [63:0] io_read_0_value,
                io_read_1_value,
                io_read_2_value,
                io_read_3_value,
                io_read_4_value,
                io_read_5_value,
                io_read_6_value,
                io_read_7_value
);

  wire [63:0] _registerFile_io_read_0_value;
  wire [63:0] _registerFile_io_read_1_value;
  wire [63:0] _registerFile_io_read_2_value;
  wire [63:0] _registerFile_io_read_3_value;
  wire [63:0] _registerFile_io_read_4_value;
  wire [63:0] _registerFile_io_read_5_value;
  wire [63:0] _registerFile_io_read_6_value;
  wire [63:0] _registerFile_io_read_7_value;
  reg  [6:0]  registerFile_io_read_0_address_REG;
  reg  [63:0] io_read_0_value_REG;
  reg  [6:0]  registerFile_io_read_1_address_REG;
  reg  [63:0] io_read_1_value_REG;
  reg  [6:0]  registerFile_io_read_2_address_REG;
  reg  [63:0] io_read_2_value_REG;
  reg  [6:0]  registerFile_io_read_3_address_REG;
  reg  [63:0] io_read_3_value_REG;
  reg  [6:0]  registerFile_io_read_4_address_REG;
  reg  [63:0] io_read_4_value_REG;
  reg  [6:0]  registerFile_io_read_5_address_REG;
  reg  [63:0] io_read_5_value_REG;
  reg  [6:0]  registerFile_io_read_6_address_REG;
  reg  [63:0] io_read_6_value_REG;
  reg  [6:0]  registerFile_io_read_7_address_REG;
  reg  [63:0] io_read_7_value_REG;
  reg         registerFile_io_write_0_write_REG;
  reg  [6:0]  registerFile_io_write_0_address_REG;
  reg         REG_0;
  reg         REG_1;
  reg         REG_2;
  reg         REG_3;
  reg         REG_4;
  reg         REG_5;
  reg         REG_6;
  reg         REG_7;
  reg  [63:0] registerFile_io_write_0_value_REG;
  reg         registerFile_io_write_1_write_REG;
  reg  [6:0]  registerFile_io_write_1_address_REG;
  reg         REG_1_0;
  reg         REG_1_1;
  reg         REG_1_2;
  reg         REG_1_3;
  reg         REG_1_4;
  reg         REG_1_5;
  reg         REG_1_6;
  reg         REG_1_7;
  reg  [63:0] registerFile_io_write_1_value_REG;
  reg         registerFile_io_write_2_write_REG;
  reg  [6:0]  registerFile_io_write_2_address_REG;
  reg         REG_2_0;
  reg         REG_2_1;
  reg         REG_2_2;
  reg         REG_2_3;
  reg         REG_2_4;
  reg         REG_2_5;
  reg         REG_2_6;
  reg         REG_2_7;
  reg  [63:0] registerFile_io_write_2_value_REG;
  reg         registerFile_io_write_3_write_REG;
  reg  [6:0]  registerFile_io_write_3_address_REG;
  reg         REG_3_0;
  reg         REG_3_1;
  reg         REG_3_2;
  reg         REG_3_3;
  reg         REG_3_4;
  reg         REG_3_5;
  reg         REG_3_6;
  reg         REG_3_7;
  reg  [63:0] registerFile_io_write_3_value_REG;
  reg         registerFile_io_write_4_write_REG;
  reg  [6:0]  registerFile_io_write_4_address_REG;
  reg         REG_4_0;
  reg         REG_4_1;
  reg         REG_4_2;
  reg         REG_4_3;
  reg         REG_4_4;
  reg         REG_4_5;
  reg         REG_4_6;
  reg         REG_4_7;
  reg  [63:0] registerFile_io_write_4_value_REG;
  reg         registerFile_io_write_5_write_REG;
  reg  [6:0]  registerFile_io_write_5_address_REG;
  reg         REG_5_0;
  reg         REG_5_1;
  reg         REG_5_2;
  reg         REG_5_3;
  reg         REG_5_4;
  reg         REG_5_5;
  reg         REG_5_6;
  reg         REG_5_7;
  reg  [63:0] registerFile_io_write_5_value_REG;
  reg         registerFile_io_write_6_write_REG;
  reg  [6:0]  registerFile_io_write_6_address_REG;
  reg         REG_6_0;
  reg         REG_6_1;
  reg         REG_6_2;
  reg         REG_6_3;
  reg         REG_6_4;
  reg         REG_6_5;
  reg         REG_6_6;
  reg         REG_6_7;
  reg  [63:0] registerFile_io_write_6_value_REG;
  reg         registerFile_io_write_7_write_REG;
  reg  [6:0]  registerFile_io_write_7_address_REG;
  reg         REG_7_0;
  reg         REG_7_1;
  reg         REG_7_2;
  reg         REG_7_3;
  reg         REG_7_4;
  reg         REG_7_5;
  reg         REG_7_6;
  reg         REG_7_7;
  reg  [63:0] registerFile_io_write_7_value_REG;
  always @(posedge clock) begin
    registerFile_io_read_0_address_REG <= io_read_0_address;
    io_read_0_value_REG <= _registerFile_io_read_0_value;
    registerFile_io_read_1_address_REG <= io_read_1_address;
    io_read_1_value_REG <= _registerFile_io_read_1_value;
    registerFile_io_read_2_address_REG <= io_read_2_address;
    io_read_2_value_REG <= _registerFile_io_read_2_value;
    registerFile_io_read_3_address_REG <= io_read_3_address;
    io_read_3_value_REG <= _registerFile_io_read_3_value;
    registerFile_io_read_4_address_REG <= io_read_4_address;
    io_read_4_value_REG <= _registerFile_io_read_4_value;
    registerFile_io_read_5_address_REG <= io_read_5_address;
    io_read_5_value_REG <= _registerFile_io_read_5_value;
    registerFile_io_read_6_address_REG <= io_read_6_address;
    io_read_6_value_REG <= _registerFile_io_read_6_value;
    registerFile_io_read_7_address_REG <= io_read_7_address;
    io_read_7_value_REG <= _registerFile_io_read_7_value;
    registerFile_io_write_0_write_REG <= io_write_0_write;
    registerFile_io_write_0_address_REG <= io_write_0_address;
    REG_0 <= io_write_0_byteMask_0;
    REG_1 <= io_write_0_byteMask_1;
    REG_2 <= io_write_0_byteMask_2;
    REG_3 <= io_write_0_byteMask_3;
    REG_4 <= io_write_0_byteMask_4;
    REG_5 <= io_write_0_byteMask_5;
    REG_6 <= io_write_0_byteMask_6;
    REG_7 <= io_write_0_byteMask_7;
    registerFile_io_write_0_value_REG <= io_write_0_value;
    registerFile_io_write_1_write_REG <= io_write_1_write;
    registerFile_io_write_1_address_REG <= io_write_1_address;
    REG_1_0 <= io_write_1_byteMask_0;
    REG_1_1 <= io_write_1_byteMask_1;
    REG_1_2 <= io_write_1_byteMask_2;
    REG_1_3 <= io_write_1_byteMask_3;
    REG_1_4 <= io_write_1_byteMask_4;
    REG_1_5 <= io_write_1_byteMask_5;
    REG_1_6 <= io_write_1_byteMask_6;
    REG_1_7 <= io_write_1_byteMask_7;
    registerFile_io_write_1_value_REG <= io_write_1_value;
    registerFile_io_write_2_write_REG <= io_write_2_write;
    registerFile_io_write_2_address_REG <= io_write_2_address;
    REG_2_0 <= io_write_2_byteMask_0;
    REG_2_1 <= io_write_2_byteMask_1;
    REG_2_2 <= io_write_2_byteMask_2;
    REG_2_3 <= io_write_2_byteMask_3;
    REG_2_4 <= io_write_2_byteMask_4;
    REG_2_5 <= io_write_2_byteMask_5;
    REG_2_6 <= io_write_2_byteMask_6;
    REG_2_7 <= io_write_2_byteMask_7;
    registerFile_io_write_2_value_REG <= io_write_2_value;
    registerFile_io_write_3_write_REG <= io_write_3_write;
    registerFile_io_write_3_address_REG <= io_write_3_address;
    REG_3_0 <= io_write_3_byteMask_0;
    REG_3_1 <= io_write_3_byteMask_1;
    REG_3_2 <= io_write_3_byteMask_2;
    REG_3_3 <= io_write_3_byteMask_3;
    REG_3_4 <= io_write_3_byteMask_4;
    REG_3_5 <= io_write_3_byteMask_5;
    REG_3_6 <= io_write_3_byteMask_6;
    REG_3_7 <= io_write_3_byteMask_7;
    registerFile_io_write_3_value_REG <= io_write_3_value;
    registerFile_io_write_4_write_REG <= io_write_4_write;
    registerFile_io_write_4_address_REG <= io_write_4_address;
    REG_4_0 <= io_write_4_byteMask_0;
    REG_4_1 <= io_write_4_byteMask_1;
    REG_4_2 <= io_write_4_byteMask_2;
    REG_4_3 <= io_write_4_byteMask_3;
    REG_4_4 <= io_write_4_byteMask_4;
    REG_4_5 <= io_write_4_byteMask_5;
    REG_4_6 <= io_write_4_byteMask_6;
    REG_4_7 <= io_write_4_byteMask_7;
    registerFile_io_write_4_value_REG <= io_write_4_value;
    registerFile_io_write_5_write_REG <= io_write_5_write;
    registerFile_io_write_5_address_REG <= io_write_5_address;
    REG_5_0 <= io_write_5_byteMask_0;
    REG_5_1 <= io_write_5_byteMask_1;
    REG_5_2 <= io_write_5_byteMask_2;
    REG_5_3 <= io_write_5_byteMask_3;
    REG_5_4 <= io_write_5_byteMask_4;
    REG_5_5 <= io_write_5_byteMask_5;
    REG_5_6 <= io_write_5_byteMask_6;
    REG_5_7 <= io_write_5_byteMask_7;
    registerFile_io_write_5_value_REG <= io_write_5_value;
    registerFile_io_write_6_write_REG <= io_write_6_write;
    registerFile_io_write_6_address_REG <= io_write_6_address;
    REG_6_0 <= io_write_6_byteMask_0;
    REG_6_1 <= io_write_6_byteMask_1;
    REG_6_2 <= io_write_6_byteMask_2;
    REG_6_3 <= io_write_6_byteMask_3;
    REG_6_4 <= io_write_6_byteMask_4;
    REG_6_5 <= io_write_6_byteMask_5;
    REG_6_6 <= io_write_6_byteMask_6;
    REG_6_7 <= io_write_6_byteMask_7;
    registerFile_io_write_6_value_REG <= io_write_6_value;
    registerFile_io_write_7_write_REG <= io_write_7_write;
    registerFile_io_write_7_address_REG <= io_write_7_address;
    REG_7_0 <= io_write_7_byteMask_0;
    REG_7_1 <= io_write_7_byteMask_1;
    REG_7_2 <= io_write_7_byteMask_2;
    REG_7_3 <= io_write_7_byteMask_3;
    REG_7_4 <= io_write_7_byteMask_4;
    REG_7_5 <= io_write_7_byteMask_5;
    REG_7_6 <= io_write_7_byteMask_6;
    REG_7_7 <= io_write_7_byteMask_7;
    registerFile_io_write_7_value_REG <= io_write_7_value;
  end // always @(posedge)
  RegisterFile registerFile (
    .clock                 (clock),
    .io_read_0_address     (registerFile_io_read_0_address_REG),
    .io_read_1_address     (registerFile_io_read_1_address_REG),
    .io_read_2_address     (registerFile_io_read_2_address_REG),
    .io_read_3_address     (registerFile_io_read_3_address_REG),
    .io_read_4_address     (registerFile_io_read_4_address_REG),
    .io_read_5_address     (registerFile_io_read_5_address_REG),
    .io_read_6_address     (registerFile_io_read_6_address_REG),
    .io_read_7_address     (registerFile_io_read_7_address_REG),
    .io_write_0_write      (registerFile_io_write_0_write_REG),
    .io_write_0_address    (registerFile_io_write_0_address_REG),
    .io_write_0_value      (registerFile_io_write_0_value_REG),
    .io_write_0_byteMask_0 (REG_0),
    .io_write_0_byteMask_1 (REG_1),
    .io_write_0_byteMask_2 (REG_2),
    .io_write_0_byteMask_3 (REG_3),
    .io_write_0_byteMask_4 (REG_4),
    .io_write_0_byteMask_5 (REG_5),
    .io_write_0_byteMask_6 (REG_6),
    .io_write_0_byteMask_7 (REG_7),
    .io_write_1_write      (registerFile_io_write_1_write_REG),
    .io_write_1_address    (registerFile_io_write_1_address_REG),
    .io_write_1_value      (registerFile_io_write_1_value_REG),
    .io_write_1_byteMask_0 (REG_1_0),
    .io_write_1_byteMask_1 (REG_1_1),
    .io_write_1_byteMask_2 (REG_1_2),
    .io_write_1_byteMask_3 (REG_1_3),
    .io_write_1_byteMask_4 (REG_1_4),
    .io_write_1_byteMask_5 (REG_1_5),
    .io_write_1_byteMask_6 (REG_1_6),
    .io_write_1_byteMask_7 (REG_1_7),
    .io_write_2_write      (registerFile_io_write_2_write_REG),
    .io_write_2_address    (registerFile_io_write_2_address_REG),
    .io_write_2_value      (registerFile_io_write_2_value_REG),
    .io_write_2_byteMask_0 (REG_2_0),
    .io_write_2_byteMask_1 (REG_2_1),
    .io_write_2_byteMask_2 (REG_2_2),
    .io_write_2_byteMask_3 (REG_2_3),
    .io_write_2_byteMask_4 (REG_2_4),
    .io_write_2_byteMask_5 (REG_2_5),
    .io_write_2_byteMask_6 (REG_2_6),
    .io_write_2_byteMask_7 (REG_2_7),
    .io_write_3_write      (registerFile_io_write_3_write_REG),
    .io_write_3_address    (registerFile_io_write_3_address_REG),
    .io_write_3_value      (registerFile_io_write_3_value_REG),
    .io_write_3_byteMask_0 (REG_3_0),
    .io_write_3_byteMask_1 (REG_3_1),
    .io_write_3_byteMask_2 (REG_3_2),
    .io_write_3_byteMask_3 (REG_3_3),
    .io_write_3_byteMask_4 (REG_3_4),
    .io_write_3_byteMask_5 (REG_3_5),
    .io_write_3_byteMask_6 (REG_3_6),
    .io_write_3_byteMask_7 (REG_3_7),
    .io_write_4_write      (registerFile_io_write_4_write_REG),
    .io_write_4_address    (registerFile_io_write_4_address_REG),
    .io_write_4_value      (registerFile_io_write_4_value_REG),
    .io_write_4_byteMask_0 (REG_4_0),
    .io_write_4_byteMask_1 (REG_4_1),
    .io_write_4_byteMask_2 (REG_4_2),
    .io_write_4_byteMask_3 (REG_4_3),
    .io_write_4_byteMask_4 (REG_4_4),
    .io_write_4_byteMask_5 (REG_4_5),
    .io_write_4_byteMask_6 (REG_4_6),
    .io_write_4_byteMask_7 (REG_4_7),
    .io_write_5_write      (registerFile_io_write_5_write_REG),
    .io_write_5_address    (registerFile_io_write_5_address_REG),
    .io_write_5_value      (registerFile_io_write_5_value_REG),
    .io_write_5_byteMask_0 (REG_5_0),
    .io_write_5_byteMask_1 (REG_5_1),
    .io_write_5_byteMask_2 (REG_5_2),
    .io_write_5_byteMask_3 (REG_5_3),
    .io_write_5_byteMask_4 (REG_5_4),
    .io_write_5_byteMask_5 (REG_5_5),
    .io_write_5_byteMask_6 (REG_5_6),
    .io_write_5_byteMask_7 (REG_5_7),
    .io_write_6_write      (registerFile_io_write_6_write_REG),
    .io_write_6_address    (registerFile_io_write_6_address_REG),
    .io_write_6_value      (registerFile_io_write_6_value_REG),
    .io_write_6_byteMask_0 (REG_6_0),
    .io_write_6_byteMask_1 (REG_6_1),
    .io_write_6_byteMask_2 (REG_6_2),
    .io_write_6_byteMask_3 (REG_6_3),
    .io_write_6_byteMask_4 (REG_6_4),
    .io_write_6_byteMask_5 (REG_6_5),
    .io_write_6_byteMask_6 (REG_6_6),
    .io_write_6_byteMask_7 (REG_6_7),
    .io_write_7_write      (registerFile_io_write_7_write_REG),
    .io_write_7_address    (registerFile_io_write_7_address_REG),
    .io_write_7_value      (registerFile_io_write_7_value_REG),
    .io_write_7_byteMask_0 (REG_7_0),
    .io_write_7_byteMask_1 (REG_7_1),
    .io_write_7_byteMask_2 (REG_7_2),
    .io_write_7_byteMask_3 (REG_7_3),
    .io_write_7_byteMask_4 (REG_7_4),
    .io_write_7_byteMask_5 (REG_7_5),
    .io_write_7_byteMask_6 (REG_7_6),
    .io_write_7_byteMask_7 (REG_7_7),
    .io_read_0_value       (_registerFile_io_read_0_value),
    .io_read_1_value       (_registerFile_io_read_1_value),
    .io_read_2_value       (_registerFile_io_read_2_value),
    .io_read_3_value       (_registerFile_io_read_3_value),
    .io_read_4_value       (_registerFile_io_read_4_value),
    .io_read_5_value       (_registerFile_io_read_5_value),
    .io_read_6_value       (_registerFile_io_read_6_value),
    .io_read_7_value       (_registerFile_io_read_7_value)
  );
  assign io_read_0_value = io_read_0_value_REG;
  assign io_read_1_value = io_read_1_value_REG;
  assign io_read_2_value = io_read_2_value_REG;
  assign io_read_3_value = io_read_3_value_REG;
  assign io_read_4_value = io_read_4_value_REG;
  assign io_read_5_value = io_read_5_value_REG;
  assign io_read_6_value = io_read_6_value_REG;
  assign io_read_7_value = io_read_7_value_REG;
endmodule

