export PLATFORM               = asap7
export PLACE_DENSITY          = 0.30
export CORE_UTILIZATION       = 20
export CORNER            = BC

export VERILOG_FILES          = designs/src/mock-alu/registerfile/*.sv
export SDC_FILE               = designs/$(PLATFORM)/mock-registerfile/constraints.sdc

export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
