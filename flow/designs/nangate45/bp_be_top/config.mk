export DESIGN_NAME = bp_be
export DESIGN_TOP_NAME = bp_be_top
export PLATFORM    = nangate45

export VERILOG_FILES = ./designs/src/$(DESIGN_TOP_NAME)/pickled.v \
                       ./designs/$(PLATFORM)/$(DESIGN_TOP_NAME)/macros.v
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_TOP_NAME)/constraint.sdc

export ADDITIONAL_LEFS = $(sort $(wildcard ./designs/$(PLATFORM)/$(DESIGN_TOP_NAME)/*.lef))
export ADDITIONAL_LIBS = $(sort $(wildcard ./designs/$(PLATFORM)/$(DESIGN_TOP_NAME)/*.lib))


# These values must be multiples of placement site
# x=0.19 y=1.4
export DIE_AREA    = 0 0 1550.02 1342.6
export CORE_AREA   = 10.07 11.2 1540.14 1332.8

export PLACE_DENSITY = 0.15
