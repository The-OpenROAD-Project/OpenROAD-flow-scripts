import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from datetime import datetime
import json
import argparse
import re
import os
import requests
from genRuleFile import genRuleFileFunc

# make sure the working dir is flow/
os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))

# Create the argument parser
parser = argparse.ArgumentParser(description='Process some integers.')

parser.add_argument('--keyFile', type=str, help='Service account credentials key file')
parser.add_argument('--overwrite', action='store_true', default=False,help='Overwrite the golden metrics')

# Parse the arguments
args = parser.parse_args()

# Initialize Firebase Admin SDK with service account credentials
cred = credentials.Certificate(args.keyFile)
firebase_admin.initialize_app(cred)
# Initialize Firestore client
db = firestore.client()

api_base_url = "http://localhost:80"

def get_golden(platform, design):
    try:
        response = requests.get(api_base_url+f"/golden?platform={platform}&design={design}&variant=base")

        # Check if the request was successful (status code 200)
        if response.status_code == 200 and "error" not in response.json():
            # Parse the JSON response
            data = response.json()

            return data, None
        else:
            print("API request failed")
            return None, "API request failed"
    except Exception as e:
        print(f"An error occurred: {str(e)}")
        return None, f"An error occurred: {str(e)}"

def update_rules(designDir, variant, golden_metrics, overwrite):
    # genRuleFileFunc(design_dir, update, tighten, failing, variant, golden_metrics={})
    if overwrite:
        genRuleFileFunc(designDir, True, False, False, variant, golden_metrics)
    else:
        genRuleFileFunc(designDir, False, True, False, variant, golden_metrics)

runFilename = f'rules-base.json'

for designsDir, dirs, files in sorted(os.walk('designs', topdown=False)):
    dirList = designsDir.split(os.sep)
    if len(dirList) != 3:
        continue

    platform = dirList[1]
    design = dirList[2]
    test = '{} {}'.format(platform, design)
    dataFile = os.path.join(designsDir, runFilename)
    if os.path.exists(dataFile) and (platform != 'sky130hd_fakestack' or platform != 'src'):
        golden_metrics, error_golden_metrics = get_golden(platform, design)
        if error_golden_metrics:
            print("failed to update rule for", platform, design)
            continue
        update_rules(designsDir, "base", golden_metrics, args.overwrite)