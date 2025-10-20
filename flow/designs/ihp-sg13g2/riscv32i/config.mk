export DESIGN_NICKNAME = riscv32i
export DESIGN_NAME = riscv
export PLATFORM    = ihp-sg13g2

export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export USE_FILL = 1

export CORE_UTILIZATION = 35
export PLACE_DENSITY_LB_ADDON = 0.2
export TNS_END_PERCENT = 100
export CTS_BUF_DISTANCE = 60
