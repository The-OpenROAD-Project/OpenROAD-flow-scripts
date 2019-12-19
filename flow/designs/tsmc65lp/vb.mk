export DESIGN_NAME = bsg_manycore_tile
export PLATFORM    = tsmc65lp

export VERILOG_FILES = ./designs/src/vb/design.v
export SDC_FILE      = ./designs/src/vb/design.sdc

export MERGED_LEF = ./platforms/tsmc65lp/merged.lef
export LIB_FILES  = $(sort $(wildcard ./platforms/tsmc65lp/lib/*.lib))
export GDS_FILES  = $(sort $(wildcard ./platforms/tsmc65lp/gds/*.gds2))

export RUN_MACRO_PLACEMENT = 1

# These values must be multiples of placement site
export DIE_AREA    = 0 0 1100 400.8
export CORE_AREA   = 10 12 1090 391.2
export CORE_WIDTH  = 1080
export CORE_HEIGHT = 379.2

export CLOCK_PERIOD = 5.000
export CLOCK_PORT   = clk_i

