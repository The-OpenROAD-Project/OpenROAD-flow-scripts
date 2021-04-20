export DESIGN_NICKNAME = aes
export DESIGN_NAME = aes_cipher_top
export PLATFORM    = sky130hd
export FLOW_VARIANT = ppa

export VERILOG_FILES = $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
export RCX_RULES     = $(PLATFORM_DIR)/rcx_patterns.rules

# These values must be multiples of placement site
export DIE_AREA    = 0 0 1120 1020.8
export CORE_AREA   = 10 12 1110 1011.2
export ABC_CLOCK_PERIOD_IN_PS = 10

#
# Placement
#
export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 3
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 2

# IR drop estimation supply net name to be analyzed and supply voltage variable
# For multiple nets: PWR_NETS_VOLTAGES  = "VDD1 1.8 VDD2 1.2"
export PWR_NETS_VOLTAGES  = "VDD 1.8"
export GND_NETS_VOLTAGES  = "VSS 0.0"
