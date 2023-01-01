export DESIGN_NAME = Element
export DESIGN_NICKNAME = mock-array_Element

export VERILOG_FILES = designs/src/mock-array/*.v
export SDC_FILE      = designs/asap7/mock-array/constraints.sdc

export PLATFORM               = asap7

export PLACE_DENSITY          = 0.40
export CORE_UTILIZATION       = 20
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2

export CLOCK_PORT   = clock
export CLOCK_PERIOD = 250

export CORNER                ?= TC
