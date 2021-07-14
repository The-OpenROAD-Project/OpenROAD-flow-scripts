export DESIGN_NICKNAME = jpeg
export DESIGN_NAME = jpeg_encoder
export PLATFORM    = gf12

export VERILOG_FILES = $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v))
export VERILOG_INCLUDE_DIRS = ./designs/src/$(DESIGN_NICKNAME)/include
#export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint_ppa.sdc
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

# These values must be multiples of placement site
#export DIE_AREA    = 0 0 1200 960.8
#export CORE_AREA   = 10 12 1190 951.2
export CORE_UTILIZATION = 40
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN = 2

export PLACE_DENSITY = 0.75
