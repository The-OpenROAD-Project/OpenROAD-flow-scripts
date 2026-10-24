export DESIGN_NAME = dsp_mac
export PLATFORM    = sky130hd

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NAME)/dsp_mac.v
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export CORE_UTILIZATION = 40
export TNS_END_PERCENT = 100
export SWAP_ARITH_OPERATORS = 1
export OPENROAD_HIERARCHICAL = 1
