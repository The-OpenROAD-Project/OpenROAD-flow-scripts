DESIGN_PDK_HOME              := $(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

export DESIGN_PDK_HOME

export CORNER                ?= TC

export LIB_FILES             += $($(CORNER)_LIB_FILES)
export DB_FILES              += $($(CORNER)_DB_FILES)
export WRAP_LIBS             += $(WRAP_$(CORNER)_LIBS)
export TEMPERATURE            = $($(CORNER)_TEMPERATURE)

export PLACE_DENSITY          = 0.30

export PDN_CFG                = $(FOUNDRY_DIR)/openROAD/pdn/grid_strategy-M1-M2-M7.cfg

# These values must be multiples of placement site
# # x=0.19 y=1.4
export DIE_AREA    = 0 0 620.15 620.6
export CORE_AREA   = 10.07 11.2 610.27 610.8
