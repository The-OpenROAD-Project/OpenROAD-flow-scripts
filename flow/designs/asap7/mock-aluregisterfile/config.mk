export PLATFORM               = asap7

include designs/src/mock-alu/defaults-alu-registerfile.mk

export BLOCKS = RegisterSRAM

export PLACE_DENSITY          = 0.30
export CORE_UTILIZATION       = 30
export CORNER            = BC
export RTLMP_FLOW=True
export MACRO_PLACE_HALO=27 27

export GND_NETS_VOLTAGES      = ""
export PWR_NETS_VOLTAGES      = ""

export GDS_ALLOW_EMPTY = RegisterSRAM

export IO_CONSTRAINTS         = designs/asap7/mock-aluregisterfile/io.tcl
