export DESIGN_NAME = dsp_mac
export PLATFORM    = nangate45

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NAME)/dsp_mac.v
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export CORE_UTILIZATION ?= 45
export PLACE_DENSITY_LB_ADDON = 0.20
export TNS_END_PERCENT        = 100
export SYNTH_REPEATABLE_BUILD ?= 1
