export DESIGN_NICKNAME = bp_fe
export DESIGN_NAME = bp_fe_top
export PLATFORM    = sky130hd

export VERILOG_FILES = ./designs/src/$(DESIGN_NAME)/pickled.v \
                       ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/macros.v
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export ADDITIONAL_LEFS = $(sort $(wildcard ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/*.lef))
export ADDITIONAL_LIBS = $(sort $(wildcard ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/*.lib))


# These values must be multiples of placement site
# x=0.19 y=1.4
export DIE_AREA    = 0 0 11400 8400
export CORE_AREA   = 152 112 11020 8120


export PLACE_DENSITY = 0.39
export PLACE_DENSITY_MAX_POST_HOLD = 0.39
