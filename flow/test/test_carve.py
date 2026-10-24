#!/usr/bin/env python3
"""carve.py on hand-written yosys JSON: two identical tiles and a parent."""

import copy
import os
import sys
import unittest

sys.path.append(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "util"))

import carve  # noqa: E402


def dff(d, q, width=1):
    return {
        "type": "$dff",
        "parameters": {"WIDTH": format(width, "032b"), "CLK_POLARITY": "1"},
        "attributes": {},
        "port_directions": {"CLK": "input", "D": "input", "Q": "output"},
        "connections": {"CLK": [2], "D": d, "Q": q},
    }


def xor(a, b, y):
    return {
        "type": "$xor",
        "parameters": {
            "A_WIDTH": format(len(a), "032b"),
            "B_WIDTH": format(len(b), "032b"),
            "Y_WIDTH": format(len(y), "032b"),
        },
        "attributes": {},
        "port_directions": {"A": "input", "B": "input", "Y": "output"},
        "connections": {"A": a, "B": b, "Y": y},
    }


def design():
    """in -> p (parent) ; t0 <= p ^ t1 ; t1 <= p ^ t0 ; out = t0 ^ t1 (parent).

    Tiles a and b each own one register and the xor in front of it; the
    parent keeps p and the xor to the output. Bits: clk 2, in 3, out 4,
    p 5, t0 6, t1 7, xa 8, xb 9.
    """
    return {
        "modules": {
            "top": {
                "attributes": {},
                "ports": {
                    "clk": {"direction": "input", "bits": [2]},
                    "in": {"direction": "input", "bits": [3]},
                    "out": {"direction": "output", "bits": [4]},
                },
                "cells": {
                    "p": dff([3], [5]),
                    "xa": xor([5], [7], [8]),
                    "ra": dff([8], [6]),
                    "xb": xor([5], [6], [9]),
                    "rb": dff([9], [7]),
                    "xo": xor([6], [7], [4]),
                },
                "netnames": {
                    "clk": {"hide_name": 0, "bits": [2]},
                    "in": {"hide_name": 0, "bits": [3]},
                    "out": {"hide_name": 0, "bits": [4]},
                    "p": {"hide_name": 0, "bits": [5]},
                    "t0": {"hide_name": 0, "bits": [6]},
                    "t1": {"hide_name": 0, "bits": [7]},
                },
            }
        }
    }


def spec():
    return {
        "module": "T",
        "tiles": [
            {
                "instance": "a",
                "seeds": [{"net": "t0"}],
                "ports": [
                    {"net": "clk", "port": "clk"},
                    {"net": "p", "port": "p"},
                    {"net": "t1", "port": "other"},
                    {"net": "t0", "port": "q"},
                ],
            },
            {
                "instance": "b",
                "seeds": [{"net": "t1"}],
                "ports": [
                    {"net": "clk", "port": "clk"},
                    {"net": "p", "port": "p"},
                    {"net": "t0", "port": "other"},
                    {"net": "t1", "port": "q"},
                ],
            },
        ],
    }


class CarveTest(unittest.TestCase):
    def test_two_tiles_and_parent(self):
        d = design()
        census = carve.carve(d, "top", spec())
        top = d["modules"]["top"]
        self.assertEqual(sorted(top["cells"]), ["a", "b", "p", "xo"])
        self.assertEqual(
            top["cells"]["a"]["connections"],
            {"clk": [2], "p": [5], "other": [7], "q": [6]},
        )
        self.assertEqual(
            top["cells"]["b"]["connections"],
            {"clk": [2], "p": [5], "other": [6], "q": [7]},
        )
        t = d["modules"]["T"]
        self.assertEqual(sorted(t["cells"]), ["ra", "xa"])
        self.assertEqual(
            {p: v["direction"] for p, v in t["ports"].items()},
            {"clk": "input", "p": "input", "other": "input", "q": "output"},
        )
        self.assertEqual([x["pins_in"] for x in census["tiles"]], [3, 3])
        self.assertEqual(census["parent_registers"], 1)

    def test_multibit_register_split(self):
        m = {"cells": {"r": dff([3, 4], [5, 6], width=2)}}
        m["cells"]["r"]["type"] = "$sdff"
        m["cells"]["r"]["parameters"]["SRST_VALUE"] = "10"
        carve.split_flops(m)
        self.assertEqual(sorted(m["cells"]), ["r[0]", "r[1]"])
        self.assertEqual(m["cells"]["r[1]"]["connections"]["Q"], [6])
        self.assertEqual(m["cells"]["r[0]"]["parameters"]["SRST_VALUE"], "0")
        self.assertEqual(m["cells"]["r[1]"]["parameters"]["SRST_VALUE"], "1")

    def test_unmapped_boundary_refused(self):
        s = spec()
        s["tiles"][0]["ports"] = s["tiles"][0]["ports"][:-1]
        with self.assertRaisesRegex(ValueError, "no port"):
            carve.carve(design(), "top", s)

    def test_shared_cell_refused(self):
        d = design()
        # one xor in front of both registers
        top = d["modules"]["top"]
        top["cells"]["rb"]["connections"]["D"] = [8]
        del top["cells"]["xb"]
        with self.assertRaisesRegex(ValueError, "is in a and b"):
            carve.carve(d, "top", spec())

    def test_different_boundary_refused(self):
        s = copy.deepcopy(spec())
        s["tiles"][1]["ports"][2]["port"] = "elsewhere"
        with self.assertRaisesRegex(ValueError, "different boundary"):
            carve.carve(design(), "top", s)

    def test_stop_keeps_shared_logic_in_parent(self):
        # without the stop, xa and xb would both read p through one shared
        # inverter in front of them, claimed by both tiles
        d = design()
        top = d["modules"]["top"]
        top["cells"]["inv"] = {
            "type": "$not",
            "parameters": {"A_WIDTH": format(1, "032b"), "Y_WIDTH": format(1, "032b")},
            "attributes": {},
            "port_directions": {"A": "input", "Y": "output"},
            "connections": {"A": [5], "Y": [10]},
        }
        top["netnames"]["np"] = {"hide_name": 0, "bits": [10]}
        top["cells"]["xa"]["connections"]["A"] = [10]
        top["cells"]["xb"]["connections"]["A"] = [10]
        s = spec()
        for t in s["tiles"]:
            t["ports"][1] = {"net": "np", "port": "p"}
        with self.assertRaisesRegex(ValueError, "is in a and b"):
            carve.carve(copy.deepcopy(d), "top", copy.deepcopy(s))
        s["stops"] = [{"net": "np"}]
        carve.carve(d, "top", s)
        self.assertIn("inv", top["cells"])

    def test_split_bitwise(self):
        m = {"cells": {"x": xor([3, 4], [5, 6], [7, 8])}}
        m["cells"]["m"] = {
            "type": "$mux",
            "parameters": {"WIDTH": format(2, "032b")},
            "attributes": {},
            "port_directions": {
                "A": "input",
                "B": "input",
                "S": "input",
                "Y": "output",
            },
            "connections": {"A": [3, 4], "B": [5, 6], "S": [9], "Y": [10, 11]},
        }
        carve.split_bitwise(m)
        self.assertEqual(sorted(m["cells"]), ["m[0]", "m[1]", "x[0]", "x[1]"])
        self.assertEqual(
            m["cells"]["x[1]"]["connections"], {"A": [4], "B": [6], "Y": [8]}
        )
        self.assertEqual(
            m["cells"]["m[1]"]["connections"], {"A": [4], "B": [6], "S": [9], "Y": [11]}
        )


if __name__ == "__main__":
    unittest.main()
