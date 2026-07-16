"""BUILD boilerplate for flow/designs/."""

load("@bazel-orfs//:openroad.bzl", "orfs_flow")
load("@orfs_designs//:designs.bzl", "orfs_design")
load("//flow/designs:qor.bzl", "orfs_qor")

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
# json covers rules-*.json so QoR reporting targets (e.g.
# //flow/designs/asap7:clock_period_png) can consume them per file.
_EXPORTED_EXTS = ["v", "sv", "svh", "tcl", "sdc", "def", "cfg", "lef", "lib", "gds", "gds.gz", "json"]

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

def _syn_status_targets(
        name,
        platform,
        verilog_files,
        arguments,
        user_arguments,
        sources,
        user_sources,
        macros,
        stage_data,
        tags):  # buildifier: disable=unused-variable
    """OpenROAD-SYN status targets for one design (orfs_design extra hook).

    Emits, always tagged "manual" (even for CI designs, so only explicit
    invocations such as //flow/designs/asap7:syn_test run them):

    - a synthesis-only variant "syn" flow with SYNTH_USE_SYN=1 forced,
      regardless of the config.mk default: <name>_syn_synth plus — when
      the package has a rules-syn.json — the <name>_syn_test QoR gate
      and <name>_syn_update rules regenerator.
    - a best-effort <name>_syn_qor / <name>_yosys_qor pair whose
      qor.json outputs feed the syn-vs-yosys QoR comparison graph.
    """
    qor_sources = {k: v for k, v in sources.items() if k != "RULES_JSON"}
    syn_sources = dict(qor_sources)
    if native.glob(["rules-syn.json"], allow_empty = True):
        syn_sources["RULES_JSON"] = [":rules-syn.json"]
    orfs_flow(
        name = name,
        verilog_files = verilog_files,
        pdk = "//flow:" + platform,
        arguments = arguments | {"SYNTH_USE_SYN": "1"},
        user_arguments = user_arguments,
        sources = syn_sources,
        user_sources = user_sources,
        macros = macros,
        stage_data = stage_data,
        variant = "syn",
        last_stage = "synth",
        tags = ["manual"],
        test_kwargs = {"tags": ["manual"]},
    )
    for qor_variant, qor_use_syn in [("syn_qor", True), ("yosys_qor", False)]:
        orfs_qor(
            name = "%s_%s" % (name, qor_variant),
            use_syn = qor_use_syn,
            module_top = name,
            variant = qor_variant,
            verilog_files = verilog_files,
            pdk = "//flow:" + platform,
            # user_arguments are dropped by the synth-stage argument
            # filter; designs whose synthesis depends on user .tcl hooks
            # may fail their best-effort QoR run and render as FAILED.
            arguments = arguments,
            sources = qor_sources,
            deps = macros,
            stage_data = stage_data,
            tags = ["manual"],
            # Consumed by the platform-level aggregation package (e.g.
            # //flow/designs/asap7:syn_qor_png).
            visibility = ["//visibility:public"],
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
        extra = _syn_status_targets,
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
