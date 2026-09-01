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

SWERV = DESIGNS["asap7/swerv_wrapper"]

SWERV_SYNTH = "//flow/designs/asap7/swerv_wrapper:swerv_wrapper_synth"

# The helper Tcl travels as `data`, which orfs_run_executable stages
# alongside `script`, so each driver sources it as a sibling.
# e12_lib.tcl is shared by all three drivers; extract_lib.tcl is the
# vendored instrument the archived reference numbers were measured with.
E12_DATA = [
    "e12_lib.tcl",
    "extract_lib.tcl",
]

# The design's own source files (SDC, LEFs, LIBs, io.tcl) reach the flow
# through `data` too: the drivers run real ORFS stage scripts, which read
# them by the variable names the config.mk sets.
E12_DESIGN_DATA = [
    label
    for labels in SWERV["sources"].values()
    for label in labels
]

# Step 0: regenerate the 24-candidate population and re-measure it with
# the flat scorer. Writes cand_s<N>.{json,place.tcl,odb} plus
# base_floorplan.odb into $E12_OUT_DIR. This is also the rig check: the
# regenerated flat scores must reproduce the archive.
#
# All four flow targets are `bazelisk run` executables taking KEY=VALUE
# overrides, rather than build-time actions with declared outputs. That
# matches what they are -- a manual campaign whose evidence directory is
# an input to analysis, not a build artifact -- and it is what lets the
# reduction-axis sweeps vary E12_* without a target per value.
orfs_run_executable(
    name = "swerv_candidates",
    src = SWERV_SYNTH,
    arguments = SWERV["arguments"],
    cmd = "run",
    data = E12_DATA + E12_DESIGN_DATA,
    script = "macro_e12.tcl",
    tags = ["manual"],
)

# Step 1: dump RTL-MP's cluster partition from the base floorplan, once.
orfs_run_executable(
    name = "swerv_dump_clusters",
    src = SWERV_SYNTH,
    arguments = SWERV["arguments"],
    cmd = "run",
    data = E12_DATA + E12_DESIGN_DATA,
    script = "dump_clusters.tcl",
    tags = ["manual"],
)

# Step 2: score one candidate with the clustered rung. E12_TAG selects
# the candidate; one candidate per process is mandatory, so the sweep
# over candidates is a loop over invocations of this target rather than
# an inner loop.
orfs_run_executable(
    name = "swerv_score_clustered",
    src = SWERV_SYNTH,
    arguments = SWERV["arguments"],
    cmd = "run",
    data = E12_DATA + E12_DESIGN_DATA,
    script = "score_clustered.tcl",
    tags = ["manual"],
)

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
