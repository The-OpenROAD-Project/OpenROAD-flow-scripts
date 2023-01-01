export DESIGN_NAME = MockArray
export DESIGN_NICKNAME = mock-array

export VERILOG_FILES_BLACKBOX = designs/src/mock-array/Element.v
export VERILOG_FILES = designs/src/mock-array/*.v

export SDC_FILE      = designs/asap7/mock-array/constraints.sdc

export PLATFORM               = asap7

export PLACE_DENSITY          = 0.20

export CORE_UTILIZATION       = 25
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2

export CLOCK_PORT   = clock
export CLOCK_PERIOD = 250

BLOCKS = Element

export GDS_ALLOW_EMPTY = Element

export CORNER                ?= TC

export MACRO_PLACEMENT = ./designs/asap7/mock-array/macro-placement.cfg

export IO_CONSTRAINTS = designs/asap7/mock-array/io.tcl
