export DESIGN_NAME = mempool_group
export DESIGN_NICKNAME = mempool_group
export PLATFORM    = nangate45

export SYNTH_HIERARCHICAL = 1
export RTLMP_FLOW ?= True

export TEMP_DESIGN_DIR = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)
export FLOORPLAN_DEF ?= ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/$(DESIGN_NAME)_fp.def
export VERILOG_FILES = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/$(DESIGN_NAME).v
export CACHED_NETLIST = $(TEMP_DESIGN_DIR)/$(DESIGN_NAME)_genus.v

export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/$(DESIGN_NAME).sdc

export ADDITIONAL_LEFS = $(PLATFORM_DIR)/lef/fakeram45_256x32.lef \
                         $(PLATFORM_DIR)/lef/fakeram45_64x64.lef \
                         $(PLATFORM_DIR)/lef/fakeram45_128x32.lef \
                         $(PLATFORM_DIR)/lef/fakeram45_128x256.lef

export ADDITIONAL_LIBS = $(PLATFORM_DIR)/lib/fakeram45_256x32.lib \
                         $(PLATFORM_DIR)/lib/fakeram45_128x32.lib \
                         $(PLATFORM_DIR)/lib/fakeram45_64x64.lib \
                         $(PLATFORM_DIR)/lib/fakeram45_128x256.lib

export DIE_AREA    = 0 0 4400 4400
export CORE_AREA   = 10 12 4390 4390

export PLACE_PINS_ARGS = -exclude left:* -exclude right:* -exclude top:* -exclude bottom:0-1000 -exclude bottom:3400-4400

export MACRO_PLACE_HALO = 10 10
export MACRO_PLACE_CHANNEL = 20 20
