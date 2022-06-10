export DESIGN_NAME = ariane
export PLATFORM    = gf12

export VERILOG_FILES = ./designs/src/$(DESIGN_NAME)/ariane.sv2v.v \
                       ./designs/$(PLATFORM)/$(DESIGN_NAME)/macros.v

export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export WRAP_LEFS = $(PLATFORM_DIR)/lef/gf12lp_1rf_lg8_w64_byte.lef

export WRAP_LIBS = $(PLATFORM_DIR)/lib/gf12lp_1rf_lg8_w64_byte_sspg_sigcmax_0p72v_0p72v_125c.lib

export ADDITIONAL_GDS  = $(PLATFORM_DIR)/gds/gf12lp_1rf_lg8_w64_byte.gds2

# These values must be multiples of placement site
export DIE_AREA    = 0 0 700 700 
export CORE_AREA   = 10 10 690 690 
export PLACE_PINS_ARGS = -exclude left:0-300 -exclude left:400-700 -exclude right:* -exclude top:* -exclude bottom:*

export MACRO_WRAPPERS = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/wrappers.tcl

ifneq ($(USE_FILL),)
export DESIGN_TYPE = CELL
else
export DESIGN_TYPE = CELL_NODEN
endif
