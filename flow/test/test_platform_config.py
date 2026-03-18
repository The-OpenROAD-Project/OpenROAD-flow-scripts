#!/usr/bin/env python3
"""Tests for platform config.py files.

Covers every Make construct used across all 6 platform config.mk files.
Tests are organized by use-case (Make construct) and by platform.

Run: pytest flow/test/test_platform_config.py -v
Integration: pytest flow/test/test_platform_config.py -v -m integration
"""

import json
import os
import subprocess
import sys
import textwrap

import pytest

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


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
def get_platform_dir(platform):
    return os.path.abspath(os.path.join(FLOW_DIR, "platforms", platform))


def clean_env(monkeypatch, platform, extras=None):
    """Set up a clean environment for testing a platform config."""
    pd = get_platform_dir(platform)
    monkeypatch.setenv("PLATFORM_DIR", pd)
    monkeypatch.setenv("PLATFORM", platform)
    # Remove variables that might leak from the real environment
    for var in [
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
    ]:
        monkeypatch.delenv(var, raising=False)
    if extras:
        for k, v in extras.items():
            monkeypatch.setenv(k, v)


# ===================================================================
# 1. PlatformConfig utility tests
# ===================================================================
class TestPlatformConfigUtility:
    """Test the shared PlatformConfig class in isolation."""

    def test_set_unconditional(self):
        cfg = PlatformConfig(platform_dir="/fake")
        cfg.set("FOO", "bar")
        d = cfg.to_dict()
        assert d["FOO"] == "bar"

    def test_set_conditional_default(self):
        cfg = PlatformConfig(platform_dir="/fake")
        cfg.set("FOO", "default_val", conditional=True)
        d = cfg.to_dict()
        assert d["FOO"] == "default_val"

    def test_set_conditional_override_from_env(self, monkeypatch):
        monkeypatch.setenv("FOO", "from_env")
        cfg = PlatformConfig(platform_dir="/fake")
        cfg.set("FOO", "default_val", conditional=True)
        d = cfg.to_dict()
        assert d["FOO"] == "from_env"

    def test_set_conditional_does_not_overwrite_internal(self):
        cfg = PlatformConfig(platform_dir="/fake")
        cfg.set("FOO", "first")
        cfg.set("FOO", "second", conditional=True)
        d = cfg.to_dict()
        assert d["FOO"] == "first"

    def test_append_internal(self):
        cfg = PlatformConfig(platform_dir="/fake")
        cfg.set("FOO", "a b")
        cfg.append("FOO", "c d")
        d = cfg.to_dict()
        assert d["FOO"] == "a b c d"

    def test_append_from_env(self, monkeypatch):
        monkeypatch.setenv("FOO", "from_env")
        cfg = PlatformConfig(platform_dir="/fake")
        cfg.append("FOO", "extra")
        d = cfg.to_dict()
        assert d["FOO"] == "from_env extra"

    def test_append_new_var(self):
        cfg = PlatformConfig(platform_dir="/fake")
        cfg.append("FOO", "value")
        d = cfg.to_dict()
        assert d["FOO"] == "value"

    def test_get(self):
        cfg = PlatformConfig(platform_dir="/fake")
        cfg.set("FOO", "bar")
        assert cfg.get("FOO") == "bar"
        assert cfg.get("MISSING", "default") == "default"

    def test_output_make(self, capsys):
        cfg = PlatformConfig(platform_dir="/fake")
        cfg.set("SIMPLE", "value")
        cfg.set("SPACES", "a b c")
        cfg.set("COND", "default", conditional=True)
        cfg.output_make()
        out = capsys.readouterr().out
        lines = out.strip().split("\n")
        assert "export SIMPLE=value" in lines
        assert "export SPACES=a__SPACE__b__SPACE__c" in lines
        assert "export COND?=default" in lines

    def test_output_json(self, capsys):
        cfg = PlatformConfig(platform_dir="/fake")
        cfg.set("KEY1", "val1")
        cfg.set("KEY2", "val2")
        cfg.output_json()
        out = capsys.readouterr().out
        data = json.loads(out)
        assert data["KEY1"] == "val1"
        assert data["KEY2"] == "val2"

    def test_sorted_glob(self, tmp_path):
        # Create some files
        (tmp_path / "c.gds").touch()
        (tmp_path / "a.gds").touch()
        (tmp_path / "b.gds").touch()
        cfg = PlatformConfig(platform_dir="/fake")
        result = cfg.sorted_glob(str(tmp_path / "*.gds"))
        files = result.split()
        assert len(files) == 3
        assert files[0].endswith("a.gds")
        assert files[1].endswith("b.gds")
        assert files[2].endswith("c.gds")

    def test_wildcard_glob(self, tmp_path):
        (tmp_path / "x.gds").touch()
        (tmp_path / "y.gds").touch()
        cfg = PlatformConfig(platform_dir="/fake")
        result = cfg.wildcard_glob(str(tmp_path / "*.gds"))
        files = result.split()
        assert len(files) == 2


# ===================================================================
# 2. Per-platform unit tests -- use-case coverage
# ===================================================================


# --- Test 1: Unconditional assignment (export VAR = value) ---
class TestUnconditionalAssignment:
    @pytest.mark.parametrize(
        "platform,key,expected_substr",
        [
            ("nangate45", "PROCESS", "45"),
            ("sky130hs", "PROCESS", "130"),
            ("sky130hd", "PROCESS", "130"),
            ("gf180", "PROCESS", "180"),
            ("ihp-sg13g2", "PROCESS", "ihp-sg13g2"),
            ("asap7", "PROCESS", "7"),
        ],
    )
    def test_unconditional_assignment(
        self, monkeypatch, platform, key, expected_substr
    ):
        clean_env(monkeypatch, platform)
        cfg = PLATFORM_MODULES[platform].get_config()
        d = cfg.to_dict()
        assert d[key] == expected_substr


# --- Test 2: Conditional assignment (export VAR ?= value) ---
class TestConditionalAssignment:
    @pytest.mark.parametrize(
        "platform,key,default_val",
        [
            ("nangate45", "PLACE_DENSITY", "0.30"),
            ("sky130hs", "PLACE_DENSITY", "0.50"),
            ("sky130hd", "PLACE_DENSITY", "0.60"),
            ("gf180", "PLACE_DENSITY", "0.40"),
            ("ihp-sg13g2", "PLACE_DENSITY", "0.65"),
            ("asap7", "PLACE_DENSITY", "0.60"),
        ],
    )
    def test_conditional_assignment_default(
        self, monkeypatch, platform, key, default_val
    ):
        clean_env(monkeypatch, platform)
        cfg = PLATFORM_MODULES[platform].get_config()
        d = cfg.to_dict()
        assert d[key] == default_val

    @pytest.mark.parametrize("platform", PLATFORMS)
    def test_conditional_assignment_override(self, monkeypatch, platform):
        clean_env(monkeypatch, platform, {"PLACE_DENSITY": "0.99"})
        cfg = PLATFORM_MODULES[platform].get_config()
        d = cfg.to_dict()
        assert d["PLACE_DENSITY"] == "0.99"


# --- Test 3: Internal append (VAR += value within same config) ---
class TestInternalAppend:
    def test_asap7_dont_use_cells_internal_append(self, monkeypatch):
        """asap7: DONT_USE_CELLS = X then DONT_USE_CELLS += SDF* ICG*"""
        clean_env(monkeypatch, "asap7")
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert "*x1p*_ASAP7*" in d["DONT_USE_CELLS"]
        assert "SDF*" in d["DONT_USE_CELLS"]
        assert "ICG*" in d["DONT_USE_CELLS"]


# --- Test 4: External append (VAR += from env) ---
class TestExternalAppend:
    def test_sky130hd_dont_use_cells_from_env(self, monkeypatch):
        """sky130hd: DONT_USE_CELLS += list (appends to env value)"""
        clean_env(monkeypatch, "sky130hd", {"DONT_USE_CELLS": "EXISTING_CELL"})
        cfg = sky130hd_config.get_config()
        d = cfg.to_dict()
        assert "EXISTING_CELL" in d["DONT_USE_CELLS"]
        assert "sky130_fd_sc_hd__probe_p_8" in d["DONT_USE_CELLS"]

    def test_ihp_dont_use_cells_from_env(self, monkeypatch):
        """ihp-sg13g2: DONT_USE_CELLS += list (appends to env value)"""
        clean_env(monkeypatch, "ihp-sg13g2", {"DONT_USE_CELLS": "EXISTING"})
        cfg = ihp_config.get_config()
        d = cfg.to_dict()
        assert "EXISTING" in d["DONT_USE_CELLS"]
        assert "sg13g2_lgcp_1" in d["DONT_USE_CELLS"]


# --- Test 5: $(PLATFORM_DIR)/path expansion ---
class TestPlatformDirExpansion:
    @pytest.mark.parametrize(
        "platform,key,suffix",
        [
            ("nangate45", "TECH_LEF", "/lef/NangateOpenCellLibrary.tech.lef"),
            ("sky130hd", "TECH_LEF", "/lef/sky130_fd_sc_hd.tlef"),
            ("asap7", "TECH_LEF", "/lef/asap7_tech_1x_201209.lef"),
        ],
    )
    def test_platform_dir_expansion(self, monkeypatch, platform, key, suffix):
        clean_env(monkeypatch, platform)
        cfg = PLATFORM_MODULES[platform].get_config()
        d = cfg.to_dict()
        assert d[key].endswith(suffix)
        assert get_platform_dir(platform) in d[key]


# --- Test 6: $(sort $(wildcard ...)) ---
class TestSortedGlob:
    def test_nangate45_gds_files_sorted(self, monkeypatch):
        clean_env(monkeypatch, "nangate45")
        cfg = nangate45_config.get_config()
        d = cfg.to_dict()
        gds = d["GDS_FILES"].split()
        # Verify files are sorted
        assert gds == sorted(gds)


# --- Test 7: $(wildcard ...) ---
class TestWildcardGlob:
    def test_sky130hd_gds_files(self, monkeypatch):
        clean_env(monkeypatch, "sky130hd")
        cfg = sky130hd_config.get_config()
        d = cfg.to_dict()
        # GDS_FILES should contain at least one .gds file
        if d["GDS_FILES"].strip():
            assert ".gds" in d["GDS_FILES"]


# --- Test 8: ifeq/ifneq conditionals ---
class TestConditionalIfeq:
    def test_gf180_place_site_9t(self, monkeypatch):
        """gf180: ifeq ($(TRACK_OPTION),9t) -> GF018hv5v_green_sc9"""
        clean_env(monkeypatch, "gf180")
        cfg = gf180_config.get_config()
        d = cfg.to_dict()
        assert d["PLACE_SITE"] == "GF018hv5v_green_sc9"

    def test_gf180_place_site_7t(self, monkeypatch):
        """gf180: else -> GF018hv5v_mcu_sc7"""
        clean_env(monkeypatch, "gf180", {"TRACK_OPTION": "7t"})
        cfg = gf180_config.get_config()
        d = cfg.to_dict()
        assert d["PLACE_SITE"] == "GF018hv5v_mcu_sc7"

    def test_asap7_pdn_no_blocks(self, monkeypatch):
        """asap7: ifeq ($(BLOCKS),) -> grid_strategy-M1-M2-M5-M6.tcl"""
        clean_env(monkeypatch, "asap7")
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert "grid_strategy-M1-M2-M5-M6.tcl" in d["PDN_TCL"]

    def test_asap7_pdn_with_blocks(self, monkeypatch):
        """asap7: BLOCKS set -> BLOCKS_grid_strategy.tcl"""
        clean_env(monkeypatch, "asap7", {"BLOCKS": "block1"})
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert "BLOCKS_grid_strategy.tcl" in d["PDN_TCL"]


# --- Test 9: $(ADDITIONAL_LIBS) from env ---
class TestEnvVariableInclusion:
    def test_nangate45_additional_libs(self, monkeypatch):
        clean_env(monkeypatch, "nangate45", {"ADDITIONAL_LIBS": "/extra/lib.lib"})
        cfg = nangate45_config.get_config()
        d = cfg.to_dict()
        assert "/extra/lib.lib" in d["LIB_FILES"]
        assert "NangateOpenCellLibrary_typical.lib" in d["LIB_FILES"]


# --- Test 10: $($(CORNER)_LIB_FILES) variable indirection ---
class TestVariableIndirection:
    def test_gf180_bc_corner(self, monkeypatch):
        clean_env(monkeypatch, "gf180", {"CORNER": "BC"})
        cfg = gf180_config.get_config()
        d = cfg.to_dict()
        assert "ff_n40C_5v50" in d["LIB_FILES"]

    def test_gf180_wc_corner(self, monkeypatch):
        clean_env(monkeypatch, "gf180", {"CORNER": "WC"})
        cfg = gf180_config.get_config()
        d = cfg.to_dict()
        assert "ss_125C_4v50" in d["LIB_FILES"]

    def test_gf180_tc_corner(self, monkeypatch):
        clean_env(monkeypatch, "gf180", {"CORNER": "TC"})
        cfg = gf180_config.get_config()
        d = cfg.to_dict()
        assert "tt_025C_5v00" in d["LIB_FILES"]

    def test_asap7_bc_nldm_corner(self, monkeypatch):
        clean_env(monkeypatch, "asap7", {"CORNER": "BC"})
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert "_FF_nldm_" in d["LIB_FILES"]

    def test_asap7_wc_corner(self, monkeypatch):
        clean_env(monkeypatch, "asap7", {"CORNER": "WC"})
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert "_SS_nldm_" in d["LIB_FILES"]


# --- Test 11: $(subst PLACEHOLDER,...) template expansion ---
class TestPlaceholderSubstitution:
    def test_asap7_placeholder_expansion(self, monkeypatch):
        """asap7: $(subst PLACEHOLDER,$(PRIMARY_VT_TAG),...) templates"""
        clean_env(monkeypatch, "asap7")
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        # Default VT is RVT -> tag "R"
        assert "PLACEHOLDER" not in d.get("BC_NLDM_DFF_LIB_FILE", "")
        assert "_RVT_" in d["BC_NLDM_DFF_LIB_FILE"]
        assert "_RVT_" in d["BC_NLDM_LIB_FILES"]


# --- Test 12: $(patsubst %VT,%,...) ---
class TestPatsubstVtTag:
    def test_asap7_vt_tag_derivation(self, monkeypatch):
        """RVT -> R, LVT -> L, SLVT -> SL"""
        clean_env(monkeypatch, "asap7", {"ASAP7_USE_VT": "LVT"})
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        # PRIMARY_VT=LVT -> tag L
        assert "_L_" in d["SC_LEF"] or "_L_" in d["GDS_FILES"]

    def test_asap7_slvt_tag(self, monkeypatch):
        clean_env(monkeypatch, "asap7", {"ASAP7_USE_VT": "SLVT"})
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert "_SL_" in d["SC_LEF"]


# --- Test 13: $(word 1,...) ---
class TestWordExtraction:
    def test_asap7_primary_vt_is_first(self, monkeypatch):
        """PRIMARY_VT = $(word 1, $(VT_LIST))"""
        clean_env(monkeypatch, "asap7", {"ASAP7_USE_VT": "LVT RVT SLVT"})
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        # Primary should be LVT -> tag L
        assert "asap7sc7p5t_28_L_" in d["SC_LEF"]


# --- Test 14: $(wordlist 2,N,...) ---
class TestWordlistExtraction:
    def test_asap7_other_vt_is_rest(self, monkeypatch):
        """OTHER_VT = $(wordlist 2, ..., $(VT_LIST))"""
        clean_env(monkeypatch, "asap7", {"ASAP7_USE_VT": "RVT LVT SLVT"})
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        # OTHER_VT = [LVT, SLVT], should appear in ADDITIONAL_LEFS
        assert "asap7sc7p5t_28_L_1x" in d.get("ADDITIONAL_LEFS", "")
        assert "asap7sc7p5t_28_SL_1x" in d.get("ADDITIONAL_LEFS", "")


# --- Test 15: $(addsuffix tag,...) ---
class TestAddsuffix:
    def test_asap7_fill_cells_suffix(self, monkeypatch):
        """FILL_CELLS = $(addsuffix $(PRIMARY_VT_TAG), $(FILL_CELLS_T))"""
        clean_env(monkeypatch, "asap7")
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        # Default RVT -> tag R
        assert "FILLERxp5_ASAP7_75t_R" in d["FILL_CELLS"]
        assert "FILLER_ASAP7_75t_R" in d["FILL_CELLS"]
        assert "DECAPx10_ASAP7_75t_R" in d["FILL_CELLS"]


# --- Test 16: $(if $(strip $(VAR)),...) ---
class TestIfStrip:
    def test_asap7_default_vt_when_unset(self, monkeypatch):
        """VT_LIST = $(if $(strip $(ASAP7_USE_VT)), ..., RVT)"""
        clean_env(monkeypatch, "asap7")
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        # Should default to RVT -> tag R
        assert "asap7sc7p5t_28_R_" in d["GDS_FILES"]

    def test_asap7_vt_when_set(self, monkeypatch):
        clean_env(monkeypatch, "asap7", {"ASAP7_USE_VT": "LVT"})
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert "asap7sc7p5t_28_L_" in d["GDS_FILES"]


# --- Test 17: $(foreach)/$(eval) loop ---
class TestForeachEvalVtExpansion:
    def test_asap7_multi_vt_expansion(self, monkeypatch):
        """foreach vt in OTHER_VT: expand templates and append"""
        clean_env(monkeypatch, "asap7", {"ASAP7_USE_VT": "RVT LVT SLVT"})
        cfg = asap7_config.get_config()
        d = cfg.to_dict()

        # Primary VT = RVT (tag R)
        assert "asap7sc7p5t_28_R_" in d["GDS_FILES"]

        # OTHER_VT = [LVT, SLVT] should be appended
        assert "asap7sc7p5t_28_L_220121a.gds" in d["GDS_FILES"]
        assert "asap7sc7p5t_28_SL_220121a.gds" in d["GDS_FILES"]

        # ADDITIONAL_LEFS should have OTHER_VT entries
        assert "asap7sc7p5t_28_L_1x_220121a.lef" in d.get("ADDITIONAL_LEFS", "")
        assert "asap7sc7p5t_28_SL_1x_220121a.lef" in d.get("ADDITIONAL_LEFS", "")

        # DFF lib files should have all 3 VTs
        assert "_RVT_" in d["BC_NLDM_DFF_LIB_FILE"]
        assert "_LVT_" in d["BC_NLDM_DFF_LIB_FILE"]
        assert "_SLVT_" in d["BC_NLDM_DFF_LIB_FILE"]

        # FILL_CELLS should have all 3 VT suffixes
        assert "FILLERxp5_ASAP7_75t_R" in d["FILL_CELLS"]
        assert "FILLERxp5_ASAP7_75t_L" in d["FILL_CELLS"]
        assert "FILLERxp5_ASAP7_75t_SL" in d["FILL_CELLS"]


# --- Test 18: $(strip ...) ---
class TestStrip:
    def test_asap7_strip_asap7_use_vt(self, monkeypatch):
        """Whitespace in ASAP7_USE_VT should be stripped"""
        clean_env(monkeypatch, "asap7", {"ASAP7_USE_VT": "  RVT  "})
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert "asap7sc7p5t_28_R_" in d["GDS_FILES"]


# --- Test 19: $(shell sed ...) SDC clock period extraction ---
class TestSdcClockPeriodExtraction:
    def test_ihp_sdc_clk_period(self, monkeypatch, tmp_path):
        """ihp-sg13g2: extract clock period from SDC file"""
        sdc = tmp_path / "constraint.sdc"
        sdc.write_text("set clk_period 10.0\ncreate_clock ...\n")
        clean_env(monkeypatch, "ihp-sg13g2", {"SDC_FILE": str(sdc)})
        cfg = ihp_config.get_config()
        d = cfg.to_dict()
        assert d["ABC_CLOCK_PERIOD_IN_PS"] == "10000.0"

    def test_ihp_sdc_period_flag(self, monkeypatch, tmp_path):
        """ihp-sg13g2: extract from -period flag"""
        sdc = tmp_path / "constraint.sdc"
        sdc.write_text("create_clock -period 5.0 [get_ports clk]\n")
        clean_env(monkeypatch, "ihp-sg13g2", {"SDC_FILE": str(sdc)})
        cfg = ihp_config.get_config()
        d = cfg.to_dict()
        assert d["ABC_CLOCK_PERIOD_IN_PS"] == "5000.0"

    def test_ihp_no_sdc_file(self, monkeypatch):
        """No SDC file -> ABC_CLOCK_PERIOD_IN_PS not set"""
        clean_env(monkeypatch, "ihp-sg13g2")
        cfg = ihp_config.get_config()
        d = cfg.to_dict()
        assert "ABC_CLOCK_PERIOD_IN_PS" not in d


# --- Test 20: $(origin VAR) check ---
class TestOriginCheck:
    def test_ihp_origin_undefined(self, monkeypatch, tmp_path):
        """When ABC_CLOCK_PERIOD_IN_PS is not in env, extract from SDC"""
        sdc = tmp_path / "constraint.sdc"
        sdc.write_text("set clk_period 8.0\n")
        clean_env(monkeypatch, "ihp-sg13g2", {"SDC_FILE": str(sdc)})
        cfg = ihp_config.get_config()
        d = cfg.to_dict()
        assert d["ABC_CLOCK_PERIOD_IN_PS"] == "8000.0"

    def test_ihp_origin_defined(self, monkeypatch, tmp_path):
        """When ABC_CLOCK_PERIOD_IN_PS is in env, don't extract"""
        sdc = tmp_path / "constraint.sdc"
        sdc.write_text("set clk_period 8.0\n")
        clean_env(
            monkeypatch,
            "ihp-sg13g2",
            {
                "SDC_FILE": str(sdc),
                "ABC_CLOCK_PERIOD_IN_PS": "12345",
            },
        )
        cfg = ihp_config.get_config()
        d = cfg.to_dict()
        assert (
            "ABC_CLOCK_PERIOD_IN_PS" not in d
            or d.get("ABC_CLOCK_PERIOD_IN_PS") != "8000.0"
        )


# --- Test 21: $(abspath ...) ---
class TestAbspath:
    def test_gf180_lib_files_absolute(self, monkeypatch):
        clean_env(monkeypatch, "gf180")
        cfg = gf180_config.get_config()
        d = cfg.to_dict()
        # BC_LIB_FILES should be absolute path
        assert os.path.isabs(d["BC_LIB_FILES"])
        assert os.path.isabs(d["LIB_FILES"].split()[0])


# --- Test 22: $(realpath ...) ---
class TestRealpath:
    def test_asap7_db_files_realpath(self, monkeypatch):
        """asap7: DB_FILES uses $(realpath ...) -- only if corner DB files exist"""
        clean_env(monkeypatch, "asap7")
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        # DB_FILES may be empty if no corner DB files are defined
        # Just verify it doesn't crash
        assert isinstance(d.get("DB_FILES", ""), str)


# --- Test 23: -include private.mk skipped ---
class TestPrivateMkSkipped:
    def test_gf180_has_private_dir_default(self, monkeypatch):
        """gf180: -include private.mk is skipped, but GF180_PRIVATE_DIR is set"""
        clean_env(monkeypatch, "gf180")
        cfg = gf180_config.get_config()
        d = cfg.to_dict()
        assert d["GF180_PRIVATE_DIR"] == "../../gf180-private"


# --- Test 24: ??= (treated as ?=) ---
class TestDoubleQuestionEquals:
    def test_ihp_io_pins_default_empty(self, monkeypatch):
        """ihp-sg13g2: ??= variables default to empty"""
        clean_env(monkeypatch, "ihp-sg13g2")
        cfg = ihp_config.get_config()
        d = cfg.to_dict()
        assert d.get("IO_NORTH_PINS", "") == ""
        assert d.get("IO_SOUTH_PINS", "") == ""

    def test_ihp_io_pins_override(self, monkeypatch):
        """ihp-sg13g2: ??= variables can be overridden from env"""
        clean_env(monkeypatch, "ihp-sg13g2", {"IO_NORTH_PINS": "pin1 pin2"})
        cfg = ihp_config.get_config()
        d = cfg.to_dict()
        assert d["IO_NORTH_PINS"] == "pin1 pin2"


# --- Test 25: Parameterized options (gf180) ---
class TestGf180ParameterizedOptions:
    def test_default_options(self, monkeypatch):
        clean_env(monkeypatch, "gf180")
        cfg = gf180_config.get_config()
        d = cfg.to_dict()
        assert "5LM_1TM" in d["TECH_LEF"]
        assert "9K" in d["TECH_LEF"]
        assert "9t" in d["TECH_LEF"]

    def test_custom_track_option(self, monkeypatch):
        clean_env(monkeypatch, "gf180", {"TRACK_OPTION": "7t"})
        cfg = gf180_config.get_config()
        d = cfg.to_dict()
        assert "7t" in d["TECH_LEF"]
        assert d["PLACE_SITE"] == "GF018hv5v_mcu_sc7"

    def test_custom_metal_option(self, monkeypatch):
        clean_env(monkeypatch, "gf180", {"METAL_OPTION": "3LM_1TM"})
        cfg = gf180_config.get_config()
        d = cfg.to_dict()
        assert "3LM_1TM" in d["TECH_LEF"]


# --- Test 26: BLOCKS conditional for PDN_TCL ---
class TestAsap7BlocksPdn:
    def test_no_blocks(self, monkeypatch):
        clean_env(monkeypatch, "asap7")
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert "BLOCKS" not in d["PDN_TCL"]

    def test_with_blocks(self, monkeypatch):
        clean_env(monkeypatch, "asap7", {"BLOCKS": "some_block"})
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert "BLOCKS_grid_strategy" in d["PDN_TCL"]


# --- Test 27: CLUSTER_FLOPS conditional ---
class TestAsap7ClusterFlops:
    def test_no_cluster_flops(self, monkeypatch):
        clean_env(monkeypatch, "asap7")
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert "DFFHQNH2V2X" not in d.get("ADDITIONAL_LIBS", "")

    def test_with_cluster_flops(self, monkeypatch):
        clean_env(monkeypatch, "asap7", {"CLUSTER_FLOPS": "1"})
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert "DFFHQNH2V2X" in d.get("ADDITIONAL_LIBS", "")
        assert "DFFHQNV2X" in d.get("ADDITIONAL_LIBS", "")
        assert "asap7sc7p5t_DFFHQNH2V2X.lef" in d.get("ADDITIONAL_LEFS", "")
        assert "asap7sc7p5t_pg" in d.get("ADDITIONAL_SITES", "")
        assert d.get("GDS_ALLOW_EMPTY") == "DFFHQN[VH][24].*"


# --- Test 28: LIB_MODEL selection ---
class TestAsap7LibModel:
    def test_default_nldm(self, monkeypatch):
        clean_env(monkeypatch, "asap7")
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert "/NLDM/" in d["LIB_DIR"] or d["LIB_DIR"].endswith("/NLDM")

    def test_ccs_model(self, monkeypatch):
        clean_env(monkeypatch, "asap7", {"LIB_MODEL": "CCS"})
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert "/CCS/" in d["LIB_DIR"] or d["LIB_DIR"].endswith("/CCS")


# --- Test 29: Corner temperature/voltage ---
class TestCornerTemperatureVoltage:
    def test_asap7_bc_corner(self, monkeypatch):
        clean_env(monkeypatch, "asap7", {"CORNER": "BC"})
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert d["TEMPERATURE"] == "25C"
        assert d["VOLTAGE"] == "0.77"

    def test_asap7_wc_corner(self, monkeypatch):
        clean_env(monkeypatch, "asap7", {"CORNER": "WC"})
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert d["TEMPERATURE"] == "100C"
        assert d["VOLTAGE"] == "0.63"

    def test_gf180_bc_corner(self, monkeypatch):
        clean_env(monkeypatch, "gf180", {"CORNER": "BC"})
        cfg = gf180_config.get_config()
        d = cfg.to_dict()
        assert d["TEMPERATURE"] == "-40c"
        assert d["VOLTAGE"] == "5.5"

    def test_gf180_wc_corner(self, monkeypatch):
        clean_env(monkeypatch, "gf180", {"CORNER": "WC"})
        cfg = gf180_config.get_config()
        d = cfg.to_dict()
        assert d["TEMPERATURE"] == "125c"
        assert d["VOLTAGE"] == "4.5"


# --- Test 30: Multi-VT expansion ---
class TestAsap7MultiVt:
    def test_single_vt_default(self, monkeypatch):
        """Default: ASAP7_USE_VT unset -> RVT only, no OTHER_VT additions"""
        clean_env(monkeypatch, "asap7")
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        # Only primary VT in GDS_FILES
        gds = d["GDS_FILES"]
        assert "28_R_" in gds
        assert "28_L_" not in gds
        # No ADDITIONAL_LEFS from VT loop (may have CLUSTER_FLOPS additions)
        assert "28_L_1x" not in d.get("ADDITIONAL_LEFS", "")

    def test_dual_vt(self, monkeypatch):
        clean_env(monkeypatch, "asap7", {"ASAP7_USE_VT": "RVT LVT"})
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert "28_R_" in d["GDS_FILES"]
        assert "28_L_" in d["GDS_FILES"]


# --- Test 31: FOOTPRINT_TCL conditional (ihp-sg13g2) ---
class TestIhpFootprintConditional:
    def test_no_footprint(self, monkeypatch):
        """No FOOTPRINT_TCL -> no IO lefs/libs added"""
        clean_env(monkeypatch, "ihp-sg13g2")
        cfg = ihp_config.get_config()
        d = cfg.to_dict()
        assert "sg13g2_io.lef" not in d.get("ADDITIONAL_LEFS", "")

    def test_with_footprint(self, monkeypatch):
        """FOOTPRINT_TCL set -> IO lefs/libs/gds added"""
        clean_env(monkeypatch, "ihp-sg13g2", {"FOOTPRINT_TCL": "/some/file.tcl"})
        cfg = ihp_config.get_config()
        d = cfg.to_dict()
        assert "sg13g2_io.lef" in d.get("ADDITIONAL_LEFS", "")
        assert "bondpad_70x70.lef" in d.get("ADDITIONAL_LEFS", "")
        assert "sg13g2_io_slow" in d.get("SLOW_LIB_FILES", "")
        assert "sg13g2_io.gds" in d.get("ADDITIONAL_GDS", "")


# --- Test 32: $(PLATFORM) in paths ---
class TestPlatformVarInPaths:
    def test_sky130hd_platform_in_klayout(self, monkeypatch):
        clean_env(monkeypatch, "sky130hd")
        cfg = sky130hd_config.get_config()
        d = cfg.to_dict()
        assert "sky130hd.lyt" in d["KLAYOUT_TECH_FILE"]
        assert "sky130hd.lydrc" in d["KLAYOUT_DRC_FILE"]
        assert "sky130hd.cdl" in d["CDL_FILE"]

    def test_sky130hs_platform_in_klayout(self, monkeypatch):
        clean_env(monkeypatch, "sky130hs")
        cfg = sky130hs_config.get_config()
        d = cfg.to_dict()
        assert "sky130hs.lyt" in d["KLAYOUT_TECH_FILE"]


# --- Test 33: Make shim round-trip ---
class TestShimRoundTrip:
    """Verify config.py Make output format is consumable by foreach/eval."""

    @pytest.mark.parametrize("platform", PLATFORMS)
    def test_make_output_format(self, monkeypatch, platform, capsys):
        """Each line is 'export KEY=VALUE' or 'export KEY?=VALUE' with __SPACE__"""
        clean_env(monkeypatch, platform)
        cfg = PLATFORM_MODULES[platform].get_config()
        cfg.output_make()
        out = capsys.readouterr().out
        for line in out.strip().split("\n"):
            assert line.startswith(
                "export "
            ), f"Line doesn't start with 'export ': {line}"
            rest = line[7:]  # strip "export "
            assert "=" in rest, f"No = in: {line}"
            # No actual spaces in values (should be __SPACE__)
            key_op_val = rest
            if "?=" in key_op_val:
                key, val = key_op_val.split("?=", 1)
            else:
                key, val = key_op_val.split("=", 1)
            assert " " not in val, f"Space in value (should be __SPACE__): {key}={val}"

    @pytest.mark.parametrize("platform", PLATFORMS)
    def test_json_output_parseable(self, monkeypatch, platform, capsys):
        """JSON output should be valid and parseable."""
        clean_env(monkeypatch, platform)
        cfg = PLATFORM_MODULES[platform].get_config()
        cfg.output_json()
        out = capsys.readouterr().out
        data = json.loads(out)
        assert isinstance(data, dict)
        assert len(data) > 0


# ===================================================================
# 3. Integration findings: design-config override semantics
# ===================================================================
class TestDesignConfigOverrides:
    """Tests discovered from Make integration comparison.

    When a design config.mk sets a variable with = or :=, it overrides
    the platform config.py's ?= default. These tests verify the ?=
    semantics work correctly end-to-end.
    """

    def test_conditional_overridden_by_immediate_assignment(self, monkeypatch):
        """nangate45/gcd: 'export ADDER_MAP_FILE :=' in design clears platform ?= default.

        Make's := (immediate assignment) sets the variable even if empty.
        When the platform config.py sees ADDER_MAP_FILE already in env,
        its ?= is a no-op.
        """
        clean_env(monkeypatch, "nangate45", {"ADDER_MAP_FILE": ""})
        cfg = nangate45_config.get_config()
        d = cfg.to_dict()
        # Empty env value should win over ?= default
        assert d["ADDER_MAP_FILE"] == ""

    def test_design_place_density_overrides_platform(self, monkeypatch):
        """asap7/gcd: design sets PLACE_DENSITY=0.35, overriding platform ?=0.60."""
        clean_env(monkeypatch, "asap7", {"PLACE_DENSITY": "0.35"})
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert d["PLACE_DENSITY"] == "0.35"

    def test_design_pdn_tcl_overrides_platform(self, monkeypatch):
        """nangate45/gcd: design sets PDN_TCL, overriding platform ?= default."""
        clean_env(
            monkeypatch,
            "nangate45",
            {"PDN_TCL": "/designs/nangate45/gcd/custom_pdn.tcl"},
        )
        cfg = nangate45_config.get_config()
        d = cfg.to_dict()
        assert d["PDN_TCL"] == "/designs/nangate45/gcd/custom_pdn.tcl"

    def test_ihp_design_place_density_overrides(self, monkeypatch):
        """ihp-sg13g2/gcd: design sets PLACE_DENSITY?=0.88, platform has ?=0.65.
        Design config is included BEFORE platform config. Since both use ?=,
        the first one (design) wins."""
        clean_env(monkeypatch, "ihp-sg13g2", {"PLACE_DENSITY": "0.88"})
        cfg = ihp_config.get_config()
        d = cfg.to_dict()
        assert d["PLACE_DENSITY"] == "0.88"


class TestGf180CornerVariants:
    """Tests for all 3 gf180 corners discovered from Make integration comparison."""

    def test_bc_rcx_rules(self, monkeypatch):
        clean_env(monkeypatch, "gf180", {"CORNER": "BC"})
        cfg = gf180_config.get_config()
        d = cfg.to_dict()
        assert "bst.rules" in d["RCX_RULES"]
        assert d["RCX_RC_CORNER"] == "FuncRCmin"

    def test_wc_rcx_rules(self, monkeypatch):
        clean_env(monkeypatch, "gf180", {"CORNER": "WC"})
        cfg = gf180_config.get_config()
        d = cfg.to_dict()
        assert "wst.rules" in d["RCX_RULES"]
        assert d["RCX_RC_CORNER"] == "FuncRCmax"

    def test_tc_rcx_rules(self, monkeypatch):
        clean_env(monkeypatch, "gf180", {"CORNER": "TC"})
        cfg = gf180_config.get_config()
        d = cfg.to_dict()
        assert "typ.rules" in d["RCX_RULES"]
        assert d["RCX_RC_CORNER"] == "FuncRCtyp"

    def test_bc_pwr_nets_uses_corner_voltage(self, monkeypatch):
        """PWR_NETS_VOLTAGES should use the corner-specific voltage."""
        clean_env(monkeypatch, "gf180", {"CORNER": "BC"})
        cfg = gf180_config.get_config()
        d = cfg.to_dict()
        assert d["PWR_NETS_VOLTAGES"] == "VDD 5.5"

    def test_wc_pwr_nets_uses_corner_voltage(self, monkeypatch):
        clean_env(monkeypatch, "gf180", {"CORNER": "WC"})
        cfg = gf180_config.get_config()
        d = cfg.to_dict()
        assert d["PWR_NETS_VOLTAGES"] == "VDD 4.5"

    def test_tc_pwr_nets_uses_corner_voltage(self, monkeypatch):
        clean_env(monkeypatch, "gf180", {"CORNER": "TC"})
        cfg = gf180_config.get_config()
        d = cfg.to_dict()
        assert d["PWR_NETS_VOLTAGES"] == "VDD 5.0"

    def test_gds_layer_map_absolute_path(self, monkeypatch):
        clean_env(monkeypatch, "gf180")
        cfg = gf180_config.get_config()
        d = cfg.to_dict()
        assert os.path.isabs(d["GDS_LAYER_MAP"])
        assert "edi2gds.layermap" in d["GDS_LAYER_MAP"]

    def test_klayout_lef_file(self, monkeypatch):
        clean_env(monkeypatch, "gf180")
        cfg = gf180_config.get_config()
        d = cfg.to_dict()
        assert "tech_9t_5LM_1TM.lef" in d["KLAYOUT_LEF_FILE"]

    def test_tie_cell_and_endcap(self, monkeypatch):
        clean_env(monkeypatch, "gf180")
        cfg = gf180_config.get_config()
        d = cfg.to_dict()
        assert d["TIE_CELL"] == "gf180mcu_fd_sc_mcu9t5v0__filltie"
        assert d["ENDCAP_CELL"] == "gf180mcu_fd_sc_mcu9t5v0__endcap"

    def test_max_fanout(self, monkeypatch):
        clean_env(monkeypatch, "gf180")
        cfg = gf180_config.get_config()
        d = cfg.to_dict()
        assert d["MAX_FANOUT"] == "20"


class TestAsap7ExtraVarsFromIntegration:
    """Tests for asap7 variables verified against Make integration output."""

    def test_platform_tcl(self, monkeypatch):
        clean_env(monkeypatch, "asap7")
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert d["PLATFORM_TCL"].endswith("/liberty_suppressions.tcl")

    def test_make_tracks(self, monkeypatch):
        clean_env(monkeypatch, "asap7")
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert d["MAKE_TRACKS"].endswith("/openRoad/make_tracks.tcl")

    def test_set_rc_tcl(self, monkeypatch):
        clean_env(monkeypatch, "asap7")
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert d["SET_RC_TCL"].endswith("/setRC.tcl")

    def test_lib_dir_default(self, monkeypatch):
        clean_env(monkeypatch, "asap7")
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert d["LIB_DIR"].endswith("/lib/NLDM")

    def test_macro_rows_halo(self, monkeypatch):
        clean_env(monkeypatch, "asap7")
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert d["MACRO_ROWS_HALO_X"] == "2"
        assert d["MACRO_ROWS_HALO_Y"] == "2"

    def test_corner_temps_and_voltages(self, monkeypatch):
        clean_env(monkeypatch, "asap7")
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert d["BC_TEMPERATURE"] == "25C"
        assert d["TC_TEMPERATURE"] == "0C"
        assert d["WC_TEMPERATURE"] == "100C"
        assert d["BC_VOLTAGE"] == "0.77"
        assert d["TC_VOLTAGE"] == "0.70"
        assert d["WC_VOLTAGE"] == "0.63"

    def test_synth_minimum_keep_size(self, monkeypatch):
        clean_env(monkeypatch, "asap7")
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert d["SYNTH_MINIMUM_KEEP_SIZE"] == "1000"

    def test_ccs_lib_files_with_bc_additional(self, monkeypatch):
        """BC_CCS_LIB_FILES should include BC_ADDITIONAL_LIBS when set."""
        clean_env(monkeypatch, "asap7", {"BC_ADDITIONAL_LIBS": "/extra/bc.lib"})
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert "/extra/bc.lib" in d["BC_CCS_LIB_FILES"]
        assert "_ccs_" in d["BC_CCS_LIB_FILES"]

    def test_wc_nldm_lib_files(self, monkeypatch):
        clean_env(monkeypatch, "asap7")
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert "_SS_nldm_" in d["WC_NLDM_LIB_FILES"]
        assert "_RVT_" in d["WC_NLDM_LIB_FILES"]

    def test_tc_nldm_lib_files(self, monkeypatch):
        clean_env(monkeypatch, "asap7")
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert "_TT_nldm_" in d["TC_NLDM_LIB_FILES"]
        assert "_RVT_" in d["TC_NLDM_LIB_FILES"]

    def test_wc_corner_lib_files(self, monkeypatch):
        """With CORNER=WC, LIB_FILES should use WC_NLDM_LIB_FILES."""
        clean_env(monkeypatch, "asap7", {"CORNER": "WC"})
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert "_SS_nldm_" in d["LIB_FILES"]

    def test_tc_corner_lib_files(self, monkeypatch):
        """With CORNER=TC, LIB_FILES should use TC_NLDM_LIB_FILES."""
        clean_env(monkeypatch, "asap7", {"CORNER": "TC"})
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert "_TT_nldm_" in d["LIB_FILES"]

    def test_ccs_model_corner_selection(self, monkeypatch):
        """With LIB_MODEL=CCS and CORNER=BC, LIB_FILES should use BC_CCS_LIB_FILES."""
        clean_env(monkeypatch, "asap7", {"LIB_MODEL": "CCS", "CORNER": "BC"})
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert "_ccs_" in d["LIB_FILES"]

    def test_lvt_design_vars(self, monkeypatch):
        """asap7/aes_lvt: ASAP7_USE_VT=LVT should set all primary VT vars to L tag."""
        clean_env(monkeypatch, "asap7", {"ASAP7_USE_VT": "LVT"})
        cfg = asap7_config.get_config()
        d = cfg.to_dict()
        assert "asap7sc7p5t_28_L_1x" in d["SC_LEF"]
        assert "asap7sc7p5t_28_L_" in d["GDS_FILES"]
        assert "TIEHIx1_ASAP7_75t_L" in d["TIEHI_CELL_AND_PORT"]
        assert "BUFx2_ASAP7_75t_L" in d["ABC_DRIVER_CELL"]
        assert "cells_latch_L.v" in d["LATCH_MAP_FILE"]
        assert "TAPCELL_ASAP7_75t_L" in d["TAP_CELL_NAME"]
        assert "FILLERxp5_ASAP7_75t_L" in d["FILL_CELLS"]


class TestIhpExtraVarsFromIntegration:
    """Tests for ihp-sg13g2 variables verified against Make integration output."""

    def test_slow_lib_files(self, monkeypatch):
        clean_env(monkeypatch, "ihp-sg13g2")
        cfg = ihp_config.get_config()
        d = cfg.to_dict()
        assert "slow_1p08V_125C" in d["SLOW_LIB_FILES"]

    def test_fast_lib_files(self, monkeypatch):
        clean_env(monkeypatch, "ihp-sg13g2")
        cfg = ihp_config.get_config()
        d = cfg.to_dict()
        assert "fast_1p32V_m40C" in d["FAST_LIB_FILES"]

    def test_typ_lib_files(self, monkeypatch):
        clean_env(monkeypatch, "ihp-sg13g2")
        cfg = ihp_config.get_config()
        d = cfg.to_dict()
        assert "typ_1p20V_25C" in d["TYP_LIB_FILES"]

    def test_lib_files_defaults_to_typ(self, monkeypatch):
        """LIB_FILES ?= $(TYP_LIB_FILES)"""
        clean_env(monkeypatch, "ihp-sg13g2")
        cfg = ihp_config.get_config()
        d = cfg.to_dict()
        assert "typ_1p20V_25C" in d["LIB_FILES"]

    def test_core_margin(self, monkeypatch):
        clean_env(monkeypatch, "ihp-sg13g2")
        cfg = ihp_config.get_config()
        d = cfg.to_dict()
        assert d["CORE_MARGIN"] == "17.5"

    def test_io_filler_cells(self, monkeypatch):
        clean_env(monkeypatch, "ihp-sg13g2")
        cfg = ihp_config.get_config()
        d = cfg.to_dict()
        assert "sg13g2_Filler10000" in d["IO_FILLER_CELLS"]
        assert "sg13g2_Filler200" in d["IO_FILLER_CELLS"]

    def test_io_bondpad_vars(self, monkeypatch):
        clean_env(monkeypatch, "ihp-sg13g2")
        cfg = ihp_config.get_config()
        d = cfg.to_dict()
        assert d["IO_BONDPAD_SIZE"] == "70"
        assert d["IO_BONDPAD_NAME"] == "bondpad_70x70"
        assert d["IO_LENGTH"] == "180"
        assert d["IO_WIDTH"] == "80"
        assert d["IO_SEALRING_OFFSET"] == "70"

    def test_gds_allow_empty_regex(self, monkeypatch):
        clean_env(monkeypatch, "ihp-sg13g2")
        cfg = ihp_config.get_config()
        d = cfg.to_dict()
        assert "RM_IHPSG13" in d["GDS_ALLOW_EMPTY"]
        assert "CORNER" in d["GDS_ALLOW_EMPTY"]

    def test_footprint_conditional_with_load_disabled(self, monkeypatch):
        """FOOTPRINT_TCL set but LOAD_ADDITIONAL_FILES=0 -> no IO additions."""
        clean_env(
            monkeypatch,
            "ihp-sg13g2",
            {
                "FOOTPRINT_TCL": "/some/file.tcl",
                "LOAD_ADDITIONAL_FILES": "0",
            },
        )
        cfg = ihp_config.get_config()
        d = cfg.to_dict()
        assert "sg13g2_io.lef" not in d.get("ADDITIONAL_LEFS", "")

    def test_slow_lib_with_footprint(self, monkeypatch):
        """FOOTPRINT_TCL set -> SLOW_LIB_FILES includes IO lib."""
        clean_env(monkeypatch, "ihp-sg13g2", {"FOOTPRINT_TCL": "/some/file.tcl"})
        cfg = ihp_config.get_config()
        d = cfg.to_dict()
        assert "sg13g2_io_slow" in d["SLOW_LIB_FILES"]
        assert "sg13g2_stdcell_slow" in d["SLOW_LIB_FILES"]


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


@pytest.mark.integration
class TestMakeIntegration:
    """Run make DESIGN_CONFIG=... clean_all metadata through the shim.

    These tests verify the full config.mk shim -> config.py -> Make pipeline.
    They require Make and the ORFS environment to be set up.
    """

    @pytest.mark.parametrize("platform,design", INTEGRATION_DESIGNS)
    def test_make_metadata(self, platform, design):
        """Run make clean_all metadata and verify it succeeds."""
        design_config = f"designs/{platform}/{design}/config.mk"
        result = subprocess.run(
            ["make", "clean_all", "metadata", f"DESIGN_CONFIG={design_config}"],
            capture_output=True,
            text=True,
            cwd=os.path.abspath(FLOW_DIR),
            timeout=300,
        )
        assert result.returncode == 0, (
            f"make metadata failed for {platform}/{design}:\n"
            f"stdout: {result.stdout[-2000:]}\n"
            f"stderr: {result.stderr[-2000:]}"
        )


if __name__ == "__main__":
    try:
        import pytest

        pytest.main([__file__, "-v", "-m", "not integration"])
    except ImportError:
        print("pytest not installed, skipping tests")
        pass
