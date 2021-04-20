export DESIGN_NICKNAME = jpeg
export DESIGN_NAME = jpeg_encoder
export PLATFORM    = sky130hd
export FLOW_VARIANT = ppa

export VERILOG_FILES = $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v))
export VERILOG_INCLUDE_DIRS = ./designs/src/$(DESIGN_NICKNAME)/include
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
export RCX_RULES     = $(PLATFORM_DIR)/rcx_patterns.rules

# These values must be multiples of placement site
export DIE_AREA    = 0 0 3000.04 2999.8
export CORE_AREA   = 10.07 9.8 2989.97 2990
#
# Placement
#
export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 3 
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 2

# IR drop estimation supply net name to be analyzed and supply voltage variable
# For multiple nets: PWR_NETS_VOLTAGES  = "VDD1 1.8 VDD2 1.2"
export PWR_NETS_VOLTAGES  = "VDD 1.8"
export GND_NETS_VOLTAGES  = "VSS 0.0"
