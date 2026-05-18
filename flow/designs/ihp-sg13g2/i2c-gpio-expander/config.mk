export DESIGN_NAME = I2cGpioExpanderTop
export DESIGN_NICKNAME = i2c-gpio-expander
export PLATFORM = ihp-sg13g2

export VERILOG_FILES = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/$(DESIGN_NAME).v \
                       $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/I2cGpioExpander.v
# IO pad cells -- platform config.mk adds these conditionally when
# FOOTPRINT_TCL is set, but declare them explicitly for robustness.
export VERILOG_FILES += $(PLATFORM_DIR)/verilog/sg13g2_io.v
export ADDITIONAL_LEFS += $(PLATFORM_DIR)/lef/sg13g2_io.lef \
                          $(PLATFORM_DIR)/lef/bondpad_70x70.lef
export ADDITIONAL_LIBS += $(PLATFORM_DIR)/lib/sg13g2_io_typ_1p2V_3p3V_25C.lib
export ADDITIONAL_SLOW_LIBS += $(PLATFORM_DIR)/lib/sg13g2_io_slow_1p08V_3p0V_125C.lib
export ADDITIONAL_FAST_LIBS += $(PLATFORM_DIR)/lib/sg13g2_io_fast_1p32V_3p6V_m40C.lib
export ADDITIONAL_GDS += $(PLATFORM_DIR)/gds/sg13g2_io.gds
export SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export SEAL_GDS = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/sealring.gds.gz

export DIE_AREA = 0.0 0.0 1050.24 1050.84
export CORE_AREA = 351.36 351.54 699.84 699.3

export MAX_ROUTING_LAYER = TopMetal2

export TNS_END_PERCENT = 100
export PLACE_DENSITY = 0.75
export MACRO_PLACE_HALO = 20 20
export CORNERS = slow fast

export IO_NORTH_PINS = sg13g2_IOPad_io_gpio_3 \
sg13g2_IOPad_io_gpio_4 \
sg13g2_IOPad_io_gpio_5 \
sg13g2_IOPad_io_gpio_6 \
sg13g2_IOPad_io_gpio_7
export IO_EAST_PINS = sg13g2_IOPadVdd_inst \
sg13g2_IOPadVss_inst \
sg13g2_IOPad_io_address_0 \
sg13g2_IOPad_io_address_1 \
sg13g2_IOPad_io_address_2
export IO_SOUTH_PINS = sg13g2_IOPad_io_clock \
sg13g2_IOPad_io_reset \
sg13g2_IOPad_io_i2c_scl \
sg13g2_IOPad_io_i2c_sda \
sg13g2_IOPad_io_i2c_interrupt
export IO_WEST_PINS = sg13g2_IOPad_io_gpio_0 \
sg13g2_IOPad_io_gpio_1 \
sg13g2_IOPad_io_gpio_2 \
sg13g2_IOPadIOVss_inst \
sg13g2_IOPadIOVdd_inst
export FOOTPRINT_TCL = $(PLATFORM_DIR)/pad.tcl

export MACRO_PLACEMENT_TCL = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/macros.tcl

export PDN_TCL = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/pdn.tcl

export BLOCKS = I2cDeviceCtrl

