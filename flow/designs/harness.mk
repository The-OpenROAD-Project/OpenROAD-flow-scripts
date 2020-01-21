export DESIGN_NAME ?= SPECIFY_DESIGN_NAME
export PLATFORM    = nangate45

export VERILOG_FILES = ./designs/src/harness/*.v
export SDC_FILE      = ./designs/src/harness/design.sdc

export MERGED_LEF = ./platforms/nangate45/NangateOpenCellLibrary.mod.lef
export LIB_FILES  = ./platforms/nangate45/NangateOpenCellLibrary_typical.lib
export GDS_FILES  = $(wildcard ./platforms/nangate45/gds/*)

#
# These values must be multiples of placement site
# x=0.19 y=1.4
export DIE_AREA    = 0 0 9002.2 9016
export CORE_AREA   = 20.14 22.4 8623.34 8618.4

# Start with 250MHz for nangate45, relatively conservative
export CLOCK_PERIOD = 4
export CLOCK_PORT   = clock
