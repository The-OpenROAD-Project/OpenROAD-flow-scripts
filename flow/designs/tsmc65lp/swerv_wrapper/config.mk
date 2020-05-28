export DESIGN_NAME = swerv_wrapper
export PLATFORM    = tsmc65lp

export VERILOG_FILES = ./designs/src/swerv/swerv_wrapper.sv2v.v \
                       ./designs/$(PLATFORM)/$(DESIGN_NAME)/macros.v
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export ADDITIONAL_LEFS = ./platforms/$(PLATFORM)/lef/tsmc65lp_1rf_lg11_w40_all.lef \
                         ./platforms/$(PLATFORM)/lef/tsmc65lp_1rf_lg6_w22_all.lef \
                         ./platforms/$(PLATFORM)/lef/tsmc65lp_1rf_lg8_w34_all.lef
export ADDITIONAL_LIBS = ./platforms/$(PLATFORM)/lib/tsmc65lp_1rf_lg11_w40_all_ss_1p08v_1p08v_125c.lib \
                         ./platforms/$(PLATFORM)/lib/tsmc65lp_1rf_lg6_w22_all_ss_1p08v_1p08v_125c.lib \
                         ./platforms/$(PLATFORM)/lib/tsmc65lp_1rf_lg8_w34_all_ss_1p08v_1p08v_125c.lib
export ADDITIONAL_GDS  = ./platforms/$(PLATFORM)/gds/tsmc65lp_1rf_lg11_w40_all.gds2 \
                         ./platforms/$(PLATFORM)/gds/tsmc65lp_1rf_lg6_w22_all.gds2 \
                         ./platforms/$(PLATFORM)/gds/tsmc65lp_1rf_lg8_w34_all.gds2

# These values must be multiples of placement site
export DIE_AREA    = 0 0 1848 1449.6
export CORE_AREA   = 10 12 1838 1440
