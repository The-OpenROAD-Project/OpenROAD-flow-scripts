export PLATFORM               = rapidus2hp

export DESIGN_NICKNAME        = ibex
export DESIGN_NAME            = ibex_core

ifeq ($(FLOW_VARIANT), verific)
	export SYNTH_HDL_FRONTEND = verific
endif

export VERILOG_FILES = \
    $(DESIGN_HOME)/src/ibex_sv/ibex_pkg.sv \
    $(sort $(filter-out %/ibex_pkg.sv, $(wildcard $(DESIGN_HOME)/src/ibex_sv/*.sv))) \
    $(DESIGN_HOME)/src/ibex_sv/syn/rtl/prim_clock_gating.v

export VERILOG_INCLUDE_DIRS = \
    $(DESIGN_HOME)/src/ibex_sv/vendor/lowrisc_ip/prim/rtl/

export SYNTH_HDL_FRONTEND ?= slang


# if FLOW_VARIANT == pos_slack, use an SDC file that has a larger clock
# resulting in positive slack
ifeq ($(FLOW_VARIANT),pos_slack)
export SDC_FILE              = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint_pos_slack.sdc
else
  DEFAULT_SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
  _0P2A_6T_SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint_0.2a_6T.sdc
  _0P2A_8T_SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint_0.2a_8T.sdc
  _0P15_SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint_0.15.sdc
  _0P3_6T_SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint_0.3_6T.sdc
  _0P3_8T_SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint_0.3_8T.sdc

  # Use $(if) to defer conditional eval until all makefiles are read
  export SDC_FILE = $(strip \
    $(if $(filter 0.2a,$(RAPIDUS_PDK_VERSION)), \
	$(if $(filter ra02h138_DST_45CPP,$(PLACE_SITE)), \
	    $(_0P2A_6T_SDC_FILE), \
	    $(_0P2A_8T_SDC_FILE) \
        ), \
        $(if $(filter 0.15,$(RAPIDUS_PDK_VERSION)), \
            $(_0P15_SDC_FILE), \
            $(if $(filter 0.3,$(RAPIDUS_PDK_VERSION)), \
	        $(if $(filter ra02h138_DST_45CPP,$(PLACE_SITE)), \
	            $(_0P3_6T_SDC_FILE), \
	            $(_0P3_8T_SDC_FILE) \
                ), \
                $(DEFAULT_SDC_FILE) \
            ) \
        ) \
    ))
endif

export CORE_UTILIZATION = $(strip \
    $(if $(filter 0.15,$(RAPIDUS_PDK_VERSION)), \
        $(if $(filter ra02h138_DST_45CPP,$(PLACE_SITE)), \
	    52, \
	    65 \
        ), \
        $(if $(filter 0.3,$(RAPIDUS_PDK_VERSION)), \
            $(if $(filter ra02h138_DST_45CPP,$(PLACE_SITE)), \
		60, \
		65 \
            ), \
	    70 \
        ) \
    ))

export CORE_ASPECT_RATIO       = 1
export CORE_MARGIN             = 0.75
export PLACE_DENSITY_LB_ADDON  = 0.20

export ENABLE_DPO              = 0

export TNS_END_PERCENT         = 100
