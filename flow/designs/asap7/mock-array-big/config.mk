export DESIGN_NAME = MockArray
export DESIGN_NICKNAME = mock-array-big

export VERILOG_FILES_BLACKBOX = designs/src/mock-array-big/Element.v
export VERILOG_FILES = designs/src/mock-array-big/*.v

export SDC_FILE      = designs/asap7/mock-array-big/constraints.sdc

export PLATFORM               = asap7

export PLACE_DENSITY          = 0.30

export CORE_UTILIZATION       = 20
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2

BLOCKS = Element

export GDS_ALLOW_EMPTY = Element

export MACRO_PLACEMENT = ./designs/asap7/mock-array-big/macro-placement.cfg

export IO_CONSTRAINTS = designs/asap7/mock-array-big/io.tcl

export MACRO_PLACE_HALO = 2 2
