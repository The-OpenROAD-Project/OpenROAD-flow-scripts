include $(dir $(DESIGN_CONFIG))/config.mk

export FLOW_VARIANT ?= hier_rtlmp
export SYNTH_HIERARCHICAL = 1
export MAX_UNGROUP_SIZE = 100000
export RTLMP_FLOW = True
#
# RTL_MP Settings
export RTLMP_MAX_INST = 30000
export RTLMP_MIN_INST = 5000
export RTLMP_MAX_MACRO = 12
export RTLMP_MIN_MACRO = 4 

export DIE_AREA    = 0 0 1000 800 
export CORE_AREA   = 10.07 11.2 990 790 

export MACRO_PLACE_HALO = 5 5
export MACRO_PLACE_CHANNEL = 10 10
