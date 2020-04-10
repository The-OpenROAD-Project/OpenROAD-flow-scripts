export DESIGN_NAME = gcd
export PLATFORM    = sw130

export VERILOG_FILES = ./designs/src/gcd/gcd.v
export SDC_FILE      = ./designs/src/gcd/gcd.sdc

# These values must be multiples of placement site
export DIE_AREA    = 0 0 199.96 200.128
export CORE_AREA   = 9.996 10.08 189.964 190.048

export CLOCK_PERIOD = 10.000
