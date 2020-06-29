export DESIGN_NICKNAME = bp_dual
export DESIGN_NAME = bsg_chip
export PLATFORM    = gf14

export VERILOG_FILES = ./platforms/gf14/bp/bsg_ac_black_parrot_dual_core_v0/bsg_chip.sv2v.v \
                       ./platforms/gf14/bp/IN12LP_GPIO18_13M9S30P.blackbox.v

# export CACHED_NETLIST    = ./platforms/gf14/bp/bsg_ac_black_parrot_dual_core_v0/dc/results/bsg_chip.mapped.flat.v
export CACHED_NETLIST    = ./platforms/gf14/bp/bsg_ac_black_parrot_dual_core_v0/yosys/synth.v

export SDC_FILE      = ./platforms/gf14/bp/bsg_ac_black_parrot_dual_core_v0/bsg_chip.elab.v.sdc

export WRAP_LEFS       = ./platforms/gf14/bp/lef/gf14_1r1w_d32_w64_m1.lef \
                         ./platforms/gf14/bp/lef/gf14_1rw_d128_w116_m2_bit.lef \
                         ./platforms/gf14/bp/lef/gf14_1rw_d256_w48_m2.lef \
                         ./platforms/gf14/bp/lef/gf14_1rw_d512_w64_m2_byte.lef \
                         ./platforms/gf14/bp/lef/gf14_1rw_d64_w124_m2_bit.lef \
                         ./platforms/gf14/bp/lef/gf14_1rw_d64_w62_m2_bit.lef

export ADDITIONAL_LEFS = ./platforms/gf14/bp/lef/IN12LP_GPIO18_13M9S30P.lef \
                         ./platforms/gf14/bp/lef/CDMM_13M_3Mx_2Cx_4Kx_2Hx_2Gx_LB.lef

export WRAP_LIBS       = ./platforms/gf14/bp/lib/gf14_1r1w_d32_w64_m1_tt_nominal_0p80v_0p80v_25c.lib \
                         ./platforms/gf14/bp/lib/gf14_1rw_d128_w116_m2_bit_tt_nominal_0p80v_0p80v_25c.lib \
                         ./platforms/gf14/bp/lib/gf14_1rw_d256_w48_m2_tt_nominal_0p80v_0p80v_25c.lib \
                         ./platforms/gf14/bp/lib/gf14_1rw_d512_w64_m2_byte_tt_nominal_0p80v_0p80v_25c.lib \
                         ./platforms/gf14/bp/lib/gf14_1rw_d64_w124_m2_bit_tt_nominal_0p80v_0p80v_25c.lib \
                         ./platforms/gf14/bp/lib/gf14_1rw_d64_w62_m2_bit_tt_nominal_0p80v_0p80v_25c.lib

export ADDITIONAL_LIBS = ./platforms/gf14/bp/lib/IN12LP_GPIO18_13M9S30P_TT_0P8_1P8_25.lib

export ADDITIONAL_GDS  = ./platforms/gf14/bp/gds/gf14_1r1w_d32_w64_m1.gds2 \
                         ./platforms/gf14/bp/gds/gf14_1rw_d128_w116_m2_bit.gds2 \
                         ./platforms/gf14/bp/gds/gf14_1rw_d256_w48_m2.gds2 \
                         ./platforms/gf14/bp/gds/gf14_1rw_d512_w64_m2_byte.gds2 \
                         ./platforms/gf14/bp/gds/gf14_1rw_d64_w124_m2_bit.gds2 \
                         ./platforms/gf14/bp/gds/gf14_1rw_d64_w62_m2_bit.gds2 \
                         ./platforms/gf14/bp/gds/IN12LP_GPIO18_13M9S30P.gds \
                         ./platforms/gf14/bp/gds/GoLd_LN14_CDMM_32xxx.gds.gz

export SEAL_GDS        = ./platforms/gf14/bp/gds/crackstop_3x3.gds

export FOOTPRINT    = ./platforms/gf14/bp/bsg_bp_dual.package.strategy
export SIG_MAP_FILE = ./platforms/gf14/bp/soc_bsg_black_parrot.sigmap

# These values must be multiples of placement site
# export DIE_AREA    =
# export CORE_AREA   =

export ABC_CLOCK_PERIOD_IN_PS = 1250

export PLACE_DENSITY = 0.20

export MACRO_WRAPPERS = ./platforms/gf14/bp/wrappers/wrappers.tcl

export PDN_CFG ?= ./platforms/gf14/pdn_grid_strategy_13m_9T.top.cfg

# TODO: replace this with max(CHANNEL_WIDTH_[HV]) from IP_global.cfg
export MACRO_BLOCKAGE_HALO = 25
