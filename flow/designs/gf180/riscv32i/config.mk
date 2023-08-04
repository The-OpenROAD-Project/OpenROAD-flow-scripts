export DESIGN_NICKNAME = riscv32i
export DESIGN_NAME = riscv
export PLATFORM    = gf180

export VERILOG_FILES = $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export CORE_UTILIZATION = 45
export PLACE_DENSITY_LB_ADDON = 0.2
export TNS_END_PERCENT = 100
export SKIP_GATE_CLONING  = 1
export HAS_IO_CONSTRAINTS = 1
export PLACE_PINS_ARGS    = -min_distance 5 -exclude bottom:* -exclude top:*

