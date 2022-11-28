export PLATFORM               = asap7

export DESIGN_TOP_NAME            = jpeg_encoder
export DESIGN_NAME        = jpeg

export VERILOG_FILES          = $(sort $(wildcard ./designs/src/$(DESIGN_NAME)/*.v))
export VERILOG_INCLUDE_DIRS   = ./designs/src/$(DESIGN_NAME)/include
export SDC_FILE               = ./designs/$(PLATFORM)/$(DESIGN_NAME)/jpeg_encoder15_7nm.sdc
export ABC_AREA               = 1

export CORE_UTILIZATION       = 30
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY          = 0.60

export DFF_LIB_FILE           = $($(CORNER)_DFF_LIB_FILE)
