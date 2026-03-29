"""Parser for ORFS config.mk design DSL files.

Parses config.mk files and produces structured data suitable for generating
orfs_flow() Bazel targets. Supports all DSL features found across the 84
config.mk files, with deprecation warnings for features that should be
migrated.

Usage:
    python3 config_mk_parser.py [--lint] [--json] <config.mk> [<config.mk> ...]
    python3 config_mk_parser.py --all <designs_dir>
"""

import argparse
import json
import os
import re
import sys
from dataclasses import asdict, dataclass, field
from pathlib import Path
from typing import Optional


# Variables that map to orfs_flow() structural params (not arguments dict)
STRUCTURAL_VARS = {
    "PLATFORM",
    "DESIGN_NAME",
    "DESIGN_NICKNAME",
    "VERILOG_FILES",
    "SDC_FILE",
    "SRC_HOME",
    "BLOCKS",
}

# Variables that map to orfs_flow() sources dict (file references)
SOURCE_VARS = {
    "SDC_FILE",
    "FASTROUTE_TCL",
    "IO_CONSTRAINTS",
    "MACRO_PLACEMENT_TCL",
    "PDN_TCL",
    "TAPCELL_TCL",
    "FLOORPLAN_DEF",
    "SEAL_GDS",
    "ADDITIONAL_LEFS",
    "ADDITIONAL_LIBS",
    "ADDITIONAL_GDS",
    "SYNTH_NETLIST_FILES",
    "VERILOG_FILES_BLACKBOX",
    # VERILOG_INCLUDE_DIRS are directories, not files — treat as arguments
    # "VERILOG_INCLUDE_DIRS",
    "WRAP_LEFS",
    "WRAP_LIBS",
    "SYNTH_CANONICALIZE_TCL",
    "FOOTPRINT_TCL",
}

# Variables that are purely for path resolution, not passed to orfs_flow()
PATH_ONLY_VARS = {
    "DESIGN_NICKNAME",
    "SRC_HOME",
    "TEMP_DESIGN_DIR",
    "chameleon_DIR",
    "microwatt_DIR",
    "TOP_DESIGN_NICKNAME",
}

# Variables that are structural but not arguments
NON_ARGUMENT_VARS = STRUCTURAL_VARS | PATH_ONLY_VARS

# Deprecated variable references that emit lint warnings
DEPRECATED_REFS = {
    "SRC_HOME": "use $(DESIGN_HOME)/src/$(DESIGN_NICKNAME) instead",
    "WORK_HOME": "use previous_stage in orfs_flow() instead",
    "TOP_DESIGN_NICKNAME": "use explicit parent path instead",
}


@dataclass
class Warning:
    """A lint warning about a deprecated or unsupported DSL feature."""
    line_number: int
    message: str
    category: str  # "deprecated", "unsupported", "info"


@dataclass
class ParsedDesign:
    """Result of parsing a config.mk file."""
    config_path: str           # Path to the config.mk file
    platform: str = ""         # e.g., "asap7"
    design_name: str = ""      # DESIGN_NAME value
    design_nickname: str = ""  # DESIGN_NICKNAME (or dir name default)
    verilog_files: list = field(default_factory=list)   # Bazel labels
    sources: dict = field(default_factory=dict)         # var -> [labels]
    arguments: dict = field(default_factory=dict)       # var -> value
    blocks: list = field(default_factory=list)           # BLOCKS list
    block_configs: list = field(default_factory=list)    # Parsed sub-macros
    has_conditionals: bool = False
    warnings: list = field(default_factory=list)

    def to_dict(self):
        d = asdict(self)
        d["warnings"] = [asdict(w) if isinstance(w, Warning) else w for w in self.warnings]
        d["block_configs"] = [bc.to_dict() if isinstance(bc, ParsedDesign) else bc for bc in self.block_configs]
        return d


def _join_continuation_lines(lines):
    """Join lines ending with backslash continuation."""
    result = []
    current = ""
    current_start_line = 0
    for i, line in enumerate(lines):
        if not current:
            current_start_line = i
        stripped = line.rstrip()
        if stripped.endswith("\\"):
            current += stripped[:-1]
        else:
            current += stripped
            result.append((current_start_line, current))
            current = ""
    if current:
        result.append((current_start_line, current))
    return result


def _strip_inline_comment(value):
    """Remove inline comments from a value, being careful with # in strings."""
    # Simple heuristic: # preceded by whitespace is a comment
    # This handles most cases without full Make parsing
    match = re.search(r'\s#\s', value)
    if match:
        return value[:match.start()].rstrip()
    # Also handle # at start of remaining value after whitespace
    match = re.search(r'\s#[^(]', value)
    if match:
        return value[:match.start()].rstrip()
    return value


class ConfigMkParser:
    """Parser for ORFS config.mk design DSL files."""

    def __init__(self, designs_home="flow/designs", flow_home="flow"):
        self.designs_home = designs_home
        self.flow_home = flow_home

    def parse(self, config_path, base_dir=None):
        """Parse a config.mk file and return a ParsedDesign.

        Args:
            config_path: Path to the config.mk file.
            base_dir: Base directory for resolving relative include paths.
                      Defaults to the directory containing config_path.

        Returns:
            ParsedDesign with all parsed information.
        """
        config_path = str(config_path)
        if base_dir is None:
            base_dir = os.path.dirname(config_path)

        # Derive platform and design dir from path
        # Expected: .../flow/designs/<platform>/<design>/config.mk
        # Or: .../flow/designs/<platform>/<design>/<block>/config.mk
        parts = Path(config_path).parts
        platform = ""
        design_dir_name = ""
        try:
            designs_idx = parts.index("designs")
            if designs_idx + 2 < len(parts):
                platform = parts[designs_idx + 1]
                design_dir_name = parts[designs_idx + 2]
        except (ValueError, IndexError):
            pass

        result = ParsedDesign(config_path=config_path)
        raw_vars = {}  # var_name -> (value, assignment_op, line_number)

        self._parse_file(config_path, base_dir, raw_vars, result, set())

        # Set platform from parsed or derived
        if "PLATFORM" in raw_vars:
            result.platform = raw_vars["PLATFORM"][0].strip()
        elif platform:
            result.platform = platform

        # Set design_name
        if "DESIGN_NAME" in raw_vars:
            result.design_name = raw_vars["DESIGN_NAME"][0].strip()

        # Set design_nickname (defaults to design dir name)
        if "DESIGN_NICKNAME" in raw_vars:
            result.design_nickname = raw_vars["DESIGN_NICKNAME"][0].strip()
        elif design_dir_name:
            result.design_nickname = design_dir_name
        elif result.design_name:
            result.design_nickname = result.design_name

        # Check structural vars for deprecated patterns
        for var_name in ("DESIGN_NICKNAME", "DESIGN_NAME", "PLATFORM"):
            if var_name in raw_vars:
                raw_val = raw_vars[var_name][0]
                line_n = raw_vars[var_name][2]
                if re.search(r'\$\{[A-Za-z_]', raw_val):
                    result.warnings.append(Warning(
                        line_number=line_n,
                        message="${VAR} shell-style syntax: "
                                "use $(VAR) Make-style",
                        category="deprecated",
                    ))

        # Build variable resolution context
        ctx = self._build_context(result, config_path, raw_vars)

        # Process each variable
        for var_name, (value, op, line_num) in raw_vars.items():
            if var_name in ("PLATFORM", "DESIGN_NAME", "DESIGN_NICKNAME"):
                continue
            if var_name in PATH_ONLY_VARS:
                continue

            resolved = self._resolve_refs(value.strip(), ctx, result, line_num)

            if var_name == "VERILOG_FILES":
                result.verilog_files = self._map_verilog_files(
                    resolved, ctx, result, line_num
                )
            elif var_name == "BLOCKS":
                result.blocks = resolved.split()
            elif var_name in SOURCE_VARS:
                labels = self._map_source_file(
                    var_name, resolved, ctx, result, line_num
                )
                if labels:
                    result.sources[var_name] = labels
            elif var_name not in NON_ARGUMENT_VARS:
                result.arguments[var_name] = resolved

        # Process BLOCKS — discover and parse sub-macro configs
        if result.blocks:
            config_dir = os.path.dirname(config_path)
            for block_name in result.blocks:
                block_config = os.path.join(config_dir, block_name, "config.mk")
                if os.path.exists(block_config):
                    block_parsed = self.parse(block_config)
                    result.block_configs.append(block_parsed)

        return result

    def _parse_file(self, filepath, base_dir, raw_vars, result, visited):
        """Parse a single file, handling includes recursively."""
        filepath = os.path.abspath(filepath)
        if filepath in visited:
            return
        visited.add(filepath)

        if not os.path.exists(filepath):
            result.warnings.append(Warning(
                line_number=0,
                message=f"File not found: {filepath}",
                category="error",
            ))
            return

        with open(filepath) as f:
            lines = f.readlines()

        joined = _join_continuation_lines(lines)
        in_conditional = 0  # nesting depth
        conditional_start = None

        for line_num, line in joined:
            stripped = line.strip()

            # Skip empty lines and comments
            if not stripped or stripped.startswith("#"):
                continue

            # Handle conditionals
            if re.match(r'^(ifeq|ifneq|ifdef|ifndef)\b', stripped):
                if in_conditional == 0:
                    conditional_start = line_num + 1
                    result.has_conditionals = True
                    self._warn_conditional(stripped, line_num + 1, result)
                in_conditional += 1
                continue

            if stripped.startswith("else"):
                # else/else ifeq — stay in conditional
                if re.match(r'^else\s+(ifeq|ifneq|ifdef|ifndef)\b', stripped):
                    self._warn_conditional(stripped, line_num + 1, result)
                continue

            if stripped == "endif":
                in_conditional = max(0, in_conditional - 1)
                continue

            # Skip lines inside conditionals for now
            # (we still parse them but mark the design as having conditionals)
            if in_conditional > 0:
                self._parse_assignment(stripped, line_num, raw_vars, result, conditional=True)
                continue

            # Handle include directives
            include_match = re.match(r'^-?include\s+(.+)', stripped)
            if include_match:
                include_path = include_match.group(1).strip()
                result.warnings.append(Warning(
                    line_number=line_num + 1,
                    message=f"include directive: consider inlining the included content",
                    category="deprecated",
                ))
                # Resolve include path
                resolved_path = self._resolve_include_path(include_path, base_dir)
                if resolved_path:
                    self._parse_file(resolved_path, os.path.dirname(resolved_path),
                                     raw_vars, result, visited)
                continue

            # Handle Make target lines (not DSL)
            if re.match(r'^[a-zA-Z_][a-zA-Z0-9_]*:', stripped) and '=' not in stripped:
                result.warnings.append(Warning(
                    line_number=line_num + 1,
                    message=f"Make target in config: move to Makefile",
                    category="deprecated",
                ))
                continue

            # Parse export assignments
            self._parse_assignment(stripped, line_num, raw_vars, result, conditional=False)

    def _parse_assignment(self, line, line_num, raw_vars, result, conditional=False):
        """Parse an export VAR = value line."""
        # Match: export VAR = value, export VAR ?= value, export VAR := value
        # Also: VAR = value (without export), and export VAR=value (no spaces)
        match = re.match(
            r'^(?:export\s+)?([A-Za-z_][A-Za-z0-9_.]*)\s*(\?=|:=|=)\s*(.*)',
            line
        )
        if not match:
            return

        var_name = match.group(1)
        op = match.group(2)
        value = match.group(3).strip()
        value = _strip_inline_comment(value)

        # For ?= only set if not already defined
        if op == "?=" and var_name in raw_vars and not conditional:
            return

        # For conditional assignments, only store if var not already set unconditionally
        if conditional and var_name in raw_vars:
            return

        raw_vars[var_name] = (value, op, line_num + 1)

    def _build_context(self, result, config_path, raw_vars):
        """Build the variable resolution context."""
        config_dir = os.path.dirname(config_path)

        # Determine design_dir relative path from the designs_home
        # e.g., "flow/designs/asap7/gcd"
        try:
            rel_config_dir = str(Path(config_dir).relative_to(
                Path(config_path).parents[len(Path(config_path).parts) - 1]
            ))
        except (ValueError, IndexError):
            rel_config_dir = config_dir

        ctx = {
            "DESIGN_HOME": self.designs_home,
            "PLATFORM": result.platform,
            "DESIGN_NAME": result.design_name,
            "DESIGN_NICKNAME": result.design_nickname,
            "DESIGN_DIR": f"{self.designs_home}/{result.platform}/{result.design_nickname}",
            "PLATFORM_DIR": f"{self.flow_home}/platforms/{result.platform}",
            "FLOW_HOME": self.flow_home,
            "_config_dir": config_dir,
            "_rel_config_dir": rel_config_dir,
        }

        # Add SRC_HOME if defined
        if "SRC_HOME" in raw_vars:
            src_home_val = raw_vars["SRC_HOME"][0].strip()
            # Resolve SRC_HOME itself
            ctx["SRC_HOME"] = self._resolve_refs(src_home_val, ctx, None, 0)
        else:
            ctx["SRC_HOME"] = f"{self.designs_home}/src/{result.design_nickname}"

        # Add any custom variables (like TOP_DESIGN_NICKNAME)
        for var_name in ("TOP_DESIGN_NICKNAME",):
            if var_name in raw_vars:
                val = raw_vars[var_name][0].strip()
                ctx[var_name] = self._resolve_refs(val, ctx, None, 0)

        return ctx

    def _resolve_refs(self, value, ctx, result, line_num):
        """Resolve Make variable references in a value string.

        Handles both $(VAR) and ${VAR} syntax.
        """
        if not value:
            return value

        # Check for deprecated ${VAR} syntax
        if result and re.search(r'\$\{[A-Za-z_]', value):
            result.warnings.append(Warning(
                line_number=line_num,
                message="${VAR} shell-style syntax: use $(VAR) Make-style",
                category="deprecated",
            ))

        # Check for deprecated variable references
        if result:
            for dep_var, msg in DEPRECATED_REFS.items():
                if f"$({dep_var})" in value or f"${{{dep_var}}}" in value:
                    result.warnings.append(Warning(
                        line_number=line_num,
                        message=f"$({dep_var}): {msg}",
                        category="deprecated",
                    ))

        # Check for $(if ...), $(strip ...), $(filter ...), $(and ...) functions
        if result:
            for func in ("if", "strip", "filter", "filter-out", "and"):
                if f"$({func} " in value or f"$({func}\t" in value:
                    result.warnings.append(Warning(
                        line_number=line_num,
                        message=f"$({func} ...): simplify or move complexity to platform config",
                        category="deprecated",
                    ))

        # Handle $(sort $(wildcard ...)) pattern
        sort_wildcard = re.match(
            r'^\$\(sort\s+\$\(wildcard\s+(.+?)\)\s*\)$', value.strip()
        )
        if sort_wildcard:
            return f"$(sort $(wildcard {self._resolve_simple_refs(sort_wildcard.group(1), ctx)}))"

        # Handle $(wildcard ...) pattern
        wildcard = re.match(r'^\$\(wildcard\s+(.+?)\)$', value.strip())
        if wildcard:
            return f"$(wildcard {self._resolve_simple_refs(wildcard.group(1), ctx)})"

        # Handle $(sort $(filter-out ...))
        filter_out = re.match(
            r'^\$\(sort\s+\$\(filter-out\s+(.+?),\s*\$\(wildcard\s+(.+?)\)\s*\)\s*\)$',
            value.strip()
        )
        if filter_out:
            resolved_glob = self._resolve_simple_refs(filter_out.group(2), ctx)
            return f"$(sort $(filter-out {filter_out.group(1)}, $(wildcard {resolved_glob})))"

        # Handle $(if ...) — extract a reasonable default
        if_match = re.match(r'^\$\(if\s+', value.strip())
        if if_match:
            # For $(if) expressions, we can't resolve statically
            # Return the raw value — it will be handled by the caller
            return self._resolve_simple_refs(value, ctx)

        # Handle $(strip ...) — unwrap
        strip_match = re.match(r'^\$\(strip\s+(.*)\)$', value.strip())
        if strip_match:
            inner = strip_match.group(1).strip()
            return self._resolve_refs(inner, ctx, result, line_num)

        # Simple variable resolution
        return self._resolve_simple_refs(value, ctx)

    def _resolve_simple_refs(self, value, ctx):
        """Replace $(VAR) and ${VAR} with their values from context."""
        def replace_var(match):
            var_name = match.group(1) or match.group(2)
            if var_name in ctx:
                return ctx[var_name]
            return match.group(0)  # Leave unresolved

        # Replace $(VAR) and ${VAR} patterns (only simple variable refs)
        result = re.sub(r'\$\(([A-Za-z_][A-Za-z0-9_]*)\)|\$\{([A-Za-z_][A-Za-z0-9_]*)\}',
                        replace_var, value)
        return result

    def _map_verilog_files(self, resolved, ctx, result, line_num):
        """Map resolved VERILOG_FILES value to Bazel labels."""
        labels = []

        # Handle $(sort $(wildcard <path>/*.v)) or $(sort $(wildcard <path>/*.sv))
        # This is the most common pattern
        sort_wc_match = re.match(
            r'^\$\(sort\s+\$\(wildcard\s+(.+?)/\*\.(v|sv)\s*\)\s*\)$',
            resolved.strip()
        )
        if sort_wc_match:
            dir_path = sort_wc_match.group(1)
            label = self._dir_to_verilog_label(dir_path)
            return [label]

        # Handle $(wildcard <path>/*.v) without sort
        wc_match = re.match(
            r'^\$\(wildcard\s+(.+?)/\*\.(v|sv)\s*\)\s*$',
            resolved.strip()
        )
        if wc_match:
            dir_path = wc_match.group(1)
            label = self._dir_to_verilog_label(dir_path)
            return [label]

        # Handle bare glob pattern (no $(wildcard)): path/*.v
        bare_glob = re.match(r'^(.+?)/\*\.(v|sv)\s*$', resolved.strip())
        if bare_glob and "$(" not in resolved:
            dir_path = bare_glob.group(1)
            result.warnings.append(Warning(
                line_number=line_num,
                message="bare glob without $(wildcard): use $(sort $(wildcard ...))",
                category="deprecated",
            ))
            label = self._dir_to_verilog_label(dir_path)
            return [label]

        # Handle $(sort $(filter-out ...)) pattern — map the wildcard part
        filter_out_match = re.match(
            r'^\$\(sort\s+\$\(filter-out\s+.+?,\s*\$\(wildcard\s+(.+?)/\*\.(v|sv)\s*\)\s*\)\s*\)$',
            resolved.strip()
        )
        if filter_out_match:
            dir_path = filter_out_match.group(1)
            label = self._dir_to_verilog_label(dir_path)
            return [label]

        # Handle multi-glob with sort (e.g., cva6 with many $(sort $(wildcard ...)) joined)
        # Split on whitespace and process each token
        tokens = resolved.split()
        multi_sort = False
        for token in tokens:
            token = token.strip()
            if not token:
                continue
            swm = re.match(r'^\$\(sort\s+\$\(wildcard\s+(.+?)/\*\.(v|sv|svh)\s*\)\s*\)$', token)
            if swm:
                dir_path = swm.group(1)
                labels.append(self._dir_to_verilog_label(dir_path))
                multi_sort = True
                continue
            wm = re.match(r'^\$\(wildcard\s+(.+?)/\*\.(v|sv|svh)\s*\)$', token)
            if wm:
                dir_path = wm.group(1)
                labels.append(self._dir_to_verilog_label(dir_path))
                multi_sort = True
                continue
            # Single file reference
            label = self._file_to_label(token, result, line_num)
            if label:
                labels.append(label)

        if labels:
            return labels

        # Fallback: try to map as a single file or unresolved
        label = self._file_to_label(resolved.strip(), result, line_num)
        if label:
            return [label]

        return [resolved]  # Return raw if can't resolve

    def _dir_to_verilog_label(self, dir_path):
        """Convert a directory path to a //flow/designs/src/<name>:verilog label."""
        # Normalize path
        dir_path = dir_path.strip().rstrip("/")

        # Check if it's under designs/src/
        src_match = re.search(r'(?:flow/)?designs/src/([^/]+)(?:/.*)?$', dir_path)
        if src_match:
            src_name = src_match.group(1)
            return f"//flow/designs/src/{src_name}:verilog"

        # Check if it's under flow/platforms/ (deprecated)
        plat_match = re.search(r'(?:flow/)?platforms/([^/]+)(/.*)?$', dir_path)
        if plat_match:
            return f"//flow/platforms/{plat_match.group(1)}{plat_match.group(2) or ''}:verilog"

        return f"//{dir_path}:verilog"

    def _file_to_label(self, path, result, line_num):
        """Convert a file path to a Bazel label."""
        if not path or path.startswith("$("):
            return path  # Can't resolve
        return self._path_to_label(path.strip(), result, line_num)

    def _map_source_file(self, var_name, resolved, ctx, result, line_num):
        """Map a source file variable to Bazel labels.

        Always produces absolute labels (//pkg:file) so they work
        from external repos like @orfs_designs.
        """
        if not resolved:
            return []

        labels = []

        # Split on whitespace for multi-file variables
        tokens = resolved.split()
        for token in tokens:
            token = token.strip()
            if not token:
                continue

            label = self._path_to_label(token, result, line_num)
            if label:
                labels.append(label)

        return labels

    def _path_to_label(self, path, result, line_num):
        """Convert a resolved file path to a proper //pkg:file Bazel label."""
        if not path:
            return path

        # Already a label
        if path.startswith("//") or path.startswith("@"):
            return path

        # Unresolved variable refs — pass through
        if "$(" in path or "${" in path:
            return path

        # Normalize: ensure path starts with flow/
        if not path.startswith("flow/"):
            if path.startswith(f"{self.designs_home}/"):
                path = f"flow/{path}"
            elif path.startswith(f"{self.flow_home}/"):
                pass  # already has flow/ prefix conceptually
            else:
                # Relative path without flow/ prefix
                if result:
                    result.warnings.append(Warning(
                        line_number=line_num,
                        message="relative path without $(DESIGN_HOME): "
                                "use $(DESIGN_HOME) prefix",
                        category="deprecated",
                    ))
                if path.startswith("designs/"):
                    path = f"flow/{path}"

        # Split into package and file: //dir:filename
        if "/" in path:
            dir_part = os.path.dirname(path)
            file_part = os.path.basename(path)
            return f"//{dir_part}:{file_part}"

        return path

    def _resolve_include_path(self, include_path, base_dir):
        """Resolve an include directive path."""
        # Try relative to base_dir first
        candidate = os.path.join(base_dir, include_path)
        if os.path.exists(candidate):
            return candidate

        # Try relative to CWD (for paths like "designs/asap7/riscv32i/config.mk")
        if os.path.exists(include_path):
            return include_path

        # Try relative to flow/
        flow_candidate = os.path.join("flow", include_path)
        if os.path.exists(flow_candidate):
            return flow_candidate

        return None

    def _warn_conditional(self, line, line_num, result):
        """Add a warning for conditional blocks."""
        if "FLOW_VARIANT" in line:
            result.warnings.append(Warning(
                line_number=line_num,
                message="ifeq FLOW_VARIANT: split into separate config.mk per variant",
                category="deprecated",
            ))
        elif "USE_FILL" in line:
            result.warnings.append(Warning(
                line_number=line_num,
                message="ifeq USE_FILL: set DESIGN_TYPE unconditionally",
                category="deprecated",
            ))
        elif "BLOCKS" in line:
            result.warnings.append(Warning(
                line_number=line_num,
                message="ifeq BLOCKS: use separate config for with/without blocks",
                category="deprecated",
            ))
        elif "SYNTH_MOCK_LARGE_MEMORIES" in line:
            result.warnings.append(Warning(
                line_number=line_num,
                message="ifeq SYNTH_MOCK_LARGE_MEMORIES: simplify to unconditional",
                category="deprecated",
            ))
        else:
            # Generic conditional warning
            cond_var = re.search(r'\$\((\w+)\)', line)
            var_name = cond_var.group(1) if cond_var else "unknown"
            result.warnings.append(Warning(
                line_number=line_num,
                message=f"ifeq {var_name}: consider simplifying or removing conditional",
                category="deprecated",
            ))


def generate_orfs_flow(parsed, module_name="orfs"):
    """Generate an orfs_flow() Bazel target string from a ParsedDesign.

    Args:
        parsed: ParsedDesign instance.
        module_name: Module name for cross-repo labels (e.g., "orfs").

    Returns:
        String containing the orfs_flow() Bazel call.
    """
    lines = []
    lines.append('load("@bazel-orfs//:openroad.bzl", "orfs_flow")')
    lines.append("")

    # Generate sub-macro targets first
    for block_config in parsed.block_configs:
        lines.append(f"# Sub-macro: {block_config.design_name}")
        lines.append(_format_orfs_flow_call(block_config, module_name, abstract_stage="cts"))
        lines.append("")

    # Generate main target
    if parsed.warnings:
        has_deprecated = any(w.category == "deprecated" for w in parsed.warnings
                            if isinstance(w, Warning))
        if has_deprecated:
            lines.append("# NOTE: This config uses deprecated features. Run the linter for details.")
    lines.append(f"# Auto-generated from {os.path.basename(parsed.config_path)}")
    lines.append(_format_orfs_flow_call(parsed, module_name))
    return "\n".join(lines) + "\n"


def _format_orfs_flow_call(parsed, module_name, abstract_stage=None):
    """Format a single orfs_flow() call."""
    parts = []

    # name
    name = parsed.design_name or parsed.design_nickname
    parts.append(f'    name = "{name}",')

    # top (only if different from name)
    if parsed.design_name and parsed.design_name != name:
        parts.append(f'    top = "{parsed.design_name}",')

    # abstract_stage (for sub-macros)
    if abstract_stage:
        parts.append(f'    abstract_stage = "{abstract_stage}",')

    # verilog_files
    if parsed.verilog_files:
        if len(parsed.verilog_files) == 1:
            vf = parsed.verilog_files[0]
            # Add module prefix for cross-repo refs
            if vf.startswith("//"):
                vf = f"@{module_name}{vf}"
            parts.append(f'    verilog_files = ["{vf}"],')
        else:
            parts.append("    verilog_files = [")
            for vf in parsed.verilog_files:
                if vf.startswith("//"):
                    vf = f"@{module_name}{vf}"
                parts.append(f'        "{vf}",')
            parts.append("    ],")

    # pdk
    pdk_label = f"@{module_name}//flow:{parsed.platform}"
    parts.append(f'    pdk = "{pdk_label}",')

    # macros (from BLOCKS)
    if parsed.block_configs:
        macro_refs = []
        for bc in parsed.block_configs:
            bn = bc.design_name or bc.design_nickname
            macro_refs.append(f'        ":{bn}_generate_abstract",')
        parts.append("    macros = [")
        parts.extend(macro_refs)
        parts.append("    ],")

    # arguments
    if parsed.arguments:
        parts.append("    arguments = {")
        for key in sorted(parsed.arguments.keys()):
            val = parsed.arguments[key]
            parts.append(f'        "{key}": "{val}",')
        parts.append("    },")

    # sources
    if parsed.sources:
        parts.append("    sources = {")
        for key in sorted(parsed.sources.keys()):
            vals = parsed.sources[key]
            formatted_vals = []
            for v in vals:
                if v.startswith("//"):
                    v = f"@{module_name}{v}"
                formatted_vals.append(f'"{v}"')
            parts.append(f'        "{key}": [{", ".join(formatted_vals)}],')
        parts.append("    },")

    return "orfs_flow(\n" + "\n".join(parts) + "\n)"


def lint_report(parsed):
    """Generate a human-readable lint report for a ParsedDesign."""
    lines = []
    for w in parsed.warnings:
        if isinstance(w, Warning):
            prefix = {
                "deprecated": "WARNING",
                "unsupported": "ERROR",
                "info": "INFO",
                "error": "ERROR",
            }.get(w.category, "WARNING")
            lines.append(f"{parsed.config_path}:{w.line_number}: {prefix}: {w.message}")
        else:
            lines.append(str(w))
    return "\n".join(lines)


def discover_configs(designs_dir, platforms=None):
    """Discover all config.mk files under a designs directory.

    Args:
        designs_dir: Path to the designs directory.
        platforms: Optional list of platforms to include. If None, all platforms.

    Returns:
        List of config.mk file paths.
    """
    configs = []
    designs_path = Path(designs_dir)
    if not designs_path.exists():
        return configs

    for platform_dir in sorted(designs_path.iterdir()):
        if not platform_dir.is_dir():
            continue
        if platform_dir.name == "src":
            continue
        if platforms and platform_dir.name not in platforms:
            continue
        for design_dir in sorted(platform_dir.iterdir()):
            if not design_dir.is_dir():
                continue
            config_mk = design_dir / "config.mk"
            if config_mk.exists():
                configs.append(str(config_mk))
    return configs


def main():
    parser = argparse.ArgumentParser(
        description="Parse ORFS config.mk design DSL files"
    )
    parser.add_argument("configs", nargs="*", help="config.mk files to parse")
    parser.add_argument("--all", metavar="DESIGNS_DIR",
                        help="Discover and parse all config.mk files under DESIGNS_DIR")
    parser.add_argument("--platforms", help="Comma-separated list of platforms to include")
    parser.add_argument("--lint", action="store_true",
                        help="Print lint warnings instead of parsed output")
    parser.add_argument("--json", action="store_true",
                        help="Output as JSON")
    parser.add_argument("--generate", action="store_true",
                        help="Generate orfs_flow() Bazel targets")
    parser.add_argument("--module-name", default="orfs",
                        help="Module name for cross-repo labels")

    args = parser.parse_args()

    configs = list(args.configs)
    if args.all:
        platforms = args.platforms.split(",") if args.platforms else None
        configs.extend(discover_configs(args.all, platforms))

    if not configs:
        parser.print_help()
        sys.exit(1)

    mk_parser = ConfigMkParser()
    results = []
    exit_code = 0

    for config_path in configs:
        parsed = mk_parser.parse(config_path)
        results.append(parsed)

        if args.lint:
            report = lint_report(parsed)
            if report:
                print(report)
                exit_code = 1
        elif args.generate:
            print(generate_orfs_flow(parsed, args.module_name))
        elif args.json:
            pass  # Batch output below
        else:
            # Default: print summary
            print(f"{config_path}:")
            print(f"  platform: {parsed.platform}")
            print(f"  design_name: {parsed.design_name}")
            print(f"  design_nickname: {parsed.design_nickname}")
            print(f"  verilog_files: {parsed.verilog_files}")
            print(f"  sources: {parsed.sources}")
            print(f"  arguments: {parsed.arguments}")
            print(f"  blocks: {parsed.blocks}")
            print(f"  has_conditionals: {parsed.has_conditionals}")
            if parsed.warnings:
                print(f"  warnings: {len(parsed.warnings)}")
            print()

    if args.json:
        output = [r.to_dict() for r in results]
        print(json.dumps(output, indent=2))

    sys.exit(exit_code)


if __name__ == "__main__":
    main()
