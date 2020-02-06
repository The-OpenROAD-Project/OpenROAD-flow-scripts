export DESIGN_NAME = swerv
export PLATFORM    = tsmc65lp

export VERILOG_FILES = ./designs/src/swerv/design.v
export SDC_FILE      = ./designs/src/swerv/design.sdc

# These values must be multiples of placement site
export DIE_AREA    = 0 0 1550 1341.6
export CORE_AREA   = 10 12 1540 1332

export CLOCK_PERIOD = 10.000
export CLOCK_PORT   = clk
