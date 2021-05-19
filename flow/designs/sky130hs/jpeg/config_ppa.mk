include $(dir $(DESIGN_CONFIG))/config.mk

export FLOW_VARIANT = ppa
#
# These values must be multiples of placement site 0.48 x 3.33
# causing degradation in cts pre timing numbers
#export DIE_AREA    = 0 0 2000.04 2000.8
#export CORE_AREA   = 10 10 1990 1991.35

export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 2
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 2

export FASTROUTE_TCL = $(PLATFORM_DIR)/fastroute_ppa.tcl

