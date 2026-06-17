export DESIGN_NICKNAME = gcd
export DESIGN_NAME     = gcd
export PLATFORM        = gt2n

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NAME)/gcd.v
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export CORE_UTILIZATION   = 25
export CORE_MARGIN        = 0.5
export PLACE_DENSITY      = 0.35
export TNS_END_PERCENT    = 100

# Highest layer gcd actually routes on (M6-M13 carry no wire). Capping here
# instead of the platform M13 top shrinks the detailed-route grid, vias, and
# DRC. See platforms/gt2n/config.mk.
export MAX_ROUTING_LAYER  = M5
