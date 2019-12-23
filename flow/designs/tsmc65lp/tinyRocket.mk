export DESIGN_NAME = RocketTile
export PLATFORM    = tsmc65lp

export VERILOG_FILES = ./designs/src/tinyRocket/AsyncResetReg.v \
                       ./designs/src/tinyRocket/ClockDivider2.v \
                       ./designs/src/tinyRocket/ClockDivider3.v \
                       ./designs/src/tinyRocket/plusarg_reader.v \
                       ./designs/src/tinyRocket/freechips.rocketchip.system.TinyConfig.v \
                       ./designs/src/tinyRocket/freechips.rocketchip.system.TinyConfig.tsmc65lp.v

export SDC_FILE      = ./designs/src/tinyRocket/RocketTile.sdc

export MERGED_LEF       = ./platforms/tsmc65lp/merged.lef
export ADDITIONAL_LEFS += ./platforms/tsmc65lp/tsmc65lp_1rf_lg6_w32_all.lef \
                          ./platforms/tsmc65lp/tsmc65lp_1rf_lg6_w32_byte.lef \
                          ./platforms/tsmc65lp/tsmc65lp_2rf_lg10_w32_bit.lef

export LIB_FILES  = $(sort $(wildcard ./platforms/tsmc65lp/lib/*.lib))
export GDS_FILES  = $(sort $(wildcard ./platforms/tsmc65lp/gds/*.gds2))

export RUN_MACRO_PLACEMENT = 1

# These values must be multiples of placement site
export DIE_AREA    = 0 0 925 806.4
export CORE_AREA   = 10 12 915 796.8
export CORE_WIDTH  = 905
export CORE_HEIGHT = 784.8

export CLOCK_PERIOD = 5.600
export CLOCK_PORT   = clock
