export DESIGN_NICKNAME = counter
export DESIGN_NAME = counter
export PLATFORM    = sky130hd

export VHDL_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/counter/*.vhd)) 

export SYNTH_HDL_FRONTEND = ghdl

export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export CORE_UTILIZATION = 50
export PLACE_DENSITY_LB_ADDON = 0.25
export TNS_END_PERCENT = 100

export REMOVE_ABC_BUFFERS = 1

