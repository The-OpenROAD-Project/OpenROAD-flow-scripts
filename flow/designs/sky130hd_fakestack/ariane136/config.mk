export DESIGN_NICKNAME = ariane136
export DESIGN_NAME = ariane
export PLATFORM    = sky130hd_fakestack

export VERILOG_FILES = ./designs/src/$(DESIGN_NICKNAME)/ariane.sv2v.v \
                       ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/macros.v

export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
export ABC_CLOCK_PERIOD_IN_PS = 4000

export ADDITIONAL_LEFS = $(PLATFORM_DIR)/lef/fakeram130_256x16.lef
export ADDITIONAL_LIBS = $(PLATFORM_DIR)/lib/fakeram130_256x16.lib

# These values must be multiples of placement site
export DIE_AREA    = 0.0 0.0 4600 4600 
export CORE_AREA   = 10.07 9.94 4590 4590
export PLACE_PINS_ARGS = -exclude left:0-2000 -exclude left:3200-4600 -exclude right:* -exclude top:* -exclude bottom:*

export PLACE_DENSITY_LB_ADDON ?= 0.20
