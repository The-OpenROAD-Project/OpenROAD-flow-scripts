export DESIGN_NAME = I2cGpioExpanderTop
export DESIGN_NICKNAME = i2c-gpio-expander
export PLATFORM = ihp-sg13g2

export VERILOG_FILES = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/$(DESIGN_NAME).v \
                       $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/I2cGpioExpander.v
export SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export SEAL_GDS = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/sealring.gds.gz

export DIE_AREA = 0.0 0.0 1050.24 1050.84
export CORE_AREA = 351.36 351.54 699.84 699.3

export MAX_ROUTING_LAYER = TopMetal2

export TNS_END_PERCENT = 100
export PLACE_DENSITY = 0.75
export MACRO_PLACE_HALO = 20 20
export CORNERS = slow fast

export FOOTPRINT_TCL = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/pad.tcl
export PDN_TCL = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/pdn.tcl

export BLOCKS = I2cDeviceCtrl
