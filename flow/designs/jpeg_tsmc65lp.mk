export DESIGN_NAME = jpeg_encoder
export PLATFORM    = tsmc65lp

export VERILOG_FILES = $(wildcard ./designs/src/jpeg/*.v)
export VERILOG_INCLUDE_DIRS = ./designs/src/jpeg/include
export SDC_FILE      = ./designs/src/jpeg/jpeg_encoder.sdc

export MERGED_LEF = ./platforms/tsmc65lp/merged.lef
export LIB_FILES  = $(sort $(wildcard ./platforms/tsmc65lp/lib/*.lib))
export GDS_FILES  = $(sort $(wildcard ./platforms/tsmc65lp/gds/*.gds2))

# These values must be multiples of placement site
export DIE_AREA    = 0 0 1200 960.8
export CORE_AREA   = 10 12 1190 951.2
export CORE_WIDTH  = 1180
export CORE_HEIGHT = 939.2

export CLOCK_PERIOD = 4.000
export CLOCK_PORT   = clk

testv:
	echo $(VERILOG_FILES)