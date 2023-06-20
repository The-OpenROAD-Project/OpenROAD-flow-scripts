include designs/asap7/mock-array/defaults.mk

export DESIGN_NAME = MockArray
export DESIGN_NICKNAME = mock-array

export VERILOG_FILES_BLACKBOX = designs/src/mock-array/Element.v
export VERILOG_FILES = designs/src/mock-array/*.v

export SDC_FILE      = designs/asap7/mock-array/constraints.sdc

export PLATFORM               = asap7

export PLACE_DENSITY          = 0.30

export CORE_AREA = $(shell \
 export MOCK_ARRAY_HEIGHT=$(MOCK_ARRAY_HEIGHT) && \
 export MOCK_ARRAY_WIDTH=$(MOCK_ARRAY_WIDTH) && \
 export MOCK_ARRAY_PITCH_SCALE=$(MOCK_ARRAY_PITCH_SCALE) && \
 cd designs/asap7/mock-array && \
 python3 -c "import config; print(f'{config.margin_x} {config.margin_y} {config.core_width + config.margin_x} {config.core_height + config.margin_y}')")
export DIE_AREA = $(shell \
 export MOCK_ARRAY_HEIGHT=$(MOCK_ARRAY_HEIGHT) && \
 export MOCK_ARRAY_WIDTH=$(MOCK_ARRAY_WIDTH) && \
 export MOCK_ARRAY_PITCH_SCALE=$(MOCK_ARRAY_PITCH_SCALE) && \
 cd designs/asap7/mock-array && \
 python3 -c "import config; print(f'0 0 {config.die_width} {config.die_height}')")

BLOCKS = Element

export GDS_ALLOW_EMPTY = Element

export MACRO_PLACEMENT_TCL = ./designs/asap7/mock-array/macro-placement.tcl

export IO_CONSTRAINTS = designs/asap7/mock-array/io.tcl

export PDN_TCL = designs/asap7/mock-array/pdn.tcl
export TNS_END_PERCENT       = 100

# Target to force generation of Verilog per user settings
#   MOCK_ARRAY_WIDTH and MOCK_ARRAY_HEIGHT
verilog:
	./designs/asap7/mock-array/verilog.sh

# If this design isn't quickly done in detailed routing, something is wrong.
# At time of adding this option, only 12 iterations were needed for 0
# violations.
export DETAILED_ROUTE_ARGS=-bottom_routing_layer M2 -top_routing_layer M7 -save_guide_updates -verbose 1 -droute_end_iter 15

# since we are specifying DETAILED_ROUTE_ARGS, we need to communicate the
# same information to other stages in the flow.
export MIN_ROUTING_LAYER = M2
export MAX_ROUTING_LAYER = M7
