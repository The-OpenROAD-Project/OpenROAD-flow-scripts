export DESIGN_NAME = swerv_wrapper
export PLATFORM    = asap7

export SYNTH_HIERARCHICAL = 1
# RTL_MP Settings
export RTLMP_MAX_INST = 30000
export RTLMP_MIN_INST = 5000
export RTLMP_MAX_MACRO = 30
export RTLMP_MIN_MACRO = 4 

export LIB_MODEL = CCS

export VERILOG_FILES = $(DESIGN_HOME)/src/swerv/swerv_wrapper.sv2v.v \
                       $(DESIGN_HOME)/$(PLATFORM)/swerv_wrapper/macros.v
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/swerv_wrapper/constraint.sdc

export ADDITIONAL_LEFS = $(sort $(wildcard $(DESIGN_HOME)/$(PLATFORM)/swerv_wrapper/lef/*.lef))
export ADDITIONAL_LIBS = $(sort $(wildcard $(DESIGN_HOME)/$(PLATFORM)/swerv_wrapper/lib/*.lib))

export DIE_AREA    = 0 0 550 600
export CORE_AREA   = 5 5 545 595 

export PLACE_PINS_ARGS = -exclude left:* -exclude right:* 
export PLACE_DENSITY_LB_ADDON = 0.20

export ROUTING_LAYER_ADJUSTMENT = 0.2
