export DESIGN_NICKNAME = ibex
export DESIGN_NAME = ibex_core
export PLATFORM    = gf12

export VERILOG_FILES = ./designs/src/$(DESIGN_NICKNAME)/ibex_core.sv2v.v \
                       ./designs/src/$(DESIGN_NICKNAME)/prim_clock_gating.sv
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export CORE_UTILIZATION = 18
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN = 10
