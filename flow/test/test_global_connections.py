#!/usr/bin/env python3
"""Floorplan makes the platform's global connections.

global_connect skips a dont_touch instance, so floorplan.tcl makes the
platform's global connections (PDN_TCL) before any step marks an
instance dont_touch. Every instance's supply pins are then on a net, and
the rules stay in the database: a later step that marks an instance
dont_touch leaves its supplies connected, and one that creates instances
connects them with global_connect before marking them.

floorplan.tcl runs as is on a two-inverter nangate45 design; load.tcl is
replaced by one that reads the netlist and stubs the reports.

Skipped when no openroad is available: OPENROAD_EXE or openroad on PATH.
"""

import os
import shutil
import subprocess
import tempfile
import unittest

FLOW = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
SCRIPTS = os.path.join(FLOW, "scripts")
PLATFORM = os.path.join(FLOW, "platforms", "nangate45")
LEF = os.path.join(PLATFORM, "lef")
TECH_LEF = os.path.join(LEF, "NangateOpenCellLibrary.tech.lef")
SC_LEF = os.path.join(LEF, "NangateOpenCellLibrary.macro.mod.lef")
LIB = os.path.join(PLATFORM, "lib", "NangateOpenCellLibrary_typical.lib")

DESIGN = """\
module top (input a, output y0, output y1);
  INV_X1 kept (.A(a), .ZN(y0));
  INV_X1 free (.A(a), .ZN(y1));
endmodule
"""

# In place of load.tcl: the netlist and liberty without an SDC, and no
# timing reports.
LOAD = f"""\
source {{{os.path.join(SCRIPTS, "util.tcl")}}}
proc load_design {{ design_file sdc_file }} {{
  read_liberty {{{LIB}}}
  read_lef {{{TECH_LEF}}}
  read_lef {{{SC_LEF}}}
  read_verilog top.v
  link_design top
}}
proc report_metrics {{ args }} {{ }}
proc report_units_metric {{ }} {{ }}
proc report_layer_rc {{ }} {{ }}
proc write_endpoint_slack {{ args }} {{ }}
"""

ENV = {
    "KEEP_VARS": "1",
    "PDN_TCL": os.path.join(PLATFORM, "grid_strategy-M1-M4-M7.tcl"),
    "DIE_AREA": "0 0 100 100",
    "CORE_AREA": "10 10 90 90",
    "PLACE_SITE": "FreePDK45_38x28_10R_NP_162NW_34O",
    "MIN_ROUTING_LAYER": "metal2",
    "MAX_ROUTING_LAYER": "metal10",
    "ROUTING_LAYER_ADJUSTMENT": "0.5",
    "DONT_USE_CELLS": "",
    "SKIP_REPAIR_TIE_FANOUT": "1",
    "SKIP_FLOORPLAN_REPAIR_TIMING": "1",
    "WRITE_ODB_AND_SDC_EACH_STAGE": "1",
    "OPENROAD_HIERARCHICAL": "0",
}

# A later step: reads floorplan's result, marks an instance dont_touch,
# creates one and connects it before marking it dont_touch.
LATER = f"""\
read_lef {{{TECH_LEF}}}
read_lef {{{SC_LEF}}}
read_db 2_1_floorplan.odb
set block [ord::get_db_block]
proc supply {{ name pin }} {{
  set net [[[[ord::get_db_block] findInst $name] findITerm $pin] getNet]
  if {{ $net eq "NULL" }} {{
    return none
  }}
  return [$net getName]
}}
foreach name {{kept free}} {{
  puts "floorplan $name [supply $name VDD] [supply $name VSS]"
}}
[$block findInst kept] setDoNotTouch 1
set created [odb::dbInst_create $block [[ord::get_db] findMaster INV_X1] created]
global_connect
$created setDoNotTouch 1
foreach name {{kept created}} {{
  puts "later $name [supply $name VDD] [supply $name VSS]"
}}
"""


def openroad():
    return os.environ.get("OPENROAD_EXE") or shutil.which("openroad")


def run(script, cwd, env):
    result = subprocess.run(
        [openroad(), "-no_init", "-no_splash", "-exit", script],
        cwd=cwd,
        env=env,
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        raise AssertionError(result.stdout + result.stderr)
    return result.stdout


@unittest.skipUnless(openroad(), "no openroad: set OPENROAD_EXE")
class GlobalConnectionsTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cwd = cls.tmp.name
        stub = os.path.join(cwd, "scripts")
        os.mkdir(stub)
        with open(os.path.join(stub, "load.tcl"), "w") as f:
            f.write(LOAD)
        with open(os.path.join(cwd, "top.v"), "w") as f:
            f.write(DESIGN)
        with open(os.path.join(cwd, "later.tcl"), "w") as f:
            f.write(LATER)
        env = dict(
            os.environ,
            SCRIPTS_DIR=stub,
            PLATFORM_DIR=PLATFORM,
            RESULTS_DIR=cwd,
            REPORTS_DIR=cwd,
            **ENV,
        )
        run(os.path.join(SCRIPTS, "floorplan.tcl"), cwd, env)
        cls.supply = {}
        for line in run("later.tcl", cwd, env).splitlines():
            words = line.split()
            if len(words) == 4 and words[0] in ("floorplan", "later"):
                cls.supply[(words[0], words[1])] = words[2:]

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def test_supply_pins_are_connected_at_floorplan(self):
        self.assertEqual(self.supply[("floorplan", "free")], ["VDD", "VSS"])
        self.assertEqual(self.supply[("floorplan", "kept")], ["VDD", "VSS"])

    def test_an_instance_marked_dont_touch_later_keeps_its_supplies(self):
        self.assertEqual(self.supply[("later", "kept")], ["VDD", "VSS"])

    def test_rules_stay_in_the_database_for_a_later_step(self):
        self.assertEqual(self.supply[("later", "created")], ["VDD", "VSS"])


if __name__ == "__main__":
    unittest.main()
