export DESIGN_NAME = RocketTile
export PLATFORM    = nangate45

export VERILOG_FILES = ./designs/src/tinyRocket/AsyncResetReg.v \
                       ./designs/src/tinyRocket/ClockDivider2.v \
                       ./designs/src/tinyRocket/ClockDivider3.v \
                       ./designs/src/tinyRocket/plusarg_reader.v \
                       ./designs/src/tinyRocket/freechips.rocketchip.system.TinyConfig.v \
                       ./designs/src/tinyRocket/freechips.rocketchip.system.TinyConfig.nangate45.v

export SDC_FILE      = ./designs/src/tinyRocket/RocketTile.sdc

export MERGED_LEF = ./platforms/nangate45/NangateOpenCellLibrary.mod.lef
export ADDITIONAL_LEFS = $(wildcard ./designs/src/tinyRocket/fakeram45*.lef)
export LIB_FILES  = ./platforms/nangate45/NangateOpenCellLibrary_typical.lib \
                    $(wildcard ./designs/src/tinyRocket/fakeram45*.lib)
export GDS_FILES  = $(wildcard ./platforms/nangate45/gds/*)

export RUN_MACRO_PLACEMENT = 1

# These values must be multiples of placement site
# x=0.19 y=1.4
export DIE_AREA    = 0 0 924.92 799.4
export CORE_AREA   = 10.07 9.8 914.85 789.6
export CORE_WIDTH  = 904.78
export CORE_HEIGHT = 779.8

export CLOCK_PERIOD = 5.600
export CLOCK_PORT   = clock
