export PLATFORM               = rapidus2hp

export DESIGN_NAME            = ethmac

ifeq ($(FLOW_VARIANT), verific)
	export SYNTH_HDL_FRONTEND = verific
endif

export SRC_HOME               = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)
export VERILOG_INCLUDE_DIRS   = $(SRC_HOME)
export VERILOG_FILES          = $(sort $(wildcard $(SRC_HOME)/*.v))
export SDC_FILE               = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
export ABC_AREA               = 1

export CORE_UTILIZATION = $(strip \
    $(if $(filter 0.15,$(RAPIDUS_PDK_VERSION)), \
	$(if $(filter ra02h138_DST_45CPP,$(PLACE_SITE)), \
		63, \
		65), \
        $(if $(filter 0.3,$(RAPIDUS_PDK_VERSION)), \
	    65, \
            70) \
    ))

export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 0.75
export PLACE_DENSITY          = 0.70
