import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from datetime import datetime
import json
import argparse
import re
import os
import requests
from dateutil.relativedelta import relativedelta
from datetime import datetime, timedelta
import subprocess
import pathlib
import base64
from git import Repo

# Create the argument parser
parser = argparse.ArgumentParser(description='Process some integers.')

parser.add_argument('--keyFile', type=str, help='Service account credentials key file')

# Parse the arguments
args = parser.parse_args()

# Initialize Firebase Admin SDK with service account credentials
cred = credentials.Certificate(args.keyFile)
firebase_admin.initialize_app(cred)
# Initialize Firestore client
db = firestore.client()

def upload_data(db, commitSHA, datafile, platform, design, variant):
    # Set the document data
    key = commitSHA + '-' + platform + '-' + design + '-' + variant
    doc_ref = db.collection('metadata').document(key)

    # Get the snapshot and check if it exists
    doc_snapshot = doc_ref.get()
    if doc_snapshot.exists:
        return
   
    doc_ref.set({
        'branch_name': "master",
        'commit_sha': commitSHA,
    })

    # Load JSON data from file
    with open(dataFile) as f:
        data = json.load(f)

    # Replace the character ':' in the keys
    new_data = {}
    stages = []
    excludes = ["run", "commit", "total_time", "constraints"]
    for k, v in data.items():
        new_key = re.sub(':', '__', k)  # replace ':' with '__'
        new_data[new_key] = v
        stage_name = k.split('__')[0]
        if stage_name not in excludes:
            stages.append(stage_name)
        if k == 'run__flow__generate_date':
            # Convert string to datetime
            gen_date = datetime.strptime(v, '%Y-%m-%d %H:%M')
            new_data[k] = gen_date
    stages = set(stages)
    new_data['stages'] = stages

    # Set the data to the document in Firestore
    doc_ref.update(new_data)

runFilename = f'metadata-base.json'


# Clone the repository
print("Cloning Repo with submodules...")
repo = Repo.clone_from('https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts.git', 'local_repo', recursive=True)
# repo = Repo('.')

# make sure the working dir is flow/
os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'local_repo'))

# Get all the commits of the past year
start_date = datetime.now() - timedelta(days=365)
end_date = datetime.now()
# commits = list(repo.iter_items('--since={}'.format(start_date), '--until={}'.format(end_date)))

# Iterate over the commits and upload the JSON file to Firestore
print("Iterating over the commits...")
for commit in repo.iter_commits():
    commit_date = datetime.fromtimestamp(commit.committed_date)
    if start_date > commit_date  or  commit_date > end_date:
        exit(0)
    # Checkout the commit
    commit_sha = commit.hexsha
    repo.git.checkout(commit_sha)
    os.chdir('flow')

    # # Build the repo
    # result = subprocess.run(['../build_openroad.sh', '--local'], capture_output=True)

    # if result.returncode != 0:
    #     print("cannot build the project for commit", commit.hexsha)
    #     pass
    # result = subprocess.run(['.', '../setup_env.sh'], capture_output=True)

    # Run the flow for all designs
    for designsDir, dirs, files in sorted(os.walk('designs', topdown=False)):
        dirList = designsDir.split(os.sep)
        if len(dirList) != 3:
            continue

        # basic info about test design
        platform = dirList[1]
        design = dirList[2]
        test = '{} {}'.format(platform, design)
        print(test)
        print("dir list", dirList)
        # Define the path to the JSON file in the repository
        config_path = os.path.join(designsDir, 'config.mk')
        if os.path.exists(config_path) and (platform != 'sky130hd_fakestack' or platform != 'src'):
            print("Making flow of ", config_path)
            # res = subprocess.run(['export', "FLOW_HOME=", str(pathlib.Path().resolve())], shell=True, capture_output=True)
            # result = subprocess.run(['export', "FLOW_HOME=", str(pathlib.Path().resolve()), "&&", 'make', 'DESIGN_CONFIG=', config_path, "FLOW_HOME=", str(pathlib.Path().resolve())], shell=True,capture_output=True)
            # Create the first subprocess and capture its output
            p1 = subprocess.Popen(['export', "FLOW_HOME=", str(pathlib.Path().resolve())], shell=True, stdout=subprocess.PIPE)

            p2 = subprocess.Popen(['export', "DESIGN_CONFIG=", str(config_path)], stdin=p1.stdout,shell=True, stdout=subprocess.PIPE)
            p1.stdout.close()
            # Create the second subprocess and capture its output
            env_vars = {'DESIGN_CONFIG': config_path, 'FLOW_HOME': str(pathlib.Path().resolve())}

            p3 = subprocess.Popen(['make', 'DESIGN_CONFIG=', config_path], stdin=p2.stdout, shell=True, stdout=subprocess.PIPE, env=env_vars)
            p2.stdout.close()
            # Wait for both processes to finish and capture their output
            # output1, _ = p1.communicate()
            output2, _ = p3.communicate()

            # Decode the output from byte strings to regular strings
            # output1_str = output1.decode('utf-8')
            output2_str = output2.decode('utf-8')

            # Print the output
            # print(output1_str)
            print(output2_str)
            # If the command was successful, upload the resulting JSON data to Firestore
            if p3.returncode == 0:
                reportDir = os.path.join('reports', platform, design, 'base')
                dataFile = os.path.join(reportDir, runFilename)
                upload_data(db, commit_sha, dataFile, platform, design, "base")

repo.git.clear_cache()
