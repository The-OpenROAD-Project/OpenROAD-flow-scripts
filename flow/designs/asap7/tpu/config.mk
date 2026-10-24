export PLATFORM = asap7
export DESIGN_NAME = tpu

export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/tpu/*.sv))
export SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export SYNTH_HDL_FRONTEND = slang
export LEC_CHECK = 0

# Every macro, and tpu itself, routes on M2-M8; M9 brings power from
# the level above. tpu's pins are all on its bottom edge: it is a macro
# that abuts its parent.
export MIN_ROUTING_LAYER = M2
export MAX_ROUTING_LAYER = M8
export IO_PLACER_H = M2 M4
export IO_PLACER_V = M3 M5

ifeq ($(FLOW_VARIANT),flat)
# The reference: tpu flat, from its RTL, every pin on its bottom edge.
export CORE_UTILIZATION = 60
export PLACE_DENSITY = 0.65
export IO_CONSTRAINTS = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/pins_bottom.tcl
export PDN_TCL = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/pdn_macro.tcl
else
# 16 tiles of 2 x 2 processing elements, and the rest of tpu built as a
# C-shaped macro around them (surgery.py carves the netlist): the top
# level is those 17 macros, abutted, and wires.
export BLOCKS = tpu_block tpu_rest
export SYNTH_VERILOG_SURGERY = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/surgery.py \
  $(FLOW_HOME)/util/carve.py $(FLOW_HOME)/util/wrap_parent.py
# the C's die: the tiles and the C cover it
export DIE_AREA = 0 0 103.68 120.96
export CORE_AREA = 0 0 103.68 120.96
# no standard cell at the top: its ports are the C's pins
export DONT_BUFFER_PORTS = 1
export IO_CONSTRAINTS = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/io_top.tcl
export MACRO_PLACEMENT_TCL = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/place.tcl
export PDN_TCL = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/pdn_top.tcl
export TAPCELL_TCL = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/tapcell_none.tcl
# detail_place, cts and grt each legalize: nothing at the top is movable
export PRE_DETAIL_PLACE_TCL = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/dpl_none.tcl
export PRE_CTS_TCL = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/dpl_none.tcl
export PRE_GLOBAL_ROUTE_TCL = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/dpl_none.tcl
endif
