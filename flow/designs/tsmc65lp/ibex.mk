export DESIGN_NICKNAME = ibex
export DESIGN_NAME = ibex_core
export PLATFORM    = tsmc65lp

export VERILOG_FILES = ./designs/src/ibex/design.v
export SDC_FILE      = ./designs/src/ibex/design.sdc

# These values must be multiples of placement site
export DIE_AREA    = 0 0 950 650.4
export CORE_AREA   = 10 12 940 640.8

export CLOCK_PERIOD = 10.000
export CLOCK_PORT   = clk_i
