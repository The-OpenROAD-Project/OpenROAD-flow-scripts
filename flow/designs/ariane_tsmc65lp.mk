export DESIGN_NAME = ariane
export PLATFORM    = tsmc65lp

export VERILOG_FILES = ./designs/src/ariane/design.v
export SDC_FILE      = ./designs/src/ariane/design.sdc

export MERGED_LEF = ./platforms/tsmc65lp/merged.lef
export LIB_FILES  = $(sort $(wildcard ./platforms/tsmc65lp/lib/*.lib))
export GDS_FILES  = $(sort $(wildcard ./platforms/tsmc65lp/gds/*.gds2))

export RUN_MACRO_PLACEMENT = 1

# These values must be multiples of placement site
export DIE_AREA    = 0 0 2200 1560
export CORE_AREA   = 10 12 2190 1550.4
export CORE_WIDTH  = 2180
export CORE_HEIGHT = 1538.4

export CLOCK_PERIOD = 5.600
export CLOCK_PORT   = clk_i
