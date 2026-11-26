export PLATFORM               = asap7

export DESIGN_NAME            = ethmac

export VERILOG_FILES         = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE              = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
export ABC_AREA               = 1

export CORE_UTILIZATION       = 70
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY          = 0.75
export GPL_PLACE_IOS          = 1

export HOLD_SLACK_MARGIN      = -10

# Temporary disabling: the design has several clock domains and the
# sequential check does not yet cover logic crossing between them.
export SEC_CHECK = 0
