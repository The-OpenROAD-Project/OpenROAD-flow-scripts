#!/usr/bin/env python3
"""A variable given on the make command line reaches a sub-make with the
value the top-level make sees, whatever characters are in it.

Most steps run in a sub-make (UNSET_AND_MAKE). Quotes, `$` and spaces in a
command-line value come out of the sub-make's command exactly as they come
out of the top level's: the tool gets the same argv either way. A value
from the environment does too.

The tool is a stub that records its argv, so make runs in well under a
second and needs nothing installed.
"""

import json
import os
import subprocess
import sys
import tempfile
import unittest

FLOW_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
DESIGN_CONFIG = "designs/nangate45/gcd/config.mk"

# OR_ARGS as typed after `make OR_ARGS=`, and the arguments OpenROAD gets
VALUES = {
    "single quotes": (
        "-ex 'thread apply all bt' -x",
        ["-ex", "thread apply all bt", "-x"],
    ),
    "double quotes": ('-msg "a  b" -x', ["-msg", "a  b", "-x"]),
    "dollar": ("'$$HOME' -x", ["$HOME", "-x"]),
    "spaces": ("-a   -b", ["-a", "-b"]),
}


class TestSubMakeArgs(unittest.TestCase):
    def setUp(self):
        self.tmp_dir = tempfile.TemporaryDirectory()
        tmp = self.tmp_dir.name
        self.log = os.path.join(tmp, "argv.jsonl")
        self.openroad = os.path.join(tmp, "openroad")
        with open(self.openroad, "w") as f:
            f.write(
                f"#!{sys.executable}\n"
                "import json, os, sys\n"
                "with open(os.environ['ARGV_LOG'], 'a') as f:\n"
                "    f.write(json.dumps(sys.argv[1:]) + '\\n')\n"
            )
        os.chmod(self.openroad, 0o755)
        self.env = dict(os.environ, ARGV_LOG=self.log, OPENROAD_EXE=self.openroad)
        for name in ("OR_ARGS", "MAKEFLAGS"):
            self.env.pop(name, None)

    def tearDown(self):
        self.tmp_dir.cleanup()

    def openroad_argv(self, target, *args, env=None):
        """The arguments after the flow's own, of the one OpenROAD run."""
        if os.path.exists(self.log):
            os.remove(self.log)
        result = subprocess.run(
            [
                "make",
                "--no-print-directory",
                f"DESIGN_CONFIG={DESIGN_CONFIG}",
                f"WORK_HOME={os.path.join(self.tmp_dir.name, 'work')}",
                "NUM_CORES=1",
                *args,
                target,
            ],
            cwd=FLOW_DIR,
            env=dict(self.env, **(env or {})),
            stdin=subprocess.DEVNULL,
            capture_output=True,
            text=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        with open(self.log) as f:
            calls = [json.loads(line) for line in f]
        self.assertEqual(len(calls), 1, calls)
        # `command` runs $(OPENROAD_EXE) -no_init -threads 1 $(OR_ARGS)
        self.assertEqual(calls[0][:3], ["-no_init", "-threads", "1"])
        return calls[0][3:]

    def test_command_line_value_reaches_sub_make(self):
        for name, (value, argv) in VALUES.items():
            with self.subTest(name):
                top = self.openroad_argv("command", f"OR_ARGS={value}")
                self.assertEqual(top, argv)
                sub = self.openroad_argv(
                    "test-unset-and-make-command", f"OR_ARGS={value}"
                )
                self.assertEqual(sub, top)

    def test_command_line_value_reaches_nested_sub_make(self):
        value, argv = VALUES["single quotes"]
        sub = self.openroad_argv(
            "test-unset-and-make-test-unset-and-make-command", f"OR_ARGS={value}"
        )
        self.assertEqual(sub, argv)

    def test_environment_value_reaches_sub_make(self):
        for name, (value, argv) in VALUES.items():
            # make expands an environment value as it does a command-line one
            env = {"OR_ARGS": value}
            with self.subTest(name):
                top = self.openroad_argv("command", env=env)
                self.assertEqual(top, argv)
                sub = self.openroad_argv("test-unset-and-make-command", env=env)
                self.assertEqual(sub, top)


if __name__ == "__main__":
    unittest.main()
