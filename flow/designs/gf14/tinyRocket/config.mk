export DESIGN_NICKNAME = tinyRocket
export DESIGN_NAME = RocketTile
export PLATFORM    = gf14

export VERILOG_FILES  = ./designs/src/$(DESIGN_NICKNAME)/AsyncResetReg.v \
                        ./designs/src/$(DESIGN_NICKNAME)/ClockDivider2.v \
                        ./designs/src/$(DESIGN_NICKNAME)/ClockDivider3.v \
                        ./designs/src/$(DESIGN_NICKNAME)/plusarg_reader.v \
                        ./designs/src/$(DESIGN_NICKNAME)/freechips.rocketchip.system.TinyConfig.v \
                        ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/macros.v

export SDC_FILE       = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export WRAP_LEFS      = ./platforms/gf14/lef/gf14_1rf_lg6_w32_all.lef \
                        ./platforms/gf14/lef/gf14_1rf_lg6_w32_byte.lef \
                        ./platforms/gf14/lef/gf14_2rf_lg10_w32_bit.lef

export WRAP_LIBS      = ./platforms/gf14/lib/gf14_1rf_lg6_w32_all_nn_nominal_0p80v_0p80v_25c.lib \
                        ./platforms/gf14/lib/gf14_1rf_lg6_w32_byte_nn_nominal_0p80v_0p80v_25c.lib \
                        ./platforms/gf14/lib/gf14_2rf_lg10_w32_bit_nn_nominal_0p80v_0p80v_25c.lib

export ADDITIONAL_GDS = ./platforms/gf14/gds/gf14_1rf_lg6_w32_all.gds2 \
                        ./platforms/gf14/gds/gf14_1rf_lg6_w32_byte.gds2 \
                        ./platforms/gf14/gds/gf14_2rf_lg10_w32_bit.gds2 \

# These values must be multiples of placement site
export DIE_AREA    = 0 0 400.008 399.84
export CORE_AREA   = 19.992 20.16 380.016 380.16

export ABC_CLOCK_PERIOD_IN_PS = 1250

export PLACE_DENSITY = 0.20

export MACRO_WRAPPERS = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/wrappers.tcl

export PDN_CFG ?= ./platforms/gf14/pdn_grid_strategy_13m_9T.top.cfg

# TODO: replace this with max(CHANNEL_WIDTH_[HV]) from IP_global.cfg
export MACRO_BLOCKAGE_HALO = 25
