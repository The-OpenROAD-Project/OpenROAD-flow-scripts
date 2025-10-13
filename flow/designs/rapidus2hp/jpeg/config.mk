export PLATFORM               = rapidus2hp

export DESIGN_NAME            = jpeg_encoder
export DESIGN_NICKNAME        = jpeg

export VERILOG_FILES          = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/*.v))
export VERILOG_INCLUDE_DIRS   = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/include
export SDC_FILE               = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/jpeg_encoder15_7nm.sdc
export ABC_AREA               = 1

export CORE_UTILIZATION       = 60
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 0.75
export PLACE_DENSITY          = 0.62

export TNS_END_PERCENT        = 100
