#!/usr/bin/env python3
"""The PDN step connects the supply pins of dont_touch instances.

global_connect skips a dont_touch instance, so an instance made
dont_touch before the PDN step kept its supply pins on no net.
dont_touch_unsupplied (util.tcl) names those instances, the PDN step
lifts dont_touch from them for the global connections and restores it
after; an instance whose supply pins are already on a net, or that is
not dont_touch, is not named.

Skipped when no openroad is available: OPENROAD_EXE or openroad on PATH.
"""

import os
import shutil
import subprocess
import tempfile
import unittest

FLOW = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
UTIL_TCL = os.path.join(FLOW, "scripts", "util.tcl")
LEF = os.path.join(FLOW, "platforms", "nangate45", "lef")

DESIGN = """\
module top (input a, output y0, output y1, output y2);
  INV_X1 kept (.A(a), .ZN(y0));
  INV_X1 free (.A(a), .ZN(y1));
  INV_X1 supplied (.A(a), .ZN(y2));
endmodule
"""

SETUP = f"""\
set ::env(REPORTS_DIR) [pwd]
source {{{UTIL_TCL}}}
read_lef {{{os.path.join(LEF, "NangateOpenCellLibrary.tech.lef")}}}
read_lef {{{os.path.join(LEF, "NangateOpenCellLibrary.macro.mod.lef")}}}
read_verilog top.v
link_design top
set block [ord::get_db_block]
proc supply_net {{ name }} {{
  set net [[[ord::get_db_block] findInst $name] findITerm VDD]
  set net [$net getNet]
  if {{ $net eq "NULL" }} {{
    return none
  }}
  return [$net getName]
}}
foreach pin {{VDD VSS}} {{
  [[$block findInst supplied] findITerm $pin] connect \\
    [odb::dbNet_create $block supplied_[string tolower $pin]]
}}
[$block findInst supplied] setDoNotTouch 1
[$block findInst kept] setDoNotTouch 1
"""

# The platform's PDN script: add_global_connection connects at once.
GLOBAL_CONNECTIONS = """\
add_global_connection -net VDD -pin_pattern {^VDD$} -power
add_global_connection -net VSS -pin_pattern {^VSS$} -ground
global_connect
"""


def openroad_command():
    openroad = os.environ.get("OPENROAD_EXE") or shutil.which("openroad")
    return [openroad, "-no_init", "-no_splash", "-exit"] if openroad else None


class TestPdnDontTouchSupplies(unittest.TestCase):
    def run_openroad(self, body):
        cmd = openroad_command()
        if cmd is None:
            self.skipTest("no openroad")
        with tempfile.TemporaryDirectory() as tmp:
            with open(os.path.join(tmp, "top.v"), "w") as f:
                f.write(DESIGN)
            with open(os.path.join(tmp, "test.tcl"), "w") as f:
                f.write(SETUP + body)
            result = subprocess.run(
                cmd + ["test.tcl"], cwd=tmp, capture_output=True, text=True
            )
        output = result.stdout + result.stderr
        self.assertEqual(result.returncode, 0, output)
        return output

    def test_global_connect_skips_dont_touch(self):
        # The problem the PDN step works around, so this test notices
        # when global_connect stops skipping dont_touch instances.
        output = self.run_openroad(
            GLOBAL_CONNECTIONS
            + 'puts "kept=[supply_net kept] free=[supply_net free]"\n'
        )
        self.assertIn("kept=none free=VDD", output)

    def test_names_only_unsupplied_dont_touch(self):
        output = self.run_openroad(
            'puts "lifted=[lmap i [dont_touch_unsupplied] { $i getName }]"\n'
        )
        self.assertIn("lifted=kept\n", output)

    def test_lifted_for_global_connections(self):
        # pdn.tcl's sequence around the platform's PDN script
        output = self.run_openroad(
            "set lifted [dont_touch_unsupplied]\n"
            "foreach inst $lifted { $inst setDoNotTouch 0 }\n"
            + GLOBAL_CONNECTIONS
            + "foreach inst $lifted { $inst setDoNotTouch 1 }\n"
            'puts "kept=[supply_net kept] supplied=[supply_net supplied]"\n'
            'puts "dont_touch=[[$block findInst kept] isDoNotTouch]"\n'
        )
        self.assertIn("kept=VDD supplied=supplied_vdd", output)
        self.assertIn("dont_touch=1", output)


if __name__ == "__main__":
    unittest.main()
