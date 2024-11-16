export DESIGN_NICKNAME = ariane133
export DESIGN_NAME = ariane
export PLATFORM    = gf12

export SYNTH_HIERARCHICAL = 1
export MAX_UNGROUP_SIZE ?= 10000
#
# RTL_MP Settings

export VERILOG_FILES = $(PLATFORM_DIR)/ariane133/ariane.v

export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/ariane133/ariane.sdc

export WRAP_LEFS = $(PLATFORM_DIR)/lef/gf12_1rw_256x16.lef
export WRAP_LIBS = $(PLATFORM_DIR)/lib/gf12_1rw_256x16_ffpg_sigcmin_0p88v_0p88v_m40c.lib

export ADDITIONAL_GDS  = $(PLATFORM_DIR)/gds/gf12lp_1rf_lg8_w64_byte.gds2

export DIE_AREA    = 0 0 900 750
export CORE_AREA   = 5 5 895 745

export PLACE_PINS_ARGS = -exclude left:0-200 -exclude left:500-700 -exclude right:* -exclude top:* -exclude bottom:*

export MACRO_PLACE_HALO = 7 7
export MACRO_PLACE_CHANNEL = 14 14

export PLACE_DENSITY_LB_ADDON = 0.05

ifeq ($(USE_FILL),1)
export DESIGN_TYPE = CELL
else
export DESIGN_TYPE = CELL_NODEN
endif
