export DESIGN_NICKNAME = ibex
export DESIGN_NAME = ibex_core
export PLATFORM    = tsmc65lp

export VERILOG_FILES = ./designs/src/ibex/ibex_core.sv2v.v \
                       ./designs/src/ibex/prim_clock_gating.sv
export SDC_FILE      = ./designs/src/ibex/ibex_core.elab.v.sdc

# These values must be multiples of placement site
export DIE_AREA    = 0 0 950 650.4
export CORE_AREA   = 10 12 940 640.8

export CLOCK_PERIOD = 10.000
