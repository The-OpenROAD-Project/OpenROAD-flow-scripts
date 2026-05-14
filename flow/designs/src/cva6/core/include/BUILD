filegroup(
    name = "include",
    srcs = glob(
        [
            "*.v",
            "*.sv",
            "*.svh",
        ],
        allow_empty = True,
    ),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "verilog",
    srcs = glob(
        [
            "*.v",
            "*.sv",
        ],
        allow_empty = True,
    ),
    visibility = ["//visibility:public"],
)

# bazel-orfs may translate $(DESIGN_HOME)/src/cva6/core/include/<file>
# references in a config.mk into per-file labels. Export individual
# files so cross-package label references resolve.
exports_files(
    glob(
        [
            "*.v",
            "*.sv",
            "*.svh",
        ],
        allow_empty = True,
    ),
    visibility = ["//visibility:public"],
)
