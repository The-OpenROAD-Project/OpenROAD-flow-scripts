export PLATFORM               = asap7

export DESIGN_NAME            = ethmac
export DESIGN_NICKNAME        = ethmac_lvt

export VERILOG_FILES         = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE              = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
export ABC_AREA               = 1

export CORE_UTILIZATION       = 40
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY          = 0.60

export ASAP7_USELVT           = 1
export ADDITIONAL_LIBS        = $(LIB_DIR)/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz \
                                $(LIB_DIR)/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz \
			        $(LIB_DIR)/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz \
			        $(LIB_DIR)/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz \
			        $(LIB_DIR)/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib 

export ADDITIONAL_GDS         = $(PLATFORM_DIR)/gds/asap7sc7p5t_28_R_220121a.gds
export ADDITIONAL_LEFS        = $(PLATFORM_DIR)/lef/asap7sc7p5t_28_R_1x_220121a.lef
export RECOVER_POWER          = 1
