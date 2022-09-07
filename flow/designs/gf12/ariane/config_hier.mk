include $(dir $(DESIGN_CONFIG))/config.mk

export FLOW_VARIANT ?= hier_rtlmp
export SYNTH_HIERARCHICAL = 1
export MAX_UNGROUP_SIZE ?= 100
export RTLMP_FLOW = True

export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint_hier.sdc

#
# RTL_MP Settings
export RTLMP_MAX_INST = 5000
export RTLMP_MIN_INST = 1000
export RTLMP_MAX_MACRO = 12
export RTLMP_MIN_MACRO = 4

# These values must be multiples of placement site
export DIE_AREA    = 0 0 700 700
export CORE_AREA   = 10 10 690 690
export PLACE_PINS_ARGS = -exclude left:0-300 -exclude left:400-700 -exclude right:* -exclude top:* -exclude bottom:*

export MACRO_PLACE_HALO = 5 5
export MACRO_PLACE_CHANNEL = 10 10

export PLACE_DENSITY = 0.55
