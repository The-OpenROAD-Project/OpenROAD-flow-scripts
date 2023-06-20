export PLATFORM               = asap7

export DESIGN_NAME            = MegaBoom
export DESIGN_NICKNAME        = megaboom

export VERILOG_FILES          = $(realpath ./designs/src/$(DESIGN_NICKNAME)/rocketchip.MegaBoomConfig.v.gz)
export VERILOG_FILES         += $(realpath ./designs/src/$(DESIGN_NICKNAME)/rocketchip.MegaBoomConfig.behav_srams.v)

export SDC_FILE               = $(realpath ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc)
export SYNTH_SDC_FILE         = $(SDC_FILE)

export CORE_UTILIZATION       = 40
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 5
export PLACE_DENSITY_LB_ADDON = 0.05

export BC_ADDITIONAL_LIBS    += $(PLATFORM_DIR)/lib/fakeram_256x128.lib \
                                $(PLATFORM_DIR)/lib/fakeram_256x64.lib \
                                $(PLATFORM_DIR)/lib/fakeram_32x46.lib \
                                $(PLATFORM_DIR)/lib/fakeram_512x8.lib \
                                $(PLATFORM_DIR)/lib/fakeram_64x20.lib \
                                $(PLATFORM_DIR)/lib/fakeram_64x22.lib 

export ADDITIONAL_LEFS       += $(PLATFORM_DIR)/lef/fakeram_256x128.lef \
                                $(PLATFORM_DIR)/lef/fakeram_256x64.lef \
                                $(PLATFORM_DIR)/lef/fakeram_32x46.lef \
                                $(PLATFORM_DIR)/lef/fakeram_512x8.lef \
                                $(PLATFORM_DIR)/lef/fakeram_64x20.lef \
                                $(PLATFORM_DIR)/lef/fakeram_64x22.lef 


#export CACHED_NETLIST         = $(realpath ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/MegaBoom.v)
