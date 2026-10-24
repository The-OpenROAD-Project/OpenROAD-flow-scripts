# The rest of tpu as a macro: the skew and deskew registers, the clock
# root and the weights in, on the whole die with a notch for the 16
# tiles (../tpu_io.tcl); its abstract obstructs only what it occupies, so
# the notch stays free.
export DESIGN_NICKNAME = tpu_tpu_rest
export DESIGN_NAME = tpu_rest
export PLATFORM = asap7

export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/tpu/*.sv))
export SYNTH_VERILOG_SURGERY = $(DESIGN_HOME)/$(PLATFORM)/tpu/surgery.py \
  $(FLOW_HOME)/util/carve.py $(FLOW_HOME)/util/wrap_parent.py
export SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/tpu/constraint.sdc
export SYNTH_HDL_FRONTEND = slang
export LEC_CHECK = 0

export DIE_AREA = 0 0 103.68 120.96
export CORE_AREA = 1.008 1.08 102.672 119.88
export PLACE_DENSITY = 0.6
export MIN_ROUTING_LAYER = M2
export MAX_ROUTING_LAYER = M8
export IO_PLACER_H = M2 M4
export IO_PLACER_V = M3 M5
export IO_CONSTRAINTS = $(DESIGN_HOME)/$(PLATFORM)/tpu/tpu_io.tcl
export PDN_TCL = $(DESIGN_HOME)/$(PLATFORM)/tpu/pdn_macro.tcl
export WRITE_ABSTRACT_LEF_ARGS =
