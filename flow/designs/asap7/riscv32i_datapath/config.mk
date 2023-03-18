export DESIGN_NICKNAME = riscv32i_datapath
export DESIGN_NAME = datapath
export PLATFORM    = asap7

export VERILOG_FILES = ./designs/src/riscv32i/*.v
export SDC_FILE      = ./designs/asap7/riscv32i_datapath/constraint.sdc
#export ADDITIONAL_LEFS = ./platforms/$(PLATFORM)/lef/fakeram7_256x32.lef
#export ADDITIONAL_LIBS = ./platforms/$(PLATFORM)/lib/fakeram7_256x32.lib

export DIE_AREA = 0 0 30 60
export CORE_AREA =  0 0 40 50

# export CORE_UTILIZATION = 0.7
export IS_CHIP = 0
export PLACE_DENSITY = 0.7

export SYNTH_HIERARCHICAL = 1
# export RTLMP_FLOW = True
# RTL_MP Settings
# export RTLMP_MAX_INST = 10000
# export RTLMP_MIN_INST = 5000

export 
#export RTLMP_MAX_MACRO = 4
#export RTLMP_MIN_MACRO = 1
#export HAS_IO_CONSTRAINTS = 1
#export PLACE_PINS_ARGS = -exclude left:* -exclude right:* -exclude top:*
