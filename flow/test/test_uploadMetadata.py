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
import shutil
import subprocess
import sys
import tempfile
import unittest

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

    def run_script(self, *extra, extra_env=None):
        env = dict(os.environ)
        for name in REQUESTER_ENV:
            env.pop(name, None)
        env.update(extra_env or {})
        env["PYTHONPATH"] = self.stubs
        env["STUB_PUBSUB_OUT"] = self.out
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

    def test_pipeline_payload_without_requester_is_unchanged(self):
        self.add_design("nangate45", "gcd", metrics={"finish:area": 5.0})
        result, messages = self.run_script("--jobName", "ORFS")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        payload = messages[0]["data"]
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


if __name__ == "__main__":
    unittest.main()
