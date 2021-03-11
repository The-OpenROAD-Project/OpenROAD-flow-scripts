
DESIGN_PDK_HOME              := $(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

export PLATFORM               = asap7
export DESIGN_PDK_HOME

export CORNER                ?= BC

export PLACE_DENSITY          = 0.30

export PDN_CFG                = $(FOUNDRY_DIR)/openRoad/pdn/grid_strategy-M2-M4-M7.cfg

# These values must be multiples of placement site
# # x=0.19 y=1.4
export DIE_AREA    = 0 0 200 200
export CORE_AREA   = 2 2 198 198

export DONT_USE_SC_LIB         = $(OBJECTS_DIR)/lib/merged.lib

ifeq ($(USE_4X),1)
  $(eval $(call use_4x))

  export DIE_AREA    = 0 0 800 800
  export CORE_AREA   = 4 4 796 796
endif

