#!/usr/bin/env python3
"""The platform DRC and LVS decks run through klayout_drc.py and
klayout_lvs.py, as `make drc` and `make lvs` run them, on a few standard
cells from the platform's own library.

DRC: the cells abutted in a row, and a metal1 sliver that breaks the
width rule, so a deck that checks nothing does not pass. The rule count
and the violation count per category are the stored ones. A change to a
deck, to klayout_drc.py or to the klayout module that changes a count
shows here; update the count when the change is intended.

LVS: a standard cell's layout matches its CDL subcircuit.

Runs on the klayout Python module, and is skipped without it.
"""

import os
import subprocess
import sys
import tempfile
import unittest

try:
    import klayout.db as db
    import klayout.rdb as rdb
except ImportError:
    db = None

FLOW = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
PLATFORMS = os.path.join(FLOW, "platforms")
UTIL = os.path.join(FLOW, "util")


def platform(*path):
    return os.path.join(PLATFORMS, *path)


def write_row(lib_gds, cells, sliver, out_gds):
    """The cells, abutted in a row in a new top cell, and below them a
    sliver, a 10 nm wide box that breaks the layer's width rule; the
    library's other cells are dropped."""
    layout = db.Layout()
    layout.read(lib_gds)
    top = layout.create_cell("SMOKE")
    layer, datatype = sliver
    top.shapes(layout.layer(layer, datatype)).insert(
        db.DBox(0, -5, 0.01, -4).to_itype(layout.dbu)
    )
    x = 0
    for name in cells:
        cell = layout.cell(name)
        box = cell.bbox()
        top.insert(
            db.CellInstArray(cell.cell_index(), db.Trans(db.Vector(x - box.left, 0)))
        )
        x += box.width()
    for index in list(layout.each_top_cell()):
        if index != top.cell_index():
            layout.prune_cell(index, -1)
    layout.write(out_gds)


def write_cell(lib_gds, cell_name, out_gds):
    """The cell alone, as the top cell."""
    layout = db.Layout()
    layout.read(lib_gds)
    keep = layout.cell(cell_name).cell_index()
    for index in list(layout.each_top_cell()):
        if index != keep:
            layout.prune_cell(index, -1)
    layout.write(out_gds)


def run(script, args):
    return subprocess.run(
        [sys.executable, os.path.join(UTIL, script)] + args,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        universal_newlines=True,
    )


# platform: deck, library, cells, sliver layer, rule categories, violations
DRC = {
    "asap7": (
        platform("asap7", "drc", "asap7_drc.py"),
        platform("asap7", "gds", "asap7sc7p5t_28_R_220121a.gds"),
        ["INVx1_ASAP7_75t_R", "NAND2x1p5_ASAP7_75t_R", "DFFHQNx2_ASAP7_75t_R"],
        (19, 0),
        258,
        {
            "WELL.S.2": 4,
            "GATE.S.1": 2,
            "ACTIVE.LUP.1": 2,
            "LIG.S.4-5": 1,
            "M1.W.1": 1,
            "V1.S.4": 1,
        },
    ),
    "nangate45": (
        platform("nangate45", "drc", "FreePDK45_drc.py"),
        platform("nangate45", "gds", "NangateOpenCellLibrary.gds"),
        ["INV_X1", "NAND2_X1", "DFF_X1"],
        (11, 0),
        129,
        {
            "METAL1.1": 1,
        },
    ),
    "sky130hd": (
        platform("sky130hd", "drc", "sky130hd_drc.py"),
        platform("sky130hd", "gds", "sky130_fd_sc_hd.gds"),
        [
            "sky130_fd_sc_hd__inv_1",
            "sky130_fd_sc_hd__nand2_1",
            "sky130_fd_sc_hd__dfxtp_1",
        ],
        (68, 20),
        145,
        {
            "m1.1": 1,
            "m1.6": 1,
        },
    ),
    "ihp-sg13g2": (
        platform("ihp-sg13g2", "drc", "sg13g2_minimal_drc.py"),
        platform("ihp-sg13g2", "gds", "sg13g2_stdcell.gds"),
        ["sg13g2_inv_1", "sg13g2_nand2_1", "sg13g2_dfrbp_1"],
        (8, 0),
        77,
        {
            "AFil.g/g1": 1,
            "AFil.g2/g3": 1,
            "GFil.g": 1,
            "M1.a": 1,
            "M1.j/k": 1,
            "M2.j/k": 1,
            "M3.j/k": 1,
            "M4.j/k": 1,
            "M5.j/k": 1,
            "M1Fil.h/k": 1,
            "M2Fil.h/k": 1,
            "M3Fil.h/k": 1,
            "M4Fil.h/k": 1,
            "M5Fil.h/k": 1,
            "TM1.c/d": 1,
            "TM2.c/d": 1,
        },
    ),
}

# platform: deck, library, CDL, cell
LVS = {
    "sky130hd": (
        platform("sky130hd", "lvs", "sky130hd_lvs.py"),
        platform("sky130hd", "gds", "sky130_fd_sc_hd.gds"),
        platform("sky130hd", "cdl", "sky130hd.cdl"),
        "sky130_fd_sc_hd__inv_1",
    ),
    "ihp-sg13g2": (
        platform("ihp-sg13g2", "lvs", "sg13g2_lvs.py"),
        platform("ihp-sg13g2", "gds", "sg13g2_stdcell.gds"),
        platform("ihp-sg13g2", "cdl", "sg13g2_stdcell.cdl"),
        "sg13g2_inv_1",
    ),
}


@unittest.skipIf(db is None, "the klayout Python module is not installed")
class TestKlayoutDecks(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()

    def tearDown(self):
        self.tmp.cleanup()

    def drc_counts(self, name):
        deck, lib_gds, cells, sliver, _, _ = DRC[name]
        gds = os.path.join(self.tmp.name, "in.gds")
        report = os.path.join(self.tmp.name, "out.lyrdb")
        write_row(lib_gds, cells, sliver, gds)
        result = run(
            "klayout_drc.py",
            ["--deck=" + deck, "--in-gds=" + gds, "--report-file=" + report],
        )
        self.assertEqual(result.returncode, 0, result.stdout)
        database = rdb.ReportDatabase("")
        database.load(report)
        categories = 0
        counts = {}
        for category in database.each_category():
            categories += 1
            if category.num_items() > 0:
                counts[category.name()] = category.num_items()
        return categories, counts

    def check_drc(self, name):
        categories, counts = self.drc_counts(name)
        self.assertEqual(categories, DRC[name][4])
        self.assertEqual(counts, DRC[name][5])

    def test_drc_asap7(self):
        self.check_drc("asap7")

    def test_drc_nangate45(self):
        self.check_drc("nangate45")

    def test_drc_sky130hd(self):
        self.check_drc("sky130hd")

    def test_drc_ihp_sg13g2(self):
        self.check_drc("ihp-sg13g2")

    def check_lvs(self, name):
        deck, lib_gds, cdl, cell = LVS[name]
        gds = os.path.join(self.tmp.name, "in.gds")
        report = os.path.join(self.tmp.name, "out.lvsdb")
        write_cell(lib_gds, cell, gds)
        result = run(
            "klayout_lvs.py",
            [
                "--deck=" + deck,
                "--in-gds=" + gds,
                "--cdl-file=" + cdl,
                "--top-cell=" + cell,
                "--report-file=" + report,
            ],
        )
        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertIn("Netlists match", result.stdout)

    def test_lvs_sky130hd(self):
        self.check_lvs("sky130hd")

    def test_lvs_ihp_sg13g2(self):
        self.check_lvs("ihp-sg13g2")


if __name__ == "__main__":
    unittest.main()
