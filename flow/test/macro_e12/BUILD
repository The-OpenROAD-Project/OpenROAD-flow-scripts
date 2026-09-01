"""E12: does a clustered global placement rank macro-placement candidates?

Every flow-running target here is tags = ["manual"]: the candidate
generation is a ~25 minute job on a 24-core machine and none of it
belongs in an automatic build. The one non-manual target is the gate's
unit test, which runs in about a second on committed fixtures and needs
no OpenROAD at all.

See README.md for the pre-registered configuration and the protocol.
"""

load("@bazel-orfs//:openroad.bzl", "orfs_run_executable")
load("@orfs_designs//:designs.bzl", "DESIGNS")
load("@rules_python//python:defs.bzl", "py_binary", "py_library", "py_test")

# The design ladder. Every design here gets the same four executables, so
# an experiment can be flushed on a cheap design and then repeated on an
# expensive one without editing anything.
#
#   tinyRocket   mechanics. Two macros and a ~6 minute production tail, so
#                the whole chain -- generation, scoring, truth, verdict --
#                runs in minutes. Its candidate population is too small to
#                rank, so a rho from it means nothing; it exists to prove
#                the pipeline executes.
#   swerv        the real population: 28 macros, and the design the
#                archived reference numbers were measured on. Hours per
#                candidate for the truth stage.
E12_DESIGNS = {
    "tinyRocket": "nangate45/tinyRocket",
    "swerv": "asap7/swerv_wrapper",
}

# Per-design synth target, exposed to this package by a narrow alias in
# the design's own BUILD (orfs_design leaves flow targets
# package-private and ORFS's design() has no visibility passthrough).
E12_SYNTH = {
    "tinyRocket": "//flow/designs/nangate45/tinyRocket:RocketTile_synth_for_e12",
    "swerv": "//flow/designs/asap7/swerv_wrapper:swerv_wrapper_synth_for_e12",
}

# The helper Tcl travels as `data`, which orfs_run_executable stages
# alongside `script`, so each driver sources it as a sibling.
# e12_lib.tcl is shared by all drivers; extract_lib.tcl is the vendored
# instrument the archived reference numbers were measured with.
E12_DATA = [
    "e12_lib.tcl",
    "extract_lib.tcl",
]

# Each stage of the pipeline, as script -> target suffix.
E12_STAGES = {
    "macro_e12.tcl": "candidates",
    "dump_clusters.tcl": "dump_clusters",
    "score_clustered.tcl": "score_clustered",
    "evaluate.tcl": "evaluate",
}

# Four `bazelisk run` executables per design, taking KEY=VALUE overrides,
# rather than build-time actions with declared outputs. That matches what
# they are -- a manual campaign whose evidence directory is an input to
# analysis, not a build artifact -- and it is what lets the
# reduction-axis sweeps vary E12_* without a target per value.
#
#   candidates       regenerate the population and score it flat. Also the
#                    rig check when grading against the archive.
#   dump_clusters    RTL-MP's cluster partition, once, from the base
#                    floorplan.
#   score_clustered  the clustered rung, one candidate per process.
#   evaluate         the production tail to grt: the truth.
[
    orfs_run_executable(
        name = "%s_%s" % (short, suffix),
        src = E12_SYNTH[short],
        arguments = DESIGNS[full]["arguments"],
        cmd = "run",
        data = E12_DATA + [
            label
            for labels in DESIGNS[full]["sources"].values()
            for label in labels
        ],
        script = script,
        tags = ["manual"],
    )
    for short, full in E12_DESIGNS.items()
    for script, suffix in E12_STAGES.items()
]

py_library(
    name = "e12_stats",
    srcs = ["e12_stats.py"],
    imports = ["."],
)

py_library(
    name = "grade_e12_lib",
    srcs = ["grade_e12.py"],
    imports = ["."],
    deps = [":e12_stats"],
)

# Step 3: the gate. Reads the committed archive plus the run's evidence
# directory, prints the rho table and writes the verdict.
py_binary(
    name = "grade_e12",
    srcs = ["grade_e12.py"],
    data = ["score_vs_flow_swerv.json"],
    tags = ["manual"],
    deps = [":e12_stats"],
)

# The gate's own tests: the pass/fail logic on synthetic fixtures, plus
# five published numbers recomputed from the committed archive. Fast, and
# the only target here that is not manual.
py_test(
    name = "grade_e12_test",
    size = "small",
    srcs = ["grade_e12_test.py"],
    data = ["score_vs_flow_swerv.json"],
    deps = [
        ":e12_stats",
        ":grade_e12_lib",
    ],
)
