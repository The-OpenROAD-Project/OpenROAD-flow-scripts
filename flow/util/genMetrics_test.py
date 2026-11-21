#!/usr/bin/env python3

import os
import shutil
import subprocess
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.realpath(__file__)))

import genMetrics


class OpenroadBinaryTests(unittest.TestCase):
    """The version is asked of the binary, not of a wrapper in front of
    it: gdb's banner is not a version, and perf record would overwrite
    perf.data with a profile of the query."""

    def binary(self, openroad_exe):
        saved = os.environ.get("OPENROAD_EXE")
        try:
            if openroad_exe is None:
                os.environ.pop("OPENROAD_EXE", None)
            else:
                os.environ["OPENROAD_EXE"] = openroad_exe
            return genMetrics.openroad_binary()
        finally:
            if saved is None:
                os.environ.pop("OPENROAD_EXE", None)
            else:
                os.environ["OPENROAD_EXE"] = saved

    def test_a_path_is_the_binary(self):
        self.assertEqual(self.binary("/opt/or/bin/openroad"), "/opt/or/bin/openroad")

    def test_unset_is_openroad_on_path(self):
        self.assertEqual(self.binary(None), "openroad")

    def test_the_binary_is_the_last_word_after_a_wrapper(self):
        for wrapped in (
            "valgrind /opt/or/bin/openroad",
            "perf record -g -- /opt/or/bin/openroad",
            "gdb -batch -ex run -ex 'thread apply all bt' --args /opt/or/bin/openroad",
        ):
            with self.subTest(wrapped):
                self.assertEqual(self.binary(wrapped), "/opt/or/bin/openroad")


class GitHeadCommitTests(unittest.TestCase):
    """Tests git_head_commit()'s fallback behavior so commit metadata
    extraction degrades gracefully instead of raising."""

    def test_returns_descriptive_string_when_git_not_on_path(self):
        """Nix builds and hermetic Bazel sandboxes can lack git; the
        helper must report that distinctly rather than masquerading as
        'not a git repo'."""
        self.assertEqual(genMetrics.git_head_commit(None, "/tmp"), "git not on PATH")

    def test_returns_na_when_folder_is_not_a_directory(self):
        """An unset/misconfigured PLATFORM_DIR must not let subprocess
        raise FileNotFoundError on cwd."""
        self.assertEqual(
            genMetrics.git_head_commit("/usr/bin/git", "/no/such/directory/orfs-test"),
            "N/A",
        )


class ShutilWhichGitConsistencyTests(unittest.TestCase):
    """Cross-checks shutil.which("git") against actually invoking git, so
    we catch any environment (e.g. a stripped Nix sandbox) where the two
    disagree and the PATH probe would give the wrong answer."""

    def test_which_matches_git_version(self):
        which_result = shutil.which("git")
        try:
            output = subprocess.check_output(
                ["git", "--version"], stderr=subprocess.STDOUT, text=True
            )
        except FileNotFoundError:
            self.assertIsNone(
                which_result,
                "shutil.which found git but invoking it raised FileNotFoundError",
            )
            return

        self.assertIsNotNone(
            which_result,
            "git --version succeeded but shutil.which returned None",
        )
        self.assertTrue(output.startswith("git version "), output)


class ShutilWhichMissingCommandTests(unittest.TestCase):
    """Validates shutil.which() returns None for a non-existent command.
    This is the primitive git_head_commit() relies on at the call site;
    if it ever returned a bogus path (in Nix, in a Bazel sandbox,
    anywhere) the missing-git branch would never fire."""

    BOGUS_CMD = "orfs-genmetrics-no-such-command-xyzzy"

    def test_which_returns_none_for_missing_command(self):
        self.assertIsNone(shutil.which(self.BOGUS_CMD))

    def test_invoking_missing_command_raises_file_not_found(self):
        with self.assertRaises(FileNotFoundError):
            subprocess.check_call([self.BOGUS_CMD])


if __name__ == "__main__":
    unittest.main()
