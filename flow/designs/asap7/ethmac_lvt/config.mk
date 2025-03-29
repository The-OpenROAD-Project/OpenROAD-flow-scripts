export PLATFORM               = asap7

export DESIGN_NAME            = ethmac
export DESIGN_NICKNAME        = ethmac_lvt

export VERILOG_FILES         = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE              = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
export ABC_AREA               = 1

export CORE_UTILIZATION       = 40
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY          = 0.60

export ASAP7_USE_VT           = LVT

export RECOVER_POWER          = 1
