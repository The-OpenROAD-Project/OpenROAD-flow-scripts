export DESIGN_NAME = bsg_chip
export DESIGN_NICKNAME = bp_quad
export PLATFORM    = nangate45

export SYNTH_HIERARCHICAL = 1
export RTLMP_FLOW = True

# RTL_MP Settings
export RTLMP_MAX_INST = 30000
export RTLMP_MIN_INST = 5000
export RTLMP_MAX_MACRO = 16
export RTLMP_MIN_MACRO = 4

export VERILOG_FILES = ./designs/src/$(DESIGN_NICKNAME)/bsg_chip_block.sv2v.v \
                       ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/macros.v

export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/bsg_chip.sdc

export ADDITIONAL_LEFS = $(PLATFORM_DIR)/lef/fakeram45_256x48.lef \
                         $(PLATFORM_DIR)/lef/fakeram45_32x32.lef \
                         $(PLATFORM_DIR)/lef/fakeram45_64x124.lef \
                         $(PLATFORM_DIR)/lef/fakeram45_512x64.lef \
                         $(PLATFORM_DIR)/lef/fakeram45_64x62.lef \
                         $(PLATFORM_DIR)/lef/fakeram45_128x116.lef

export ADDITIONAL_LIBS = $(PLATFORM_DIR)/lib/fakeram45_256x48.lib \
                         $(PLATFORM_DIR)/lib/fakeram45_32x32.lib \
                         $(PLATFORM_DIR)/lib/fakeram45_64x124.lib \
                         $(PLATFORM_DIR)/lib/fakeram45_512x64.lib \
                         $(PLATFORM_DIR)/lib/fakeram45_64x62.lib \
                         $(PLATFORM_DIR)/lib/fakeram45_128x116.lib

export DIE_AREA    = 0 0 1500 1500
export CORE_AREA   = 10 12 1448 1448

export PLACE_PINS_ARGS = -exclude left:0-500 -exclude left:1000-1500: -exclude right:* -exclude top:* -exclude bottom:*

export MACRO_PLACE_HALO = 10 10
export MACRO_PLACE_CHANNEL = 20 20
