export DESIGN_NICKNAME = gcd
export DESIGN_NAME = gcd
export PLATFORM    = rapidus2hp

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NAME)/gcd.v
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export CORE_UTILIZATION = 45
export CORE_MARGIN = .5
export PLACE_DENSITY = 0.42
