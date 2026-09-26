#!/usr/bin/env python3
import json
import os
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import gen_memories

# Setup FAKERAM_RUN_PY using runfiles if available, otherwise assume a relative path
if "TEST_WORKSPACE" in os.environ:
    # Bazel test execution
    runfiles_dir = Path(os.environ.get("RUNFILES_DIR", "."))
    candidates = list(runfiles_dir.glob("**/fakeram*/run.py")) + list(
        runfiles_dir.glob("**/run.py")
    )
    fakeram_run = candidates[0] if candidates else runfiles_dir / "fakeram" / "run.py"
else:
    fakeram_run = (
        Path(__file__).resolve().parent.parent.parent.parent
        / "tools"
        / "FakeRAM2.0"
        / "run.py"
    )

os.environ["FAKERAM_RUN_PY"] = str(fakeram_run)

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
                "mem_128x32.lef",
                "mem_128x32.lib",
                "mem_128x32_pre_layout.lib",
            ],
        )
        self.assertEqual((mems_dir / "blackboxes.txt").read_text(), "mem_128x32\n")

    def test_additional_memories_forces_conversion(self):
        force = Path(self.tmp.name) / "force.memories"
        force.write_text(FORCE_TAGS)
        code, d = self.run_generator(memories_files=[force])
        self.assertEqual(code, 0)
        blackboxes = (d / "memories" / "blackboxes.txt").read_text().split()
        self.assertEqual(sorted(blackboxes), ["cache_tags", "mem_128x32"])
        self.assertTrue((d / "memories" / "cache_tags.lib").exists())
        self.assertTrue((d / "memories" / "cache_tags.lef").exists())
        doc = json.loads((d / "memories.json").read_text())
        tags = next(m for m in doc["memories"] if m["name"] == "cache_tags")
        self.assertTrue(tags["idiomatic"])
        self.assertIn("forced", tags["reason"])

    def test_unsupported_platform_fails_clearly(self):
        code, _d = self.run_generator(platform="nangate45")
        self.assertEqual(code, 1)

    def test_bad_memories_file_fails(self):
        bad = Path(self.tmp.name) / "bad.memories"
        bad.write_text("{not json")
        with self.assertRaises(json.JSONDecodeError):
            self.run_generator(memories_files=[bad])

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


if __name__ == "__main__":
    unittest.main()
