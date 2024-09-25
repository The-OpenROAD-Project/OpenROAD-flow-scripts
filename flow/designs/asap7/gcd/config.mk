export PLATFORM               = asap7

export DESIGN_NAME            = gcd

export VERILOG_FILES          = $(sort $(wildcard ./designs/src/$(DESIGN_NAME)/*.v))
export SDC_FILE               = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export DIE_AREA               = 0 0 16.2 16.2
export CORE_AREA              = 1.08 1.08 15.12 15.12
export PLACE_DENSITY          = 0.35

# Imagine some out of tree tool here that optimizes after synthesis
export FLOORPLAN_INPUT_STEM = 1_2_faster_synth

# include private.mk so that RESULTS_DIR is defined when we create more
# targets.
export PRIVATE_DIR = ./designs/$(PLATFORM)/$(DESIGN_NAME)
