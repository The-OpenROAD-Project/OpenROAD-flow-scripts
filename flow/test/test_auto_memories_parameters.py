#!/usr/bin/env python3
"""AUTO_MEMORIES drops the parameters from the instances of a
parameterized memory module it blackboxes.

A black box keeps its instances' parameters, and the netlist writes them
out (`Sram #(.NUM_ENTRIES(32)) u0`), which OpenROAD's Verilog reader
refuses for a macro. After auto_memories_drop_parameters the instance is
written as a plain instance of the macro, its ports unchanged.

Skipped when no yosys with read_slang is available: YOSYS_EXE or yosys on
PATH, with the plugin from SLANG_PLUGIN_PATH when read_slang is not built
in.
"""

import os
import shutil
import subprocess
import tempfile
import unittest

DROP_TCL = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "..",
    "scripts",
    "memories",
    "drop_parameters.tcl",
)

DESIGN = """\
module Sram #(parameter NUM_ENTRIES = 64) (
    input clk, input we, input [$clog2(NUM_ENTRIES)-1:0] addr,
    input [15:0] d, output logic [15:0] q);
  logic [15:0] mem [0:NUM_ENTRIES-1];
  always_ff @(posedge clk) begin
    if (we) mem[addr] <= d;
    q <= mem[addr];
  end
endmodule
module top (input clk, input we, input [4:0] addr, input [15:0] d,
            output [15:0] q0, q1);
  Sram #(.NUM_ENTRIES(32)) u0 (.clk, .we, .addr, .d, .q(q0));
  Sram #(.NUM_ENTRIES(32)) u1 (.clk, .we, .addr, .d, .q(q1));
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


class TestAutoMemoriesParameters(unittest.TestCase):
    def netlist(self, drop):
        cmd = yosys_command()
        if cmd is None:
            self.skipTest("no yosys with read_slang")
        with tempfile.TemporaryDirectory() as tmp:
            design = os.path.join(tmp, "top.sv")
            with open(design, "w") as f:
                f.write(DESIGN)
            netlist = os.path.join(tmp, "out.v")
            script = os.path.join(tmp, "drop.tcl")
            with open(script, "w") as f:
                f.write(
                    "yosys -import\n"
                    f"source {{{DROP_TCL}}}\n"
                    "yosys read_slang --keep-hierarchy --top top"
                    f" --blackboxed-module Sram {{{design}}}\n"
                    + ("auto_memories_drop_parameters [list Sram]\n" if drop else "")
                    + "hierarchy -top top\n"
                    f"write_verilog -noattr {{{netlist}}}\n"
                )
            result = subprocess.run(
                cmd + ["-c", script], capture_output=True, text=True
            )
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            with open(netlist) as f:
                return f.read()

    def test_black_box_keeps_parameters(self):
        # The problem: without the proc the instance is parameterized.
        self.assertIn("Sram #(", self.netlist(drop=False))

    def test_parameters_dropped(self):
        netlist = self.netlist(drop=True)
        self.assertNotIn("#(", netlist)
        self.assertIn("Sram u0", netlist)
        self.assertIn("Sram u1", netlist)
        self.assertIn(".addr(addr)", netlist)


if __name__ == "__main__":
    unittest.main()
