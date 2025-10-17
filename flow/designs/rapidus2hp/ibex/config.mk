export PLATFORM               = rapidus2hp

export DESIGN_NICKNAME        = ibex
export DESIGN_NAME            = ibex_core

export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/ibex_sv/*.sv)) \
    $(DESIGN_HOME)/src/ibex_sv/syn/rtl/prim_clock_gating.v

export VERILOG_INCLUDE_DIRS = \
    $(DESIGN_HOME)/src/ibex_sv/vendor/lowrisc_ip/prim/rtl/

export SYNTH_HDL_FRONTEND = slang

# if FLOW_VARIANT == pos_slack, use an SDC file that has a larger clock
# resulting in positive slack
ifeq ($(FLOW_VARIANT),pos_slack)
export SDC_FILE              = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint_pos_slack.sdc
else
export SDC_FILE              = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
endif

export CORE_UTILIZATION        = 70
export CORE_ASPECT_RATIO       = 1
export CORE_MARGIN             = 0.75
export PLACE_DENSITY_LB_ADDON  = 0.20

export ENABLE_DPO              = 0

export TNS_END_PERCENT         = 100
