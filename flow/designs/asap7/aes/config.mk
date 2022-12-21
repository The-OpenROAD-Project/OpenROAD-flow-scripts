export PLATFORM               = asap7

export DESIGN_NAME            = aes_cipher_top
export DESIGN_NICKNAME        = aes

export VERILOG_FILES = $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export ABC_AREA               = 1

export CORE_UTILIZATION       = 40 
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY         = 0.65
