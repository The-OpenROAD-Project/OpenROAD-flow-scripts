export PLATFORM               = asap7

include designs/src/mock-alu/defaults-registerfile.mk

export BLOCKS = registers_8x64

export PLACE_DENSITY          = 0.30
export CORE_UTILIZATION       = 30
export CORNER            = BC
export RTLMP_FLOW=True
export MACRO_PLACE_HALO=27 27

export GND_NETS_VOLTAGES      = ""
export PWR_NETS_VOLTAGES      = ""

export GDS_ALLOW_EMPTY = registers_8x64
