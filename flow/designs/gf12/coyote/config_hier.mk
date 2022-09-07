include $(dir $(DESIGN_CONFIG))/config.mk

export FLOW_VARIANT ?= hier_rtlmp
export SYNTH_HIERARCHICAL = 1
export MAX_UNGROUP_SIZE ?= 1000
export RTLMP_FLOW = True

export SDC_FILE        = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint_hier.sdc
#
# RTL_MP Settings
export RTLMP_MAX_INST = 20000
export RTLMP_MIN_INST = 4000
export RTLMP_MAX_MACRO = 10
export RTLMP_MIN_MACRO = 5 

export DIE_AREA    = 0 0 950 950
export CORE_AREA   = 2 2 948 848 
export PLACE_PINS_ARGS = -exclude left:* -exclude right:* -exclude top:0-350 -exclude top:650-950 -exclude bottom:*

export PLACE_DENSITY = 0.38
