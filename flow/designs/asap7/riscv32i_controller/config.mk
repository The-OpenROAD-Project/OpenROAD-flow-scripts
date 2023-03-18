export DESIGN_NICKNAME = riscv32i_controller
export DESIGN_NAME = controller
export PLATFORM    = asap7

export VERILOG_FILES = ./designs/src/riscv32i_datapath/*.v
export SDC_FILE      = ./designs/asap7/riscv32i_controller/constraint.sdc
#export ADDITIONAL_LEFS = ./platforms/$(PLATFORM)/lef/fakeram7_256x32.lef
#export ADDITIONAL_LIBS = ./platforms/$(PLATFORM)/lib/fakeram7_256x32.lib

#export DIE_AREA = 0 0 120 120
#export CORE_AREA = 5 5 110 110

export IS_CHIP = 0
export PLACE_DENSITY = 0.65

export SYNTH_HIERARCHICAL = 1
export RTLMP_FLOW = True
# RTL_MP Settings
export RTLMP_MAX_INST = 10000
export RTLMP_MIN_INST = 5000
#export RTLMP_MAX_MACRO = 4
#export RTLMP_MIN_MACRO = 1
#export HAS_IO_CONSTRAINTS = 1
#export PLACE_PINS_ARGS = -exclude left:* -exclude right:* -exclude top:*
