export PLATFORM = nangate45
export DESIGN_NAME = tpu

export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/tpu/*.sv))
export SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

# Synthesis
export ABC_CLOCK_PERIOD_IN_PS = 1000
export SYNTH_HDL_FRONTEND = slang
export LEC_CHECK = 0

# Floorplan
export CORE_UTILIZATION = 60
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN = 2

export TNS_END_PERCENT = 100
