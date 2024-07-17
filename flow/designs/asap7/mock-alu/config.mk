export PLATFORM               = asap7

include designs/src/mock-alu/defaults.mk

export PLACE_DENSITY          = 0.75
export CORE_UTILIZATION       = 50
export CORNER            = BC
# PLACE_DENSITY is very tight, to adjust this up, PLACE_DENSITY also
# needs to be adjusted.
export TNS_END_PERCENT = 5
