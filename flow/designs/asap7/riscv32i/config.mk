export DESIGN_NICKNAME ?= riscv32i
export DESIGN_NAME = riscv_top
export PLATFORM    = asap7

export SYNTH_HIERARCHICAL ?= 1

export RTLMP_MIN_INST = 1000
export RTLMP_MAX_INST = 3500
export RTLMP_MIN_MACRO = 1
export RTLMP_MAX_MACRO = 5

export MAX_UNGROUP_SIZE ?= 1000

export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/riscv32i/*.v))
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/riscv32i/constraint.sdc

ifeq ($(BLOCKS),)
	export ADDITIONAL_LEFS = ./platforms/$(PLATFORM)/lef/fakeram7_256x32.lef
	export ADDITIONAL_LIBS = $(LIB_DIR)/fakeram7_256x32.lib
endif

export DIE_AREA = 0 0 80 90
export CORE_AREA = 5 5 75 85 

export PLACE_DENSITY_LB_ADDON = 0.10

export PLACE_PINS_ARGS    = -exclude left:* -exclude right:* -exclude top:*
export MACRO_PLACE_HALO    = 1 1
export MACRO_PLACE_CHANNEL = 6 6
#
export TNS_END_PERCENT   = 100
