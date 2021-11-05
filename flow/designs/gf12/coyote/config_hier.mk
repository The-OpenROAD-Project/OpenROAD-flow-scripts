include $(dir $(DESIGN_CONFIG))/config.mk

#export FLOW_VARIANT = hier
export FLOW_VARIANT = hier_rtlmp
export SYNTH_HIERARCHICAL = 1
export MAX_UNGROUP_SIZE = 100
export RTLMP_FLOW = True

export SDC_FILE        = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint_hier.sdc

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

export DIE_AREA    = 0 0 900 900
export CORE_AREA   = 2 2 898 898 
export PLACE_PINS_ARGS = -exclude left:* -exclude right:* -exclude top:0-350 -exclude top:650-900 -exclude bottom:*
