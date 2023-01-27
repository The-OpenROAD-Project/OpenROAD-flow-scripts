export DESIGN_NAME = ariane
export PLATFORM    = gf12

export SYNTH_HIERARCHICAL = 1
export MAX_UNGROUP_SIZE ?= 1000
export RTLMP_FLOW = True
#
# RTL_MP Settings
export RTLMP_MAX_INST = 20000
export RTLMP_MIN_INST = 4000
export RTLMP_MAX_MACRO = 12
export RTLMP_MIN_MACRO = 4
export RTLMP_BOUNDARY_WT = 150.0

export VERILOG_FILES = ./designs/src/$(DESIGN_NAME)/ariane.sv2v.v \
                       ./designs/$(PLATFORM)/$(DESIGN_NAME)/macros.v

#export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint_hier.sdc

export WRAP_LEFS = $(PLATFORM_DIR)/lef/gf12lp_1rf_lg8_w64_byte.lef

export WRAP_LIBS = $(PLATFORM_DIR)/lib/gf12lp_1rf_lg8_w64_byte_sspg_sigcmax_0p72v_0p72v_125c.lib

export ADDITIONAL_GDS  = $(PLATFORM_DIR)/gds/gf12lp_1rf_lg8_w64_byte.gds2

export DIE_AREA    = 0 0 750 550
export CORE_AREA   = 2 2 748 548
export PLACE_PINS_ARGS = -exclude left:0-250 -exclude left:400-550 -exclude right:* -exclude top:* -exclude bottom:*

export MACRO_PLACE_HALO = 4 4
export MACRO_PLACE_CHANNEL = 8 8

#export PLACE_DENSITY = 0.55
export PLACE_DENSITY_LB_ADDON = 0.02

export MACRO_WRAPPERS = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/wrappers.tcl

ifneq ($(USE_FILL),)
export DESIGN_TYPE = CELL
else
export DESIGN_TYPE = CELL_NODEN
endif
