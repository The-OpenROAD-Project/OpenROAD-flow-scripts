"""BUILD boilerplate for flow/designs/."""

load("@bazel-orfs//:openroad.bzl", "orfs_flow")
load("@orfs_designs//:designs.bzl", "DESIGNS", "orfs_design")
load("@rules_python//python:defs.bzl", "py_binary", "py_test")

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
    )
    _auto_floorplan_pin(config)
    _pareto_test()

def _auto_floorplan_pin(config):
    """Generate <name>_auto_floorplan_pin for this design.

    AUTO_FLOORPLAN measures the floorplan shape on every run, which is
    right while the RTL is moving and wrong at a tapeout: sign-off needs
    a decision, not a measurement. This target turns one into the other,
    the same way <name>_update does for rules-base.json --

        bazelisk run //flow/designs/asap7/ibex:ibex_core_auto_floorplan_pin

    reads the evidence the floorplan stage emitted, writes the winning
    coordinates into config.mk between generated markers, and sets
    AUTO_FLOORPLAN = 0. From then on they are ordinary config.mk entries,
    so autotuner and seed sweeps apply to them like any other knob.
    """
    pkg = native.package_name()
    prefix = "flow/designs/"
    if not pkg.startswith(prefix):
        return
    key = pkg[len(prefix):]
    entry = DESIGNS.get(key)
    if not entry:
        # Block sub-packages and designs without a parsed config.mk have
        # no flow targets to hang this off.
        return
    name = entry["name"]

    # The floorplan stage echoes its evidence into the stage log, which
    # is a declared output; the REPORTS_DIR copy is not, and a sandboxed
    # build discards it.
    native.filegroup(
        name = name + "_auto_floorplan_evidence",
        srcs = [":" + name + "_floorplan"],
        output_group = "2_1_floorplan.log",
        tags = ["manual"],
    )
    py_binary(
        name = name + "_auto_floorplan_pin",
        srcs = ["//flow/util:pinAutoFloorplan.py"],
        main = "pinAutoFloorplan.py",
        args = [
            "$(location :{}_auto_floorplan_evidence)".format(name),
            pkg + "/" + config,
        ],
        data = [":" + name + "_auto_floorplan_evidence"],
        tags = ["manual"],
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

def _pareto_test():
    """Generate <name>_pareto_test for designs that have a rules-base.json.

    <name>_test asks whether anything got worse than a padded bound.
    This asks the question that one cannot: did the QoR point move in a
    good direction, or is it dominated? A change that shrinks the core
    and gives up a little slack fails the first and passes the second,
    and the difference matters when the whole point of a change is to
    trade along the front.

    It shares the metadata action with <name>_test, so it adds no flow
    runtime. Designs whose rules-base.json has no `golden` values yet
    (recorded by <name>_update once genRuleFile.py has run) warn and
    pass rather than failing on absence.
    """
    pkg = native.package_name()
    prefix = "flow/designs/"
    if not pkg.startswith(prefix):
        return
    entry = DESIGNS.get(pkg[len(prefix):])
    if not entry:
        return
    if not native.glob(["rules-base.json"], allow_empty = True):
        return
    name = entry["name"]

    native.filegroup(
        name = name + "_metadata_json",
        srcs = [":" + name + "_generate_metadata"],
        output_group = "metadata.json",
        tags = ["manual"],
    )
    py_test(
        name = name + "_pareto_test",
        srcs = ["//flow/util:checkPareto.py"],
        main = "checkPareto.py",
        args = [
            "-m",
            "$(location :{}_metadata_json)".format(name),
            "-r",
            "$(location :rules-base.json)",
        ],
        data = [
            ":" + name + "_metadata_json",
            ":rules-base.json",
        ],
        tags = ["orfs"],
    )
