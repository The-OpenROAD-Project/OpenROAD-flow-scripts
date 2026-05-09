"""BUILD.bazel boilerplate for flow/designs/."""

load("@orfs_designs//:designs.bzl", "orfs_design")

# Per filegroup target: extensions included in the filegroup.
# bazel-orfs's config_mk_parser produces these target names from
# VERILOG_FILES wildcard patterns.
_GROUPS = {
    "verilog": ["v", "sv"],
    "include": ["v", "sv", "svh"],
    "lef": ["lef"],
    "lib": ["lib"],
    "gds": ["gds", "gds.gz"],
}

def design(config = "config.mk", user_arguments = []):
    """Standard BUILD body for flow/designs/<platform>/<design>/.

    Args:
        config: The config.mk file that drives this design.
        user_arguments: see orfs_design — list of config.mk var names that
            are project-specific (read by the design's own .tcl/.mk, not by
            ORFS) and should bypass the variables.yaml validator.
    """
    orfs_design(config = config, user_arguments = user_arguments)

def files(group, extra_srcs = None):
    """Named filegroup over conventional extensions."""
    exts = _GROUPS[group]
    native.filegroup(
        name = group,
        srcs = native.glob(["*.{}".format(e) for e in exts], allow_empty = True) +
               (extra_srcs or []),
        visibility = ["//visibility:public"],
    )
