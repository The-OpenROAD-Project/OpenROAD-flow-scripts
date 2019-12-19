export DESIGN_NAME = bp_fe_top
export PLATFORM    = nangate45

export VERILOG_FILES = ./designs/src/bp_fe_top/pickled.v \
                       ./designs/src/bp_fe_top/nangate45_macros.v
export SDC_FILE      = ./designs/src/bp_fe_top/design.sdc

export MERGED_LEF = ./platforms/nangate45/NangateOpenCellLibrary.mod.lef
export ADDITIONAL_LEFS = $(wildcard ./designs/src/bp_fe_top/fakeram45*.lef)
export LIB_FILES  = ./platforms/nangate45/NangateOpenCellLibrary_typical.lib \
                    $(wildcard ./designs/src/bp_fe_top/fakeram45*.lib)
export GDS_FILES  = $(wildcard ./platforms/nangate45/gds/*)

export RUN_MACRO_PLACEMENT = 1

# These values must be multiples of placement site
# x=0.19 y=1.4
export DIE_AREA    = 0 0 1550.02 1342.6
export CORE_AREA   = 10.07 11.2 1540.14 1332.8
export CORE_WIDTH  = 1530.07
export CORE_HEIGHT = 1321.6

export CLOCK_PERIOD = 5.600
export CLOCK_PORT   = clk_i
