export PLATFORM               = rapidus2hp

export DESIGN_NAME            = jpeg_encoder
export DESIGN_NICKNAME        = jpeg

ifeq ($(FLOW_VARIANT), verific)
	export SYNTH_HDL_FRONTEND = verific
endif

export VERILOG_FILES          = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/*.v))
export VERILOG_INCLUDE_DIRS   = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/include

DEFAULT_SDC_FILE  = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/jpeg_encoder15_7nm.sdc
_0P2A_8T_SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/jpeg_encoder15_0.2a_8T.sdc
_0P15_6T_SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/jpeg_encoder15_0.15_6T.sdc
_0P15_8T_SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/jpeg_encoder15_0.15_8T.sdc
_0P3_SDC_FILE     = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/jpeg_encoder15_0.3.sdc

# Use $(if) to defer conditional eval until all makefiles are read
export SDC_FILE = $(strip \
    $(if $(and $(filter 0.2a,$(RAPIDUS_PDK_VERSION)),$(filter ra02h184_HST_45CPP,$(PLACE_SITE))), \
        $(_0P2A_8T_SDC_FILE), \
        $(if $(filter 0.15,$(RAPIDUS_PDK_VERSION)), \
            $(if $(filter ra02h138_DST_45CPP,$(PLACE_SITE)), \
                $(_0P15_6T_SDC_FILE), \
                $(_0P15_8T_SDC_FILE) \
            ), \
            $(if $(filter 0.3,$(RAPIDUS_PDK_VERSION)), \
                $(_0P3_SDC_FILE), \
                $(DEFAULT_SDC_FILE) \
            ) \
        ) \
    ))

export ABC_AREA               = 1

export CORE_UTILIZATION       = 60
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 0.75
export PLACE_DENSITY          = 0.62

export TNS_END_PERCENT        = 100
