export DESIGN_NAME = swerv_wrapper
export PLATFORM    = tsmc65lp

export SYNTH_HIERARCHICAL = 1

# RTL_MP Settings
export RTLMP_MAX_INST = 30000
export RTLMP_MIN_INST = 5000
export RTLMP_MAX_MACRO = 12
export RTLMP_MIN_MACRO = 4

export VERILOG_FILES = $(DESIGN_HOME)/src/swerv/swerv_wrapper.sv2v.v \
                       $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/macros.v
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export ADDITIONAL_LEFS = $(PLATFORM_DIR)/lef/tsmc65lp_1rf_lg11_w40_all.lef \
                         $(PLATFORM_DIR)/lef/tsmc65lp_1rf_lg6_w22_all.lef \
                         $(PLATFORM_DIR)/lef/tsmc65lp_1rf_lg8_w34_all.lef
export ADDITIONAL_LIBS = $(PLATFORM_DIR)/lib/tsmc65lp_1rf_lg11_w40_all_ss_1p08v_1p08v_125c.lib \
                         $(PLATFORM_DIR)/lib/tsmc65lp_1rf_lg6_w22_all_ss_1p08v_1p08v_125c.lib \
                         $(PLATFORM_DIR)/lib/tsmc65lp_1rf_lg8_w34_all_ss_1p08v_1p08v_125c.lib
export ADDITIONAL_GDS  = $(PLATFORM_DIR)/gds/tsmc65lp_1rf_lg11_w40_all.gds2 \
                         $(PLATFORM_DIR)/gds/tsmc65lp_1rf_lg6_w22_all.gds2 \
                         $(PLATFORM_DIR)/gds/tsmc65lp_1rf_lg8_w34_all.gds2

export REMOVE_BUFFER_TREE     = 1

export DIE_AREA    = 0 0 1610 1360
export CORE_AREA   = 5 5 1605 1355
export PLACE_PINS_ARGS = -exclude left:* -exclude right:* -exclude top:* -exclude bottom:0-300 -exclude bottom:1300-1600

export MACRO_PLACE_HALO = 10 10 
export MACRO_PLACE_CHANNEL = 20 20

export PLACE_DENSITY_LB_ADDON = 0.10 
