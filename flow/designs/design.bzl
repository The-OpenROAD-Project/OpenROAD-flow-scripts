"""BUILD boilerplate for flow/designs/."""

load("@bazel-orfs//:openroad.bzl", "orfs_flow", "orfs_openroad_synth")
load("@orfs_designs//:designs.bzl", "DESIGNS", "orfs_design")

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

_EXPORTS_SENTINEL = "_orfs_design_exports_sentinel"

def _export_design_files():
    """Publicly export per-file labels for cross-package references.

    bazel-orfs's config_mk_parser turns $(DESIGN_HOME)/... and
    $(PLATFORM_DIR)/... paths in a config.mk into per-file bazel labels
    like //flow/designs/<plat>/<other>:constraint.sdc.  Those labels
    resolve only if the source package calls exports_files() on the
    individual files — being part of a public filegroup is not
    sufficient.

    Idempotent: design() and files() both call this, and a BUILD file
    may legitimately call files() more than once (e.g. files("verilog")
    and files("lef") in the same package).  A second native.exports_files
    over the same paths is a duplicate-target error, so a sentinel rule
    short-circuits subsequent calls within the same package.
    """
    if _EXPORTS_SENTINEL in native.existing_rules():
        return
    exported = native.glob(
        ["*.{}".format(e) for e in _EXPORTED_EXTS],
        allow_empty = True,
    )
    if exported:
        native.exports_files(exported, visibility = ["//visibility:public"])
    native.filegroup(
        name = _EXPORTS_SENTINEL,
        srcs = [],
        visibility = ["//visibility:private"],
    )

def design(config = "config.mk", user_arguments = [], user_sources = [], local_arguments = []):
    """Standard BUILD body for flow/designs/<platform>/<design>/.

    Args:
        config: The config.mk file that drives this design.
        user_arguments: see orfs_design — list of config.mk var names that
            are project-specific (read by the design's own .tcl/.mk, not by
            ORFS) and should bypass the variables.yaml validator.
        user_sources: see orfs_design — list of config.mk var names that
            are project-specific source-typed (path-label) hooks read only
            by the design's own .tcl/.mk; the file is still staged into the
            sandbox but the var name skips variables.yaml validation.
        local_arguments: see orfs_design — list of config.mk var names that
            are pure make-only helpers (used only via $(VAR) expansion
            within the same config.mk, never read by ORFS or by user
            .tcl/.mk). Dropped entirely before orfs_flow() is invoked.
    """
    _export_design_files()
    orfs_design(
        config = config,
        user_arguments = user_arguments,
        user_sources = user_sources,
        local_arguments = local_arguments,
        blender = True,
    )
    _emit_syn_variant(DESIGNS.get(_design_key()))

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

def _design_key():
    """Map this BUILD package to its DESIGNS key.

    `native.package_name()` looks like `flow/designs/<platform>/<dir>`;
    the DESIGNS dict is keyed by `<platform>/<dir>` (bazel-orfs's
    config_mk_parser also indexes by directory name when it differs
    from the nickname). Returns "" for packages outside that layout
    so the lookup misses cleanly.
    """
    parts = native.package_name().split("/")
    if len(parts) < 2:
        return ""
    return "{}/{}".format(parts[-2], parts[-1])

def _emit_syn_variant(entry):
    """Emit the `_syn` variant chain for `entry` from DESIGNS.

    Adds `<name>_syn_synth` (built-in OpenROAD synth, driven by
    flow/scripts/synth_syn.tcl) plus the downstream `_syn_*` chain
    via `orfs_flow(variant = "syn", previous_stage = {...})`.

    No-op for hierarchical designs (`entry["blocks"]` non-empty); the
    built-in synthesizer doesn't handle BLOCKS yet and those would
    just fail. Flat designs pick the variant up for free.

    All emitted targets are tagged `manual` so `bazel build //...`
    does not pick them up while the OpenROAD synth tool (PR #10473)
    matures.
    """
    if entry == None or entry.get("blocks"):
        return
    name = entry["name"]
    pdk = "//flow:" + entry["platform"]
    syn_args = dict(entry["arguments"])
    syn_synth = name + "_syn_synth"
    orfs_openroad_synth(
        name = syn_synth,
        module_top = name,
        verilog_files = entry["verilog_files"],
        sources = entry["sources"],
        arguments = syn_args,
        pdk = pdk,
        variant = "syn",
        tags = ["manual"],
    )
    orfs_flow(
        name = name,
        variant = "syn",
        verilog_files = entry["verilog_files"],
        sources = entry["sources"],
        arguments = syn_args,
        pdk = pdk,
        previous_stage = {"floorplan": ":" + syn_synth},
        tags = ["manual"],
        test_kwargs = {"tags": ["orfs", "manual"]},
    )
