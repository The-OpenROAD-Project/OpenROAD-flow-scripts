#!/usr/bin/env python3

import contextlib
import io
import json
import os
import subprocess
import sys
import tempfile
import unittest
import urllib.error
from unittest.mock import patch

sys.path.append(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "util"))

import checkQorMetrics

COMMIT = "a" * 40
BASE = "b" * 40


class FakeResponse(io.BytesIO):
    def __enter__(self):
        return self

    def __exit__(self, *args):
        self.close()


def response(status="pass", strategy="merge-base", failed=0, metrics=()):
    return {
        "status": status,
        "baselineStrategy": strategy,
        "baseBuildId": 7,
        "baseCommitSha": BASE,
        "totals": {"passed": 1, "failed": failed, "missingFromBaseline": 0},
        "metrics": list(metrics),
    }


class Dashboard:
    """Stands in for urlopen: records each payload and answers with replies in turn."""

    def __init__(self, *replies):
        self.replies = list(replies) or [response()]
        self.payloads = []

    def __call__(self, request, timeout):
        self.payloads.append(json.loads(request.data))
        reply = self.replies[min(len(self.payloads), len(self.replies)) - 1]
        if isinstance(reply, Exception):
            raise reply
        return FakeResponse(json.dumps(reply).encode("utf-8"))


def git(cwd, *args):
    return subprocess.run(
        ["git", *args], cwd=cwd, check=True, capture_output=True, text=True
    ).stdout.strip()


class CheckQorMetricsTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        environment = {
            key: value
            for key, value in os.environ.items()
            if not key.startswith("DASHBOARD_")
        }
        environment.update(
            GIT_AUTHOR_NAME="test",
            GIT_AUTHOR_EMAIL="test@example.com",
            GIT_COMMITTER_NAME="test",
            GIT_COMMITTER_EMAIL="test@example.com",
            GIT_CONFIG_GLOBAL=os.devnull,
            GIT_CONFIG_NOSYSTEM="1",
        )
        for patcher in (
            patch.dict(os.environ, environment, clear=True),
            patch.object(checkQorMetrics.time, "sleep"),
        ):
            patcher.start()
            self.addCleanup(patcher.stop)
        checkQorMetrics.local_merge_base.cache_clear()
        self.addCleanup(checkQorMetrics.local_merge_base.cache_clear)
        # git runs in the current directory, which is flow/ after the import.
        # An empty directory outside any repository keeps this checkout out of it.
        self.enter(self.tmp.name)

    def enter(self, directory):
        previous = os.getcwd()
        os.chdir(directory)
        self.addCleanup(os.chdir, previous)

    def metadata(self, name="metadata.json", commit=COMMIT, **metrics):
        metrics = metrics or {"finish__timing__setup__ws": 1.5}
        path = os.path.join(self.tmp.name, name)
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, "w", encoding="utf-8") as metadata_file:
            # allow_nan writes the bare Infinity/NaN tokens genMetrics.py writes.
            json.dump(
                {checkQorMetrics.COMMIT_KEY: commit, **metrics},
                metadata_file,
                allow_nan=True,
            )
        return path

    def run_check(self, *args, dashboard=None, metadata=None):
        """Returns (exit code, output, payloads) for one single-run check."""
        dashboard = dashboard or Dashboard()
        argv = ["-m", metadata or self.metadata(), "-p", "asap7", "-d", "gcd"]
        output = io.StringIO()
        with patch.object(
            checkQorMetrics.urllib.request, "urlopen", dashboard
        ), contextlib.redirect_stdout(output):
            code = checkQorMetrics.run_check(argv + list(args))
        return code, output.getvalue(), dashboard.payloads

    def repository(self):
        """A repository with a master commit on origin and an unpushed one after it.

        Returns (repository, master_sha, unpushed_sha).
        """
        repository = os.path.join(self.tmp.name, "repo")
        os.makedirs(repository)
        git(repository, "init", "-q", "-b", "master")
        git(repository, "commit", "-q", "--allow-empty", "-m", "master")
        master = git(repository, "rev-parse", "HEAD")
        git(repository, "update-ref", "refs/remotes/origin/master", master)
        git(repository, "commit", "-q", "--allow-empty", "-m", "local")
        return repository, master, git(repository, "rev-parse", "HEAD")


class PayloadTest(CheckQorMetricsTest):
    def test_checkout_sends_only_the_commit(self):
        code, _, payloads = self.run_check()
        self.assertEqual(code, 0)
        payload = payloads[0]
        self.assertEqual(payload["CommitSha"], COMMIT)
        self.assertEqual(payload["BranchName"], "")
        self.assertEqual(payload["PipelineId"], "")
        self.assertNotIn("JobName", payload)
        self.assertNotIn("BaseCommitSha", payload)
        self.assertEqual(
            (payload["PlatformName"], payload["DesignName"], payload["VariantName"]),
            ("asap7", "gcd", "base"),
        )
        self.assertEqual(payload["Metrics"], {"finish__timing__setup__ws": 1.5})

    def test_branch_is_dropped_without_a_job_name(self):
        _, output, payloads = self.run_check("--branch", "feature")
        self.assertEqual(payloads[0]["BranchName"], "")
        self.assertIn("--branch (DASHBOARD_BRANCH) is ignored", output)

    def test_job_name_sends_the_branch(self):
        _, _, payloads = self.run_check("--job-name", "orfs-ci", "--branch", "feature")
        self.assertEqual(payloads[0]["JobName"], "orfs-ci")
        self.assertEqual(payloads[0]["BranchName"], "feature")

    def test_environment_sets_job_branch_and_commit(self):
        os.environ.update(
            DASHBOARD_JOB_NAME="orfs-ci",
            DASHBOARD_BRANCH="pr-1",
            DASHBOARD_COMMIT=BASE,
        )
        _, _, payloads = self.run_check()
        self.assertEqual(payloads[0]["JobName"], "orfs-ci")
        self.assertEqual(payloads[0]["BranchName"], "pr-1")
        self.assertEqual(payloads[0]["CommitSha"], BASE)

    def test_base_commit_pins_the_baseline(self):
        _, output, payloads = self.run_check("--base-commit", BASE)
        self.assertEqual(payloads[0]["BaseCommitSha"], BASE)
        self.assertIn(f"Baseline pinned to commit {BASE}", output)

    def test_base_commit_from_the_environment(self):
        os.environ["DASHBOARD_BASE_COMMIT"] = BASE
        _, _, payloads = self.run_check()
        self.assertEqual(payloads[0]["BaseCommitSha"], BASE)

    def test_commit_flag_replaces_the_recorded_commit(self):
        _, _, payloads = self.run_check("--commit", BASE.upper())
        self.assertEqual(payloads[0]["CommitSha"], BASE)

    def test_unresolved_recorded_commit_is_sent_empty(self):
        _, output, payloads = self.run_check(
            metadata=self.metadata(commit="not a git repo"),
            dashboard=Dashboard(response(strategy="latest-master")),
        )
        self.assertEqual(payloads[0]["CommitSha"], "")
        self.assertIn("metadata.json records no commit", output)


class CommitValidationTest(CheckQorMetricsTest):
    def test_short_commit_is_rejected_before_any_request(self):
        code, output, payloads = self.run_check("--commit", "abc1234")
        self.assertEqual(code, 1)
        self.assertEqual(payloads, [])
        self.assertIn("is not a full 40-character SHA", output)

    def test_short_base_commit_is_rejected_before_any_request(self):
        code, output, payloads = self.run_check("--base-commit", "abc1234")
        self.assertEqual(code, 1)
        self.assertEqual(payloads, [])
        self.assertIn("--base-commit 'abc1234' is not a full 40-character SHA", output)

    def test_short_base_commit_from_the_environment_is_rejected(self):
        os.environ["DASHBOARD_BASE_COMMIT"] = "abc1234"
        code, _, payloads = self.run_check()
        self.assertEqual(code, 1)
        self.assertEqual(payloads, [])

    def test_base_commit_is_sent_lowercased(self):
        _, _, payloads = self.run_check("--base-commit", f" {BASE.upper()} ")
        self.assertEqual(payloads[0]["BaseCommitSha"], BASE)


class BranchTest(CheckQorMetricsTest):
    def test_branch_comes_from_git(self):
        repository, _, _ = self.repository()
        git(repository, "checkout", "-q", "-b", "feature")
        self.enter(repository)
        _, _, payloads = self.run_check("--job-name", "orfs-ci", "--merge-base", "none")
        self.assertEqual(payloads[0]["BranchName"], "feature")

    def test_branch_flag_beats_git(self):
        repository, _, _ = self.repository()
        self.enter(repository)
        _, _, payloads = self.run_check("--job-name", "orfs-ci", "--branch", "pr-2")
        self.assertEqual(payloads[0]["BranchName"], "pr-2")

    def test_detached_head_reads_as_head(self):
        repository, master, _ = self.repository()
        git(repository, "checkout", "-q", "--detach", master)
        self.enter(repository)
        _, output, payloads = self.run_check("--job-name", "orfs-ci")
        self.assertEqual(payloads[0]["BranchName"], "HEAD")
        self.assertIn(
            "[WARN] Checking as a build of orfs-ci with a detached HEAD", output
        )

    def test_no_branch_outside_a_repository_warns(self):
        _, output, payloads = self.run_check("--job-name", "orfs-ci")
        self.assertEqual(payloads[0]["BranchName"], "")
        self.assertIn("with no branch", output)


class MergeBaseTest(CheckQorMetricsTest):
    def check(self, commit, *args):
        return self.run_check(
            *args,
            metadata=self.metadata(commit=commit),
            dashboard=Dashboard(response(strategy="explicit-commit")),
        )

    def test_unpushed_commit_is_pinned_to_its_merge_base(self):
        repository, master, unpushed = self.repository()
        self.enter(repository)
        code, output, payloads = self.check(unpushed)
        self.assertEqual(code, 0)
        self.assertEqual(payloads[0]["BaseCommitSha"], master)
        self.assertEqual(payloads[0]["CommitSha"], unpushed)
        self.assertIn(f"pinned to its local merge base {master[:12]}", output)

    def test_pushed_commit_is_left_to_the_dashboard(self):
        repository, _, unpushed = self.repository()
        git(repository, "update-ref", "refs/remotes/origin/feature", unpushed)
        self.enter(repository)
        _, _, payloads = self.check(unpushed)
        self.assertNotIn("BaseCommitSha", payloads[0])

    def test_commit_missing_from_the_checkout_is_left_to_the_dashboard(self):
        repository, _, _ = self.repository()
        self.enter(repository)
        _, _, payloads = self.check(COMMIT)
        self.assertNotIn("BaseCommitSha", payloads[0])

    def test_missing_explicit_ref_is_ignored_when_no_pin_applies(self):
        repository, pushed, _ = self.repository()
        self.enter(repository)
        os.environ["DASHBOARD_MERGE_BASE"] = "missing/ref"
        for commit in (pushed, COMMIT, "N/A"):
            with self.subTest(commit=commit):
                code, output, payloads = self.check(commit)
                self.assertEqual(code, 0)
                self.assertTrue(output.rstrip().endswith("QoR check: PASS"))
                self.assertEqual(len(payloads), 1)
                self.assertNotIn("BaseCommitSha", payloads[0])

    def test_pin_warns_with_the_ref(self):
        repository, master, unpushed = self.repository()
        self.enter(repository)
        _, output, _ = self.check(unpushed)
        self.assertIn(
            f"[WARN] {unpushed[:12]} is on no remote, so the baseline was pinned "
            f"to its local merge base {master[:12]} with refs/remotes/origin/master",
            output,
        )

    def test_upstream_master_is_the_default_when_it_exists(self):
        # A fork clone: origin/master is the fork's old master, upstream/master
        # the project's, and the local commit is on the project's.
        repository, old_master, _ = self.repository()
        git(repository, "reset", "-q", "--hard", old_master)
        git(repository, "commit", "-q", "--allow-empty", "-m", "upstream")
        upstream = git(repository, "rev-parse", "HEAD")
        git(repository, "update-ref", "refs/remotes/upstream/master", upstream)
        git(repository, "branch", "upstream/master", old_master)
        git(repository, "commit", "-q", "--allow-empty", "-m", "local")
        unpushed = git(repository, "rev-parse", "HEAD")
        self.enter(repository)
        _, output, payloads = self.check(unpushed)
        self.assertEqual(payloads[0]["BaseCommitSha"], upstream)
        self.assertIn(f"{upstream[:12]} with refs/remotes/upstream/master", output)

    def test_missing_upstream_tracking_ref_falls_back_past_local_tag(self):
        repository, master, unpushed = self.repository()
        git(repository, "tag", "upstream/master", unpushed)
        self.enter(repository)
        _, _, payloads = self.check(unpushed)
        self.assertEqual(payloads[0]["BaseCommitSha"], master)

    def test_no_merge_base_warns_and_sends_no_pin(self):
        repository, _, unpushed = self.repository()
        git(repository, "checkout", "-q", "--orphan", "unrelated")
        git(repository, "commit", "-q", "--allow-empty", "-m", "unrelated")
        unrelated = git(repository, "rev-parse", "HEAD")
        git(repository, "update-ref", "refs/remotes/upstream/master", unrelated)
        self.enter(repository)
        code, output, payloads = self.check(unpushed)
        self.assertEqual(code, 0)
        self.assertEqual(len(payloads), 1)
        self.assertNotIn("BaseCommitSha", payloads[0])
        self.assertIn(
            "[WARN] " + unpushed[:12] + " is on no remote and has no merge base "
            "with refs/remotes/upstream/master, so the baseline was not pinned",
            output,
        )
        self.assertIn("QoR check: PASS", output)

    def test_missing_automatic_ref_warns_and_sends_no_pin(self):
        repository, _, unpushed = self.repository()
        git(repository, "update-ref", "-d", "refs/remotes/origin/master")
        self.enter(repository)
        code, output, payloads = self.check(unpushed)
        self.assertEqual(code, 0)
        self.assertNotIn("BaseCommitSha", payloads[0])
        self.assertIn("[WARN] refs/remotes/origin/master does not exist here", output)

    def test_explicit_missing_ref_is_an_error(self):
        repository, _, unpushed = self.repository()
        self.enter(repository)
        code, output, payloads = self.check(unpushed, "--merge-base", "upstrem/master")
        self.assertEqual(code, 1)
        self.assertEqual(payloads, [])
        self.assertIn("--merge-base upstrem/master does not exist here", output)
        self.assertTrue(output.rstrip().endswith("QoR check: ERROR"))

    def test_explicit_ref_from_the_environment_is_an_error_too(self):
        repository, _, unpushed = self.repository()
        os.environ["DASHBOARD_MERGE_BASE"] = "upstrem/master"
        self.enter(repository)
        code, output, payloads = self.check(unpushed)
        self.assertEqual(code, 1)
        self.assertEqual(payloads, [])
        self.assertIn(
            "DASHBOARD_MERGE_BASE upstrem/master does not exist here", output
        )
        self.assertTrue(output.rstrip().endswith("QoR check: ERROR"))

    def test_explicit_ref_without_shared_history_is_an_error(self):
        repository, _, unpushed = self.repository()
        git(repository, "checkout", "-q", "--orphan", "unrelated")
        git(repository, "commit", "-q", "--allow-empty", "-m", "unrelated")
        git(repository, "branch", "-q", "trunk", "HEAD")
        self.enter(repository)
        code, output, payloads = self.check(unpushed, "--merge-base", "trunk")
        self.assertEqual(code, 1)
        self.assertEqual(payloads, [])
        self.assertIn(
            f"[ERROR] asap7/gcd/base: {unpushed[:12]} has no merge base with "
            "trunk (--merge-base)",
            output,
        )
        self.assertIn("QoR check: ERROR", output)

    def test_failed_remote_lookup_sends_no_pin(self):
        repository, _, unpushed = self.repository()
        self.enter(repository)
        real_git = checkQorMetrics.git

        def git_without_for_each_ref(*args):
            return None if args[0] == "for-each-ref" else real_git(*args)

        for args in ((), ("--merge-base", "missing/ref")):
            with self.subTest(args=args), patch.object(
                checkQorMetrics, "git", git_without_for_each_ref
            ):
                code, output, payloads = self.check(unpushed, *args)
                self.assertEqual(code, 0)
                self.assertNotIn("BaseCommitSha", payloads[0])
                self.assertIn(f"git could not tell whether {unpushed[:12]}", output)

    def test_ref_from_the_environment(self):
        repository, _, unpushed = self.repository()
        git(repository, "branch", "trunk", unpushed)
        os.environ["DASHBOARD_MERGE_BASE"] = "trunk"
        self.enter(repository)
        _, _, payloads = self.check(unpushed)
        self.assertEqual(payloads[0]["BaseCommitSha"], unpushed)

    def test_none_turns_it_off(self):
        repository, _, unpushed = self.repository()
        self.enter(repository)
        os.environ["DASHBOARD_MERGE_BASE"] = "missing/ref"
        _, _, payloads = self.check(unpushed, "--merge-base", "none")
        self.assertNotIn("BaseCommitSha", payloads[0])

    def test_base_commit_wins(self):
        repository, _, unpushed = self.repository()
        self.enter(repository)
        _, _, payloads = self.check(
            unpushed, "--base-commit", BASE, "--merge-base", "missing/ref"
        )
        self.assertEqual(payloads[0]["BaseCommitSha"], BASE)

    def test_job_name_skips_it(self):
        repository, _, unpushed = self.repository()
        self.enter(repository)
        os.environ["DASHBOARD_MERGE_BASE"] = "missing/ref"
        _, _, payloads = self.check(unpushed, "--job-name", "orfs-ci")
        self.assertNotIn("BaseCommitSha", payloads[0])

    def test_merge_base_without_a_build_is_sent_again_unpinned(self):
        repository, master, unpushed = self.repository()
        self.enter(repository)
        code, output, payloads = self.run_check(
            metadata=self.metadata(commit=unpushed),
            dashboard=Dashboard(
                response(status="no_baseline", strategy="none"),
                response(strategy="latest-master"),
            ),
        )
        self.assertEqual(code, 0)
        self.assertEqual(len(payloads), 2)
        self.assertEqual(payloads[0]["BaseCommitSha"], master)
        self.assertNotIn("BaseCommitSha", payloads[1])
        self.assertIn(
            f"merge base {master[:12]} with refs/remotes/origin/master has no "
            "build of this design, so the check was sent again without that pin",
            output,
        )
        self.assertIn("compared against the latest master build", output)
        self.assertIn("QoR check: PASS", output)

    def test_unpinned_retry_keeps_the_pin_warning_and_final_verdict(self):
        repository, master, unpushed = self.repository()
        self.enter(repository)
        no_baseline = response(status="no_baseline", strategy="none")
        for retry, exit_code, verdict in (
            (no_baseline, 2, "INCONCLUSIVE"),
            (response(status="fail", failed=1), 1, "FAIL"),
            ([], 3, "INCONCLUSIVE"),
        ):
            with self.subTest(exit_code=exit_code):
                code, output, payloads = self.run_check(
                    "--strict",
                    metadata=self.metadata(commit=unpushed),
                    dashboard=Dashboard(no_baseline, retry),
                )
                self.assertEqual(code, exit_code)
                self.assertEqual(len(payloads), 2)
                self.assertEqual(payloads[0]["BaseCommitSha"], master)
                self.assertNotIn("BaseCommitSha", payloads[1])
                self.assertIn("the check was sent again without that pin", output)
                self.assertTrue(output.rstrip().endswith(f"QoR check: {verdict}"))

    def test_explicit_base_commit_without_a_build_is_not_sent_again(self):
        repository, _, unpushed = self.repository()
        self.enter(repository)
        code, output, payloads = self.run_check(
            "--base-commit",
            BASE,
            metadata=self.metadata(commit=unpushed),
            dashboard=Dashboard(response(status="no_baseline", strategy="none")),
        )
        self.assertEqual(code, 0)
        self.assertEqual(len(payloads), 1)
        self.assertIn("QoR check: INCONCLUSIVE", output)


class MetricFilterTest(CheckQorMetricsTest):
    def test_non_finite_metrics_are_left_out_and_named(self):
        path = self.metadata(
            finish__timing__setup__ws=1.5,
            finish__timing__setup__tns=float("-inf"),
            detailedroute__route__wirelength=float("nan"),
        )
        _, output, payloads = self.run_check(metadata=path)
        self.assertEqual(payloads[0]["Metrics"], {"finish__timing__setup__ws": 1.5})
        self.assertIn(
            "non-finite metric(s): detailedroute__route__wirelength, "
            "finish__timing__setup__tns",
            output,
        )

    def test_strings_booleans_and_iterations_are_not_sent(self):
        path = self.metadata(
            finish__timing__setup__ws=1.5,
            run__flow__platform="asap7",
            synth__flag=True,
            detailedroute__route__drc_errors__iter__1=3,
        )
        _, _, payloads = self.run_check(metadata=path)
        self.assertEqual(payloads[0]["Metrics"], {"finish__timing__setup__ws": 1.5})

    def test_only_prefix_keeps_matching_metrics(self):
        path = self.metadata(synth__design__area=10, finish__timing__setup__ws=1.5)
        _, _, payloads = self.run_check("--only-prefix", "synth__", metadata=path)
        self.assertEqual(payloads[0]["Metrics"], {"synth__design__area": 10})

    def test_non_finite_metric_outside_the_prefix_is_not_named(self):
        path = self.metadata(
            synth__design__area=10, finish__timing__setup__tns=float("-inf")
        )
        _, output, payloads = self.run_check("--only-prefix", "synth__", metadata=path)
        self.assertEqual(payloads[0]["Metrics"], {"synth__design__area": 10})
        self.assertNotIn("non-finite", output)

    def test_non_finite_metrics_are_named_without_a_baseline(self):
        path = self.metadata(
            finish__timing__setup__ws=1.5, finish__timing__setup__tns=float("-inf")
        )
        _, output, _ = self.run_check(
            metadata=path, dashboard=Dashboard(response(status="no_baseline"))
        )
        self.assertIn("non-finite metric(s): finish__timing__setup__tns", output)

    def test_only_non_finite_metrics_is_an_error_naming_them(self):
        path = self.metadata(
            finish__timing__setup__tns=float("-inf"),
            finish__timing__setup__ws=float("nan"),
        )
        code, output, payloads = self.run_check(metadata=path)
        self.assertEqual(code, 1)
        self.assertEqual(payloads, [])
        self.assertIn(
            "no finite numeric metrics in "
            f"{path}; non-finite: finish__timing__setup__tns, "
            "finish__timing__setup__ws",
            output,
        )

    def test_no_metric_matching_the_prefix_is_an_error_naming_it(self):
        path = self.metadata(finish__timing__setup__ws=1.5)
        code, output, payloads = self.run_check(
            "--only-prefix", "synth__", "constraints__", metadata=path
        )
        self.assertEqual(code, 1)
        self.assertEqual(payloads, [])
        self.assertIn("starts with synth__ or constraints__", output)

    def test_no_numeric_metric_is_an_error(self):
        path = self.metadata(run__flow__platform="asap7")
        code, output, payloads = self.run_check(metadata=path)
        self.assertEqual(code, 1)
        self.assertEqual(payloads, [])
        self.assertIn("no numeric metrics", output)
        self.assertIn("QoR check: ERROR", output)


class ReportTest(CheckQorMetricsTest):
    def test_pass(self):
        code, output, _ = self.run_check()
        self.assertEqual(code, 0)
        self.assertTrue(output.rstrip().endswith("QoR check: PASS"))

    def test_fail_lists_the_failed_rule(self):
        failed = {
            "metricName": "finish__timing__setup__ws",
            "status": "fail",
            "baseValue": 2,
            "targetValue": 1.5,
            "thresholdValue": 1.9,
            "deltaPct": -25,
        }
        code, output, _ = self.run_check(
            dashboard=Dashboard(response(status="fail", failed=1, metrics=[failed]))
        )
        self.assertEqual(code, 1)
        self.assertIn(
            checkQorMetrics.ROW_FMT.format(
                "finish__timing__setup__ws", "2", "1.5000", "1.9000", "-25.00"
            ),
            output,
        )
        self.assertIn("finish__timing__setup__ws 1.5 (base 2, limit 1.9)", output)
        self.assertIn("QoR check: FAIL", output)

    def test_latest_master_warns_with_a_commit(self):
        _, output, _ = self.run_check(
            dashboard=Dashboard(response(strategy="latest-master"))
        )
        self.assertIn(f"merge base of {COMMIT[:12]}", output)
        self.assertIn("DASHBOARD_BASE_COMMIT", output)

    def test_merge_base_does_not_warn(self):
        _, output, _ = self.run_check()
        self.assertNotIn("[WARN]", output)

    def test_inconclusive_exits_0_or_2_with_strict(self):
        reply = response(status="inconclusive")
        code, output, _ = self.run_check(dashboard=Dashboard(reply))
        self.assertEqual(code, 0)
        self.assertIn("QoR check: INCONCLUSIVE", output)
        code, _, _ = self.run_check("--strict", dashboard=Dashboard(reply))
        self.assertEqual(code, 2)

    def test_no_baseline_is_inconclusive(self):
        code, output, _ = self.run_check(
            "--strict", dashboard=Dashboard(response(status="no_baseline"))
        )
        self.assertEqual(code, 2)
        self.assertIn("no baseline to compare against", output)

    def test_unreachable_retries_then_exits_0_or_3_with_strict(self):
        down = urllib.error.URLError("connection refused")
        dashboard = Dashboard(down)
        code, output, payloads = self.run_check(dashboard=dashboard)
        self.assertEqual(code, 0)
        self.assertEqual(len(payloads), checkQorMetrics.RETRY_ATTEMPTS)
        self.assertIn("[WARN] asap7/gcd/base: dashboard not reached", output)
        self.assertNotIn("[ERROR]", output)
        code, _, _ = self.run_check("--strict", dashboard=Dashboard(down))
        self.assertEqual(code, 3)

    def test_transient_error_is_retried(self):
        busy = urllib.error.HTTPError("url", 503, "busy", {}, io.BytesIO(b"try again"))
        self.addCleanup(busy.close)
        code, _, payloads = self.run_check(dashboard=Dashboard(busy, response()))
        self.assertEqual(code, 0)
        self.assertEqual(len(payloads), 2)

    def test_client_error_is_not_retried(self):
        bad = urllib.error.HTTPError("url", 400, "bad", {}, io.BytesIO(b"no"))
        self.addCleanup(bad.close)
        _, output, payloads = self.run_check(dashboard=Dashboard(bad))
        self.assertEqual(len(payloads), 1)
        self.assertIn("HTTP 400: no", output)

    def test_non_object_response_is_unreachable(self):
        code, output, _ = self.run_check("--strict", dashboard=Dashboard([1, 2]))
        self.assertEqual(code, 3)
        self.assertIn("unexpected response type: list", output)


class SweepTest(CheckQorMetricsTest):
    def run_sweep(self, *args, dashboard=None):
        dashboard = dashboard or Dashboard()
        output = io.StringIO()
        with patch.object(
            checkQorMetrics.urllib.request, "urlopen", dashboard
        ), contextlib.redirect_stdout(output):
            code = checkQorMetrics.run_check(list(args))
        return code, output.getvalue(), dashboard.payloads

    def test_sweep_checks_each_run_and_writes_the_log(self):
        self.metadata("reports/asap7/gcd/base/metadata.json")
        self.metadata("reports/nangate45/aes/base/metadata.json")
        os.makedirs("reports/asap7/jpeg/base")
        os.makedirs("reports/asap7/gcd/test_variant")
        code, output, payloads = self.run_sweep()
        self.assertEqual(code, 0)
        self.assertCountEqual(
            [(p["PlatformName"], p["DesignName"]) for p in payloads],
            [("asap7", "gcd"), ("nangate45", "aes")],
        )
        self.assertLess(output.index("asap7/gcd/base"), output.index("nangate45/aes"))
        self.assertIn("No metadata.json for asap7 jpeg base", output)
        with open(checkQorMetrics.LOG_FILENAME, encoding="utf-8") as log_file:
            self.assertIn("QoR check: PASS", log_file.read())

    def test_bad_commit_replaces_a_stale_log(self):
        self.metadata("reports/asap7/gcd/base/metadata.json")
        with open(checkQorMetrics.LOG_FILENAME, "w", encoding="utf-8") as log_file:
            log_file.write("QoR check: PASS\n")
        code, _, payloads = self.run_sweep("--commit", "abc1234")
        self.assertEqual(code, 1)
        self.assertEqual(payloads, [])
        with open(checkQorMetrics.LOG_FILENAME, encoding="utf-8") as log_file:
            log = log_file.read()
        self.assertIn("is not a full 40-character SHA", log)
        self.assertNotIn("QoR check: PASS", log)

    def test_missing_explicit_ref_fails_only_runs_that_need_a_pin(self):
        repository, pushed, unpushed = self.repository()
        self.metadata("repo/reports/asap7/gcd/base/metadata.json", commit=pushed)
        self.metadata("repo/reports/asap7/aes/base/metadata.json", commit=unpushed)
        self.enter(repository)
        code, output, payloads = self.run_sweep("--merge-base", "missing/ref")
        self.assertEqual(code, 1)
        self.assertEqual([p["DesignName"] for p in payloads], ["gcd"])
        self.assertIn("[ERROR] asap7/aes/base:", output)
        with open(checkQorMetrics.LOG_FILENAME, encoding="utf-8") as log_file:
            self.assertTrue(log_file.read().rstrip().endswith("QoR check: ERROR"))

    def test_bad_commit_without_reports_writes_no_log(self):
        code, _, _ = self.run_sweep("--commit", "abc1234")
        self.assertEqual(code, 1)
        self.assertFalse(os.path.exists(checkQorMetrics.REPORTS_FOLDER))

    def test_sweep_filters_by_design(self):
        self.metadata("reports/asap7/gcd/base/metadata.json")
        self.metadata("reports/asap7/aes/base/metadata.json")
        _, _, payloads = self.run_sweep("-d", "aes")
        self.assertEqual([p["DesignName"] for p in payloads], ["aes"])

    def test_no_reports_is_0_or_2_with_strict(self):
        code, _, payloads = self.run_sweep()
        self.assertEqual(code, 0)
        self.assertEqual(payloads, [])
        code, _, _ = self.run_sweep("--strict")
        self.assertEqual(code, 2)


if __name__ == "__main__":
    unittest.main()
