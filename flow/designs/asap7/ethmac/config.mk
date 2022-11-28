export PLATFORM               = asap7

export DESIGN_TOP_NAME            = ethmac

export VERILOG_FILES         = $(sort $(wildcard ./designs/src/$(DESIGN_NAME)/*.v))
export SDC_FILE              = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc
export ABC_AREA               = 1

export CORE_UTILIZATION       = 40
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY          = 0.60

export DFF_LIB_FILE           = $($(CORNER)_DFF_LIB_FILE)
