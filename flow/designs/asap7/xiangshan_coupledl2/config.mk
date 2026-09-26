export PLATFORM = asap7
export DESIGN_NAME = CoupledL2
export DESIGN_NICKNAME = xiangshan_coupledl2

export VERILOG_FILES = $(sort \
  $(wildcard $(DESIGN_HOME)/src/xiangshan_coupledl2/*.sv) \
  $(wildcard $(DESIGN_HOME)/src/xiangshan_coupledl2/deps/*.sv)) \
  $(PLATFORM_DIR)/verilog/array_2048x137_bk_bb.sv \
  $(PLATFORM_DIR)/verilog/array_256x104_bb.sv \
  $(PLATFORM_DIR)/verilog/array_256x13_bb.sv \
  $(PLATFORM_DIR)/verilog/array_256x164_bb.sv \
  $(PLATFORM_DIR)/verilog/array_256x16_bb.sv \
  $(PLATFORM_DIR)/verilog/array_256x8_0_bb.sv
export VERILOG_DEFINES += -D SYNTHESIS
export SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

# Fakeram macros for the SRAM arrays; fakeram.cfg in this directory records how
# the platform views were generated.
export ADDITIONAL_LEFS = $(PLATFORM_DIR)/lef/array_2048x137_bk.lef \
                         $(PLATFORM_DIR)/lef/array_256x104.lef \
                         $(PLATFORM_DIR)/lef/array_256x13.lef \
                         $(PLATFORM_DIR)/lef/array_256x164.lef \
                         $(PLATFORM_DIR)/lef/array_256x16.lef \
                         $(PLATFORM_DIR)/lef/array_256x8_0.lef
export ADDITIONAL_LIBS = $(PLATFORM_DIR)/lib/NLDM/array_2048x137_bk.lib \
                         $(PLATFORM_DIR)/lib/NLDM/array_256x104.lib \
                         $(PLATFORM_DIR)/lib/NLDM/array_256x13.lib \
                         $(PLATFORM_DIR)/lib/NLDM/array_256x164.lib \
                         $(PLATFORM_DIR)/lib/NLDM/array_256x16.lib \
                         $(PLATFORM_DIR)/lib/NLDM/array_256x8_0.lib
export GDS_ALLOW_EMPTY = (fakeram.*|DFFHQN[VH][24].*|array_.*)

export ASAP7_USE_VT = RVT LVT SLVT

# Synthesis
export SYNTH_HIERARCHICAL = 1
export SYNTH_MINIMUM_KEEP_SIZE ?= 10000
export SYNTH_HDL_FRONTEND = slang
export LEC_CHECK = 0

# Floorplan
export CORE_UTILIZATION = 50
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN = 2
export MACRO_PLACE_HALO = 5 5

# Placement and timing repair
export GPL_TIMING_DRIVEN = 0
export GPL_ROUTABILITY_DRIVEN = 0
export TNS_END_PERCENT = 5
export SKIP_CTS_REPAIR_TIMING = 1
export SKIP_INCREMENTAL_REPAIR = 1
export ENABLE_RESISTANCE_AWARE = 0

# Routing
export GLOBAL_ROUTE_ARGS = -congestion_iterations 5 -congestion_report_iter_step 5 -verbose -allow_congestion
# FlexDR on current master reports DRT-0206 terminal-connectivity errors for
# this design, so detailed routing is skipped and the Final report uses
# global-route estimated parasitics.
export SKIP_DETAILED_ROUTE = 1
export DETAILED_ROUTE_END_ITERATION = 32
export SKIP_ANTENNA_REPAIR = 1
export SKIP_ANTENNA_REPAIR_POST_DRT = 1
