#!/usr/bin/env python3
import json
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import schema


def sample_memory(name="mem_64x32") -> schema.Memory:
    return schema.Memory(
        name=name,
        rows=64,
        bits=32,
        addr_w=6,
        read_ports=1,
        write_ports=1,
        pins=[
            schema.Pin("R0_addr", "input", 6, "R0", "addr"),
            schema.Pin("R0_en", "input", 1, "R0", "en"),
            schema.Pin("R0_clk", "input", 1, "R0", "clk"),
            schema.Pin("R0_data", "output", 32, "R0", "data_out"),
            schema.Pin("W0_addr", "input", 6, "W0", "addr"),
            schema.Pin("W0_en", "input", 1, "W0", "en"),
            schema.Pin("W0_clk", "input", 1, "W0", "clk"),
            schema.Pin("W0_data", "input", 32, "W0", "data_in"),
        ],
        behavioral_model={"file": "mems.v", "module": name},
        idiomatic=True,
        reason="meets ASAP7 macro floors",
    )


class SchemaTest(unittest.TestCase):
    def test_round_trip(self):
        with tempfile.TemporaryDirectory() as d:
            path = Path(d) / "memories.json"
            schema.dump([sample_memory()], path, platform="asap7")
            loaded = schema.load(path)
        self.assertEqual(len(loaded), 1)
        self.assertEqual(loaded[0].to_dict(), sample_memory().to_dict())

    def test_dump_is_sorted_and_versioned(self):
        with tempfile.TemporaryDirectory() as d:
            path = Path(d) / "memories.json"
            schema.dump(
                [sample_memory("zz"), sample_memory("aa")], path, platform="asap7"
            )
            doc = json.loads(path.read_text())
        self.assertEqual(doc["version"], schema.SCHEMA_VERSION)
        self.assertEqual(doc["platform"], "asap7")
        self.assertEqual([m["name"] for m in doc["memories"]], ["aa", "zz"])

    def test_merge_partial_override(self):
        detected = [sample_memory()]
        detected[0].idiomatic = False
        detected[0].reason = "depth 4 below macro floor 16"
        override = schema.Memory(
            name="mem_64x32", idiomatic=True, reason="forced: no behavioral fallback"
        )
        merged = schema.merge(detected, [override])
        self.assertEqual(len(merged), 1)
        m = merged[0]
        self.assertTrue(m.idiomatic)
        self.assertEqual(m.reason, "forced: no behavioral fallback")
        # Geometry and pins kept from detection.
        self.assertEqual((m.rows, m.bits), (64, 32))
        self.assertEqual(len(m.pins), 8)

    def test_merge_new_entry_taken_whole(self):
        extra = sample_memory("mem_extra")
        merged = schema.merge([sample_memory()], [extra])
        self.assertEqual(sorted(m.name for m in merged), ["mem_64x32", "mem_extra"])

    def test_load_rejects_bad_documents(self):
        with tempfile.TemporaryDirectory() as d:
            path = Path(d) / "bad.memories"
            path.write_text("[]")
            with self.assertRaises(schema.SchemaError):
                schema.load(path)
            path.write_text('{"version": 99, "memories": []}')
            with self.assertRaises(schema.SchemaError):
                schema.load(path)
            path.write_text('{"memories": [{"rows": 4}]}')
            with self.assertRaises(schema.SchemaError):
                schema.load(path)
            path.write_text(
                '{"memories": [{"name": "m", "pins": '
                '[{"name": "p", "direction": "input", "width": 1, '
                '"port_id": "R0", "function": "banana"}]}]}'
            )
            with self.assertRaises(schema.SchemaError):
                schema.load(path)

    def test_validate_emittable(self):
        good = sample_memory()
        schema.validate_emittable(good)  # no raise
        with self.assertRaises(schema.SchemaError):
            schema.validate_emittable(schema.Memory(name="empty"))
        clkless = sample_memory()
        clkless.pins = [p for p in clkless.pins if p.function != "clk"]
        with self.assertRaises(schema.SchemaError):
            schema.validate_emittable(clkless)
        addrless = sample_memory()
        addrless.pins = [p for p in addrless.pins if p.function != "addr"]
        with self.assertRaises(schema.SchemaError):
            schema.validate_emittable(addrless)
        dataless = sample_memory()
        dataless.pins = [
            p for p in dataless.pins if p.function not in ("data_in", "data_out")
        ]
        with self.assertRaises(schema.SchemaError):
            schema.validate_emittable(dataless)


if __name__ == "__main__":
    unittest.main()
