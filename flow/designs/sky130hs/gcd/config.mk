export DESIGN_NAME = gcd
export PLATFORM    = sky130hs

export VERILOG_FILES = ./designs/src/$(DESIGN_NICKNAME)/gcd.v
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
export ABC_AREA      = 1

# Adders degrade GCD
export ADDER_MAP_FILE :=

# These values must be multiples of placement site
export DIE_AREA    = 0 0 279.96 280.128
export CORE_AREA   = 9.996 10.08 269.964 270.048
