export DESIGN_NICKNAME = aes
export DESIGN_NAME     = aes_cipher_top
export PLATFORM        = gf180

export VERILOG_FILES   = $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE        = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
export ABC_AREA        = 1

export CORE_UTILIZATION  = 35
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN       = 2

export PLACE_DENSITY = 0.60

ifneq ($(USE_FILL),)
export DESIGN_TYPE = CELL
else
export DESIGN_TYPE = CELL_NODEN
endif
