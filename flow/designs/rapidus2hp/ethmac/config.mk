export PLATFORM               = rapidus2hp

export DESIGN_NAME            = ethmac

export VERILOG_FILES         = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE              = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
export ABC_AREA               = 1

export CORE_UTILIZATION       = 70
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 0.75
export PLACE_DENSITY          = 0.70
