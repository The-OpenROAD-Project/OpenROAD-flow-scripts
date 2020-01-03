export DESIGN_NAME = black_parrot
export PLATFORM    = tsmc65lp

export VERILOG_FILES = ./designs/src/black_parrot/pickled.v \
                       ./designs/src/black_parrot/tsmc65lp_macros.v
export SDC_FILE      = ./designs/src/black_parrot/design.sdc

export ADDITIONAL_LEFS = ./platforms/tsmc65lp/tsmc65lp_1rf_lg6_w16_bit.lef \
                         ./platforms/tsmc65lp/tsmc65lp_1rf_lg6_w8_bit.lef \
                         ./platforms/tsmc65lp/tsmc65lp_1rf_lg6_w96_bit.lef \
                         ./platforms/tsmc65lp/tsmc65lp_1rf_lg9_w64_bit.lef \
                         ./platforms/tsmc65lp/tsmc65lp_1rf_lg8_w96_all.lef \
                         ./platforms/tsmc65lp/tsmc65lp_1rf_lg9_w64_all.lef
export ADDITIONAL_LIBS = ./platforms/tsmc65lp/lib/tsmc65lp_1rf_lg6_w16_bit_ss_1p08v_1p08v_125c.lib \
                         ./platforms/tsmc65lp/lib/tsmc65lp_1rf_lg6_w8_bit_ss_1p08v_1p08v_125c.lib \
                         ./platforms/tsmc65lp/lib/tsmc65lp_1rf_lg6_w96_bit_ss_1p08v_1p08v_125c.lib \
                         ./platforms/tsmc65lp/lib/tsmc65lp_1rf_lg9_w64_bit_ss_1p08v_1p08v_125c.lib \
                         ./platforms/tsmc65lp/lib/tsmc65lp_1rf_lg8_w96_all_ss_1p08v_1p08v_125c.lib \
                         ./platforms/tsmc65lp/lib/tsmc65lp_1rf_lg9_w64_all_ss_1p08v_1p08v_125c.lib
export ADDITIONAL_GDS  = ./platforms/tsmc65lp/gds/tsmc65lp_1rf_lg6_w16_bit.gds2 \
                         ./platforms/tsmc65lp/gds/tsmc65lp_1rf_lg6_w8_bit.gds2 \
                         ./platforms/tsmc65lp/gds/tsmc65lp_1rf_lg6_w96_bit.gds2 \
                         ./platforms/tsmc65lp/gds/tsmc65lp_1rf_lg9_w64_bit.gds2 \
                         ./platforms/tsmc65lp/gds/tsmc65lp_1rf_lg8_w96_all.gds2 \
                         ./platforms/tsmc65lp/gds/tsmc65lp_1rf_lg9_w64_all.gds2


export RUN_MACRO_PLACEMENT = 1

# These values must be multiples of placement site
export DIE_AREA    = 0 0 2200 2000.8
export CORE_AREA   = 10 12 2190 1991.2
export CORE_WIDTH  = 2180
export CORE_HEIGHT = 1979.2

export CLOCK_PERIOD = 5.600
export CLOCK_PORT   = clk_i
