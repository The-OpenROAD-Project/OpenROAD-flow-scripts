export PLATFORM               = asap7

export DESIGN_NAME            = MegaBoom
export DESIGN_NICKNAME        = megaboom

export VERILOG_FILES          = $(realpath ./designs/src/$(DESIGN_NICKNAME)/rocketchip.MegaBoomConfig.v.gz)
export VERILOG_FILES         += $(realpath ./designs/src/$(DESIGN_NICKNAME)/rocketchip.MegaBoomConfig.behav_srams.v)

export SDC_FILE               = $(realpath ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc)
export SYNTH_SDC_FILE         = $(SDC_FILE)

export PLACE_DENSITY_LB_ADDON = 0.05

export IO_CONSTRAINTS         = $(dir $(DESIGN_CONFIG))/io.tcl
export MACRO_PLACEMENT_TCL    = $(dir $(DESIGN_CONFIG))/macro-placement.tcl

export PDN_TCL                = $(dir $(DESIGN_CONFIG))/pdn.tcl

export CORE_AREA              = 2.5 2.5 1397.5 1397.5
export DIE_AREA               = 0 0 1400 1400

export BC_ADDITIONAL_LIBS    += $(PLATFORM_DIR)/lib/fakeram_256x128.lib \
                                $(PLATFORM_DIR)/lib/fakeram_256x64.lib \
                                $(PLATFORM_DIR)/lib/fakeram_32x46.lib \
                                $(PLATFORM_DIR)/lib/fakeram_512x8.lib \
                                $(PLATFORM_DIR)/lib/fakeram_64x20.lib \
                                $(PLATFORM_DIR)/lib/fakeram_64x22.lib \
                                $(PLATFORM_DIR)/lib/fakeregfile_32x46.lib \
                                $(PLATFORM_DIR)/lib/fakeregfile_64x64.lib \
                                $(PLATFORM_DIR)/lib/fakeregfile_128x64.lib 

export ADDITIONAL_LEFS       += $(PLATFORM_DIR)/lef/fakeram_256x128.lef \
                                $(PLATFORM_DIR)/lef/fakeram_256x64.lef \
                                $(PLATFORM_DIR)/lef/fakeram_32x46.lef \
                                $(PLATFORM_DIR)/lef/fakeram_512x8.lef \
                                $(PLATFORM_DIR)/lef/fakeram_64x20.lef \
                                $(PLATFORM_DIR)/lef/fakeram_64x22.lef \
                                $(PLATFORM_DIR)/lef/fakeregfile_32x46.lef \
                                $(PLATFORM_DIR)/lef/fakeregfile_64x64.lef \
                                $(PLATFORM_DIR)/lef/fakeregfile_128x64.lef 


#export CACHED_NETLIST         = $(realpath ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/MegaBoom.v)

export SYNTH_ARGS=-noshare


export MIN_ROUTING_LAYER = M2
export MAX_ROUTING_LAYER = M9
