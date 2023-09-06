export MOCK_REGISTERFILE_WIDTH     ?= 64
export MOCK_REGISTERFILE_READ_PORTS ?= 8
export MOCK_REGISTERFILE_WRITE_PORTS ?= 4
export MOCK_REGISTERFILE_REGISTERS ?= 128
     
export DESIGN_NAME            = MockRegisterFile
export DESIGN_NICKNAME        = mock-registerfile

export VERILOG_FILES          = designs/src/mock-alu/registerfile/*.sv

export SDC_FILE               = designs/$(PLATFORM)/mock-registerfile/constraints.sdc

export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2

# Requires firtool 0.53 or newer in path
verilog:
	export MOCK_REGISTERFILE_WIDTH=$(MOCK_REGISTERFILE_WIDTH) ; \
	export MOCK_REGISTERFILE_READ_PORTS=$(MOCK_REGISTERFILE_READ_PORTS) ; \
	export MOCK_REGISTERFILE_WRITE_PORTS=$(MOCK_REGISTERFILE_WRITE_PORTS) ; \
	export MOCK_REGISTERFILE_REGISTERS=$(MOCK_REGISTERFILE_REGISTERS) ; \
	./designs/src/mock-alu/verilog-registerfile.sh

export PLACE_PINS_ARGS=-annealing
