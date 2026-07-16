# OpenROAD-SYN status suite for asap7.
#
# Every asap7 design gets manual <name>_syn_* targets from the config.mk
# DSL (see flow/designs/design.bzl): a synthesis-only variant "syn" flow
# with SYNTH_USE_SYN=1 forced, a QoR gate checking the synthesis-stage
# subset of the design's rules-base.json (no per-variant rules files in
# git), and a best-effort <name>_syn_qor / <name>_yosys_qor pair for the
# comparison graph. This package aggregates them:
#
#   bazelisk test //flow/designs/asap7:syn_test
#   bazelisk build //flow/designs/asap7:syn_qor_png
#
# The suite deliberately includes designs that fail OpenROAD-SYN today —
# it is a status report, not a green-only gate. A design can fail by not
# synthesizing at all, or by missing the rules-base.json gates that its
# regular flow meets (e.g. aes-block's SYN area blows past the yosys
# reference).

# Design directory -> DESIGN_NAME (bazel target prefix), ordered
# fastest-first so --keep_going runs surface quick failures early.
# Expected failures / quirks are listed last. "minimal" is excluded: it
# has no VERILOG_FILES and thus no generated design targets.
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
# the aggregators. Their generated per-design targets stay tags=["manual"]
# like all syn targets, but they are deliberately left out of syn_test and
# the QoR graph so those remain runnable; reproduce individually, e.g.
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

# Designs whose OpenROAD-SYN synthesis fails today. They stay in
# syn_test (failing honestly) and in the QoR graph (best-effort FAIL
# columns), but the clock-period plot depends on each design's generated
# synthesis rules snapshot, which these cannot produce.
# - mock-alu: SDC references yosys-style register names (*io_out_REG*)
#   absent from the SYN netlist.
# - riscv32i: slang rejects procedural assignment to nets (dmem.v).
# - mock-cpu: slang rejects endianness-mismatched part-select
#   (wptr_full.v).
SYN_FAILING_DESIGNS = [
    "mock-alu",
    "mock-cpu",
    "riscv32i",
]

# Generated synthesis QoR snapshots (rules.json from the syn variant's
# update_rules stage) for designs whose OpenROAD-SYN synthesis passes.
# These are bazel outputs, not checked-in files: the syn variant's QoR
# gate checks the synthesis subset of rules-base.json instead, so no
# rules-syn.json files live in git.
[
    filegroup(
        name = "{pkg}_syn_rules".format(pkg = pkg),
        srcs = [
            "//flow/designs/asap7/{pkg}:{name}_syn_update_rules".format(
                name = name,
                pkg = pkg,
            ),
        ],
        output_group = "rules.json",
    )
    for pkg, name in SYN_TEST_DESIGNS.items()
    if pkg not in SYN_FAILING_DESIGNS
]

# Explicitly listed manual tests DO run through a test_suite (the manual
# tag only exempts them from wildcard expansion); the suite itself is
# manual so `bazelisk test //flow/...` does not pull them in either.
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

# The syn-vs-yosys QoR comparison graph plus the runtime A/B chart. A
# plain build target: the per-design _qor inputs are best-effort (marker
# JSON on failure), so this always builds and failing designs render as
# hatched FAIL columns.
#
# Refresh the checked-in copies embedded by the status PR with:
#   bazelisk build //flow/designs/asap7:syn_qor_png
#   cp -f bazel-bin/flow/designs/asap7/openroad-syn-{qor,runtime}.png \
#       flow/docs/images/
# Effective clock period (target - gated worst slack) across stages,
# one series per design, OpenROAD-SYN synthesis point overlaid. The base
# series comes from the checked-in rules-base.json; the SYN point comes
# from the generated synthesis rules snapshot (the syn variant's
# update_rules output), so building this runs synthesis for the passing
# designs. Same refresh pattern as syn_qor_png, into
# flow/docs/images/openroad-syn-clock-period.png.
genrule(
    name = "clock_period_png",
    srcs = [
        "//flow/designs/asap7/{pkg}:rules-base.json".format(pkg = pkg)
        for pkg in SYN_TEST_DESIGNS
        if pkg not in SYN_FAILING_DESIGNS
    ] + [
        ":{pkg}_syn_rules".format(pkg = pkg)
        for pkg in SYN_TEST_DESIGNS
        if pkg not in SYN_FAILING_DESIGNS
    ],
    outs = ["openroad-syn-clock-period.png"],
    cmd = "$(location //flow/util:plotClockPeriod) --output $@ " + " ".join([
        ("--design {pkg} " +
         "--rules-base $(location //flow/designs/asap7/{pkg}:rules-base.json) " +
         "--rules-syn $(location :{pkg}_syn_rules)").format(
            pkg = pkg,
        )
        for pkg in SYN_TEST_DESIGNS
        if pkg not in SYN_FAILING_DESIGNS
    ]),
    tags = ["manual"],
    tools = ["//flow/util:plotClockPeriod"],
)

genrule(
    name = "syn_qor_png",
    srcs = [
        "//flow/designs/asap7/{pkg}:{name}_{kind}_qor".format(
            name = name,
            kind = kind,
            pkg = pkg,
        )
        for pkg, name in SYN_TEST_DESIGNS.items()
        for kind in [
            "syn",
            "yosys",
        ]
    ],
    outs = [
        "openroad-syn-qor.png",
        "openroad-syn-runtime.png",
    ],
    cmd = "$(location //flow/util:plotSynQoR) " +
          "--output $(location openroad-syn-qor.png) " +
          "--runtime-output $(location openroad-syn-runtime.png) " + " ".join([
        ("--design {pkg} " +
         "--syn $(location //flow/designs/asap7/{pkg}:{name}_syn_qor) " +
         "--base $(location //flow/designs/asap7/{pkg}:{name}_yosys_qor)").format(
            name = name,
            pkg = pkg,
        )
        for pkg, name in SYN_TEST_DESIGNS.items()
    ]),
    tags = ["manual"],
    tools = ["//flow/util:plotSynQoR"],
)
