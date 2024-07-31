export DESIGN_NICKNAME ?= or1200
export DESIGN_NAME = or1200_top
export PLATFORM    = nangate45


export SYNTH_HIERARCHICAL = 1
export VERILOG_FILES =./designs/nangate45/or1200/output_file.v
export SDC_FILE      =./designs/$(PLATFORM)/or1200/constraint.sdc

export ADDITIONAL_LEFS = $(sort $(wildcard ./designs/$(PLATFORM)/or1200/lef/*.lef))
export ADDITIONAL_LIBS = $(sort $(wildcard ./designs/$(PLATFORM)/or1200/lib/*.lib))

export CORE_UTILIZATION = 40
export PLACE_DENSITY    = 0.6

export TNS_END_PERCENT  = 100



