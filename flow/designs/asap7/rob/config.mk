export PLATFORM               = asap7

export DESIGN_NAME            = Rob
export DESIGN_NICKNAME        = rob

export VERILOG_FILES          = $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.sv))
export SDC_FILE               = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export CORE_UTILIZATION       = 30
export PLACE_DENSITY          = 0.35
