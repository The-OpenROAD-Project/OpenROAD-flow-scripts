export DESIGN_NAME = gcd
export PLATFORM    = sky130hs

export VERILOG_FILES = ./designs/src/$(DESIGN_NICKNAME)/gcd.v
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
export RCX_RULES     = $(PLATFORM_DIR)/rcx_patterns.rules

# These values must be multiples of placement site
export DIE_AREA    = 0 0 279.96 280.128
export CORE_AREA   = 9.996 10.08 269.964 270.048

# IR drop estimation supply net name to be analyzed and supply voltage variable
export VDD_NET_NAME  = VDD
export VSS_NET_NAME  = VSS
export VDD_VOLTAGE   = 1.8
export VSS_VOLTAGE   = 0.0
