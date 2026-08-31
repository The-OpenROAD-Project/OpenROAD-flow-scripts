load("@rules_python//python:defs.bzl", "py_binary", "py_library", "py_test")
load("@rules_python//python:pip.bzl", "compile_pip_requirements")

# pinAutoFloorplan.py is exported so //flow/designs:design.bzl can
# instantiate a per-design py_binary over it.
exports_files([
    "open_plots.sh",
    "pinAutoFloorplan.py",
])

compile_pip_requirements(
    name = "requirements",
    src = "requirements.in",
    requirements_txt = "requirements_lock.txt",
)

MAKEFILE_SHARED = [
    "*.mk",
]

# for scripts/flow.sh steps
filegroup(
    name = "makefile",
    srcs = glob(
        MAKEFILE_SHARED + [
            "*.py",
            "*.sh",
        ],
        exclude = ["*_test.py"],
    ),
    visibility = ["//visibility:public"],
)

# for scripts/synth.sh steps
filegroup(
    name = "makefile_yosys",
    srcs = glob(MAKEFILE_SHARED),
    visibility = ["//visibility:public"],
)

# TL;DR markdown dashboard over locally built OpenROAD-SYN QoR tests;
# run via the //flow/designs:syn-dashboard alias.
py_binary(
    name = "synDashboard",
    srcs = ["synDashboard.py"],
    visibility = ["//flow/designs:__pkg__"],
)

py_library(
    name = "genMetrics_lib",
    srcs = ["genMetrics.py"],
    imports = ["."],
)

py_test(
    name = "genMetrics_test",
    srcs = ["genMetrics_test.py"],
    deps = [":genMetrics_lib"],
)

# Turns a raced AUTO_FLOORPLAN result into a decision: writes the winning
# coordinates into a design's config.mk and sets AUTO_FLOORPLAN = 0.
# Instantiated per design by //flow/designs:design.bzl as
# <name>_auto_floorplan_pin; not useful to run directly.
py_binary(
    name = "pinAutoFloorplan",
    srcs = ["pinAutoFloorplan.py"],
    visibility = ["//visibility:public"],
)
