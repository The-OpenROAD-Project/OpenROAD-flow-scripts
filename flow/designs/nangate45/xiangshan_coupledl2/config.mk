export PLATFORM = nangate45
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
export ADDITIONAL_LIBS = $(PLATFORM_DIR)/lib/array_2048x137_bk.lib \
                         $(PLATFORM_DIR)/lib/array_256x104.lib \
                         $(PLATFORM_DIR)/lib/array_256x13.lib \
                         $(PLATFORM_DIR)/lib/array_256x164.lib \
                         $(PLATFORM_DIR)/lib/array_256x16.lib \
                         $(PLATFORM_DIR)/lib/array_256x8_0.lib
export GDS_ALLOW_EMPTY = (fakeram.*|DFFHQN[VH][24].*|array_.*)

# Synthesis
export ABC_CLOCK_PERIOD_IN_PS = 3800
export SYNTH_HIERARCHICAL = 1
export SYNTH_MINIMUM_KEEP_SIZE ?= 10000
export SYNTH_RETIME_MODULES = $(DESIGN_NAME)
export SYNTH_HDL_FRONTEND = slang
export LEC_CHECK = 0

# Floorplan
export CORE_UTILIZATION = 70
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN = 2
export MACRO_PLACE_HALO = 10 10

# Placement and timing repair
export GPL_TIMING_DRIVEN = 0
export GPL_ROUTABILITY_DRIVEN = 0
export TNS_END_PERCENT = 5
export SKIP_CTS_REPAIR_TIMING = 1
export SKIP_INCREMENTAL_REPAIR = 1
export ENABLE_RESISTANCE_AWARE = 0

# Routing
export GLOBAL_ROUTE_ARGS = -congestion_iterations 5 -congestion_report_iter_step 5 -verbose -allow_congestion
# The nangate45 platform defaults OPT_POST_GRT_WNS to 0, which wraps recover_power in an
# incremental global_route pair even with RECOVER_POWER=0. That reroute does not receive
# -allow_congestion and fails with GRT-0116 on this congested design, so skip it. The
# post-GRT WNS repair it would enable is already disabled by SKIP_INCREMENTAL_REPAIR.
export OPT_POST_GRT_WNS = 1
export DETAILED_ROUTE_END_ITERATION = 16
export SKIP_ANTENNA_REPAIR = 1
export SKIP_ANTENNA_REPAIR_POST_DRT = 1

# PDNSim cannot connect short row-end filler stubs next to the macro halos.
export PWR_NETS_VOLTAGES =
export GND_NETS_VOLTAGES =
