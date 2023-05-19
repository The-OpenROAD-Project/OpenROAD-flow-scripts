export DESIGN_NICKNAME = riscv32i
export DESIGN_NAME = riscv_top
export PLATFORM    = asap7

export SYNTH_HIERARCHICAL = 1
export RTLMP_FLOW = True
export MAX_UNGROUP_SIZE ?= 1000

export VERILOG_FILES = $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
export ADDITIONAL_LEFS = ./platforms/$(PLATFORM)/lef/fakeram7_256x32.lef
export ADDITIONAL_LIBS = ./platforms/$(PLATFORM)/lib/fakeram7_256x32.lib

export DIE_AREA = 0 0 80 90
export CORE_AREA = 5 5 75 85 

export PLACE_DENSITY_LB_ADDON = 0.10

export HAS_IO_CONSTRAINTS = 1
export PLACE_PINS_ARGS    = -exclude left:* -exclude right:* -exclude top:*
export MACRO_PLACE_HALO    = 3 3
export MACRO_PLACE_CHANNEL = 6 6
#
export TNS_END_PERCENT   ?= 100
