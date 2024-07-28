export DESIGN_NICKNAME = bp_multi
export DESIGN_NAME = bp_multi_top
export PLATFORM    = nangate45

export SYNTH_HIERARCHICAL = 1
export RTLMP_FLOW = True
#
# RTL_MP Settings
export RTLMP_MAX_INST = 30000
export RTLMP_MIN_INST = 5000
export RTLMP_MAX_MACRO = 12
export RTLMP_MIN_MACRO = 4 

export VERILOG_FILES = ./designs/src/$(DESIGN_NAME)/pickled.v \
                       ./designs/$(PLATFORM)/$(DESIGN_NAME)/macros.v
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc
export ABC_AREA      = 1

export ADDITIONAL_LEFS = $(PLATFORM_DIR)/lef/fakeram45_512x64.lef \
                         $(PLATFORM_DIR)/lef/fakeram45_256x96.lef \
                         $(PLATFORM_DIR)/lef/fakeram45_32x64.lef \
                         $(PLATFORM_DIR)/lef/fakeram45_64x7.lef \
                         $(PLATFORM_DIR)/lef/fakeram45_64x15.lef \
                         $(PLATFORM_DIR)/lef/fakeram45_64x96.lef
export ADDITIONAL_LIBS = $(PLATFORM_DIR)/lib/fakeram45_512x64.lib \
                         $(PLATFORM_DIR)/lib/fakeram45_256x96.lib \
                         $(PLATFORM_DIR)/lib/fakeram45_32x64.lib \
                         $(PLATFORM_DIR)/lib/fakeram45_64x7.lib \
                         $(PLATFORM_DIR)/lib/fakeram45_64x15.lib \
                         $(PLATFORM_DIR)/lib/fakeram45_64x96.lib


export DIE_AREA    = 0 0 1100 1100 
export CORE_AREA   = 10.07 9.8 1090 1090
export PLACE_PINS_ARGS = -exclude left:100-1100 -exclude right:100-1100 -exclude top:*

export MACRO_PLACE_HALO = 10 10
export MACRO_PLACE_CHANNEL = 20 20

export PLACE_DENSITY_LB_ADDON = 0.05
export SKIP_GATE_CLONING      = 1
