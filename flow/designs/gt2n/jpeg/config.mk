export DESIGN_NICKNAME = jpeg
export DESIGN_NAME     = jpeg_encoder
export PLATFORM        = gt2n

export VERILOG_FILES        = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/*.v))
export VERILOG_INCLUDE_DIRS = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/include
export SDC_FILE             = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export ABC_AREA = 1

# Floorplan: jpeg_encoder is larger than aes; start conservative.
export CORE_UTILIZATION       = 40
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY_LB_ADDON = 0.20
export TNS_END_PERCENT        = 100
