export PLATFORM               = asap7

export DESIGN_NAME            = cva6

# Some files are listed specifically vs. sorted wildcard to control the order
# (makes Verific happy)
export SRC_HOME = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)
export VERILOG_FILES          = $(sort $(wildcard $(SRC_HOME)/common/local/util/*.sv)) \
	$(SRC_HOME)/core/include/config_pkg.sv \
	$(SRC_HOME)/core/include/cv32a65x_config_pkg.sv \
	$(SRC_HOME)/core/include/riscv_pkg.sv \
	$(SRC_HOME)/core/include/ariane_pkg.sv \
	$(SRC_HOME)/core/include/build_config_pkg.sv \
	$(SRC_HOME)/core/include/std_cache_pkg.sv \
	$(SRC_HOME)/core/include/wt_cache_pkg.sv \
	$(sort $(wildcard $(SRC_HOME)/vendor/pulp-platform/common_cells/src/*.sv)) \
	$(SRC_HOME)/core/cvfpu/src/fpnew_pkg.sv \
	$(sort $(wildcard $(SRC_HOME)/vendor/pulp-platform/axi/src/*.sv)) \
	$(SRC_HOME)/core/cvfpu/src/fpnew_cast_multi.sv \
	$(SRC_HOME)/core/cvfpu/src/fpnew_classifier.sv \
	$(SRC_HOME)/core/cvfpu/src/fpnew_divsqrt_multi.sv \
	$(SRC_HOME)/core/cvfpu/src/fpnew_fma.sv \
	$(SRC_HOME)/core/cvfpu/src/fpnew_fma_multi.sv \
	$(SRC_HOME)/core/cvfpu/src/fpnew_noncomp.sv \
	$(SRC_HOME)/core/cvfpu/src/fpnew_opgroup_block.sv \
	$(SRC_HOME)/core/cvfpu/src/fpnew_opgroup_fmt_slice.sv \
	$(SRC_HOME)/core/cvfpu/src/fpnew_opgroup_multifmt_slice.sv \
	$(SRC_HOME)/core/cvfpu/src/fpnew_rounding.sv \
	$(SRC_HOME)/core/cvfpu/src/fpnew_top.sv \
	$(sort $(wildcard $(SRC_HOME)/core/*.sv)) \
	$(sort $(wildcard $(SRC_HOME)/core/pmp/src/*.sv)) \
	$(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_pkg.sv \
	$(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache.sv \
	$(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_amo.sv \
	$(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_cmo.sv \
	$(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_core_arbiter.sv \
	$(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_ctrl.sv \
	$(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_ctrl_pe.sv \
	$(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_flush.sv \
	$(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_memctrl.sv \
	$(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_miss_handler.sv \
	$(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_mshr.sv \
	$(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_rtab.sv \
	$(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_uncached.sv \
	$(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_victim_plru.sv \
	$(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_victim_random.sv \
	$(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_victim_sel.sv \
	$(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_wbuf.sv \
	$(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/hwpf_stride/hwpf_stride_pkg.sv \
	$(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/hwpf_stride/hwpf_stride.sv \
	$(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/hwpf_stride/hwpf_stride_arb.sv \
	$(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/hwpf_stride/hwpf_stride_wrapper.sv \
	$(sort $(wildcard $(SRC_HOME)/core/cache_subsystem/*.sv)) \
	$(sort $(wildcard $(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/common/*.sv)) \
	$(sort $(wildcard $(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/common/macros/blackbox/*.sv)) \
	$(sort $(wildcard $(SRC_HOME)/core/cache_subsystem/hpdcache/rtl/src/utils/*.sv)) \
	$(sort $(wildcard $(SRC_HOME)/core/cva6_mmu/*.sv)) \
	$(SRC_HOME)/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/defs_div_sqrt_mvp.sv \
	$(SRC_HOME)/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/control_mvp.sv \
	$(SRC_HOME)/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/div_sqrt_top_mvp.sv \
	$(SRC_HOME)/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/iteration_div_sqrt_mvp.sv \
	$(SRC_HOME)/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/norm_div_sqrt_mvp.sv \
	$(SRC_HOME)/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/nrbd_nrsc_mvp.sv \
	$(SRC_HOME)/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/preprocess_mvp.sv \
	$(SRC_HOME)/core/cvxif_example/include/cvxif_instr_pkg.sv \
	$(sort $(wildcard $(SRC_HOME)/core/frontend/*.sv)) \
	$(SRC_HOME)/vendor/pulp-platform/tech_cells_generic/src/rtl/tc_sram.sv \
	$(PLATFORM_DIR)/verilog/fakeram7_64x256.sv \
	$(PLATFORM_DIR)/verilog/fakeram7_128x64.sv \
	$(PLATFORM_DIR)/verilog/fakeram7_64x28.sv \
	$(PLATFORM_DIR)/verilog/fakeram7_64x25.sv

export VERILOG_INCLUDE_DIRS = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/include \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvfpu/src/common_cells/include \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/include

export VERILOG_DEFINES += -D HPDCACHE_ASSERT_OFF

export ADDITIONAL_LEFS = $(PLATFORM_DIR)/lef/fakeram7_64x256.lef \
			 $(PLATFORM_DIR)/lef/fakeram7_128x64.lef \
			 $(PLATFORM_DIR)/lef/fakeram7_64x28.lef \
			 $(PLATFORM_DIR)/lef/fakeram7_64x25.lef

export ADDITIONAL_LIBS = $(PLATFORM_DIR)/lib/NLDM/fakeram7_64x256.lib \
			 $(PLATFORM_DIR)/lib/NLDM/fakeram7_128x64.lib \
			 $(PLATFORM_DIR)/lib/NLDM/fakeram7_64x28.lib \
			 $(PLATFORM_DIR)/lib/NLDM/fakeram7_64x25.lib

export SDC_FILE               = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export CORE_UTILIZATION       = 70
export CORE_MARGIN            = 2
export MACRO_PLACE_HALO       = 3 3
export PLACE_DENSITY          = 0.69

# a smoketest for this option, there are a
# few last gasp iterations
#export SKIP_LAST_GASP ?= 1

# For use with SYNTH_HIERARCHICAL
export SYNTH_MINIMUM_KEEP_SIZE ?= 40000

export SYNTH_HDL_FRONTEND = slang

export ASAP7_USE_VT = RVT LVT SLVT

export CTS_LIB_NAME = asap7sc7p5t_INVBUF_SLVT_FF_nldm_211120

# Remove rvfi_probes_o interface
export SYNTH_CANONICALIZE_TCL = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/canonicalize.tcl
