export PLATFORM               = asap7

export DESIGN_TOP_NAME            = sha3

export VERILOG_FILES = $(sort $(wildcard ./designs/src/$(DESIGN_NAME)/*.v))
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export PLACE_DENSITY          = 0.60

export DIE_AREA               = 0 0 90 90
export CORE_AREA              = 5.08 5.08 80 80

export DFF_LIB_FILE           = $($(CORNER)_DFF_LIB_FILE)
