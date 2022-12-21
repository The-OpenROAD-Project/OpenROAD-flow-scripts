export PLATFORM               = asap7

export DESIGN_NAME            = sha3_core
export DESIGN_NICKNAME        = sha3-blocks_sha3_core

export VERILOG_FILES = $(sort $(wildcard ./designs/src/sha3/*.v))
export SDC_FILE      = ./designs/$(PLATFORM)/sha3-blocks/sha3_core/constraint.sdc

export DFF_LIB_FILE           = $($(CORNER)_DFF_LIB_FILE)

export ABC_CLOCK_PERIOD_IN_PS = 650

export CORE_UTILIZATION       = 30
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY          = 0.60
