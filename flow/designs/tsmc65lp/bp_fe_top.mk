export DESIGN_NICKNAME = bp_fe
export DESIGN_NAME = bp_fe_top
export PLATFORM    = tsmc65lp

export VERILOG_FILES = ./designs/src/bp_fe_top/pickled.v \
                       ./designs/src/bp_fe_top/tsmc65lp_macros.v
export SDC_FILE      = ./designs/src/bp_fe_top/design.sdc

export ADDITIONAL_LEFS = ./platforms/tsmc65lp/lef/tsmc65lp_1rf_lg6_w8_bit.lef \
                         ./platforms/tsmc65lp/lef/tsmc65lp_1rf_lg6_w96_bit.lef \
                         ./platforms/tsmc65lp/lef/tsmc65lp_1rf_lg9_w64_bit.lef \
                         ./platforms/tsmc65lp/lef/tsmc65lp_1rf_lg9_w64_all.lef
export ADDITIONAL_LIBS = ./platforms/tsmc65lp/lib/tsmc65lp_1rf_lg6_w8_bit_ss_1p08v_1p08v_125c.lib \
                         ./platforms/tsmc65lp/lib/tsmc65lp_1rf_lg6_w96_bit_ss_1p08v_1p08v_125c.lib \
                         ./platforms/tsmc65lp/lib/tsmc65lp_1rf_lg9_w64_bit_ss_1p08v_1p08v_125c.lib \
                         ./platforms/tsmc65lp/lib/tsmc65lp_1rf_lg9_w64_all_ss_1p08v_1p08v_125c.lib
export ADDITIONAL_GDS  = ./platforms/tsmc65lp/gds/tsmc65lp_1rf_lg6_w8_bit.gds2 \
                         ./platforms/tsmc65lp/gds/tsmc65lp_1rf_lg6_w96_bit.gds2 \
                         ./platforms/tsmc65lp/gds/tsmc65lp_1rf_lg9_w64_bit.gds2 \
                         ./platforms/tsmc65lp/gds/tsmc65lp_1rf_lg9_w64_all.gds2



# These values must be multiples of placement site
export DIE_AREA    = 0 0 1200 1000.8
export CORE_AREA   = 10 12 1190 991.2

export CLOCK_PERIOD = 5.600
