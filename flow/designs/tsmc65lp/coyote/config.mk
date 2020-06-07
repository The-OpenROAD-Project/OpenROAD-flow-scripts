export DESIGN_NICKNAME = coyote
export DESIGN_NAME = bsg_rocket_node_client_rocc
export PLATFORM    = tsmc65lp

export VERILOG_FILES = ./designs/src/$(DESIGN_NICKNAME)/coyote.sv2v.v \
                       ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/macros.v
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export ADDITIONAL_LEFS = ./platforms/$(PLATFORM)/lef/tsmc65lp_1rf_lg6_w80_bit.lef \
                         ./platforms/$(PLATFORM)/lef/tsmc65lp_1rf_lg8_w128_all.lef \
                         ./platforms/$(PLATFORM)/lef/tsmc65lp_2rf_lg6_w44_bit.lef \
                         ./platforms/$(PLATFORM)/lef/tsmc65lp_2rf_lg8_w64_bit.lef
export ADDITIONAL_LIBS = ./platforms/$(PLATFORM)/lib/tsmc65lp_1rf_lg6_w80_bit_ss_1p08v_1p08v_125c.lib \
                         ./platforms/$(PLATFORM)/lib/tsmc65lp_1rf_lg8_w128_all_ss_1p08v_1p08v_125c.lib \
                         ./platforms/$(PLATFORM)/lib/tsmc65lp_2rf_lg6_w44_bit_ss_1p08v_1p08v_125c.lib \
                         ./platforms/$(PLATFORM)/lib/tsmc65lp_2rf_lg8_w64_bit_ss_1p08v_1p08v_125c.lib
export ADDITIONAL_GDS  = ./platforms/$(PLATFORM)/gds/tsmc65lp_1rf_lg6_w80_bit.gds2 \
                         ./platforms/$(PLATFORM)/gds/tsmc65lp_1rf_lg8_w128_all.gds2 \
                         ./platforms/$(PLATFORM)/gds/tsmc65lp_2rf_lg6_w44_bit.gds2 \
                         ./platforms/$(PLATFORM)/gds/tsmc65lp_2rf_lg8_w64_bit.gds2

# These values must be multiples of placement site
export DIE_AREA    = 0.0 0.0 4200 1860
export CORE_AREA   = 10 12 4190 1850.4
