export PLATFORM               = asap7

export DESIGN_NAME            = fifo
export DESIGN_NICKNAME        = fifo

export VERILOG_FILES = $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v)
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export CORE_UTILIZATION         = 40
export CORE_ASPECT_RATIO        = 1
export CORE_MARGIN              = 2
export PLACE_DENSITY            = 0.65
export TNS_END_PERCENT          = 100
