export DESIGN_NAME = gcd
export PLATFORM    = nangate45

export VERILOG_FILES = ./designs/src/$(DESIGN_NAME)/gcd.v
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc
export ABC_AREA      = 1

# Adders degrade GCD
export ADDER_MAP_FILE :=

# These values must be multiples of placement site
# x=0.19 y=1.4
export DIE_AREA    = 0 0 70.11 70 
export CORE_AREA   = 10.07 11.2 60.04 60.2 

export PLACE_DENSITY_LB_ADDON = 0.20
