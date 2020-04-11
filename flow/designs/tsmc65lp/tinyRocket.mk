export DESIGN_NICKNAME = tinyRocket
export DESIGN_NAME = RocketTile
export PLATFORM    = tsmc65lp

export VERILOG_FILES = ./designs/src/tinyRocket/AsyncResetReg.v \
                       ./designs/src/tinyRocket/ClockDivider2.v \
                       ./designs/src/tinyRocket/ClockDivider3.v \
                       ./designs/src/tinyRocket/plusarg_reader.v \
                       ./designs/src/tinyRocket/freechips.rocketchip.system.TinyConfig.v \
                       ./designs/src/tinyRocket/freechips.rocketchip.system.TinyConfig.tsmc65lp.v

export SDC_FILE      = ./designs/src/tinyRocket/RocketTile.sdc

export ADDITIONAL_LEFS = ./platforms/tsmc65lp/lef/tsmc65lp_1rf_lg6_w32_byte.lef \
                         ./platforms/tsmc65lp/lef/tsmc65lp_1rf_lg6_w32_all.lef \
                         ./platforms/tsmc65lp/lef/tsmc65lp_2rf_lg10_w32_bit.lef
export ADDITIONAL_LIBS = ./platforms/tsmc65lp/lib/tsmc65lp_1rf_lg6_w32_byte_ss_1p08v_1p08v_125c.lib \
                         ./platforms/tsmc65lp/lib/tsmc65lp_1rf_lg6_w32_all_ss_1p08v_1p08v_125c.lib \
                         ./platforms/tsmc65lp/lib/tsmc65lp_2rf_lg10_w32_bit_ss_1p08v_1p08v_125c.lib
export ADDITIONAL_GDS  = ./platforms/tsmc65lp/gds/tsmc65lp_1rf_lg6_w32_byte.gds2 \
                         ./platforms/tsmc65lp/gds/tsmc65lp_1rf_lg6_w32_all.gds2 \
                         ./platforms/tsmc65lp/gds/tsmc65lp_2rf_lg10_w32_bit.gds2

export LIB_FILES  = $(sort $(wildcard ./platforms/tsmc65lp/lib/*.lib))
export GDS_FILES  = $(sort $(wildcard ./platforms/tsmc65lp/gds/*.gds2))


# These values must be multiples of placement site
export DIE_AREA    = 0 0 925 806.4
export CORE_AREA   = 10 12 915 796.8

export CLOCK_PERIOD = 5.600
