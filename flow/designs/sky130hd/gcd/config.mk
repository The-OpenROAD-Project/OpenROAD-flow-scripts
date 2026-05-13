export DESIGN_NAME = gcd
export PLATFORM    = sky130hd

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/gcd.v
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

# Adders degrade GCD
export ADDER_MAP_FILE :=

export CORE_UTILIZATION = 40
export TNS_END_PERCENT = 100
export SWAP_ARITH_OPERATORS = 1
export OPENROAD_HIERARCHICAL = 1
