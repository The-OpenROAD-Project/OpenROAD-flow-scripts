"""BUILD boilerplate for flow/designs/."""

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

# Extensions exported as individual labels so bazel-orfs's per-file
# cross-package references resolve. Kept tight on purpose: globbing "*"
# silently exposes LICENSE/.gitignore/etc. as the public API surface.
# gds/gds.gz are inputs in hierarchical flows via ADDITIONAL_GDS.
_EXPORTED_EXTS = ["v", "sv", "svh", "tcl", "sdc", "def", "cfg", "lef", "lib", "gds", "gds.gz"]

def _export_design_files():
    """Publicly export per-file labels for cross-package references.

    bazel-orfs's config_mk_parser turns $(DESIGN_HOME)/... and
    $(PLATFORM_DIR)/... paths in a config.mk into per-file bazel labels
    like //flow/designs/<plat>/<other>:constraint.sdc.  Those labels
    resolve only if the source package calls exports_files() on the
    individual files — being part of a public filegroup is not
    sufficient.
    """
    exported = native.glob(
        ["*.{}".format(e) for e in _EXPORTED_EXTS],
        allow_empty = True,
    )
    if exported:
        native.exports_files(exported, visibility = ["//visibility:public"])

def design(config = "config.mk", user_arguments = [], local_arguments = []):
    """Standard BUILD body for flow/designs/<platform>/<design>/.

    Args:
        config: The config.mk file that drives this design.
        user_arguments: see orfs_design — list of config.mk var names that
            are project-specific (read by the design's own .tcl/.mk, not by
            ORFS) and should bypass the variables.yaml validator.
        local_arguments: see orfs_design — list of config.mk var names that
            are pure make-only helpers (used only via $(VAR) expansion
            within the same config.mk, never read by ORFS or by user
            .tcl/.mk). Dropped entirely before orfs_flow() is invoked.
    """
    _export_design_files()
    orfs_design(
        config = config,
        user_arguments = user_arguments,
        local_arguments = local_arguments,
    )

def files(group, extra_srcs = None):
    """Named filegroup over conventional extensions.

    Also exports the same files individually so per-file labels
    (e.g. //flow/designs/src/gcd:gcd.v) resolve from sibling packages.
    bazel-orfs's config_mk_parser emits such labels for
    $(DESIGN_HOME)/src/<name>/<file> references.
    """
    exts = _GROUPS[group]
    srcs = native.glob(["*.{}".format(e) for e in exts], allow_empty = True) + \
           (extra_srcs or [])
    native.filegroup(
        name = group,
        srcs = srcs,
        visibility = ["//visibility:public"],
    )
    _export_design_files()
