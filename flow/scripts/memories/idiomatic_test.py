#!/usr/bin/env python3
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import idiomatic
import schema


def mem(rows, bits, read_ports=1, write_ports=1, rw_ports=0):
    return schema.Memory(
        name="m",
        rows=rows,
        bits=bits,
        read_ports=read_ports,
        write_ports=write_ports,
        rw_ports=rw_ports,
    )


class IdiomaticTest(unittest.TestCase):
    def test_accepts_macro_sized_memory(self):
        ok, reason = idiomatic.judge(mem(64, 32))
        self.assertTrue(ok, reason)

    def test_rejects_shallow_memory(self):
        ok, reason = idiomatic.judge(mem(4, 25))
        self.assertFalse(ok)
        self.assertIn("depth 4", reason)

    def test_rejects_small_capacity(self):
        # 16 rows x 8 bits = 128 bits: deep enough, too small overall.
        ok, reason = idiomatic.judge(mem(16, 8))
        self.assertFalse(ok)
        self.assertIn("capacity 128", reason)

    def test_rejects_too_many_ports(self):
        ok, reason = idiomatic.judge(mem(256, 32, read_ports=4, write_ports=2))
        self.assertFalse(ok)
        self.assertIn("ports", reason)

    def test_apply_sets_fields(self):
        memories = [mem(64, 32), mem(4, 25)]
        idiomatic.apply(memories)
        self.assertTrue(memories[0].idiomatic)
        self.assertFalse(memories[1].idiomatic)
        self.assertTrue(memories[1].reason)


if __name__ == "__main__":
    unittest.main()
