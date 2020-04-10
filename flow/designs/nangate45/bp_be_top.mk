export DESIGN_NICKNAME = bp_be
export DESIGN_NAME = bp_be_top
export PLATFORM    = nangate45

export VERILOG_FILES = ./designs/src/bp_be_top/pickled.v \
                       ./designs/src/bp_be_top/nangate45_macros.v
export SDC_FILE      = ./designs/src/bp_be_top/design.sdc

export ADDITIONAL_LEFS = $(wildcard ./designs/src/bp_be_top/fakeram45*.lef)
export ADDITIONAL_LIBS = $(wildcard ./designs/src/bp_be_top/fakeram45*.lib)


# These values must be multiples of placement site
# x=0.19 y=1.4
export DIE_AREA    = 0 0 1550.02 1342.6
export CORE_AREA   = 10.07 11.2 1540.14 1332.8

export CLOCK_PERIOD = 5.600
export PLACE_DENSITY = 0.15
