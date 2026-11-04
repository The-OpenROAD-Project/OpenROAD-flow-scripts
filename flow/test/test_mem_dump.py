#!/usr/bin/env python3
"""SYNTH_MEMORY_MAX_BITS stops synthesis on a read/write memory over the
limit, and lets a ROM of the same size through.

mem_dump.py reads the memories yosys inferred (mem.json) and exits with
an error when one is over the limit. A ROM, a $mem_v2 with no write
port, holds constants that synthesis maps to logic: it is listed, marked
as a ROM, and not counted.
"""

import json
import os
import subprocess
import sys
import tempfile
import unittest

MEM_DUMP = os.path.join(
    os.path.dirname(os.path.abspath(__file__)), "..", "scripts", "mem_dump.py"
)


def mem_json(wr_ports, size=64, width=128):
    def b(n):
        return format(n, "032b")

    return {
        "modules": {
            "top": {
                "attributes": {},
                "cells": {
                    "mem": {
                        "type": "$mem_v2",
                        "attributes": {},
                        "parameters": {
                            "SIZE": b(size),
                            "WIDTH": b(width),
                            "WR_PORTS": b(wr_ports),
                        },
                    }
                },
            }
        }
    }


class TestMemDump(unittest.TestCase):
    def run_mem_dump(self, data, max_bits):
        with tempfile.TemporaryDirectory() as tmp:
            path = os.path.join(tmp, "mem.json")
            with open(path, "w") as f:
                json.dump(data, f)
            return subprocess.run(
                [sys.executable, MEM_DUMP, "--max-bits", str(max_bits), path],
                capture_output=True,
                text=True,
            )

    def test_ram_over_limit_stops(self):
        # 64 x 128 = 8192 bits, one write port
        result = self.run_mem_dump(mem_json(wr_ports=1), 4096)
        self.assertNotEqual(result.returncode, 0, result.stdout)
        self.assertIn("exceeds SYNTH_MEMORY_MAX_BITS", result.stderr)

    def test_rom_over_limit_passes(self):
        # the same 8192 bits with no write port
        result = self.run_mem_dump(mem_json(wr_ports=0), 4096)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("ROM top", result.stdout)

    def test_ram_under_limit_passes(self):
        result = self.run_mem_dump(mem_json(wr_ports=1), 8192)
        self.assertEqual(result.returncode, 0, result.stderr)


if __name__ == "__main__":
    unittest.main()
