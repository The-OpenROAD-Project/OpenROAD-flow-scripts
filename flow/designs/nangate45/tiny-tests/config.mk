export DESIGN_NAME ?= SmallPinCount
export PLATFORM     = nangate45

export VERILOG_FILES = ./designs/src/tiny-tests/$(DESIGN_NAME).v
export SDC_FILE      = ./designs/src/tiny-tests/design.sdc

export MERGED_LEF = $(PLATFORM_DIR)/NangateOpenCellLibrary.mod.lef
export LIB_FILES  = $(PLATFORM_DIR)/NangateOpenCellLibrary_typical.lib
export GDS_FILES  = $(sort $(wildcard $(PLATFORM_DIR)/gds/*))

# These values must be multiples of placement site
# x=0.19 y=1.4
export DIE_AREA    = 0 0 320.15 320.6
export CORE_AREA   = 10.07 11.2 310.27 310.8
