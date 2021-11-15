$(info [INFO-FLOW] IBEX Design)

export PLATFORM               = asap7
export CORNER                ?= BC

export DESIGN_NICKNAME        = ibex
export DESIGN_NAME            = ibex_core


export VERILOG_FILES         = $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE              = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export CORE_UTILIZATION       = 25 
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

export DONT_USE_SC_LIB         = $(OBJECTS_DIR)/lib/merged.lib
#####
