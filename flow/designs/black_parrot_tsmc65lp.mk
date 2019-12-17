export DESIGN_NAME = black_parrot
export PLATFORM    = tsmc65lp

export VERILOG_FILES = ./designs/src/black_parrot/pickled.v \
                       ./designs/src/black_parrot/tsmc65lp_macros.v
export SDC_FILE      = ./designs/src/black_parrot/design.sdc

export MERGED_LEF = ./platforms/tsmc65lp/merged.lef
export LIB_FILES  = $(sort $(wildcard ./platforms/tsmc65lp/lib/*.lib))
export GDS_FILES  = $(sort $(wildcard ./platforms/tsmc65lp/gds/*.gds2))

export RUN_MACRO_PLACEMENT = 1

# These values must be multiples of placement site
export DIE_AREA    = 0 0 2200 2000.8
export CORE_AREA   = 10 12 2190 1991.2
export CORE_WIDTH  = 2180
export CORE_HEIGHT = 1979.2

export CLOCK_PERIOD = 5.600
export CLOCK_PORT   = clk_i
