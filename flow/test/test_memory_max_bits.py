#!/usr/bin/env python3
"""SYNTH_MEMORY_MAX_BITS stops synthesis on a read/write memory over the
limit, and lets a ROM of the same size through.

synth_memory_max_bits logs every memory yosys inferred and stops with an
error naming each read/write memory over the limit. A ROM, a $mem_v2 with
no write port, holds constants that synthesis maps to logic: it is logged,
marked as a ROM, and not counted. With SYNTH_MOCK_LARGE_MEMORIES, a memory
over the limit is shrunk to one row instead.

Skipped when no yosys is available: YOSYS_EXE or yosys on PATH.
"""

import os
import shutil
import subprocess
import tempfile
import unittest

MAX_BITS_TCL = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "..",
    "scripts",
    "memories",
    "max_bits.tcl",
)

# A RAM with one write port, 32 x 128 = 4096 bits, and a ROM twice its size,
# 64 x 128 = 8192 bits
DESIGN = """\
module ram (input clk, input we, input [4:0] addr, input [127:0] d,
            output reg [127:0] q);
  reg [127:0] mem [0:31];
  always @(posedge clk) begin
    if (we) mem[addr] <= d;
    q <= mem[addr];
  end
endmodule
module rom (input clk, input [5:0] addr, output reg [127:0] q);
  reg [127:0] mem [0:63];
  integer i;
  initial for (i = 0; i < 64; i = i + 1) mem[i] = {4{i * 32'h9e3779b9}};
  always @(posedge clk) q <= mem[addr];
endmodule
module top (input clk, input we, input [5:0] addr, input [127:0] d,
            output [127:0] q0, q1);
  ram u_ram (.clk, .we, .addr(addr[4:0]), .d, .q(q0));
  rom u_rom (.clk, .addr, .q(q1));
endmodule
"""


class TestMemoryMaxBits(unittest.TestCase):
    def run_check(self, max_bits, mock=0):
        yosys = os.environ.get("YOSYS_EXE") or shutil.which("yosys")
        if not yosys:
            self.skipTest("no yosys")
        with tempfile.TemporaryDirectory() as tmp:
            design = os.path.join(tmp, "top.v")
            with open(design, "w") as f:
                f.write(DESIGN)
            script = os.path.join(tmp, "check.tcl")
            with open(script, "w") as f:
                f.write(
                    "yosys -import\n"
                    f"source {{{MAX_BITS_TCL}}}\n"
                    f"yosys read_verilog -sv {{{design}}}\n"
                    "yosys hierarchy -top top\n"
                    "yosys proc\n"
                    "yosys memory -nomap\n"
                    f'puts "mocked: [synth_memory_max_bits {max_bits} {mock} 0]"\n'
                )
            result = subprocess.run(
                [yosys, "-q", "-c", script], capture_output=True, text=True
            )
        return result.returncode, result.stdout + result.stderr

    def test_ram_over_limit_stops(self):
        returncode, output = self.run_check(2048)
        self.assertNotEqual(returncode, 0, output)
        error = output.split("over SYNTH_MEMORY_MAX_BITS=2048")[1]
        self.assertRegex(error, r"ram/\S+ 32 x 128 = 4096")
        self.assertNotIn("rom/", error)

    def test_rom_over_limit_passes(self):
        returncode, output = self.run_check(4096)
        self.assertEqual(returncode, 0, output)
        self.assertRegex(
            output, r"Memory rom/\S+ has dimensions 64 x 128 = 8192, a ROM\n"
        )
        self.assertRegex(output, r"Memory ram/\S+ has dimensions 32 x 128 = 4096\n")

    def test_mock_shrinks_instead_of_stopping(self):
        returncode, output = self.run_check(2048, mock=1)
        self.assertEqual(returncode, 0, output)
        self.assertRegex(output, r"Shrunk memory ram/\S+ from 32 rows to 1")
        self.assertIn("{ram 128 32}", output)


if __name__ == "__main__":
    unittest.main()
