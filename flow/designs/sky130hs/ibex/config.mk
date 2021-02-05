export DESIGN_NICKNAME = ibex
export DESIGN_NAME = ibex_core
export PLATFORM    = sky130hs

export VERILOG_FILES = ./designs/src/$(DESIGN_NICKNAME)/ibex_core.sv2v.v \
                       ./designs/src/$(DESIGN_NICKNAME)/prim_clock_gating.sv
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

# These values must be multiples of placement site
# x=0.19 y=1.4
export DIE_AREA    = 0 0 3000 1999
export CORE_AREA   = 150.0 150 2850.0 1850


