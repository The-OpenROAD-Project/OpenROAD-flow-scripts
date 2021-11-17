export PLATFORM               = asap7
export CORNER                ?= BC

export DESIGN_NAME            = sha3
export DESIGN_NICKNAME        = $(DESIGN_NAME)

export VERILOG_FILES = $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export PLACE_DENSITY          = 0.60

ifdef ($(ASAP7_USE4X)) 
  export DIE_AREA               = 0 0 30 30
  export CORE_AREA              = 0.5 0.5 29.5 29.5
else
  export DIE_AREA               = 0 0 90 90
  export CORE_AREA              = 5.08 5.08 80 80
endif

export DFF_LIB_FILE           = $($(CORNER)_DFF_LIB_FILE)
