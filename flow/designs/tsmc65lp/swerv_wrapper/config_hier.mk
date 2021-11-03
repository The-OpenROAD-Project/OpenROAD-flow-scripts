include $(dir $(DESIGN_CONFIG))/config.mk

#export FLOW_VARIANT = hier
export FLOW_VARIANT = hier_rtlmp
export SYNTH_HIERARCHICAL = 1
export MAX_UNGROUP_SIZE = 100
export RTLMP_FLOW = True

export FLOORPLAN_DEF = ./results/$(PLATFORM)/$(DESIGN_NAME)/$(FLOW_VARIANT)/2_2_floorplan_io.def

# RTL_MP Settings
export RTLMP_MAX_INST = 5000
export RTLMP_MIN_INST = 1000
export RTLMP_MAX_MACRO = 12
export RTLMP_MIN_MACRO = 4
export RTLMP_RPT_DIR = $(OBJECTS_DIR)/rtlmp
export RTLMP_RPT_FILE = partition.txt
export RTLMP_CONFIG_FILE = ./designs/$(PLATFORM)/$(DESIGN_NAME)/rtlmp_config.txt
export RTLMP_BLOCKAGE_FILE = ./designs/$(PLATFORM)/$(DESIGN_NAME)/macro_blockage.txt

export DIE_AREA    = 0 0 1610 1410
export CORE_AREA   = 5 5 1605 1405
export PLACE_PINS_ARGS = -exclude left:* -exclude right:* -exclude top:* -exclude bottom:0-300 -exclude bottom:1300-1600
