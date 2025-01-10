export PLATFORM               = asap7

export DESIGN_NICKNAME        = ibex
export DESIGN_NAME            = ibex_core

export VERILOG_FILES         = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE              = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export CORE_UTILIZATION       =  40
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY_LB_ADDON  = 0.20

export ENABLE_DPO = 0

export TNS_END_PERCENT        = 100

export FP_REPAIR_TIMING_MAX_PASSES_PER_ITER = 5
export CTS_REPAIR_TIMING_MAX_PASSES_PER_ITER = 30
export GRT_REPAIR_TIMING_MAX_PASSES_PER_ITER = 20

