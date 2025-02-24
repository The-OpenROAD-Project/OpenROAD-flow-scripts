export PLATFORM               = asap7

export DESIGN_NAME            = mock_cpu
export DESIGN_NICKNAME        = mock-cpu

export VERILOG_FILES = $(wildcard $(DESIGN_HOME)/src/fifo/*.v)
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export CORE_UTILIZATION         = 40
export CORE_ASPECT_RATIO        = 1
export CORE_MARGIN              = 2
export PLACE_DENSITY            = 0.71
export TNS_END_PERCENT          = 100

export IO_CONSTRAINTS        = designs/asap7/mock-cpu/io.tcl
