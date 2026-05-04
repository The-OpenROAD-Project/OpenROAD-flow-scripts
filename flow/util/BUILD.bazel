load("@rules_python//python:defs.bzl", "py_library", "py_test")
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

py_test(
    name = "genMetrics_test",
    srcs = ["genMetrics_test.py"],
    deps = [":genMetrics_lib"],
)
