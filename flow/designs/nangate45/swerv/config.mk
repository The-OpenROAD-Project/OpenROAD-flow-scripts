export DESIGN_NAME = swerv
export PLATFORM    = nangate45

export VERILOG_FILES = ./designs/src/$(DESIGN_NAME)/swerv_wrapper.sv2v.v
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export CORE_UTILIZATION = 40
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN = 5

export PLACE_DENSITY_LB_ADDON = 0.20
