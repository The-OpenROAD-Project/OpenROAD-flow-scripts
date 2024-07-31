export PLATFORM    = nangate45
export DESIGN_NICKNAME ?= iot_shield
export DESIGN_NAME = i2c_master_top

export VERILOG_FILES =$(sort $(wildcard ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/rtl/*.v))

export SDC_FILE      =./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export CORE_UTILIZATION = 40
export PLACE_DENSITY = 0.68
export TNS_END_PERCENT =100

export DETAILED_ROUTE_ARGS = -droute_end_iter 16
export GLOBAL_ROUTE_ARGS = -allow_congestion -verbose