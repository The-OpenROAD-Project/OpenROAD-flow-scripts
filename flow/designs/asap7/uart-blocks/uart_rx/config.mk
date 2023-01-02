export PLATFORM               = asap7

export DESIGN_NAME            = uart_rx
export DESIGN_NICKNAME        = uart-blocks_uart_rx

export VERILOG_FILES = ./designs/src/uart-no-param/*.v
export SDC_FILE      = ./designs/$(PLATFORM)/uart-blocks/uart_rx/constraint.sdc

export CORE_UTILIZATION       = 30
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY          = 0.60
