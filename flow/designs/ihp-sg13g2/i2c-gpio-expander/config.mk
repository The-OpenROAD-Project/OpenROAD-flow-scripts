export DESIGN_NAME = I2cGpioExpanderTop
export DESIGN_NICKNAME = i2c-gpio-expander
export PLATFORM = ihp-sg13g2

export VERILOG_FILES = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/$(DESIGN_NAME).v \
                       $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/I2cGpioExpander.v
export SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export SEAL_GDS = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/sealring.gds.gz

export DIE_AREA = 0.0 0.0 1050.0 1050.0
export CORE_AREA = 425.28 427.16 631.2 630.24

export MAX_ROUTING_LAYER = TopMetal2

export TNS_END_PERCENT = 100
export PLACE_DENSITY = 0.75

export CORNERS = slow fast

export FOOTPRINT_TCL = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/pad.tcl
export PDN_TCL = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/pdn.tcl
