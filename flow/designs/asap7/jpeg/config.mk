$(info [INFO-FLOW] JPEG Design)

export PLATFORM               = asap7
export CORNER                ?= BC

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

#####Dont modify below lines
export LIB_FILES             += $($(CORNER)_LIB_FILES)
export DFF_LIB_FILE           = $($(CORNER)_DFF_LIB_FILE)
export LIB_DIRS              += $($(CORNER)_LIB_DIRS)
#export DB_FILES              += $($(CORNER)_DB_FILES)
#export DB_DIRS               += $($(CORNER)_DB_DIRS)
#export WRAP_LIBS             += $(WRAP_$(CORNER)_LIBS)
#export WRAP_LEFS             += $(WRAP_$(CORNER)_LEFS)
export TEMPERATURE            = $($(CORNER)_TEMPERATURE)

export DONT_USE_SC_LIB        = $(OBJECTS_DIR)/lib/merged.lib
######
