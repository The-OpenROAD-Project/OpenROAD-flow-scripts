export DESIGN_NAME = jpeg
export DESIGN_TOP_NAME = jpeg_encoder
export PLATFORM    = tsmc65lp

export VERILOG_FILES = $(sort $(wildcard ./designs/src/$(DESIGN_NAME)/*.v))
export VERILOG_INCLUDE_DIRS = ./designs/src/$(DESIGN_NAME)/include
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc
export ABC_AREA      = 1

export CORE_UTILIZATION = 40
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN = 5

export PLACE_DENSITY = 0.70
