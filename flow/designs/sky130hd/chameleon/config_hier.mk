include $(dir $(DESIGN_CONFIG))/config.mk

export FLOW_VARIANT = hier_rtlmp
export SYNTH_HIERARCHICAL = 1
export MAX_UNGROUP_SIZE = 100
export RTLMP_FLOW = True

export FLOORPLAN_DEF = ./results/$(PLATFORM)/$(DESIGN_NICKNAME)/$(FLOW_VARIANT)/2_2_floorplan_io.def
#
# RTL_MP Settings
export RTLMP_MAX_INST = 1000
export RTLMP_MIN_INST = 100
export RTLMP_MAX_MACRO = 12
export RTLMP_MIN_MACRO = 1 

export PLACE_PINS_ARGS = -exclude left:0-1000 -exclude left:2000-3520 -exclude right:* -exclude top:* -exclude bottom:*

export MACRO_PLACE_HALO = 5 5
export MACRO_PLACE_CHANNEL = 10 10

#export PLACE_DENSITY = 0.55
