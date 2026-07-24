#!/usr/bin/env python3
import json
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import gen_memories
from detect_test import BUS_STYLE, NOT_A_MEMORY, RW_STYLE

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
        rtl = d / "design.v"
        rtl.write_text(BUS_STYLE + NOT_A_MEMORY + RW_STYLE)
        argv = [
            "--platform",
            platform,
            "--out-dir",
            str(d / "memories"),
            "--json",
            str(d / "memories.json"),
            "--verilog",
            str(rtl),
        ]
        for f in memories_files:
            argv += ["--memories", str(f)]
        return gen_memories.main(argv), d

    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)

    def test_flow_contract(self):
        # Everything synthesis and later stages consume must be on disk:
        # memories.json, per-macro .lib/_pre_layout.lib/.lef, and the
        # blackbox name list — for converted memories only.
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

    def test_missing_verilog_fails_cleanly(self):
        code = gen_memories.main(
            [
                "--platform",
                "asap7",
                "--out-dir",
                str(Path(self.tmp.name) / "memories"),
                "--json",
                str(Path(self.tmp.name) / "memories.json"),
                "--verilog",
                str(Path(self.tmp.name) / "does-not-exist.v"),
            ]
        )
        self.assertEqual(code, 1)

    def test_bad_memories_file_fails(self):
        bad = Path(self.tmp.name) / "bad.memories"
        bad.write_text("{not json")
        code, _d = self.run_generator(memories_files=[bad])
        self.assertEqual(code, 1)

    def test_no_memories_still_writes_contract_files(self):
        d = Path(self.tmp.name)
        rtl = d / "logic.v"
        rtl.write_text(NOT_A_MEMORY)
        code = gen_memories.main(
            [
                "--platform",
                "asap7",
                "--out-dir",
                str(d / "memories"),
                "--json",
                str(d / "memories.json"),
                "--verilog",
                str(rtl),
            ]
        )
        self.assertEqual(code, 0)
        self.assertEqual(json.loads((d / "memories.json").read_text())["memories"], [])
        self.assertEqual((d / "memories" / "blackboxes.txt").read_text(), "")


if __name__ == "__main__":
    unittest.main()
