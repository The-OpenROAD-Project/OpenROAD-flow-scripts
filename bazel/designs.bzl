"""Repository rule that parses config.mk files and generates a .bzl with design configs.

The generated .bzl file contains a DESIGNS dict that orfs_design() reads
to create orfs_flow() targets with properly routed stage arguments.

Each config.mk is read via repository_ctx.read() so that Bazel watches
them and re-fetches the repo when any config.mk changes.
"""

def _find_config_files(repository_ctx, designs_dir, platforms):
    """Walk designs_dir to find all config.mk files."""
    configs = []
    for platform in platforms:
        platform_dir = designs_dir + "/" + platform
        # List design directories under this platform
        result = repository_ctx.execute(["find", platform_dir, "-name", "config.mk", "-type", "f"])
        if result.return_code == 0:
            for line in result.stdout.strip().split("\n"):
                if line:
                    configs.append(line)
    return configs

def _orfs_designs_impl(repository_ctx):
    parser_path = repository_ctx.path(repository_ctx.attr._parser)
    designs_path = repository_ctx.path(repository_ctx.attr.designs_dir)
    designs_dir = str(designs_path.dirname)

    python = repository_ctx.which("python3") or repository_ctx.which("python")
    if not python:
        fail("python3 not found in PATH")

    # Read every config.mk to register them as watched inputs.
    # When any config.mk changes, Bazel will re-fetch this repo.
    config_files = _find_config_files(
        repository_ctx,
        designs_dir,
        repository_ctx.attr.platforms,
    )
    for config_file in config_files:
        repository_ctx.read(config_file)

    platforms_arg = ",".join(repository_ctx.attr.platforms)
    result = repository_ctx.execute(
        [python, str(parser_path), "--all", designs_dir, "--platforms", platforms_arg, "--json"],
        timeout = 120,
    )

    if result.return_code != 0:
        fail("config_mk_parser.py failed (dir=%s):\nstdout: %s\nstderr: %s" % (designs_dir, result.stdout, result.stderr))

    if not result.stdout or not result.stdout.strip():
        fail("config_mk_parser.py produced no output (dir=%s, stderr=%s)" % (designs_dir, result.stderr))

    configs = json.decode(result.stdout)

    # Build a dict keyed by "platform/design_nickname"
    designs = {}
    for config in configs:
        platform = config.get("platform", "")
        nickname = config.get("design_nickname", "")
        name = config.get("design_name", "") or nickname
        if not name or not platform or not nickname:
            continue

        key = "%s/%s" % (platform, nickname)
        designs[key] = {
            "name": name,
            "platform": platform,
            "verilog_files": config.get("verilog_files", []),
            "sources": config.get("sources", {}),
            "arguments": config.get("arguments", {}),
            "blocks": config.get("blocks", []),
        }

        # Also add block_configs as separate entries
        for block_config in config.get("block_configs", []):
            bp = block_config.get("platform", platform)
            bn = block_config.get("design_nickname", "")
            bname = block_config.get("design_name", "") or bn
            if not bname or not bn:
                continue
            bkey = "%s/%s" % (bp, bn)
            designs[bkey] = {
                "name": bname,
                "platform": bp,
                "verilog_files": block_config.get("verilog_files", []),
                "sources": block_config.get("sources", {}),
                "arguments": block_config.get("arguments", {}),
                "blocks": [],
            }

    # Generate designs.bzl
    bzl_content = 'DESIGNS = %s\n' % repr(designs)
    repository_ctx.file("designs.bzl", bzl_content)
    repository_ctx.file("BUILD.bazel", "")

orfs_designs = repository_rule(
    implementation = _orfs_designs_impl,
    attrs = {
        "designs_dir": attr.label(
            mandatory = True,
        ),
        "platforms": attr.string_list(
            default = ["asap7", "sky130hd", "sky130hs", "nangate45", "ihp-sg13g2"],
        ),
        "module_name": attr.string(
            default = "orfs",
        ),
        "_parser": attr.label(
            default = Label("//bazel:config_mk_parser.py"),
            allow_single_file = True,
        ),
    },
)
