#!/usr/bin/env python3
"""klayout_drc.py: each check flags the shapes that break it, and only those.

Runs on the klayout Python module, and is skipped without it.
"""

import os
import sys
import tempfile
import unittest

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "../util"))

try:
    import klayout.db as db
except ImportError:
    db = None

import klayout_drc
from klayout_drc import nm, projection, um


def write_gds(path, boxes):
    """boxes: (layer, datatype, x1, y1, x2, y2) in microns, in a hierarchy of
    a top cell and one child cell placed twice."""
    layout = db.Layout()
    layout.dbu = 0.001
    top = layout.create_cell("TOP")
    child = layout.create_cell("CHILD")
    for layer, datatype, x1, y1, x2, y2 in boxes:
        li = layout.layer(layer, datatype)
        top.shapes(li).insert(db.DBox(x1, y1, x2, y2))
    li = layout.layer(1, 0)
    child.shapes(li).insert(db.DBox(0, 0, 0.05, 1))  # narrow: one violation
    top.insert(db.DCellInstArray(child.cell_index(), db.DTrans(db.DVector(100, 0))))
    top.insert(db.DCellInstArray(child.cell_index(), db.DTrans(db.DVector(200, 0))))
    layout.write(path)


@unittest.skipIf(db is None, "the klayout Python module is not installed")
class TestKlayoutDrc(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.gds = os.path.join(self.tmp.name, "in.gds")
        self.rdb = os.path.join(self.tmp.name, "out.lyrdb")
        write_gds(
            self.gds,
            [
                (1, 0, 0, 0, 0.08, 1),  # width 80 nm
                (1, 0, 1, 0, 1.2, 1),  # clean
                (1, 0, 1.25, 0, 1.45, 1),  # 50 nm from the one above
                (2, 0, 3, 0, 3.1, 0.1),  # via
                (1, 0, 2.99, -0.01, 3.11, 0.11),  # 10 nm enclosure
                (2, 0, 4, 0, 4.1, 0.1),  # via
                (1, 0, 3.9, -0.1, 4.2, 0.2),  # 100 nm enclosure
            ],
        )

    def tearDown(self):
        self.tmp.cleanup()

    def run_deck(self, body, mode="deep"):
        deck = klayout_drc.Deck(self.gds, self.rdb, "test", mode=mode)
        body(deck)
        deck.write()
        counts = {}
        for name, cat in deck.categories.items():
            counts[name] = cat.num_items()
        return counts

    def test_width_space_enclosing(self):
        def body(deck):
            m1 = deck.input(1, 0)
            via = deck.input(2, 0)
            m1.width(nm(100), projection).output("W", "width")
            m1.space(nm(100), projection).output("S", "space")
            m1.enclosing(via, nm(50), projection).output("E", "enclosure")

        counts = self.run_deck(body)
        # The child cell's narrow shape is reported once, in the child.
        self.assertEqual(counts, {"W": 2, "S": 1, "E": 4})

    def test_flat_reports_each_instance(self):
        def body(deck):
            deck.input(1, 0).width(nm(100), projection).output("W")

        self.assertEqual(self.run_deck(body, mode="flat"), {"W": 3})

    def test_universal_not_equal(self):
        def body(deck):
            m1 = deck.input(1, 0)
            m1.drc(klayout_drc.width(projection) != nm(200)).with_angle(90).output("X")

        # Every edge of a shape that is not 200 nm wide, both sides: the
        # 80 nm, 50 nm (twice in the child) and 300 nm wide shapes.
        counts = self.run_deck(body)
        self.assertGreater(counts["X"], 0)

    def test_area_and_units(self):
        def body(deck):
            self.assertEqual(deck.v(nm(80)), 80)
            self.assertEqual(deck.v(um(1)), 1000)
            self.assertEqual(deck.area(0.5), 500000)
            deck.input(1, 0).with_area(0, 0.1).output("A")

        # 0.08, 0.0144 and 0.09 um2 in the top cell, 0.05 um2 once in the child
        self.assertEqual(self.run_deck(body), {"A": 4})


if __name__ == "__main__":
    unittest.main()
