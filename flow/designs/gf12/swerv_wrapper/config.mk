export DESIGN_NAME = swerv_wrapper
export PLATFORM    = gf12
#
export MAX_UNGROUP_SIZE ?= 10000
export SYNTH_HIERARCHICAL = 1

# RTL_MP Settings
export RTLMP_MAX_INST = 25000
export RTLMP_MIN_INST = 5000
export RTLMP_MAX_MACRO = 12
export RTLMP_MIN_MACRO = 4

export VERILOG_FILES = $(DESIGN_HOME)/src/swerv/swerv_wrapper.sv2v.v \
                       $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/macros.v
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export WRAP_LEFS      = $(PLATFORM_DIR)/lef/gf12_1rf_lg11_w40_all.lef \
                        $(PLATFORM_DIR)/lef/gf12_1rf_lg6_w22_all.lef \
                        $(PLATFORM_DIR)/lef/gf12_1rf_lg8_w34_all.lef

export WRAP_LIBS      = $(PLATFORM_DIR)/lib/gf12_1rf_lg11_w40_all_ffpg_sigcmin_0p88v_0p88v_m40c.lib \
                        $(PLATFORM_DIR)/lib/gf12_1rf_lg6_w22_all_ffpg_sigcmin_0p88v_0p88v_m40c.lib \
                        $(PLATFORM_DIR)/lib/gf12_1rf_lg8_w34_all_ffpg_sigcmin_0p88v_0p88v_m40c.lib

export ADDITIONAL_GDS = $(PLATFORM_DIR)/gds/gf12_1rf_lg11_w40_all.gds2 \
                        $(PLATFORM_DIR)/gds/gf12_1rf_lg6_w22_all.gds2 \
                        $(PLATFORM_DIR)/gds/gf12_1rf_lg8_w34_all.gds2

export DIE_AREA    = 0 0 610 500 
export CORE_AREA   = 2 2 608 498
#
export PLACE_PINS_ARGS = -exclude left:* -exclude right:* -exclude top:* -exclude bottom:0-10 -exclude bottom:400-700

export PLACE_DENSITY_LB_ADDON = 0.05
export MACRO_WRAPPERS = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/wrappers.tcl
#
export MACRO_PLACE_HALO = 7 7
export MACRO_PLACE_CHANNEL = 14 14

ifeq ($(USE_FILL),1)
export DESIGN_TYPE = CELL
else
export DESIGN_TYPE = CELL_NODEN
endif

export REMOVE_ABC_BUFFERS = 1
