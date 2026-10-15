export PLATFORM               = asap7

export DESIGN_NAME            = aes_cipher_top
export DESIGN_NICKNAME        = aes-block

export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/aes/*.v))
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export SYNTH_HDL_FRONTEND     = slang
# ignore unsynthesizable timing controls (the sources' #1 delays)
export SYNTH_SLANG_ARGS += --ignore-timing

export ABC_AREA               = 1

# Absolute sizes, today's result of CORE_UTILIZATION 47 with yosys's
# Verilog frontend, so the macros keep fitting as yosys and OpenROAD
# improve: this design is the smoke test of BLOCKS plus macro placement,
# not of utilization.
export DIE_AREA               = 0 0 113.801 113.801
export CORE_AREA              = 2.052 2.160 111.780 111.780

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
export RTLMP_MIN_CHANNEL_SIZE  ?= 6 6

export ROUTING_LAYER_ADJUSTMENT = 0.3
export HOLD_SLACK_MARGIN        = -30
