$(info [INFO-FLOW] AES Design)

DESIGN_DIR                   := $(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))
DESIGN_PDK_HOME              := $(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

export DESIGN_NAME            = aes_cipher_top
export DESIGN_NICKNAME        = aes
export DESIGN                 = aes

export VERILOG_FILES          = $(sort $(wildcard $(abspath $(DESIGN_DIR)/../../src/$(DESIGN))/*.v))
export SDC_FILE               = $(DESIGN_DIR)/constraint.sdc
export ABC_AREA               = 1

export CORNER                ?= BC

export LIB_FILES             += $($(CORNER)_LIB_FILES)
export LIB_DIRS              += $($(CORNER)_LIB_DIRS)
export DB_FILES              += $($(CORNER)_DB_FILES)
export DB_DIRS               += $($(CORNER)_DB_DIRS)
export WRAP_LIBS             += $(WRAP_$(CORNER)_LIBS)
export WRAP_LEFS             += $(WRAP_$(CORNER)_LEFS)
export TEMPERATURE            = $($(CORNER)_TEMPERATURE)

export ABC_CLOCK_PERIOD_IN_PS = 400

export DESIGN_POWER           = VDD
export DESIGN_GROUND          = VSS

export DESIGN_DIR


export PLATFORM               = asap7
export DESIGN_PDK_HOME

export CORNER                ?= BC

export PDN_CFG                = $(FOUNDRY_DIR)/openRoad/pdn/grid_strategy-M2-M5-M7.cfg

export CORE_UTILIZATION       = 30
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY          = 0.60

export DONT_USE_SC_LIB         = $(OBJECTS_DIR)/lib/merged.lib

ifeq ($(USE_4X),1)
  $(eval $(call use_4x))

  export DIE_AREA    = 0 0 800 800
  export CORE_AREA   = 4 4 796 796
endif

