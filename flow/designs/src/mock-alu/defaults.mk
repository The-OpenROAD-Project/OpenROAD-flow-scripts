export MOCK_ALU_WIDTH     ?= 64
export MOCK_ALU_OPERATIONS?= ADD,SUB,AND,OR,XOR,SHL,SHR,SRA,SETCC_EQ,SETCC_NE,SETCC_LT,SETCC_ULT,SETCC_LE,SETCC_ULE,MULT

export MOCK_REGISTERFILE_WIDTH     ?= 64
export MOCK_REGISTERFILE_READ_PORTS ?= 8
export MOCK_REGISTERFILE_WRITE_PORTS ?= 4
export MOCK_REGISTERFILE_REGISTERS ?= 128

export DESIGN_NAME            = MockAlu
export DESIGN_NICKNAME        = mock-alu

export VERILOG_FILES          = designs/src/mock-alu/*.sv designs/src/mock-alu/*.v

export SDC_FILE               = designs/$(PLATFORM)/mock-alu/constraints.sdc

export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2

verilog:
	export MOCK_ALU_WIDTH=$(word 1, $(MOCK_ALU_WIDTH)) ; \
	./designs/src/mock-alu/verilog.sh

export PLACE_PINS_ARGS=-annealing
