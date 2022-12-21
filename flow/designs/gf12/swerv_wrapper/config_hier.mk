include $(dir $(DESIGN_CONFIG))/config.mk

export FLOW_VARIANT ?= hier_rtlmp
export SYNTH_HIERARCHICAL = 1
export MAX_UNGROUP_SIZE ?= 100
export RTLMP_FLOW = True
#
# RTL_MP Settings
export RTLMP_MAX_INST = 5000
export RTLMP_MIN_INST = 1000
export RTLMP_MAX_MACRO = 12
export RTLMP_MIN_MACRO = 4


export DIE_AREA    = 0 0 610 500
export CORE_AREA   = 10 10 600 490
export PLACE_PINS_ARGS = -exclude left:* -exclude right:* -exclude top:* -exclude bottom:0-20 -exclude bottom:400-610
#
export MACRO_PLACE_HALO = 5 5
export MACRO_PLACE_CHANNEL = 10 10

export PLACE_DENSITY = 0.50
