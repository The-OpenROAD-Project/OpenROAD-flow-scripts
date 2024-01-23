export PLATFORM               = asap7

export DESIGN_NAME            = fifo_oneclock
export DESIGN_NICKNAME        = fifo_oneclock

export VERILOG_FILES = $(wildcard ./designs/src/fifo/*.v)
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export CORE_UTILIZATION         = 40
export CORE_ASPECT_RATIO        = 1
export CORE_MARGIN              = 2
export PLACE_DENSITY            = 0.65
export TNS_END_PERCENT          = 100
