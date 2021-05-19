include $(dir $(DESIGN_CONFIG))/config.mk

export FLOW_VARIANT = ppa

# These values must be multiples of placement site 0.48 x 3.33
export DIE_AREA    = 0 0 800 800.8
export CORE_AREA   = 10 10 790 792.55

export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 2
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 2

export FASTROUTE_TCL = $(PLATFORM_DIR)/fastroute_ppa.tcl

