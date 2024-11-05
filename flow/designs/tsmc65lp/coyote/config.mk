export DESIGN_NICKNAME = coyote
export DESIGN_NAME = bsg_rocket_node_client_rocc
export PLATFORM    = tsmc65lp

export SYNTH_HIERARCHICAL = 1


# RTL_MP Settings
export RTLMP_MAX_INST = 30000
export RTLMP_MIN_INST = 5000
export RTLMP_MAX_MACRO = 10
export RTLMP_MIN_MACRO = 5 

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/coyote.sv2v.v \
                       $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/macros.v
#export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint_hier.sdc
export ABC_AREA      = 1

export ADDITIONAL_LEFS = $(PLATFORM_DIR)/lef/tsmc65lp_1rf_lg6_w80_bit.lef \
                         $(PLATFORM_DIR)/lef/tsmc65lp_1rf_lg8_w128_all.lef \
                         $(PLATFORM_DIR)/lef/tsmc65lp_2rf_lg6_w44_bit.lef \
                         $(PLATFORM_DIR)/lef/tsmc65lp_2rf_lg8_w64_bit.lef
export ADDITIONAL_LIBS = $(PLATFORM_DIR)/lib/tsmc65lp_1rf_lg6_w80_bit_ss_1p08v_1p08v_125c.lib \
                         $(PLATFORM_DIR)/lib/tsmc65lp_1rf_lg8_w128_all_ss_1p08v_1p08v_125c.lib \
                         $(PLATFORM_DIR)/lib/tsmc65lp_2rf_lg6_w44_bit_ss_1p08v_1p08v_125c.lib \
                         $(PLATFORM_DIR)/lib/tsmc65lp_2rf_lg8_w64_bit_ss_1p08v_1p08v_125c.lib
export ADDITIONAL_GDS  = $(PLATFORM_DIR)/gds/tsmc65lp_1rf_lg6_w80_bit.gds2 \
                         $(PLATFORM_DIR)/gds/tsmc65lp_1rf_lg8_w128_all.gds2 \
                         $(PLATFORM_DIR)/gds/tsmc65lp_2rf_lg6_w44_bit.gds2 \
                         $(PLATFORM_DIR)/gds/tsmc65lp_2rf_lg8_w64_bit.gds2

export DIE_AREA = 0 0 2250 2250
export CORE_AREA = 5 5 2245 2245
export PLACE_PINS_ARGS = -exclude left:* -exclude right:0-700 -exclude right:1500-2250 -exclude top:* -exclude bottom:*

export MACRO_PLACE_HALO = 10 10
export MACRO_PLACE_CHANNEL = 20 20

export PLACE_DENSITY_LB_ADDON = 0.10 
export REMOVE_BUFFER_TREE     = 1
