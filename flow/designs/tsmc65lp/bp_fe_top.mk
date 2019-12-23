export DESIGN_NAME = bp_fe_top
export PLATFORM    = tsmc65lp

export VERILOG_FILES = ./designs/src/bp_fe_top/pickled.v \
                       ./designs/src/bp_fe_top/tsmc65lp_macros.v
export SDC_FILE      = ./designs/src/bp_fe_top/design.sdc

export MERGED_LEF       = ./platforms/tsmc65lp/merged.lef
export ADDITIONAL_LEFS += ./platforms/tsmc65lp/tsmc65lp_1rf_lg6_w8_bit.lef \
                          ./platforms/tsmc65lp/tsmc65lp_1rf_lg6_w96_bit.lef \
                          ./platforms/tsmc65lp/tsmc65lp_1rf_lg9_w64_all.lef \
                          ./platforms/tsmc65lp/tsmc65lp_1rf_lg9_w64_bit.lef
export LIB_FILES  = $(sort $(wildcard ./platforms/tsmc65lp/lib/*.lib))
export GDS_FILES  = $(sort $(wildcard ./platforms/tsmc65lp/gds/*.gds2))

export RUN_MACRO_PLACEMENT = 1

# These values must be multiples of placement site
export DIE_AREA    = 0 0 1200 1000.8
export CORE_AREA   = 10 12 1190 991.2
export CORE_WIDTH  = 1180
export CORE_HEIGHT = 979.2

export CLOCK_PERIOD = 5.600
export CLOCK_PORT   = clk_i
