export DESIGN_NICKNAME = jpeg
export DESIGN_NAME = jpeg_encoder
export PLATFORM    = sky130hd

export VERILOG_FILES = $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v))
export VERILOG_INCLUDE_DIRS = ./designs/src/$(DESIGN_NICKNAME)/include
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export CORE_UTILIZATION = 50
export PLACE_DENSITY_LB_ADDON = 0.15
export TNS_END_PERCENT = 100

export FASTROUTE_TCL = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/fastroute.tcl
