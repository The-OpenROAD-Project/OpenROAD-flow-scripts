export DESIGN_NAME = swerv_wrapper
export PLATFORM    = nangate45

export VERILOG_FILES = $(DESIGN_HOME)/src/swerv/swerv_wrapper.sv2v.v \
                       $(DESIGN_HOME)/$(PLATFORM)/swerv/macros.v
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/swerv_wrapper/constraint.sdc

export ADDITIONAL_LEFS = $(PLATFORM_DIR)/lef/fakeram45_2048x39.lef \
                         $(PLATFORM_DIR)/lef/fakeram45_256x34.lef \
                         $(PLATFORM_DIR)/lef/fakeram45_64x21.lef
export ADDITIONAL_LIBS = $(PLATFORM_DIR)/lib/fakeram45_2048x39.lib \
                         $(PLATFORM_DIR)/lib/fakeram45_256x34.lib \
                         $(PLATFORM_DIR)/lib/fakeram45_64x21.lib

export DIE_AREA    = 0 0 1100 1000
export CORE_AREA   = 10.07 11.2 1090 990 

export IO_CONSTRAINTS = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/io.tcl

export MACRO_PLACE_HALO = 10 10

export PLACE_DENSITY_LB_ADDON = 0.08
export TNS_END_PERCENT        = 100

export FASTROUTE_TCL = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/fastroute.tcl
