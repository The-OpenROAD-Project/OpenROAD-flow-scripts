import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from datetime import datetime
import json
import argparse
import re
import os
import requests
from genRuleFile import get_golden
from genRuleFile import update_rules
from genRuleFile import get_metrics

# make sure the working dir is flow/
os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))

# Create the argument parser
parser = argparse.ArgumentParser(description="Process some integers.")

parser.add_argument("--keyFile", type=str, help="Service account credentials key file")
parser.add_argument(
    "--overwrite",
    action="store_true",
    default=False,
    help="Overwrite the golden metrics",
)
parser.add_argument(
    "--apiURL",
    type=str,
    default="http://localhost:80",
    help="Set API Base URL to get golden metrics",
)
parser.add_argument(
    "--commitSHA",
    type=str,
    default="",
    help="commit for the metrics used to update the rules",
)

# Parse the arguments
args = parser.parse_args()

# Initialize Firebase Admin SDK with service account credentials
cred = credentials.Certificate(json.loads(args.keyFile))

firebase_admin.initialize_app(cred)
# Initialize Firestore client
db = firestore.client()

api_base_url = args.apiURL

runFilename = f"rules-base.json"

for designsDir, dirs, files in sorted(os.walk("designs", topdown=False)):
    dirList = designsDir.split(os.sep)
    if len(dirList) != 3:
        continue

    platform = dirList[1]
    design = dirList[2]
    test = "{} {}".format(platform, design)
    dataFile = os.path.join(designsDir, runFilename)
    if os.path.exists(dataFile) and (
        platform != "sky130hd_fakestack" or platform != "src"
    ):
        metrics, error_metrics = get_metrics(
            args.commitSHA,  # commit
            platform,  # platform
            design,  # design
            api_base_url,  # backend url
        )
        if error_metrics:
            print("failed to update rule for", platform, design)
            continue
        update_rules(
            designsDir,  # design directory
            "base",  # variant
            metrics,  # metrics needed for update, default is {} in case of file
            args.overwrite,  # overwrite flag, default is false
        )
