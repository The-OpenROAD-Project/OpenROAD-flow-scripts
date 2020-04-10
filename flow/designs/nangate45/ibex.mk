export DESIGN_NICKNAME = ibex
export DESIGN_NAME = ibex_core
export PLATFORM    = nangate45

export VERILOG_FILES = ./designs/src/ibex/ibex_core.sv2v.v \
                       ./designs/src/ibex/prim_clock_gating.sv
export SDC_FILE      = ./designs/src/ibex/ibex_core.elab.v.sdc

# These values must be multiples of placement site
# x=0.19 y=1.4
export DIE_AREA    = 0 0 600.08 599.8
export CORE_AREA   = 10.07 11.2 590.01 590

export CLOCK_PERIOD = 10.000
