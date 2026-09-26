export DESIGN_NICKNAME = gcd_$(TRACK_OPTION)_$(TECH_OPTION)
export DESIGN_NAME = gcd
export PLATFORM    = gf12

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NAME)/gcd.v
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export CORE_UTILIZATION  = 20
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN       = 2

export PLACE_DENSITY_LB_ADDON = 0.20

export GLOBAL_PLACEMENT_ARGS = -skip_initial_place

ifeq ($(USE_FILL),1)
export DESIGN_TYPE = CELL
else
export DESIGN_TYPE = CELL_NODEN
endif

export SKIP_GATE_CLONING = 1

export SWAP_ARITH_OPERATORS = 1
export OPENROAD_HIERARCHICAL = 1
