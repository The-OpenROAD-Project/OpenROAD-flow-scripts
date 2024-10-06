export DESIGN_NICKNAME = bp
export DESIGN_NAME = black_parrot
export PLATFORM    = tsmc65lp

export SYNTH_HIERARCHICAL = 1
#
# RTL_MP Settings
export RTLMP_MAX_INST = 30000
export RTLMP_MIN_INST = 5000
export RTLMP_MAX_MACRO = 12
export RTLMP_MIN_MACRO = 4 

export VERILOG_FILES = ./designs/src/$(DESIGN_NAME)/pickled.v \
                       ./designs/$(PLATFORM)/$(DESIGN_NAME)/macros.v
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export ADDITIONAL_LEFS = $(PLATFORM_DIR)/lef/tsmc65lp_1rf_lg6_w16_bit.lef \
                         $(PLATFORM_DIR)/lef/tsmc65lp_1rf_lg6_w8_bit.lef \
                         $(PLATFORM_DIR)/lef/tsmc65lp_1rf_lg6_w96_bit.lef \
                         $(PLATFORM_DIR)/lef/tsmc65lp_1rf_lg9_w64_bit.lef \
                         $(PLATFORM_DIR)/lef/tsmc65lp_1rf_lg8_w96_all.lef \
                         $(PLATFORM_DIR)/lef/tsmc65lp_1rf_lg9_w64_all.lef
export ADDITIONAL_LIBS = $(PLATFORM_DIR)/lib/tsmc65lp_1rf_lg6_w16_bit_ss_1p08v_1p08v_125c.lib \
                         $(PLATFORM_DIR)/lib/tsmc65lp_1rf_lg6_w8_bit_ss_1p08v_1p08v_125c.lib \
                         $(PLATFORM_DIR)/lib/tsmc65lp_1rf_lg6_w96_bit_ss_1p08v_1p08v_125c.lib \
                         $(PLATFORM_DIR)/lib/tsmc65lp_1rf_lg9_w64_bit_ss_1p08v_1p08v_125c.lib \
                         $(PLATFORM_DIR)/lib/tsmc65lp_1rf_lg8_w96_all_ss_1p08v_1p08v_125c.lib \
                         $(PLATFORM_DIR)/lib/tsmc65lp_1rf_lg9_w64_all_ss_1p08v_1p08v_125c.lib
export ADDITIONAL_GDS  = $(PLATFORM_DIR)/gds/tsmc65lp_1rf_lg6_w16_bit.gds2 \
                         $(PLATFORM_DIR)/gds/tsmc65lp_1rf_lg6_w8_bit.gds2 \
                         $(PLATFORM_DIR)/gds/tsmc65lp_1rf_lg6_w96_bit.gds2 \
                         $(PLATFORM_DIR)/gds/tsmc65lp_1rf_lg9_w64_bit.gds2 \
                         $(PLATFORM_DIR)/gds/tsmc65lp_1rf_lg8_w96_all.gds2 \
                         $(PLATFORM_DIR)/gds/tsmc65lp_1rf_lg9_w64_all.gds2

export DIE_AREA    = 0 0 1800 1600.8
export CORE_AREA   = 10 12 1790 1591.2
export PLACE_PINS_ARGS = -exclude left:* -exclude right:* -exclude top:*

export MACRO_PLACE_HALO = 10 10
export MACRO_PLACE_CHANNEL = 20 20

export PLACE_DENSITY_LB_ADDON = 0.10 
