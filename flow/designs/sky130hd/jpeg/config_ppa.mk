include $(dir $(DESIGN_CONFIG))/config.mk

export FLOW_VARIANT = ppa

# These values must be multiples of placement site 0.46 x 2.72
export DIE_AREA    = 0 0 1400 1400
export CORE_AREA   = 10. 10 1390 1391.76

export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 4
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 2

export FASTROUTE_TCL = $(PLATFORM_DIR)/fastroute_ppa.tcl

