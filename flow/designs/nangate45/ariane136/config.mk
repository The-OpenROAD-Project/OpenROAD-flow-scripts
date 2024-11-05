export DESIGN_NAME = ariane
export DESIGN_NICKNAME = ariane136
export PLATFORM    = nangate45

export SYNTH_HIERARCHICAL = 1

# RTL_MP Settings
export RTLMP_MAX_INST = 30000
export RTLMP_MIN_INST = 5000
export RTLMP_MAX_MACRO = 16
export RTLMP_MIN_MACRO = 4
export RTLMP_SIGNATURE_NET_THRESHOLD = 30

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ariane.sv2v.v \
                       $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/macros.v

export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export ADDITIONAL_LEFS = $(PLATFORM_DIR)/lef/fakeram45_256x16.lef

export ADDITIONAL_LIBS = $(PLATFORM_DIR)/lib/fakeram45_256x16.lib

export DIE_AREA    = 0 0 1500 1500
export CORE_AREA   = 10 12 1448 1448

export PLACE_PINS_ARGS = -exclude left:0-500 -exclude left:1000-1500: -exclude right:* -exclude top:* -exclude bottom:*

export MACRO_PLACE_HALO = 10 10
export MACRO_PLACE_CHANNEL = 20 20
export TNS_END_PERCENT = 100
