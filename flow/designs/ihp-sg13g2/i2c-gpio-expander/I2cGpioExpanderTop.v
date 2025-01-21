// Generator : SpinalHDL v1.10.2a    git head : a348a60b7e8b6a455c72e1536ec3d74a2ea16935
// Component : SG13G2Top
// Git hash  : dbd10e6c9374bd7bc3ffc29e541415e2be16643a

`timescale 1ns/1ps

module I2cGpioExpanderTop (
  inout  wire          io_clock_PAD,
  inout  wire          io_reset_PAD,
  inout  wire          io_i2c_scl_PAD,
  inout  wire          io_i2c_sda_PAD,
  inout  wire          io_i2c_interrupt_PAD,
  inout  wire          io_gpio_0_PAD,
  inout  wire          io_gpio_1_PAD,
  inout  wire          io_gpio_2_PAD,
  inout  wire          io_gpio_3_PAD,
  inout  wire          io_gpio_4_PAD,
  inout  wire          io_gpio_5_PAD,
  inout  wire          io_gpio_6_PAD,
  inout  wire          io_gpio_7_PAD,
  inout  wire          io_address_0_PAD,
  inout  wire          io_address_1_PAD,
  inout  wire          io_address_2_PAD
);

  reg        [7:0]    system_expander_io_gpio_pins_read;
  wire                sg13g2_IOPad_io_i2c_interrupt_c2p;
  wire                sg13g2_IOPad_io_gpio_0_c2p;
  wire                sg13g2_IOPad_io_gpio_0_c2p_en;
  wire                sg13g2_IOPad_io_gpio_1_c2p;
  wire                sg13g2_IOPad_io_gpio_1_c2p_en;
  wire                sg13g2_IOPad_io_gpio_2_c2p;
  wire                sg13g2_IOPad_io_gpio_2_c2p_en;
  wire                sg13g2_IOPad_io_gpio_3_c2p;
  wire                sg13g2_IOPad_io_gpio_3_c2p_en;
  wire                sg13g2_IOPad_io_gpio_4_c2p;
  wire                sg13g2_IOPad_io_gpio_4_c2p_en;
  wire                sg13g2_IOPad_io_gpio_5_c2p;
  wire                sg13g2_IOPad_io_gpio_5_c2p_en;
  wire                sg13g2_IOPad_io_gpio_6_c2p;
  wire                sg13g2_IOPad_io_gpio_6_c2p_en;
  wire                sg13g2_IOPad_io_gpio_7_c2p;
  wire                sg13g2_IOPad_io_gpio_7_c2p_en;
  wire                sg13g2_IOPad_io_clock_p2c;
  wire                sg13g2_IOPad_io_reset_p2c;
  wire                sg13g2_IOPad_io_address_0_p2c;
  wire                sg13g2_IOPad_io_address_1_p2c;
  wire                sg13g2_IOPad_io_address_2_p2c;
  wire                system_expander_io_i2c_scl_write;
  wire                system_expander_io_i2c_sda_write;
  wire       [0:0]    system_expander_io_i2c_interrupts;
  wire       [7:0]    system_expander_io_gpio_pins_write;
  wire       [7:0]    system_expander_io_gpio_pins_writeEnable;
  wire                sg13g2_IOPad_io_i2c_scl_p2c;
  wire                sg13g2_IOPad_io_i2c_sda_p2c;
  wire                sg13g2_IOPad_io_gpio_0_p2c;
  wire                sg13g2_IOPad_io_gpio_1_p2c;
  wire                sg13g2_IOPad_io_gpio_2_p2c;
  wire                sg13g2_IOPad_io_gpio_3_p2c;
  wire                sg13g2_IOPad_io_gpio_4_p2c;
  wire                sg13g2_IOPad_io_gpio_5_p2c;
  wire                sg13g2_IOPad_io_gpio_6_p2c;
  wire                sg13g2_IOPad_io_gpio_7_p2c;
  wire                clock;
  wire                reset;
  reg        [2:0]    address;

  sg13g2_IOPadIn sg13g2_IOPad_io_clock (
    .p2c (sg13g2_IOPad_io_clock_p2c), //o
    .pad (io_clock_PAD             )  //~
  );
  sg13g2_IOPadIn sg13g2_IOPad_io_reset (
    .p2c (sg13g2_IOPad_io_reset_p2c), //o
    .pad (io_reset_PAD             )  //~
  );
  sg13g2_IOPadIn sg13g2_IOPad_io_address_0 (
    .p2c (sg13g2_IOPad_io_address_0_p2c), //o
    .pad (io_address_0_PAD             )  //~
  );
  sg13g2_IOPadIn sg13g2_IOPad_io_address_1 (
    .p2c (sg13g2_IOPad_io_address_1_p2c), //o
    .pad (io_address_1_PAD             )  //~
  );
  sg13g2_IOPadIn sg13g2_IOPad_io_address_2 (
    .p2c (sg13g2_IOPad_io_address_2_p2c), //o
    .pad (io_address_2_PAD             )  //~
  );
  I2cGpioExpander system_expander (
    .io_address               (address[2:0]                                 ), //i
    .io_i2c_scl_write         (system_expander_io_i2c_scl_write             ), //o
    .io_i2c_scl_read          (sg13g2_IOPad_io_i2c_scl_p2c                  ), //i
    .io_i2c_sda_write         (system_expander_io_i2c_sda_write             ), //o
    .io_i2c_sda_read          (sg13g2_IOPad_io_i2c_sda_p2c                  ), //i
    .io_i2c_interrupts        (system_expander_io_i2c_interrupts            ), //o
    .io_gpio_pins_read        (system_expander_io_gpio_pins_read[7:0]       ), //i
    .io_gpio_pins_write       (system_expander_io_gpio_pins_write[7:0]      ), //o
    .io_gpio_pins_writeEnable (system_expander_io_gpio_pins_writeEnable[7:0]), //o
    .clock                    (clock                                        ), //i
    .reset                    (reset                                        )  //i
  );
  sg13g2_IOPadOut4mA sg13g2_IOPad_io_i2c_interrupt (
    .c2p (sg13g2_IOPad_io_i2c_interrupt_c2p), //i
    .pad (io_i2c_interrupt_PAD             )  //~
  );
  sg13g2_IOPadInOut4mA sg13g2_IOPad_io_i2c_scl (
    .c2p    (1'b0                            ), //i
    .c2p_en (system_expander_io_i2c_scl_write), //i
    .p2c    (sg13g2_IOPad_io_i2c_scl_p2c     ), //o
    .pad    (io_i2c_scl_PAD                  )  //~
  );
  sg13g2_IOPadInOut4mA sg13g2_IOPad_io_i2c_sda (
    .c2p    (1'b0                            ), //i
    .c2p_en (system_expander_io_i2c_sda_write), //i
    .p2c    (sg13g2_IOPad_io_i2c_sda_p2c     ), //o
    .pad    (io_i2c_sda_PAD                  )  //~
  );
  sg13g2_IOPadInOut16mA sg13g2_IOPad_io_gpio_0 (
    .c2p    (sg13g2_IOPad_io_gpio_0_c2p   ), //i
    .c2p_en (sg13g2_IOPad_io_gpio_0_c2p_en), //i
    .p2c    (sg13g2_IOPad_io_gpio_0_p2c   ), //o
    .pad    (io_gpio_0_PAD                )  //~
  );
  sg13g2_IOPadInOut16mA sg13g2_IOPad_io_gpio_1 (
    .c2p    (sg13g2_IOPad_io_gpio_1_c2p   ), //i
    .c2p_en (sg13g2_IOPad_io_gpio_1_c2p_en), //i
    .p2c    (sg13g2_IOPad_io_gpio_1_p2c   ), //o
    .pad    (io_gpio_1_PAD                )  //~
  );
  sg13g2_IOPadInOut16mA sg13g2_IOPad_io_gpio_2 (
    .c2p    (sg13g2_IOPad_io_gpio_2_c2p   ), //i
    .c2p_en (sg13g2_IOPad_io_gpio_2_c2p_en), //i
    .p2c    (sg13g2_IOPad_io_gpio_2_p2c   ), //o
    .pad    (io_gpio_2_PAD                )  //~
  );
  sg13g2_IOPadInOut16mA sg13g2_IOPad_io_gpio_3 (
    .c2p    (sg13g2_IOPad_io_gpio_3_c2p   ), //i
    .c2p_en (sg13g2_IOPad_io_gpio_3_c2p_en), //i
    .p2c    (sg13g2_IOPad_io_gpio_3_p2c   ), //o
    .pad    (io_gpio_3_PAD                )  //~
  );
  sg13g2_IOPadInOut16mA sg13g2_IOPad_io_gpio_4 (
    .c2p    (sg13g2_IOPad_io_gpio_4_c2p   ), //i
    .c2p_en (sg13g2_IOPad_io_gpio_4_c2p_en), //i
    .p2c    (sg13g2_IOPad_io_gpio_4_p2c   ), //o
    .pad    (io_gpio_4_PAD                )  //~
  );
  sg13g2_IOPadInOut16mA sg13g2_IOPad_io_gpio_5 (
    .c2p    (sg13g2_IOPad_io_gpio_5_c2p   ), //i
    .c2p_en (sg13g2_IOPad_io_gpio_5_c2p_en), //i
    .p2c    (sg13g2_IOPad_io_gpio_5_p2c   ), //o
    .pad    (io_gpio_5_PAD                )  //~
  );
  sg13g2_IOPadInOut16mA sg13g2_IOPad_io_gpio_6 (
    .c2p    (sg13g2_IOPad_io_gpio_6_c2p   ), //i
    .c2p_en (sg13g2_IOPad_io_gpio_6_c2p_en), //i
    .p2c    (sg13g2_IOPad_io_gpio_6_p2c   ), //o
    .pad    (io_gpio_6_PAD                )  //~
  );
  sg13g2_IOPadInOut16mA sg13g2_IOPad_io_gpio_7 (
    .c2p    (sg13g2_IOPad_io_gpio_7_c2p   ), //i
    .c2p_en (sg13g2_IOPad_io_gpio_7_c2p_en), //i
    .p2c    (sg13g2_IOPad_io_gpio_7_p2c   ), //o
    .pad    (io_gpio_7_PAD                )  //~
  );
  assign clock = sg13g2_IOPad_io_clock_p2c;
  assign reset = sg13g2_IOPad_io_reset_p2c;
  always @(*) begin
    address[0] = sg13g2_IOPad_io_address_0_p2c;
    address[1] = sg13g2_IOPad_io_address_1_p2c;
    address[2] = sg13g2_IOPad_io_address_2_p2c;
  end

  assign sg13g2_IOPad_io_i2c_interrupt_c2p = system_expander_io_i2c_interrupts[0];
  assign sg13g2_IOPad_io_gpio_0_c2p = system_expander_io_gpio_pins_write[0];
  assign sg13g2_IOPad_io_gpio_0_c2p_en = system_expander_io_gpio_pins_writeEnable[0];
  always @(*) begin
    system_expander_io_gpio_pins_read[0] = sg13g2_IOPad_io_gpio_0_p2c;
    system_expander_io_gpio_pins_read[1] = sg13g2_IOPad_io_gpio_1_p2c;
    system_expander_io_gpio_pins_read[2] = sg13g2_IOPad_io_gpio_2_p2c;
    system_expander_io_gpio_pins_read[3] = sg13g2_IOPad_io_gpio_3_p2c;
    system_expander_io_gpio_pins_read[4] = sg13g2_IOPad_io_gpio_4_p2c;
    system_expander_io_gpio_pins_read[5] = sg13g2_IOPad_io_gpio_5_p2c;
    system_expander_io_gpio_pins_read[6] = sg13g2_IOPad_io_gpio_6_p2c;
    system_expander_io_gpio_pins_read[7] = sg13g2_IOPad_io_gpio_7_p2c;
  end

  assign sg13g2_IOPad_io_gpio_1_c2p = system_expander_io_gpio_pins_write[1];
  assign sg13g2_IOPad_io_gpio_1_c2p_en = system_expander_io_gpio_pins_writeEnable[1];
  assign sg13g2_IOPad_io_gpio_2_c2p = system_expander_io_gpio_pins_write[2];
  assign sg13g2_IOPad_io_gpio_2_c2p_en = system_expander_io_gpio_pins_writeEnable[2];
  assign sg13g2_IOPad_io_gpio_3_c2p = system_expander_io_gpio_pins_write[3];
  assign sg13g2_IOPad_io_gpio_3_c2p_en = system_expander_io_gpio_pins_writeEnable[3];
  assign sg13g2_IOPad_io_gpio_4_c2p = system_expander_io_gpio_pins_write[4];
  assign sg13g2_IOPad_io_gpio_4_c2p_en = system_expander_io_gpio_pins_writeEnable[4];
  assign sg13g2_IOPad_io_gpio_5_c2p = system_expander_io_gpio_pins_write[5];
  assign sg13g2_IOPad_io_gpio_5_c2p_en = system_expander_io_gpio_pins_writeEnable[5];
  assign sg13g2_IOPad_io_gpio_6_c2p = system_expander_io_gpio_pins_write[6];
  assign sg13g2_IOPad_io_gpio_6_c2p_en = system_expander_io_gpio_pins_writeEnable[6];
  assign sg13g2_IOPad_io_gpio_7_c2p = system_expander_io_gpio_pins_write[7];
  assign sg13g2_IOPad_io_gpio_7_c2p_en = system_expander_io_gpio_pins_writeEnable[7];

endmodule
