export DESIGN_NICKNAME = ibex
export DESIGN_NAME = ibex_core
export PLATFORM    = gf12

export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/ibex_sv/*.sv)) \
    $(DESIGN_HOME)/src/ibex_sv/syn/rtl/prim_clock_gating.v

export VERILOG_INCLUDE_DIRS = \
    $(DESIGN_HOME)/src/ibex_sv/vendor/lowrisc_ip/prim/rtl/

export SYNTH_HDL_FRONTEND = slang

export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export CORE_UTILIZATION = 40 
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN = 2

export PLACE_DENSITY = 0.70

ifeq ($(USE_FILL),1)
export DESIGN_TYPE = CELL
else
export DESIGN_TYPE = CELL_NODEN
endif

# slack margin to address WC corner
export SETUP_SLACK_MARGIN ?= 180
export HOLD_SLACK_MARGIN ?= 50
