export DESIGN_NAME = ariane
export PLATFORM    = tsmc65lp

export SYNTH_HIERARCHICAL = 1
export MAX_UNGROUP_SIZE ?= 10000
export RTLMP_FLOW = True
#
# RTL_MP Settings
export RTLMP_MAX_INST = 20000
export RTLMP_MIN_INST = 5000
export RTLMP_MAX_MACRO = 12
export RTLMP_MIN_MACRO = 4

export VERILOG_FILES = ./designs/src/$(DESIGN_NAME)/ariane.sv2v.v \
                       ./designs/$(PLATFORM)/$(DESIGN_NAME)/macros.v

export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export ADDITIONAL_LEFS = $(PLATFORM_DIR)/lef/tsmc65lp_1rf_lg8_w64_byte.lef
export ADDITIONAL_LIBS = $(PLATFORM_DIR)/lib/tsmc65lp_1rf_lg8_w64_byte_ss_1p08v_1p08v_125c.lib
export ADDITIONAL_GDS  = $(PLATFORM_DIR)/gds/tsmc65lp_1rf_lg8_w64_byte.gds2

export DIE_AREA    = 0 0 1950 1560
export CORE_AREA   = 10 12 1940 1550
export PLACE_PINS_ARGS = -exclude left:0-400 -exclude left:900-1560 -exclude right:* -exclude top:* -exclude bottom:*

export MACRO_PLACE_HALO = 10 10
export MACRO_PLACE_CHANNEL = 30 30

#export PLACE_DENSITY = .70
export PLACE_DENSITY_LB_ADDON = 0.10 
