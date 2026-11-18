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
    def test_rejects_memory_inside_a_larger_module(self):
        # An inline array has no module of its own to blackbox: converting
        # it would generate a macro nothing instantiates.
        m = mem(64, 32)
        m.behavioral_model = {"module": "picorv32"}
        ok, reason = idiomatic.judge(m)
        self.assertFalse(ok)
        self.assertIn("inside module picorv32", reason)

    def test_accepts_memory_that_is_its_module(self):
        m = mem(64, 32)
        m.name = "ram_64x32"
        m.behavioral_model = {"module": "$paramod$abc123\\ram_64x32"}
        ok, reason = idiomatic.judge(m)
        self.assertTrue(ok, reason)

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


class BackendShapeTest(unittest.TestCase):
    def test_rejects_combinational_read(self):
        m = mem(704, 776)
        m.comb_read_ports = 1
        ok, reason = idiomatic.judge(m)
        self.assertFalse(ok)
        self.assertIn("combinational read", reason)

    def test_accepts_single_rw_port_under_firtool_convention(self):
        m = mem(64, 114, read_ports=0, write_ports=0, rw_ports=1)
        m.port_convention = "firtool"
        ok, reason = idiomatic.judge(m)
        self.assertTrue(ok, reason)

    def test_rejects_separate_ports_under_firtool_convention(self):
        m = mem(64, 114, read_ports=1, write_ports=1)
        m.port_convention = "firtool"
        ok, reason = idiomatic.judge(m)
        self.assertFalse(ok)
        self.assertIn("single read-write port", reason)

    def test_synthesized_pins_keep_the_old_acceptance(self):
        ok, reason = idiomatic.judge(mem(64, 32))
        self.assertTrue(ok, reason)


if __name__ == "__main__":
    unittest.main()
