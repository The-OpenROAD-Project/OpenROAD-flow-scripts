#!/usr/bin/env python3
"""riscv32i's sources read under slang, which is stricter than yosys's own
Verilog frontend: a signal assigned in an always block must be declared a
variable (reg), not a net (IEEE 1364-2005 6.1.2, IEEE 1800-2023 6.5).

The SRAM macro comes from its liberty file in the flow; here a black-box
module with the same ports stands in for it. Skipped when no yosys with
read_slang is available: YOSYS_EXE or yosys on PATH, with the plugin from
SLANG_PLUGIN_PATH when read_slang is not built in.
"""

import glob
import os
import shutil
import subprocess
import tempfile
import unittest

SRC_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)), "..", "designs", "src", "riscv32i"
)

FAKERAM_STUB = """\
(* blackbox *)
module fakeram7_256x32 (
  input clk,
  input [31:0] wd_in,
  input ce_in,
  input we_in,
  output [31:0] rd_out,
  input [7:0] addr_in
);
endmodule
"""


def yosys_command():
    yosys = os.environ.get("YOSYS_EXE") or shutil.which("yosys")
    if not yosys:
        return None
    cmd = [yosys, "-q"]
    plugin = os.environ.get("SLANG_PLUGIN_PATH")
    if plugin:
        cmd += ["-m", plugin]
    probe = subprocess.run(cmd + ["-p", "help read_slang"], capture_output=True)
    return cmd if probe.returncode == 0 else None


class TestRiscv32iSlang(unittest.TestCase):
    def test_sources_read_under_slang(self):
        cmd = yosys_command()
        if cmd is None:
            self.skipTest("no yosys with read_slang")
        with tempfile.TemporaryDirectory() as tmp:
            stub = os.path.join(tmp, "fakeram7_256x32.v")
            with open(stub, "w") as f:
                f.write(FAKERAM_STUB)
            sources = sorted(glob.glob(os.path.join(SRC_DIR, "*.v"))) + [stub]
            result = subprocess.run(
                cmd + ["-p", f"read_slang {' '.join(sources)} --top riscv_top"],
                capture_output=True,
                text=True,
            )
        output = result.stdout + result.stderr
        self.assertNotIn("cannot assign to a net", output)
        self.assertEqual(result.returncode, 0, output)


if __name__ == "__main__":
    unittest.main()
