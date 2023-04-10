export DESIGN_NAME = MockArray
export DESIGN_NICKNAME = mock-array-big

export VERILOG_FILES_BLACKBOX = designs/src/mock-array-big/Element.v
export VERILOG_FILES = designs/src/mock-array-big/*.v

export SDC_FILE      = designs/asap7/mock-array-big/constraints.sdc

export PLATFORM               = asap7

export PLACE_DENSITY          = 0.30

export CORE_AREA = $(shell python3 designs/asap7/mock-array-big/core_area.py)
export DIE_AREA = $(shell python3 designs/asap7/mock-array-big/die_area.py)

BLOCKS = Element

export GDS_ALLOW_EMPTY = Element

export MACRO_PLACEMENT_TCL = ./designs/asap7/mock-array-big/macro-placement.tcl

export IO_CONSTRAINTS = designs/asap7/mock-array-big/io.tcl

export MACRO_PLACE_HALO = 1 1

export PDN_TCL = designs/asap7/mock-array-big/pdn.tcl
