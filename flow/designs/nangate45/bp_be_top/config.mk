export DESIGN_NICKNAME = bp_be
export DESIGN_NAME = bp_be_top
export PLATFORM    = nangate45

export SYNTH_HIERARCHICAL = 1

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NAME)/pickled.v \
                       $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/macros.v
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export ADDITIONAL_LEFS = $(PLATFORM_DIR)/lef/fakeram45_512x64.lef \
                         $(PLATFORM_DIR)/lef/fakeram45_64x15.lef \
                         $(PLATFORM_DIR)/lef/fakeram45_64x96.lef
export ADDITIONAL_LIBS = $(PLATFORM_DIR)/lib/fakeram45_512x64.lib \
                         $(PLATFORM_DIR)/lib/fakeram45_64x15.lib \
                         $(PLATFORM_DIR)/lib/fakeram45_64x96.lib

export DIE_AREA    = 0 0 800 700 
export CORE_AREA   = 10.07 11.2 790 690 

export IO_CONSTRAINTS = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/io.tcl

export MACRO_PLACE_HALO = 10 10

export PLACE_DENSITY_LB_ADDON = 0.10
export TNS_END_PERCENT        = 100

export CTS_CLUSTER_SIZE = 30
export CTS_CLUSTER_DIAMETER = 50
export SYNTH_MINIMUM_KEEP_SIZE = 3000

export FASTROUTE_TCL = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/fastroute.tcl
