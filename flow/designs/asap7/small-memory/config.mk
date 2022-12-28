export DESIGN_NAME = SmallMemory
export DESIGN_NICKNAME = small-memory

export VERILOG_FILES = ./designs/src/$(DESIGN_NICKNAME)/*.v
export SDC_FILE               = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export CORNER                ?= TC

export ABC_CLOCK_PERIOD_IN_PS = 400

export PLATFORM               = asap7

export PLACE_DENSITY          = 0.30
export CORE_UTILIZATION       = 20
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2

# Start with 250MHz for nangate45, relatively conservative
export CLOCK_PERIOD = 4000
export CLOCK_PORT   = clock
