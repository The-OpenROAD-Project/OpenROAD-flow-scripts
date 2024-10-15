export DESIGN_NICKNAME = bp_quad
export DESIGN_NAME = bsg_chip
export PLATFORM    = gf12

export SYNTH_HIERARCHICAL = 1
export MAX_UNGROUP_SIZE ?= 1000

export CACHED_NETLIST = $(PLATFORM_DIR)/bp/bsg_ac_black_parrot_quad_core_v0/bp_quad_block/yosys/bp_quad_yosys_netlist.v
export VERILOG_FILES = $(PLATFORM_DIR)/bp/bsg_ac_black_parrot_quad_core_v0/bp_quad_block/rtl/bsg_chip_block.sv2v.v


export SDC_FILE      = $(PLATFORM_DIR)/bp/bsg_ac_black_parrot_quad_core_v0/bp_quad_block/sdc/bsg_chip.sdc

export WRAP_LEFS       = $(PLATFORM_DIR)/lef/gf12_1r1w_d32_w64_m1.lef \
                         $(PLATFORM_DIR)/lef/gf12_1rw_d128_w116_m2_bit.lef \
                         $(PLATFORM_DIR)/lef/gf12_1rw_d256_w48_m2.lef \
                         $(PLATFORM_DIR)/lef/gf12_1rw_d512_w64_m2_byte.lef \
                         $(PLATFORM_DIR)/lef/gf12_1rw_d64_w124_m2_bit.lef \
                         $(PLATFORM_DIR)/lef/gf12_1rw_d64_w62_m2_bit.lef

export WRAP_LIBS       = $(PLATFORM_DIR)/lib/gf12_1r1w_d32_w64_m1_ffpg_sigcmin_0p88v_0p88v_m40c.lib \
                         $(PLATFORM_DIR)/lib/gf12_1rw_d128_w116_m2_bit_ffpg_sigcmin_0p88v_0p88v_m40c.lib \
                         $(PLATFORM_DIR)/lib/gf12_1rw_d256_w48_m2_ffpg_sigcmin_0p88v_0p88v_m40c.lib \
                         $(PLATFORM_DIR)/lib/gf12_1rw_d512_w64_m2_byte_ffpg_sigcmin_0p88v_0p88v_m40c.lib \
                         $(PLATFORM_DIR)/lib/gf12_1rw_d64_w124_m2_bit_ffpg_sigcmin_0p88v_0p88v_m40c.lib \
                         $(PLATFORM_DIR)/lib/gf12_1rw_d64_w62_m2_bit_ffpg_sigcmin_0p88v_0p88v_m40c.lib


export ADDITIONAL_GDS  = $(PLATFORM_DIR)/gds/gf12_1r1w_d32_w64_m1.gds2 \
                         $(PLATFORM_DIR)/gds/gf12_1rw_d128_w116_m2_bit.gds2 \
                         $(PLATFORM_DIR)/gds/gf12_1rw_d256_w48_m2.gds2 \
                         $(PLATFORM_DIR)/gds/gf12_1rw_d512_w64_m2_byte.gds2 \
                         $(PLATFORM_DIR)/gds/gf12_1rw_d64_w124_m2_bit.gds2 \
                         $(PLATFORM_DIR)/gds/gf12_1rw_d64_w62_m2_bit.gds2 \
                         $(PLATFORM_DIR)/gds/IN12LP_GPIO18_13M9S30P.gds \
                         $(PLATFORM_DIR)/gds/GoLd_LN14_CDMM_32xxx.gds.gz

export SEAL_GDS        = $(PLATFORM_DIR)/gds/crackstop_3x3.gds

export DIE_AREA    = 0 0 1800 1800 
export CORE_AREA   = 5 5 1795 1795
export PLACE_PINS_ARGS = -exclude left:* -exclude right:* -exclude top:* -exclude bottom:0-800 -exclude bottom:1200-1800

export PLACE_DENSITY_LB_ADDON = 0.02

export MACRO_WRAPPERS = $(PLATFORM_DIR)/bp/wrappers/wrappers.tcl

export PDN_TCL = $(PLATFORM_DIR)/cfg/pdn_grid_strategy_13m_9T.top.tcl

# Define macro halo and channel spacings
export MACRO_PLACE_HALO = 5 5 
export MACRO_PLACE_CHANNEL = 10 10
