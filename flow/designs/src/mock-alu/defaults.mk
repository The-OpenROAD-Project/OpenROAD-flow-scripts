export DESIGN_NAME            = MockAlu
export DESIGN_NICKNAME        = mock-alu

export VERILOG_FILES          = designs/src/mock-alu/*.v

export SDC_FILE               = designs/$(PLATFORM)/mock-alu/constraints.sdc

export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2

export PLACE_PINS_ARGS=-annealing
