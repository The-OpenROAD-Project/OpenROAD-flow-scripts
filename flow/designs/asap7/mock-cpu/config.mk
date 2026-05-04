export PLATFORM               = asap7

export DESIGN_NAME            = mock_cpu
export DESIGN_NICKNAME        = mock-cpu

export VERILOG_FILES = $(wildcard $(DESIGN_HOME)/src/fifo/*.v)
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
export SDC_FILE_EXTRA = $(DESIGN_HOME)/src/mock-array/util.tcl

# The SDC references fifo_in/<pin> and fifo_out/<pin> directly. Two
# knobs must agree to make those pin paths resolve in OpenSTA:
#
#   1. Yosys must keep the fifo1 module boundary through flattening.
#      SYNTH_KEEP_MODULES doesn't work here because hierarchy elaboration
#      specializes fifo1 into $paramod$<hash>\fifo1 before the flow's
#      keep loop runs — instead we use an (* keep_hierarchy *) RTL
#      attribute on the module itself (see src/fifo/fifo1.v).
#
#   2. OpenROAD must link the netlist hierarchically, otherwise
#      link_design flattens the fifo_in / fifo_out instances even though
#      Yosys preserved them. OPENROAD_HIERARCHICAL=1 switches link_design
#      to -hier mode. (Same mechanism used by asap7/mock-alu, cva6,
#      swerv_wrapper.)
export OPENROAD_HIERARCHICAL = 1

export CORE_UTILIZATION         = 40
export CORE_ASPECT_RATIO        = 1
export CORE_MARGIN              = 2
export PLACE_DENSITY            = 0.71
export TNS_END_PERCENT          = 100

export IO_CONSTRAINTS        = designs/asap7/mock-cpu/io.tcl

