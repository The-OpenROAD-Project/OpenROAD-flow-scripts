export PLATFORM               = gf180

export DESIGN_NAME            = uart_rx
export DESIGN_NICKNAME        = uart-blocks_uart_rx

export VERILOG_FILES = $(DESIGN_HOME)/src/uart-no-param/*.v
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/uart-blocks/uart_rx/constraint.sdc

export CORE_UTILIZATION       = 30
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY          = 0.60

export PDN_TCL = $(DESIGN_HOME)/$(PLATFORM)/uart-blocks/BLOCKS_grid_strategy.tcl

export PLACE_PINS_ARGS    = -exclude bottom:* -exclude top:* -exclude right:*

export MAX_ROUTING_LAYER      = Metal4
