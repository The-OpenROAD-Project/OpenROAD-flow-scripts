export PLATFORM               = asap7

export DESIGN_NAME            = gcd

export VERILOG_FILES          = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NAME)/*.v))
export SDC_FILE               = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export DIE_AREA               = 0 0 16.2 16.2
export CORE_AREA              = 1.08 1.08 15.12 15.12
export PLACE_DENSITY          = 0.35

# a smoketest for this option, there are a
# few last gasp iterations
export SKIP_LAST_GASP ?= 1
