$(info [INFO-FLOW] UART Design)

export PLATFORM               = asap7
export CORNER                ?= BC

export DESIGN_NAME            = uart
export DESIGN_NICKNAME        = uart

export VERILOG_FILES          = $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE               = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export PLACE_DENSITY          = 0.70


ifdef ($(ASAP7_USE4X)) 
  export DIE_AREA               = 0 0 30 30
  export CORE_AREA              = 0.5 0.5 29.5 29.5
else
  export DIE_AREA               = 0 0 15 15
  export CORE_AREA              = 1.08 1.08 14 14
endif

#####Dont modify below lines
export LIB_FILES             += $($(CORNER)_LIB_FILES)
export LIB_DIRS              += $($(CORNER)_LIB_DIRS)
export TEMPERATURE            = $($(CORNER)_TEMPERATURE)

export DONT_USE_SC_LIB        = $(OBJECTS_DIR)/lib/merged.lib
#####
