export DESIGN_NAME = spi
export PLATFORM    = ihp-sg13g2

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/spi.v
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export USE_FILL = 1

export PLACE_DENSITY ?= 0.88
export CORE_UTILIZATION = 27
export CORE_ASPECT_RATIO = 1.4
export TNS_END_PERCENT = 100

# AutoTuner result settings
export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 2
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 0
export PLACE_DENSITY_LB_ADDON = 0.02
