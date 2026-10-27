#!/usr/bin/env python3
import json
import re
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import gen_memories

SAMPLE_YOSYS_NETLIST = {
    "modules": {
        "\\mem_128x32": {
            "cells": {
                "\\$mem_0": {
                    "type": "$mem_v2",
                    "parameters": {
                        "SIZE": 128,
                        "WIDTH": 32,
                        "RD_PORTS": 1,
                        "WR_PORTS": 1,
                    },
                    "connections": {
                        "RD_CLK": [10],
                        "WR_CLK": [10],
                        "RD_EN": [11],
                        "WR_EN": [12, 13, 14, 15],
                        "RD_ADDR": list(range(16, 23)),
                        "WR_ADDR": list(range(16, 23)),
                        "RD_DATA": list(range(24, 56)),
                        "WR_DATA": list(range(56, 88)),
                    },
                }
            }
        },
        "\\cache_tags": {
            "cells": {
                "\\$mem_0": {
                    "type": "$mem_v2",
                    "parameters": {
                        "SIZE": 4,
                        "WIDTH": 25,
                        "RD_PORTS": 1,
                        "WR_PORTS": 1,
                    },
                    "connections": {
                        "RD_CLK": [10],
                        "WR_CLK": [10],
                        "RD_EN": [11],
                        "WR_EN": [12],
                        "RD_ADDR": [13, 14],
                        "WR_ADDR": [13, 14],
                        "RD_DATA": list(range(15, 40)),
                        "WR_DATA": list(range(40, 65)),
                    },
                }
            }
        },
    }
}

FORCE_TAGS = """\
{
  "version": 1,
  "memories": [
    {
      "name": "cache_tags",
      "idiomatic": true,
      "reason": "forced: RTL provides no behavioral fallback"
    }
  ]
}
"""


class GenMemoriesTest(unittest.TestCase):
    def run_generator(self, memories_files=(), platform="asap7"):
        d = Path(self.tmp.name)
        netlist_json = d / "memories_inferred.json"
        netlist_json.write_text(json.dumps(SAMPLE_YOSYS_NETLIST))
        argv = [
            "--platform",
            platform,
            "--out-dir",
            str(d / "memories"),
            "--json",
            str(d / "memories.json"),
            "--yosys-json",
            str(netlist_json),
        ]
        for f in memories_files:
            argv += ["--memories", str(f)]
        return gen_memories.main(argv), d

    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)

    def test_flow_contract(self):
        code, d = self.run_generator()
        self.assertEqual(code, 0)

        doc = json.loads((d / "memories.json").read_text())
        by_name = {m["name"]: m for m in doc["memories"]}
        self.assertEqual(set(by_name), {"mem_128x32", "cache_tags"})
        self.assertTrue(by_name["mem_128x32"]["idiomatic"])
        self.assertFalse(by_name["cache_tags"]["idiomatic"])
        self.assertIn("depth 4", by_name["cache_tags"]["reason"])

        mems_dir = d / "memories"
        self.assertEqual(
            sorted(p.name for p in mems_dir.iterdir()),
            [
                "blackboxes.txt",
                "inline.txt",
                "mem_128x32.lef",
                "mem_128x32.lib",
                "mem_128x32_pre_layout.lib",
                "regfile_cores.txt",
                "regfiles.txt",
            ],
        )
        # one `<module> <area>` line; the area is the one the .lib states,
        # which synthesis costs the blackbox by
        [line] = (mems_dir / "blackboxes.txt").read_text().splitlines()
        name, area = line.split()
        self.assertEqual(name, "mem_128x32")
        lib_area = re.search(
            r"^\s*area\s*:\s*([0-9.]+)\s*;",
            (mems_dir / "mem_128x32.lib").read_text(),
            re.M,
        ).group(1)
        self.assertEqual(float(area), float(lib_area))
        self.assertGreater(float(area), 0)

    def test_additional_memories_forces_conversion(self):
        force = Path(self.tmp.name) / "force.memories"
        force.write_text(FORCE_TAGS)
        code, d = self.run_generator(memories_files=[force])
        self.assertEqual(code, 0)
        blackboxes = [
            line.split()[0]
            for line in (d / "memories" / "blackboxes.txt").read_text().splitlines()
        ]
        self.assertEqual(sorted(blackboxes), ["cache_tags", "mem_128x32"])
        self.assertTrue((d / "memories" / "cache_tags.lib").exists())
        self.assertTrue((d / "memories" / "cache_tags.lef").exists())
        doc = json.loads((d / "memories.json").read_text())
        tags = next(m for m in doc["memories"] if m["name"] == "cache_tags")
        self.assertTrue(tags["idiomatic"])
        self.assertIn("forced", tags["reason"])

    def test_deep_memory_is_folded_square(self):
        # 512x17 with one bit line per column is 2.3 x 166.6 um, 73:1, a
        # sliver macro placement cannot fit; the column mux folds it. The
        # fold squares the bit-cell counts, and a bit cell is not square,
        # so the bound leaves room for that.
        netlist = json.loads(json.dumps(SAMPLE_YOSYS_NETLIST))
        mem = netlist["modules"].pop("\\mem_128x32")
        mem["cells"]["\\$mem_0"]["parameters"].update(SIZE=512, WIDTH=17)
        netlist["modules"] = {"\\mem_512x17": mem}
        d = Path(self.tmp.name)
        (d / "netlist.json").write_text(json.dumps(netlist))
        code = gen_memories.main(
            [
                "--platform",
                "asap7",
                "--out-dir",
                str(d / "memories"),
                "--json",
                str(d / "memories.json"),
                "--yosys-json",
                str(d / "netlist.json"),
            ]
        )
        self.assertEqual(code, 0)
        lef = (d / "memories" / "mem_512x17.lef").read_text()
        size = re.search(r"SIZE\s+(\S+)\s+BY\s+(\S+)", lef)
        self.assertIsNotNone(size, "no SIZE in the generated LEF")
        width, height = map(float, size.groups())
        self.assertLessEqual(max(width, height) / min(width, height), 8.0)

    def test_unsupported_platform_fails_clearly(self):
        code, _d = self.run_generator(platform="nangate45")
        self.assertEqual(code, 1)

    def test_bad_memories_file_fails(self):
        bad = Path(self.tmp.name) / "bad.memories"
        bad.write_text("{not json")
        with self.assertRaises(json.JSONDecodeError):
            self.run_generator(memories_files=[bad])

    def test_missing_yosys_json_fails(self):
        d = Path(self.tmp.name)
        with self.assertRaises(FileNotFoundError):
            gen_memories.main(
                [
                    "--platform",
                    "asap7",
                    "--out-dir",
                    str(d / "memories"),
                    "--json",
                    str(d / "memories.json"),
                    "--yosys-json",
                    str(d / "missing.json"),
                ]
            )

    def test_no_memories_still_writes_contract_files(self):
        d = Path(self.tmp.name)
        empty_netlist = d / "empty.json"
        empty_netlist.write_text(json.dumps({"modules": {}}))
        code = gen_memories.main(
            [
                "--platform",
                "asap7",
                "--out-dir",
                str(d / "memories"),
                "--json",
                str(d / "memories.json"),
                "--yosys-json",
                str(empty_netlist),
            ]
        )
        self.assertEqual(code, 0)
        self.assertEqual(json.loads((d / "memories.json").read_text())["memories"], [])
        self.assertEqual((d / "memories" / "blackboxes.txt").read_text(), "")
        self.assertEqual((d / "memories" / "regfiles.txt").read_text(), "")
        self.assertEqual((d / "memories" / "inline.txt").read_text(), "")
        self.assertEqual((d / "memories" / "regfile_cores.txt").read_text(), "")

    def test_regfile_area_is_the_lib_cell_area(self):
        # a register file's blackboxes.txt line carries the area its
        # generated .lib states, as FakeRAM's do
        with tempfile.TemporaryDirectory() as d:
            lib = Path(d) / "RegFile.lib"
            lib.write_text(
                "library (RegFile) {\n  cell (RegFile) {\n"
                "    area : 153.527400;\n  }\n}\n"
            )
            self.assertEqual(gen_memories._lib_area(lib), "153.527400")

    def test_regfile_lib_without_area_fails(self):
        with tempfile.TemporaryDirectory() as d:
            lib = Path(d) / "RegFile.lib"
            lib.write_text("library (RegFile) {\n  cell (RegFile) {\n  }\n}\n")
            with self.assertRaises(SystemExit):
                gen_memories._lib_area(lib)

    def test_initialized_register_file_stops(self):
        # a spec naming a module whose memory has an initial value stops:
        # generate_ram's storage has none, and the value would be lost
        d = Path(self.tmp.name)
        netlist = json.loads(json.dumps(SAMPLE_YOSYS_NETLIST))
        cell = netlist["modules"]["\\cache_tags"]["cells"]["\\$mem_0"]
        cell["parameters"]["INIT"] = "x" * 75 + "01" * 12 + "1"
        netlist_json = d / "memories_inferred.json"
        netlist_json.write_text(json.dumps(netlist))
        spec = d / "cache_tags.regfile"
        spec.write_text("module cache_tags\n")
        with self.assertRaises(SystemExit) as stop:
            gen_memories.run(
                netlist_json,
                [],
                "asap7",
                d / "memories",
                d / "memories.json",
                regfile_specs=[spec],
            )
        self.assertIn("cache_tags", str(stop.exception))
        self.assertIn("initial value", str(stop.exception))


if __name__ == "__main__":
    unittest.main()
