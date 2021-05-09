include $(dir $(DESIGN_CONFIG))/config.mk

export FLOW_VARIANT = ppa

#
# gcd, in this platform shows outlier with ppa settings increase in detailed route wirelength
export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 4
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 1 

#export GLOBAL_PLACEMENT_ARGS = -timing_driven

#export FASTROUTE_TCL = $(PLATFORM_DIR)/fastroute_ppa.tcl

