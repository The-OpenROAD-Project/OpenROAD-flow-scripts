load("@bazel-orfs//:openroad.bzl", "orfs_run")
load("@orfs_designs//:designs.bzl", "DESIGNS")
load("@rules_shell//shell:sh_test.bzl", "sh_test")
load("//flow/designs:design.bzl", "design")

# SYNTH_USE_SYN is make-only for now: bazel-orfs's synth stage always
# runs the yosys flow and neither stages the Verilog sources nor sets
# VERILOG_FILES for the OpenROAD synthesis step, so the built-in
# synthesizer opt-in must not reach the bazel arguments.
design(
    config = "config.mk",
    local_arguments = ["SYNTH_USE_SYN"],
)

# Stage-boundary .odb/.sdc stems shared by the normal per-stage flow
# targets and the single-process flow below; the gcd_single_flow_test
# suite compares each of these files pairwise between the two flows.
SINGLE_FLOW_STAGES = {
    "synth": "1_synth",
    "floorplan": "2_floorplan",
    "place": "3_place",
    "cts": "4_cts",
    "grt": "5_1_grt",
    "route": "5_route",
    "final": "6_final",
}

# Substep files the single-process flow also writes, declared so the
# action keeps them and a human can inspect them on failure.
SINGLE_FLOW_EXTRA_OUTS = [
    "2_1_floorplan.odb",
    "2_1_floorplan.sdc",
    "2_2_floorplan_macro.odb",
    "2_3_floorplan_tapcell.odb",
    "2_4_floorplan_pdn.odb",
    "3_1_place_gp_skip_io.odb",
    "3_2_place_iop.odb",
    "3_3_place_gp.odb",
    "3_4_place_resized.odb",
    "3_5_place_dp.odb",
    "4_1_cts.odb",
    "5_2_route.odb",
    "5_3_fillcell.odb",
    "6_1_fill.odb",
    "6_1_fill.sdc",
]

# The whole flow, yosys netlist through finish, as one Tcl script in a
# single OpenROAD process (scripts/flow.tcl) with
# WRITE_ODB_AND_SDC_EACH_STAGE=0: the stage scripts write no .odb/.sdc
# files (flow.tcl errors if one does), the top level writes every file
# the per-stage flow produces via explicit write_db/write_sdc. The
# synth stage config only carries synth-scoped variables, so the
# design's full argument set rides along; FLOW_VARIANT=single keeps the
# output paths clear of the regular stage targets' declared outputs in
# this package.
orfs_run(
    name = "gcd_single_flow",
    src = ":gcd_synth",
    outs = [
        "results/asap7/gcd/single/{}.{}".format(stem, ext)
        for stem in SINGLE_FLOW_STAGES.values()
        for ext in [
            "odb",
            "sdc",
        ]
    ] + [
        "results/asap7/gcd/single/" + name
        for name in SINGLE_FLOW_EXTRA_OUTS
    ],
    arguments = {
        k: v
        for k, v in DESIGNS["asap7/gcd"]["arguments"].items()
        if k != "SYNTH_USE_SYN"
    } | {
        "FLOW_VARIANT": "single",
    },
    script = ":single_flow.tcl",
    variant = "single",
)

# Normal-flow stage outputs, one filegroup per compared file.
[
    filegroup(
        name = "gcd_base_{}_{}".format(stage, ext),
        srcs = [":gcd_" + stage],
        output_group = "{}.{}".format(stem, ext),
    )
    for stage, stem in SINGLE_FLOW_STAGES.items()
    for ext in [
        "odb",
        "sdc",
    ]
]

# Byte-compare each stage boundary's .odb/.sdc between the per-stage
# flow and the single-process flow: equal files prove the
# single-process mode is equivalent to the per-stage flow, not merely
# that it runs to completion. check_same.sh takes file pairs:
# file_a file_b ... (.sdc pair first: check_same.sh stops at a binary
# diff, and the .sdc verdict should be reported before that).
#
# Known divergence, deliberately left failing so it gets root-caused
# rather than papered over: from the grt stage on, the grt-stage
# repair_timing inserts one extra buffer (8 vs 7 on asap7/gcd) when the
# process continues from the in-memory CTS state instead of reloading
# 4_cts.odb, even though the 4_cts.odb/.sdc it starts from are
# byte-identical (all .sdc match through the whole flow).
[
    sh_test(
        name = "gcd_single_flow_{}_test".format(stage),
        srcs = ["@openroad//test/orfs:check_same.sh"],
        args = [
            arg
            for ext in [
                "sdc",
                "odb",
            ]
            for arg in [
                "$(location :gcd_base_{}_{})".format(stage, ext),
                "$(location :results/asap7/gcd/single/{}.{})".format(stem, ext),
            ]
        ],
        data = [
            ":gcd_base_{}_{}".format(stage, ext)
            for ext in [
                "sdc",
                "odb",
            ]
        ] + [
            ":results/asap7/gcd/single/{}.{}".format(stem, ext)
            for ext in [
                "sdc",
                "odb",
            ]
        ],
        tags = ["orfs"],
    )
    for stage, stem in SINGLE_FLOW_STAGES.items()
]

test_suite(
    name = "gcd_single_flow_test",
    tests = [
        ":gcd_single_flow_{}_test".format(stage)
        for stage in SINGLE_FLOW_STAGES
    ],
)
