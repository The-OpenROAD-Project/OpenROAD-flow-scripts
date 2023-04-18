export DESIGN_NAME = MockArray
export DESIGN_NICKNAME = mock-array-big

export VERILOG_FILES_BLACKBOX = designs/src/mock-array-big/Element.v
export VERILOG_FILES = designs/src/mock-array-big/*.v

export SDC_FILE      = designs/sky130hs/mock-array-big/constraints.sdc

export PLATFORM               = sky130hs

export PLACE_DENSITY          = 0.30

export CORE_AREA = $(shell python3 designs/sky130hs/mock-array-big/core_area.py)
export DIE_AREA = $(shell python3 designs/sky130hs/mock-array-big/die_area.py)

BLOCKS = Element

export GDS_ALLOW_EMPTY = Element

export MACRO_PLACEMENT_TCL = ./designs/sky130hs/mock-array-big/macro-placement.tcl

export IO_CONSTRAINTS = designs/sky130hs/mock-array-big/io.tcl

export MACRO_PLACE_HALO = 1 1

export PWR_NETS_VOLTAGES  = ""
export GND_NETS_VOLTAGES  = ""
