include $(dir $(DESIGN_CONFIG))/config.mk

export FLOW_VARIANT ?= hier_rtlmp
export SYNTH_HIERARCHICAL = 1
export MAX_UNGROUP_SIZE ?= 1000
export RTLMP_FLOW = True

export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint_hier.sdc

#
# RTL_MP Settings
export RTLMP_MAX_INST = 500000
export RTLMP_MIN_INST = 1000
export RTLMP_MAX_MACRO = 140
export RTLMP_MIN_MACRO = 4
