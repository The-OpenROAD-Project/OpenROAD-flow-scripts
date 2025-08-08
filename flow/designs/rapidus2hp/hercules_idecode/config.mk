export PLATFORM             = rapidus2hp

export DESIGN_NAME          = hercules_idecode

export SRC_HOME             = /platforms/Rapidus/designs/hercules_idecode
export VERILOG_FILES        = $(sort $(wildcard $(SRC_HOME)/hercules_idecode/verilog/*.sv)) \
	$(sort $(wildcard $(SRC_HOME)/shared/verilog/*.sv)) \
	$(sort $(wildcard $(SRC_HOME)/models/cells/generic/*.sv))

export VERILOG_INCLUDE_DIRS =  $(SRC_HOME)/hercules_idecode/verilog \
	$(SRC_HOME)/shared/verilog \
	$(SRC_HOME)/models/cells/generic

export SDC_FILE             = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/prects.sdc

export SYNTH_HDL_FRONTEND  ?= slang
export CORE_UTILIZATION     = 25
export CORE_MARGIN          = 1
export PLACE_DENSITY        = 0.50

# a smoketest for this option, there are a
# few last gasp iterations
export SKIP_LAST_GASP      ?= 1
