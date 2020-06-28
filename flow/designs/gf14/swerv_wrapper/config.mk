export DESIGN_NAME = swerv_wrapper
export PLATFORM    = gf14

export VERILOG_FILES = ./designs/src/swerv/swerv_wrapper.sv2v.v \
                       ./designs/$(PLATFORM)/$(DESIGN_NAME)/macros.v
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export WRAP_LEFS      = ./platforms/$(PLATFORM)/lef/gf14_1rf_lg11_w40_all.lef \
                        ./platforms/$(PLATFORM)/lef/gf14_1rf_lg6_w22_all.lef \
                        ./platforms/$(PLATFORM)/lef/gf14_1rf_lg8_w34_all.lef

export WRAP_LIBS      = ./platforms/$(PLATFORM)/lib/gf14_1rf_lg11_w40_all_nn_nominal_0p80v_0p80v_25c.lib \
                        ./platforms/$(PLATFORM)/lib/gf14_1rf_lg6_w22_all_nn_nominal_0p80v_0p80v_25c.lib \
                        ./platforms/$(PLATFORM)/lib/gf14_1rf_lg8_w34_all_nn_nominal_0p80v_0p80v_25c.lib

export ADDITIONAL_GDS = ./platforms/$(PLATFORM)/gds/gf14_1rf_lg11_w40_all.gds2 \
                        ./platforms/$(PLATFORM)/gds/gf14_1rf_lg6_w22_all.gds2 \
                        ./platforms/$(PLATFORM)/gds/gf14_1rf_lg8_w34_all.gds2

# These values must be multiples of placement site
export DIE_AREA    = 0 0 970.2 760.896
export CORE_AREA   = 9.996 20.16 960.036 749.952

export PLACE_DENSITY = 0.25
