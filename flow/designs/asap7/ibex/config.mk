export PLATFORM               = asap7

export DESIGN_NICKNAME        = ibex
export DESIGN_NAME            = ibex_core

export VERILOG_FILES         = $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE              = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

#export CORE_UTILIZATION       =  40
#export CORE_ASPECT_RATIO      = 1
#export CORE_MARGIN            = 2
#export PLACE_DENSITY_LB_ADDON  = 0.20

export CORE_UTILIZATION       =  38
export CORE_ASPECT_RATIO      = 1.817627195520696
export CORE_MARGIN            = 2
export PLACE_DENSITY_LB_ADDON  = 0.6572863558735609

export CTS_CLUSTER_SIZE = 116
export CTS_CLUSTER_DIAMETER = 45

export ENABLE_DPO = 0

export DFF_LIB_FILE           = $($(CORNER)_DFF_LIB_FILE)

export FASTROUTE_TCL = ./designs/$(PLATFORM)/ibex/fastroute.tcl