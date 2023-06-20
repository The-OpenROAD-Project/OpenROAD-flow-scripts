export PLATFORM               = gf180

export DESIGN_NAME            = uart
export DESIGN_NICKNAME        = uart-blocks

export VERILOG_FILES = ./designs/src/uart-no-param/*.v
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export BLOCKS = uart_rx

export VERILOG_FILES_BLACKBOX = ./designs/src/uart-no-param/uart_rx.v

export DIE_AREA = 0 0 430 430
export CORE_AREA = 10 10 420 420

export HAS_IO_CONSTRAINTS = 1
export PLACE_PINS_ARGS    = -exclude bottom:* -exclude top:* -exclude right:*

export MACRO_PLACE_HALO = 20 20
export MACRO_PLACE_CHANNEL = 20 20

export PDN_TCL = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/BLOCKS_grid_strategy.tcl
export PLACE_DENSITY          = 0.60
