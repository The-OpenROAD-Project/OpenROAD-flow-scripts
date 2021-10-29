export DESIGN_NICKNAME = coyote
export DESIGN_NAME = bsg_rocket_node_client_rocc
export PLATFORM    = tsmc65lp

#export FLOW_VARIANT = hier
export FLOW_VARIANT = hier_rtlmp
export SYNTH_HIERARCHICAL = 1
export MAX_UNGROUP_SIZE = 100
export RTLMP_FLOW = True

export VERILOG_FILES = ./designs/src/$(DESIGN_NICKNAME)/coyote.sv2v.v \
                       ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/macros.v
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint_hier.sdc
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

export FLOORPLAN_DEF = ./results/$(PLATFORM)/$(DESIGN_NICKNAME)/$(FLOW_VARIANT)/2_2_floorplan_io.def
#
# RTL_MP Settings
export RTLMP_MAX_INST = 20000
export RTLMP_MIN_INST = 4000
export RTLMP_MAX_MACRO = 10
export RTLMP_MIN_MACRO = 5 
export RTLMP_RPT_DIR = $(OBJECTS_DIR)/rtl_mp
export RTLMP_RPT_FILE = partition.txt
export RTLMP_CONFIG_FILE = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/rtlmp_config.txt
export RTLMP_BLOCKAGE_FILE = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/macro_blockage.txt

# These values must be multiples of placement site
#export DIE_AREA = 0 0 3080 3100
export DIE_AREA = 0 0 1810 1810
export CORE_AREA = 5 5 1805 1805
export PLACE_PINS_ARGS = -exclude left:* -exclude right:0-500 -exclude right:1500-2000 -exclude top:* -exclude bottom:*
export MACRO_BLOCKAGE_HALO = 10

export PLACE_DENSITY         ?= 0.65
export REMOVE_BUFFER_TREE     = 1
