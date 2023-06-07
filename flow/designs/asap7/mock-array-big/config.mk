include designs/asap7/mock-array-big/defaults.mk

export DESIGN_NAME = MockArray
export DESIGN_NICKNAME = mock-array-big

export VERILOG_FILES_BLACKBOX = designs/src/mock-array-big/Element.v
export VERILOG_FILES = designs/src/mock-array-big/*.v

export SDC_FILE      = designs/asap7/mock-array-big/constraints.sdc

export PLATFORM               = asap7

export PLACE_DENSITY          = 0.30

export CORE_AREA = $(shell export MOCK_ARRAY_HEIGHT=$(MOCK_ARRAY_HEIGHT) && export MOCK_ARRAY_WIDTH=$(MOCK_ARRAY_WIDTH) && export MOCK_ARRAY_PITCH_SCALE=$(MOCK_ARRAY_PITCH_SCALE) && python3 designs/asap7/mock-array-big/core_area.py)
export DIE_AREA = $(shell export MOCK_ARRAY_HEIGHT=$(MOCK_ARRAY_HEIGHT) && export MOCK_ARRAY_WIDTH=$(MOCK_ARRAY_WIDTH) && export MOCK_ARRAY_PITCH_SCALE=$(MOCK_ARRAY_PITCH_SCALE) && python3 designs/asap7/mock-array-big/die_area.py)

BLOCKS = Element

export GDS_ALLOW_EMPTY = Element

export MACRO_PLACEMENT_TCL = ./designs/asap7/mock-array-big/macro-placement.tcl

export IO_CONSTRAINTS = designs/asap7/mock-array-big/io.tcl

export PDN_TCL = designs/asap7/mock-array-big/pdn.tcl
export TNS_END_PERCENT       = 100

# Target to force generation of Verilog per user settings
#   MOCK_ARRAY_WIDTH and MOCK_ARRAY_HEIGHT
verilog:
	./designs/asap7/mock-array-big/verilog.sh

# If this design isn't quickly done in detailed routing, something is wrong.
# At time of adding this option, only 3 iterations were needed for 0
# violations.
export DETAILED_ROUTE_ARGS=-droute_end_iter 10
