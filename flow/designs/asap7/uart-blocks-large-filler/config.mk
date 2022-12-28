export PLATFORM               = asap7

export DESIGN_NAME            = uart
export DESIGN_NICKNAME        = uart-blocks-large-filler

export VERILOG_FILES = ./designs/src/uart-no-param/*.v
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export BLOCKS = uart_rx

export VERILOG_FILES_BLACKBOX = ./designs/src/uart-no-param/uart_rx.v

export ABC_CLOCK_PERIOD_IN_PS = 300000

export DIE_AREA = 0 0 2000 2000
export CORE_AREA = 2 2 1998 1998
export PLACE_DENSITY          = 0.12

export CORNER                 = TC
