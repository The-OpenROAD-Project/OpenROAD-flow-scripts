export PLATFORM               = asap7

export DESIGN_NAME            = uart
export DESIGN_NICKNAME        = uart-blocks

export VERILOG_FILES = ./designs/src/uart-no-param/*.v
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export BLOCKS = uart_rx

export VERILOG_FILES_BLACKBOX = ./designs/src/uart-no-param/uart_rx.v

export CORE_UTILIZATION       = 10
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY          = 0.12

export CORNER                 = TC
