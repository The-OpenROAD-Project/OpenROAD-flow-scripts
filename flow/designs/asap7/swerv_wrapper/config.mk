export DESIGN_NAME = swerv_wrapper
export PLATFORM    = asap7

# SYNTH_KEEP_MODULES below is a captured list of kept modules
# with:
#
# make SYNTH_HIERARCHICAL=1 SYNTH_KEEP_MODULES= clean_synth synth
#
# To list modules with the keep_hiearchy=1 attribute, run:
#
# make run-yosys RUN_YOSYS_ARGS=-C
#
# source scripts/yosys_load.tcl
# ls A:keep_hierarchy=1
export SYNTH_KEEP_MODULES ?= \
  IC_DATA_ICACHE_TAG_HIGH12_ICACHE_TAG_LOW6_ICACHE_IC_DEPTH8 \
  IC_TAG_ICACHE_TAG_HIGH12_ICACHE_TAG_LOW6_ICACHE_TAG_DEPTH64 \
  dbg \
  dec_decode_ctl \
  dec_gpr_ctl_GPR_BANKS1_GPR_BANKS_LOG21 \
  dec_ib_ctl \
  dec_tlu_ctl \
  dec_trigger \
  dma_ctrl \
  exu \
  exu_alu_ctl \
  exu_div_ctl \
  ifu_aln_ctl \
  ifu_bp_ctl \
  ifu_ifc_ctl \
  ifu_mem_ctl \
  lsu_bus_buffer \
  lsu_bus_intf \
  lsu_dccm_ctl \
  lsu_dccm_mem \
  lsu_ecc \
  lsu_lsc_ctl \
  lsu_stbuf \
  lsu_trigger \
  pic_ctrl \
  ram_2048x39 \
  ram_256x34


export LIB_MODEL = CCS

# The sv2v'd RTL instantiates OPENROAD_CLKGATE directly, so the clkgate
# mapping model is a source file rather than a synthesis techmap input.
# Spelled as a resolved path on purpose: bazel-orfs's config.mk parser
# cannot evaluate the make functions behind $(PRIMARY_VT_TAG), so
# $(CLKGATE_MAP_FILE) is dropped when the file list is turned into bazel
# labels, and elaboration then fails with `unknown module
# 'OPENROAD_CLKGATE'`. This path is what $(CLKGATE_MAP_FILE) expands to
# for the platform's default PRIMARY_VT (RVT); it must be kept in step
# with that default, and with ASAP7_USE_VT if this design ever sets it.
export VERILOG_FILES = $(DESIGN_HOME)/src/swerv/swerv_wrapper.sv2v.v \
                       $(DESIGN_HOME)/$(PLATFORM)/swerv_wrapper/macros.v \
                       $(PLATFORM_DIR)/yoSys/cells_clkgate_R.v
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/swerv_wrapper/constraint.sdc

export ADDITIONAL_LEFS = $(sort $(wildcard $(DESIGN_HOME)/$(PLATFORM)/swerv_wrapper/lef/*.lef))
export ADDITIONAL_LIBS = $(sort $(wildcard $(DESIGN_HOME)/$(PLATFORM)/swerv_wrapper/lib/*.lib))

export CORE_UTILIZATION = 30

export IO_CONSTRAINTS     = $(DESIGN_HOME)/$(PLATFORM)/swerv_wrapper/io.tcl
export PLACE_DENSITY_LB_ADDON = 0.20

export ROUTING_LAYER_ADJUSTMENT = 0.2

# Use OpenROAD-native synthesis (SYN) instead of Yosys. SWAP_ARITH_OPERATORS
# removed: its wrapped-operator flow is Yosys-only and unsupported by SYN.
export SYNTH_USE_SYN = 1
export OPENROAD_HIERARCHICAL = 1

export GPL_RANDOM_SEED = 2
