"""Best-effort synthesis QoR targets for the OpenROAD-SYN status report.

orfs_qor() runs synthesis (yosys or OpenROAD-SYN, chosen per target) plus
metadata-generate in one action and always produces a single qor.json: a
copy of the synthesis-only metadata.json on success, or a small failure
marker {"orfs_qor_failed": true, ...} when any step fails. This lets the
aggregating QoR comparison graph (//flow/designs/asap7:syn_qor_png) be a
plain `bazel build` target that renders failing designs instead of
refusing to build. The strict per-design <name>_syn_test targets are
unaffected — only the QoR reporting pipeline is best-effort.

This is ORFS status-suite policy layered on bazel-orfs plumbing, so it
lives here (loading bazel-orfs's helper .bzls) rather than in bazel-orfs.
"""

load(
    "@bazel-orfs//private:attrs.bzl",
    "synth_attrs",
    "yosys_attrs",
)
load(
    "@bazel-orfs//private:environment.bzl",
    "EXPAND_VERILOG_DIRS",
    "config_content",
    "config_environment",
    "config_overrides",
    "data_arguments",
    "data_inputs",
    "declare_artifact",
    "deps_inputs",
    "flow_environment",
    "flow_inputs",
    "merge_arguments",
    "module_top",
    "orfs_additional_arguments",
    "pdk_inputs",
    "required_arguments",
    "verilog_arguments",
    "yosys_environment",
    "yosys_inputs",
)
load(
    "@bazel-orfs//private:providers.bzl",
    "OrfsInfo",
)
load(
    "@bazel-orfs//private:stages.bzl",
    "get_sources",
    "get_stage_args",
)

def _qor_impl(ctx):
    all_arguments = merge_arguments(
        data_arguments(ctx) |
        required_arguments(ctx),
        orfs_additional_arguments(
            [dep[OrfsInfo] for dep in ctx.attr.deps],
            use_pre_layout = True,
        ),
    )
    use_syn = all_arguments.get("SYNTH_USE_SYN") == "1"

    config = declare_artifact(ctx, "results", "1_synth.mk")
    ctx.actions.write(
        output = config,
        content = config_content(
            ctx,
            all_arguments,
            [file.path for file in ctx.files.extra_configs],
        ),
    )

    qor = declare_artifact(ctx, "reports", "qor.json")

    if use_syn:
        targets = ["do-1_synth", "metadata-generate"]
    else:
        targets = [
            "yosys-dependencies",
            "do-yosys-canonicalize",
            "do-yosys",
            "do-1_synth",
            "metadata-generate",
        ]

    marker = json.encode({
        "design": module_top(ctx),
        "orfs_qor_failed": True,
        "variant": ctx.attr.variant,
    })

    ctx.actions.run_shell(
        arguments = ["--file", ctx.file._makefile.path] + targets,
        command = EXPAND_VERILOG_DIRS + """
if {make} "$@"; then
  cp "$(dirname {qor})/metadata.json" {qor}
else
  echo '{marker}' > {qor}
fi
""".format(
            make = ctx.executable._make.path,
            marker = marker,
            qor = qor.path,
        ),
        env = config_overrides(
            ctx,
            verilog_arguments(ctx.files.verilog_files) |
            flow_environment(ctx) |
            yosys_environment(ctx) |
            config_environment(config),
        ),
        inputs = depset(
            [config] + ctx.files.verilog_files + ctx.files.extra_configs,
            transitive = [
                data_inputs(ctx),
                pdk_inputs(ctx),
                deps_inputs(ctx),
            ],
        ),
        outputs = [qor],
        tools = depset(transitive = [yosys_inputs(ctx), flow_inputs(ctx)]),
        progress_message = "Best-effort synthesis QoR for %s (%s)" % (
            module_top(ctx),
            ctx.attr.variant,
        ),
    )

    return [DefaultInfo(files = depset([qor]))]

_orfs_qor_rule = rule(
    implementation = _qor_impl,
    attrs = yosys_attrs() |
            synth_attrs() |
            {
                "_stage": attr.string(
                    default = "synth",
                ),
            },
)

def orfs_qor(
        name,
        use_syn,
        module_top,
        variant,
        verilog_files,
        pdk,
        arguments = {},
        sources = {},
        deps = [],
        stage_data = {},
        **kwargs):
    """Best-effort synthesis QoR target that always builds.

    Args:
      name: target name (convention: <design>_syn_qor / <design>_yosys_qor).
      use_syn: True runs OpenROAD-SYN (SYNTH_USE_SYN=1), False forces the
        yosys flow — regardless of what the design's arguments say.
      module_top: Verilog top module name.
      variant: FLOW_VARIANT; must be distinct from any orfs_flow() variant
        in the same package so declared output paths do not collide.
      verilog_files: design sources.
      pdk: PDK label.
      arguments: config.mk argument dict (synth-stage vars are selected).
      sources: config.mk source-label dict (routed to the data attr).
      deps: macro abstracts.
      stage_data: dict keyed by stage with extra data labels.
      **kwargs: forwarded to the rule (e.g. tags, visibility).
    """
    _orfs_qor_rule(
        name = name,
        module_top = module_top,
        variant = variant,
        verilog_files = verilog_files,
        pdk = pdk,
        deps = deps,
        arguments = get_stage_args(
            "synth",
            arguments = arguments | {"SYNTH_USE_SYN": "1" if use_syn else "0"},
            sources = sources,
        ),
        data = get_sources("synth", {}, sources) + stage_data.get("synth", []),
        **kwargs
    )
