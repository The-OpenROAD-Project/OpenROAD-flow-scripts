export DESIGN_NICKNAME = aes
export DESIGN_NAME = aes_cipher_top
export PLATFORM    = nangate45

export VERILOG_FILES = $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export FLOORPLAN_DEF = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/aes_ng45_fp.def

export PLACE_DENSITY_LB_ADDON = 0.20
export TNS_END_PERCENT = 100
