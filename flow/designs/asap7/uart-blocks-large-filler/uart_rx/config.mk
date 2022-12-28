export PLATFORM               = asap7

export DESIGN_NAME            = uart_rx
export DESIGN_NICKNAME        = uart-blocks-large-filler_uart_rx

export VERILOG_FILES = ./designs/src/uart-no-param/*.v
export SDC_FILE      = ./designs/$(PLATFORM)/uart-blocks-large-filler/uart_rx/constraint.sdc

export ABC_CLOCK_PERIOD_IN_PS = 650

export CORE_UTILIZATION       = 30
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY          = 0.60
