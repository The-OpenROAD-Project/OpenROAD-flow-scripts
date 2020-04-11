export DESIGN_NICKNAME = aes
export DESIGN_NAME = aes_cipher_top
export PLATFORM    = nangate45

export VERILOG_FILES = $(wildcard ./designs/src/aes/*.v)
export SDC_FILE      = ./designs/src/aes/aes_cipher_top.sdc

# These values must be multiples of placement site
# x=0.19 y=1.4
#export DIE_AREA    = 0 0 320.15 320.6
#export CORE_AREA   = 10.07 11.2 310.27 310.8
export DIE_AREA    = 0 0 620.15 620.6
export CORE_AREA   = 10.07 11.2 610.27 610.8

export CLOCK_PERIOD = 5.000
