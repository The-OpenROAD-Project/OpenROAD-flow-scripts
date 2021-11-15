$(info [INFO-FLOW] Ethernet Design)

export PLATFORM               = asap7
export CORNER                ?= BC

export DESIGN_NAME            = ethmac
export DESIGN_NICKNAME        = eth_top


export VERILOG_FILES         = $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE              = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
export ABC_AREA               = 1

export CORE_UTILIZATION       = 40
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY          = 0.60

#####Dont modify below lines
export LIB_FILES             += $($(CORNER)_LIB_FILES)
export LIB_DIRS              += $($(CORNER)_LIB_DIRS)
export TEMPERATURE            = $($(CORNER)_TEMPERATURE)
#Verilog file has Async Reset signals so included DFF_LIB
export DFF_LIB_FILE           = $($(CORNER)_DFF_LIB_FILE)

export DONT_USE_SC_LIB         = $(OBJECTS_DIR)/lib/merged.lib
#####
