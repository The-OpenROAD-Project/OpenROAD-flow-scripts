export DESIGN_NAME = riscv32i
export DESIGN_TOP_NAME = riscv
export PLATFORM    = sky130hd

export VERILOG_FILES = $(sort $(wildcard ./designs/src/$(DESIGN_NAME)/*.v))
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export CORE_UTILIZATION = 40
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN = 2
#
export PLACE_DENSITY_LB_ADDON = 0.2
