export PLATFORM               = asap7

export VERILOG_FILES = $(sort $(wildcard ./designs/src/aes/*.v))
export SDC_FILE      = ./designs/$(PLATFORM)/aes/constraint.sdc

export ABC_AREA               = 1

export CORE_UTILIZATION       = 40 
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY          = 0.70

export PDN_TCL                = $(FLOW_HOME)/platforms/asap7/openRoad/pdn/BLOCK_grid_strategy.tcl

export PLACE_PINS_ARGS = -annealing
export HAS_IO_CONSTRAINTS = 0
