export DESIGN_NICKNAME = vb
export DESIGN_NAME = bsg_manycore_tile
export PLATFORM    = tsmc65lp

export VERILOG_FILES = ./designs/src/vb/bsg_manycore_tile.sv2v.v
export SDC_FILE      = ./designs/src/vb/bsg_manycore_tile.elab.v.sdc

export ADDITIONAL_LEFS = ./platforms/tsmc65lp/lef/tsmc65lp_1rf_lg10_w32_all.lef \
                         ./platforms/tsmc65lp/lef/tsmc65lp_2rf_lg5_w32_all.lef \
                         ./platforms/tsmc65lp/lef/tsmc65lp_1rf_lg10_w32_byte.lef
export ADDITIONAL_LIBS = ./platforms/tsmc65lp/lib/tsmc65lp_1rf_lg10_w32_all_ss_1p08v_1p08v_125c.lib \
                         ./platforms/tsmc65lp/lib/tsmc65lp_2rf_lg5_w32_all_ss_1p08v_1p08v_125c.lib \
                         ./platforms/tsmc65lp/lib/tsmc65lp_1rf_lg10_w32_byte_ss_1p08v_1p08v_125c.lib
export ADDITIONAL_GDS  = ./platforms/tsmc65lp/gds/tsmc65lp_1rf_lg10_w32_all.gds2 \
                         ./platforms/tsmc65lp/gds/tsmc65lp_2rf_lg5_w32_all.gds2 \
                         ./platforms/tsmc65lp/gds/tsmc65lp_1rf_lg10_w32_byte.gds2


# These values must be multiples of placement site
export DIE_AREA    = 0 0 1100 400.8
export CORE_AREA   = 10 12 1090 391.2

export CLOCK_PERIOD = 5.000
