export DESIGN_NAME = swerv
export PLATFORM    = nangate45

export VERILOG_FILES = ./designs/src/swerv/design.v
export SDC_FILE      = ./designs/src/swerv/design.sdc

export MERGED_LEF = ./platforms/nangate45/NangateOpenCellLibrary.mod.lef
export LIB_FILES  = ./platforms/nangate45/NangateOpenCellLibrary_typical.lib
export GDS_FILES  = $(wildcard ./platforms/nangate45/gds/*)

# These values must be multiples of placement site
# x=0.19 y=1.4
export DIE_AREA    = 0 0 1550.02 1342.6
export CORE_AREA   = 10.07 11.2 1540.14 1332.8
export CORE_WIDTH  = 1530.07
export CORE_HEIGHT = 1321.6

export CLOCK_PERIOD = 10.000
export CLOCK_PORT   = clk
