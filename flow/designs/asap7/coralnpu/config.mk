export PLATFORM                = asap7

export DESIGN_NICKNAME         = coralnpu
export DESIGN_NAME             = CoreMiniAxi

export VERILOG_FILES           = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/$(DESIGN_NAME).sv \
	$(PLATFORM_DIR)/verilog/fakeram_512x128.sv \
	$(PLATFORM_DIR)/verilog/fakeram_2048x128.sv

export VERILOG_DEFINES += -D USE_ASAP7

export ADDITIONAL_LEFS = $(PLATFORM_DIR)/lef/fakeram_512x128.lef \
			 $(PLATFORM_DIR)/lef/fakeram_2048x128.lef

export ADDITIONAL_LIBS += $(PLATFORM_DIR)/lib/NLDM/fakeram_512x128.lib \
			  $(PLATFORM_DIR)/lib/NLDM/fakeram_2048x128.lib

export SDC_FILE                = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export SYNTH_HDL_FRONTEND     ?= slang

export CORE_UTILIZATION        = 65

export SYNTH_HIERARCHICAL      = 1
export SYNTH_MINIMUM_KEEP_SIZE = 40000

export MACRO_PLACE_HALO = 2 2

