export DESIGN_NICKNAME = ariane136
export DESIGN_NAME = ariane
export PLATFORM    = sky130hd_fakestack

export SYNTH_HIERARCHICAL = 1
export MAX_UNGROUP_SIZE = 10000

export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ariane.sv2v.v \
                       $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/macros.v

export ADDITIONAL_LEFS = $(PLATFORM_DIR)/lef/fakeram130_256x16.lef
export ADDITIONAL_LIBS = $(PLATFORM_DIR)/lib/fakeram130_256x16.lib

# These values must be multiples of placement site
export DIE_AREA    = 0.0 0.0 4600 4600 
export CORE_AREA   = 10.07 9.94 4590 4590
export PLACE_PINS_ARGS = -exclude left:0-2000 -exclude left:3200-4600 -exclude right:* -exclude top:* -exclude bottom:*
#
# RTL_MP Settings
export RTLMP_MAX_INST = 5000
export RTLMP_MIN_INST = 1000
export RTLMP_MAX_MACRO = 24
export RTLMP_MIN_MACRO = 4

export GPL_TIMING_DRIVEN = 0
export GPL_ROUTABILITY_DRIVEN = 0

export MACRO_PLACE_HALO = 10 10

export PLACE_DENSITY_LB_ADDON ?= 0.20
