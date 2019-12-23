export DESIGN_NAME = ibex_core
export PLATFORM    = nangate45

export VERILOG_FILES = ./designs/src/ibex/design.v
export SDC_FILE      = ./designs/src/ibex/design.sdc

# These values must be multiples of placement site
# x=0.19 y=1.4
export DIE_AREA    = 0 0 600.08 599.8
export CORE_AREA   = 10.07 11.2 590.01 590
export CORE_WIDTH  = 479.94
export CORE_HEIGHT = 478.8

export CLOCK_PERIOD = 10.000
export CLOCK_PORT   = clk_i

export PLACE_DENSITY = 0.45
