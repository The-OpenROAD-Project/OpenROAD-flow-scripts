include $(dir $(DESIGN_CONFIG))/config.mk

#export FLOW_VARIANT = hier
export FLOW_VARIANT = hier_rtlmp
export SYNTH_HIERARCHICAL = 1
export MAX_UNGROUP_SIZE = 100
export RTLMP_FLOW = True

export FLOORPLAN_DEF = ./results/$(PLATFORM)/$(DESIGN_NAME)/$(FLOW_VARIANT)/2_2_floorplan_io.def
#
# RTL_MP Settings
export RTLMP_MAX_INST = 5000
export RTLMP_MIN_INST = 1000
export RTLMP_MAX_MACRO = 12
export RTLMP_MIN_MACRO = 4
export RTLMP_AREA_WT = 0.01
export RTLMP_WIRELENGTH_WT = 54.7
export RTLMP_OUTLINE_WT = 74.71
export RTLMP_BOUNDARY_WT = 100.0
export RTLMP_MACRO_BLOCKAGE_WT = 50.0
export RTLMP_LOCATION_WT = 100.0
export RTLMP_NOTCH_WT = 100.0

export DIE_AREA    = 0 0 650 500
export CORE_AREA   = 10 10 640 490
export PLACE_PINS_ARGS = -exclude left:* -exclude right:* -exclude top:* -exclude bottom:0-20 -exclude bottom:400-650

export PLACE_DENSITY = 0.55
