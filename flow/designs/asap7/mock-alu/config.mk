include designs/asap7/mock-alu/defaults.mk

export DESIGN_NAME            = MockAlu
export DESIGN_NICKNAME        = mock-alu

export VERILOG_FILES          = designs/src/mock-alu/*.v

export SDC_FILE               = designs/asap7/mock-alu/constraints.sdc

export PLATFORM               = asap7

export PLACE_DENSITY          = 0.75
export CORE_UTILIZATION       = 50
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2

verilog:
	export MOCK_ALU_WIDTH=$(word 1, $(MOCK_ALU_WIDTH)) ; \
	./designs/asap7/mock-alu/verilog.sh
