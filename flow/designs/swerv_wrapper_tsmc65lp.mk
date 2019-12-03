export DESIGN_NAME = swerv_wrapper
export PLATFORM    = tsmc65lp

export VERILOG_FILES = ./designs/src/swerv/design.v
export SDC_FILE      = ./designs/src/swerv/design.sdc

export MERGED_LEF = ./platforms/tsmc65lp/merged.lef
export LIB_FILES  = $(sort $(wildcard ./platforms/tsmc65lp/lib/*.lib))
export GDS_FILES  = $(sort $(wildcard ./platforms/tsmc65lp/gds/*.gds2))

export RUN_MACRO_PLACEMENT = 1

# These values must be multiples of placement site
export DIE_AREA    = 0 0 1848 1449.6
export CORE_AREA   = 10 12 1838 1440
export CORE_WIDTH  = 1828
export CORE_HEIGHT = 1428

export CLOCK_PERIOD = 10.000
export CLOCK_PORT   = clk
