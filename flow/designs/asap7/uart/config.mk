export PLATFORM               = asap7
export CORNER                 = TC

export DESIGN_NAME            = uart

export VERILOG_FILES          = $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE               = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export PLACE_DENSITY          = 0.70
export DIE_AREA               = 0 0 15 15
export CORE_AREA              = 1.08 1.08 14 14
