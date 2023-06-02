include designs/asap7/mock-array-big/defaults.mk

export DESIGN_NAME = Element
export DESIGN_NICKNAME = mock-array-big_Element

export VERILOG_FILES = designs/src/mock-array-big/*.v
export SDC_FILE      = designs/asap7/mock-array-big/Element/constraints.sdc

export PLATFORM               = asap7

export PLACE_DENSITY          = 0.50
export GPL_TIMING_DRIVEN      = 0
export GPL_ROUTABILITY_DRIVEN = 0

export CORE_AREA = $(shell export MOCK_ARRAY_HEIGHT=$(MOCK_ARRAY_HEIGHT) && export MOCK_ARRAY_WIDTH=$(MOCK_ARRAY_WIDTH) && export MOCK_ARRAY_PITCH_SCALE=$(MOCK_ARRAY_PITCH_SCALE) && python3 designs/asap7/mock-array-big/ce_core_area.py)
export DIE_AREA = $(shell export MOCK_ARRAY_HEIGHT=$(MOCK_ARRAY_HEIGHT) && export MOCK_ARRAY_WIDTH=$(MOCK_ARRAY_WIDTH) && export MOCK_ARRAY_PITCH_SCALE=$(MOCK_ARRAY_PITCH_SCALE) && python3 designs/asap7/mock-array-big/ce_die_area.py)

export IO_CONSTRAINTS = designs/asap7/mock-array-big/Element/io.tcl

export PDN_TCL = designs/asap7/mock-array-big/Element/pdn.tcl

# max routing layer need to be set to M5, since M6 is needed for next level up to connect
# to the ring and stipe
export MAX_ROUTING_LAYER = M5

# If this design isn't quickly done in detailed routing, something is wrong.
# At time of adding this option, only 3 iterations were needed for 0
# violations.
export DETAILED_ROUTE_ARGS=-droute_end_iter 10
