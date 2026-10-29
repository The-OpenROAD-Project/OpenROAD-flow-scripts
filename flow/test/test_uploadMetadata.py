#!/usr/bin/env python3

"""Tests for the Pub/Sub payload that uploadMetadata.py publishes.

uploadMetadata.py does its work at import time (it parses arguments, changes
to flow/ and walks reports/), so it runs here as a subprocess. The script is
copied into a temporary util/ directory next to a temporary reports/ tree,
which makes that tree the one it walks, and stub google.cloud modules on
PYTHONPATH record every published message instead of sending it.
"""

import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import unittest
from datetime import datetime, timezone

SCRIPT = os.path.join(
    os.path.dirname(os.path.abspath(__file__)), "..", "util", "uploadMetadata.py"
)

STUB_PUBSUB = """
import json
import os


class _Future:
    def __init__(self, message_id):
        self._message_id = message_id

    def result(self):
        if os.environ.get("STUB_PUBSUB_FAIL"):
            raise RuntimeError("stub publish failure")
        return self._message_id


class PublisherClient:
    def __init__(self, credentials=None):
        pass

    def topic_path(self, project, topic):
        return f"projects/{project}/topics/{topic}"

    def publish(self, topic_path, data, **attributes):
        with open(os.environ["STUB_PUBSUB_OUT"], "a") as f:
            record = {"data": json.loads(data), "attributes": attributes}
            f.write(json.dumps(record) + "\\n")
        return _Future("stub-id")
"""

STUB_SERVICE_ACCOUNT = """
class Credentials:
    @staticmethod
    def from_service_account_file(path):
        return None
"""

BUILD_TIME_FORMAT = re.compile(r"^\d{4}-\d{2}-\d{2} \d{2}:\d{2}$")

REQUESTER_ENV = ("UPLOAD_BUILD_USER_EMAIL", "UPLOAD_CHANGE_AUTHOR_EMAIL")

# Large enough to push the pipeline payload over the 8 MB cap, so the script
# falls back to one v1 message per design.
OVERSIZED_METRICS = {"blob": "x" * (9 * 1024 * 1024)}


class TestUploadMetadata(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        root = self.tmp.name
        self.flow = os.path.join(root, "flow")
        os.makedirs(os.path.join(self.flow, "util"))
        os.makedirs(os.path.join(self.flow, "reports"))
        shutil.copy(SCRIPT, os.path.join(self.flow, "util"))

        stubs = os.path.join(root, "stubs")
        files = {
            "google/__init__.py": "",
            "google/cloud/__init__.py": "",
            "google/cloud/pubsub_v1.py": STUB_PUBSUB,
            "google/oauth2/__init__.py": "",
            "google/oauth2/service_account.py": STUB_SERVICE_ACCOUNT,
        }
        for rel, content in files.items():
            path = os.path.join(stubs, rel)
            os.makedirs(os.path.dirname(path), exist_ok=True)
            with open(path, "w") as f:
                f.write(content)
        self.stubs = stubs
        self.out = os.path.join(root, "published.jsonl")

    def tearDown(self):
        self.tmp.cleanup()

    def add_design(self, platform, design, variant="base", metrics=None):
        report_dir = os.path.join(self.flow, "reports", platform, design, variant)
        os.makedirs(report_dir)
        with open(os.path.join(report_dir, "metadata.json"), "w") as f:
            json.dump(metrics or {"finish:area": 1.0}, f)

    def run_script(self, *extra, fail=False, tz=None, extra_env=None):
        env = dict(os.environ)
        for name in REQUESTER_ENV:
            env.pop(name, None)
        env.update(extra_env or {})
        if tz:
            env["TZ"] = tz
        env["PYTHONPATH"] = self.stubs
        env["STUB_PUBSUB_OUT"] = self.out
        if fail:
            env["STUB_PUBSUB_FAIL"] = "1"
        cmd = [
            sys.executable,
            os.path.join(self.flow, "util", "uploadMetadata.py"),
            "--buildID",
            "42",
            "--branchName",
            "master",
            "--pipelineID",
            "jenkins-ORFS-master-42",
            "--commitSHA",
            "abc123",
            "--jenkinsURL",
            "http://jenkins/job/ORFS/42/",
            "--jenkinsEnv",
            "public",
            "--pubsubProjectID",
            "test-project",
            *extra,
        ]
        result = subprocess.run(cmd, env=env, capture_output=True, text=True)
        messages = []
        if os.path.exists(self.out):
            with open(self.out) as f:
                messages = [json.loads(line) for line in f]
        return result, messages

    def test_empty_designs_publishes_report(self):
        result, messages = self.run_script(
            "--jobName",
            "ORFS",
            "--buildTime",
            "2026-10-05 12:34",
            "--expectedDesigns",
            "12",
            "--noMetricsReason",
            "  flow failed before metrics  ",
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(len(messages), 1)
        payload = messages[0]["data"]
        self.assertEqual(payload["designs"], [])
        self.assertEqual(payload["payload_schema_version"], 3)
        self.assertEqual(payload["build_time"], "2026-10-05 12:34")
        self.assertEqual(payload["design_count"], 12)
        self.assertEqual(payload["no_metrics_reason"], "flow failed before metrics")
        self.assertEqual(messages[0]["attributes"]["payload_schema_version"], "3")
        self.assertIn("[WARN] No design records were collected", result.stdout)

    def test_empty_designs_without_new_flags(self):
        result, messages = self.run_script()
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(len(messages), 1)
        payload = messages[0]["data"]
        self.assertEqual(payload["designs"], [])
        self.assertEqual(payload["payload_schema_version"], 2)
        self.assertRegex(payload["build_time"], BUILD_TIME_FORMAT)
        self.assertNotIn("design_count", payload)
        self.assertNotIn("no_metrics_reason", payload)

    def test_blank_reason_is_omitted(self):
        result, messages = self.run_script("--noMetricsReason", "   ")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertNotIn("no_metrics_reason", messages[0]["data"])

    def test_empty_designs_failed_publish_exits_nonzero(self):
        result, _ = self.run_script(fail=True)
        self.assertEqual(result.returncode, 1, result.stdout + result.stderr)
        self.assertIn("[ERROR] Pub/Sub publish failed", result.stdout)

    def test_default_build_time_is_utc(self):
        # Far from UTC, so a local-time default could not pass by accident.
        before = datetime.now(timezone.utc).replace(second=0, microsecond=0)
        result, messages = self.run_script(tz="Pacific/Kiritimati")
        after = datetime.now(timezone.utc)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        build_time = datetime.strptime(
            messages[0]["data"]["build_time"], "%Y-%m-%d %H:%M"
        ).replace(tzinfo=timezone.utc)
        self.assertTrue(before <= build_time <= after, build_time)

    def test_designs_payload_gains_build_time_only(self):
        self.add_design("nangate45", "gcd", metrics={"finish:area": 5.0})
        result, messages = self.run_script(
            "--jobName", "ORFS", "--noMetricsReason", "ignored"
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(len(messages), 1)
        payload = messages[0]["data"]
        self.assertRegex(payload.pop("build_time"), BUILD_TIME_FORMAT)
        self.assertEqual(
            payload,
            {
                "payload_schema_version": 3,
                "jenkins_env": "public",
                "build_id": "42",
                "branch_name": "master",
                "pipeline_id": "jenkins-ORFS-master-42",
                "change_branch": None,
                "commit_sha": "abc123",
                "jenkins_url": "http://jenkins/job/ORFS/42/",
                "job_name": "ORFS",
                "designs": [
                    {
                        "platform": "nangate45",
                        "design": "gcd",
                        "variant": "base",
                        "metrics": {"finish__area": 5.0},
                    }
                ],
            },
        )
        self.assertNotIn("empty (no-metrics)", result.stdout)
        self.assertIn(
            "[WARN] Ignoring --noMetricsReason because design records were collected",
            result.stdout,
        )

    def test_blank_build_time_defaults_to_now(self):
        result, messages = self.run_script("--buildTime", "  ")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertRegex(messages[0]["data"]["build_time"], BUILD_TIME_FORMAT)

    def test_malformed_build_time_is_rejected(self):
        result, messages = self.run_script("--buildTime", "2026-10-05T12:34:56Z")
        self.assertEqual(result.returncode, 2, result.stdout + result.stderr)
        self.assertIn("expected format", result.stderr)
        self.assertEqual(messages, [])

    def test_negative_expected_designs_is_rejected(self):
        result, messages = self.run_script("--expectedDesigns", "-1")
        self.assertEqual(result.returncode, 2, result.stdout + result.stderr)
        self.assertIn("is negative", result.stderr)
        self.assertEqual(messages, [])

    def test_zero_expected_designs_is_not_sent(self):
        result, messages = self.run_script("--expectedDesigns", "0")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertNotIn("design_count", messages[0]["data"])

    def test_unpadded_build_time_is_normalized(self):
        result, messages = self.run_script("--buildTime", "2026-1-5 1:3")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(messages[0]["data"]["build_time"], "2026-01-05 01:03")

    def test_reason_at_length_limit_is_kept(self):
        reason = "x" * 100
        result, messages = self.run_script("--noMetricsReason", reason)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(messages[0]["data"]["no_metrics_reason"], reason)

    def test_overlong_reason_is_dropped_with_warning(self):
        result, messages = self.run_script("--noMetricsReason", "x" * 101)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertNotIn("no_metrics_reason", messages[0]["data"])
        self.assertIn("longer than 100 characters", result.stdout)

    def test_report_dir_without_data_file_is_skipped(self):
        self.add_design("nangate45", "gcd")
        os.makedirs(os.path.join(self.flow, "reports", "nangate45", "aes", "base"))
        result, messages = self.run_script("--expectedDesigns", "2")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        payload = messages[0]["data"]
        self.assertEqual([d["design"] for d in payload["designs"]], ["gcd"])
        self.assertEqual(payload["design_count"], 2)
        self.assertIn("[WARN] No data file for nangate45 aes base.", result.stdout)

    def test_failed_flow_without_data_files_publishes_empty_report(self):
        os.makedirs(os.path.join(self.flow, "reports", "nangate45", "gcd", "base"))
        result, messages = self.run_script(
            "--expectedDesigns", "1", "--noMetricsReason", "no_reports_found"
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(len(messages), 1)
        payload = messages[0]["data"]
        self.assertEqual(payload["designs"], [])
        self.assertEqual(payload["no_metrics_reason"], "no_reports_found")

    def test_only_skipped_platforms_publishes_empty_report(self):
        self.add_design("sky130hd_fakestack", "gcd")
        self.add_design("src", "gcd")
        result, messages = self.run_script()
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(len(messages), 1)
        self.assertEqual(messages[0]["data"]["designs"], [])
        self.assertIn(
            "[WARN] Skiping upload sky130hd_fakestack gcd base.", result.stdout
        )
        self.assertIn("[WARN] No design records were collected", result.stdout)

    def test_v1_fallback_warns_that_design_count_is_dropped(self):
        # Large enough to push the pipeline payload over the 8 MB cap.
        self.add_design("nangate45", "gcd", metrics={"blob": "x" * (9 * 1024 * 1024)})
        result, messages = self.run_script("--expectedDesigns", "3")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(len(messages), 1)
        self.assertNotIn("payload_schema_version", messages[0]["data"])
        self.assertNotIn("design_count", messages[0]["data"])
        self.assertIn("[WARN] --expectedDesigns is not sent", result.stdout)

    def test_design_count_with_designs(self):
        self.add_design("nangate45", "gcd")
        result, messages = self.run_script("--expectedDesigns", "3")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        payload = messages[0]["data"]
        self.assertEqual(payload["design_count"], 3)
        self.assertEqual(len(payload["designs"]), 1)

    def test_empty_designs_invalid_provenance_falls_back_to_v3(self):
        bad = os.path.join(self.tmp.name, "provenance.json")
        with open(bad, "w") as f:
            f.write("[]")
        result, messages = self.run_script("--jobName", "ORFS", "--provenanceFile", bad)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        payload = messages[0]["data"]
        self.assertEqual(payload["payload_schema_version"], 3)
        self.assertEqual(payload["designs"], [])
        self.assertNotIn("submodules", payload)

    def test_empty_designs_valid_provenance_is_v4(self):
        good = os.path.join(self.tmp.name, "provenance.json")
        with open(good, "w") as f:
            json.dump(
                {
                    "jenkins_library": {"ref": "v1.0.0"},
                    "submodules": [
                        {"path": "tools/OpenROAD", "sha": "def456", "overridden": False}
                    ],
                },
                f,
            )
        result, messages = self.run_script(
            "--jobName", "ORFS", "--provenanceFile", good
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        payload = messages[0]["data"]
        self.assertEqual(payload["payload_schema_version"], 4)
        self.assertEqual(payload["designs"], [])
        self.assertEqual(payload["jenkins_library"], {"ref": "v1.0.0"})

    def test_pipeline_payload_without_requester_is_unchanged(self):
        self.add_design("nangate45", "gcd", metrics={"finish:area": 5.0})
        result, messages = self.run_script("--jobName", "ORFS")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        payload = messages[0]["data"]
        self.assertRegex(payload.pop("build_time"), BUILD_TIME_FORMAT)
        self.assertEqual(
            payload,
            {
                "payload_schema_version": 3,
                "jenkins_env": "public",
                "build_id": "42",
                "branch_name": "master",
                "pipeline_id": "jenkins-ORFS-master-42",
                "change_branch": None,
                "commit_sha": "abc123",
                "jenkins_url": "http://jenkins/job/ORFS/42/",
                "job_name": "ORFS",
                "designs": [
                    {
                        "platform": "nangate45",
                        "design": "gcd",
                        "variant": "base",
                        "metrics": {"finish__area": 5.0},
                    }
                ],
            },
        )

    def test_v1_message_without_requester_is_unchanged(self):
        self.add_design("nangate45", "gcd", metrics=OVERSIZED_METRICS)
        result, messages = self.run_script()
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(len(messages), 1)
        payload = messages[0]["data"]
        self.assertEqual(payload.pop("blob"), OVERSIZED_METRICS["blob"])
        self.assertEqual(
            payload,
            {
                "build_id": "42",
                "branch_name": "master",
                "pipeline_id": "jenkins-ORFS-master-42",
                "change_branch": None,
                "commit_sha": "abc123",
                "jenkins_url": "http://jenkins/job/ORFS/42/",
                "jenkins_env": "public",
            },
        )

    def test_both_requester_flags_reach_pipeline_payload(self):
        self.add_design("nangate45", "gcd")
        result, messages = self.run_script(
            "--buildUserEmail",
            " ada@example.com ",
            "--changeAuthorEmail",
            "bob@example.com",
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        payload = messages[0]["data"]
        self.assertEqual(payload["build_user_email"], "ada@example.com")
        self.assertEqual(payload["change_author_email"], "bob@example.com")
        self.assertEqual(payload["payload_schema_version"], 2)

    def test_both_requester_flags_reach_v1_messages(self):
        self.add_design("nangate45", "gcd", metrics=OVERSIZED_METRICS)
        result, messages = self.run_script(
            "--buildUserEmail",
            "ada@example.com",
            "--changeAuthorEmail",
            "bob@example.com",
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        payload = messages[0]["data"]
        self.assertEqual(payload["build_user_email"], "ada@example.com")
        self.assertEqual(payload["change_author_email"], "bob@example.com")

    def test_blank_requester_flag_is_omitted(self):
        self.add_design("nangate45", "gcd")
        result, messages = self.run_script(
            "--buildUserEmail", "   ", "--changeAuthorEmail", "bob@example.com"
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        payload = messages[0]["data"]
        self.assertNotIn("build_user_email", payload)
        self.assertEqual(payload["change_author_email"], "bob@example.com")

    def test_blank_requester_flag_is_omitted_from_v1_messages(self):
        self.add_design("nangate45", "gcd", metrics=OVERSIZED_METRICS)
        result, messages = self.run_script(
            "--buildUserEmail", "ada@example.com", "--changeAuthorEmail", ""
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        payload = messages[0]["data"]
        self.assertEqual(payload["build_user_email"], "ada@example.com")
        self.assertNotIn("change_author_email", payload)

    def test_requester_without_at_sign_is_dropped(self):
        self.add_design("nangate45", "gcd")
        result, messages = self.run_script(
            "--buildUserEmail", "null", "--changeAuthorEmail", "None"
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        payload = messages[0]["data"]
        self.assertNotIn("build_user_email", payload)
        self.assertNotIn("change_author_email", payload)
        self.assertIn("[WARN] Not sending --buildUserEmail: 'null'", result.stdout)
        self.assertIn("[WARN] Not sending --changeAuthorEmail: 'None'", result.stdout)

    def test_v1_fallback_warns_about_requester_once(self):
        self.add_design("nangate45", "gcd", metrics=OVERSIZED_METRICS)
        result, messages = self.run_script("--buildUserEmail", "null")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertNotIn("build_user_email", messages[0]["data"])
        self.assertEqual(result.stdout.count("Not sending --buildUserEmail"), 1)

    def test_requester_is_read_from_environment(self):
        self.add_design("nangate45", "gcd")
        result, messages = self.run_script(
            extra_env={
                "UPLOAD_BUILD_USER_EMAIL": "ada@example.com",
                "UPLOAD_CHANGE_AUTHOR_EMAIL": " bob@example.com ",
            }
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        payload = messages[0]["data"]
        self.assertEqual(payload["build_user_email"], "ada@example.com")
        self.assertEqual(payload["change_author_email"], "bob@example.com")

    def test_requester_flag_overrides_environment(self):
        self.add_design("nangate45", "gcd")
        result, messages = self.run_script(
            "--buildUserEmail",
            "ada@example.com",
            extra_env={"UPLOAD_BUILD_USER_EMAIL": "other@example.com"},
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(messages[0]["data"]["build_user_email"], "ada@example.com")

    def test_empty_requester_flag_suppresses_environment(self):
        self.add_design("nangate45", "gcd")
        result, messages = self.run_script(
            "--buildUserEmail",
            "",
            extra_env={"UPLOAD_BUILD_USER_EMAIL": "ada@example.com"},
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertNotIn("build_user_email", messages[0]["data"])

    def test_environment_requester_is_validated(self):
        self.add_design("nangate45", "gcd")
        result, messages = self.run_script(
            extra_env={"UPLOAD_BUILD_USER_EMAIL": "null"}
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertNotIn("build_user_email", messages[0]["data"])
        self.assertIn("[WARN] Not sending --buildUserEmail: 'null'", result.stdout)

    def test_environment_requester_reaches_v1_messages(self):
        self.add_design("nangate45", "gcd", metrics=OVERSIZED_METRICS)
        result, messages = self.run_script(
            extra_env={"UPLOAD_CHANGE_AUTHOR_EMAIL": "bob@example.com"}
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(messages[0]["data"]["change_author_email"], "bob@example.com")

    def test_requester_keys_win_over_same_named_v1_metric(self):
        metrics = dict(OVERSIZED_METRICS, build_user_email="metric")
        self.add_design("nangate45", "gcd", metrics=metrics)
        result, messages = self.run_script("--buildUserEmail", "ada@example.com")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(messages[0]["data"]["build_user_email"], "ada@example.com")

    def test_no_publisher_publishes_nothing(self):
        env = dict(os.environ)
        env["PYTHONPATH"] = self.stubs
        env["STUB_PUBSUB_OUT"] = self.out
        result = subprocess.run(
            [sys.executable, os.path.join(self.flow, "util", "uploadMetadata.py")],
            env=env,
            capture_output=True,
            text=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertFalse(os.path.exists(self.out))


if __name__ == "__main__":
    unittest.main()
