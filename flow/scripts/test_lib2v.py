"""Tests for lib2v.py - Liberty to behavioral Verilog generator."""

import os
import textwrap
import unittest
from pathlib import Path

try:
    from lib2v import (
        Cell,
        FFInfo,
        LatchInfo,
        BundleInfo,
        Pin,
        generate_verilog,
        generate_empty_module,
        liberty_to_verilog,
        parse_lib,
        parse_lef_physical_only,
    )
except ModuleNotFoundError:
    from flow.scripts.lib2v import (
        Cell,
        FFInfo,
        LatchInfo,
        BundleInfo,
        Pin,
        generate_verilog,
        generate_empty_module,
        liberty_to_verilog,
        parse_lib,
        parse_lef_physical_only,
    )


class TestLibertyToVerilog(unittest.TestCase):
    """Test liberty expression to verilog conversion."""

    def test_and(self):
        self.assertEqual(liberty_to_verilog("(A * B)"), "(A & B)")

    def test_or(self):
        self.assertEqual(liberty_to_verilog("(A) + (B)"), "(A) | (B)")

    def test_not(self):
        self.assertEqual(liberty_to_verilog("!A"), "~A")

    def test_complex_ao(self):
        self.assertEqual(
            liberty_to_verilog("(A1 * A2) + (B)"),
            "(A1 & A2) | (B)",
        )

    def test_complex_nand(self):
        self.assertEqual(
            liberty_to_verilog("(!A * !B)"),
            "(~A & ~B)",
        )

    def test_xor(self):
        self.assertEqual(
            liberty_to_verilog("(A * !B) + (!A * B)"),
            "(A & ~B) | (~A & B)",
        )

    def test_ampersand_passthrough(self):
        """Liberty state_function uses & directly."""
        self.assertEqual(liberty_to_verilog("CLK & IQ"), "CLK & IQ")

    def test_constant_zero(self):
        self.assertEqual(liberty_to_verilog("0"), "0")

    def test_constant_one(self):
        self.assertEqual(liberty_to_verilog("1"), "1")


class TestParseLib(unittest.TestCase):
    """Test liberty file parsing."""

    def test_combinational_cell(self):
        lib = textwrap.dedent("""\
            library (test) {
              cell (AND2x1_TEST) {
                pin (Y) {
                  direction : output;
                  function : "(A * B)";
                }
                pin (A) {
                  direction : input;
                }
                pin (B) {
                  direction : input;
                }
              }
            }
        """)
        cells = parse_lib(lib)
        self.assertEqual(len(cells), 1)
        c = cells[0]
        self.assertEqual(c.name, "AND2x1_TEST")
        self.assertIn("Y", c.pins)
        self.assertEqual(c.pins["Y"].direction, "output")
        self.assertEqual(c.pins["Y"].function, "(A * B)")
        self.assertIn("A", c.pins)
        self.assertIn("B", c.pins)
        self.assertIsNone(c.ff)
        self.assertIsNone(c.latch)

    def test_ff_cell(self):
        lib = textwrap.dedent("""\
            library (test) {
              cell (DFFHQNx1_TEST) {
                ff (IQN,IQNN) {
                  clocked_on : "CLK";
                  next_state : "!D";
                }
                pin (QN) {
                  direction : output;
                  function : "IQN";
                }
                pin (CLK) {
                  direction : input;
                }
                pin (D) {
                  direction : input;
                }
              }
            }
        """)
        cells = parse_lib(lib)
        self.assertEqual(len(cells), 1)
        c = cells[0]
        self.assertEqual(c.name, "DFFHQNx1_TEST")
        self.assertIsNotNone(c.ff)
        self.assertEqual(c.ff.var1, "IQN")
        self.assertEqual(c.ff.var2, "IQNN")
        self.assertEqual(c.ff.clocked_on, "CLK")
        self.assertEqual(c.ff.next_state, "!D")
        self.assertEqual(c.ff.clear, "")
        self.assertEqual(c.ff.preset, "")

    def test_ff_with_async(self):
        lib = textwrap.dedent("""\
            library (test) {
              cell (DFFASRx1_TEST) {
                ff (IQN,IQNN) {
                  clocked_on : "CLK";
                  next_state : "!D";
                  clear : "!SETN";
                  preset : "!RESETN";
                }
                pin (QN) {
                  direction : output;
                  function : "IQN";
                }
                pin (CLK) {
                  direction : input;
                }
                pin (D) {
                  direction : input;
                }
                pin (RESETN) {
                  direction : input;
                }
                pin (SETN) {
                  direction : input;
                }
              }
            }
        """)
        cells = parse_lib(lib)
        c = cells[0]
        self.assertEqual(c.ff.clear, "!SETN")
        self.assertEqual(c.ff.preset, "!RESETN")

    def test_falling_edge_ff(self):
        lib = textwrap.dedent("""\
            library (test) {
              cell (DFFLQNx1_TEST) {
                ff (IQN,IQNN) {
                  clocked_on : "!CLK";
                  next_state : "!D";
                }
                pin (QN) {
                  direction : output;
                  function : "IQN";
                }
                pin (CLK) {
                  direction : input;
                }
                pin (D) {
                  direction : input;
                }
              }
            }
        """)
        cells = parse_lib(lib)
        c = cells[0]
        self.assertEqual(c.ff.clocked_on, "!CLK")

    def test_latch_cell(self):
        lib = textwrap.dedent("""\
            library (test) {
              cell (DHLx1_TEST) {
                latch (IQ,IQN) {
                  enable : "CLK";
                  data_in : "D";
                }
                pin (Q) {
                  direction : output;
                  function : "IQ";
                }
                pin (CLK) {
                  direction : input;
                }
                pin (D) {
                  direction : input;
                }
              }
            }
        """)
        cells = parse_lib(lib)
        c = cells[0]
        self.assertIsNotNone(c.latch)
        self.assertEqual(c.latch.var1, "IQ")
        self.assertEqual(c.latch.enable, "CLK")
        self.assertEqual(c.latch.data_in, "D")

    def test_ff_bank(self):
        lib = textwrap.dedent("""\
            library (test) {
              cell (DFFV2Xx1_TEST) {
                pin (CLK) {
                  clock : true;
                  direction : input;
                }
                ff_bank (IQN, IQNN, 2) {
                  clocked_on : "CLK";
                  next_state : "!D";
                }
                bundle (D) {
                  members (D0, D1);
                  direction : input;
                  pin (D0) {
                  }
                  pin (D1) {
                  }
                }
                bundle (QN) {
                  members (QN0, QN1);
                  direction : output;
                  function : "IQN";
                  pin (QN0) {
                  }
                  pin (QN1) {
                  }
                }
              }
            }
        """)
        cells = parse_lib(lib)
        c = cells[0]
        self.assertIsNotNone(c.ff)
        self.assertEqual(c.ff.var1, "IQN")
        self.assertEqual(c.ff.clocked_on, "CLK")
        self.assertEqual(c.ff.next_state, "!D")
        self.assertEqual(len(c.bundles), 2)

    def test_icg_cell(self):
        lib = textwrap.dedent("""\
            library (test) {
              cell (ICGx1_TEST) {
                clock_gating_integrated_cell : latch_posedge_precontrol;
                pin (IQ) {
                  direction : internal;
                }
                pin (GCLK) {
                  direction : output;
                  state_function : "CLK & IQ";
                }
                pin (CLK) {
                  clock : true;
                  direction : input;
                }
                pin (ENA) {
                  clock_gate_enable_pin : true;
                  direction : input;
                }
                pin (SE) {
                  direction : input;
                }
              }
            }
        """)
        cells = parse_lib(lib)
        c = cells[0]
        self.assertEqual(c.clock_gating, "latch_posedge_precontrol")
        self.assertIn("IQ", c.pins)
        self.assertEqual(c.pins["IQ"].direction, "internal")
        self.assertTrue(c.pins["CLK"].clock)
        self.assertTrue(c.pins["ENA"].clock_gate_enable_pin)

    def test_multiple_cells(self):
        lib = textwrap.dedent("""\
            library (test) {
              cell (A) {
                pin (Y) { direction : output; function : "X"; }
                pin (X) { direction : input; }
              }
              cell (B) {
                pin (Y) { direction : output; function : "X"; }
                pin (X) { direction : input; }
              }
            }
        """)
        cells = parse_lib(lib)
        self.assertEqual(len(cells), 2)
        self.assertEqual(cells[0].name, "A")
        self.assertEqual(cells[1].name, "B")

    def test_power_down_function_ignored(self):
        """power_down_function should not be captured as pin function."""
        lib = textwrap.dedent("""\
            library (test) {
              cell (BUFx1_TEST) {
                pin (Y) {
                  direction : output;
                  function : "A";
                  power_down_function : "(!VDD) + (VSS)";
                }
                pin (A) {
                  direction : input;
                }
              }
            }
        """)
        cells = parse_lib(lib)
        self.assertEqual(cells[0].pins["Y"].function, "A")


class TestGenerateVerilog(unittest.TestCase):
    """Test verilog generation for different cell types."""

    def test_combinational(self):
        cell = Cell(name="AND2x1_TEST")
        cell.pins["Y"] = Pin(name="Y", direction="output", function="(A * B)")
        cell.pins["A"] = Pin(name="A", direction="input")
        cell.pins["B"] = Pin(name="B", direction="input")
        v = generate_verilog(cell)
        self.assertIn("module AND2x1_TEST", v)
        self.assertIn("assign Y = (A & B);", v)
        self.assertIn("output Y;", v)
        self.assertIn("input A, B;", v)
        self.assertIn("endmodule", v)

    def test_dff_posedge(self):
        cell = Cell(name="DFFHQNx1_TEST")
        cell.ff = FFInfo(var1="IQN", var2="IQNN", clocked_on="CLK", next_state="!D")
        cell.pins["QN"] = Pin(name="QN", direction="output", function="IQN")
        cell.pins["CLK"] = Pin(name="CLK", direction="input")
        cell.pins["D"] = Pin(name="D", direction="input")
        v = generate_verilog(cell)
        self.assertIn("always @(posedge CLK)", v)
        self.assertIn("IQN <= ~D;", v)
        self.assertIn("assign QN = IQN;", v)

    def test_dff_negedge(self):
        cell = Cell(name="DFFLQNx1_TEST")
        cell.ff = FFInfo(var1="IQN", var2="IQNN", clocked_on="!CLK", next_state="!D")
        cell.pins["QN"] = Pin(name="QN", direction="output", function="IQN")
        cell.pins["CLK"] = Pin(name="CLK", direction="input")
        cell.pins["D"] = Pin(name="D", direction="input")
        v = generate_verilog(cell)
        self.assertIn("always @(negedge CLK)", v)

    def test_dff_non_inverting(self):
        cell = Cell(name="DFFHQx4_TEST")
        cell.ff = FFInfo(var1="IQ", var2="IQN", clocked_on="CLK", next_state="D")
        cell.pins["Q"] = Pin(name="Q", direction="output", function="IQ")
        cell.pins["CLK"] = Pin(name="CLK", direction="input")
        cell.pins["D"] = Pin(name="D", direction="input")
        v = generate_verilog(cell)
        self.assertIn("IQ <= D;", v)
        self.assertIn("assign Q = IQ;", v)

    def test_dff_async_clear_preset(self):
        cell = Cell(name="DFFASRx1_TEST")
        cell.ff = FFInfo(
            var1="IQN", var2="IQNN",
            clocked_on="CLK", next_state="!D",
            clear="!SETN", preset="!RESETN",
        )
        cell.pins["QN"] = Pin(name="QN", direction="output", function="IQN")
        cell.pins["CLK"] = Pin(name="CLK", direction="input")
        cell.pins["D"] = Pin(name="D", direction="input")
        cell.pins["RESETN"] = Pin(name="RESETN", direction="input")
        cell.pins["SETN"] = Pin(name="SETN", direction="input")
        v = generate_verilog(cell)
        self.assertIn("negedge SETN", v)
        self.assertIn("negedge RESETN", v)
        self.assertIn("if (~SETN)", v)
        self.assertIn("IQN <= 1'b0;", v)
        self.assertIn("else if (~RESETN)", v)
        self.assertIn("IQN <= 1'b1;", v)

    def test_latch(self):
        cell = Cell(name="DHLx1_TEST")
        cell.latch = LatchInfo(var1="IQ", var2="IQN", enable="CLK", data_in="D")
        cell.pins["Q"] = Pin(name="Q", direction="output", function="IQ")
        cell.pins["CLK"] = Pin(name="CLK", direction="input")
        cell.pins["D"] = Pin(name="D", direction="input")
        v = generate_verilog(cell)
        self.assertIn("always @*", v)
        self.assertIn("if (CLK)", v)
        self.assertIn("IQ = D;", v)
        self.assertIn("assign Q = IQ;", v)

    def test_latch_neg_enable(self):
        cell = Cell(name="DLLx1_TEST")
        cell.latch = LatchInfo(var1="IQ", var2="IQN", enable="!CLK", data_in="D")
        cell.pins["Q"] = Pin(name="Q", direction="output", function="IQ")
        cell.pins["CLK"] = Pin(name="CLK", direction="input")
        cell.pins["D"] = Pin(name="D", direction="input")
        v = generate_verilog(cell)
        self.assertIn("if (~CLK)", v)

    def test_icg(self):
        cell = Cell(name="ICGx1_TEST")
        cell.clock_gating = "latch_posedge_precontrol"
        cell.pins["GCLK"] = Pin(name="GCLK", direction="output", state_function="CLK & IQ")
        cell.pins["CLK"] = Pin(name="CLK", direction="input", clock=True)
        cell.pins["ENA"] = Pin(name="ENA", direction="input", clock_gate_enable_pin=True)
        cell.pins["SE"] = Pin(name="SE", direction="input")
        cell.pins["IQ"] = Pin(name="IQ", direction="internal")
        v = generate_verilog(cell)
        self.assertIn("reg IQ;", v)
        self.assertIn("if (~CLK)", v)
        self.assertIn("IQ = ENA | SE;", v)
        self.assertIn("assign GCLK = CLK & IQ;", v)

    def test_bundle_dff(self):
        cell = Cell(name="DFFV2Xx1_TEST")
        cell.ff = FFInfo(var1="IQN", var2="IQNN", clocked_on="CLK", next_state="!D")
        cell.pins["CLK"] = Pin(name="CLK", direction="input")
        cell.bundles = [
            BundleInfo(name="D", members=["D0", "D1"], direction="input"),
            BundleInfo(name="QN", members=["QN0", "QN1"], direction="output", function="IQN"),
        ]
        v = generate_verilog(cell)
        self.assertIn("output reg QN0, QN1;", v)
        self.assertIn("input CLK, D0, D1;", v)
        self.assertIn("QN0 <= ~D0;", v)
        self.assertIn("QN1 <= ~D1;", v)

    def test_bundle_dff_4bit(self):
        cell = Cell(name="DFFV4Xx1_TEST")
        cell.ff = FFInfo(var1="IQN", var2="IQNN", clocked_on="CLK", next_state="!D")
        cell.pins["CLK"] = Pin(name="CLK", direction="input")
        cell.bundles = [
            BundleInfo(name="D", members=["D0", "D1", "D2", "D3"], direction="input"),
            BundleInfo(name="QN", members=["QN0", "QN1", "QN2", "QN3"], direction="output", function="IQN"),
        ]
        v = generate_verilog(cell)
        self.assertIn("QN0 <= ~D0;", v)
        self.assertIn("QN3 <= ~D3;", v)

    def test_scan_dff(self):
        cell = Cell(name="SDFHx1_TEST")
        cell.ff = FFInfo(
            var1="IQN", var2="IQNN",
            clocked_on="CLK",
            next_state="(!D * !SE) + (!D * !SI) + (SE * !SI)",
        )
        cell.pins["QN"] = Pin(name="QN", direction="output", function="IQN")
        cell.pins["CLK"] = Pin(name="CLK", direction="input")
        cell.pins["D"] = Pin(name="D", direction="input")
        cell.pins["SE"] = Pin(name="SE", direction="input")
        cell.pins["SI"] = Pin(name="SI", direction="input")
        v = generate_verilog(cell)
        self.assertIn("(~D & ~SE) | (~D & ~SI) | (SE & ~SI)", v)

    def test_empty_module(self):
        v = generate_empty_module("TAPCELL_TEST")
        self.assertEqual(v, "module TAPCELL_TEST;\nendmodule")


class TestParseLef(unittest.TestCase):
    """Test LEF parsing for physical-only cells."""

    def test_physical_only_detection(self, tmp_path=None):
        """Physical-only cells have no SIGNAL pins."""
        import tempfile
        with tempfile.NamedTemporaryFile(mode="w", suffix=".lef", delete=False) as f:
            f.write(textwrap.dedent("""\
                MACRO TAPCELL_TEST
                  CLASS CORE WELLTAP ;
                  PIN VDD
                    DIRECTION INOUT ;
                    USE POWER ;
                  END VDD
                  PIN VSS
                    DIRECTION INOUT ;
                    USE GROUND ;
                  END VSS
                END TAPCELL_TEST

                MACRO AND2_TEST
                  CLASS CORE ;
                  PIN A
                    DIRECTION INPUT ;
                    USE SIGNAL ;
                  END A
                  PIN Y
                    DIRECTION OUTPUT ;
                    USE SIGNAL ;
                  END Y
                END AND2_TEST
            """))
            f.flush()
            names = parse_lef_physical_only(Path(f.name))
        os.unlink(f.name)
        self.assertEqual(names, ["TAPCELL_TEST"])


def _find_platform_dir():
    """Find the ASAP7 platform directory, works in Bazel runfiles and locally."""
    # Try relative to this file (local execution)
    local = Path(__file__).parent / "../platforms/asap7"
    if local.exists():
        return local
    # Try Bazel runfiles
    runfiles = Path(os.environ.get("TEST_SRCDIR", "")) / os.environ.get("TEST_WORKSPACE", "")
    bazel = runfiles / "flow/platforms/asap7"
    if bazel.exists():
        return bazel
    return None


class TestEndToEnd(unittest.TestCase):
    """End-to-end tests on actual ASAP7 lib files if available."""

    @classmethod
    def setUpClass(cls):
        platform = _find_platform_dir()
        if platform:
            cls.LIB_DIR = platform / "lib/NLDM"
            cls.LEF_DIR = platform / "lef"
        else:
            cls.LIB_DIR = None
            cls.LEF_DIR = None

    def _lib(self, name):
        if not self.LIB_DIR:
            self.skipTest("ASAP7 platform not found")
        p = self.LIB_DIR / name
        if not p.exists():
            self.skipTest(f"{name} not found")
        return p

    def test_seq_rvt_dff_count(self):
        """SEQ RVT should produce DFF, latch, ICG, and scan modules."""
        try:
            from lib2v import read_lib
        except ModuleNotFoundError:
            from flow.scripts.lib2v import read_lib
        content = read_lib(self._lib("asap7sc7p5t_SEQ_RVT_TT_nldm_220123.lib"))
        cells = parse_lib(content)
        names = [c.name for c in cells]
        self.assertIn("DFFHQNx1_ASAP7_75t_R", names)
        self.assertIn("DFFASRHQNx1_ASAP7_75t_R", names)
        self.assertIn("DHLx1_ASAP7_75t_R", names)
        self.assertIn("ICGx1_ASAP7_75t_R", names)
        self.assertIn("SDFHx1_ASAP7_75t_R", names)

    def test_seq_lvt_cell_suffix(self):
        """LVT cells should have _L suffix."""
        try:
            from lib2v import read_lib
        except ModuleNotFoundError:
            from flow.scripts.lib2v import read_lib
        content = read_lib(self._lib("asap7sc7p5t_SEQ_LVT_TT_nldm_220123.lib"))
        cells = parse_lib(content)
        for c in cells:
            self.assertTrue(c.name.endswith("_L"), f"{c.name} doesn't end with _L")

    def test_seq_slvt_cell_suffix(self):
        """SLVT cells should have _SL suffix."""
        try:
            from lib2v import read_lib
        except ModuleNotFoundError:
            from flow.scripts.lib2v import read_lib
        content = read_lib(self._lib("asap7sc7p5t_SEQ_SLVT_TT_nldm_220123.lib"))
        cells = parse_lib(content)
        for c in cells:
            self.assertTrue(c.name.endswith("_SL"), f"{c.name} doesn't end with _SL")

    def test_simple_rvt_combinational(self):
        """SIMPLE RVT should produce combinational cells."""
        try:
            from lib2v import read_lib
        except ModuleNotFoundError:
            from flow.scripts.lib2v import read_lib
        content = read_lib(self._lib("asap7sc7p5t_SIMPLE_RVT_TT_nldm_211120.lib.gz"))
        cells = parse_lib(content)
        names = [c.name for c in cells]
        self.assertIn("AND2x2_ASAP7_75t_R", names)
        # All should be combinational (no ff/latch)
        for c in cells:
            self.assertIsNone(c.ff, f"{c.name} has unexpected ff group")
            self.assertIsNone(c.latch, f"{c.name} has unexpected latch group")

    def test_fake_v2x_bundle(self):
        """FAKE V2X should parse ff_bank and bundles."""
        try:
            from lib2v import read_lib
        except ModuleNotFoundError:
            from flow.scripts.lib2v import read_lib
        content = read_lib(self._lib("asap7sc7p5t_DFFHQNV2X_RVT_TT_nldm_FAKE.lib"))
        cells = parse_lib(content)
        self.assertTrue(len(cells) > 0)
        c = cells[0]
        self.assertIsNotNone(c.ff)
        self.assertEqual(len(c.bundles), 2)
        v = generate_verilog(c)
        self.assertIn("QN0 <= ~D0;", v)

    def test_physical_only_from_lef(self):
        """LEF scan should find TAPCELL/FILLER/DECAP cells."""
        if not self.LEF_DIR or not self.LEF_DIR.exists():
            self.skipTest("LEF dir not found")
        try:
            from lib2v import find_physical_only_cells
        except ModuleNotFoundError:
            from flow.scripts.lib2v import find_physical_only_cells
        physical = find_physical_only_cells(self.LEF_DIR, set())
        phy_names = [n for n in physical if "TAPCELL" in n or "FILLER" in n or "DECAP" in n]
        self.assertTrue(len(phy_names) > 0, "No physical-only cells found")
        # Should include all Vt variants
        suffixes = set()
        for n in phy_names:
            for suffix in ["_R", "_L", "_SL", "_SRAM"]:
                if n.endswith(suffix):
                    suffixes.add(suffix)
        self.assertIn("_R", suffixes)
        self.assertIn("_L", suffixes)


if __name__ == "__main__":
    unittest.main()
