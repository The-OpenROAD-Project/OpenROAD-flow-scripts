export DESIGN_NICKNAME = aes
export DESIGN_NAME = aes_cipher_top
export PLATFORM    = asap7

export VERILOG_FILES = $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

# These values must be multiples of placement site
#export DIE_AREA    = 0 0 620 520.8
#export CORE_AREA   = 10 12 610 511.2
export CORE_UTILIZATION = 15
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN = 2
