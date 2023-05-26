export DESIGN_NAME = gcd
export PLATFORM    = sky130hs

export VERILOG_FILES = ./designs/src/$(DESIGN_NICKNAME)/gcd.v
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
export ABC_AREA      = 1

# Adders degrade GCD
export ADDER_MAP_FILE :=

export CORE_UTILIZATION = 40
export PLACE_DENSITY_LB_ADDON = 0.1
export TNS_END_PERCENT = 100
