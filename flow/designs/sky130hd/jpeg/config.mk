export DESIGN_NAME = jpeg
export DESIGN_TOP_NAME = jpeg_encoder
export PLATFORM    = sky130hd

export VERILOG_FILES = $(sort $(wildcard ./designs/src/$(DESIGN_NAME)/*.v))
export VERILOG_INCLUDE_DIRS = ./designs/src/$(DESIGN_NAME)/include
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export CORE_UTILIZATION = 50
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN = 2

export PLACE_DENSITY_LB_ADDON = 0.25
