export PLATFORM               = rapidus2hp

export DESIGN_NAME            = hercules_is_int

export SRC_HOME = /platforms/Rapidus/designs/hercules_is_int

ifeq ($(FLOW_VARIANT), gatelevel)
  export SYNTH_NETLIST_FILES = $(SRC_HOME)/ca78_8t_postroute_0707.v
endif

export VERILOG_FILES          =	$(sort $(wildcard $(SRC_HOME)/hercules_issue/verilog/*.sv)) \
	$(sort $(wildcard $(SRC_HOME)/shared/verilog/*.sv)) \
	$(sort $(wildcard $(SRC_HOME)/models/cells/generic/*.sv))

export VERILOG_INCLUDE_DIRS =  $(SRC_HOME)/hercules_issue/verilog \
	$(SRC_HOME)/shared/verilog \
	$(SRC_HOME)/models/cells/generic

export VERILOG_DEFINES +=

export SDC_FILE               = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/prects.sdc

# Must be defined before the ifeq's
export SYNTH_HDL_FRONTEND  = slang
export SYNTH_HIERARCHICAL ?= 0

ifeq ($(PLACE_SITE), SC6T)
  export CORE_UTILIZATION       = 30
else
  export CORE_UTILIZATION       = 35
endif

export CORE_MARGIN            = 2
export MACRO_PLACE_HALO       = 2 2

export PLACE_DENSITY          = 0.58

# a smoketest for this option, there are a
# few last gasp iterations
export SKIP_LAST_GASP ?= 1

# For use with SYNTH_HIERARCHICAL
export SYNTH_MINIMUM_KEEP_SIZE ?= 40000
