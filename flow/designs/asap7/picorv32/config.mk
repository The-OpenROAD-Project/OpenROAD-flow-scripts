export PLATFORM = asap7
export DESIGN_NAME = picorv32

export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/picorv32/*.sv))
export SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export ASAP7_USE_VT = RVT LVT SLVT

# Synthesis
export SYNTH_OPERATIONS_ARGS = -booth
export REMOVE_ABC_BUFFERS = 1
export SYNTH_RETIME_MODULES = $(DESIGN_NAME)
export SYNTH_HDL_FRONTEND = slang
export LEC_CHECK = 0

# Floorplan
export CORE_UTILIZATION = 60
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN = 2

export TNS_END_PERCENT = 100
