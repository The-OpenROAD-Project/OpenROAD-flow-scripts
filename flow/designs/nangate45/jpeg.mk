export DESIGN_NAME = jpeg_encoder
export PLATFORM    = nangate45

export VERILOG_FILES = $(wildcard ./designs/src/jpeg/*.v)
export VERILOG_INCLUDE_DIRS = ./designs/src/jpeg/include
export SDC_FILE      = ./designs/src/jpeg/jpeg_encoder.sdc

export MERGED_LEF = ./platforms/nangate45/NangateOpenCellLibrary.mod.lef
export LIB_FILES  = ./platforms/nangate45/NangateOpenCellLibrary_typical.lib
export GDS_FILES  = $(wildcard ./platforms/nangate45/gds/*)

# These values must be multiples of placement site
export DIE_AREA    = 0 0 1200.04 1199.8
export CORE_AREA   = 10.07 9.8 1189.97 1190
export CORE_WIDTH  = 1179.9
export CORE_HEIGHT = 1180.2


export CLOCK_PERIOD = 4.000
export CLOCK_PORT   = clk

export PLACE_DENSITY = 0.5
