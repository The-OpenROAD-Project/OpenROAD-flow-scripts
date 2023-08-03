export DESIGN_NICKNAME = tinyRocket
export DESIGN_NAME = RocketTile
export PLATFORM    = nangate45

export SYNTH_HIERARCHICAL = 1
export MAX_UNGROUP_SIZE ?= 5000
export RTLMP_FLOW = True

export VERILOG_FILES = ./designs/src/$(DESIGN_NICKNAME)/AsyncResetReg.v \
                       ./designs/src/$(DESIGN_NICKNAME)/ClockDivider2.v \
                       ./designs/src/$(DESIGN_NICKNAME)/ClockDivider3.v \
                       ./designs/src/$(DESIGN_NICKNAME)/plusarg_reader.v \
                       ./designs/src/$(DESIGN_NICKNAME)/freechips.rocketchip.system.TinyConfig.v \
                       ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/freechips.rocketchip.system.TinyConfig.v

export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export ADDITIONAL_LEFS = $(sort $(wildcard ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/*.lef))
export ADDITIONAL_LIBS = $(sort $(wildcard ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/*.lib))


# These values must be multiples of placement site
# x=0.19 y=1.4
export DIE_AREA    = 0 0 424.92 499.4
export CORE_AREA   = 10.07 9.8 414.85 489.6
export TNS_END_PERCENT        = 100
