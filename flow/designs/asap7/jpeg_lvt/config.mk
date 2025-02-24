export PLATFORM               = asap7

export DESIGN_NAME            = jpeg_encoder
export DESIGN_NICKNAME        = jpeg_lvt

export VERILOG_FILES          = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/*.v))
export VERILOG_INCLUDE_DIRS   = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/include
export SDC_FILE               = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/jpeg_encoder15_7nm.sdc
export ABC_AREA               = 1

export ADDITIONAL_LIBS        = $(LIB_DIR)/asap7sc7p5t_AO_LVT_FF_nldm_211120.lib.gz \
                                 $(LIB_DIR)/asap7sc7p5t_INVBUF_LVT_FF_nldm_220122.lib.gz \
			         $(LIB_DIR)/asap7sc7p5t_OA_LVT_FF_nldm_211120.lib.gz \
			         $(LIB_DIR)/asap7sc7p5t_SIMPLE_LVT_FF_nldm_211120.lib.gz \
			         $(LIB_DIR)/asap7sc7p5t_SEQ_LVT_FF_nldm_220123.lib 

export ADDITIONAL_GDS  = $(PLATFORM_DIR)/gds/asap7sc7p5t_28_L_220121a.gds
export ADDITIONAL_LEFS  = $(PLATFORM_DIR)/lef/asap7sc7p5t_28_L_1x_220121a.lef

export CORE_UTILIZATION       = 30
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY          = 0.60

export TNS_END_PERCENT        = 100
export RECOVER_POWER          = 100

