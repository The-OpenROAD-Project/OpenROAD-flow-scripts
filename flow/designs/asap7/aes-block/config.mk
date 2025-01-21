export PLATFORM               = asap7

export DESIGN_NAME            = aes_cipher_top
export DESIGN_NICKNAME        = aes-block

export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/aes/*.v))
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export ABC_AREA               = 1

export CORE_UTILIZATION       = 27
export CORE_ASPECT_RATIO      = 0.867
export CORE_MARGIN            = 2
export PLACE_DENSITY          = 0.65

export BLOCKS ?= aes_rcon aes_sbox
export SYNTH_HIERARCHICAL = 1

export PLACE_PINS_ARGS = -annealing

# Generous routing at top level
export MIN_ROUTING_LAYER      = M2
export MAX_ROUTING_LAYER      = M9

# Ignore power at this exploratory level
export GND_NETS_VOLTAGES      =
export PWR_NETS_VOLTAGES      =

# The macros are very small so use a smaller halo
export MACRO_PLACE_HALO        ?= 5 5

export ROUTING_LAYER_ADJUSTMENT = 0.23

# Parameters from AutoTuner runs
export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 2
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 1
export CTS_CLUSTER_SIZE = 155
export CTS_CLUSTER_DIAMETER = 248
export PLACE_DENSITY_LB_ADDON = 0.14
