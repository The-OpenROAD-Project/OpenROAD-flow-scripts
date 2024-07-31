export DESIGN_NICKNAME ?= bp_be
export DESIGN_NAME = bp_be_top
export PLATFORM    = nangate45

export SYNTH_HIERARCHICAL = 1
export RTLMP_FLOW = True
#
# RTL_MP Settings
export RTLMP_MAX_INST = 30000
export RTLMP_MIN_INST = 5000
export RTLMP_MAX_MACRO = 12
export RTLMP_MIN_MACRO = 4 

export VERILOG_FILES =$(sort $(wildcard ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/rtl/*.v))


export SDC_FILE      =./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export ADDITIONAL_LEFS = $(sort $(wildcard ./designs/$(PLATFORM)/bp_be/lef/*.lef))
export ADDITIONAL_LIBS = $(sort $(wildcard ./designs/$(PLATFORM)/bp_be/lib/*.lib))
export DIE_AREA    = 0 0 800 700 
export CORE_AREA   = 10.07 11.2 790 690 

export PLACE_PINS_ARGS = -exclude left:500-800 -exclude right:500-800 -exclude top:*

export MACRO_PLACE_HALO = 10 10
export MACRO_PLACE_CHANNEL = 20 20

export PLACE_DENSITY_LB_ADDON = 0.10
export TNS_END_PERCENT        = 100

export DETAILED_ROUTE_ARGS = -droute_end_iter 1
export GLOBAL_ROUTE_ARGS = -allow_congestion -verbose