export PLATFORM               = asap7

export VERILOG_FILES = $(sort $(wildcard ./designs/src/aes/*.v))
export SDC_FILE      = ./designs/$(PLATFORM)/aes/constraint.sdc

export SYNTH_HDL_FRONTEND     = slang
# ignore unsynthesizable timing controls (the sources' #1 delays)
export SYNTH_SLANG_ARGS += --ignore-timing

export ABC_AREA               = 1

# Absolute sizes, today's result of CORE_UTILIZATION 40 with yosys's
# Verilog frontend, so the parent's macros keep their size as yosys and
# OpenROAD improve: aes-block is the smoke test of BLOCKS plus macro
# placement, not of utilization.
ifeq ($(DESIGN_NAME),aes_rcon)
export DIE_AREA               = 0 0 9.144 9.144
export CORE_AREA              = 2.052 2.160 7.128 7.020
else ifeq ($(DESIGN_NAME),aes_sbox)
export DIE_AREA               = 0 0 15.866 15.866
export CORE_AREA              = 2.052 2.160 13.824 13.770
endif

export PLACE_DENSITY          = 0.70

export MAX_ROUTING_LAYER       ?= M5

export PLACE_PINS_ARGS = -annealing

export PDN_TCL                = $(PLATFORM_DIR)/openRoad/pdn/BLOCK_grid_strategy.tcl

