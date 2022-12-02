export DESIGN_NICKNAME = bp_fe
export DESIGN_NAME = bp_fe_top
export PLATFORM    = nangate45

export SYNTH_HIERARCHICAL = 1
export RTLMP_FLOW = True
#
# RTL_MP Settings
export RTLMP_MAX_INST = 20000
export RTLMP_MIN_INST = 5000
export RTLMP_MAX_MACRO = 12
export RTLMP_MIN_MACRO = 4 

export VERILOG_FILES = ./designs/src/$(DESIGN_NAME)/pickled.v \
                       ./designs/$(PLATFORM)/$(DESIGN_NAME)/macros.v
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export ADDITIONAL_LEFS = $(sort $(wildcard ./designs/$(PLATFORM)/$(DESIGN_NAME)/*.lef))
export ADDITIONAL_LIBS = $(sort $(wildcard ./designs/$(PLATFORM)/$(DESIGN_NAME)/*.lib))


# These values must be multiples of placement site
# x=0.19 y=1.4
export DIE_AREA    = 0 0 899.97 699.4
export CORE_AREA   = 10.07 9.8 889.9 689.6

export MACRO_PLACE_HALO = 5 5
export MACRO_PLACE_CHANNEL = 10 10


export PLACE_DENSITY = 0.14
export PLACE_DENSITY_MAX_POST_HOLD = 0.12
