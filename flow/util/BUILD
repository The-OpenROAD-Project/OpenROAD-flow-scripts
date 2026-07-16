load("@rules_python//python:defs.bzl", "py_binary", "py_library", "py_test")
load("@rules_python//python:pip.bzl", "compile_pip_requirements")

exports_files(["open_plots.sh"])

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

py_library(
    name = "genMetrics_lib",
    srcs = ["genMetrics.py"],
    imports = ["."],
)

# Renders the OpenROAD-SYN vs yosys synthesis QoR comparison graph from
# per-design qor.json pairs (see //flow/designs/asap7:syn_qor_png).
# matplotlib comes from the @orfs-pip hub, so `bazelisk build` needs no
# host python packages.
py_binary(
    name = "plotSynQoR",
    srcs = ["plotSynQoR.py"],
    visibility = ["//visibility:public"],
    deps = ["@orfs-pip//matplotlib"],
)

# Renders effective clock period across flow stages from the checked-in
# rules-*.json QoR gates (see //flow/designs/asap7:clock_period_png).
py_binary(
    name = "plotClockPeriod",
    srcs = ["plotClockPeriod.py"],
    visibility = ["//visibility:public"],
    deps = ["@orfs-pip//matplotlib"],
)

py_test(
    name = "genMetrics_test",
    srcs = ["genMetrics_test.py"],
    deps = [":genMetrics_lib"],
)
