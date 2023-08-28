export PLATFORM               = asap7

export DESIGN_NAME            = sha3
export DESIGN_NICKNAME        = sha3-blocks

export VERILOG_FILES = $(sort $(wildcard ./designs/src/sha3/*.v))
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export CORE_UTILIZATION       = 30
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY          = 0.30

export SYNTH_HIERARCHICAL = 1
export RTLMP_FLOW = True

export BLOCKS = sha3_core

export PLACE_PINS_ARGS = -annealing

# Generous routing at top level
export MIN_ROUTING_LAYER      = M2
export MAX_ROUTING_LAYER      = M9

# Ignore power at this exploratory level
export GND_NETS_VOLTAGES      = ""
export PWR_NETS_VOLTAGES      = ""
