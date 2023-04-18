export DESIGN_NAME = Element
export DESIGN_NICKNAME = mock-array-big_Element

export VERILOG_FILES = designs/src/mock-array-big/*.v
export SDC_FILE      = designs/sky130hs/mock-array-big/constraints.sdc

export PLATFORM               = sky130hs

export PLACE_DENSITY          = 0.50
export GPL_TIMING_DRIVEN      = 0
export GPL_ROUTABILITY_DRIVEN = 0

export CORE_AREA = $(shell python3 designs/sky130hs/mock-array-big/ce_core_area.py)
export DIE_AREA = $(shell python3 designs/sky130hs/mock-array-big/ce_die_area.py)

export IO_CONSTRAINTS = designs/sky130hs/mock-array-big/Element/io.tcl

export MACRO_PLACE_HALO = 1 1
