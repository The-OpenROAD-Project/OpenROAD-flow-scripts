export DESIGN_NAME = dynamic_node_top_wrap
export PLATFORM    = tsmc65lp

export VERILOG_FILES = ./designs/src/dynamic_node/dynamic_node.pickle.v
export SDC_FILE      = ./designs/src/dynamic_node/design.sdc

export MERGED_LEF = ./platforms/tsmc65lp/merged.lef
export LIB_FILES  = $(sort $(wildcard ./platforms/tsmc65lp/lib/*.lib))
export GDS_FILES  = $(sort $(wildcard ./platforms/tsmc65lp/gds/*.gds2))

# These values must be multiples of placement site
export DIE_AREA    = 0 0 500 501.6
export CORE_AREA   = 10 12 490 492
export CORE_WIDTH  = 480
export CORE_HEIGHT = 480

export CLOCK_PERIOD = 15.000
export CLOCK_PORT   = clk
