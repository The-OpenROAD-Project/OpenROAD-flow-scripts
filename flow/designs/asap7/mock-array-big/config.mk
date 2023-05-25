include designs/asap7/mock-array-big/defaults.mk

export DESIGN_NAME = MockArray
export DESIGN_NICKNAME = mock-array-big

export VERILOG_FILES_BLACKBOX = designs/src/mock-array-big/Element.v
export VERILOG_FILES = designs/src/mock-array-big/*.v

export SDC_FILE      = designs/asap7/mock-array-big/constraints.sdc

export PLATFORM               = asap7

export PLACE_DENSITY          = 0.30

export CORE_AREA = $(shell \
 export MOCK_ARRAY_HEIGHT=$(MOCK_ARRAY_HEIGHT) && \
 export MOCK_ARRAY_WIDTH=$(MOCK_ARRAY_WIDTH) && \
 export MOCK_ARRAY_PITCH_SCALE=$(MOCK_ARRAY_PITCH_SCALE) && \
 cd designs/asap7/mock-array-big && \
 python3 -c "import config; print(f'{config.margin_x} {config.margin_y} {config.core_width + config.margin_x} {config.core_height + config.margin_y}')")
export DIE_AREA = $(shell \
 export MOCK_ARRAY_HEIGHT=$(MOCK_ARRAY_HEIGHT) && \
 export MOCK_ARRAY_WIDTH=$(MOCK_ARRAY_WIDTH) && \
 export MOCK_ARRAY_PITCH_SCALE=$(MOCK_ARRAY_PITCH_SCALE) && \
 cd designs/asap7/mock-array-big && \
 python3 -c "import config; print(f'0 0 {config.die_width} {config.die_height}')")

BLOCKS = Element

export GDS_ALLOW_EMPTY = Element

export MACRO_PLACEMENT_TCL = ./designs/asap7/mock-array-big/macro-placement.tcl

export IO_CONSTRAINTS = designs/asap7/mock-array-big/io.tcl

export PDN_TCL = designs/asap7/mock-array-big/pdn.tcl
export TNS_END_PERCENT       ?= 100

export PRIVATE_DIR=designs/asap7/mock-array-big
