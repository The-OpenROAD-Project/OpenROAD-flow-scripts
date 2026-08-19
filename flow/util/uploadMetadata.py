#!/usr/bin/env python3

import json
import argparse
import os
from datetime import datetime, timezone

# --- FIRESTORE (remove when deprecating) ---
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# --- END FIRESTORE ---

# --- PUBSUB ---
from google.cloud import pubsub_v1
from google.oauth2 import service_account

# --- END PUBSUB ---

# Remember where we were invoked from: the chdir below would otherwise silently
# reinterpret any relative path passed on the command line as relative to flow/.
INVOCATION_DIR = os.getcwd()

# make sure the working dir is flow/
os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))

# Create the argument parser
parser = argparse.ArgumentParser(description="Process some integers.")

# Add the named arguments
parser.add_argument("--buildID", type=str, help="Build ID from jenkins")
parser.add_argument("--branchName", type=str, help="Current Branch Name")
parser.add_argument("--pipelineID", type=str, help="Jenkins pipeline ID")
parser.add_argument("--commitSHA", type=str, help="Current commit sha")
parser.add_argument("--jenkinsURL", type=str, help="Jenkins Report URL")
parser.add_argument(
    "--changeBranch", type=str, help="Branch corresponding to change request"
)
parser.add_argument("--cred", type=str, help="Service account credentials file")
parser.add_argument("--variant", type=str, default="base")
parser.add_argument(
    "--jobName",
    type=str,
    default=None,
    help="Canonical Jenkins job-folder name (JOB_NAME with the trailing "
    "/<branch> segment stripped, folder slashes kept). When set, the "
    "Pub/Sub payload is emitted as schema v3 with a top-level job_name "
    "so the backend resolves the pipeline directly instead of "
    "classifying the BUILD_TAG.",
)
parser.add_argument(
    "--provenanceFile",
    type=str,
    default=None,
    help="Path to a JSON file describing what was actually built: the "
    "jenkins-ci shared-library version and the submodule commits present in "
    "the build workspace. Must be produced there, not here — nightly "
    "pipelines repoint tools/OpenROAD, so the reporting workspace holds the "
    "pinned commit rather than the built one. When supplied alongside "
    "--jobName the payload is emitted as schema v4.",
)

# --- PUBSUB args ---
parser.add_argument(
    "--jenkinsEnv",
    type=str,
    default="unknown",
    choices=["public", "secure", "unknown"],
    help="Jenkins environment (public or secure)",
)
parser.add_argument("--pubsubProjectID", type=str, help="GCP project ID for Pub/Sub")
parser.add_argument(
    "--pubsubTopicID",
    type=str,
    default="ci-metrics-reports-topics",
    help="Pub/Sub topic ID",
)
parser.add_argument(
    "--pubsubCred", type=str, help="Service account credentials file for Pub/Sub"
)
# --- END PUBSUB args ---

# Parse the arguments
args = parser.parse_args()


# --- FIRESTORE (remove when deprecating) ---
def upload_data(db, dataFile, platform, design, variant, args, rules):
    # Set the document data
    key = args.commitSHA + "-" + platform + "-" + design + "-" + variant
    doc_ref = db.collection("build_metrics").document(key)
    doc_ref.set(
        {
            "build_id": args.buildID,
            "branch_name": args.branchName,
            "pipeline_id": args.pipelineID,
            "change_branch": args.changeBranch,
            "commit_sha": args.commitSHA,
            "jenkins_url": args.jenkinsURL,
            "rules": rules,
        }
    )

    # Load JSON data from file
    with open(dataFile) as f:
        data = json.load(f)

    # Replace the character ':' in the keys
    new_data = {}
    stages = []
    excludes = ["run", "commit", "total_time", "constraints"]
    gen_date = datetime.now()
    for k, v in data.items():
        new_key = k.replace(":", "__")  # replace ':' with '__'
        new_data[new_key] = v
        stage_name = k.split("__")[0]
        if stage_name not in excludes:
            stages.append(stage_name)
        if k == "run__flow__generate_date":
            # Convert string to datetime
            gen_date = datetime.strptime(v, "%Y-%m-%d %H:%M")
            new_data[k] = gen_date
    stages = set(stages)
    new_data["stages"] = stages

    # Set the data to the document in Firestore
    doc_ref.update(new_data)

    branch_doc_ref = db.collection("branches").document(args.branchName)
    # check if date is greater than the one in the document if it exists
    if branch_doc_ref.get().exists:
        current_date = branch_doc_ref.get().to_dict().get("run__flow__generate_date")
        current_date = current_date.replace(tzinfo=timezone.utc)
        gen_date = gen_date.replace(tzinfo=timezone.utc)
        if current_date is not None and gen_date > current_date:
            branch_doc_ref.update(
                {
                    "run__flow__generate_date": gen_date,
                    "jenkins_url": args.jenkinsURL,
                    "change_branch": args.changeBranch,
                }
            )
        else:
            branch_doc_ref.update(
                {
                    "jenkins_url": args.jenkinsURL,
                    "change_branch": args.changeBranch,
                }
            )
    else:
        branch_doc_ref.set(
            {
                "name": args.branchName,
                "run__flow__generate_date": gen_date,
                "jenkins_url": args.jenkinsURL,
            }
        )

    commit_doc_ref = db.collection("commits").document(args.commitSHA)
    if commit_doc_ref.get().exists:
        current_date = commit_doc_ref.get().to_dict().get("run__flow__generate_date")
        current_date = current_date.replace(tzinfo=timezone.utc)
        gen_date = gen_date.replace(tzinfo=timezone.utc)
        if current_date is not None and gen_date > current_date:
            commit_doc_ref.update(
                {
                    "run__flow__generate_date": gen_date,
                    "jenkins_url": args.jenkinsURL,
                }
            )
        else:
            commit_doc_ref.update(
                {
                    "jenkins_url": args.jenkinsURL,
                }
            )
    else:
        commit_doc_ref.set(
            {
                "sha": args.commitSHA,
                "run__flow__generate_date": gen_date,
                "jenkins_url": args.jenkinsURL,
            }
        )

    platform_doc_ref = db.collection("platforms").document(platform)
    if platform_doc_ref.get().exists:
        designs = platform_doc_ref.get().to_dict().get("designs")
        if design not in designs:
            design_ref = {
                "name": design,
                "rules": rules,
            }
            designs[design] = design_ref
            platform_doc_ref.update(
                {
                    "designs": designs,
                }
            )
    else:
        designs = {}
        design_ref = {
            "name": design,
            "rules": rules,
        }
        designs[design] = design_ref
        platform_doc_ref.set(
            {
                "designs": designs,
                "name": platform,
            }
        )

    if (
        not doc_ref.get().exists
        or not branch_doc_ref.get().exists
        or not commit_doc_ref.get().exists
        or not platform_doc_ref.get().exists
    ):
        raise Exception(f"Failed to upload data for {platform} {design} {variant}.")


# --- END FIRESTORE ---


# --- PUBSUB ---
# Pub/Sub hard cap is 10 MB. Stay under with safety margin to leave room for
# attribute overhead and future payload growth.
MAX_PUBSUB_BYTES = 8 * 1024 * 1024


def build_design_record(dataFile, platform, design, variant, rules):
    """Return a dict for one design to be included in the pipeline-level payload."""
    with open(dataFile) as f:
        data = json.load(f)
    metrics = {k.replace(":", "__"): v for k, v in data.items()}
    return {
        "platform": platform,
        "design": design,
        "variant": variant,
        "rules": rules,
        "metrics": metrics,
    }


def _submodule_defect(entry):
    """Describe why ``entry`` is not a usable submodule record, or ``None``.

    Mirrors the keys the backend requires of every element of the v4
    ``submodules`` array. ``overridden`` is checked for presence only: ``False``
    is the common, valid case.
    """
    if not isinstance(entry, dict):
        return "is not an object"

    for key in ("path", "sha"):
        value = entry.get(key)
        if not isinstance(value, str) or not value.strip():
            return f"has no {key}"

    if entry.get("overridden") is None:
        return "has no overridden"

    return None


def load_provenance(path):
    """Return the build-provenance dict from ``path``, or ``None``.

    A malformed or unreadable file degrades to v3 rather than failing the upload:
    losing the whole metrics report over missing provenance would be a worse
    outcome than losing the provenance.
    """
    if not path:
        return None

    # Relative paths are resolved against the caller's directory, not flow/.
    if not os.path.isabs(path):
        path = os.path.join(INVOCATION_DIR, path)

    try:
        with open(path) as f:
            data = json.load(f)
    except (OSError, ValueError) as e:
        print(
            f"[WARN] Could not read provenance file '{path}': {e}. "
            "Falling back to v3."
        )
        return None

    # json.load accepts any top-level JSON value: a file holding a list or a
    # bare scalar parses fine, then .get() below raises AttributeError.
    if not isinstance(data, dict):
        print(
            f"[WARN] Provenance file '{path}' does not contain a JSON object. "
            "Falling back to v3."
        )
        return None

    submodules = data.get("submodules")
    library = data.get("jenkins_library")
    if not isinstance(submodules, list) or not submodules:
        print(f"[WARN] Provenance file '{path}' has no submodules. Falling back to v3.")
        return None
    if not isinstance(library, dict) or not library.get("ref"):
        print(
            f"[WARN] Provenance file '{path}' has no jenkins_library.ref. "
            "Falling back to v3."
        )
        return None

    # Every entry has to satisfy the backend's per-entry v4 keys, not just the
    # array as a whole: one defective entry rejects the whole message, and the
    # point of degrading to v3 is to not emit a message the backend will reject.
    for i, entry in enumerate(submodules):
        defect = _submodule_defect(entry)
        if defect:
            print(
                f"[WARN] Provenance file '{path}': submodules[{i}] {defect}. "
                "Falling back to v3."
            )
            return None

    return {"jenkins_library": library, "submodules": submodules}


def resolve_job_name(args):
    """Canonical job name, or None when absent/blank."""
    return args.jobName.strip() if args.jobName else None


def resolve_schema_version(args, provenance):
    """The schema version this run's payload satisfies.

    v4 needs both a job name and provenance; the backend requires every v4 key,
    so a run that could not capture its submodules must stay on v3 rather than
    emit a v4 message the backend will reject.
    """
    if not resolve_job_name(args):
        return 2
    return 4 if provenance else 3


def build_pipeline_payload(design_records, args, provenance=None):
    """Return the pipeline-level payload dict.

    Emits schema v2 (no job name), v3 (job name) or v4 (job name plus build
    provenance) — see :func:`resolve_schema_version`.
    """
    job_name = resolve_job_name(args)
    schema_version = resolve_schema_version(args, provenance)
    payload = {
        "payload_schema_version": schema_version,
        "jenkins_env": args.jenkinsEnv,
        "build_id": args.buildID,
        "branch_name": args.branchName,
        "pipeline_id": args.pipelineID,
        "change_branch": args.changeBranch,
        "commit_sha": args.commitSHA,
        "jenkins_url": args.jenkinsURL,
        "designs": design_records,
    }
    if job_name:
        payload["job_name"] = job_name
    # Only a v4 payload carries provenance. Provenance without a job name cannot
    # be v4 (the backend requires job_name from v3 up), and attaching v4 keys to
    # a message labelled v2 would make payload_schema_version stop describing
    # the payload.
    if schema_version == 4:
        payload.update(provenance)
    return payload


def publish_pipeline_report(
    publisher, topic_path, message_data, design_count, args, provenance=None
):
    """Publish a pre-encoded pipeline message (v2, v3 or v4)."""
    size_kb = len(message_data) / 1024
    schema_version = str(resolve_schema_version(args, provenance))
    print(
        f"[INFO] Publishing v{schema_version} pipeline report "
        f"({design_count} designs, {size_kb:.1f} KB) to Pub/Sub."
    )
    future = publisher.publish(
        topic_path,
        data=message_data,
        payload_schema_version=schema_version,
        jenkins_env=args.jenkinsEnv,
    )
    message_id = future.result()
    print(f"[INFO] Published pipeline report to Pub/Sub (message ID: {message_id}).")


def publish_v1_per_design(publisher, topic_path, design_records, args, provenance=None):
    """Fallback path used when the v2 pipeline payload exceeds MAX_PUBSUB_BYTES.

    Emits one v1-format message per design (no payload_schema_version, metrics
    flattened at the root), matching the legacy schema the ingestion service
    still supports.

    Provenance is mirrored onto every message: all of them resolve to the same
    build, and the backend upserts components by path, so N copies converge on
    one set of rows. Omitting it here would make an oversized nightly look like
    a build with no overrides.

    Unlike the pipeline payload this is not gated on the v4 job-name
    requirement: a v1 message declares no schema version, so there is nothing
    for the extra keys to contradict, and the backend reads provenance here by
    key presence rather than by version.
    """
    futures = []
    for d in design_records:
        payload = {
            "build_id": args.buildID,
            "branch_name": args.branchName,
            "pipeline_id": args.pipelineID,
            "change_branch": args.changeBranch,
            "commit_sha": args.commitSHA,
            "jenkins_url": args.jenkinsURL,
            "jenkins_env": args.jenkinsEnv,
            "rules": d["rules"],
        }
        if provenance:
            payload.update(provenance)
        payload.update(d["metrics"])

        message_data = json.dumps(payload, default=str).encode("utf-8")
        try:
            future = publisher.publish(
                topic_path,
                data=message_data,
                jenkins_env=args.jenkinsEnv,
            )
            futures.append((d, future))
        except Exception as e:
            print(
                f"[WARN] Pub/Sub v1 fallback publish failed for "
                f"{d['platform']} {d['design']} {d['variant']}: {e}"
            )

    for d, future in futures:
        try:
            message_id = future.result()
            print(
                f"[INFO] Published v1 fallback message (ID: {message_id}) for "
                f"{d['platform']} {d['design']} {d['variant']}."
            )
        except Exception as e:
            print(
                f"[WARN] Pub/Sub v1 fallback publish failed for "
                f"{d['platform']} {d['design']} {d['variant']}: {e}"
            )


# --- END PUBSUB ---


def get_rules(dataFile):
    data = {}
    if os.path.exists(dataFile):
        with open(dataFile) as f:
            data = json.load(f)

    return data


# --- FIRESTORE init (remove when deprecating) ---
db = None
if args.cred:
    firebase_admin.initialize_app(credentials.Certificate(args.cred))
    db = firestore.client()
# --- END FIRESTORE init ---

# --- PUBSUB init ---
publisher = None
topic_path = None
if args.pubsubCred and args.pubsubProjectID:
    pubsub_credentials = service_account.Credentials.from_service_account_file(
        args.pubsubCred
    )
    publisher = pubsub_v1.PublisherClient(credentials=pubsub_credentials)
    topic_path = publisher.topic_path(args.pubsubProjectID, args.pubsubTopicID)
    print(f"[INFO] Pub/Sub publisher initialized for topic: {topic_path}")
elif args.pubsubProjectID:
    # No credentials file — use default credentials (e.g., emulator or ADC)
    publisher = pubsub_v1.PublisherClient()
    topic_path = publisher.topic_path(args.pubsubProjectID, args.pubsubTopicID)
    print(
        f"[INFO] Pub/Sub publisher initialized (default creds) for topic: {topic_path}"
    )
# --- END PUBSUB init ---

RUN_FILENAME = "metadata.json"

# --- PUBSUB ---
design_records = []
# --- END PUBSUB ---

for reportDir, dirs, files in sorted(os.walk("reports", topdown=False)):
    dirList = reportDir.split(os.sep)
    if len(dirList) != 4:
        continue

    # basic info about test design
    platform = dirList[1]
    design = dirList[2]
    variant = dirList[3]
    dataFile = os.path.join(reportDir, RUN_FILENAME)
    if not os.path.exists(dataFile):
        print(f"[WARN] No data file for {platform} {design} {variant}.")
        continue
    if platform == "sky130hd_fakestack" or platform == "src":
        print(f"[WARN] Skiping upload {platform} {design} {variant}.")
        continue
    print(f"[INFO] Get rules for {platform} {design} {variant}.")
    rules = get_rules(
        os.path.join("designs", platform, design, f"rules-{variant}.json")
    )

    # --- FIRESTORE (remove when deprecating) ---
    if db:
        print(f"[INFO] Upload data for {platform} {design} {variant}.")
        upload_data(db, dataFile, platform, design, variant, args, rules)
    # --- END FIRESTORE ---

    # --- PUBSUB ---
    if publisher:
        design_records.append(
            build_design_record(dataFile, platform, design, variant, rules)
        )
    # --- END PUBSUB ---

# --- PUBSUB ---
if publisher and design_records:
    provenance = load_provenance(args.provenanceFile)
    payload = build_pipeline_payload(design_records, args, provenance)
    message_data = json.dumps(payload, default=str).encode("utf-8")

    if len(message_data) > MAX_PUBSUB_BYTES:
        print(
            f"[WARN] Payload size {len(message_data) / 1024:.1f} KB exceeds "
            f"{MAX_PUBSUB_BYTES // 1024} KB cap. Falling back to v1 per-design publish "
            f"({len(design_records)} messages)."
        )
        publish_v1_per_design(publisher, topic_path, design_records, args, provenance)
    else:
        try:
            publish_pipeline_report(
                publisher,
                topic_path,
                message_data,
                len(design_records),
                args,
                provenance,
            )
        except Exception as e:
            print(f"[WARN] Pub/Sub publish failed for pipeline report: {e}")
elif publisher and not design_records:
    print("[WARN] Pub/Sub publisher initialized but no design records were collected.")
# --- END PUBSUB ---
