#!/usr/bin/env python3
"""OPENROAD_EXE is a command, not only a path: a wrapper such as a debugger
or a profiler goes in front of the binary in it, as in
`make OPENROAD_EXE="gdb --args openroad" ...`.

The wrapped command passes the flow's check, and every rule runs it as
given: at the top level, through a sub-make, and in the generated
open_/gui_/web_ rules. The wrapper runs once per call, never twice.

The tools are stubbed: `openroad` and the wrapper only log their argv, so
make runs in well under a second and needs nothing installed.
"""

import os
import subprocess
import tempfile
import textwrap
import unittest

FLOW_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
DESIGN_CONFIG = "designs/nangate45/gcd/config.mk"


class TestOpenroadExe(unittest.TestCase):
    def setUp(self):
        self.tmp_dir = tempfile.TemporaryDirectory()
        tmp = self.tmp_dir.name
        self.log = os.path.join(tmp, "argv.log")
        self.openroad = self.script("openroad", 'echo "openroad $*" >> "$ARGV_LOG"\n')
        self.wrapper = self.script(
            "wrapper", 'echo "wrapper $1" >> "$ARGV_LOG"\nexec "$@"\n'
        )
        self.work_home = os.path.join(tmp, "work")
        self.env = dict(os.environ, ARGV_LOG=self.log)
        for name in ("OPENROAD_EXE", "YOSYS_EXE", "GDB", "VALGRIND", "MAKEFLAGS"):
            self.env.pop(name, None)

    def tearDown(self):
        self.tmp_dir.cleanup()

    def script(self, name, body):
        path = os.path.join(self.tmp_dir.name, name)
        with open(path, "w") as f:
            f.write("#!/usr/bin/env bash\n" + body)
        os.chmod(path, 0o755)
        return path

    def make(self, target, *args, env=None):
        if os.path.exists(self.log):
            os.remove(self.log)
        result = subprocess.run(
            [
                "make",
                "--no-print-directory",
                f"DESIGN_CONFIG={DESIGN_CONFIG}",
                f"WORK_HOME={self.work_home}",
                "FLOW_VARIANT=openroad_exe",
                *args,
                target,
            ],
            cwd=FLOW_DIR,
            env=dict(self.env, **(env or {})),
            stdin=subprocess.DEVNULL,
            capture_output=True,
            text=True,
        )
        calls = []
        if os.path.exists(self.log):
            with open(self.log) as f:
                calls = f.read().splitlines()
        return result, calls

    def wrapped(self):
        return f"{self.wrapper} {self.openroad}"

    def assert_wrapped_once(self, result, calls):
        output = result.stdout + result.stderr
        self.assertEqual(result.returncode, 0, output)
        self.assertNotIn("binary operator expected", output)
        # the wrapper ran once, on the binary, and the binary ran once
        self.assertEqual(len(calls), 2, calls)
        self.assertEqual(calls[0], f"wrapper {self.openroad}")
        self.assertTrue(calls[1].startswith("openroad "), calls)
        return calls[1]

    def test_wrapped_command_passes_the_check(self):
        for how in ("command line", "environment"):
            with self.subTest(how):
                if how == "command line":
                    result, _ = self.make(
                        "check-openroad", f"OPENROAD_EXE={self.wrapped()}"
                    )
                else:
                    result, _ = self.make(
                        "check-openroad", env={"OPENROAD_EXE": self.wrapped()}
                    )
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_missing_program_fails_the_check(self):
        missing = os.path.join(self.tmp_dir.name, "no-such-wrapper")
        result, _ = self.make(
            "check-openroad", f"OPENROAD_EXE={missing} {self.openroad}"
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("not found or not executable", result.stdout)

    def test_wrapped_yosys_passes_the_check(self):
        yosys = self.script("yosys", "true\n")
        result, _ = self.make("check-yosys", f"YOSYS_EXE={self.wrapper} {yosys}")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_top_level_rule_runs_the_command_once(self):
        for how in ("command line", "environment"):
            with self.subTest(how):
                if how == "command line":
                    args, env = [f"OPENROAD_EXE={self.wrapped()}"], None
                else:
                    args, env = [], {"OPENROAD_EXE": self.wrapped()}
                call = self.assert_wrapped_once(*self.make("command", *args, env=env))
                self.assertIn("-no_init", call)

    def test_sub_make_runs_the_command_once(self):
        for how in ("command line", "environment"):
            with self.subTest(how):
                if how == "command line":
                    args, env = [f"OPENROAD_EXE={self.wrapped()}"], None
                else:
                    args, env = [], {"OPENROAD_EXE": self.wrapped()}
                call = self.assert_wrapped_once(
                    *self.make("test-unset-and-make-command", *args, env=env)
                )
                self.assertIn("-no_init", call)

    def test_generated_rules_run_the_command(self):
        # open_/gui_/web_ rules are generated for each result on disk
        result, _ = self.make("print-RESULTS_DIR")
        results_dir = result.stdout.split("RESULTS_DIR: ")[1].strip()
        os.makedirs(results_dir)
        open(os.path.join(results_dir, "2_floorplan.odb"), "w").close()
        for target, flag in (
            ("open_floorplan", "-no_init"),
            ("gui_floorplan", "-gui"),
            ("web_floorplan", "-web"),
        ):
            with self.subTest(target):
                call = self.assert_wrapped_once(
                    *self.make(target, f"OPENROAD_EXE={self.wrapped()}")
                )
                self.assertIn(flag, call.split())
                self.assertTrue(call.endswith("open.tcl"), call)


if __name__ == "__main__":
    unittest.main()
