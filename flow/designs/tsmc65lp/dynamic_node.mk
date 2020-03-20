export DESIGN_NICKNAME = dynamic_node
export DESIGN_NAME = dynamic_node_top_wrap
export PLATFORM    = tsmc65lp

export VERILOG_FILES = ./designs/src/dynamic_node/dynamic_node.pickle.v
export SDC_FILE      = ./designs/src/dynamic_node/design.sdc

# These values must be multiples of placement site
export DIE_AREA    = 0 0 500 501.6
export CORE_AREA   = 10 12 490 492

export CLOCK_PERIOD = 15.000
