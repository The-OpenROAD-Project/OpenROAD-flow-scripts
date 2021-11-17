export PLATFORM               = asap7
export CORNER                ?= BC

export DESIGN_NAME            = uart
export DESIGN_NICKNAME        = $(DESIGN_NAME)

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
