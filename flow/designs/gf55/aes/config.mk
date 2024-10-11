
DESIGN_DIR              := $(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

export DESIGN_NICKNAME   = aes
export DESIGN_NAME       = aes_cipher_top
export PLATFORM          = gf55

export VERILOG_FILES     = $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE          = $(DESIGN_DIR)/constraint.sdc
export ABC_AREA          = 1

export VT                = L
export CORNER            = BC

export CORE_UTILIZATION  = 35
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN       = 4

export PLACE_DENSITY     = 0.50
export RECOVER_POWER     = 100

ifeq ($(USE_FILL),1)
export DESIGN_TYPE = CELL
else
export DESIGN_TYPE = CELL_NODEN
endif
