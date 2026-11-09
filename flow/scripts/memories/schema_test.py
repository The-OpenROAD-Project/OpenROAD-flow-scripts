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

    def test_mask_lanes_cover_the_word(self):
        # even split, ragged last lane (tc_sram's bytes over 25 bits), none
        schema.lane_width_check("m", 64, 8, 0)
        schema.lane_width_check("m", 25, 4, 8)
        schema.lane_width_check("m", 25, 0, 0)
        for bits, lanes, width in (
            (25, 4, 0),  # not even, and no width given
            (25, 4, 6),  # 24 bits of lanes for 25
            (25, 4, 9),  # the last lane would be empty
            (25, 0, 8),  # a width with no lanes
        ):
            with self.assertRaises(schema.SchemaError):
                schema.lane_width_check("m", bits, lanes, width)

    def test_mask_pin_matches_mask_lanes(self):
        masked = sample_memory()
        masked.mask_lanes = 4
        masked.pins.append(schema.Pin("W0_mask", "input", 4, "W0", "mask"))
        schema.validate_emittable(masked)  # no raise
        # the override changed mask_lanes, the detected pin is per bit
        narrow = sample_memory()
        narrow.mask_lanes = 4
        narrow.pins.append(schema.Pin("W0_mask", "input", 32, "W0", "mask"))
        # mask_lanes on a memory with no mask pin
        pinless = sample_memory()
        pinless.mask_lanes = 4
        # a mask pin with no mask_lanes
        laneless = sample_memory()
        laneless.pins.append(schema.Pin("W0_mask", "input", 4, "W0", "mask"))
        for mem in (narrow, pinless, laneless):
            with self.assertRaisesRegex(schema.SchemaError, mem.name):
                schema.validate_emittable(mem)

    def test_mask_lane_width_survives_merge_and_dump(self):
        base = sample_memory()
        override = schema.Memory(name=base.name, mask_lanes=4, mask_lane_width=8)
        [merged] = schema.merge([base], [override])
        self.assertEqual(merged.mask_lane_width, 8)
        with tempfile.TemporaryDirectory() as d:
            path = Path(d) / "memories.json"
            schema.dump([merged], path, "asap7")
            self.assertEqual(
                json.loads(path.read_text())["memories"][0]["mask_lane_width"], 8
            )


if __name__ == "__main__":
    unittest.main()
