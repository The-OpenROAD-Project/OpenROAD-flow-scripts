include $(dir $(DESIGN_CONFIG))/config.mk

export FLOW_VARIANT = hier
export SYNTH_HIERARCHICAL = 1
export MAX_UNGROUP_SIZE = 10000
export RTLMP_FLOW = True

export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export FLOORPLAN_DEF = ./results/$(PLATFORM)/$(DESIGN_NICKNAME)/$(FLOW_VARIANT)/2_2_floorplan_io.def
export ABC_CLOCK_PERIOD_IN_PS = 4000
#
# RTL_MP Settings
export RTLMP_MAX_INST = 5000
export RTLMP_MIN_INST = 1000
export RTLMP_MAX_MACRO = 24
export RTLMP_MIN_MACRO = 4

export GPL_TIMING_DRIVEN = 0
export GPL_ROUTABILITY_DRIVEN = 0

export MACRO_PLACE_HALO = 10 10
