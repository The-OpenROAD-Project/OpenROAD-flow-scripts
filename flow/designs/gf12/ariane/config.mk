export DESIGN_NAME = ariane
export PLATFORM    = gf12

export SYNTH_HIERARCHICAL = 1
export SYNTH_MINIMUM_KEEP_SIZE ?= 10000
#

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NAME)/ariane.sv2v.v \
                       $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/macros.v

#export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint_hier.sdc

export WRAP_LEFS = $(PLATFORM_DIR)/lef/gf12lp_1rf_lg8_w64_byte.lef

export WRAP_LIBS = $(PLATFORM_DIR)/lib/gf12lp_1rf_lg8_w64_byte_sspg_sigcmax_0p72v_0p72v_125c.lib

export ADDITIONAL_GDS  = $(PLATFORM_DIR)/gds/gf12lp_1rf_lg8_w64_byte.gds2

export DIE_AREA    = 0 0 850 600
export CORE_AREA   = 5 5 745 595

export PLACE_DENSITY ?= 0.50

export IO_CONSTRAINTS  = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/io.tcl

export MACRO_PLACE_HALO = 7 7 
export MACRO_WRAPPERS = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/wrappers.tcl

ifeq ($(USE_FILL),1)
export DESIGN_TYPE = CELL
else
export DESIGN_TYPE = CELL_NODEN
endif

export REMOVE_ABC_BUFFERS = 1
