export DESIGN_NICKNAME = bp
export DESIGN_NAME = black_parrot
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

export ABC_AREA = 1

export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export ADDITIONAL_LEFS = $(sort $(wildcard ./designs/$(PLATFORM)/$(DESIGN_NAME)/*.lef))
export ADDITIONAL_LIBS = $(sort $(wildcard ./designs/$(PLATFORM)/$(DESIGN_NAME)/*.lib))


export DIE_AREA    = 0 0 1350 1300 
export CORE_AREA   = 10.07 11.2 1340 1290 

export PLACE_PINS_ARGS = -exclude left:* -exclude right:* -exclude top:* -exclude bottom:0-100 -exclude bottom:1200-1350

export PLACE_DENSITY_LB_ADDON = 0.05

export MACRO_PLACE_HALO = 10 10
export MACRO_PLACE_CHANNEL = 20 20
