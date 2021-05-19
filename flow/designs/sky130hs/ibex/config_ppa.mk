include $(dir $(DESIGN_CONFIG))/config.mk

export FLOW_VARIANT = ppa
#
# These values must be multiples of placement site 0.48 x 3.33
export DIE_AREA    = 0 0 1200 1200
export CORE_AREA   = 10.0 10 1190.32 1192.15

export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 2
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 2

export FASTROUTE_TCL = $(PLATFORM_DIR)/fastroute_ppa.tcl

