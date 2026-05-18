export DESIGN_NAME = gcd
export PLATFORM    = sky130hs

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/gcd.v
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
export ABC_AREA      = 1

# Adders degrade GCD
export ADDER_MAP_FILE :=

export CORE_UTILIZATION = 50
export PLACE_DENSITY_LB_ADDON = 0.1
export TNS_END_PERCENT        = 100
#export SYNTH_HDL_FRONTEND ?= slang
#export OPENROAD_HIERARCHICAL ?= 1
