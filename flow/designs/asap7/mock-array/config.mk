include designs/asap7/mock-array/defaults.mk

export DESIGN_NAME            = MockArray
export DESIGN_NICKNAME        = mock-array

export VERILOG_FILES          = designs/src/mock-array/*.v

export SDC_FILE               = designs/asap7/mock-array/constraints.sdc

export PLATFORM               = asap7

export PLACE_DENSITY          = 0.30

export CORE_AREA = $(shell \
  export MOCK_ARRAY_TABLE="$(MOCK_ARRAY_TABLE)"  && \
  export MOCK_ARRAY_SCALE="$(MOCK_ARRAY_SCALE)" && \
  cd $(dir $(DESIGN_CONFIG)) && \
  python3 -c "import config ; print(f'{config.margin_x} {config.margin_y} {config.core_width + config.margin_x} {config.core_height + config.margin_y}')")

export DIE_AREA  = $(shell \
  export MOCK_ARRAY_TABLE="$(MOCK_ARRAY_TABLE)" && \
  export MOCK_ARRAY_SCALE="$(MOCK_ARRAY_SCALE)" && \
  cd $(dir $(DESIGN_CONFIG)) && \
  python3 -c "import config; print(f'{0} {0} {config.die_width} {config.die_height}')")

export BLOCKS                       = Element

export GDS_ALLOW_EMPTY       = Element

export MACRO_PLACEMENT_TCL   = ./designs/asap7/mock-array/macro-placement.tcl

export IO_CONSTRAINTS        = designs/asap7/mock-array/io.tcl

export PDN_TCL               = $(FLOW_HOME)/platforms/asap7/openRoad/pdn/BLOCKS_grid_strategy.tcl

# Target to force generation of Verilog per user settings MOCK_ARRAY_TABLE (rows, cols)
verilog:
	export MOCK_ARRAY_ROWS=$(word 1, $(MOCK_ARRAY_TABLE)) ; \
	export MOCK_ARRAY_COLS=$(word 2, $(MOCK_ARRAY_TABLE)) ; \
	./designs/asap7/mock-array/verilog.sh

# If this design isn't quickly done in detailed routing, something is wrong.
# At time of adding this option, only 12 iterations were needed for 0
# violations.
export DETAILED_ROUTE_ARGS   = -bottom_routing_layer M2 -top_routing_layer M7 -save_guide_updates -verbose 1 -droute_end_iter 15

# since we are specifying DETAILED_ROUTE_ARGS, we need to communicate the
# same information to other stages in the flow.
export MIN_ROUTING_LAYER = M2
export MAX_ROUTING_LAYER = M7

# works with 28 or more iterations as of writing, so give it a few more.
export GLOBAL_ROUTE_ARGS=-congestion_iterations 40 -verbose
export FASTROUTE_TCL = ./designs/$(PLATFORM)/mock-array/fastroute.tcl

# ensure we have some rows, so we don't get a bad clock skew.
export MACRO_HALO_X            = 0.5
export MACRO_HALO_Y            = 0.5
