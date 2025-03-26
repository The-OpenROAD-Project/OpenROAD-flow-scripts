#
# TODO before enablement: pipe VERILOG_DEFINES through to yosys
#

export PLATFORM               = asap7

export DESIGN_NAME            = cva6

export VERILOG_FILES          = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvfpu/src/fpnew_pkg.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/include/config_pkg.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/include/cv32a65x_config_pkg.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/include/riscv_pkg.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/include/ariane_pkg.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/vendor/pulp-platform/axi/src/axi_pkg.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/include/wt_cache_pkg.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/include/std_cache_pkg.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/include/build_config_pkg.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvxif_example/include/cvxif_instr_pkg.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/vendor/pulp-platform/common_cells/src/cf_math_pkg.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/hwpf_stride/hwpf_stride_pkg.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_pkg.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvfpu/src/fpnew_cast_multi.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvfpu/src/fpnew_classifier.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvfpu/src/fpnew_divsqrt_multi.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvfpu/src/fpnew_fma_multi.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvfpu/src/fpnew_fma.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvfpu/src/fpnew_noncomp.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvfpu/src/fpnew_opgroup_block.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvfpu/src/fpnew_opgroup_fmt_slice.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvfpu/src/fpnew_opgroup_multifmt_slice.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvfpu/src/fpnew_rounding.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvfpu/src/fpnew_top.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/defs_div_sqrt_mvp.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/control_mvp.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/div_sqrt_top_mvp.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/iteration_div_sqrt_mvp.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/norm_div_sqrt_mvp.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/nrbd_nrsc_mvp.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/preprocess_mvp.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvxif_compressed_if_driver.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvxif_issue_register_commit_if_driver.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvxif_fu.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvxif_example/instr_decoder.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvxif_example/compressed_instr_decoder.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvxif_example/copro_alu.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/vendor/pulp-platform/common_cells/src/fifo_v3.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/vendor/pulp-platform/common_cells/src/lfsr.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/vendor/pulp-platform/common_cells/src/lfsr_8bit.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/vendor/pulp-platform/common_cells/src/stream_arbiter.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/vendor/pulp-platform/common_cells/src/stream_arbiter_flushable.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/vendor/pulp-platform/common_cells/src/stream_mux.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/vendor/pulp-platform/common_cells/src/stream_demux.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/vendor/pulp-platform/common_cells/src/lzc.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/vendor/pulp-platform/common_cells/src/rr_arb_tree.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/vendor/pulp-platform/common_cells/src/shift_reg.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/vendor/pulp-platform/common_cells/src/unread.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/vendor/pulp-platform/common_cells/src/popcount.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/vendor/pulp-platform/common_cells/src/exp_backoff.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/vendor/pulp-platform/common_cells/src/counter.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/vendor/pulp-platform/common_cells/src/delta_counter.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cva6.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cva6_rvfi_probes.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/alu.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/fpu_wrap.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/branch_unit.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/compressed_decoder.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/macro_decoder.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/controller.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/zcmt_decoder.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/csr_buffer.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/csr_regfile.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/decoder.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/ex_stage.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/instr_realign.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/id_stage.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/issue_read_operands.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/issue_stage.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/load_unit.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/load_store_unit.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/lsu_bypass.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/mult.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/multiplier.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/serdiv.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/perf_counters.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/ariane_regfile_ff.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/scoreboard.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/store_buffer.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/amo_buffer.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/store_unit.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/commit_stage.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/axi_shim.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cva6_accel_first_pass_decoder_stub.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/acc_dispatcher.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cva6_fifo_v3.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/frontend/btb.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/frontend/bht.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/frontend/bht2lvl.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/frontend/ras.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/frontend/instr_scan.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/frontend/instr_queue.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/frontend/frontend.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/wt_dcache_ctrl.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/wt_dcache_mem.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/wt_dcache_missunit.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/wt_dcache_wbuffer.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/wt_dcache.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/cva6_icache.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/wt_cache_subsystem.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/wt_axi_adapter.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/tag_cmp.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/axi_adapter.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/cache_ctrl.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/cva6_icache_axi_wrapper.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/std_cache_subsystem.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/std_nbdcache.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/utils/hpdcache_mem_resp_demux.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/utils/hpdcache_mem_to_axi_read.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/utils/hpdcache_mem_to_axi_write.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/cva6_hpdcache_subsystem.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/cva6_hpdcache_subsystem_axi_arbiter.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/cva6_hpdcache_if_adapter.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/cva6_hpdcache_wrapper.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/common/macros/blackbox/hpdcache_sram_1rw.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/common/macros/blackbox/hpdcache_sram_wbyteenable_1rw.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/common/macros/blackbox/hpdcache_sram_wmask_1rw.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/pmp/src/pmp.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/pmp/src/pmp_entry.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/pmp/src/pmp_data_if.sv \
	$(PLATFORM_DIR)/verilog/fakeram7_256x32.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/common/local/util/tc_sram_wrapper.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/vendor/pulp-platform/tech_cells_generic/src/rtl/tc_sram.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/common/local/util/sram.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/common/local/util/sram_cache.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cva6_mmu/cva6_mmu.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cva6_mmu/cva6_ptw.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cva6_mmu/cva6_tlb.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cva6_mmu/cva6_shared_tlb.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/utils/hpdcache_mem_req_read_arbiter.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/utils/hpdcache_mem_req_write_arbiter.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_demux.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_lfsr.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_sync_buffer.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_fifo_reg.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_fxarb.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_rrarb.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_mux.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_decoder.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_1hot_to_binary.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_prio_1hot_encoder.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_sram.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_sram_wbyteenable.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_sram_wmask.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_regbank_wbyteenable_1rw.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_regbank_wmask_1rw.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_data_downsize.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_data_upsize.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_data_resize.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/hwpf_stride/hwpf_stride.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/hwpf_stride/hwpf_stride_arb.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/hwpf_stride/hwpf_stride_wrapper.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_amo.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_cmo.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_core_arbiter.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_ctrl.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_ctrl_pe.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_memctrl.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_miss_handler.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_mshr.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_rtab.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_uncached.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_victim_plru.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_victim_random.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_victim_sel.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_wbuf.sv \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/src/hpdcache_flush.sv

export VERILOG_INCLUDE_DIRS = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/include \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cvfpu/src/common_cells/include \
	$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/cache_subsystem/hpdcache/rtl/include

export VERILOG_DEFINES += -D HPDCACHE_ASSERT_OFF

export ADDITIONAL_LEFS = $(PLATFORM_DIR)/lef/fakeram7_256x32.lef

export ADDITIONAL_LIBS = $(PLATFORM_DIR)/lib/NLDM/fakeram7_256x32.lib

export SDC_FILE               = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

export DIE_AREA               = 0 0 250 250
export CORE_AREA              = 1.08 1.08 240 240

export PLACE_DENSITY          = 0.50

# a smoketest for this option, there are a
# few last gasp iterations
export SKIP_LAST_GASP ?= 1


export SYNTH_USE_SLANG = 1
