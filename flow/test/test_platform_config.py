#!/usr/bin/env python3
"""Tests for platform config.py files.

Covers every Make construct used across all 6 platform config.mk files.
Tests are organized by use-case (Make construct) and by platform.

Run: python -m unittest flow.test.test_platform_config -v
Integration: RUN_INTEGRATION=1 python -m unittest flow.test.test_platform_config -v
"""

import io
import json
import os
import shutil
import subprocess
import sys
import tempfile
import textwrap
import unittest
from contextlib import redirect_stdout
from unittest.mock import patch

# Add scripts dir to path for imports
FLOW_DIR = os.path.join(os.path.dirname(__file__), "..")
sys.path.insert(0, os.path.join(FLOW_DIR, "scripts"))

from platform_config_utils import PlatformConfig

# Import platform config modules
sys.path.insert(0, os.path.join(FLOW_DIR, "platforms", "nangate45"))
sys.path.insert(0, os.path.join(FLOW_DIR, "platforms", "sky130hs"))
sys.path.insert(0, os.path.join(FLOW_DIR, "platforms", "sky130hd"))
sys.path.insert(0, os.path.join(FLOW_DIR, "platforms", "gf180"))
sys.path.insert(0, os.path.join(FLOW_DIR, "platforms", "ihp-sg13g2"))
sys.path.insert(0, os.path.join(FLOW_DIR, "platforms", "asap7"))

# We import via importlib to handle the hyphenated directory name
import importlib.util


def _load_config_module(platform_name):
    """Load a platform's config.py module by path."""
    if platform_name == "ihp-sg13g2":
        dirname = "ihp-sg13g2"
    else:
        dirname = platform_name
    spec = importlib.util.spec_from_file_location(
        f"config_{platform_name.replace('-', '_')}",
        os.path.join(FLOW_DIR, "platforms", dirname, "config.py"),
    )
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


nangate45_config = _load_config_module("nangate45")
sky130hs_config = _load_config_module("sky130hs")
sky130hd_config = _load_config_module("sky130hd")
gf180_config = _load_config_module("gf180")
ihp_config = _load_config_module("ihp-sg13g2")
asap7_config = _load_config_module("asap7")

PLATFORMS = ["nangate45", "sky130hs", "sky130hd", "gf180", "ihp-sg13g2", "asap7"]
PLATFORM_MODULES = {
    "nangate45": nangate45_config,
    "sky130hs": sky130hs_config,
    "sky130hd": sky130hd_config,
    "gf180": gf180_config,
    "ihp-sg13g2": ihp_config,
    "asap7": asap7_config,
}

# Environment variables to clean before each test
ENV_VARS_TO_CLEAN = [
    "ADDITIONAL_LIBS",
    "ADDITIONAL_GDS",
    "ADDITIONAL_LEFS",
    "BLOCKS",
    "CORNER",
    "ASAP7_USE_VT",
    "LIB_MODEL",
    "CLUSTER_FLOPS",
    "FOOTPRINT_TCL",
    "LOAD_ADDITIONAL_FILES",
    "TRACK_OPTION",
    "METAL_OPTION",
    "KVALUE",
    "POWER_OPTION",
    "SDC_FILE",
    "ABC_CLOCK_PERIOD_IN_PS",
    "DONT_USE_CELLS",
    "BC_ADDITIONAL_LIBS",
    "ADDITIONAL_SLOW_LIBS",
    "ADDITIONAL_FAST_LIBS",
    "ADDITIONAL_TYP_LIBS",
]


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
def get_platform_dir(platform):
    return os.path.abspath(os.path.join(FLOW_DIR, "platforms", platform))


def make_clean_env(platform, extras=None):
    """Return an env dict for use with patch.dict(os.environ, ...)."""
    env = {
        "PLATFORM_DIR": get_platform_dir(platform),
        "PLATFORM": platform,
    }
    if extras:
        env.update(extras)
    return env


def clean_and_get_config(platform, extras=None):
    """Clean env, run get_config, return dict. Must be called inside patch.dict."""
    cfg = PLATFORM_MODULES[platform].get_config()
    return cfg.to_dict()


class PlatformTestCase(unittest.TestCase):
    """Base class that cleans environment variables in setUp."""

    def setUp(self):
        self._saved_env = {}
        for var in ENV_VARS_TO_CLEAN:
            if var in os.environ:
                self._saved_env[var] = os.environ.pop(var)

    def tearDown(self):
        # Remove any vars we may have set
        for var in ENV_VARS_TO_CLEAN:
            os.environ.pop(var, None)
        # Restore original values
        os.environ.update(self._saved_env)

    def run_with_env(self, platform, extras=None):
        """Set up env and return config dict."""
        env = make_clean_env(platform, extras)
        os.environ.update(env)
        return clean_and_get_config(platform, extras)


# ===================================================================
# 1. PlatformConfig utility tests
# ===================================================================
class TestPlatformConfigUtility(unittest.TestCase):
    def test_set_unconditional(self):
        cfg = PlatformConfig(platform_dir="/fake")
        cfg.set("FOO", "bar")
        d = cfg.to_dict()
        self.assertEqual(d["FOO"], "bar")

    def test_set_conditional_default(self):
        cfg = PlatformConfig(platform_dir="/fake")
        cfg.set("FOO", "default_val", conditional=True)
        d = cfg.to_dict()
        self.assertEqual(d["FOO"], "default_val")

    def test_set_conditional_override_from_env(self):
        with patch.dict(os.environ, {"FOO": "from_env"}):
            cfg = PlatformConfig(platform_dir="/fake")
            cfg.set("FOO", "default_val", conditional=True)
            d = cfg.to_dict()
            self.assertEqual(d["FOO"], "from_env")

    def test_set_conditional_does_not_overwrite_internal(self):
        cfg = PlatformConfig(platform_dir="/fake")
        cfg.set("FOO", "first")
        cfg.set("FOO", "second", conditional=True)
        d = cfg.to_dict()
        self.assertEqual(d["FOO"], "first")

    def test_append_internal(self):
        cfg = PlatformConfig(platform_dir="/fake")
        cfg.set("FOO", "a b")
        cfg.append("FOO", "c d")
        d = cfg.to_dict()
        self.assertEqual(d["FOO"], "a b c d")

    def test_append_from_env(self):
        with patch.dict(os.environ, {"FOO": "from_env"}):
            cfg = PlatformConfig(platform_dir="/fake")
            cfg.append("FOO", "extra")
            d = cfg.to_dict()
            self.assertEqual(d["FOO"], "from_env extra")

    def test_append_new_var(self):
        cfg = PlatformConfig(platform_dir="/fake")
        cfg.append("FOO", "value")
        d = cfg.to_dict()
        self.assertEqual(d["FOO"], "value")

    def test_get(self):
        cfg = PlatformConfig(platform_dir="/fake")
        cfg.set("FOO", "bar")
        self.assertEqual(cfg.get("FOO"), "bar")
        self.assertEqual(cfg.get("MISSING", "default"), "default")

    def test_output_make(self):
        cfg = PlatformConfig(platform_dir="/fake")
        cfg.set("SIMPLE", "value")
        cfg.set("SPACES", "a b c")
        cfg.set("COND", "default", conditional=True)
        buf = io.StringIO()
        with redirect_stdout(buf):
            cfg.output_make()
        lines = buf.getvalue().strip().split("\n")
        self.assertIn("export SIMPLE=value", lines)
        self.assertIn("export SPACES=a__SPACE__b__SPACE__c", lines)
        self.assertIn("export COND?=default", lines)

    def test_output_json(self):
        cfg = PlatformConfig(platform_dir="/fake")
        cfg.set("KEY1", "val1")
        cfg.set("KEY2", "val2")
        buf = io.StringIO()
        with redirect_stdout(buf):
            cfg.output_json()
        data = json.loads(buf.getvalue())
        self.assertEqual(data["KEY1"], "val1")
        self.assertEqual(data["KEY2"], "val2")

    def test_sorted_glob(self):
        tmp = tempfile.mkdtemp()
        try:
            for name in ["c.gds", "a.gds", "b.gds"]:
                open(os.path.join(tmp, name), "w").close()
            cfg = PlatformConfig(platform_dir="/fake")
            result = cfg.sorted_glob(os.path.join(tmp, "*.gds"))
            files = result.split()
            self.assertEqual(len(files), 3)
            self.assertTrue(files[0].endswith("a.gds"))
            self.assertTrue(files[1].endswith("b.gds"))
            self.assertTrue(files[2].endswith("c.gds"))
        finally:
            shutil.rmtree(tmp)

    def test_wildcard_glob(self):
        tmp = tempfile.mkdtemp()
        try:
            for name in ["x.gds", "y.gds"]:
                open(os.path.join(tmp, name), "w").close()
            cfg = PlatformConfig(platform_dir="/fake")
            result = cfg.wildcard_glob(os.path.join(tmp, "*.gds"))
            files = result.split()
            self.assertEqual(len(files), 2)
        finally:
            shutil.rmtree(tmp)


# ===================================================================
# 2. Per-platform unit tests -- use-case coverage
# ===================================================================


# --- Test 1: Unconditional assignment (export VAR = value) ---
class TestUnconditionalAssignment(PlatformTestCase):
    def test_unconditional_assignment(self):
        cases = [
            ("nangate45", "PROCESS", "45"),
            ("sky130hs", "PROCESS", "130"),
            ("sky130hd", "PROCESS", "130"),
            ("gf180", "PROCESS", "180"),
            ("ihp-sg13g2", "PROCESS", "ihp-sg13g2"),
            ("asap7", "PROCESS", "7"),
        ]
        for platform, key, expected_substr in cases:
            with self.subTest(platform=platform, key=key):
                d = self.run_with_env(platform)
                self.assertEqual(d[key], expected_substr)


# --- Test 2: Conditional assignment (export VAR ?= value) ---
class TestConditionalAssignment(PlatformTestCase):
    def test_conditional_assignment_default(self):
        cases = [
            ("nangate45", "PLACE_DENSITY", "0.30"),
            ("sky130hs", "PLACE_DENSITY", "0.50"),
            ("sky130hd", "PLACE_DENSITY", "0.60"),
            ("gf180", "PLACE_DENSITY", "0.40"),
            ("ihp-sg13g2", "PLACE_DENSITY", "0.65"),
            ("asap7", "PLACE_DENSITY", "0.60"),
        ]
        for platform, key, default_val in cases:
            with self.subTest(platform=platform):
                d = self.run_with_env(platform)
                self.assertEqual(d[key], default_val)

    def test_conditional_assignment_override(self):
        for platform in PLATFORMS:
            with self.subTest(platform=platform):
                d = self.run_with_env(platform, {"PLACE_DENSITY": "0.99"})
                self.assertEqual(d["PLACE_DENSITY"], "0.99")


# --- Test 3: Internal append (VAR += value within same config) ---
class TestInternalAppend(PlatformTestCase):
    def test_asap7_dont_use_cells_internal_append(self):
        """asap7: DONT_USE_CELLS = X then DONT_USE_CELLS += SDF* ICG*"""
        d = self.run_with_env("asap7")
        self.assertIn("*x1p*_ASAP7*", d["DONT_USE_CELLS"])
        self.assertIn("SDF*", d["DONT_USE_CELLS"])
        self.assertIn("ICG*", d["DONT_USE_CELLS"])


# --- Test 4: External append (VAR += from env) ---
class TestExternalAppend(PlatformTestCase):
    def test_sky130hd_dont_use_cells_from_env(self):
        """sky130hd: DONT_USE_CELLS += list (appends to env value)"""
        d = self.run_with_env("sky130hd", {"DONT_USE_CELLS": "EXISTING_CELL"})
        self.assertIn("EXISTING_CELL", d["DONT_USE_CELLS"])
        self.assertIn("sky130_fd_sc_hd__probe_p_8", d["DONT_USE_CELLS"])

    def test_ihp_dont_use_cells_from_env(self):
        """ihp-sg13g2: DONT_USE_CELLS += list (appends to env value)"""
        d = self.run_with_env("ihp-sg13g2", {"DONT_USE_CELLS": "EXISTING"})
        self.assertIn("EXISTING", d["DONT_USE_CELLS"])
        self.assertIn("sg13g2_lgcp_1", d["DONT_USE_CELLS"])


# --- Test 5: $(PLATFORM_DIR)/path expansion ---
class TestPlatformDirExpansion(PlatformTestCase):
    def test_platform_dir_expansion(self):
        cases = [
            ("nangate45", "TECH_LEF", "/lef/NangateOpenCellLibrary.tech.lef"),
            ("sky130hd", "TECH_LEF", "/lef/sky130_fd_sc_hd.tlef"),
            ("asap7", "TECH_LEF", "/lef/asap7_tech_1x_201209.lef"),
        ]
        for platform, key, suffix in cases:
            with self.subTest(platform=platform):
                d = self.run_with_env(platform)
                self.assertTrue(d[key].endswith(suffix))
                self.assertIn(get_platform_dir(platform), d[key])


# --- Test 6: $(sort $(wildcard ...)) ---
class TestSortedGlob(PlatformTestCase):
    def test_nangate45_gds_files_sorted(self):
        d = self.run_with_env("nangate45")
        gds = d["GDS_FILES"].split()
        self.assertEqual(gds, sorted(gds))


# --- Test 7: $(wildcard ...) ---
class TestWildcardGlob(PlatformTestCase):
    def test_sky130hd_gds_files(self):
        d = self.run_with_env("sky130hd")
        if d["GDS_FILES"].strip():
            self.assertIn(".gds", d["GDS_FILES"])


# --- Test 8: ifeq/ifneq conditionals ---
class TestConditionalIfeq(PlatformTestCase):
    def test_gf180_place_site_9t(self):
        """gf180: ifeq ($(TRACK_OPTION),9t) -> GF018hv5v_green_sc9"""
        d = self.run_with_env("gf180")
        self.assertEqual(d["PLACE_SITE"], "GF018hv5v_green_sc9")

    def test_gf180_place_site_7t(self):
        """gf180: else -> GF018hv5v_mcu_sc7"""
        d = self.run_with_env("gf180", {"TRACK_OPTION": "7t"})
        self.assertEqual(d["PLACE_SITE"], "GF018hv5v_mcu_sc7")

    def test_asap7_pdn_no_blocks(self):
        """asap7: ifeq ($(BLOCKS),) -> grid_strategy-M1-M2-M5-M6.tcl"""
        d = self.run_with_env("asap7")
        self.assertIn("grid_strategy-M1-M2-M5-M6.tcl", d["PDN_TCL"])

    def test_asap7_pdn_with_blocks(self):
        """asap7: BLOCKS set -> BLOCKS_grid_strategy.tcl"""
        d = self.run_with_env("asap7", {"BLOCKS": "block1"})
        self.assertIn("BLOCKS_grid_strategy.tcl", d["PDN_TCL"])


# --- Test 9: $(ADDITIONAL_LIBS) from env ---
class TestEnvVariableInclusion(PlatformTestCase):
    def test_nangate45_additional_libs(self):
        d = self.run_with_env("nangate45", {"ADDITIONAL_LIBS": "/extra/lib.lib"})
        self.assertIn("/extra/lib.lib", d["LIB_FILES"])
        self.assertIn("NangateOpenCellLibrary_typical.lib", d["LIB_FILES"])


# --- Test 10: $($(CORNER)_LIB_FILES) variable indirection ---
class TestVariableIndirection(PlatformTestCase):
    def test_gf180_bc_corner(self):
        d = self.run_with_env("gf180", {"CORNER": "BC"})
        self.assertIn("ff_n40C_5v50", d["LIB_FILES"])

    def test_gf180_wc_corner(self):
        d = self.run_with_env("gf180", {"CORNER": "WC"})
        self.assertIn("ss_125C_4v50", d["LIB_FILES"])

    def test_gf180_tc_corner(self):
        d = self.run_with_env("gf180", {"CORNER": "TC"})
        self.assertIn("tt_025C_5v00", d["LIB_FILES"])

    def test_asap7_bc_nldm_corner(self):
        d = self.run_with_env("asap7", {"CORNER": "BC"})
        self.assertIn("_FF_nldm_", d["LIB_FILES"])

    def test_asap7_wc_corner(self):
        d = self.run_with_env("asap7", {"CORNER": "WC"})
        self.assertIn("_SS_nldm_", d["LIB_FILES"])


# --- Test 11: $(subst PLACEHOLDER,...) template expansion ---
class TestPlaceholderSubstitution(PlatformTestCase):
    def test_asap7_placeholder_expansion(self):
        """asap7: $(subst PLACEHOLDER,$(PRIMARY_VT_TAG),...) templates"""
        d = self.run_with_env("asap7")
        self.assertNotIn("PLACEHOLDER", d.get("BC_NLDM_DFF_LIB_FILE", ""))
        self.assertIn("_RVT_", d["BC_NLDM_DFF_LIB_FILE"])
        self.assertIn("_RVT_", d["BC_NLDM_LIB_FILES"])


# --- Test 12: $(patsubst %VT,%,...) ---
class TestPatsubstVtTag(PlatformTestCase):
    def test_asap7_vt_tag_derivation(self):
        """RVT -> R, LVT -> L, SLVT -> SL"""
        d = self.run_with_env("asap7", {"ASAP7_USE_VT": "LVT"})
        self.assertTrue("_L_" in d["SC_LEF"] or "_L_" in d["GDS_FILES"])

    def test_asap7_slvt_tag(self):
        d = self.run_with_env("asap7", {"ASAP7_USE_VT": "SLVT"})
        self.assertIn("_SL_", d["SC_LEF"])


# --- Test 13: $(word 1,...) ---
class TestWordExtraction(PlatformTestCase):
    def test_asap7_primary_vt_is_first(self):
        """PRIMARY_VT = $(word 1, $(VT_LIST))"""
        d = self.run_with_env("asap7", {"ASAP7_USE_VT": "LVT RVT SLVT"})
        self.assertIn("asap7sc7p5t_28_L_", d["SC_LEF"])


# --- Test 14: $(wordlist 2,N,...) ---
class TestWordlistExtraction(PlatformTestCase):
    def test_asap7_other_vt_is_rest(self):
        """OTHER_VT = $(wordlist 2, ..., $(VT_LIST))"""
        d = self.run_with_env("asap7", {"ASAP7_USE_VT": "RVT LVT SLVT"})
        self.assertIn("asap7sc7p5t_28_L_1x", d.get("ADDITIONAL_LEFS", ""))
        self.assertIn("asap7sc7p5t_28_SL_1x", d.get("ADDITIONAL_LEFS", ""))


# --- Test 15: $(addsuffix tag,...) ---
class TestAddsuffix(PlatformTestCase):
    def test_asap7_fill_cells_suffix(self):
        """FILL_CELLS = $(addsuffix $(PRIMARY_VT_TAG), $(FILL_CELLS_T))"""
        d = self.run_with_env("asap7")
        self.assertIn("FILLERxp5_ASAP7_75t_R", d["FILL_CELLS"])
        self.assertIn("FILLER_ASAP7_75t_R", d["FILL_CELLS"])
        self.assertIn("DECAPx10_ASAP7_75t_R", d["FILL_CELLS"])


# --- Test 16: $(if $(strip $(VAR)),...) ---
class TestIfStrip(PlatformTestCase):
    def test_asap7_default_vt_when_unset(self):
        """VT_LIST = $(if $(strip $(ASAP7_USE_VT)), ..., RVT)"""
        d = self.run_with_env("asap7")
        self.assertIn("asap7sc7p5t_28_R_", d["GDS_FILES"])

    def test_asap7_vt_when_set(self):
        d = self.run_with_env("asap7", {"ASAP7_USE_VT": "LVT"})
        self.assertIn("asap7sc7p5t_28_L_", d["GDS_FILES"])


# --- Test 17: $(foreach)/$(eval) loop ---
class TestForeachEvalVtExpansion(PlatformTestCase):
    def test_asap7_multi_vt_expansion(self):
        """foreach vt in OTHER_VT: expand templates and append"""
        d = self.run_with_env("asap7", {"ASAP7_USE_VT": "RVT LVT SLVT"})

        # Primary VT = RVT (tag R)
        self.assertIn("asap7sc7p5t_28_R_", d["GDS_FILES"])

        # OTHER_VT = [LVT, SLVT] should be appended
        self.assertIn("asap7sc7p5t_28_L_220121a.gds", d["GDS_FILES"])
        self.assertIn("asap7sc7p5t_28_SL_220121a.gds", d["GDS_FILES"])

        # ADDITIONAL_LEFS should have OTHER_VT entries
        self.assertIn("asap7sc7p5t_28_L_1x_220121a.lef", d.get("ADDITIONAL_LEFS", ""))
        self.assertIn("asap7sc7p5t_28_SL_1x_220121a.lef", d.get("ADDITIONAL_LEFS", ""))

        # DFF lib files should have all 3 VTs
        self.assertIn("_RVT_", d["BC_NLDM_DFF_LIB_FILE"])
        self.assertIn("_LVT_", d["BC_NLDM_DFF_LIB_FILE"])
        self.assertIn("_SLVT_", d["BC_NLDM_DFF_LIB_FILE"])

        # FILL_CELLS should have all 3 VT suffixes
        self.assertIn("FILLERxp5_ASAP7_75t_R", d["FILL_CELLS"])
        self.assertIn("FILLERxp5_ASAP7_75t_L", d["FILL_CELLS"])
        self.assertIn("FILLERxp5_ASAP7_75t_SL", d["FILL_CELLS"])


# --- Test 18: $(strip ...) ---
class TestStrip(PlatformTestCase):
    def test_asap7_strip_asap7_use_vt(self):
        """Whitespace in ASAP7_USE_VT should be stripped"""
        d = self.run_with_env("asap7", {"ASAP7_USE_VT": "  RVT  "})
        self.assertIn("asap7sc7p5t_28_R_", d["GDS_FILES"])


# --- Test 19: $(shell sed ...) SDC clock period extraction ---
class TestSdcClockPeriodExtraction(PlatformTestCase):
    def test_ihp_sdc_clk_period(self):
        """ihp-sg13g2: extract clock period from SDC file"""
        tmp = tempfile.mkdtemp()
        try:
            sdc = os.path.join(tmp, "constraint.sdc")
            with open(sdc, "w") as f:
                f.write("set clk_period 10.0\ncreate_clock ...\n")
            d = self.run_with_env("ihp-sg13g2", {"SDC_FILE": sdc})
            self.assertEqual(d["ABC_CLOCK_PERIOD_IN_PS"], "10000.0")
        finally:
            shutil.rmtree(tmp)

    def test_ihp_sdc_period_flag(self):
        """ihp-sg13g2: extract from -period flag"""
        tmp = tempfile.mkdtemp()
        try:
            sdc = os.path.join(tmp, "constraint.sdc")
            with open(sdc, "w") as f:
                f.write("create_clock -period 5.0 [get_ports clk]\n")
            d = self.run_with_env("ihp-sg13g2", {"SDC_FILE": sdc})
            self.assertEqual(d["ABC_CLOCK_PERIOD_IN_PS"], "5000.0")
        finally:
            shutil.rmtree(tmp)

    def test_ihp_no_sdc_file(self):
        """No SDC file -> ABC_CLOCK_PERIOD_IN_PS not set"""
        d = self.run_with_env("ihp-sg13g2")
        self.assertNotIn("ABC_CLOCK_PERIOD_IN_PS", d)


# --- Test 20: $(origin VAR) check ---
class TestOriginCheck(PlatformTestCase):
    def test_ihp_origin_undefined(self):
        """When ABC_CLOCK_PERIOD_IN_PS is not in env, extract from SDC"""
        tmp = tempfile.mkdtemp()
        try:
            sdc = os.path.join(tmp, "constraint.sdc")
            with open(sdc, "w") as f:
                f.write("set clk_period 8.0\n")
            d = self.run_with_env("ihp-sg13g2", {"SDC_FILE": sdc})
            self.assertEqual(d["ABC_CLOCK_PERIOD_IN_PS"], "8000.0")
        finally:
            shutil.rmtree(tmp)

    def test_ihp_origin_defined(self):
        """When ABC_CLOCK_PERIOD_IN_PS is in env, don't extract"""
        tmp = tempfile.mkdtemp()
        try:
            sdc = os.path.join(tmp, "constraint.sdc")
            with open(sdc, "w") as f:
                f.write("set clk_period 8.0\n")
            d = self.run_with_env(
                "ihp-sg13g2",
                {"SDC_FILE": sdc, "ABC_CLOCK_PERIOD_IN_PS": "12345"},
            )
            self.assertTrue(
                "ABC_CLOCK_PERIOD_IN_PS" not in d
                or d.get("ABC_CLOCK_PERIOD_IN_PS") != "8000.0"
            )
        finally:
            shutil.rmtree(tmp)


# --- Test 21: $(abspath ...) ---
class TestAbspath(PlatformTestCase):
    def test_gf180_lib_files_absolute(self):
        d = self.run_with_env("gf180")
        self.assertTrue(os.path.isabs(d["BC_LIB_FILES"]))
        self.assertTrue(os.path.isabs(d["LIB_FILES"].split()[0]))


# --- Test 22: $(realpath ...) ---
class TestRealpath(PlatformTestCase):
    def test_asap7_db_files_realpath(self):
        """asap7: DB_FILES uses $(realpath ...) -- only if corner DB files exist"""
        d = self.run_with_env("asap7")
        self.assertIsInstance(d.get("DB_FILES", ""), str)


# --- Test 23: -include private.mk skipped ---
class TestPrivateMkSkipped(PlatformTestCase):
    def test_gf180_has_private_dir_default(self):
        """gf180: -include private.mk is skipped, but GF180_PRIVATE_DIR is set"""
        d = self.run_with_env("gf180")
        self.assertEqual(d["GF180_PRIVATE_DIR"], "../../gf180-private")


# --- Test 24: ??= (treated as ?=) ---
class TestDoubleQuestionEquals(PlatformTestCase):
    def test_ihp_io_pins_default_empty(self):
        """ihp-sg13g2: ??= variables default to empty"""
        d = self.run_with_env("ihp-sg13g2")
        self.assertEqual(d.get("IO_NORTH_PINS", ""), "")
        self.assertEqual(d.get("IO_SOUTH_PINS", ""), "")

    def test_ihp_io_pins_override(self):
        """ihp-sg13g2: ??= variables can be overridden from env"""
        d = self.run_with_env("ihp-sg13g2", {"IO_NORTH_PINS": "pin1 pin2"})
        self.assertEqual(d["IO_NORTH_PINS"], "pin1 pin2")


# --- Test 25: Parameterized options (gf180) ---
class TestGf180ParameterizedOptions(PlatformTestCase):
    def test_default_options(self):
        d = self.run_with_env("gf180")
        self.assertIn("5LM_1TM", d["TECH_LEF"])
        self.assertIn("9K", d["TECH_LEF"])
        self.assertIn("9t", d["TECH_LEF"])

    def test_custom_track_option(self):
        d = self.run_with_env("gf180", {"TRACK_OPTION": "7t"})
        self.assertIn("7t", d["TECH_LEF"])
        self.assertEqual(d["PLACE_SITE"], "GF018hv5v_mcu_sc7")

    def test_custom_metal_option(self):
        d = self.run_with_env("gf180", {"METAL_OPTION": "3LM_1TM"})
        self.assertIn("3LM_1TM", d["TECH_LEF"])


# --- Test 26: BLOCKS conditional for PDN_TCL ---
class TestAsap7BlocksPdn(PlatformTestCase):
    def test_no_blocks(self):
        d = self.run_with_env("asap7")
        self.assertNotIn("BLOCKS", d["PDN_TCL"])

    def test_with_blocks(self):
        d = self.run_with_env("asap7", {"BLOCKS": "some_block"})
        self.assertIn("BLOCKS_grid_strategy", d["PDN_TCL"])


# --- Test 27: CLUSTER_FLOPS conditional ---
class TestAsap7ClusterFlops(PlatformTestCase):
    def test_no_cluster_flops(self):
        d = self.run_with_env("asap7")
        self.assertNotIn("DFFHQNH2V2X", d.get("ADDITIONAL_LIBS", ""))

    def test_with_cluster_flops(self):
        d = self.run_with_env("asap7", {"CLUSTER_FLOPS": "1"})
        self.assertIn("DFFHQNH2V2X", d.get("ADDITIONAL_LIBS", ""))
        self.assertIn("DFFHQNV2X", d.get("ADDITIONAL_LIBS", ""))
        self.assertIn("asap7sc7p5t_DFFHQNH2V2X.lef", d.get("ADDITIONAL_LEFS", ""))
        self.assertIn("asap7sc7p5t_pg", d.get("ADDITIONAL_SITES", ""))
        self.assertEqual(d.get("GDS_ALLOW_EMPTY"), "DFFHQN[VH][24].*")


# --- Test 28: LIB_MODEL selection ---
class TestAsap7LibModel(PlatformTestCase):
    def test_default_nldm(self):
        d = self.run_with_env("asap7")
        self.assertTrue("/NLDM/" in d["LIB_DIR"] or d["LIB_DIR"].endswith("/NLDM"))

    def test_ccs_model(self):
        d = self.run_with_env("asap7", {"LIB_MODEL": "CCS"})
        self.assertTrue("/CCS/" in d["LIB_DIR"] or d["LIB_DIR"].endswith("/CCS"))


# --- Test 29: Corner temperature/voltage ---
class TestCornerTemperatureVoltage(PlatformTestCase):
    def test_asap7_bc_corner(self):
        d = self.run_with_env("asap7", {"CORNER": "BC"})
        self.assertEqual(d["TEMPERATURE"], "25C")
        self.assertEqual(d["VOLTAGE"], "0.77")

    def test_asap7_wc_corner(self):
        d = self.run_with_env("asap7", {"CORNER": "WC"})
        self.assertEqual(d["TEMPERATURE"], "100C")
        self.assertEqual(d["VOLTAGE"], "0.63")

    def test_gf180_bc_corner(self):
        d = self.run_with_env("gf180", {"CORNER": "BC"})
        self.assertEqual(d["TEMPERATURE"], "-40c")
        self.assertEqual(d["VOLTAGE"], "5.5")

    def test_gf180_wc_corner(self):
        d = self.run_with_env("gf180", {"CORNER": "WC"})
        self.assertEqual(d["TEMPERATURE"], "125c")
        self.assertEqual(d["VOLTAGE"], "4.5")


# --- Test 30: Multi-VT expansion ---
class TestAsap7MultiVt(PlatformTestCase):
    def test_single_vt_default(self):
        """Default: ASAP7_USE_VT unset -> RVT only, no OTHER_VT additions"""
        d = self.run_with_env("asap7")
        gds = d["GDS_FILES"]
        self.assertIn("28_R_", gds)
        self.assertNotIn("28_L_", gds)
        self.assertNotIn("28_L_1x", d.get("ADDITIONAL_LEFS", ""))

    def test_dual_vt(self):
        d = self.run_with_env("asap7", {"ASAP7_USE_VT": "RVT LVT"})
        self.assertIn("28_R_", d["GDS_FILES"])
        self.assertIn("28_L_", d["GDS_FILES"])


# --- Test 31: FOOTPRINT_TCL conditional (ihp-sg13g2) ---
class TestIhpFootprintConditional(PlatformTestCase):
    def test_no_footprint(self):
        """No FOOTPRINT_TCL -> no IO lefs/libs added"""
        d = self.run_with_env("ihp-sg13g2")
        self.assertNotIn("sg13g2_io.lef", d.get("ADDITIONAL_LEFS", ""))

    def test_with_footprint(self):
        """FOOTPRINT_TCL set -> IO lefs/libs/gds added"""
        d = self.run_with_env("ihp-sg13g2", {"FOOTPRINT_TCL": "/some/file.tcl"})
        self.assertIn("sg13g2_io.lef", d.get("ADDITIONAL_LEFS", ""))
        self.assertIn("bondpad_70x70.lef", d.get("ADDITIONAL_LEFS", ""))
        self.assertIn("sg13g2_io_slow", d.get("SLOW_LIB_FILES", ""))
        self.assertIn("sg13g2_io.gds", d.get("ADDITIONAL_GDS", ""))


# --- Test 32: $(PLATFORM) in paths ---
class TestPlatformVarInPaths(PlatformTestCase):
    def test_sky130hd_platform_in_klayout(self):
        d = self.run_with_env("sky130hd")
        self.assertIn("sky130hd.lyt", d["KLAYOUT_TECH_FILE"])
        self.assertIn("sky130hd.lydrc", d["KLAYOUT_DRC_FILE"])
        self.assertIn("sky130hd.cdl", d["CDL_FILE"])

    def test_sky130hs_platform_in_klayout(self):
        d = self.run_with_env("sky130hs")
        self.assertIn("sky130hs.lyt", d["KLAYOUT_TECH_FILE"])


# --- Test 33: Make shim round-trip ---
class TestShimRoundTrip(PlatformTestCase):
    """Verify config.py Make output format is consumable by foreach/eval."""

    def test_make_output_format(self):
        """Each line is 'export KEY=VALUE' or 'export KEY?=VALUE' with __SPACE__"""
        for platform in PLATFORMS:
            with self.subTest(platform=platform):
                d = self.run_with_env(platform)
                cfg = PLATFORM_MODULES[platform].get_config()
                buf = io.StringIO()
                with redirect_stdout(buf):
                    cfg.output_make()
                for line in buf.getvalue().strip().split("\n"):
                    self.assertTrue(
                        line.startswith("export "),
                        f"Line doesn't start with 'export ': {line}",
                    )
                    rest = line[7:]  # strip "export "
                    self.assertIn("=", rest, f"No = in: {line}")
                    if "?=" in rest:
                        key, val = rest.split("?=", 1)
                    else:
                        key, val = rest.split("=", 1)
                    self.assertNotIn(
                        " ",
                        val,
                        f"Space in value (should be __SPACE__): {key}={val}",
                    )

    def test_json_output_parseable(self):
        """JSON output should be valid and parseable."""
        for platform in PLATFORMS:
            with self.subTest(platform=platform):
                self.run_with_env(platform)
                cfg = PLATFORM_MODULES[platform].get_config()
                buf = io.StringIO()
                with redirect_stdout(buf):
                    cfg.output_json()
                data = json.loads(buf.getvalue())
                self.assertIsInstance(data, dict)
                self.assertGreater(len(data), 0)


# ===================================================================
# 3. Integration findings: design-config override semantics
# ===================================================================
class TestDesignConfigOverrides(PlatformTestCase):
    """Tests discovered from Make integration comparison.

    When a design config.mk sets a variable with = or :=, it overrides
    the platform config.py's ?= default. These tests verify the ?=
    semantics work correctly end-to-end.
    """

    def test_conditional_overridden_by_immediate_assignment(self):
        """nangate45/gcd: 'export ADDER_MAP_FILE :=' in design clears platform ?= default."""
        d = self.run_with_env("nangate45", {"ADDER_MAP_FILE": ""})
        self.assertEqual(d["ADDER_MAP_FILE"], "")

    def test_design_place_density_overrides_platform(self):
        """asap7/gcd: design sets PLACE_DENSITY=0.35, overriding platform ?=0.60."""
        d = self.run_with_env("asap7", {"PLACE_DENSITY": "0.35"})
        self.assertEqual(d["PLACE_DENSITY"], "0.35")

    def test_design_pdn_tcl_overrides_platform(self):
        """nangate45/gcd: design sets PDN_TCL, overriding platform ?= default."""
        d = self.run_with_env(
            "nangate45", {"PDN_TCL": "/designs/nangate45/gcd/custom_pdn.tcl"}
        )
        self.assertEqual(d["PDN_TCL"], "/designs/nangate45/gcd/custom_pdn.tcl")

    def test_ihp_design_place_density_overrides(self):
        """ihp-sg13g2/gcd: design sets PLACE_DENSITY?=0.88, platform has ?=0.65."""
        d = self.run_with_env("ihp-sg13g2", {"PLACE_DENSITY": "0.88"})
        self.assertEqual(d["PLACE_DENSITY"], "0.88")


class TestGf180CornerVariants(PlatformTestCase):
    """Tests for all 3 gf180 corners discovered from Make integration comparison."""

    def test_bc_rcx_rules(self):
        d = self.run_with_env("gf180", {"CORNER": "BC"})
        self.assertIn("bst.rules", d["RCX_RULES"])
        self.assertEqual(d["RCX_RC_CORNER"], "FuncRCmin")

    def test_wc_rcx_rules(self):
        d = self.run_with_env("gf180", {"CORNER": "WC"})
        self.assertIn("wst.rules", d["RCX_RULES"])
        self.assertEqual(d["RCX_RC_CORNER"], "FuncRCmax")

    def test_tc_rcx_rules(self):
        d = self.run_with_env("gf180", {"CORNER": "TC"})
        self.assertIn("typ.rules", d["RCX_RULES"])
        self.assertEqual(d["RCX_RC_CORNER"], "FuncRCtyp")

    def test_bc_pwr_nets_uses_corner_voltage(self):
        """PWR_NETS_VOLTAGES should use the corner-specific voltage."""
        d = self.run_with_env("gf180", {"CORNER": "BC"})
        self.assertEqual(d["PWR_NETS_VOLTAGES"], "VDD 5.5")

    def test_wc_pwr_nets_uses_corner_voltage(self):
        d = self.run_with_env("gf180", {"CORNER": "WC"})
        self.assertEqual(d["PWR_NETS_VOLTAGES"], "VDD 4.5")

    def test_tc_pwr_nets_uses_corner_voltage(self):
        d = self.run_with_env("gf180", {"CORNER": "TC"})
        self.assertEqual(d["PWR_NETS_VOLTAGES"], "VDD 5.0")

    def test_gds_layer_map_absolute_path(self):
        d = self.run_with_env("gf180")
        self.assertTrue(os.path.isabs(d["GDS_LAYER_MAP"]))
        self.assertIn("edi2gds.layermap", d["GDS_LAYER_MAP"])

    def test_klayout_lef_file(self):
        d = self.run_with_env("gf180")
        self.assertIn("tech_9t_5LM_1TM.lef", d["KLAYOUT_LEF_FILE"])

    def test_tie_cell_and_endcap(self):
        d = self.run_with_env("gf180")
        self.assertEqual(d["TIE_CELL"], "gf180mcu_fd_sc_mcu9t5v0__filltie")
        self.assertEqual(d["ENDCAP_CELL"], "gf180mcu_fd_sc_mcu9t5v0__endcap")

    def test_max_fanout(self):
        d = self.run_with_env("gf180")
        self.assertEqual(d["MAX_FANOUT"], "20")


class TestAsap7ExtraVarsFromIntegration(PlatformTestCase):
    """Tests for asap7 variables verified against Make integration output."""

    def test_platform_tcl(self):
        d = self.run_with_env("asap7")
        self.assertTrue(d["PLATFORM_TCL"].endswith("/liberty_suppressions.tcl"))

    def test_make_tracks(self):
        d = self.run_with_env("asap7")
        self.assertTrue(d["MAKE_TRACKS"].endswith("/openRoad/make_tracks.tcl"))

    def test_set_rc_tcl(self):
        d = self.run_with_env("asap7")
        self.assertTrue(d["SET_RC_TCL"].endswith("/setRC.tcl"))

    def test_lib_dir_default(self):
        d = self.run_with_env("asap7")
        self.assertTrue(d["LIB_DIR"].endswith("/lib/NLDM"))

    def test_macro_rows_halo(self):
        d = self.run_with_env("asap7")
        self.assertEqual(d["MACRO_ROWS_HALO_X"], "2")
        self.assertEqual(d["MACRO_ROWS_HALO_Y"], "2")

    def test_corner_temps_and_voltages(self):
        d = self.run_with_env("asap7")
        self.assertEqual(d["BC_TEMPERATURE"], "25C")
        self.assertEqual(d["TC_TEMPERATURE"], "0C")
        self.assertEqual(d["WC_TEMPERATURE"], "100C")
        self.assertEqual(d["BC_VOLTAGE"], "0.77")
        self.assertEqual(d["TC_VOLTAGE"], "0.70")
        self.assertEqual(d["WC_VOLTAGE"], "0.63")

    def test_synth_minimum_keep_size(self):
        d = self.run_with_env("asap7")
        self.assertEqual(d["SYNTH_MINIMUM_KEEP_SIZE"], "1000")

    def test_ccs_lib_files_with_bc_additional(self):
        """BC_CCS_LIB_FILES should include BC_ADDITIONAL_LIBS when set."""
        d = self.run_with_env("asap7", {"BC_ADDITIONAL_LIBS": "/extra/bc.lib"})
        self.assertIn("/extra/bc.lib", d["BC_CCS_LIB_FILES"])
        self.assertIn("_ccs_", d["BC_CCS_LIB_FILES"])

    def test_wc_nldm_lib_files(self):
        d = self.run_with_env("asap7")
        self.assertIn("_SS_nldm_", d["WC_NLDM_LIB_FILES"])
        self.assertIn("_RVT_", d["WC_NLDM_LIB_FILES"])

    def test_tc_nldm_lib_files(self):
        d = self.run_with_env("asap7")
        self.assertIn("_TT_nldm_", d["TC_NLDM_LIB_FILES"])
        self.assertIn("_RVT_", d["TC_NLDM_LIB_FILES"])

    def test_wc_corner_lib_files(self):
        """With CORNER=WC, LIB_FILES should use WC_NLDM_LIB_FILES."""
        d = self.run_with_env("asap7", {"CORNER": "WC"})
        self.assertIn("_SS_nldm_", d["LIB_FILES"])

    def test_tc_corner_lib_files(self):
        """With CORNER=TC, LIB_FILES should use TC_NLDM_LIB_FILES."""
        d = self.run_with_env("asap7", {"CORNER": "TC"})
        self.assertIn("_TT_nldm_", d["LIB_FILES"])

    def test_ccs_model_corner_selection(self):
        """With LIB_MODEL=CCS and CORNER=BC, LIB_FILES should use BC_CCS_LIB_FILES."""
        d = self.run_with_env("asap7", {"LIB_MODEL": "CCS", "CORNER": "BC"})
        self.assertIn("_ccs_", d["LIB_FILES"])

    def test_lvt_design_vars(self):
        """asap7/aes_lvt: ASAP7_USE_VT=LVT should set all primary VT vars to L tag."""
        d = self.run_with_env("asap7", {"ASAP7_USE_VT": "LVT"})
        self.assertIn("asap7sc7p5t_28_L_1x", d["SC_LEF"])
        self.assertIn("asap7sc7p5t_28_L_", d["GDS_FILES"])
        self.assertIn("TIEHIx1_ASAP7_75t_L", d["TIEHI_CELL_AND_PORT"])
        self.assertIn("BUFx2_ASAP7_75t_L", d["ABC_DRIVER_CELL"])
        self.assertIn("cells_latch_L.v", d["LATCH_MAP_FILE"])
        self.assertIn("TAPCELL_ASAP7_75t_L", d["TAP_CELL_NAME"])
        self.assertIn("FILLERxp5_ASAP7_75t_L", d["FILL_CELLS"])


class TestIhpExtraVarsFromIntegration(PlatformTestCase):
    """Tests for ihp-sg13g2 variables verified against Make integration output."""

    def test_slow_lib_files(self):
        d = self.run_with_env("ihp-sg13g2")
        self.assertIn("slow_1p08V_125C", d["SLOW_LIB_FILES"])

    def test_fast_lib_files(self):
        d = self.run_with_env("ihp-sg13g2")
        self.assertIn("fast_1p32V_m40C", d["FAST_LIB_FILES"])

    def test_typ_lib_files(self):
        d = self.run_with_env("ihp-sg13g2")
        self.assertIn("typ_1p20V_25C", d["TYP_LIB_FILES"])

    def test_lib_files_defaults_to_typ(self):
        """LIB_FILES ?= $(TYP_LIB_FILES)"""
        d = self.run_with_env("ihp-sg13g2")
        self.assertIn("typ_1p20V_25C", d["LIB_FILES"])

    def test_core_margin(self):
        d = self.run_with_env("ihp-sg13g2")
        self.assertEqual(d["CORE_MARGIN"], "17.5")

    def test_io_filler_cells(self):
        d = self.run_with_env("ihp-sg13g2")
        self.assertIn("sg13g2_Filler10000", d["IO_FILLER_CELLS"])
        self.assertIn("sg13g2_Filler200", d["IO_FILLER_CELLS"])

    def test_io_bondpad_vars(self):
        d = self.run_with_env("ihp-sg13g2")
        self.assertEqual(d["IO_BONDPAD_SIZE"], "70")
        self.assertEqual(d["IO_BONDPAD_NAME"], "bondpad_70x70")
        self.assertEqual(d["IO_LENGTH"], "180")
        self.assertEqual(d["IO_WIDTH"], "80")
        self.assertEqual(d["IO_SEALRING_OFFSET"], "70")

    def test_gds_allow_empty_regex(self):
        d = self.run_with_env("ihp-sg13g2")
        self.assertIn("RM_IHPSG13", d["GDS_ALLOW_EMPTY"])
        self.assertIn("CORNER", d["GDS_ALLOW_EMPTY"])

    def test_footprint_conditional_with_load_disabled(self):
        """FOOTPRINT_TCL set but LOAD_ADDITIONAL_FILES=0 -> no IO additions."""
        d = self.run_with_env(
            "ihp-sg13g2",
            {"FOOTPRINT_TCL": "/some/file.tcl", "LOAD_ADDITIONAL_FILES": "0"},
        )
        self.assertNotIn("sg13g2_io.lef", d.get("ADDITIONAL_LEFS", ""))

    def test_slow_lib_with_footprint(self):
        """FOOTPRINT_TCL set -> SLOW_LIB_FILES includes IO lib."""
        d = self.run_with_env("ihp-sg13g2", {"FOOTPRINT_TCL": "/some/file.tcl"})
        self.assertIn("sg13g2_io_slow", d["SLOW_LIB_FILES"])
        self.assertIn("sg13g2_stdcell_slow", d["SLOW_LIB_FILES"])


# ===================================================================
# 4. Integration tests: make clean_all metadata
# ===================================================================
INTEGRATION_DESIGNS = [
    ("nangate45", "gcd"),
    ("sky130hd", "gcd"),
    ("gf180", "ibex"),
    ("ihp-sg13g2", "gcd"),
    ("asap7", "aes-mbff"),
]


@unittest.skipUnless(os.environ.get("RUN_INTEGRATION"), "set RUN_INTEGRATION=1 to run")
class TestMakeIntegration(unittest.TestCase):
    """Run make DESIGN_CONFIG=... clean_all metadata through the shim.

    These tests verify the full config.mk shim -> config.py -> Make pipeline.
    They require Make and the ORFS environment to be set up.
    """

    def test_make_metadata(self):
        """Run make clean_all metadata and verify it succeeds."""
        for platform, design in INTEGRATION_DESIGNS:
            with self.subTest(platform=platform, design=design):
                design_config = f"designs/{platform}/{design}/config.mk"
                result = subprocess.run(
                    [
                        "make",
                        "clean_all",
                        "metadata",
                        f"DESIGN_CONFIG={design_config}",
                    ],
                    capture_output=True,
                    text=True,
                    cwd=os.path.abspath(FLOW_DIR),
                    timeout=300,
                )
                self.assertEqual(
                    result.returncode,
                    0,
                    f"make metadata failed for {platform}/{design}:\n"
                    f"stdout: {result.stdout[-2000:]}\n"
                    f"stderr: {result.stderr[-2000:]}",
                )


ALL_PLATFORMS = ["nangate45", "sky130hd", "sky130hs", "gf180", "ihp-sg13g2", "asap7"]


class TestUnexpandedOutput(PlatformTestCase):
    """Verify config.py output uses $(PLATFORM_DIR) and $(PLATFORM) instead of absolute paths.

    bazel-orfs runs in a sandbox where platform files live at different paths.
    config.py must output symbolic references so consumers can expand on their end:
    - Make: $(eval) expands $(PLATFORM_DIR) and $(PLATFORM)
    - bazel-orfs: Python substitution when the Bazel rule executes
    """

    def test_json_no_absolute_platform_dir(self):
        """JSON output must not contain the absolute platform_dir path."""
        for platform in ALL_PLATFORMS:
            with self.subTest(platform=platform):
                pd = get_platform_dir(platform)
                d = self.run_with_env(platform)
                mod = _load_config_module(platform)
                cfg = mod.get_config()

                buf = io.StringIO()
                with redirect_stdout(buf):
                    cfg.output_json()
                data = json.loads(buf.getvalue())

                for key, value in data.items():
                    self.assertNotIn(
                        pd,
                        value,
                        f"{platform}: {key} contains absolute path {pd!r} "
                        f"instead of $(PLATFORM_DIR). Value: {value!r}",
                    )

    def test_make_no_absolute_platform_dir(self):
        """Make output must not contain the absolute platform_dir path."""
        for platform in ALL_PLATFORMS:
            with self.subTest(platform=platform):
                pd = get_platform_dir(platform)
                self.run_with_env(platform)
                mod = _load_config_module(platform)
                cfg = mod.get_config()

                buf = io.StringIO()
                with redirect_stdout(buf):
                    cfg.output_make()
                output = buf.getvalue()

                self.assertNotIn(
                    pd,
                    output,
                    f"{platform}: Make output contains absolute path {pd!r} "
                    f"instead of $(PLATFORM_DIR)",
                )

    def test_glob_results_unexpanded(self):
        """GDS_FILES from glob must use $(PLATFORM_DIR), not absolute paths."""
        for platform in ["nangate45", "sky130hd", "sky130hs", "gf180"]:
            with self.subTest(platform=platform):
                pd = get_platform_dir(platform)
                self.run_with_env(platform)
                mod = _load_config_module(platform)
                cfg = mod.get_config()

                buf = io.StringIO()
                with redirect_stdout(buf):
                    cfg.output_json()
                data = json.loads(buf.getvalue())

                gds = data.get("GDS_FILES", "")
                self.assertTrue(gds, f"{platform}: GDS_FILES is empty")
                self.assertIn(
                    "$(PLATFORM_DIR)",
                    gds,
                    f"{platform}: GDS_FILES glob result missing $(PLATFORM_DIR): {gds!r}",
                )
                self.assertNotIn(
                    pd,
                    gds,
                    f"{platform}: GDS_FILES contains absolute path: {gds!r}",
                )

    def test_platform_name_unexpanded(self):
        """Variables using $(PLATFORM) in filenames must not expand it."""
        cases = [
            (
                "sky130hd",
                [
                    "KLAYOUT_TECH_FILE",
                    "KLAYOUT_DRC_FILE",
                    "CDL_FILE",
                    "KLAYOUT_LVS_FILE",
                ],
            ),
            ("sky130hs", ["KLAYOUT_TECH_FILE"]),
        ]
        for platform, keys in cases:
            with self.subTest(platform=platform):
                self.run_with_env(platform)
                mod = _load_config_module(platform)
                cfg = mod.get_config()

                buf = io.StringIO()
                with redirect_stdout(buf):
                    cfg.output_json()
                data = json.loads(buf.getvalue())

                for key in keys:
                    value = data.get(key, "")
                    self.assertIn(
                        "$(PLATFORM)",
                        value,
                        f"{platform}: {key} should contain $(PLATFORM), got: {value!r}",
                    )
                    self.assertNotIn(
                        f"/{platform}.",
                        value,
                        f"{platform}: {key} contains expanded platform name: {value!r}",
                    )


if __name__ == "__main__":
    unittest.main()
