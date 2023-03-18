export DESIGN_NICKNAME = riscv32i_regfile
export DESIGN_NAME = regfile
export PLATFORM    = asap7

export VERILOG_FILES = ./designs/src/riscv32i/regfile.v
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
# export ADDITIONAL_LEFS = ./platforms/$(PLATFORM)/lef/fakeram7_256x32.lef
# export ADDITIONAL_LIBS = ./platforms/$(PLATFORM)/lib/fakeram7_256x32.lib

# export DIE_AREA = 0 0 20 100
# export CORE_AREA = 5 5 15 95

export CORE_UTILIZATION = 60

export PLACE_DENSITY = 0.84

# export SYNTH_HIERARCHICAL = 1
# export RTLMP_FLOW = True
# RTL_MP Settings
# export RTLMP_MAX_INST = 10000
# export RTLMP_MIN_INST = 5000
# export RTLMP_MAX_MACRO = 4
# export RTLMP_MIN_MACRO = 1
# export HAS_IO_CONSTRAINTS = 1
# export PLACE_PINS_ARGS = -exclude left:* -exclude right:* -exclude top:*
