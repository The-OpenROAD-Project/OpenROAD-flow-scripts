export DESIGN_NICKNAME = jpeg
export DESIGN_NAME = jpeg_encoder
export PLATFORM    = sky130hs

export VERILOG_FILES = $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v))
export VERILOG_INCLUDE_DIRS = ./designs/src/$(DESIGN_NICKNAME)/include
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
export ABC_AREA = 1

export CORE_UTILIZATION = 50
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN = 2

export PLACE_DENSITY_LB_ADDON = 0.25
