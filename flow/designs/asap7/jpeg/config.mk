export PLATFORM               = asap7

export DESIGN_NAME            = jpeg_encoder
export DESIGN_NICKNAME        = jpeg

export VERILOG_FILES          = $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v))
export VERILOG_INCLUDE_DIRS   = ./designs/src/$(DESIGN_NICKNAME)/include
export SDC_FILE               = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/jpeg_encoder15_7nm.sdc
export ABC_AREA               = 1

export CORE_UTILIZATION       = 30
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY          = 0.60

export DFF_LIB_FILE           = $($(CORNER)_DFF_LIB_FILE)

export TNS_END_PERCENT        = 100
export EQUIVALENCE_CHECK     ?=   1
export REMOVE_CELLS_FOR_EQY   = TAPCELL*
