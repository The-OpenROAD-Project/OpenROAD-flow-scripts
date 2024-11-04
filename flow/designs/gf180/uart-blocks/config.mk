export PLATFORM               = gf180

export DESIGN_NAME            = uart
export DESIGN_NICKNAME        = uart-blocks

export VERILOG_FILES = $(DESIGN_HOME)/src/uart-no-param/*.v
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export SYNTH_HIERARCHICAL = 1
export BLOCKS = uart_rx

export DIE_AREA = 0 0 430 430
export CORE_AREA = 10 10 420 420

export PLACE_PINS_ARGS    = -exclude bottom:* -exclude top:* -exclude right:*

export MACRO_PLACE_HALO = 20 20
export MACRO_PLACE_CHANNEL = 20 20

export PDN_TCL = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/BLOCKS_grid_strategy.tcl
export PLACE_DENSITY          = 0.60

export TAPCELL_TCL ?= $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/tapcell.tcl
export MACRO_HALO_X = 14
export MACRO_HALO_Y = 14
