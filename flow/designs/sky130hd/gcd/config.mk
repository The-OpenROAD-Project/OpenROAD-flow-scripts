export DESIGN_NAME = gcd
export PLATFORM    = sky130hd

export VERILOG_FILES = ./designs/src/$(DESIGN_NICKNAME)/gcd.v
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

# Adders degrade GCD
export ADDER_MAP_FILE :=

export CORE_UTILIZATION = 40
export PLACE_DENISTY_LB_ADDON = 0.1
export TNS_END_PERCENT = 100
