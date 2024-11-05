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

export MACRO_PLACE_HALO = 0 2.16
export RTLMP_BOUNDARY_WT = 0
export RTLMP_FLOW ?= 1

export BLOCKS                ?= Element

ifneq ($(BLOCKS),)
  export GDS_ALLOW_EMPTY       = Element
  ifneq ($(RTLMP_FLOW), 1)
    export MACRO_PLACEMENT_TCL   = $(DESIGN_HOME)/asap7/mock-array/macro-placement.tcl
  endif
  export PDN_TCL               = $(PLATFORM_DIR)/openRoad/pdn/BLOCKS_grid_strategy.tcl
endif

export IO_CONSTRAINTS        = designs/asap7/mock-array/io.tcl

# Target to force generation of Verilog per user settings MOCK_ARRAY_TABLE (rows, cols)
.PHONY: verilog
verilog:
	export MOCK_ARRAY_ROWS=$(word 1, $(MOCK_ARRAY_TABLE)) ; \
	export MOCK_ARRAY_COLS=$(word 2, $(MOCK_ARRAY_TABLE)) ; \
	$(DESIGN_HOME)/asap7/mock-array/verilog.sh

.PHONY: simulate
simulate:
	export MOCK_ARRAY_ROWS=$(word 1, $(MOCK_ARRAY_TABLE)) ; \
	export MOCK_ARRAY_COLS=$(word 2, $(MOCK_ARRAY_TABLE)) ; \
	$(DESIGN_HOME)/asap7/mock-array/simulate.sh

.PHONY: power
power:
	$(OPENSTA_EXE) -no_init -exit designs/asap7/mock-array/power.tcl

# Routing by abutment should be easy, limit iterations
export DETAILED_ROUTE_END_ITERATION = 6

export MAX_ROUTING_LAYER = M9
export ROUTING_LAYER_ADJUSTMENT = 0.45

# works with 28 or more iterations as of writing, so give it a few more.
export GLOBAL_ROUTE_ARGS=-congestion_iterations 40 -verbose

# ensure we have some rows, so we don't get a bad clock skew.
export MACRO_HALO_X            = 0.5
export MACRO_HALO_Y            = 0.5

export ADDITIONAL_FILES = designs/src/mock-array/util.tcl

export IO_PLACER_V = M5 M7
export IO_PLACER_H = M4 M6
