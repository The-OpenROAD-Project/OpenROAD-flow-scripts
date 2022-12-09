include $(dir $(DESIGN_CONFIG))/config.mk

export FLOW_VARIANT ?= hier_rtlmp
export SYNTH_HIERARCHICAL = 1
export MAX_UNGROUP_SIZE = 10000
export RTLMP_FLOW = True
#
# RTL_MP Settings
export RTLMP_MAX_INST = 10000
export RTLMP_MIN_INST = 1000
export RTLMP_MAX_MACRO = 12
export RTLMP_MIN_MACRO = 4 

export MACRO_PLACE_HALO = 10 10
export MACRO_PLACE_CHANNEL = 20 20
