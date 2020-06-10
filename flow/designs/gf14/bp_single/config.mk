export DESIGN_NICKNAME = bp_single
export DESIGN_NAME = bsg_chip
export PLATFORM    = gf14

export VERILOG_FILES = ./platforms/gf14/bp/bsg_ac_black_parrot_single_core_v0/bsg_chip.sv2v.v \
                       ./platforms/gf14/bp/IN12LP_GPIO18_13M9S30P.blackbox.v

# export CACHED_NETLIST    = ./platforms/gf14/bp/bsg_ac_black_parrot_single_core_v0/dc/results/bsg_chip.mapped.flat.v
export CACHED_NETLIST    = ./platforms/gf14/bp/bsg_ac_black_parrot_single_core_v0/yosys/synth.v

export SDC_FILE      = ./platforms/gf14/bp/bsg_ac_black_parrot_single_core_v0/bsg_chip.elab.v.sdc

export ADDITIONAL_LEFS = ./platforms/gf14/bp/lef/gf14_1r1w_d32_w64_m1.lef \
                         ./platforms/gf14/bp/lef/gf14_1rw_d128_w116_m2_bit.lef \
                         ./platforms/gf14/bp/lef/gf14_1rw_d256_w48_m2.lef \
                         ./platforms/gf14/bp/lef/gf14_1rw_d512_w64_m2_byte.lef \
                         ./platforms/gf14/bp/lef/gf14_1rw_d64_w124_m2_bit.lef \
                         ./platforms/gf14/bp/lef/gf14_1rw_d64_w62_m2_bit.lef \
                         ./platforms/gf14/bp/lef/IN12LP_GPIO18_13M9S30P.lef \
                         ./platforms/gf14/bp/wrappers/gf14_1r1w_d32_w64_m1_mod.lef \
                         ./platforms/gf14/bp/wrappers/gf14_1rw_d128_w116_m2_bit_mod.lef \
                         ./platforms/gf14/bp/wrappers/gf14_1rw_d256_w48_m2_mod.lef \
                         ./platforms/gf14/bp/wrappers/gf14_1rw_d512_w64_m2_byte_mod.lef \
                         ./platforms/gf14/bp/wrappers/gf14_1rw_d64_w124_m2_bit_mod.lef \
                         ./platforms/gf14/bp/wrappers/gf14_1rw_d64_w62_m2_bit_mod.lef

export ADDITIONAL_LIBS = ./platforms/gf14/bp/lib/gf14_1r1w_d32_w64_m1_tt_nominal_0p80v_0p80v_25c.lib \
                         ./platforms/gf14/bp/lib/gf14_1rw_d128_w116_m2_bit_tt_nominal_0p80v_0p80v_25c.lib \
                         ./platforms/gf14/bp/lib/gf14_1rw_d256_w48_m2_tt_nominal_0p80v_0p80v_25c.lib \
                         ./platforms/gf14/bp/lib/gf14_1rw_d512_w64_m2_byte_tt_nominal_0p80v_0p80v_25c.lib \
                         ./platforms/gf14/bp/lib/gf14_1rw_d64_w124_m2_bit_tt_nominal_0p80v_0p80v_25c.lib \
                         ./platforms/gf14/bp/lib/gf14_1rw_d64_w62_m2_bit_tt_nominal_0p80v_0p80v_25c.lib \
                         ./platforms/gf14/bp/lib/IN12LP_GPIO18_13M9S30P_TT_0P8_1P8_25.lib \
                         ./platforms/gf14/bp/wrappers/gf14_1r1w_d32_w64_m1_mod_tt_nominal_0p80v_0p80v_25c.lib \
                         ./platforms/gf14/bp/wrappers/gf14_1rw_d128_w116_m2_bit_mod_tt_nominal_0p80v_0p80v_25c.lib \
                         ./platforms/gf14/bp/wrappers/gf14_1rw_d256_w48_m2_mod_tt_nominal_0p80v_0p80v_25c.lib \
                         ./platforms/gf14/bp/wrappers/gf14_1rw_d512_w64_m2_byte_mod_tt_nominal_0p80v_0p80v_25c.lib \
                         ./platforms/gf14/bp/wrappers/gf14_1rw_d64_w124_m2_bit_mod_tt_nominal_0p80v_0p80v_25c.lib \
                         ./platforms/gf14/bp/wrappers/gf14_1rw_d64_w62_m2_bit_mod_tt_nominal_0p80v_0p80v_25c.lib

export ADDITIONAL_GDS  = ./platforms/gf14/bp/wrappers/gf14_1r1w_d32_w64_m1_mod.gds2 \
                         ./platforms/gf14/bp/wrappers/gf14_1rw_d128_w116_m2_bit_mod.gds2 \
                         ./platforms/gf14/bp/wrappers/gf14_1rw_d256_w48_m2_mod.gds2 \
                         ./platforms/gf14/bp/wrappers/gf14_1rw_d512_w64_m2_byte_mod.gds2 \
                         ./platforms/gf14/bp/wrappers/gf14_1rw_d64_w124_m2_bit_mod.gds2 \
                         ./platforms/gf14/bp/wrappers/gf14_1rw_d64_w62_m2_bit_mod.gds2 \
                         ./platforms/gf14/bp/gds/IN12LP_GPIO18_13M9S30P.gds


export FOOTPRINT    = ./platforms/gf14/bp/bsg_bp_single.package.strategy
export SIG_MAP_FILE = ./platforms/gf14/bp/soc_bsg_black_parrot.sigmap

# These values must be multiples of placement site
# export DIE_AREA    =
# export CORE_AREA   =

export ABC_CLOCK_PERIOD_IN_PS = 1250

export PLACE_DENSITY = 0.20

export MACRO_WRAPPERS = ./platforms/gf14/bp/wrappers/wrappers.tcl
export MACRO_PLACEMENT = ./platforms/gf14/bp/bp_single.macro_placment.cfg

export PDN_CFG ?= ./platforms/gf14/pdn_grid_strategy_13m_9T.top.cfg

# TODO: replace this with max(CHANNEL_WIDTH_[HV]) from IP_global.cfg
export MACRO_BLOCKAGE_HALO = 25
