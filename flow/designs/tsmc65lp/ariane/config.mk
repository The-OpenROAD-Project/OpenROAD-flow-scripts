export DESIGN_NAME = ariane
export PLATFORM    = tsmc65lp

export SYNTH_HIERARCHICAL = 1

export VERILOG_FILES = ./designs/src/$(DESIGN_NAME)/ariane.sv2v.v \
                       ./designs/$(PLATFORM)/$(DESIGN_NAME)/macros.v

export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export ADDITIONAL_LEFS = $(PLATFORM_DIR)/lef/tsmc65lp_1rf_lg8_w64_byte.lef
export ADDITIONAL_LIBS = $(PLATFORM_DIR)/lib/tsmc65lp_1rf_lg8_w64_byte_ss_1p08v_1p08v_125c.lib
export ADDITIONAL_GDS  = $(PLATFORM_DIR)/gds/tsmc65lp_1rf_lg8_w64_byte.gds2

# These values must be multiples of placement site
export DIE_AREA    = 0 0 2000 1560
export CORE_AREA   = 10 12 1990 1550.4
export PLACE_PINS_ARGS = -exclude left:0-500 -exclude left:800-1560 -exclude right:* -exclude top:* -exclude bottom:*

export PLACE_DENSITY_LB_ADDON = 0.10
export SKIP_PIN_SWAP          = 1


