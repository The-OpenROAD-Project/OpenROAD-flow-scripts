export DESIGN_NAME = I2cGpioExpanderTop
export DESIGN_NICKNAME = i2c-gpio-expander
export PLATFORM = ihp-sg13cmos5l

export VERILOG_FILES = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/$(DESIGN_NAME).v \
                       $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/I2cGpioExpander.v
export SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export DIE_AREA = 0.0 0.0 1050.24 1050.84
export CORE_AREA = 351.36 351.54 699.84 699.3

export MAX_ROUTING_LAYER = TopMetal1

export TNS_END_PERCENT = 100
export PLACE_DENSITY = 0.75
export MACRO_PLACE_HALO = 20 20
export CORNERS = slow fast

export IO_NORTH_PINS = sg13cmos5l_IOPad_io_gpio_3 \
sg13cmos5l_IOPad_io_gpio_4 \
sg13cmos5l_IOPad_io_gpio_5 \
sg13cmos5l_IOPad_io_gpio_6 \
sg13cmos5l_IOPad_io_gpio_7
export IO_EAST_PINS = sg13cmos5l_IOPadVdd_inst \
sg13cmos5l_IOPadVss_inst \
sg13cmos5l_IOPad_io_address_0 \
sg13cmos5l_IOPad_io_address_1 \
sg13cmos5l_IOPad_io_address_2
export IO_SOUTH_PINS = sg13cmos5l_IOPad_io_clock \
sg13cmos5l_IOPad_io_reset \
sg13cmos5l_IOPad_io_i2c_scl \
sg13cmos5l_IOPad_io_i2c_sda \
sg13cmos5l_IOPad_io_i2c_interrupt
export IO_WEST_PINS = sg13cmos5l_IOPad_io_gpio_0 \
sg13cmos5l_IOPad_io_gpio_1 \
sg13cmos5l_IOPad_io_gpio_2 \
sg13cmos5l_IOPadIOVss_inst \
sg13cmos5l_IOPadIOVdd_inst

export SEAL_GDS = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/macros/sealring/sealring.gds.gz

export ADDITIONAL_LEFS += $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/macros/bondpad/bondpad_70x70.lef
export ADDITIONAL_GDS += $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/macros/bondpad/bondpad_70x70.gds.gz

export FOOTPRINT_TCL = $(PLATFORM_DIR)/pad.tcl

export PDN_TCL = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/pdn.tcl
