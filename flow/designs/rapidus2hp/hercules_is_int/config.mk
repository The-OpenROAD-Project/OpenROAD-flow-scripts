export PLATFORM               = rapidus2hp

export DESIGN_NAME            = hercules_is_int

export SRC_HOME = /platforms/Rapidus/designs/hercules_is_int

ifeq ($(FLOW_VARIANT), gatelevel)
  export SYNTH_NETLIST_FILES  = $(SRC_HOME)/ca78_8t_postroute_0707.v
endif

ifeq ($(FLOW_VARIANT), verific)
	export SYNTH_HDL_FRONTEND = verific
endif

export VERILOG_FILES          = $(sort $(wildcard $(SRC_HOME)/hercules_issue/verilog/*.sv)) \
	$(sort $(wildcard $(SRC_HOME)/shared/verilog/*.sv)) \
	$(sort $(wildcard $(SRC_HOME)/models/cells/generic/*.sv))

export VERILOG_INCLUDE_DIRS   = $(SRC_HOME)/hercules_issue/verilog \
	$(SRC_HOME)/shared/verilog \
	$(SRC_HOME)/models/cells/generic

export SDC_FILE               = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/prects.sdc

# Must be defined before the ifeq's
export SYNTH_HDL_FRONTEND    ?= slang
export SYNTH_HIERARCHICAL    ?= 0

# Use $(if) to defer conditional eval until all makefiles are read
export CORE_UTILIZATION = $(strip \
    $(if $(filter 0.3,$(RAPIDUS_PDK_VERSION)), \
        $(if $(filter ra02h138_DST_45CPP,$(PLACE_SITE)), \
            $(if $(filter slang,$(SYNTH_HDL_FRONTEND)), \
                $(if $(filter 14LM,$(LAYER_STACK_OPTION)), \
                    52, \
                    $(if $(filter 16LM,$(LAYER_STACK_OPTION)), \
                        54, \
                        56 \
                    ) \
                ), \
                $(if $(filter 14LM,$(LAYER_STACK_OPTION)), \
                    50, \
                    56 \
                ) \
            ), \
            56 \
        ), \
        $(if $(filter 0.15,$(RAPIDUS_PDK_VERSION)), \
            $(if $(filter ra02h138_DST_45CPP SC6T,$(PLACE_SITE)), \
                30, \
                52 \
            ), \
            $(if $(filter slang,$(SYNTH_HDL_FRONTEND)), \
                $(if $(filter ra02h138_DST_45CPP SC6T,$(PLACE_SITE)), \
                    30, \
                    52 \
                ), \
	        $(if $(filter ra02h138_DST_45CPP SC6T,$(PLACE_SITE)), \
                    30, \
                    54 \
                ) \
            ) \
        ) \
    ))

export CORE_MARGIN            = 1
export PLACE_DENSITY          = 0.58

export PLACE_PINS_ARGS = -min_distance_in_tracks -min_distance 1
export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 0
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 0
# temporarily skip over DPO to bypass one-site gap issues
export ENABLE_DPO = 0

# Selectively keep module hierarchies to match baseline data
# ifeq ($(SYNTH_HDL_FRONTEND), verific)
#   export SYNTH_KEEP_MODULES = \hercules_is_grbt \
# 	 \hercules_is_grf \
# 	 \hercules_is_lsq \
# 	 \hercules_is_lsq2 \
# 	 \hercules_is_mx0(HERCULES_IQ_DATA_GATING=0)\
# 	 \hercules_is_mx1(HERCULES_IQ_DATA_GATING=0) \
# 	 \hercules_is_pcrf \
# 	 \hercules_is_resc_ix \
# 	 \hercules_is_resc_ls \
# 	 \hercules_is_sxq
# else
#   export SYNTH_KEEP_MODULES = \hercules_is_grbt$$hercules_is_int.u_grbt \
# 	\\hercules_is_grf$$hercules_is_int.u_grf \
# 	\\hercules_is_lsq$$hercules_is_int.u_ls0_iq \
# 	\\hercules_is_lsq$$hercules_is_int.u_ls1_iq \
# 	\\hercules_is_lsq2$$hercules_is_int.u_ls2_iq \
# 	\\hercules_is_mx0$$hercules_is_int.u_mx0_iq \
# 	\\hercules_is_mx1$$hercules_is_int.u_mx1_iq \
# 	\\hercules_is_pcrf$$hercules_is_int.u_pcrf \
# 	\\hercules_is_resc_ix$$hercules_is_int.u_grcx \
# 	\\hercules_is_resc_ls$$hercules_is_int.u_grcl \
# 	\\hercules_is_sxq$$hercules_is_int.u_sx0_iq \
# 	\\hercules_is_sxq$$hercules_is_int.u_sx1_iq
# endif
