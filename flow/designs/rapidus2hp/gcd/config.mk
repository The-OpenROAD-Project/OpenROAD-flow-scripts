export DESIGN_NICKNAME = gcd
export DESIGN_NAME = gcd
export PLATFORM    = rapidus2hp

ifeq ($(FLOW_VARIANT), verific)
	export SYNTH_HDL_FRONTEND = verific
endif

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NAME)/gcd.v
export SDC_FILE    = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

# Use $(if) to defer conditional eval until all makefiles are read
#
# | PDK  | Place Site | Utilization |
# | ---- | ---------- | ----------- |
# | 0.2  |     6T     |      43     |
# | 0.2  |     8T     |      45     |
# | 0.2a |     6T     |      43     |
# | 0.2a |     8T     |      45     |
# | 0.15 |     6T     |      38     |
# | 0.15 |     8T     |      40     |
#
export CORE_UTILIZATION = $(strip $(if $(filter 0.15,$(RAPIDUS_PDK_VERSION)), \
	$(if $(filter ra02h138_DST_45CPP,$(PLACE_SITE)), \
		36, \
		40), \
	$(if $(filter ra02h138_DST_45CPP SC6T,$(PLACE_SITE)), \
		43, \
		45)))

export CORE_MARGIN = .5
export PLACE_DENSITY = 0.42
