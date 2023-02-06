export DESIGN_NICKNAME = ariane136
export DESIGN_NAME = ariane
export PLATFORM    = nangate45

export VERILOG_FILES = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/ariane_netlist.v 

export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
export ABC_CLOCK_PERIOD_IN_PS = 4000

export ADDITIONAL_LEFS = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/fakeram45_256x16.lef
export ADDITIONAL_LIBS = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/fakeram45_256x16.lib

# These values must be multiples of placement site
export DIE_AREA    = 0.0 0.0 1500 1500
export CORE_AREA   = 10.07 9.94 1490 1490 
export PLACE_PINS_ARGS = -exclude left:0-400 -exclude left:1200-1500 -exclude right:* -exclude top:* -exclude bottom:*

export PLACE_DENSITY_LB_ADDON ?= 0.20
