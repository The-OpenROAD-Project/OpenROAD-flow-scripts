$(info [INFO-FLOW] GCD Design)

export PLATFORM               = asap7

export CORNER                ?= BC
export DESIGN_NAME            = gcd
export DESIGN_NICKNAME        = gcd

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

# Adders degrade GCD
export ADDER_MAP_FILE              :=
###Dont modify below paths
export LIB_FILES             += $($(CORNER)_LIB_FILES)
export LIB_DIRS              += $($(CORNER)_LIB_DIRS)
export TEMPERATURE            = $($(CORNER)_TEMPERATURE)

export DONT_USE_SC_LIB        = $(OBJECTS_DIR)/lib/merged.lib
######
