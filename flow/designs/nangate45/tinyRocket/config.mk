export DESIGN_NAME = tinyRocket
export DESIGN_TOP_NAME = RocketTile
export PLATFORM    = nangate45

export VERILOG_FILES = ./designs/src/$(DESIGN_NAME)/AsyncResetReg.v \
                       ./designs/src/$(DESIGN_NAME)/ClockDivider2.v \
                       ./designs/src/$(DESIGN_NAME)/ClockDivider3.v \
                       ./designs/src/$(DESIGN_NAME)/plusarg_reader.v \
                       ./designs/src/$(DESIGN_NAME)/freechips.rocketchip.system.TinyConfig.v \
                       ./designs/$(PLATFORM)/$(DESIGN_NAME)/freechips.rocketchip.system.TinyConfig.v

export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export ADDITIONAL_LEFS = $(sort $(wildcard ./designs/$(PLATFORM)/$(DESIGN_NAME)/*.lef))
export ADDITIONAL_LIBS = $(sort $(wildcard ./designs/$(PLATFORM)/$(DESIGN_NAME)/*.lib))


# These values must be multiples of placement site
# x=0.19 y=1.4
export DIE_AREA    = 0 0 924.92 799.4
export CORE_AREA   = 10.07 9.8 914.85 789.6

