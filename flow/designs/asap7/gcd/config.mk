$(info [INFO-FLOW] GCD Design)

DESIGN_DIR                   := $(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))
DESIGN_PDK_HOME              := $(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

export DESIGN_NAME            = gcd
export DESIGN_NICKNAME        = gcd
export DESIGN                 = gcd

export VERILOG_FILES          = $(sort $(wildcard $(abspath $(DESIGN_DIR)/../../src/$(DESIGN))/*.v))
export SDC_FILE               = $(DESIGN_DIR)/constraint.sdc

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

export PLATFORM               = asap7
export DESIGN_PDK_HOME

export CORNER                ?= BC

export PLACE_DENSITY          = 0.30

export PDN_CFG                = $(FOUNDRY_DIR)/openRoad/pdn/grid_strategy-M2-M5-M7.cfg

export DONT_USE_SC_LIB        = $(OBJECTS_DIR)/lib/merged.lib

export CORE_UTILIZATION       = 20
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2

export DESIGN_DIR
