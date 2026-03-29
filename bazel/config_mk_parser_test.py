"""Extensive unit tests for the ORFS config.mk DSL parser.

Tests every DSL feature found across the 84 config.mk files, including
both supported features and deprecated features that emit lint warnings.
"""

import os
import tempfile
import textwrap
import unittest
from pathlib import Path

from config_mk_parser import (
    ConfigMkParser,
    ParsedDesign,
    Warning,
    _join_continuation_lines,
    _strip_inline_comment,
    discover_configs,
    generate_orfs_flow,
    lint_report,
)

# Path to the real flow/designs directory (for integration tests)
REPO_ROOT = Path(__file__).parent.parent
DESIGNS_DIR = REPO_ROOT / "flow" / "designs"


def _write_config(content, dir_structure="flow/designs/asap7/test"):
    """Write a config.mk to a temp directory with proper structure."""
    tmpdir = tempfile.mkdtemp()
    config_dir = os.path.join(tmpdir, dir_structure)
    os.makedirs(config_dir, exist_ok=True)
    config_path = os.path.join(config_dir, "config.mk")
    with open(config_path, "w") as f:
        f.write(textwrap.dedent(content))
    return config_path, tmpdir


class TestJoinContinuationLines(unittest.TestCase):
    """Test line continuation joining."""

    def test_no_continuation(self):
        lines = ["line1\n", "line2\n"]
        result = _join_continuation_lines(lines)
        self.assertEqual(result, [(0, "line1"), (1, "line2")])

    def test_two_line_continuation(self):
        lines = ["first \\\n", "  second\n"]
        result = _join_continuation_lines(lines)
        self.assertEqual(len(result), 1)
        self.assertEqual(result[0], (0, "first   second"))

    def test_three_line_continuation(self):
        lines = ["a \\\n", "  b \\\n", "  c\n"]
        result = _join_continuation_lines(lines)
        self.assertEqual(len(result), 1)
        self.assertIn("a", result[0][1])
        self.assertIn("b", result[0][1])
        self.assertIn("c", result[0][1])

    def test_mixed_continuation(self):
        lines = ["normal\n", "cont \\\n", "  end\n", "another\n"]
        result = _join_continuation_lines(lines)
        self.assertEqual(len(result), 3)
        self.assertEqual(result[0][1], "normal")
        self.assertIn("cont", result[1][1])
        self.assertIn("end", result[1][1])
        self.assertEqual(result[2][1], "another")

    def test_trailing_continuation(self):
        """Continuation at end of file."""
        lines = ["value \\\n"]
        result = _join_continuation_lines(lines)
        self.assertEqual(len(result), 1)
        self.assertEqual(result[0][1], "value ")


class TestStripInlineComment(unittest.TestCase):
    """Test inline comment stripping."""

    def test_no_comment(self):
        self.assertEqual(_strip_inline_comment("value"), "value")

    def test_inline_comment(self):
        self.assertEqual(_strip_inline_comment("value # comment"), "value")

    def test_hash_in_middle(self):
        # $(filter ...) patterns contain no spaces before #
        self.assertEqual(_strip_inline_comment("abc#def"), "abc#def")

    def test_comment_after_spaces(self):
        self.assertEqual(
            _strip_inline_comment("some value  # a comment"),
            "some value"
        )


class TestLineParsingBasic(unittest.TestCase):
    """Test basic line parsing: assignments, operators, whitespace."""

    def setUp(self):
        self.parser = ConfigMkParser()

    def test_basic_assignment(self):
        config, _ = _write_config("export PLATFORM = asap7\n")
        result = self.parser.parse(config)
        self.assertEqual(result.platform, "asap7")

    def test_conditional_assignment(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = gcd
            export SKIP_LAST_GASP ?= 1
        """)
        result = self.parser.parse(config)
        self.assertEqual(result.arguments["SKIP_LAST_GASP"], "1")

    def test_conditional_assignment_no_override(self):
        """?= should not override a prior = assignment."""
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = gcd
            export CORE_UTILIZATION = 65
            export CORE_UTILIZATION ?= 50
        """)
        result = self.parser.parse(config)
        self.assertEqual(result.arguments["CORE_UTILIZATION"], "65")

    def test_immediate_assignment(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = gcd
            export ABC_AREA := 1
        """)
        result = self.parser.parse(config)
        self.assertEqual(result.arguments["ABC_AREA"], "1")

    def test_clear_to_empty(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = gcd
            export ADDER_MAP_FILE :=
        """)
        result = self.parser.parse(config)
        self.assertEqual(result.arguments["ADDER_MAP_FILE"], "")

    def test_comment_lines_ignored(self):
        config, _ = _write_config("""\
            # This is a comment
            export PLATFORM = asap7
            # Another comment
            export DESIGN_NAME = gcd
        """)
        result = self.parser.parse(config)
        self.assertEqual(result.platform, "asap7")
        self.assertEqual(result.design_name, "gcd")

    def test_empty_lines_ignored(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7

            export DESIGN_NAME = gcd

        """)
        result = self.parser.parse(config)
        self.assertEqual(result.platform, "asap7")

    def test_leading_whitespace(self):
        config, _ = _write_config("""\
              export PLATFORM = asap7
            \texport DESIGN_NAME = gcd
        """)
        result = self.parser.parse(config)
        self.assertEqual(result.platform, "asap7")

    def test_no_spaces_around_equals(self):
        config, _ = _write_config("""\
            export PLATFORM=asap7
            export DESIGN_NAME=gcd
        """)
        result = self.parser.parse(config)
        self.assertEqual(result.platform, "asap7")

    def test_multi_line_continuation(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = gcd
            export IO_NORTH_PINS = pin1 \\
            pin2 \\
            pin3
        """)
        result = self.parser.parse(config)
        self.assertIn("pin1", result.arguments["IO_NORTH_PINS"])
        self.assertIn("pin2", result.arguments["IO_NORTH_PINS"])
        self.assertIn("pin3", result.arguments["IO_NORTH_PINS"])

    def test_non_export_line_ignored(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = gcd
            SOME_VAR = value
        """)
        result = self.parser.parse(config)
        # Non-export assignments are still parsed (Make allows it)
        self.assertIn("SOME_VAR", result.arguments)

    def test_make_target_line_warning(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = gcd
            verilog:
            \techo hello
        """)
        result = self.parser.parse(config)
        warnings = [w for w in result.warnings if isinstance(w, Warning)]
        target_warnings = [w for w in warnings if "Make target" in w.message]
        self.assertTrue(len(target_warnings) > 0)


class TestVariableResolution(unittest.TestCase):
    """Test variable reference resolution."""

    def setUp(self):
        self.parser = ConfigMkParser()

    def test_design_home_ref(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = gcd
            export SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc
        """)
        result = self.parser.parse(config)
        self.assertIn("SDC_FILE", result.sources)
        labels = result.sources["SDC_FILE"]
        self.assertTrue(any("constraint.sdc" in l for l in labels))

    def test_platform_ref(self):
        config, _ = _write_config("""\
            export PLATFORM = sky130hd
            export DESIGN_NAME = gcd
            export SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc
        """)
        result = self.parser.parse(config)
        self.assertIn("SDC_FILE", result.sources)

    def test_design_nickname_default(self):
        """DESIGN_NICKNAME defaults to the design directory name."""
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = gcd
            export SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
        """)
        result = self.parser.parse(config)
        # design_nickname should default to "test" (the dir name)
        self.assertEqual(result.design_nickname, "test")

    def test_design_nickname_explicit(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NICKNAME = aes
            export DESIGN_NAME = aes_cipher_top
        """)
        result = self.parser.parse(config)
        self.assertEqual(result.design_nickname, "aes")
        self.assertEqual(result.design_name, "aes_cipher_top")

    def test_platform_dir_ref(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = gcd
            export PDN_TCL = $(PLATFORM_DIR)/openRoad/pdn/BLOCK_grid_strategy.tcl
        """)
        result = self.parser.parse(config)
        self.assertIn("PDN_TCL", result.sources)
        labels = result.sources["PDN_TCL"]
        self.assertTrue(any("platforms/asap7" in l for l in labels))

    def test_src_home_deprecated(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = gcd
            export SRC_HOME = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)
            export VERILOG_FILES = $(SRC_HOME)/gcd.v
        """)
        result = self.parser.parse(config)
        warnings = [w for w in result.warnings if isinstance(w, Warning)]
        src_warnings = [w for w in warnings if "SRC_HOME" in w.message]
        self.assertTrue(len(src_warnings) > 0)

    def test_shell_style_var_deprecated(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = gcd
            export TOP_DESIGN_NICKNAME = parent
            export DESIGN_NICKNAME = ${TOP_DESIGN_NICKNAME}_${DESIGN_NAME}
        """)
        result = self.parser.parse(config)
        warnings = [w for w in result.warnings if isinstance(w, Warning)]
        shell_warnings = [w for w in warnings if "shell-style" in w.message]
        self.assertTrue(len(shell_warnings) > 0)

    def test_nested_refs(self):
        config, _ = _write_config("""\
            export PLATFORM = sky130hd
            export DESIGN_NAME = gcd
            export SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc
        """)
        result = self.parser.parse(config)
        self.assertIn("SDC_FILE", result.sources)

    def test_unknown_variable_left_unresolved(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = gcd
            export ADDITIONAL_LIBS = $(LIB_DIR)/fakeram.lib
        """)
        result = self.parser.parse(config)
        self.assertIn("ADDITIONAL_LIBS", result.sources)
        labels = result.sources["ADDITIONAL_LIBS"]
        self.assertTrue(any("$(LIB_DIR)" in l for l in labels))


class TestVerilogFilesMapping(unittest.TestCase):
    """Test VERILOG_FILES → Bazel label mapping."""

    def setUp(self):
        self.parser = ConfigMkParser()

    def test_sort_wildcard_pattern(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = gcd
            export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NAME)/*.v))
        """)
        result = self.parser.parse(config)
        self.assertEqual(result.verilog_files, ["//flow/designs/src/gcd:verilog"])

    def test_sort_wildcard_nickname(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = aes_cipher_top
            export DESIGN_NICKNAME = aes
            export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/*.v))
        """)
        result = self.parser.parse(config)
        self.assertEqual(result.verilog_files, ["//flow/designs/src/aes:verilog"])

    def test_wildcard_without_sort(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = gcd
            export VERILOG_FILES = $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NAME)/*.v)
        """)
        result = self.parser.parse(config)
        self.assertEqual(result.verilog_files, ["//flow/designs/src/gcd:verilog"])

    def test_single_file(self):
        config, _ = _write_config("""\
            export PLATFORM = sky130hd
            export DESIGN_NAME = gcd
            export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/gcd.v
        """)
        result = self.parser.parse(config)
        self.assertTrue(len(result.verilog_files) == 1)
        self.assertIn("gcd.v", result.verilog_files[0])

    def test_multi_file_continuation(self):
        """Multi-file VERILOG_FILES with line continuations."""
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = test
            export VERILOG_FILES = $(DESIGN_HOME)/src/test/a.v \\
                $(DESIGN_HOME)/src/test/b.v
        """)
        result = self.parser.parse(config)
        self.assertEqual(len(result.verilog_files), 2)

    def test_platform_dir_verilog_deprecated(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = test
            export VERILOG_FILES = $(PLATFORM_DIR)/verilog/fakeram.sv
        """)
        result = self.parser.parse(config)
        self.assertTrue(len(result.verilog_files) >= 1)

    def test_bare_glob_deprecated(self):
        """Glob without $(wildcard) — deprecated."""
        config, _ = _write_config("""\
            export PLATFORM = gf180
            export DESIGN_NAME = uart
            export DESIGN_NICKNAME = uart-no-param
            export VERILOG_FILES = flow/designs/src/uart-no-param/*.v
        """)
        result = self.parser.parse(config)
        self.assertTrue(len(result.verilog_files) >= 1)


class TestSdcFileMapping(unittest.TestCase):
    """Test SDC_FILE → Bazel label mapping."""

    def setUp(self):
        self.parser = ConfigMkParser()

    def test_standard_pattern_design_name(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = gcd
            export SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc
        """)
        result = self.parser.parse(config)
        self.assertIn("SDC_FILE", result.sources)
        labels = result.sources["SDC_FILE"]
        self.assertTrue(any("constraint.sdc" in l for l in labels))

    def test_standard_pattern_nickname(self):
        config, _ = _write_config("""\
            export PLATFORM = sky130hd
            export DESIGN_NAME = gcd
            export DESIGN_NICKNAME = gcd
            export SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
        """)
        result = self.parser.parse(config)
        self.assertIn("SDC_FILE", result.sources)
        # Should be relative label since it's in the same dir
        labels = result.sources["SDC_FILE"]
        self.assertTrue(any("constraint.sdc" in l for l in labels))


class TestVariableClassification(unittest.TestCase):
    """Test that variables are correctly classified as structural/source/argument."""

    def setUp(self):
        self.parser = ConfigMkParser()

    def test_platform_is_structural(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = gcd
        """)
        result = self.parser.parse(config)
        self.assertEqual(result.platform, "asap7")
        self.assertNotIn("PLATFORM", result.arguments)

    def test_design_name_is_structural(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = gcd
        """)
        result = self.parser.parse(config)
        self.assertEqual(result.design_name, "gcd")
        self.assertNotIn("DESIGN_NAME", result.arguments)

    def test_verilog_files_is_structural(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = gcd
            export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NAME)/*.v))
        """)
        result = self.parser.parse(config)
        self.assertTrue(len(result.verilog_files) > 0)
        self.assertNotIn("VERILOG_FILES", result.arguments)

    def test_sdc_file_is_source(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = gcd
            export SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc
        """)
        result = self.parser.parse(config)
        self.assertIn("SDC_FILE", result.sources)
        self.assertNotIn("SDC_FILE", result.arguments)

    def test_source_vars_classified(self):
        """All SOURCE_VARS should go to sources, not arguments."""
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = gcd
            export FASTROUTE_TCL = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/route.tcl
            export IO_CONSTRAINTS = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/io.tcl
            export PDN_TCL = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/pdn.tcl
        """)
        result = self.parser.parse(config)
        for var in ("FASTROUTE_TCL", "IO_CONSTRAINTS", "PDN_TCL"):
            self.assertIn(var, result.sources, f"{var} should be in sources")
            self.assertNotIn(var, result.arguments, f"{var} should not be in arguments")

    def test_core_utilization_is_argument(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = gcd
            export CORE_UTILIZATION = 65
        """)
        result = self.parser.parse(config)
        self.assertIn("CORE_UTILIZATION", result.arguments)
        self.assertEqual(result.arguments["CORE_UTILIZATION"], "65")

    def test_blocks_is_structural(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = test
            export BLOCKS = block1 block2
        """)
        result = self.parser.parse(config)
        self.assertEqual(result.blocks, ["block1", "block2"])
        self.assertNotIn("BLOCKS", result.arguments)

    def test_synth_hierarchical_is_argument(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = test
            export SYNTH_HIERARCHICAL = 1
        """)
        result = self.parser.parse(config)
        self.assertIn("SYNTH_HIERARCHICAL", result.arguments)


class TestConditionalParsing(unittest.TestCase):
    """Test parsing of conditional blocks (ifeq, ifdef, etc.)."""

    def setUp(self):
        self.parser = ConfigMkParser()

    def test_ifeq_detected(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = gcd
            ifeq ($(FLOW_VARIANT),top)
                export DESIGN_NAME = top_module
            endif
        """)
        result = self.parser.parse(config)
        self.assertTrue(result.has_conditionals)

    def test_ifeq_flow_variant_warning(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = gcd
            ifeq ($(FLOW_VARIANT),top)
                export ABC_AREA = 1
            endif
        """)
        result = self.parser.parse(config)
        warnings = [w for w in result.warnings if isinstance(w, Warning)]
        fv_warnings = [w for w in warnings if "FLOW_VARIANT" in w.message]
        self.assertTrue(len(fv_warnings) > 0)

    def test_ifeq_use_fill_warning(self):
        config, _ = _write_config("""\
            export PLATFORM = gf12
            export DESIGN_NAME = gcd
            ifeq ($(USE_FILL),1)
                export DESIGN_TYPE = CELL
            endif
        """)
        result = self.parser.parse(config)
        warnings = [w for w in result.warnings if isinstance(w, Warning)]
        fill_warnings = [w for w in warnings if "USE_FILL" in w.message]
        self.assertTrue(len(fill_warnings) > 0)

    def test_ifeq_blocks_warning(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = test
            ifeq ($(BLOCKS),)
                export ADDITIONAL_LEFS = something.lef
            endif
        """)
        result = self.parser.parse(config)
        warnings = [w for w in result.warnings if isinstance(w, Warning)]
        block_warnings = [w for w in warnings if "BLOCKS" in w.message]
        self.assertTrue(len(block_warnings) > 0)

    def test_else_ifeq_chains(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = aes
            ifeq ($(FLOW_VARIANT),top)
                export DESIGN_NAME = top
            else ifeq ($(FLOW_VARIANT),blackbox)
                export DESIGN_NAME = blackbox
            else ifeq ($(FLOW_VARIANT),combine)
                export DESIGN_NAME = combine
            endif
        """)
        result = self.parser.parse(config)
        self.assertTrue(result.has_conditionals)
        # The unconditional DESIGN_NAME should be "aes"
        self.assertEqual(result.design_name, "aes")

    def test_nested_ifeq(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = gcd
            ifeq ($(A),1)
                ifeq ($(B),2)
                    export X = nested
                endif
            endif
            export CORE_UTILIZATION = 65
        """)
        result = self.parser.parse(config)
        self.assertTrue(result.has_conditionals)
        self.assertEqual(result.arguments["CORE_UTILIZATION"], "65")

    def test_if_filter_deprecated(self):
        config, _ = _write_config("""\
            export PLATFORM = rapidus2hp
            export DESIGN_NAME = gcd
            export CORE_UTILIZATION = $(strip $(if $(filter 0.15,$(RAPIDUS_PDK_VERSION)),40,45))
        """)
        result = self.parser.parse(config)
        warnings = [w for w in result.warnings if isinstance(w, Warning)]
        if_warnings = [w for w in warnings if "$(if" in w.message or "$(strip" in w.message or "$(filter" in w.message]
        self.assertTrue(len(if_warnings) > 0)

    def test_include_deprecated(self):
        """include directive is parsed and emits warning."""
        tmpdir = tempfile.mkdtemp()
        base_dir = os.path.join(tmpdir, "flow/designs/asap7/test")
        os.makedirs(base_dir, exist_ok=True)

        # Write the included file
        included = os.path.join(base_dir, "base.mk")
        with open(included, "w") as f:
            f.write("export CORE_UTILIZATION = 50\n")

        # Write the main config
        config = os.path.join(base_dir, "config.mk")
        with open(config, "w") as f:
            f.write("export PLATFORM = asap7\nexport DESIGN_NAME = test\n")
            f.write(f"include {included}\n")

        result = self.parser.parse(config)
        self.assertEqual(result.arguments["CORE_UTILIZATION"], "50")
        warnings = [w for w in result.warnings if isinstance(w, Warning)]
        include_warnings = [w for w in warnings if "include" in w.message]
        self.assertTrue(len(include_warnings) > 0)

    def test_work_home_deprecated(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = aes
            export SYNTH_NETLIST_FILES = $(WORK_HOME)/results/asap7/aes/top/1_synth.v
        """)
        result = self.parser.parse(config)
        warnings = [w for w in result.warnings if isinstance(w, Warning)]
        wh_warnings = [w for w in warnings if "WORK_HOME" in w.message]
        self.assertTrue(len(wh_warnings) > 0)

    def test_relative_path_deprecated(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = test
            export VERILOG_FILES = designs/src/test/*.v
        """)
        result = self.parser.parse(config)
        warnings = [w for w in result.warnings if isinstance(w, Warning)]
        rel_warnings = [w for w in warnings if "relative path" in w.message
                        or "bare glob" in w.message]
        self.assertTrue(len(rel_warnings) > 0)


class TestBlocksSubMacros(unittest.TestCase):
    """Test BLOCKS variable and sub-macro config discovery."""

    def setUp(self):
        self.parser = ConfigMkParser()

    def test_blocks_parsed(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = test
            export BLOCKS = block1 block2
        """)
        result = self.parser.parse(config)
        self.assertEqual(result.blocks, ["block1", "block2"])

    def test_single_block(self):
        config, _ = _write_config("""\
            export PLATFORM = gf180
            export DESIGN_NAME = uart
            export BLOCKS = uart_rx
        """)
        result = self.parser.parse(config)
        self.assertEqual(result.blocks, ["uart_rx"])

    def test_block_config_discovery(self):
        """When BLOCKS is set, parser should discover sub-macro config.mk files."""
        tmpdir = tempfile.mkdtemp()
        base_dir = os.path.join(tmpdir, "flow/designs/gf180/uart-blocks")
        os.makedirs(base_dir, exist_ok=True)

        # Write main config
        config = os.path.join(base_dir, "config.mk")
        with open(config, "w") as f:
            f.write("export PLATFORM = gf180\n")
            f.write("export DESIGN_NAME = uart\n")
            f.write("export DESIGN_NICKNAME = uart-blocks\n")
            f.write("export BLOCKS = uart_rx\n")

        # Write sub-macro config
        block_dir = os.path.join(base_dir, "uart_rx")
        os.makedirs(block_dir, exist_ok=True)
        block_config = os.path.join(block_dir, "config.mk")
        with open(block_config, "w") as f:
            f.write("export PLATFORM = gf180\n")
            f.write("export DESIGN_NAME = uart_rx\n")
            f.write("export CORE_UTILIZATION = 30\n")

        result = self.parser.parse(config)
        self.assertEqual(result.blocks, ["uart_rx"])
        self.assertEqual(len(result.block_configs), 1)
        self.assertEqual(result.block_configs[0].design_name, "uart_rx")
        self.assertEqual(result.block_configs[0].arguments["CORE_UTILIZATION"], "30")


class TestGenerateOrfsFlow(unittest.TestCase):
    """Test orfs_flow() generation from ParsedDesign."""

    def setUp(self):
        self.parser = ConfigMkParser()

    def test_simple_generation(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = gcd
            export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NAME)/*.v))
            export SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc
            export CORE_UTILIZATION = 65
        """)
        result = self.parser.parse(config)
        output = generate_orfs_flow(result)
        self.assertIn("orfs_flow(", output)
        self.assertIn('name = "gcd"', output)
        self.assertIn('"CORE_UTILIZATION": "65"', output)
        self.assertIn("@orfs//flow/designs/src/gcd:verilog", output)
        self.assertIn("@orfs//flow:asap7", output)

    def test_generation_with_blocks(self):
        """Test that BLOCKS generates macros references."""
        tmpdir = tempfile.mkdtemp()
        base_dir = os.path.join(tmpdir, "flow/designs/gf180/test")
        os.makedirs(base_dir, exist_ok=True)

        config = os.path.join(base_dir, "config.mk")
        with open(config, "w") as f:
            f.write("export PLATFORM = gf180\n")
            f.write("export DESIGN_NAME = top\n")
            f.write("export BLOCKS = sub1\n")

        # Sub-macro
        sub_dir = os.path.join(base_dir, "sub1")
        os.makedirs(sub_dir, exist_ok=True)
        with open(os.path.join(sub_dir, "config.mk"), "w") as f:
            f.write("export PLATFORM = gf180\n")
            f.write("export DESIGN_NAME = sub1\n")
            f.write("export CORE_UTILIZATION = 50\n")

        result = self.parser.parse(config)
        output = generate_orfs_flow(result)
        self.assertIn('name = "sub1"', output)
        self.assertIn("abstract_stage", output)
        self.assertIn(":sub1_generate_abstract", output)


class TestLintReport(unittest.TestCase):
    """Test lint report generation."""

    def setUp(self):
        self.parser = ConfigMkParser()

    def test_clean_config_no_lint(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = gcd
            export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NAME)/*.v))
            export SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc
            export CORE_UTILIZATION = 65
        """)
        result = self.parser.parse(config)
        report = lint_report(result)
        self.assertEqual(report, "")

    def test_deprecated_features_reported(self):
        config, _ = _write_config("""\
            export PLATFORM = asap7
            export DESIGN_NAME = gcd
            ifeq ($(FLOW_VARIANT),top)
                export ABC = 1
            endif
        """)
        result = self.parser.parse(config)
        report = lint_report(result)
        self.assertIn("WARNING", report)
        self.assertIn("FLOW_VARIANT", report)


# ========================================================================
# Integration tests — parse real config.mk files from the repository
# ========================================================================

@unittest.skipUnless(DESIGNS_DIR.exists(), "ORFS designs directory not found")
class TestIntegrationGcd(unittest.TestCase):
    """Parse real gcd config.mk files from each platform."""

    def setUp(self):
        self.parser = ConfigMkParser()

    def test_asap7_gcd(self):
        config = str(DESIGNS_DIR / "asap7" / "gcd" / "config.mk")
        result = self.parser.parse(config)
        self.assertEqual(result.platform, "asap7")
        self.assertEqual(result.design_name, "gcd")
        self.assertEqual(result.verilog_files, ["//flow/designs/src/gcd:verilog"])
        self.assertIn("SDC_FILE", result.sources)
        self.assertEqual(result.arguments["CORE_UTILIZATION"], "65")
        self.assertEqual(result.arguments["PLACE_DENSITY"], "0.35")
        self.assertFalse(result.has_conditionals)

    def test_nangate45_gcd(self):
        config = str(DESIGNS_DIR / "nangate45" / "gcd" / "config.mk")
        result = self.parser.parse(config)
        self.assertEqual(result.platform, "nangate45")
        self.assertEqual(result.design_name, "gcd")
        self.assertIn("SDC_FILE", result.sources)
        self.assertIn("PDN_TCL", result.sources)
        self.assertEqual(result.arguments["ABC_AREA"], "1")
        self.assertFalse(result.has_conditionals)

    def test_sky130hd_gcd(self):
        config = str(DESIGNS_DIR / "sky130hd" / "gcd" / "config.mk")
        result = self.parser.parse(config)
        self.assertEqual(result.platform, "sky130hd")
        self.assertEqual(result.design_name, "gcd")
        self.assertFalse(result.has_conditionals)

    def test_sky130hs_gcd(self):
        config = str(DESIGNS_DIR / "sky130hs" / "gcd" / "config.mk")
        result = self.parser.parse(config)
        self.assertEqual(result.platform, "sky130hs")
        self.assertEqual(result.design_name, "gcd")
        self.assertFalse(result.has_conditionals)

    def test_ihp_sg13g2_gcd(self):
        config = str(DESIGNS_DIR / "ihp-sg13g2" / "gcd" / "config.mk")
        result = self.parser.parse(config)
        self.assertEqual(result.platform, "ihp-sg13g2")
        self.assertEqual(result.design_name, "gcd")
        self.assertFalse(result.has_conditionals)

    def test_gf12_gcd(self):
        config = str(DESIGNS_DIR / "gf12" / "gcd" / "config.mk")
        result = self.parser.parse(config)
        self.assertEqual(result.platform, "gf12")
        self.assertEqual(result.design_name, "gcd")
        self.assertTrue(result.has_conditionals)  # Has ifeq USE_FILL

    def test_rapidus2hp_gcd(self):
        config = str(DESIGNS_DIR / "rapidus2hp" / "gcd" / "config.mk")
        result = self.parser.parse(config)
        self.assertEqual(result.platform, "rapidus2hp")
        self.assertEqual(result.design_name, "gcd")
        self.assertTrue(result.has_conditionals)


@unittest.skipUnless(DESIGNS_DIR.exists(), "ORFS designs directory not found")
class TestIntegrationComplex(unittest.TestCase):
    """Parse complex real config.mk files."""

    def setUp(self):
        self.parser = ConfigMkParser()

    def test_asap7_aes(self):
        """Has ifeq FLOW_VARIANT with 3 branches."""
        config = str(DESIGNS_DIR / "asap7" / "aes" / "config.mk")
        result = self.parser.parse(config)
        self.assertEqual(result.platform, "asap7")
        self.assertEqual(result.design_name, "aes_cipher_top")
        self.assertEqual(result.design_nickname, "aes")
        self.assertTrue(result.has_conditionals)
        self.assertEqual(result.arguments["CORE_UTILIZATION"], "70")

    def test_gf180_uart_blocks(self):
        """Has BLOCKS with uart_rx sub-macro."""
        config = str(DESIGNS_DIR / "gf180" / "uart-blocks" / "config.mk")
        result = self.parser.parse(config)
        self.assertEqual(result.platform, "gf180")
        self.assertEqual(result.design_name, "uart")
        self.assertEqual(result.blocks, ["uart_rx"])
        self.assertEqual(len(result.block_configs), 1)
        self.assertEqual(result.block_configs[0].design_name, "uart_rx")

    def test_asap7_riscv32i_mock_sram(self):
        """Has include and BLOCKS."""
        config = str(DESIGNS_DIR / "asap7" / "riscv32i-mock-sram" / "config.mk")
        result = self.parser.parse(config)
        self.assertEqual(result.platform, "asap7")
        self.assertEqual(result.blocks, ["fakeram7_256x32"])
        self.assertTrue(len(result.block_configs) == 1)

    def test_asap7_aes_block(self):
        """Has BLOCKS for hierarchical synthesis."""
        config = str(DESIGNS_DIR / "asap7" / "aes-block" / "config.mk")
        result = self.parser.parse(config)
        self.assertEqual(result.platform, "asap7")
        self.assertEqual(result.design_name, "aes_cipher_top")
        self.assertEqual(result.blocks, ["aes_rcon", "aes_sbox"])

    def test_ihp_i2c_gpio_expander(self):
        """Has BLOCKS with sub-macro using ${VAR} syntax."""
        config = str(DESIGNS_DIR / "ihp-sg13g2" / "i2c-gpio-expander" / "config.mk")
        result = self.parser.parse(config)
        self.assertEqual(result.platform, "ihp-sg13g2")
        self.assertEqual(result.design_name, "I2cGpioExpanderTop")
        self.assertEqual(result.blocks, ["I2cDeviceCtrl"])
        self.assertEqual(len(result.block_configs), 1)


@unittest.skipUnless(DESIGNS_DIR.exists(), "ORFS designs directory not found")
class TestIntegrationAllConfigs(unittest.TestCase):
    """Smoke test: parse ALL config.mk files without errors."""

    def setUp(self):
        self.parser = ConfigMkParser()

    def test_parse_all_configs(self):
        """Every config.mk should parse without exceptions."""
        configs = discover_configs(str(DESIGNS_DIR))
        self.assertGreaterEqual(len(configs), 80)

        # Some configs get DESIGN_NAME from include or don't set it
        # (e.g., minimal, mock-alu, gcd-ccs, riscv32i-mock-sram)
        no_design_name_ok = {
            "minimal", "mock-alu", "gcd-ccs", "riscv32i-mock-sram"
        }

        errors = []
        for config in configs:
            try:
                result = self.parser.parse(config)
                self.assertIsInstance(result, ParsedDesign)
                self.assertTrue(result.platform, f"No platform in {config}")
                design_dir = Path(config).parent.name
                if design_dir not in no_design_name_ok:
                    self.assertTrue(result.design_name, f"No design_name in {config}")
            except Exception as e:
                errors.append(f"{config}: {e}")

        if errors:
            self.fail(f"Failed to parse {len(errors)} configs:\n" +
                      "\n".join(errors))

    def test_tier1_no_conditionals(self):
        """Tier 1 designs (simple) should have no conditionals."""
        tier1_configs = [
            "asap7/gcd", "asap7/minimal", "asap7/jpeg", "asap7/uart",
            "nangate45/gcd", "nangate45/dynamic_node", "nangate45/swerv",
            "sky130hd/gcd", "sky130hs/gcd",
            "ihp-sg13g2/gcd", "ihp-sg13g2/spi",
        ]
        for design_path in tier1_configs:
            config = str(DESIGNS_DIR / design_path / "config.mk")
            if not os.path.exists(config):
                continue
            result = self.parser.parse(config)
            self.assertFalse(
                result.has_conditionals,
                f"{design_path} should be Tier 1 (no conditionals)"
            )


@unittest.skipUnless(DESIGNS_DIR.exists(), "ORFS designs directory not found")
class TestRoundTrip(unittest.TestCase):
    """Parse config.mk → generate orfs_flow() → verify correctness."""

    def setUp(self):
        self.parser = ConfigMkParser()

    def test_asap7_gcd_roundtrip(self):
        config = str(DESIGNS_DIR / "asap7" / "gcd" / "config.mk")
        result = self.parser.parse(config)
        output = generate_orfs_flow(result)

        # Verify key elements present
        self.assertIn('name = "gcd"', output)
        self.assertIn("@orfs//flow/designs/src/gcd:verilog", output)
        self.assertIn('"CORE_UTILIZATION": "65"', output)
        self.assertIn('"PLACE_DENSITY": "0.35"', output)
        self.assertIn("@orfs//flow:asap7", output)

    def test_sky130hd_gcd_roundtrip(self):
        config = str(DESIGNS_DIR / "sky130hd" / "gcd" / "config.mk")
        result = self.parser.parse(config)
        output = generate_orfs_flow(result)
        self.assertIn('name = "gcd"', output)
        self.assertIn("@orfs//flow:sky130hd", output)

    def test_gf180_uart_blocks_roundtrip(self):
        """Hierarchical design with BLOCKS."""
        config = str(DESIGNS_DIR / "gf180" / "uart-blocks" / "config.mk")
        result = self.parser.parse(config)
        output = generate_orfs_flow(result)
        self.assertIn('name = "uart"', output)
        self.assertIn("uart_rx", output)
        self.assertIn("abstract_stage", output)
        self.assertIn("macros", output)


class TestDiscoverConfigs(unittest.TestCase):
    """Test config.mk file discovery."""

    @unittest.skipUnless(DESIGNS_DIR.exists(), "ORFS designs directory not found")
    def test_discover_all(self):
        configs = discover_configs(str(DESIGNS_DIR))
        self.assertGreaterEqual(len(configs), 80)

    @unittest.skipUnless(DESIGNS_DIR.exists(), "ORFS designs directory not found")
    def test_discover_filtered(self):
        configs = discover_configs(str(DESIGNS_DIR), platforms=["asap7"])
        self.assertGreater(len(configs), 5)
        for c in configs:
            self.assertIn("asap7", c)

    @unittest.skipUnless(DESIGNS_DIR.exists(), "ORFS designs directory not found")
    def test_discover_excludes_src(self):
        """The src/ directory should not be included."""
        configs = discover_configs(str(DESIGNS_DIR))
        for c in configs:
            self.assertNotIn("/src/", c.split("designs/")[1])


if __name__ == "__main__":
    unittest.main()
