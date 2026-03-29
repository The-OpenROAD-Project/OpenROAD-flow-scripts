"""Macro to create orfs_flow() targets from parsed config.mk data."""

load("@bazel-orfs//:openroad.bzl", "orfs_flow")
load("@orfs_designs//:designs.bzl", "DESIGNS")

def _convert_sources(sources, pkg):
    """Convert absolute source labels to relative when in the current package.

    Filters out unresolvable labels (unresolved Make variables, invalid paths).
    """
    result = {}
    for var, labels in sources.items():
        converted = []
        for label in labels:
            # Skip unresolved Make variables
            if "$(" in label or "${" in label:
                continue
            # Skip invalid paths like //./
            if "//." in label:
                continue
            # Skip platform paths — already included in PDK
            if "//flow/platforms/" in label:
                continue
            # Skip partial patterns and directory refs
            if "*" in label or "))" in label:
                continue
            # Skip empty targets (trailing colon with no name)
            if label.endswith(":"):
                continue
            if label.startswith("//" + pkg + ":"):
                label = ":" + label.split(":")[1]
            converted.append(label)
        if converted:
            result[var] = converted
    return result

def orfs_design(platform = None, design = None):
    """Create orfs_flow() targets for a design based on its parsed config.mk.

    Call this from a design's BUILD.bazel:
        load("//bazel:orfs.bzl", "orfs_design")
        orfs_design()

    The platform and design are auto-detected from the package path
    (flow/designs/<platform>/<design>/).

    Args:
        platform: Override platform (default: from package path).
        design: Override design nickname (default: from package path).
    """
    pkg = native.package_name()  # e.g., "flow/designs/asap7/gcd"
    parts = pkg.split("/")

    if not platform and len(parts) >= 3:
        platform = parts[2]  # "asap7"
    if not design and len(parts) >= 4:
        design = parts[3]  # "gcd"

    key = "%s/%s" % (platform, design)
    if key not in DESIGNS:
        fail("No parsed config.mk for %s. Run the linter: " +
             "python3 bazel/config_mk_parser.py --lint flow/designs/%s/config.mk" % (key, key))

    config = DESIGNS[key]
    name = config["name"]
    sources = _convert_sources(config["sources"], pkg)

    # Auto-detect rules-base.json if present in the package
    if "RULES_JSON" not in sources and native.glob(["rules-base.json"], allow_empty = True):
        sources["RULES_JSON"] = [":rules-base.json"]

    # Handle BLOCKS: create sub-macro orfs_flow() targets
    macros = []
    for block_name in config.get("blocks", []):
        block_key = "%s/%s" % (platform, "%s_%s" % (design, block_name))

        # Sub-macro config may use <design>_<block> or just <block> as nickname
        block_config = DESIGNS.get(block_key)
        if not block_config:
            # No parsed config for this block — skip
            # (block may use block.mk or other non-standard config)
            continue

        block_verilog = [
            vf for vf in block_config["verilog_files"]
            if "$(" not in vf and "${" not in vf and "//." not in vf and not vf.endswith(":")
        ]
        block_sources = _convert_sources(block_config["sources"], pkg)
        orfs_flow(
            name = block_config["name"],
            abstract_stage = "cts",
            verilog_files = block_verilog,
            pdk = "//flow:" + platform,
            arguments = block_config["arguments"],
            sources = block_sources,
        )
        macros.append(":%s_generate_abstract" % block_config["name"])

    # Filter verilog_files: skip unresolved Make variables and invalid labels
    verilog_files = []
    for vf in config["verilog_files"]:
        # Skip unresolved Make variables and partial patterns
        if "$(" in vf or "${" in vf or "*" in vf or "))" in vf:
            continue
        # Skip invalid paths
        if "//." in vf or vf.endswith(":"):
            continue
        # Skip platform paths — already in PDK
        if "//flow/platforms/" in vf:
            continue
        # Skip directory references (VERILOG_INCLUDE_DIRS)
        if vf.endswith(":include") or "/include" in vf.split(":")[-1]:
            continue
        verilog_files.append(vf)

    # Collect extra data dependencies for VERILOG_INCLUDE_DIRS
    # Include dir files must be in the sandbox for synthesis to find them
    extra_data = []
    include_dirs = config["arguments"].get("VERILOG_INCLUDE_DIRS", "")
    for inc_dir in include_dirs.replace("\t", " ").split(" "):
        inc_dir = inc_dir.strip().rstrip("/")
        if inc_dir:
            extra_data.append("//" + inc_dir + ":include")

    orfs_flow(
        name = name,
        verilog_files = verilog_files,
        pdk = "//flow:" + platform,
        arguments = config["arguments"],
        sources = sources,
        macros = macros if macros else [],
        stage_data = {"synth": extra_data} if extra_data else {},
    )
