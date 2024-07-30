#!/usr/bin/env python3

import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from datetime import datetime, timezone
import json
import argparse
import re
import os

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

# Parse the arguments
args = parser.parse_args()


def upload_data(db, datafile, platform, design, variant, args, rules):
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
        new_key = re.sub(":", "__", k)  # replace ':' with '__'
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


def get_rules(platform, design, variant):
    runFilename = f"rules-{variant}.json"
    dataFile = os.path.join("designs", platform, design, runFilename)
    data = {}
    if os.path.exists(dataFile):
        with open(dataFile) as f:
            data = json.load(f)

    return data


# Initialize Firebase Admin SDK with service account credentials
firebase_admin.initialize_app(credentials.Certificate(args.cred))
# Initialize Firestore client
db = firestore.client()

runFilename = f"metadata-{args.variant}.json"

for reportDir, dirs, files in sorted(os.walk("reports", topdown=False)):
    dirList = reportDir.split(os.sep)
    if len(dirList) != 4:
        continue

    # basic info about test design
    platform = dirList[1]
    design = dirList[2]
    variant = dirList[3]
    dataFile = os.path.join(reportDir, runFilename)
    if not os.path.exists(dataFile):
        print(f"[WARN] No data file for {platform} {design} {variant}.")
        continue
    if platform == "sky130hd_fakestack" or platform == "src":
        print(f"[WARN] Skiping upload {platform} {design} {variant}.")
        continue
    print(f"[INFO] Get rules for {platform} {design} {variant}.")
    rules = get_rules(platform, design, variant)
    print(f"[INFO] Upload data for {platform} {design} {variant}.")
    upload_data(db, dataFile, platform, design, variant, args, rules)
