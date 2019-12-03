export DESIGN_NAME = ibex_core
export PLATFORM    = nangate45

export VERILOG_FILES = ./designs/src/ibex/design.v
export SDC_FILE      = ./designs/src/ibex/design.sdc

export MERGED_LEF = ./platforms/nangate45/NangateOpenCellLibrary.mod.lef
export LIB_FILES  = ./platforms/nangate45/NangateOpenCellLibrary_typical.lib
export GDS_FILES  = $(wildcard ./platforms/nangate45/gds/*)

# These values must be multiples of placement site
# x=0.19 y=1.4
export DIE_AREA    = 0 0 450.11 450.8
export CORE_AREA   = 10.07 11.2 440.23 441
export CORE_WIDTH  = 430.16
export CORE_HEIGHT = 429.8

export CLOCK_PERIOD = 10.000
export CLOCK_PORT   = clk_i
