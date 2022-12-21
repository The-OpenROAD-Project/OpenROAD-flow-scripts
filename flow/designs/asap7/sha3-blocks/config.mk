export PLATFORM               = asap7

export DESIGN_NAME            = sha3
export DESIGN_NICKNAME        = sha3-blocks

export VERILOG_FILES = ./designs/src/sha3/sha3.v
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export DFF_LIB_FILE           = $($(CORNER)_DFF_LIB_FILE)

export BLOCKS = sha3_core

export VERILOG_FILES_BLACKBOX = ./designs/src/$(DESIGN_NICKNAME)/sha3core.v

export ABC_CLOCK_PERIOD_IN_PS = 650

export CORE_UTILIZATION       = 10
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY          = 0.12

export MACRO_PLACE_CHANNEL  = 160 160
export MACRO_PLACE_HALO = 2 2
