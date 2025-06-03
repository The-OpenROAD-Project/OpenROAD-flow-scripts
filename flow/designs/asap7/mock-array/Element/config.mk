include designs/asap7/mock-array/defaults.mk

export DESIGN_NAME            = Element
export DESIGN_NICKNAME        = mock-array_Element

export VERILOG_FILES          = designs/src/mock-array/*.v
export SDC_FILE               = designs/asap7/mock-array/constraints.sdc

export PLATFORM               = asap7

export PLACE_DENSITY          = 0.82

export CORE_AREA = $(shell \
  export MOCK_ARRAY_TABLE="$(MOCK_ARRAY_TABLE)" && \
  export MOCK_ARRAY_SCALE="$(MOCK_ARRAY_SCALE)" && \
  cd $(DESIGN_DIR)/../ && \
  python3 -c "import config; print(f'{config.ce_margin_x} {config.ce_margin_y} {config.ce_width - config.ce_margin_x} {config.ce_height - config.ce_margin_y}')")

export DIE_AREA = $(shell \
  export MOCK_ARRAY_TABLE="$(MOCK_ARRAY_TABLE)" && \
  export MOCK_ARRAY_SCALE="$(MOCK_ARRAY_SCALE)" && \
  cd $(DESIGN_DIR)/../ && \
  python3 -c "import config; print(f'0 0 {config.ce_width} {config.ce_height}')")

export IO_CONSTRAINTS         = designs/asap7/mock-array/Element/io.tcl

export PDN_TCL                = $(PLATFORM_DIR)/openRoad/pdn/BLOCK_grid_strategy.tcl

# Detailed routing should be easy, limit iterations
export DETAILED_ROUTE_END_ITERATION ?= 6

export MIN_ROUTING_LAYER = M2
# M5 is the top PDN layer, so don't exceed that.
export MAX_ROUTING_LAYER = M5

export IO_PLACER_H=M2 M4
export IO_PLACER_V=M3 M5

export PLACE_PINS_ARGS = -annealing

export GND_NETS_VOLTAGES      =
export PWR_NETS_VOLTAGES      =

export ADDITIONAL_FILES = designs/src/mock-array/util.tcl
