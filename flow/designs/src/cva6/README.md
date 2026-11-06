Extracted from https://github.com/openhwgroup/cva6

Based on commit 3a389af (cv-hpdcache 04de808, cvfpu 3116391).

The RAMs are upstream's, unmodified: `asap7/cva6` makes them macros with
AUTO_MEMORIES, and puts the I-cache's behind `sram_cache`'s techno cut
with SYNTH_VERILOG_SURGERY (`asap7/cva6/surgery.py`).

Changed from upstream, tie-offs for outputs or struct fields cv32a65x
leaves undriven: `core/cache_subsystem/cva6_hpdcache_if_adapter.sv`,
`core/cache_subsystem/cva6_hpdcache_wrapper.sv`,
`core/cache_subsystem/hpdcache/rtl/src/hwpf_stride/hwpf_stride.sv`,
`core/csr_regfile.sv` (`debug_mode_o` gated by `DebugEn`),
`core/cva6_mmu/cva6_mmu.sv`, `core/cvxif_fu.sv`, `core/id_stage.sv`,
`core/load_store_unit.sv` and `core/load_unit.sv`.
