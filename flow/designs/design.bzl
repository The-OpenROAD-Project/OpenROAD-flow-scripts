"""BUILD boilerplate for flow/designs/."""

load("@bazel-orfs//:canon_verilog.bzl", "orfs_canon_verilog")
load("@bazel-orfs//:openroad.bzl", "orfs_flow", "orfs_openroad_synth", "orfs_run")
load("@bazel-orfs-lec//:lec.bzl", "lec")
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
    _emit_lec(DESIGNS.get(_design_key()))
    _emit_syn_variant(
        DESIGNS.get(_design_key()),
        user_arguments,
        user_sources,
        local_arguments,
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

# Stages whose .odb gets a LEC netlist extracted, with the .odb stem.
# Adjacent pairs are compared: synth<->floorplan, floorplan<->place, ...
LEC_STAGES = [
    ("synth", "1_synth"),
    ("floorplan", "2_floorplan"),
    ("place", "3_place"),
    ("cts", "4_cts"),
    ("route", "5_route"),
    ("final", "6_final"),
]

def lec_liberty(entry):
    """Liberty inputs for kepler-formal: one-corner PDK libs + design macros."""
    return ["//flow:{}_lec_libs".format(entry["platform"])] + \
           entry["sources"].get("ADDITIONAL_LIBS", [])

def _lec_design_keys():
    """DESIGNS keys that correspond to design packages.

    Filters out
      - BLOCKS sub-flow entries (`<parent key>_<block>`), which live in
        the parent's package, and
      - nickname aliases: config_mk_parser indexes a design both by
        directory name and by DESIGN_NICKNAME when they differ (e.g.
        nangate45/black_parrot vs nangate45/bp). The entries are
        identical, only the directory key is a real bazel package; of
        each identical pair the longer key is the directory one
        (nicknames abbreviate).
      - designs without VERILOG_FILES (e.g. asap7/minimal), whose BUILD
        files skip design() so no flow targets exist.
    """
    skip = {}
    for key, entry in DESIGNS.items():
        if not entry.get("verilog_files"):
            skip[key] = True
    for key, entry in DESIGNS.items():
        for block in entry.get("blocks", []):
            skip[key + "_" + block] = True
    for key, entry in DESIGNS.items():
        if key in skip:
            continue
        for other, other_entry in DESIGNS.items():
            if other == key or other in skip:
                continue
            if entry == other_entry and len(other) > len(key):
                skip[key] = True
                break
    return [key for key in DESIGNS.keys() if key not in skip]

def lec_check_targets():
    """Labels of all per-design lec_check targets (//flow:lec_check)."""
    labels = []
    for key in _lec_design_keys():
        entry = DESIGNS[key]
        package = "//flow/designs/" + key
        name = entry["name"]
        labels.append("{}:{}_lec_synth".format(package, name))
        for stage, _ in LEC_STAGES[1:]:
            labels.append("{}:{}_lec_{}".format(package, name, stage))
        if not entry.get("blocks"):
            labels.append("{}:{}_syn_lec_synth".format(package, name))
    return labels

def lec_test_targets():
    """Labels of all per-design LEC verdict tests (//flow:lec_test)."""
    return [label + "_test" for label in lec_check_targets()]

def _emit_lec(entry):
    """Emit kepler-formal LEC targets for `entry` from DESIGNS.

    Per design (all tagged `manual`; see flow/README.md):
      - `<n>_canon_v`: pre-synthesis Verilog written from the yosys
        canonicalize RTLIL checkpoint. Using the post-canonicalization
        netlist as SEC gold means kepler-formal never parses the raw
        (System)Verilog sources — a failure implicates synthesis, not
        canonicalization.
      - `<n>_lec_synth` + `_test`: SEC of canonicalized RTL vs the
        yosys synthesis netlist (kepler-formal pre-synthesis .v
        support).
      - `<n>_<stage>_lec_v`: per-stage netlist written by OpenROAD from
        the stage .odb (physical-only cells removed; hierarchical for
        OPENROAD_HIERARCHICAL designs).
      - `<n>_lec_<stage>` + `_test` for floorplan/place/cts/route/final:
        adjacent-pair gate-level LEC along the flow.

    LEC runs at `bazel build` time (cacheable lec_check actions); the
    `_test` targets only assert the recorded verdict.
    """
    if entry == None:
        return
    name = entry["name"]
    liberty = lec_liberty(entry)
    results_dir = "results/{}/{}/base".format(entry["platform"], name)

    orfs_canon_verilog(
        name = name + "_canon_v",
        src = ":" + name + "_synth",
        tags = ["manual"],
        visibility = ["//visibility:public"],
    )
    lec(
        name = name + "_lec_synth",
        # pdr: the default (legacy) SEC engine was inconclusive on uart
        # after 28min at k=32; pdr proves it at k=1 in seconds.
        extra_config = ["sec_engine: pdr"],
        # sv2v: the behavioral canonicalized gold goes through the
        # SystemVerilog frontend, the gate netlist through the Verilog
        # netlist parser.
        format = "sv2v",
        # The gate side is the OpenROAD-written netlist from 1_synth.odb
        # rather than 1_2_yosys.v: linking drops unused modules (e.g.
        # SYNTH_WRAPPED_OPERATORS adder variants), which would otherwise
        # leave kepler-formal's top inference with multiple roots. It
        # also covers the ODB import, and matches every later stage.
        gate_verilog_files = [":" + name + "_synth_lec_v"],
        gold_verilog_files = [":" + name + "_canon_v"],
        liberty_files = liberty,
        tags = ["manual"],
        verification = "sec",
        visibility = ["//visibility:public"],
    )

    previous = None
    for stage, stem in LEC_STAGES:
        orfs_run(
            name = "{}_{}_lec_v".format(name, stage),
            src = ":{}_{}".format(name, stage),
            script = "@bazel-orfs-lec//:write_netlist.tcl",
            outs = ["{}/{}_lec.v".format(results_dir, stem)],
            tags = ["manual"],
        )
        if previous:
            lec(
                name = "{}_lec_{}".format(name, stage),
                gate_verilog_files = [":{}_{}_lec_v".format(name, stage)],
                gold_verilog_files = [":{}_{}_lec_v".format(name, previous)],
                liberty_files = liberty,
                tags = ["manual"],
                visibility = ["//visibility:public"],
            )
        previous = stage

def _emit_syn_variant(entry, user_arguments = [], user_sources = [], local_arguments = []):
    """Emit the `_syn` variant chain for `entry` from DESIGNS.

    Adds `<name>_syn_synth` (built-in OpenROAD synth, driven by
    flow/scripts/synth_syn.tcl) plus the downstream `_syn_*` chain
    via `orfs_flow(variant = "syn", previous_stage = {...})`.

    No-op for hierarchical designs (`entry["blocks"]` non-empty); the
    built-in synthesizer doesn't handle BLOCKS yet and those would
    just fail. Flat designs pick the variant up for free.

    Project-specific config.mk vars (design()'s user_arguments /
    user_sources / local_arguments) are split out of the DESIGNS entry
    the same way orfs_design does, so orfs_flow's variables.yaml
    validation only sees real ORFS variables.

    All emitted targets are tagged `manual` so `bazel build //...`
    does not pick them up while the OpenROAD synth tool (PR #10473)
    matures.
    """
    if entry == None or entry.get("blocks"):
        return
    name = entry["name"]
    pdk = "//flow:" + entry["platform"]
    syn_args = {
        k: v
        for k, v in entry["arguments"].items()
        if k not in user_arguments and k not in local_arguments
    }
    syn_user_args = {
        k: v
        for k, v in entry["arguments"].items()
        if k in user_arguments
    }
    syn_sources = {
        k: v
        for k, v in entry["sources"].items()
        if k not in user_sources and k not in local_arguments
    }
    syn_user_sources = {
        k: v
        for k, v in entry["sources"].items()
        if k in user_sources
    }
    syn_synth = name + "_syn_synth"
    orfs_openroad_synth(
        name = syn_synth,
        module_top = name,
        verilog_files = entry["verilog_files"],
        sources = entry["sources"],
        arguments = syn_args | syn_user_args,
        pdk = pdk,
        variant = "syn",
        tags = ["manual"],
    )
    orfs_flow(
        name = name,
        variant = "syn",
        verilog_files = entry["verilog_files"],
        sources = syn_sources,
        user_sources = syn_user_sources,
        arguments = syn_args,
        user_arguments = syn_user_args,
        pdk = pdk,
        previous_stage = {"floorplan": ":" + syn_synth},
        tags = ["manual"],
        test_kwargs = {"tags": ["orfs", "manual"]},
    )

    # Pre-synthesis SEC of the built-in synth netlist against the yosys
    # canonicalized RTL (`<n>_canon_v` from _emit_lec): both synthesizers
    # are checked against the same canonicalization, so a `_syn` failure
    # with a passing `<n>_lec_synth` implicates the built-in synthesis.
    orfs_run(
        name = name + "_syn_synth_lec_v",
        src = ":" + syn_synth,
        script = "@bazel-orfs-lec//:write_netlist.tcl",
        outs = ["results/{}/{}/syn/1_synth_lec.v".format(entry["platform"], name)],
        tags = ["manual"],
    )
    lec(
        name = name + "_syn_lec_synth",
        extra_config = ["sec_engine: pdr"],
        format = "sv2v",
        gate_verilog_files = [":" + name + "_syn_synth_lec_v"],
        gold_verilog_files = [":" + name + "_canon_v"],
        liberty_files = lec_liberty(entry),
        tags = ["manual"],
        verification = "sec",
        visibility = ["//visibility:public"],
    )
