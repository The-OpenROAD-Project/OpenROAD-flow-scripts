"""BUILD.bazel boilerplate for flow/designs/."""

load("@bazel-orfs//:openroad.bzl", "orfs_design")
load("@orfs_designs//:designs.bzl", "DESIGNS")

# Per filegroup target: (extensions in the filegroup, extensions in
# exports_files). bazel-orfs's config_mk_parser produces these target
# names from VERILOG_FILES wildcard patterns.
_GROUPS = {
    "verilog": (["v", "sv"], ["v", "sv", "svh"]),
    "include": (["v", "sv", "svh"], ["v", "sv", "svh"]),
    "lef": (["lef"], ["lef"]),
    "lib": (["lib"], ["lib"]),
    "gds": (["gds", "gds.gz"], ["gds", "gds.gz"]),
}

def design(user_arguments = []):
    """Standard BUILD body for flow/designs/<platform>/<design>/.

    user_arguments: see orfs_design — list of config.mk var names that
    are project-specific (read by the design's own .tcl/.mk, not by
    ORFS) and should bypass the variables.yaml validator.
    """
    native.exports_files(native.glob(["*"]))
    orfs_design(designs = DESIGNS, user_arguments = user_arguments)

def files(group, extra_srcs = None):
    """Public exports_files + named filegroup over conventional extensions."""
    fg_exts, ex_exts = _GROUPS[group]
    native.exports_files(
        native.glob(["*.{}".format(e) for e in ex_exts], allow_empty = True),
        visibility = ["//visibility:public"],
    )
    native.filegroup(
        name = group,
        srcs = native.glob(["*.{}".format(e) for e in fg_exts], allow_empty = True) +
               (extra_srcs or []),
        visibility = ["//visibility:public"],
    )
