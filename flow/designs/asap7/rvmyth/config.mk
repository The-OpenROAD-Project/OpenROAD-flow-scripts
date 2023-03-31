#design config

export PLATFORM               = asap7
export DESIGN_NICKNAME        = rvmyth
export DESIGN_NAME            = rvmyth_core

export VERILOG_FILES = ./designs/src/$(DESIGN_NICKNAME)/rvmyth_core.v

export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export ABC_AREA               = 1

export CORE_UTILIZATION       = 40
export DIE_AREA               = 0 0 437.72 448.44   
export CORE_AREA              = 5.52 10.88 431.94 435.2
export CORE_ASPECT_RATIO      = 1
export PLACE_DENSITY          = 0.60
