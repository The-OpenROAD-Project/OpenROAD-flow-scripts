export DESIGN_NICKNAME = gcd
export DESIGN_NAME = gcd
export PLATFORM    = rapidus2hp

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NAME)/gcd.v

ifeq ($(RAPIDUS_PDK_VERSION),)
  export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint_ps.sdc
else
  export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc
endif

export CORE_UTILIZATION = 45
export CORE_MARGIN = .5
export PLACE_DENSITY = 0.42
