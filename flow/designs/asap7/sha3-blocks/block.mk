export PLATFORM               = asap7

export VERILOG_FILES = $(sort $(wildcard ./designs/src/sha3/*.v))
export SDC_FILE      = ./designs/$(PLATFORM)/sha3-blocks/constraint.sdc

export CORE_UTILIZATION       = 30
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY          = 0.50

export PLACE_PINS_ARGS = -annealing
