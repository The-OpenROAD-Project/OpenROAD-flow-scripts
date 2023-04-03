export DESIGN_NICKNAME = ariane133
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

export VERILOG_FILES = $(PLATFORM_DIR)/ariane133/ariane.v

export SDC_FILE      = ./designs/$(PLATFORM)/ariane133/ariane.sdc

export WRAP_LEFS = $(PLATFORM_DIR)/lef/gf12_1rw_256x16.lef
export WRAP_LIBS = $(PLATFORM_DIR)/lib/gf12_1rw_256x16_ffpg_sigcmin_0p88v_0p88v_m40c.lib

export ADDITIONAL_GDS  = $(PLATFORM_DIR)/gds/gf12lp_1rf_lg8_w64_byte.gds2

export DIE_AREA    = 0 0 800 600 
export CORE_AREA   = 2 2 800 600 
export PLACE_PINS_ARGS = -exclude left:0-250 -exclude left:500-600 -exclude right:* -exclude top:* -exclude bottom:*

export MACRO_PLACE_HALO = 4 4
export MACRO_PLACE_CHANNEL = 8 8

export PLACE_DENSITY_LB_ADDON = 0.02

ifneq ($(USE_FILL),)
export DESIGN_TYPE = CELL
else
export DESIGN_TYPE = CELL_NODEN
endif
