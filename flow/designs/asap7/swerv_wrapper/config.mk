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

export VERILOG_FILES = $(DESIGN_HOME)/src/swerv/swerv_wrapper.sv2v.v \
                       $(DESIGN_HOME)/$(PLATFORM)/swerv_wrapper/macros.v
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/swerv_wrapper/constraint.sdc

export ADDITIONAL_LEFS = $(sort $(wildcard $(DESIGN_HOME)/$(PLATFORM)/swerv_wrapper/lef/*.lef))
export ADDITIONAL_LIBS = $(sort $(wildcard $(DESIGN_HOME)/$(PLATFORM)/swerv_wrapper/lib/*.lib))

export DIE_AREA    = 0 0 550 600
export CORE_AREA   = 5 5 545 595 

export IO_CONSTRAINTS     = $(DESIGN_HOME)/$(PLATFORM)/swerv_wrapper/io.tcl
export PLACE_DENSITY_LB_ADDON = 0.20

export ROUTING_LAYER_ADJUSTMENT = 0.2
