export DESIGN_NICKNAME = bsg_loopback
export DESIGN_NAME = bsg_chip
export PLATFORM    = gf14

export VERILOG_FILES = ./platforms/gf14/bp/bsg_ac_io_complex_loopback/bsg_chip.sv2v.v \
                       ./platforms/gf14/bp/IN12LP_GPIO18_13M9S30P.blackbox.v

# export DC_NETLIST    = ./platforms/gf14/bp/bsg_ac_io_complex_loopback/dc/results/bsg_chip.mapped.flat.v

export SDC_FILE      = ./platforms/gf14/bp/bsg_ac_io_complex_loopback/bsg_chip.elab.v.sdc

export ADDITIONAL_LEFS = ./platforms/gf14/bp/lef/IN12LP_GPIO18_13M9S30P.lef

export ADDITIONAL_LIBS = ./platforms/gf14/bp/lib/IN12LP_GPIO18_13M9S30P_TT_0P8_1P8_25.lib

export ADDITIONAL_GDS  = ./platforms/gf14/bp/gds/IN12LP_GPIO18_13M9S30P.gds


export FOOTPRINT    = ./platforms/gf14/bp/bsg_black_parrot.package.strategy
export SIG_MAP_FILE = ./platforms/gf14/bp/soc_bsg_black_parrot.sigmap

# These values must be multiples of placement site
# export DIE_AREA    =
# export CORE_AREA   =

export CLOCK_PERIOD = 5.600
