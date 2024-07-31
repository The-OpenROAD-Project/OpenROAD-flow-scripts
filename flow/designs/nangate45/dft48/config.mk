export DESIGN_NICKNAME ?= dft48
export DESIGN_NAME = dft_top
export PLATFORM    = nangate45


export VERILOG_FILES =$(sort $(wildcard ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/rtl/*.v))

export SDC_FILE      =./designs/$(PLATFORM)/dft48/constraint.sdc

export ABC_AREA      = 1

export ADDITIONAL_LEFS = $(sort $(wildcard ./designs/$(PLATFORM)/dft48/lef/*.lef))
export ADDITIONAL_LIBS = $(sort $(wildcard ./designs/$(PLATFORM)/dft48/lib/*.lib))

export CORE_UTILIZATION = 40
export PLACE_DENSITY = 0.6
export TNS_END_PERCENT =5

export SYNTH_HIERARCHICAL = 1


export DETAILED_ROUTE_ARGS = -droute_end_iter 16
export GLOBAL_ROUTE_ARGS = -allow_congestion -verbose




