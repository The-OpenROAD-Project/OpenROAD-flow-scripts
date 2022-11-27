export DESIGN_TOP_NAME = swerv
export PLATFORM    = tsmc65lp

export VERILOG_FILES = ./designs/src/$(DESIGN_TOP_NAME)/swerv_wrapper.sv2v.v
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_TOP_NAME)/constraint.sdc

# These values must be multiples of placement site
export DIE_AREA    = 0 0 1550 1341.6
export CORE_AREA   = 10 12 1540 1332
