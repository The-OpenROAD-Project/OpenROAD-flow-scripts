# OpenROAD-SYN test suites for asap7 — the local counterpart of the
# Jenkins QoR signal (https://dashboard.precisioninno.com/).
#
# Every design gets manual forced-engine flow variants from the
# config.mk DSL (see flow/designs/design.bzl): <name>_syn_* pins
# SYNTH_USE_SYN=1 and <name>_yosys_* pins the yosys engine, regardless
# of the config.mk default. Designs with a rules-base.json get two QoR
# gates per variant, both checking the design's regular rules file with
# the regular checkMetadata.py — congruent with what Jenkins measures:
#
#   bazelisk test --keep_going //flow/designs/asap7:syn_synth_test
#     Fast tier: synthesis only, checks the synth__/constraints__ subset
#     of rules-base.json. Minutes-scale; QoR-only (no LEC), so it cannot
#     prove correctness — use it to iterate, not to conclude.
#
#   bazelisk test --keep_going //flow/designs/asap7:syn_test
#     Full flow, all rules-base.json gates. The real signal; shares its
#     synthesis action with the fast tier.
#
# Sharpening the loop on one design or stage:
#
#   bazelisk test //flow/designs/asap7/jpeg:jpeg_encoder_syn_synth_test
#   bazelisk test //flow/designs/asap7/jpeg:jpeg_encoder_syn_test
#   bazelisk build //flow/designs/asap7/jpeg:jpeg_encoder_syn_route
#   bazelisk test //flow/designs/asap7/gcd:gcd_yosys_test   # yosys A/B
#
# Both suites deliberately include designs that fail OpenROAD-SYN today
# — they are a status signal, not a green-only gate. A design can fail
# by not synthesizing at all, or by missing rules-base.json gates that
# its regular flow meets.

# Design directory -> DESIGN_NAME (bazel target prefix), ordered
# fastest-first so --keep_going runs surface quick failures early.
# Known failures / quirks are listed last. "minimal" is excluded: it
# has no VERILOG_FILES and thus no generated design targets.
#
# Known OpenROAD-SYN failures today:
# - mock-alu: SDC references yosys-style register names (*io_out_REG*)
#   absent from the SYN netlist.
# - riscv32i: slang rejects procedural assignment to nets (dmem.v).
# - mock-cpu: slang rejects endianness-mismatched part-select
#   (wptr_full.v).
# - aes-block: hierarchical BLOCKS; synthesizes, but SYN area blows past
#   the yosys-derived rules-base.json gate.
SYN_TEST_DESIGNS = {
    "gcd": "gcd",  # smoketest, fast
    "uart": "uart",
    "mock-alu": "MockAlu",
    "riscv32i": "riscv_top",
    "aes": "aes_cipher_top",
    "aes_lvt": "aes_cipher_top",
    "aes-mbff": "aes_cipher_top",
    "jpeg": "jpeg_encoder",
    "jpeg_lvt": "jpeg_encoder",
    "ethmac": "ethmac",
    "ethmac_lvt": "ethmac",
    "mock-cpu": "mock_cpu",
    "gcd-ccs": "gcd",  # CCS liberty
    "aes-block": "aes_cipher_top",  # hierarchical BLOCKS
}

# Designs whose OpenROAD-SYN run is too slow (or does not terminate) for
# the suites. Their generated per-design targets stay tags=["manual"]
# like all forced-engine targets, but they are deliberately left out of
# the suites so those remain runnable; reproduce individually, e.g.
#   bazelisk build //flow/designs/asap7/ibex:ibex_core_syn_synth
#
# - ibex: sv_elaborate/synthesize/repair_design complete in seconds, but
#   report_metrics ("Report metrics stage 1, synth...") spins in STA for
#   hours (observed >2h on 48 threads with no progress).
# - cva6: synthesize itself takes ~73s, but repair_design -pre_placement
#   was still running after 10+ minutes when the status sweep was cut
#   off; not yet characterized to completion.
# - swerv_wrapper: largest design in the suite; not yet run to
#   completion under OpenROAD-SYN in this environment.
# - riscv32i-mock-sram: hierarchical BLOCKS (fakeram) — the syn variant
#   first needs the block's full PnR flow for its abstract; not yet run
#   to completion.
SYN_SLOW_DESIGNS = {
    "cva6": "cva6",
    "ibex": "ibex_core",
    "riscv32i-mock-sram": "riscv_top",
    "swerv_wrapper": "swerv_wrapper",
}

# Explicitly listed manual tests DO run through a test_suite (the manual
# tag only exempts them from wildcard expansion); the suites themselves
# are manual so `bazelisk test //flow/...` does not pull them in either.
test_suite(
    name = "syn_test",
    tags = ["manual"],
    tests = [
        "//flow/designs/asap7/{pkg}:{name}_syn_test".format(
            name = name,
            pkg = pkg,
        )
        for pkg, name in SYN_TEST_DESIGNS.items()
    ],
)

test_suite(
    name = "syn_synth_test",
    tags = ["manual"],
    tests = [
        "//flow/designs/asap7/{pkg}:{name}_syn_synth_test".format(
            name = name,
            pkg = pkg,
        )
        for pkg, name in SYN_TEST_DESIGNS.items()
    ],
)
