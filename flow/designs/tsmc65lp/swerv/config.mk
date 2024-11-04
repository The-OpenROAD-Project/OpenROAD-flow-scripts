export DESIGN_NAME = swerv
export PLATFORM    = tsmc65lp

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NAME)/swerv_wrapper.sv2v.v
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

# These values must be multiples of placement site
export DIE_AREA    = 0 0 1550 1341.6
export CORE_AREA   = 10 12 1540 1332
