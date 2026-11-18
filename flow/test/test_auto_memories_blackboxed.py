#!/usr/bin/env python3
"""AUTO_MEMORIES stops synthesis when a module it asks read_slang to
blackbox is not a black box of the design.

read_slang's --blackboxed-module ignores a name it does not know, and
slang names a module per instance, `<definition>$<instance path>`. Only
the definition's name blackboxes the memory; any other name must stop
the flow right after the sources are read, naming the module.

Skipped when no yosys with read_slang is available: YOSYS_EXE or yosys on
PATH, with the plugin from SLANG_PLUGIN_PATH when read_slang is not built
in.
"""

import os
import shutil
import subprocess
import tempfile
import unittest

CHECK_TCL = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "..",
    "scripts",
    "memories",
    "check_blackboxed.tcl",
)

DESIGN = """\
module ram (input clk, input we, input [5:0] addr, input [15:0] d,
            output logic [15:0] q);
  logic [15:0] mem [0:63];
  always_ff @(posedge clk) begin
    if (we) mem[addr] <= d;
    q <= mem[addr];
  end
endmodule
module \\1d_ram (input clk, input we, input [5:0] addr, input [15:0] d,
                output logic [15:0] q);
  logic [15:0] mem [0:63];
  always_ff @(posedge clk) begin
    if (we) mem[addr] <= d;
    q <= mem[addr];
  end
endmodule
module top (input clk, input we, input [5:0] addr, input [15:0] d,
            output [15:0] q0, q1, q2);
  ram u0 (.clk, .we, .addr, .d, .q(q0));
  ram u1 (.clk, .we, .addr, .d, .q(q1));
  \\1d_ram  u2 (.clk, .we, .addr, .d, .q(q2));
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


class TestAutoMemoriesBlackboxed(unittest.TestCase):
    def run_check(self, names):
        cmd = yosys_command()
        if cmd is None:
            self.skipTest("no yosys with read_slang")
        with tempfile.TemporaryDirectory() as tmp:
            design = os.path.join(tmp, "top.sv")
            with open(design, "w") as f:
                f.write(DESIGN)
            braced = [f"{{{n}}}" for n in names]
            blackboxed = " ".join(f"--blackboxed-module {n}" for n in braced)
            script = os.path.join(tmp, "check.tcl")
            with open(script, "w") as f:
                f.write(
                    "yosys -import\n"
                    f"source {{{CHECK_TCL}}}\n"
                    f"yosys read_slang --keep-hierarchy --top top {blackboxed}"
                    f" {{{design}}}\n"
                    f"auto_memories_check_blackboxed [list {' '.join(braced)}]\n"
                )
            result = subprocess.run(
                cmd + ["-c", script], capture_output=True, text=True
            )
        return result.returncode, result.stdout + result.stderr

    def test_definition_name_is_blackboxed(self):
        returncode, output = self.run_check(["ram"])
        self.assertEqual(returncode, 0, output)

    def test_escaped_definition_name_is_blackboxed(self):
        # read_slang takes `\1d_ram` as `1d_ram`; yosys lists it escaped
        returncode, output = self.run_check(["ram", "1d_ram"])
        self.assertEqual(returncode, 0, output)

    def test_per_instance_name_stops_the_flow(self):
        returncode, output = self.run_check(["ram$top.u0", "ram$top.u1"])
        self.assertNotEqual(returncode, 0, output)
        self.assertIn("not a black box of the design", output)
        self.assertIn("ram$top.u0, ram$top.u1", output)

    def test_unknown_name_stops_the_flow(self):
        returncode, output = self.run_check(["no_such_module"])
        self.assertNotEqual(returncode, 0, output)
        self.assertIn("no_such_module", output)


if __name__ == "__main__":
    unittest.main()
