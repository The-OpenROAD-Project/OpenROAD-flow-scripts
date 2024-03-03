export DESIGN_NICKNAME = aes
export DESIGN_NAME = aes_cipher_top
export PLATFORM    = sky130hd

export VERILOG_FILES = $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export PLACE_PINS_ARGS = -min_distance 4 -min_distance_in_tracks

export CORE_UTILIZATION = 20
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN = 2

export PLACE_DENSITY = 0.6
export TNS_END_PERCENT = 100
