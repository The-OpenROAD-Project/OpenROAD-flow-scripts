export DESIGN_NICKNAME = gcd
export DESIGN_NAME = gcd
export PLATFORM    = rapidus2hp

ifeq ($(FLOW_VARIANT), verific)
	export SYNTH_HDL_FRONTEND = verific
endif

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NAME)/gcd.v
export SDC_FILE    = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc


# Use $(if) to defer conditional eval until all makefiles are read
export CORE_UTILIZATION = $(strip $(if $(filter ra02h138_DST_45CPP SC6T,$(PLACE_SITE)), \
	43, \
	45))

export CORE_MARGIN = .5
export PLACE_DENSITY = 0.42
