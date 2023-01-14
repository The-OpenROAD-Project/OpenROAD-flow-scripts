export DESIGN_NAME = swerv_wrapper
export PLATFORM    = gf12

export VERILOG_FILES = ./designs/src/swerv/swerv_wrapper.sv2v.v \
                       ./designs/$(PLATFORM)/$(DESIGN_NAME)/macros.v
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export WRAP_LEFS      = $(PLATFORM_DIR)/lef/gf12_1rf_lg11_w40_all.lef \
                        $(PLATFORM_DIR)/lef/gf12_1rf_lg6_w22_all.lef \
                        $(PLATFORM_DIR)/lef/gf12_1rf_lg8_w34_all.lef

export WRAP_LIBS      = $(PLATFORM_DIR)/lib/gf12_1rf_lg11_w40_all_ffpg_sigcmin_0p88v_0p88v_m40c.lib \
                        $(PLATFORM_DIR)/lib/gf12_1rf_lg6_w22_all_ffpg_sigcmin_0p88v_0p88v_m40c.lib \
                        $(PLATFORM_DIR)/lib/gf12_1rf_lg8_w34_all_ffpg_sigcmin_0p88v_0p88v_m40c.lib

export ADDITIONAL_GDS = $(PLATFORM_DIR)/gds/gf12_1rf_lg11_w40_all.gds2 \
                        $(PLATFORM_DIR)/gds/gf12_1rf_lg6_w22_all.gds2 \
                        $(PLATFORM_DIR)/gds/gf12_1rf_lg8_w34_all.gds2

export DIE_AREA    = 0 0 702 542 
export CORE_AREA   = 2 2 700 540 
export HAS_IO_CONSTRAINTS = 1
export PLACE_PINS_ARGS = -exclude left:* -exclude right:* -exclude top:* -exclude bottom:0-10 -exclude bottom:400-700

export PLACE_DENSITY = 0.40
export MACRO_WRAPPERS = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/wrappers.tcl

ifneq ($(USE_FILL),)
export DESIGN_TYPE = CELL
else
export DESIGN_TYPE = CELL_NODEN
endif
