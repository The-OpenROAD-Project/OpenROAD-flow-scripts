export DESIGN_NAME = gcd
export PLATFORM    = ihp-sg13g2

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/gcd.v
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export USE_FILL = 1

export PLACE_DENSITY ?= 0.88
export CORE_UTILIZATION = 33
export TNS_END_PERCENT = 100
export CORE_ASPECT_RATIO = 0.52
export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 1
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 0
export PLACE_DENSITY_LB_ADDON = 0.094

#Temporary: enable post-DRT repair antennas locally - remove once set in platforms config.mk
export SKIP_ANTENNA_REPAIR_POST_DRT = 0
