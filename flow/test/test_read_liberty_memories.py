#!/usr/bin/env python3
"""read_liberty.tcl reads the liberty views AUTO_MEMORIES generated, and
refuses to go on without them.

After synthesis the memory macros are instances in the netlist and their
LEFs are in the .odb. A stage that runs without AUTO_MEMORIES=1 used to
skip their liberty silently, which times them as black boxes: no error,
every path through a memory unreported. With the views present and
AUTO_MEMORIES not 1, the script now stops and names the memories.

OpenROAD is not needed: the script runs under tclsh with util.tcl for the
env helpers and a read_liberty stub that records what it was asked to read.
"""

import os
import shutil
import subprocess
import tempfile
import unittest

FLOW_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
SCRIPTS_DIR = os.path.join(FLOW_DIR, "scripts")

DRIVER = """
source $::env(SCRIPTS_DIR)/util.tcl
proc read_liberty { args } { puts "READ [lindex $args end]" }
source $::env(SCRIPTS_DIR)/read_liberty.tcl
"""


@unittest.skipUnless(shutil.which("tclsh"), "tclsh not installed")
class TestReadLibertyMemories(unittest.TestCase):
    def setUp(self):
        self.tmp_dir = tempfile.TemporaryDirectory()
        tmp = self.tmp_dir.name
        self.results = os.path.join(tmp, "results")
        os.makedirs(self.results)
        self.stdcell_lib = os.path.join(tmp, "stdcells.lib")
        self.env = dict(
            os.environ,
            SCRIPTS_DIR=SCRIPTS_DIR,
            RESULTS_DIR=self.results,
            REPORTS_DIR=os.path.join(tmp, "reports"),
            LIB_FILES=self.stdcell_lib,
        )
        for var in ("AUTO_MEMORIES", "CORNERS"):
            self.env.pop(var, None)

    def tearDown(self):
        self.tmp_dir.cleanup()

    def generate_memory_views(self, *names):
        memories = os.path.join(self.results, "memories")
        os.makedirs(memories)
        for name in names:
            for suffix in (".lib", "_pre_layout.lib", ".lef"):
                open(os.path.join(memories, name + suffix), "w").close()

    def run_script(self):
        driver = os.path.join(self.tmp_dir.name, "driver.tcl")
        with open(driver, "w") as f:
            f.write(DRIVER)
        return subprocess.run(
            ["tclsh", driver],
            env=self.env,
            capture_output=True,
            text=True,
        )

    def read_files(self, result):
        return [
            os.path.basename(line.split(" ", 1)[1])
            for line in result.stdout.splitlines()
            if line.startswith("READ ")
        ]

    def test_auto_memories_reads_generated_views(self):
        self.generate_memory_views("ram_a", "ram_b")
        self.env["AUTO_MEMORIES"] = "1"
        result = self.run_script()
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(
            sorted(self.read_files(result)),
            ["ram_a.lib", "ram_b.lib", "stdcells.lib"],
        )

    def test_generated_views_without_auto_memories_stop(self):
        self.generate_memory_views("ram_a")
        result = self.run_script()
        self.assertNotEqual(result.returncode, 0, result.stdout)
        self.assertIn("ram_a", result.stderr)
        self.assertIn("AUTO_MEMORIES is not 1", result.stderr)
        self.assertIn("black boxes", result.stderr)

    def test_no_generated_views_reads_only_lib_files(self):
        result = self.run_script()
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(self.read_files(result), ["stdcells.lib"])


if __name__ == "__main__":
    unittest.main()
