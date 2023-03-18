export DESIGN_NICKNAME = riscv32i
export DESIGN_NAME = riscv_top
export PLATFORM    = asap7


export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export VERILOG_FILES_BLACKBOX = ./designs/src/$(DESIGN_NICKNAME)/blackbox/regfile.v

export VERILOG_FILES = $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v))


export ADDITIONAL_LEFS = $(sort $(wildcard ./platforms/$(PLATFORM)/blackbox/*.lef))
export ADDITIONAL_LIBS = $(sort $(wildcard ./platforms/$(PLATFORM)/blackbox/*.lib))
# export ADDITIONAL_GDS = $(sort $(wildcard ./platforms/$(PLATFORM)/blackbox/*.gds))


# export DIE_AREA = 0 0 120 120
# export CORE_AREA = 5 5 110 110
# export PLACE_DENSITY = 0.65

export CORE_UTILIZATION = 40

# export PLACE_DENSITY = 0.84
BLOCKS = regfile

# export MACRO_EXTENSION = 2

# export SYNTH_HIERARCHICAL = 1
# export RTLMP_FLOW = True
# # RTL_MP Settings
# export RTLMP_MAX_INST = 10000
# export RTLMP_MIN_INST = 5000
# export RTLMP_MAX_MACRO = 4
# export RTLMP_MIN_MACRO = 1
export HAS_IO_CONSTRAINTS = 1
export PLACE_PINS_ARGS = -exclude left:* -exclude right:* -exclude top:*
