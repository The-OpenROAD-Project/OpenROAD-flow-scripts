// Generator : SpinalHDL v1.10.2a    git head : a348a60b7e8b6a455c72e1536ec3d74a2ea16935
// Component : SG13G2Top
// Git hash  : dbd10e6c9374bd7bc3ffc29e541415e2be16643a

`timescale 1ns/1ps

module I2cGpioExpander (
  input  wire [2:0]    io_address,
  output wire          io_i2c_scl_write,
  input  wire          io_i2c_scl_read,
  output wire          io_i2c_sda_write,
  input  wire          io_i2c_sda_read,
  output wire [0:0]    io_i2c_interrupts,
  input  wire [7:0]    io_gpio_pins_read,
  output wire [7:0]    io_gpio_pins_write,
  output wire [7:0]    io_gpio_pins_writeEnable,
  input  wire          clock,
  input  wire          reset
);
  localparam State_IDLE = 3'd0;
  localparam State_REG_1 = 3'd1;
  localparam State_READ = 3'd2;
  localparam State_WRITE = 3'd3;
  localparam State_RESPONSE = 3'd4;

  wire       [6:0]    i2cCtrl_io_config_deviceAddr;
  wire       [0:0]    i2cCtrl_io_interrupts;
  reg                 i2cCtrl_io_cmd_ready;
  reg                 i2cCtrl_io_rsp_valid;
  reg        [7:0]    irq_high_ctrl_io_clears;
  reg        [7:0]    irq_low_ctrl_io_clears;
  reg        [7:0]    irq_rise_ctrl_io_clears;
  reg        [7:0]    irq_fall_ctrl_io_clears;
  wire                i2cCtrl_io_i2c_scl_write;
  wire                i2cCtrl_io_i2c_sda_write;
  wire       [0:0]    i2cCtrl_io_i2c_interrupts;
  wire                i2cCtrl_io_cmd_valid;
  wire       [7:0]    i2cCtrl_io_cmd_payload_data;
  wire                i2cCtrl_io_cmd_payload_reg;
  wire                i2cCtrl_io_cmd_payload_read;
  wire                i2cCtrl_io_rsp_ready;
  wire       [7:0]    gpioCtrl_1_io_gpio_pins_write;
  wire       [7:0]    gpioCtrl_1_io_gpio_pins_writeEnable;
  wire       [7:0]    gpioCtrl_1_io_value;
  wire                gpioCtrl_1_io_interrupt;
  wire       [7:0]    gpioCtrl_1_io_irqHigh_valid;
  wire       [7:0]    gpioCtrl_1_io_irqLow_valid;
  wire       [7:0]    gpioCtrl_1_io_irqRise_valid;
  wire       [7:0]    gpioCtrl_1_io_irqFall_valid;
  wire       [7:0]    irq_high_ctrl_io_pendings;
  wire       [7:0]    irq_low_ctrl_io_pendings;
  wire       [7:0]    irq_rise_ctrl_io_pendings;
  wire       [7:0]    irq_fall_ctrl_io_pendings;
  reg        [2:0]    i2cConfig_latchedAddress;
  reg                 i2cConfig_latch;
  wire                when_I2cGpioExpander_l46;
  reg        [7:0]    gpioConfig_write;
  reg        [7:0]    gpioConfig_direction;
  reg        [7:0]    irq_high_masks;
  reg        [7:0]    irq_low_masks;
  reg        [7:0]    irq_rise_masks;
  reg        [7:0]    irq_fall_masks;
  reg        [7:0]    link_regAddr;
  reg        [2:0]    link_state;
  reg        [7:0]    link_data;
  reg                 link_error;
  wire       [7:0]    switch_I2cGpioExpander_l139;
  wire       [7:0]    switch_I2cGpioExpander_l182;
  `ifndef SYNTHESIS
  reg [63:0] link_state_string;
  `endif


  I2cDeviceCtrl i2cCtrl (
    .io_config_clockDivider (16'h0001                         ), //i
    .io_config_timeout      (16'h1388                         ), //i
    .io_config_deviceAddr   (i2cCtrl_io_config_deviceAddr[6:0]), //i
    .io_i2c_scl_write       (i2cCtrl_io_i2c_scl_write         ), //o
    .io_i2c_scl_read        (io_i2c_scl_read                  ), //i
    .io_i2c_sda_write       (i2cCtrl_io_i2c_sda_write         ), //o
    .io_i2c_sda_read        (io_i2c_sda_read                  ), //i
    .io_i2c_interrupts      (i2cCtrl_io_i2c_interrupts        ), //o
    .io_interrupts          (i2cCtrl_io_interrupts            ), //i
    .io_cmd_valid           (i2cCtrl_io_cmd_valid             ), //o
    .io_cmd_ready           (i2cCtrl_io_cmd_ready             ), //i
    .io_cmd_payload_data    (i2cCtrl_io_cmd_payload_data[7:0] ), //o
    .io_cmd_payload_reg     (i2cCtrl_io_cmd_payload_reg       ), //o
    .io_cmd_payload_read    (i2cCtrl_io_cmd_payload_read      ), //o
    .io_rsp_valid           (i2cCtrl_io_rsp_valid             ), //i
    .io_rsp_ready           (i2cCtrl_io_rsp_ready             ), //o
    .io_rsp_payload_data    (link_data[7:0]                   ), //i
    .io_rsp_payload_error   (link_error                       ), //i
    .clock                  (clock                            ), //i
    .reset                  (reset                            )  //i
  );
  GpioCtrl gpioCtrl_1 (
    .io_gpio_pins_read        (io_gpio_pins_read[7:0]                  ), //i
    .io_gpio_pins_write       (gpioCtrl_1_io_gpio_pins_write[7:0]      ), //o
    .io_gpio_pins_writeEnable (gpioCtrl_1_io_gpio_pins_writeEnable[7:0]), //o
    .io_config_write          (gpioConfig_write[7:0]                   ), //i
    .io_config_direction      (gpioConfig_direction[7:0]               ), //i
    .io_value                 (gpioCtrl_1_io_value[7:0]                ), //o
    .io_interrupt             (gpioCtrl_1_io_interrupt                 ), //o
    .io_irqHigh_valid         (gpioCtrl_1_io_irqHigh_valid[7:0]        ), //o
    .io_irqHigh_pending       (irq_high_ctrl_io_pendings[7:0]          ), //i
    .io_irqLow_valid          (gpioCtrl_1_io_irqLow_valid[7:0]         ), //o
    .io_irqLow_pending        (irq_low_ctrl_io_pendings[7:0]           ), //i
    .io_irqRise_valid         (gpioCtrl_1_io_irqRise_valid[7:0]        ), //o
    .io_irqRise_pending       (irq_rise_ctrl_io_pendings[7:0]          ), //i
    .io_irqFall_valid         (gpioCtrl_1_io_irqFall_valid[7:0]        ), //o
    .io_irqFall_pending       (irq_fall_ctrl_io_pendings[7:0]          ), //i
    .clock                    (clock                                   ), //i
    .reset                    (reset                                   )  //i
  );
  InterruptCtrl irq_high_ctrl (
    .io_inputs   (gpioCtrl_1_io_irqHigh_valid[7:0]), //i
    .io_clears   (irq_high_ctrl_io_clears[7:0]    ), //i
    .io_masks    (irq_high_masks[7:0]             ), //i
    .io_pendings (irq_high_ctrl_io_pendings[7:0]  ), //o
    .clock       (clock                           ), //i
    .reset       (reset                           )  //i
  );
  InterruptCtrl irq_low_ctrl (
    .io_inputs   (gpioCtrl_1_io_irqLow_valid[7:0]), //i
    .io_clears   (irq_low_ctrl_io_clears[7:0]    ), //i
    .io_masks    (irq_low_masks[7:0]             ), //i
    .io_pendings (irq_low_ctrl_io_pendings[7:0]  ), //o
    .clock       (clock                          ), //i
    .reset       (reset                          )  //i
  );
  InterruptCtrl irq_rise_ctrl (
    .io_inputs   (gpioCtrl_1_io_irqRise_valid[7:0]), //i
    .io_clears   (irq_rise_ctrl_io_clears[7:0]    ), //i
    .io_masks    (irq_rise_masks[7:0]             ), //i
    .io_pendings (irq_rise_ctrl_io_pendings[7:0]  ), //o
    .clock       (clock                           ), //i
    .reset       (reset                           )  //i
  );
  InterruptCtrl irq_fall_ctrl (
    .io_inputs   (gpioCtrl_1_io_irqFall_valid[7:0]), //i
    .io_clears   (irq_fall_ctrl_io_clears[7:0]    ), //i
    .io_masks    (irq_fall_masks[7:0]             ), //i
    .io_pendings (irq_fall_ctrl_io_pendings[7:0]  ), //o
    .clock       (clock                           ), //i
    .reset       (reset                           )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(link_state)
      State_IDLE : link_state_string = "IDLE    ";
      State_REG_1 : link_state_string = "REG_1   ";
      State_READ : link_state_string = "READ    ";
      State_WRITE : link_state_string = "WRITE   ";
      State_RESPONSE : link_state_string = "RESPONSE";
      default : link_state_string = "????????";
    endcase
  end
  `endif

  assign io_i2c_scl_write = i2cCtrl_io_i2c_scl_write;
  assign io_i2c_sda_write = i2cCtrl_io_i2c_sda_write;
  assign io_i2c_interrupts = i2cCtrl_io_i2c_interrupts;
  assign when_I2cGpioExpander_l46 = (! i2cConfig_latch);
  assign i2cCtrl_io_config_deviceAddr = {4'b0110,i2cConfig_latchedAddress};
  assign io_gpio_pins_write = gpioCtrl_1_io_gpio_pins_write;
  assign io_gpio_pins_writeEnable = gpioCtrl_1_io_gpio_pins_writeEnable;
  always @(*) begin
    irq_high_ctrl_io_clears = 8'h0;
    case(link_state)
      State_IDLE : begin
      end
      State_REG_1 : begin
      end
      State_READ : begin
      end
      State_WRITE : begin
        case(switch_I2cGpioExpander_l182)
          8'h01 : begin
          end
          8'h02 : begin
          end
          8'h03 : begin
            irq_high_ctrl_io_clears = i2cCtrl_io_cmd_payload_data;
          end
          8'h04 : begin
          end
          8'h05 : begin
          end
          8'h06 : begin
          end
          8'h07 : begin
          end
          8'h08 : begin
          end
          8'h09 : begin
          end
          8'h0a : begin
          end
          default : begin
          end
        endcase
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    irq_low_ctrl_io_clears = 8'h0;
    case(link_state)
      State_IDLE : begin
      end
      State_REG_1 : begin
      end
      State_READ : begin
      end
      State_WRITE : begin
        case(switch_I2cGpioExpander_l182)
          8'h01 : begin
          end
          8'h02 : begin
          end
          8'h03 : begin
          end
          8'h04 : begin
            irq_low_ctrl_io_clears = i2cCtrl_io_cmd_payload_data;
          end
          8'h05 : begin
          end
          8'h06 : begin
          end
          8'h07 : begin
          end
          8'h08 : begin
          end
          8'h09 : begin
          end
          8'h0a : begin
          end
          default : begin
          end
        endcase
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    irq_rise_ctrl_io_clears = 8'h0;
    case(link_state)
      State_IDLE : begin
      end
      State_REG_1 : begin
      end
      State_READ : begin
      end
      State_WRITE : begin
        case(switch_I2cGpioExpander_l182)
          8'h01 : begin
          end
          8'h02 : begin
          end
          8'h03 : begin
          end
          8'h04 : begin
          end
          8'h05 : begin
            irq_rise_ctrl_io_clears = i2cCtrl_io_cmd_payload_data;
          end
          8'h06 : begin
          end
          8'h07 : begin
          end
          8'h08 : begin
          end
          8'h09 : begin
          end
          8'h0a : begin
          end
          default : begin
          end
        endcase
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    irq_fall_ctrl_io_clears = 8'h0;
    case(link_state)
      State_IDLE : begin
      end
      State_REG_1 : begin
      end
      State_READ : begin
      end
      State_WRITE : begin
        case(switch_I2cGpioExpander_l182)
          8'h01 : begin
          end
          8'h02 : begin
          end
          8'h03 : begin
          end
          8'h04 : begin
          end
          8'h05 : begin
          end
          8'h06 : begin
            irq_fall_ctrl_io_clears = i2cCtrl_io_cmd_payload_data;
          end
          8'h07 : begin
          end
          8'h08 : begin
          end
          8'h09 : begin
          end
          8'h0a : begin
          end
          default : begin
          end
        endcase
      end
      default : begin
      end
    endcase
  end

  assign i2cCtrl_io_interrupts = (|(((irq_high_ctrl_io_pendings | irq_low_ctrl_io_pendings) | irq_rise_ctrl_io_pendings) | irq_fall_ctrl_io_pendings));
  always @(*) begin
    i2cCtrl_io_cmd_ready = 1'b0;
    case(link_state)
      State_IDLE : begin
      end
      State_REG_1 : begin
        i2cCtrl_io_cmd_ready = 1'b1;
      end
      State_READ : begin
        i2cCtrl_io_cmd_ready = 1'b1;
      end
      State_WRITE : begin
        i2cCtrl_io_cmd_ready = 1'b1;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    i2cCtrl_io_rsp_valid = 1'b0;
    case(link_state)
      State_IDLE : begin
      end
      State_REG_1 : begin
      end
      State_READ : begin
      end
      State_WRITE : begin
      end
      default : begin
        i2cCtrl_io_rsp_valid = 1'b1;
      end
    endcase
  end

  assign switch_I2cGpioExpander_l139 = link_regAddr;
  assign switch_I2cGpioExpander_l182 = link_regAddr;
  always @(posedge clock) begin
    if(!reset) begin
      i2cConfig_latch <= 1'b0;
      gpioConfig_write <= 8'h0;
      gpioConfig_direction <= 8'h0;
      irq_high_masks <= 8'h0;
      irq_low_masks <= 8'h0;
      irq_rise_masks <= 8'h0;
      irq_fall_masks <= 8'h0;
      link_state <= State_IDLE;
      link_data <= 8'h0;
      link_error <= 1'b0;
    end else begin
      if(when_I2cGpioExpander_l46) begin
        i2cConfig_latch <= 1'b1;
      end
      case(link_state)
        State_IDLE : begin
          if(i2cCtrl_io_cmd_valid) begin
            link_error <= 1'b0;
            if(i2cCtrl_io_cmd_payload_read) begin
              link_state <= State_READ;
            end else begin
              if(i2cCtrl_io_cmd_payload_reg) begin
                link_state <= State_REG_1;
              end else begin
                link_state <= State_WRITE;
              end
            end
          end
        end
        State_REG_1 : begin
          link_state <= State_RESPONSE;
        end
        State_READ : begin
          case(switch_I2cGpioExpander_l139)
            8'h0 : begin
              link_data <= gpioCtrl_1_io_value;
            end
            8'h01 : begin
              link_data <= gpioConfig_write;
            end
            8'h02 : begin
              link_data <= gpioConfig_direction;
            end
            8'h03 : begin
              link_data <= irq_high_ctrl_io_pendings;
            end
            8'h04 : begin
              link_data <= irq_low_ctrl_io_pendings;
            end
            8'h05 : begin
              link_data <= irq_rise_ctrl_io_pendings;
            end
            8'h06 : begin
              link_data <= irq_fall_ctrl_io_pendings;
            end
            8'h07 : begin
              link_data <= irq_high_masks;
            end
            8'h08 : begin
              link_data <= irq_low_masks;
            end
            8'h09 : begin
              link_data <= irq_rise_masks;
            end
            8'h0a : begin
              link_data <= irq_fall_masks;
            end
            default : begin
              link_error <= 1'b1;
            end
          endcase
          link_state <= State_RESPONSE;
        end
        State_WRITE : begin
          case(switch_I2cGpioExpander_l182)
            8'h01 : begin
              gpioConfig_write <= i2cCtrl_io_cmd_payload_data;
            end
            8'h02 : begin
              gpioConfig_direction <= i2cCtrl_io_cmd_payload_data;
            end
            8'h03 : begin
            end
            8'h04 : begin
            end
            8'h05 : begin
            end
            8'h06 : begin
            end
            8'h07 : begin
              irq_high_masks <= i2cCtrl_io_cmd_payload_data;
            end
            8'h08 : begin
              irq_low_masks <= i2cCtrl_io_cmd_payload_data;
            end
            8'h09 : begin
              irq_rise_masks <= i2cCtrl_io_cmd_payload_data;
            end
            8'h0a : begin
              irq_fall_masks <= i2cCtrl_io_cmd_payload_data;
            end
            default : begin
              link_error <= 1'b1;
            end
          endcase
          link_state <= State_RESPONSE;
        end
        default : begin
          if(i2cCtrl_io_rsp_ready) begin
            link_state <= State_IDLE;
          end
        end
      endcase
    end
  end

  always @(posedge clock) begin
    if(when_I2cGpioExpander_l46) begin
      i2cConfig_latchedAddress <= io_address;
    end
    case(link_state)
      State_IDLE : begin
      end
      State_REG_1 : begin
        link_regAddr <= i2cCtrl_io_cmd_payload_data;
      end
      State_READ : begin
        link_regAddr <= (link_regAddr + 8'h01);
      end
      State_WRITE : begin
        link_regAddr <= (link_regAddr + 8'h01);
      end
      default : begin
      end
    endcase
  end


endmodule

//InterruptCtrl_3 replaced by InterruptCtrl

//InterruptCtrl_2 replaced by InterruptCtrl

//InterruptCtrl_1 replaced by InterruptCtrl

module InterruptCtrl (
  input  wire [7:0]    io_inputs,
  input  wire [7:0]    io_clears,
  input  wire [7:0]    io_masks,
  output wire [7:0]    io_pendings,
  input  wire          clock,
  input  wire          reset
);

  reg        [7:0]    pendings;

  assign io_pendings = (pendings & io_masks);
  always @(posedge clock) begin
    if(!reset) begin
      pendings <= 8'h0;
    end else begin
      pendings <= ((pendings & (~ io_clears)) | io_inputs);
    end
  end


endmodule

module GpioCtrl (
  input  wire [7:0]    io_gpio_pins_read,
  output wire [7:0]    io_gpio_pins_write,
  output wire [7:0]    io_gpio_pins_writeEnable,
  input  wire [7:0]    io_config_write,
  input  wire [7:0]    io_config_direction,
  output wire [7:0]    io_value,
  output wire          io_interrupt,
  output wire [7:0]    io_irqHigh_valid,
  input  wire [7:0]    io_irqHigh_pending,
  output wire [7:0]    io_irqLow_valid,
  input  wire [7:0]    io_irqLow_pending,
  output wire [7:0]    io_irqRise_valid,
  input  wire [7:0]    io_irqRise_pending,
  output wire [7:0]    io_irqFall_valid,
  input  wire [7:0]    io_irqFall_pending,
  input  wire          clock,
  input  wire          reset
);

  wire       [7:0]    io_gpio_pins_read_buffercc_io_dataOut;
  wire       [7:0]    synchronized;
  reg        [7:0]    last;

  (* keep_hierarchy = "TRUE" *) BufferCC io_gpio_pins_read_buffercc (
    .io_dataIn  (io_gpio_pins_read[7:0]                    ), //i
    .io_dataOut (io_gpio_pins_read_buffercc_io_dataOut[7:0]), //o
    .clock      (clock                                     ), //i
    .reset      (reset                                     )  //i
  );
  assign io_value = io_gpio_pins_read_buffercc_io_dataOut;
  assign synchronized = io_value;
  assign io_gpio_pins_write = io_config_write;
  assign io_gpio_pins_writeEnable = io_config_direction;
  assign io_irqHigh_valid = synchronized;
  assign io_irqLow_valid = (~ synchronized);
  assign io_irqRise_valid = (synchronized & (~ last));
  assign io_irqFall_valid = ((~ synchronized) & last);
  assign io_interrupt = (|(((io_irqHigh_pending | io_irqLow_pending) | io_irqRise_pending) | io_irqFall_pending));
  always @(posedge clock) begin
    last <= synchronized;
  end


endmodule

module I2cDeviceCtrl (
  input  wire [15:0]   io_config_clockDivider,
  input  wire [15:0]   io_config_timeout,
  input  wire [6:0]    io_config_deviceAddr,
  output wire          io_i2c_scl_write,
  input  wire          io_i2c_scl_read,
  output wire          io_i2c_sda_write,
  input  wire          io_i2c_sda_read,
  output wire [0:0]    io_i2c_interrupts,
  input  wire [0:0]    io_interrupts,
  output reg           io_cmd_valid,
  input  wire          io_cmd_ready,
  output wire [7:0]    io_cmd_payload_data,
  output wire          io_cmd_payload_reg,
  output wire          io_cmd_payload_read,
  input  wire          io_rsp_valid,
  output reg           io_rsp_ready,
  input  wire [7:0]    io_rsp_payload_data,
  input  wire          io_rsp_payload_error,
  input  wire          clock,
  input  wire          reset
);
  localparam State_1_IDLE = 2'd0;
  localparam State_1_REQ = 2'd1;
  localparam State_1_RSP = 2'd2;

  wire                io_i2c_scl_read_buffercc_io_dataOut;
  wire                io_i2c_sda_read_buffercc_io_dataOut;
  wire       [7:0]    _zz_ctrl_sdaWrite;
  wire       [2:0]    _zz_ctrl_sdaWrite_1;
  reg        [15:0]   filter_timer_counter;
  wire                filter_timer_tick;
  wire                filter_sampler_sclSync;
  wire                filter_sampler_sdaSync;
  wire                filter_sampler_sclSamples_0;
  wire                filter_sampler_sclSamples_1;
  wire                filter_sampler_sclSamples_2;
  wire                _zz_filter_sampler_sclSamples_0;
  reg                 _zz_filter_sampler_sclSamples_1;
  reg                 _zz_filter_sampler_sclSamples_2;
  wire                filter_sampler_sdaSamples_0;
  wire                filter_sampler_sdaSamples_1;
  wire                filter_sampler_sdaSamples_2;
  wire                _zz_filter_sampler_sdaSamples_0;
  reg                 _zz_filter_sampler_sdaSamples_1;
  reg                 _zz_filter_sampler_sdaSamples_2;
  reg                 filter_sda;
  reg                 filter_scl;
  wire                when_I2cDeviceCtrl_l52;
  wire                when_I2cDeviceCtrl_l55;
  wire                sclEdge_rise;
  wire                sclEdge_fall;
  wire                sclEdge_toggle;
  reg                 filter_scl_regNext;
  wire                sdaEdge_rise;
  wire                sdaEdge_fall;
  wire                sdaEdge_toggle;
  reg                 filter_sda_regNext;
  wire                detector_start;
  wire                detector_stop;
  reg        [15:0]   timeout_value;
  reg                 timeout_transmission;
  wire                when_I2cDeviceCtrl_l86;
  wire                when_I2cDeviceCtrl_l89;
  reg        [1:0]    ctrl_state;
  reg        [10:0]   ctrl_shiftRegister;
  reg        [4:0]    ctrl_bitCounter;
  reg        [3:0]    ctrl_frameCounter;
  reg                 ctrl_transmission;
  reg                 ctrl_sdaWrite;
  wire       [6:0]    ctrl_address;
  wire       [7:0]    ctrl_data;
  reg                 ctrl_read;
  wire                ctrl_write;
  reg                 ctrl_response_error;
  reg        [7:0]    ctrl_response_data;
  reg                 ctrl_cmdLock;
  wire                when_I2cDeviceCtrl_l123;
  wire       [4:0]    _zz_ctrl_bitCounter;
  wire                when_I2cDeviceCtrl_l137;
  wire                when_I2cDeviceCtrl_l138;
  wire                when_I2cDeviceCtrl_l141;
  wire                when_I2cDeviceCtrl_l145;
  wire                when_I2cDeviceCtrl_l149;
  wire                when_I2cDeviceCtrl_l150;
  wire                when_I2cDeviceCtrl_l152;
  wire                when_I2cDeviceCtrl_l157;
  wire                when_I2cDeviceCtrl_l160;
  wire                when_I2cDeviceCtrl_l175;
  wire                io_cmd_fire;
  `ifndef SYNTHESIS
  reg [31:0] ctrl_state_string;
  `endif


  assign _zz_ctrl_sdaWrite = {ctrl_response_data[0],{ctrl_response_data[1],{ctrl_response_data[2],{ctrl_response_data[3],{ctrl_response_data[4],{ctrl_response_data[5],{ctrl_response_data[6],ctrl_response_data[7]}}}}}}};
  assign _zz_ctrl_sdaWrite_1 = ctrl_bitCounter[2:0];
  (* keep_hierarchy = "TRUE" *) BufferCC_1 io_i2c_scl_read_buffercc (
    .io_dataIn  (io_i2c_scl_read                    ), //i
    .io_dataOut (io_i2c_scl_read_buffercc_io_dataOut), //o
    .clock      (clock                              ), //i
    .reset      (reset                              )  //i
  );
  (* keep_hierarchy = "TRUE" *) BufferCC_1 io_i2c_sda_read_buffercc (
    .io_dataIn  (io_i2c_sda_read                    ), //i
    .io_dataOut (io_i2c_sda_read_buffercc_io_dataOut), //o
    .clock      (clock                              ), //i
    .reset      (reset                              )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(ctrl_state)
      State_1_IDLE : ctrl_state_string = "IDLE";
      State_1_REQ : ctrl_state_string = "REQ ";
      State_1_RSP : ctrl_state_string = "RSP ";
      default : ctrl_state_string = "????";
    endcase
  end
  `endif

  assign filter_timer_tick = (filter_timer_counter == 16'h0);
  assign filter_sampler_sclSync = io_i2c_scl_read_buffercc_io_dataOut;
  assign filter_sampler_sdaSync = io_i2c_sda_read_buffercc_io_dataOut;
  assign _zz_filter_sampler_sclSamples_0 = filter_sampler_sclSync;
  assign filter_sampler_sclSamples_0 = _zz_filter_sampler_sclSamples_0;
  assign filter_sampler_sclSamples_1 = _zz_filter_sampler_sclSamples_1;
  assign filter_sampler_sclSamples_2 = _zz_filter_sampler_sclSamples_2;
  assign _zz_filter_sampler_sdaSamples_0 = filter_sampler_sdaSync;
  assign filter_sampler_sdaSamples_0 = _zz_filter_sampler_sdaSamples_0;
  assign filter_sampler_sdaSamples_1 = _zz_filter_sampler_sdaSamples_1;
  assign filter_sampler_sdaSamples_2 = _zz_filter_sampler_sdaSamples_2;
  assign when_I2cDeviceCtrl_l52 = (&{(filter_sampler_sdaSamples_2 != filter_sda),{(filter_sampler_sdaSamples_1 != filter_sda),(filter_sampler_sdaSamples_0 != filter_sda)}});
  assign when_I2cDeviceCtrl_l55 = (&{(filter_sampler_sclSamples_2 != filter_scl),{(filter_sampler_sclSamples_1 != filter_scl),(filter_sampler_sclSamples_0 != filter_scl)}});
  assign sclEdge_rise = ((! filter_scl_regNext) && filter_scl);
  assign sclEdge_fall = (filter_scl_regNext && (! filter_scl));
  assign sclEdge_toggle = (filter_scl_regNext != filter_scl);
  assign sdaEdge_rise = ((! filter_sda_regNext) && filter_sda);
  assign sdaEdge_fall = (filter_sda_regNext && (! filter_sda));
  assign sdaEdge_toggle = (filter_sda_regNext != filter_sda);
  assign detector_start = (filter_scl && sdaEdge_fall);
  assign detector_stop = (filter_scl && sdaEdge_rise);
  assign when_I2cDeviceCtrl_l86 = ((detector_start || sclEdge_rise) || sclEdge_fall);
  assign when_I2cDeviceCtrl_l89 = (filter_timer_tick && timeout_transmission);
  assign ctrl_address = ctrl_shiftRegister[7 : 1];
  assign ctrl_data = ctrl_shiftRegister[7 : 0];
  assign ctrl_write = (! ctrl_read);
  assign when_I2cDeviceCtrl_l123 = ((detector_start || detector_stop) || (timeout_value == io_config_timeout));
  assign _zz_ctrl_bitCounter[4 : 0] = 5'h1f;
  assign when_I2cDeviceCtrl_l137 = (((ctrl_frameCounter == 4'b0000) || (((ctrl_frameCounter == 4'b0001) || ((! (ctrl_frameCounter == 4'b0000)) && (! (ctrl_frameCounter == 4'b0001)))) && ctrl_write)) && (ctrl_bitCounter == 5'h08));
  assign when_I2cDeviceCtrl_l138 = ((ctrl_frameCounter == 4'b0000) && (ctrl_address == io_config_deviceAddr));
  assign when_I2cDeviceCtrl_l141 = (((ctrl_frameCounter == 4'b0001) || ((! (ctrl_frameCounter == 4'b0000)) && (! (ctrl_frameCounter == 4'b0001)))) && (! ctrl_response_error));
  assign when_I2cDeviceCtrl_l145 = ((ctrl_read && (! (ctrl_frameCounter == 4'b0000))) && (((ctrl_frameCounter == 4'b0000) && (ctrl_bitCounter < 5'h08)) || ((! (ctrl_frameCounter == 4'b0000)) && (ctrl_bitCounter < 5'h08))));
  assign when_I2cDeviceCtrl_l149 = (sclEdge_rise && ctrl_transmission);
  assign when_I2cDeviceCtrl_l150 = (((ctrl_frameCounter == 4'b0000) && (ctrl_bitCounter < 5'h08)) || ((! (ctrl_frameCounter == 4'b0000)) && (ctrl_bitCounter < 5'h08)));
  assign when_I2cDeviceCtrl_l152 = ((ctrl_frameCounter == 4'b0000) && (ctrl_bitCounter == 5'h07));
  assign when_I2cDeviceCtrl_l157 = (sclEdge_fall && ctrl_transmission);
  assign when_I2cDeviceCtrl_l160 = (ctrl_bitCounter == 5'h08);
  always @(*) begin
    io_cmd_valid = 1'b0;
    case(ctrl_state)
      State_1_IDLE : begin
      end
      State_1_REQ : begin
        io_cmd_valid = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign io_cmd_payload_data = ctrl_data;
  assign io_cmd_payload_reg = (ctrl_frameCounter == 4'b0001);
  assign io_cmd_payload_read = ctrl_read;
  always @(*) begin
    io_rsp_ready = 1'b0;
    case(ctrl_state)
      State_1_IDLE : begin
      end
      State_1_REQ : begin
      end
      default : begin
        if(io_rsp_valid) begin
          io_rsp_ready = 1'b1;
        end
      end
    endcase
  end

  assign when_I2cDeviceCtrl_l175 = (((! ctrl_cmdLock) && (ctrl_bitCounter == 5'h08)) && (((ctrl_frameCounter == 4'b0001) || (ctrl_read && (ctrl_frameCounter == 4'b0000))) || (ctrl_write && ((! (ctrl_frameCounter == 4'b0000)) && (! (ctrl_frameCounter == 4'b0001))))));
  assign io_cmd_fire = (io_cmd_valid && io_cmd_ready);
  assign io_i2c_scl_write = 1'b0;
  assign io_i2c_sda_write = ctrl_sdaWrite;
  assign io_i2c_interrupts = io_interrupts;
  always @(posedge clock) begin
    if(!reset) begin
      filter_timer_counter <= 16'h0;
      _zz_filter_sampler_sclSamples_1 <= 1'b1;
      _zz_filter_sampler_sclSamples_2 <= 1'b1;
      _zz_filter_sampler_sdaSamples_1 <= 1'b1;
      _zz_filter_sampler_sdaSamples_2 <= 1'b1;
      filter_sda <= 1'b1;
      filter_scl <= 1'b1;
      filter_scl_regNext <= 1'b1;
      filter_sda_regNext <= 1'b1;
      timeout_value <= 16'h0;
      timeout_transmission <= 1'b0;
      ctrl_state <= State_1_IDLE;
      ctrl_transmission <= 1'b0;
      ctrl_sdaWrite <= 1'b0;
    end else begin
      filter_timer_counter <= (filter_timer_counter - 16'h0001);
      if(filter_timer_tick) begin
        filter_timer_counter <= io_config_clockDivider;
      end
      if(filter_timer_tick) begin
        _zz_filter_sampler_sclSamples_1 <= _zz_filter_sampler_sclSamples_0;
      end
      if(filter_timer_tick) begin
        _zz_filter_sampler_sclSamples_2 <= _zz_filter_sampler_sclSamples_1;
      end
      if(filter_timer_tick) begin
        _zz_filter_sampler_sdaSamples_1 <= _zz_filter_sampler_sdaSamples_0;
      end
      if(filter_timer_tick) begin
        _zz_filter_sampler_sdaSamples_2 <= _zz_filter_sampler_sdaSamples_1;
      end
      if(filter_timer_tick) begin
        if(when_I2cDeviceCtrl_l52) begin
          filter_sda <= filter_sampler_sdaSamples_2;
        end
        if(when_I2cDeviceCtrl_l55) begin
          filter_scl <= filter_sampler_sclSamples_2;
        end
      end
      filter_scl_regNext <= filter_scl;
      filter_sda_regNext <= filter_sda;
      if(detector_start) begin
        timeout_transmission <= 1'b1;
      end
      if(detector_stop) begin
        timeout_transmission <= 1'b0;
      end
      if(when_I2cDeviceCtrl_l86) begin
        timeout_value <= 16'h0;
      end
      if(when_I2cDeviceCtrl_l89) begin
        timeout_value <= (timeout_value + 16'h0001);
      end
      if(when_I2cDeviceCtrl_l123) begin
        ctrl_state <= State_1_IDLE;
        if(detector_start) begin
          ctrl_transmission <= 1'b1;
        end else begin
          ctrl_transmission <= 1'b0;
        end
      end
      ctrl_sdaWrite <= 1'b0;
      if(when_I2cDeviceCtrl_l137) begin
        if(when_I2cDeviceCtrl_l138) begin
          ctrl_sdaWrite <= 1'b1;
        end
        if(when_I2cDeviceCtrl_l141) begin
          ctrl_sdaWrite <= 1'b1;
        end
      end
      if(when_I2cDeviceCtrl_l145) begin
        ctrl_sdaWrite <= (! _zz_ctrl_sdaWrite[_zz_ctrl_sdaWrite_1]);
      end
      case(ctrl_state)
        State_1_IDLE : begin
          if(when_I2cDeviceCtrl_l175) begin
            ctrl_state <= State_1_REQ;
          end
        end
        State_1_REQ : begin
          if(io_cmd_fire) begin
            ctrl_state <= State_1_RSP;
          end
        end
        default : begin
          if(io_rsp_valid) begin
            ctrl_state <= State_1_IDLE;
          end
        end
      endcase
    end
  end

  always @(posedge clock) begin
    if(when_I2cDeviceCtrl_l123) begin
      ctrl_bitCounter <= _zz_ctrl_bitCounter;
      ctrl_frameCounter <= 4'b0000;
      ctrl_read <= 1'b0;
      ctrl_response_error <= 1'b1;
    end
    if(when_I2cDeviceCtrl_l149) begin
      if(when_I2cDeviceCtrl_l150) begin
        ctrl_shiftRegister <= {ctrl_shiftRegister[9 : 0],filter_sda};
        if(when_I2cDeviceCtrl_l152) begin
          ctrl_read <= filter_sda;
        end
      end
    end
    if(when_I2cDeviceCtrl_l157) begin
      ctrl_bitCounter <= (ctrl_bitCounter + 5'h01);
      ctrl_cmdLock <= 1'b0;
      if(when_I2cDeviceCtrl_l160) begin
        ctrl_bitCounter <= 5'h0;
        ctrl_frameCounter <= (ctrl_frameCounter + 4'b0001);
      end
    end
    case(ctrl_state)
      State_1_IDLE : begin
      end
      State_1_REQ : begin
      end
      default : begin
        if(io_rsp_valid) begin
          ctrl_cmdLock <= 1'b1;
          ctrl_response_data <= io_rsp_payload_data;
          ctrl_response_error <= io_rsp_payload_error;
        end
      end
    endcase
  end


endmodule

module BufferCC (
  input  wire [7:0]    io_dataIn,
  output wire [7:0]    io_dataOut,
  input  wire          clock,
  input  wire          reset
);

  (* async_reg = "true" *) reg        [7:0]    buffers_0;

  assign io_dataOut = buffers_0;
  always @(posedge clock) begin
    buffers_0 <= io_dataIn;
  end


endmodule

//BufferCC_2 replaced by BufferCC_1

module BufferCC_1 (
  input  wire          io_dataIn,
  output wire          io_dataOut,
  input  wire          clock,
  input  wire          reset
);

  (* async_reg = "true" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clock) begin
    if(!reset) begin
      buffers_0 <= 1'b1;
      buffers_1 <= 1'b1;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule
