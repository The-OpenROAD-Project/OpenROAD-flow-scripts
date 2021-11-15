$(info [INFO-FLOW] AES Design)

export PLATFORM               = asap7

#User can modify below variables as per design requirement
export CORNER                ?= BC

export DESIGN_NAME            = aes_cipher_top
export DESIGN_NICKNAME        = aes

export VERILOG_FILES = $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export ABC_AREA               = 1

#Floorplaning and placement variables for relative die size
export CORE_UTILIZATION       = 30
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY          = 0.60

ifeq ($(USE_4X),1)
  $(eval $(call use_4x))

  export DIE_AREA    = 0 0 800 800
  export CORE_AREA   = 4 4 796 796
endif
#####Dont modify below lines######
export LIB_FILES             += $($(CORNER)_LIB_FILES)
export LIB_DIRS              += $($(CORNER)_LIB_DIRS)
#export DB_FILES              += $($(CORNER)_DB_FILES)
#export DB_DIRS               += $($(CORNER)_DB_DIRS)
##export WRAP_LIBS             += $(WRAP_$(CORNER)_LIBS)
##export WRAP_LEFS             += $(WRAP_$(CORNER)_LEFS)
#export TEMPERATURE            = $($(CORNER)_TEMPERATURE)

export DONT_USE_SC_LIB         = $(OBJECTS_DIR)/lib/merged.lib
#####
