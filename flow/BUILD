load("@bazel-orfs//:openroad.bzl", "orfs_pdk")
load("@rules_python//python:defs.bzl", "py_library", "py_test")

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
    "scripts/memories/*.py",
    "scripts/*.sh",
    "scripts/*.yaml",
    "scripts/*.mk",
]

MAKEFILE_SHARED_EXCLUDE = [
    "scripts/memories/*_test.py",
]

# makefile and scripts used by script/synth.sh steps
filegroup(
    name = "makefile_yosys",
    srcs = ["Makefile"],
    data = glob(
        MAKEFILE_SHARED + [
            "scripts/*.script",
            "scripts/*.v",
            "scripts/util.tcl",
            "scripts/synth*.tcl",
            "scripts/synth*.v",
            "platforms/common/**/*.v",
        ],
        exclude = MAKEFILE_SHARED_EXCLUDE,
    ) + [
        "//flow/util:makefile_yosys",
    ],
    visibility = ["//visibility:public"],
)

# makefile and scripts used in the scripts/flow.sh steps
filegroup(
    name = "makefile",
    srcs = ["Makefile"],
    data = glob(
        MAKEFILE_SHARED + [
            "scripts/*.tcl",
            "platforms/common/**/*.v",
        ],
        exclude = MAKEFILE_SHARED_EXCLUDE,
    ) + [
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

# AUTO_MEMORIES: pre-synthesis memory detection and .lib/.lef macro view
# generation. See docs/user/AutoMemories.md. The unit tests are the
# feature's test coverage — run with `bazelisk test //flow:memories_tests`.
py_library(
    name = "memories",
    srcs = glob(
        ["scripts/memories/*.py"],
        exclude = ["scripts/memories/*_test.py"],
    ),
    imports = ["scripts/memories"],
)

# Test fixtures (Verilog snippets) live in detect_test.py and are
# imported by the other tests.
py_library(
    name = "memories_test_fixtures",
    srcs = ["scripts/memories/detect_test.py"],
    imports = ["scripts/memories"],
    deps = [":memories"],
)

MEMORIES_TESTS = [
    "detect_test",
    "gen_memories_test",
    "idiomatic_test",
    "lef_test",
    "liberty_test",
    "schema_test",
    "sram_area_model_test",
]

[py_test(
    name = "memories_" + test,
    srcs = ["scripts/memories/{}.py".format(test)],
    main = "scripts/memories/{}.py".format(test),
    deps = [
        ":memories",
        ":memories_test_fixtures",
    ],
) for test in MEMORIES_TESTS]

test_suite(
    name = "memories_tests",
    tests = ["memories_" + test for test in MEMORIES_TESTS],
)
