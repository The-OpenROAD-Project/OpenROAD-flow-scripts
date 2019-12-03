export DESIGN_NAME = gcd
export PLATFORM    = nangate45

export VERILOG_FILES = ./designs/src/gcd/gcd.v
export SDC_FILE      = ./designs/src/gcd/gcd.sdc

export MERGED_LEF = ./platforms/nangate45/NangateOpenCellLibrary.mod.lef
export LIB_FILES  = ./platforms/nangate45/NangateOpenCellLibrary_typical.lib
export GDS_FILES  = $(wildcard ./platforms/nangate45/gds/*)


# These values must be multiples of placement site
# x=0.19 y=1.4
export DIE_AREA    = 0 0 100.13 100.8
export CORE_AREA   = 10.07 11.2 90.25 91
export CORE_WIDTH  = 80.18
export CORE_HEIGHT = 79.8

export CLOCK_PERIOD = 10.000
export CLOCK_PORT   = clk
