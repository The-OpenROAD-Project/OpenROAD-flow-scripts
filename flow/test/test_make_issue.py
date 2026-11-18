#!/usr/bin/env python3
"""`make <step>_issue` archives a flow step as a reproducible: makeIssue.py.

The unit tests call makeIssue's functions with the tools they would run
mocked. The end-to-end tests run makeIssue.py as the flow's Makefile runs
it, from the flow directory, on a stub flow: a scripts directory with the
step's script, a platform and a design. The archive is unpacked elsewhere
and its run-me script run with a stub openroad on PATH that records what
it can read from where run-me started it. Nothing beyond bash, tar and
gzip needs to be installed.
"""

import os
import shutil
import subprocess
import sys
import tarfile
import tempfile
import textwrap
import unittest
from unittest import mock

UTILS_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "util")
MAKE_ISSUE = os.path.join(UTILS_DIR, "makeIssue.py")

sys.path.insert(0, UTILS_DIR)
import makeIssue  # noqa: E402

STEP = "detail_place"
TAG = "test"
NICKNAME = "stub"
PLATFORM = "stubpdk"
VARIANT = "base"
FLOW_NAME = f"{NICKNAME}-{PLATFORM}-{VARIANT}"

FAKE_OPENROAD = textwrap.dedent("""\
    #!/usr/bin/env bash
    # Records the script it was given, whether that script and the step's
    # input are readable from where run-me started it, and its arguments.
    script="${@: -1}"
    {
      echo "args=$*"
      echo "script=$script"
      [ -r "$script" ] && echo "script_readable=1" || echo "script_readable=0"
      [ -r "$RESULTS_DIR/3_place.odb" ] && echo "input_readable=1" \\
        || echo "input_readable=0"
    } > "$OPENROAD_REPORT"
    """)


class StubFlow:
    """A flow directory with one step, a platform and a design, in a
    temporary directory that is removed with cleanup()."""

    def __init__(self):
        self.tmp_dir = tempfile.TemporaryDirectory()
        self.tmp = self.tmp_dir.name
        self.flow = os.path.join(self.tmp, "flow")
        self.scripts = os.path.join(self.flow, "scripts")
        self.platform_dir = os.path.join(self.flow, "platforms", PLATFORM)
        self.design_dir = os.path.join(self.flow, "designs", PLATFORM, NICKNAME)
        self.design_config = os.path.join(self.design_dir, "config.mk")
        for path, text in [
            (os.path.join(self.scripts, STEP + ".tcl"), "puts step\n"),
            (os.path.join(self.platform_dir, "config.mk"), "\n"),
            (os.path.join(self.platform_dir, "pdn.tcl"), "\n"),
            (self.design_config, "\n"),
        ]:
            self.write(path, text)

        self.bin = os.path.join(self.tmp, "bin")
        self.write(os.path.join(self.bin, "openroad"), FAKE_OPENROAD)
        os.chmod(os.path.join(self.bin, "openroad"), 0o755)

    def cleanup(self):
        self.tmp_dir.cleanup()

    @staticmethod
    def write(path, text):
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, "w") as f:
            f.write(text)

    def flow_dirs(self, work_home):
        return {
            name: f"{work_home}/{name.lower()}/{PLATFORM}/{NICKNAME}/{VARIANT}"
            for name in ["LOG_DIR", "OBJECTS_DIR", "REPORTS_DIR", "RESULTS_DIR"]
        }

    def make_issue(self, work_home, step=STEP, **extra):
        """Runs makeIssue.py as `make <step>_issue` does and returns the
        archive's path."""
        dirs = self.flow_dirs(work_home)
        for path in dirs.values():
            os.makedirs(os.path.join(self.flow, path), exist_ok=True)
        self.write(os.path.join(self.flow, dirs["RESULTS_DIR"], "3_place.odb"), "")

        variables = dict(
            dirs,
            DESIGN_NICKNAME=NICKNAME,
            PLATFORM=PLATFORM,
            FLOW_VARIANT=VARIANT,
            PLATFORM_DIR=self.platform_dir,
            DESIGN_DIR=self.design_dir,
            DESIGN_CONFIG=self.design_config,
            SCRIPTS_DIR=self.scripts,
            UTILS_DIR=UTILS_DIR,
            WORK_HOME=work_home,
        )
        variables.update(extra)
        env = dict(
            os.environ,
            FLOW_HOME=self.flow,
            ISSUE_TAG=TAG,
            ISSUE_VARIABLES="\n".join(f"{k}={v}" for k, v in variables.items()),
            **variables,
        )
        result = subprocess.run(
            [sys.executable, MAKE_ISSUE, f"{work_home}/{step}"],
            cwd=self.flow,
            env=env,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            universal_newlines=True,
        )
        if result.returncode != 0:
            raise AssertionError(f"makeIssue.py failed:\n{result.stdout}")
        return os.path.join(self.flow, work_home, f"{step}_{TAG}.tar.gz")

    def unpack(self, archive, step=STEP):
        """Unpacks the archive away from the flow; returns its root."""
        unpacked = os.path.join(self.tmp, "unpacked")
        shutil.rmtree(unpacked, ignore_errors=True)
        with tarfile.open(archive) as tar:
            tar.extractall(unpacked)
        return os.path.join(unpacked, f"{step}_{TAG}")

    @staticmethod
    def members(archive):
        with tarfile.open(archive) as tar:
            return [m.name for m in tar.getmembers()]

    @staticmethod
    def find(root, name):
        found = [
            os.path.join(d, name) for d, _, files in os.walk(root) if name in files
        ]
        if len(found) != 1:
            raise AssertionError(f"{len(found)} {name} in {root}")
        return found[0]

    def run_me(self, root):
        """Runs the unpacked archive's run-me script from elsewhere and
        returns what the stub openroad recorded."""
        report = os.path.join(self.tmp, "openroad_report")
        if os.path.exists(report):
            os.remove(report)
        env = dict(
            os.environ,
            PATH=self.bin + os.pathsep + os.environ["PATH"],
            OPENROAD_REPORT=report,
        )
        env.pop("FLOW_HOME", None)
        result = subprocess.run(
            [self.find(root, f"run-me-{FLOW_NAME}.sh")],
            cwd=self.tmp,
            env=env,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            universal_newlines=True,
        )
        if result.returncode != 0 or not os.path.exists(report):
            raise AssertionError(f"run-me did not start openroad:\n{result.stdout}")
        with open(report) as f:
            return dict(line.split("=", 1) for line in f.read().splitlines())


class StubFlowTestCase(unittest.TestCase):
    def setUp(self):
        self.stub = StubFlow()
        self.addCleanup(self.stub.cleanup)


class TestRunMe(StubFlowTestCase):
    """The archive's run-me runs the step from wherever it is unpacked."""

    def assert_runs(self, work_home):
        archive = self.stub.make_issue(work_home)
        recorded = self.stub.run_me(self.stub.unpack(archive))
        self.assertEqual(os.path.basename(recorded["script"]), STEP + ".tcl")
        self.assertEqual(recorded["script_readable"], "1", recorded)
        self.assertEqual(recorded["input_readable"], "1", recorded)

    def test_work_home_default(self):
        self.assert_runs(".")

    def test_work_home_absolute(self):
        self.assert_runs(os.path.join(self.stub.tmp, "work"))


class TestOptions(StubFlowTestCase):
    def test_copy_issue_copies_the_archive(self):
        copies = os.path.join(self.stub.tmp, "copies")
        archive = self.stub.make_issue(".", COPY_ISSUE=copies)
        self.assertEqual(os.listdir(copies), [os.path.basename(archive)])

    def test_full_issue_archives_the_design_and_platform_directories(self):
        self.stub.write(os.path.join(self.stub.design_dir, "rtl.v"), "\n")
        members = self.stub.members(self.stub.make_issue(".", FULL_ISSUE="1"))
        self.assertIn(f"{STEP}_{TAG}/designs/{PLATFORM}/{NICKNAME}/rtl.v", members)

    def test_exclude_platform_drops_liberty_and_lef(self):
        for name in ["cells.lib", "cells.lef", "tech.tlef"]:
            self.stub.write(os.path.join(self.stub.platform_dir, name), "\n")
        # FULL_ISSUE archives the platform directory, so the liberty and
        # LEF files are in the archive until EXCLUDE_PLATFORM drops them.
        archive = self.stub.make_issue(".", EXCLUDE_PLATFORM="1", FULL_ISSUE="1")
        names = [os.path.basename(m) for m in self.stub.members(archive)]
        for name in ["cells.lib", "cells.lef", "tech.tlef"]:
            self.assertNotIn(name, names)
        self.assertIn("pdn.tcl", names)
        self.assertIn(f"run-me-{FLOW_NAME}.sh", names)


class TestCompressor(unittest.TestCase):
    def test_pigz_when_installed(self):
        with mock.patch("shutil.which", return_value="/usr/bin/pigz"):
            self.assertEqual(makeIssue.compressor(), "pigz")

    def test_gzip_otherwise(self):
        with mock.patch("shutil.which", return_value=None):
            self.assertEqual(makeIssue.compressor(), "gzip")


class TestFileVariables(StubFlowTestCase):
    """Every file a file variable names is archived on its own, whatever
    else is set (#914: DFF_LIB_FILE and LIB_FILES ran together into one
    name), and a variable may name several files or a glob
    (ADDITIONAL_FILES, #2060)."""

    def files(self, **variables):
        env = dict(
            variables,
            PLATFORM_DIR=self.stub.platform_dir,
            UTILS_DIR=UTILS_DIR,
        )
        return makeIssue.issue_files(env, "work/vars", "work/run-me.sh")

    def test_adjacent_variables_stay_separate(self):
        files = self.files(DFF_LIB_FILE="dff.lib", LIB_FILES="a.lib b.lib")
        for name in ["dff.lib", "a.lib", "b.lib"]:
            self.assertIn(name, files)

    def test_every_design_and_platform_variable_is_archived(self):
        variables = {
            name: f"{name.lower()}.file"
            for name in makeIssue.DESIGN_FILE_VARS + makeIssue.PLATFORM_FILE_VARS
        }
        files = self.files(**variables)
        for name, path in variables.items():
            self.assertIn(path, files, name)

    def test_a_glob_names_the_files_it_matches(self):
        extra = os.path.join(self.stub.platform_dir, "extra")
        for name in ["a.v", "b.v"]:
            self.stub.write(os.path.join(extra, name), "\n")
        files = self.files(ADDITIONAL_FILES=f"{extra}/*.v")
        self.assertIn(os.path.join(extra, "a.v"), files)
        self.assertIn(os.path.join(extra, "b.v"), files)
        self.assertNotIn(f"{extra}/*.v", files)

    def test_the_issue_files_are_archived(self):
        files = self.files()
        for name in [
            "work/run-me.sh",
            "work/vars.sh",
            "work/vars.tcl",
            "work/vars.gdb",
        ]:
            self.assertIn(name, files)

    def test_exclude_platform_leaves_out_platform_variables(self):
        files = self.files(EXCLUDE_PLATFORM="1", LIB_FILES="a.lib", SDC_FILE="d.sdc")
        self.assertNotIn("a.lib", files)
        self.assertIn("d.sdc", files)

    def test_archived_end_to_end(self):
        lib = os.path.join(self.stub.platform_dir, "dff.lib")
        cells = os.path.join(self.stub.platform_dir, "cells.lib")
        for path in [lib, cells]:
            self.stub.write(path, "\n")
        names = [
            os.path.basename(m)
            for m in self.stub.members(
                self.stub.make_issue(".", DFF_LIB_FILE=lib, LIB_FILES=cells)
            )
        ]
        self.assertIn("dff.lib", names)
        self.assertIn("cells.lib", names)


if __name__ == "__main__":
    unittest.main()
