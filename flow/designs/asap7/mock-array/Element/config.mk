include designs/asap7/mock-array/defaults.mk

export DESIGN_NAME = Element
export DESIGN_NICKNAME = mock-array_Element

export VERILOG_FILES = designs/src/mock-array/*.v
export SDC_FILE      = designs/asap7/mock-array/Element/constraints.sdc

export PLATFORM               = asap7

export PLACE_DENSITY          = 0.50
export GPL_TIMING_DRIVEN      = 0
export GPL_ROUTABILITY_DRIVEN = 0

export CORE_AREA = $(shell \
 export MOCK_ARRAY_HEIGHT=$(MOCK_ARRAY_HEIGHT) && \
 export MOCK_ARRAY_WIDTH=$(MOCK_ARRAY_WIDTH) && \
 export MOCK_ARRAY_PITCH_SCALE=$(MOCK_ARRAY_PITCH_SCALE) && \
 cd designs/asap7/mock-array && \
 python3 -c "import config; print(f'{config.ce_margin_x} {config.ce_margin_y} {config.ce_width - config.ce_margin_x} {config.ce_height - config.ce_margin_y}')")
export DIE_AREA = $(shell \
 export MOCK_ARRAY_HEIGHT=$(MOCK_ARRAY_HEIGHT) && \
 export MOCK_ARRAY_WIDTH=$(MOCK_ARRAY_WIDTH) && \
 export MOCK_ARRAY_PITCH_SCALE=$(MOCK_ARRAY_PITCH_SCALE) && \
 cd designs/asap7/mock-array && \
 python3 -c "import config; print(f'0 0 {config.ce_width} {config.ce_height}')")

export IO_CONSTRAINTS = designs/asap7/mock-array/Element/io.tcl

export PDN_TCL = designs/asap7/mock-array/Element/pdn.tcl

# max routing layer need to be set to M5, since M6 is needed for next level up to connect
# to the ring and stipe
#
# If this design isn't quickly done in detailed routing, something is wrong.
# At time of adding this option, only 3 iterations were needed for 0
# violations.
export DETAILED_ROUTE_ARGS=-bottom_routing_layer M2 -top_routing_layer M5 -save_guide_updates -verbose 1 -droute_end_iter 10

# since we are specifying DETAILED_ROUTE_ARGS, we need to communicate the
# same information to other stages in the flow.
export MIN_ROUTING_LAYER = M2
export MAX_ROUTING_LAYER = M5
