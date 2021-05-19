include $(dir $(DESIGN_CONFIG))/config.mk

export FLOW_VARIANT = ppa

# These values must be multiples of placement site
export DIE_AREA    = 0 0 150 150
export CORE_AREA   = 10 10 140.08 143.2

export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 2
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 2

export FASTROUTE_TCL = $(PLATFORM_DIR)/fastroute_ppa.tcl

