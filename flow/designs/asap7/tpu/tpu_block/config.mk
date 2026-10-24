# The tile: 2 x 2 processing elements, carved out of tpu (../surgery.py),
# its pins planned with the C's (../tpu_io.tcl).
export DESIGN_NICKNAME = tpu_tpu_block
export DESIGN_NAME = tpu_block
export PLATFORM = asap7

export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/tpu/*.sv))
export SYNTH_VERILOG_SURGERY = $(DESIGN_HOME)/$(PLATFORM)/tpu/surgery.py \
  $(FLOW_HOME)/util/carve.py $(FLOW_HOME)/util/wrap_parent.py
export SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/tpu/tpu_block/constraint.sdc
export SYNTH_HDL_FRONTEND = slang
export LEC_CHECK = 0

export DIE_AREA = 0 0 24.336 25.92
export CORE_AREA = 1.008 1.08 23.328 24.84
export MIN_ROUTING_LAYER = M2
export MAX_ROUTING_LAYER = M8
export IO_PLACER_H = M2 M4
export IO_PLACER_V = M3 M5
export IO_CONSTRAINTS = $(DESIGN_HOME)/$(PLATFORM)/tpu/tpu_io.tcl
export PDN_TCL = $(DESIGN_HOME)/$(PLATFORM)/tpu/pdn_macro.tcl

# the settings a search over placement density, padding, clock tree
# clustering and global route layer adjustment found best
export PLACE_DENSITY = 0.634
export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 1
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 0
export CTS_CLUSTER_SIZE = 184
export CTS_CLUSTER_DIAMETER = 353
export ROUTING_LAYER_ADJUSTMENT = 0.137
