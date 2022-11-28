export DESIGN_NAME = jpeg
export DESIGN_TOP_NAME = jpeg_encoder
export PLATFORM    = gf12

export VERILOG_FILES = $(sort $(wildcard ./designs/src/$(DESIGN_NAME)/*.v))
export VERILOG_INCLUDE_DIRS = ./designs/src/$(DESIGN_NAME)/include

export SDC_FILE = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc
export ABC_AREA = 1

export CORE_UTILIZATION = 40
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN = 2

export PLACE_DENSITY = 0.75

ifneq ($(USE_FILL),)
export DESIGN_TYPE = CELL
else
export DESIGN_TYPE = CELL_NODEN
endif
