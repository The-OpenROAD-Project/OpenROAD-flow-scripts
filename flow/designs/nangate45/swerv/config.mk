export DESIGN_NAME = swerv
export PLATFORM    = nangate45

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NAME)/swerv_wrapper.sv2v.v
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export CORE_UTILIZATION = 65
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN = 5

export PLACE_DENSITY_LB_ADDON = 0.20
export TNS_END_PERCENT        = 100

export SWAP_ARITH_OPERATORS = 1
export OPENROAD_HIERARCHICAL = 1
