#!/usr/bin/env python3
"""wrap_parent.py on a parent with two tiles: ports per tile pin, ties
inside the parent, nets between tiles left at the top."""

import os
import sys
import unittest

sys.path.append(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "util"))

import wrap_parent  # noqa: E402

TILE = {
    "ports": {
        "clk": {"direction": "input", "bits": [2]},
        "a": {"direction": "input", "bits": [3, 4]},
        "z": {"direction": "output", "bits": [5, 6]},
    },
    "cells": {},
    "netnames": {},
}


def design():
    # top: port x (bits 2, 3) feeds a parent cell r driving net 10; tile
    # t0 reads clk and net 10 / a constant; t1 reads t0's output alone
    return {
        "modules": {
            "top": {
                "ports": {
                    "clk": {"direction": "input", "bits": [2]},
                    "x": {"direction": "input", "bits": [3]},
                    "y": {"direction": "output", "bits": [21]},
                },
                "cells": {
                    "r": {
                        "type": "$not",
                        "port_directions": {"A": "input", "Y": "output"},
                        "connections": {"A": [3], "Y": [10]},
                    },
                    "s": {
                        "type": "$not",
                        "port_directions": {"A": "input", "Y": "output"},
                        "connections": {"A": [13], "Y": [21]},
                    },
                    "u_b0_0": {
                        "type": "tile",
                        "connections": {"clk": [2], "a": [10, "0"], "z": [11, 12]},
                    },
                    "u_b0_1": {
                        "type": "tile",
                        "connections": {"clk": [2], "a": [11, 12], "z": [13, 14]},
                    },
                },
                "netnames": {
                    "clk": {"bits": [2]},
                    "x": {"bits": [3]},
                    "y": {"bits": [21]},
                },
            },
            "tile": TILE,
        }
    }


class WrapParent(unittest.TestCase):
    def setUp(self):
        self.d = wrap_parent.wrap(design(), "top", "rest")
        self.top = self.d["modules"]["top"]
        self.rest = self.d["modules"]["rest"]

    def test_top_is_instances_only(self):
        self.assertEqual(sorted(self.top["cells"]), ["u_b0_0", "u_b0_1", "u_rest"])
        types = {c["type"] for c in self.top["cells"].values()}
        self.assertEqual(types, {"tile", "rest"})

    def test_parent_cells_and_ports(self):
        self.assertIn("r", self.rest["cells"])
        self.assertIn("s", self.rest["cells"])
        for p in ["clk", "x", "y"]:
            self.assertIn(p, self.rest["ports"])

    def test_a_port_per_tile_pin(self):
        ports = self.rest["ports"]
        # both tiles' clocks get a port each, so each sits on its tile
        self.assertEqual(ports["u_b0_0__clk"]["direction"], "output")
        self.assertEqual(ports["u_b0_1__clk"]["direction"], "output")
        self.assertEqual(ports["u_b0_0__clk"]["bits"], [2])
        # t1's output goes to the parent's cell s
        self.assertEqual(ports["u_b0_1__z"]["direction"], "input")
        self.assertEqual(ports["u_b0_1__z"]["bits"], [13])

    def test_constant_tied_inside(self):
        a = self.rest["ports"]["u_b0_0__a"]["bits"]
        self.assertEqual(a[0], 10)
        ties = [c for c in self.rest["cells"].values() if c["type"] == "$pos"]
        self.assertEqual(len(ties), 1)
        self.assertEqual(ties[0]["connections"]["A"], ["0"])
        self.assertEqual(ties[0]["connections"]["Y"], [a[1]])

    def test_tile_to_tile_stays_at_top(self):
        t0 = self.top["cells"]["u_b0_0"]["connections"]
        t1 = self.top["cells"]["u_b0_1"]["connections"]
        self.assertEqual(t0["z"], [11, 12])
        self.assertEqual(t1["a"], [11, 12])
        self.assertNotIn("u_b0_0__z", self.rest["ports"])
        self.assertNotIn("u_b0_1__a", self.rest["ports"])

    def test_parent_instance_meets_tiles(self):
        rest = self.top["cells"]["u_rest"]["connections"]
        t0 = self.top["cells"]["u_b0_0"]["connections"]
        self.assertEqual(rest["u_b0_0__clk"], t0["clk"])
        self.assertEqual(rest["u_b0_0__a"], t0["a"])
        self.assertNotEqual(t0["clk"], [2])


if __name__ == "__main__":
    unittest.main()
