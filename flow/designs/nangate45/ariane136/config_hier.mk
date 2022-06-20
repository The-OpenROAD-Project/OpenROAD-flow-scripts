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

# These values must be multiples of placement site
export DIE_AREA    = 0 0 2200 2200
export CORE_AREA   = 10 10 2190 2190
export PLACE_PINS_ARGS = -exclude left:0-700 -exclude left:1500-2200 -exclude right:* -exclude top:* -exclude bottom:*

export MACRO_PLACE_HALO = 7 7
