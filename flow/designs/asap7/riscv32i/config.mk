export DESIGN_NICKNAME ?= riscv32i
export DESIGN_NAME = riscv_top
export PLATFORM    = asap7

export SYNTH_HIERARCHICAL ?= 1

export SYNTH_MINIMUM_KEEP_SIZE ?= 10000

export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/riscv32i/*.v))
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/riscv32i/constraint.sdc

ifeq ($(BLOCKS),)
	export ADDITIONAL_LEFS = ./platforms/$(PLATFORM)/lef/fakeram7_256x32.lef
	export ADDITIONAL_LIBS = $(LIB_DIR)/fakeram7_256x32.lib
endif

export DIE_AREA = 0 0 80 90
export CORE_AREA = 5 5 75 85 

export PLACE_DENSITY_LB_ADDON = 0.10

export IO_CONSTRAINTS     = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/io.tcl
export MACRO_PLACE_HALO    = 2 2

export TNS_END_PERCENT   = 100

export CTS_CLUSTER_SIZE = 10
export CTS_CLUSTER_DIAMETER = 50
