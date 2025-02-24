export DESIGN_NAME = gcd
export PLATFORM    = intel16

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NAME)/gcd.v
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc
export ABC_AREA      = 1

# Adders degrade GCD
export ADDER_MAP_FILE :=

export CORE_UTILIZATION    = 30
export CORE_ASPECT_RATIO   = 1
export CORE_MARGIN         = 1

export PLACE_DENSITY = uniform
