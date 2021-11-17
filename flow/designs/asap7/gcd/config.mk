export PLATFORM               = asap7

export CORNER                ?= BC
export DESIGN_NAME            = gcd
export DESIGN_NICKNAME        = $(DESIGN_NAME)

export VERILOG_FILES          = $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE               = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export PLACE_DENSITY          = 0.35


ifdef ($(ASAP7_USE4X)) 
  export DIE_AREA               = 0 0 50 50
  export CORE_AREA              = 0.5 0.5 49.5 49.5
else
  export DIE_AREA               = 0 0 16.2 16.2
  export CORE_AREA              = 1.08 1.08 15.12 15.12
endif
