include $(dir $(DESIGN_CONFIG))/config.mk

export FLOW_VARIANT = ppa
#
# These values must be multiples of placement site  0.46 x 2.72
export DIE_AREA    = 0 0  760 760 
export CORE_AREA   = 10 10 750.14 752.56

export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 3
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 2

export FASTROUTE_TCL = $(PLATFORM_DIR)/fastroute_ppa.tcl

