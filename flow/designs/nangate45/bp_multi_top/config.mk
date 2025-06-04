export DESIGN_NICKNAME = bp_multi
export DESIGN_NAME = bp_multi_top
export PLATFORM    = nangate45

export SYNTH_HIERARCHICAL = 1
#

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NAME)/pickled.v \
                       $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/macros.v
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc
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
export IO_CONSTRAINTS = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/io.tcl

export MACRO_PLACE_HALO = 10 10

export PLACE_DENSITY_LB_ADDON = 0.05
export SKIP_GATE_CLONING      = 1
