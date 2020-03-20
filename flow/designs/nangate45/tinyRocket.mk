export DESIGN_NICKNAME = tinyRocket
export DESIGN_NAME = RocketTile
export PLATFORM    = nangate45

export VERILOG_FILES = ./designs/src/tinyRocket/AsyncResetReg.v \
                       ./designs/src/tinyRocket/ClockDivider2.v \
                       ./designs/src/tinyRocket/ClockDivider3.v \
                       ./designs/src/tinyRocket/plusarg_reader.v \
                       ./designs/src/tinyRocket/freechips.rocketchip.system.TinyConfig.v \
                       ./designs/src/tinyRocket/freechips.rocketchip.system.TinyConfig.nangate45.v

export SDC_FILE      = ./designs/src/tinyRocket/RocketTile.sdc

export ADDITIONAL_LEFS = $(wildcard ./designs/src/tinyRocket/fakeram45*.lef)
export ADDITIONAL_LIBS = $(wildcard ./designs/src/tinyRocket/fakeram45*.lib)


# These values must be multiples of placement site
# x=0.19 y=1.4
export DIE_AREA    = 0 0 924.92 799.4
export CORE_AREA   = 10.07 9.8 914.85 789.6

export CLOCK_PERIOD = 5.600
