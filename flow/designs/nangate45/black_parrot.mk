export DESIGN_NICKNAME = bp
export DESIGN_NAME = black_parrot
export PLATFORM    = nangate45

export VERILOG_FILES = ./designs/src/black_parrot/pickled.v \
                       ./designs/src/black_parrot/nangate45_macros.v
export SDC_FILE      = ./designs/src/black_parrot/design.sdc

export ADDITIONAL_LEFS = $(wildcard ./designs/src/black_parrot/fakeram45*.lef)
export ADDITIONAL_LIBS = $(wildcard ./designs/src/black_parrot/fakeram45*.lib)


# These values must be multiples of placement site
# x=0.19 y=1.4
export DIE_AREA    = 0 0 2200.01 2199.4
export CORE_AREA   = 10.07 11.2 2189.94 2189.6

export CLOCK_PERIOD = 5.600
export PLACE_DENSITY = 0.15
