export PLATFORM               = asap7
export PLACE_DENSITY          = 0.30
export CORE_UTILIZATION       = 20
export CORNER            = BC

export VERILOG_FILES          = designs/src/mock-alu/aluregisterfile/*.sv
export SDC_FILE               = designs/$(PLATFORM)/mock-aluregisterfile/constraints.sdc

export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2

export GND_NETS_VOLTAGES      = ""
export PWR_NETS_VOLTAGES      = ""

export IO_CONSTRAINTS         = designs/asap7/mock-aluregisterfile/io.tcl
