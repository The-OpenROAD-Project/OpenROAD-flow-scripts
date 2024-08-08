export DESIGN_NICKNAME = riscv32i
export DESIGN_NAME = riscv
export PLATFORM    = sky130hs

export VERILOG_FILES = $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export CORE_UTILIZATION = 45
export PLACE_DENSITY_LB_ADDON = 0.2
# many east pins cause global routing congestion
export PLACE_PINS_ARGS=-min_distance 6 -min_distance_in_tracks
export TNS_END_PERCENT = 100

export FASTROUTE_TCL = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/fastroute.tcl

export REMOVE_ABC_BUFFERS = 1
