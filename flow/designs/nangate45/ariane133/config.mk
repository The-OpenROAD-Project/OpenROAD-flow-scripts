export DESIGN_NAME = ariane
export DESIGN_NICKNAME = ariane133
export PLATFORM    = nangate45

export SYNTH_HIERARCHICAL = 1

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ariane.sv2v.v \
                       $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/macros.v

export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/ariane133/ariane.sdc

export ADDITIONAL_LEFS = $(PLATFORM_DIR)/lef/fakeram45_256x16.lef
export ADDITIONAL_LIBS = $(PLATFORM_DIR)/lib/fakeram45_256x16.lib

export CORE_UTILIZATION = 60
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN = 5

export IO_CONSTRAINTS = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/io.tcl

export MACRO_PLACE_HALO    = 10 10

export SKIP_GATE_CLONING   = 1

export RTLMP_MAX_LEVEL = 1
export RTLMP_MAX_MACRO = 10
export RTLMP_MIN_MACRO = 1
export RTLMP_MAX_INST = 80000
export RTLMP_MIN_INST = 8000
