load("@bazel-orfs//:openroad.bzl", "orfs_pdk")
load("//flow/designs:design.bzl", "lec_check_targets", "lec_test_targets")

# Expose every individual file under platforms/ as a public source-file
# target, so designs in other packages can refer to e.g.
# //flow:platforms/asap7/verilog/fakeram7_64x28.sv directly. This is the
# label form bazel-orfs's config_mk_parser produces for VERILOG_FILES /
# ADDITIONAL_LEFS / ADDITIONAL_LIBS that point at platform-provided files.
# Exclude package BUILD files so they aren't claimed as source labels by
# any future sub-package under platforms/.
exports_files(
    glob(
        ["platforms/**/*"],
        exclude = [
            "platforms/**/BUILD",
            "platforms/**/BUILD.bazel",
        ],
    ),
    visibility = ["//visibility:public"],
)

# Expose synth.tcl as an addressable source label so bazel-orfs can
# point its `_synth_tcl` attr default at `@orfs//flow:scripts/synth.tcl`
# instead of vendoring its own (drifting) copy at the bazel-orfs repo
# root. See bazel-orfs `private/rules.bzl`.
exports_files(
    ["scripts/synth.tcl"],
    visibility = ["//visibility:public"],
)

# files shared between scripts/synth.sh and scripts/flow.sh steps
MAKEFILE_SHARED = [
    "scripts/variables.json",
    "scripts/*.py",
    "scripts/*.sh",
    "scripts/*.yaml",
    "scripts/*.mk",
]

# makefile and scripts used by script/synth.sh steps
filegroup(
    name = "makefile_yosys",
    srcs = ["Makefile"],
    data = glob(MAKEFILE_SHARED + [
        "scripts/*.script",
        "scripts/*.v",
        "scripts/util.tcl",
        "scripts/synth*.tcl",
        "scripts/synth*.v",
        "platforms/common/**/*.v",
    ]) + [
        "//flow/util:makefile_yosys",
    ],
    visibility = ["//visibility:public"],
)

# makefile and scripts used in the scripts/flow.sh steps
filegroup(
    name = "makefile",
    srcs = ["Makefile"],
    data = glob(MAKEFILE_SHARED + [
        "scripts/*.tcl",
        "platforms/common/**/*.v",
    ]) + [
        "//flow/util:makefile",
    ],
    visibility = ["//visibility:public"],
)

[orfs_pdk(
    name = pdk,
    srcs = glob([
        "platforms/{pdk}/**/*.{ext}".format(
            ext = ext,
            pdk = pdk,
        )
        for ext in {
            "asap7": [
                "cfg",
                "gds",
                "lef",
                "lib",
                "lib.gz",
                "lyt",
                "mk",
                "rules",
                "sdc",
                "sv",
                "tcl",
                "v",
            ],
            "gf180": [
                "cfg",
                "gds",
                "lef",
                "lib.gz",
                "lyt",
                "mk",
                "rules",
                "tcl",
                "v",
            ],
            "ihp-sg13g2": [
                "gds",
                "json",
                "lef",
                "lib",
                "lyt",
                "mk",
                "rules",
                "tcl",
                "v",
            ],
            "nangate45": [
                "cfg",
                "gds",
                "lef",
                "lib",
                "lyt",
                "mk",
                "rules",
                "tcl",
                "v",
            ],
            "sky130hd": [
                "gds",
                "lef",
                "lib",
                "lyt",
                "mk",
                "rules",
                "tcl",
                "tlef",
                "v",
            ],
            "sky130hs": [
                "gds",
                "lef",
                "lib",
                "lyt",
                "mk",
                "rules",
                "tcl",
                "tlef",
                "v",
            ],
        }.get(pdk, [])
    ] + [
        "platforms/common/**/*.v",
    ]),
    config = ":platforms/{pdk}/config.mk".format(pdk = pdk),
    libs = glob([
        "platforms/{pdk}/**/*.{ext}".format(
            ext = ext,
            pdk = pdk,
        )
        for ext in {
            "asap7": [
                "lib",
                "lib.gz",
            ],
            "gf180": ["lib.gz"],
        }.get(
            pdk,
            ["lib"],
        )
    ]),
    visibility = ["//visibility:public"],
) for pdk in [
    "asap7",
    "gf180",
    "ihp-sg13g2",
    "nangate45",
    "sky130hd",
    "sky130hs",
]]

# Single-corner (typical) liberty sets per platform for kepler-formal
# LEC: kepler-formal needs cell definitions, not timing corners, and
# feeding it the same cells at several corners would double-define
# them. Design-specific macro libs come in via ADDITIONAL_LIBS (see
# lec_liberty in flow/designs/design.bzl).
[filegroup(
    name = pdk + "_lec_libs",
    srcs = glob(patterns),
    visibility = ["//visibility:public"],
) for pdk, patterns in {
    "asap7": ["platforms/asap7/lib/NLDM/*_TT_*.lib*"],
    "gf180": ["platforms/gf180/lib/*__tt_025C_5v00.lib.gz"],
    "ihp-sg13g2": ["platforms/ihp-sg13g2/lib/*_typ_*.lib"],
    "nangate45": ["platforms/nangate45/lib/*.lib"],
    "sky130hd": ["platforms/sky130hd/lib/*.lib"],
    "sky130hs": ["platforms/sky130hs/lib/*tt_025C_1v80.lib"],
}.items()]

# LEC (kepler-formal) aggregates over every design and stage; all
# constituents are tagged `manual` so wildcards skip them. Build the
# checks first (this is where the SAT solving happens; throttle with
# --jobs=N), then run the instant verdict tests:
#
#   bazelisk build //flow:lec_check --jobs=4
#   bazelisk test  //flow:lec_test
filegroup(
    name = "lec_check",
    srcs = lec_check_targets(),
    tags = ["manual"],
    visibility = ["//visibility:public"],
)

test_suite(
    name = "lec_test",
    tags = ["manual"],
    tests = lec_test_targets(),
    visibility = ["//visibility:public"],
)
