$(info [INFO-FLOW] GCD Design)
DESIGN_DIR                   := $(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))
DESIGN_PDK_HOME              := $(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

export DESIGN_NAME            = gcd
export DESIGN_NICKNAME        = gcd
export DESIGN                 = gcd

export PLATFORM               = intel22

export VERILOG_FILES          = $(sort $(wildcard $(abspath $(DESIGN_HOME)/src/$(DESIGN))/*.v))
export SDC_FILE               = $(DESIGN_DIR)/constraint.sdc

export PLACE_DENSITY          = 0.35

export DIE_AREA               = 0 0 50 50
export CORE_AREA              = 1.26 1.89 49 49
