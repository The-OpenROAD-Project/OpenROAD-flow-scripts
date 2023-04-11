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
import base64

# make sure the working dir is flow/
os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))

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

def upload_data(db, commitSHA, data, platform, design, variant):
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

runFilename = f'metadata-base-ok.json'

# Define the repository name and owner
repo_owner = 'The-OpenROAD-Project'
repo_name = 'OpenROAD-flow-scripts'

# Set up GitHub API request headers
headers = {'Authorization': 'Bearer <token>'}

# Define the time range for commits (3 months ago until now)
end_time = datetime.now()
start_time = end_time - relativedelta(months=3)

# Get the list of commits in the time range
commits_url = f'https://api.github.com/repos/{repo_owner}/{repo_name}/commits'

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
    json_path = os.path.join(designsDir, runFilename)
    if os.path.exists(json_path) and (platform != 'sky130hd_fakestack' or platform != 'src'):
        json_path = os.path.join('flow',json_path)
        commits_params = {'path': json_path, 'since': start_time.isoformat(), 'until': end_time.isoformat()}
        try:
            commits_response = requests.get(commits_url, headers=headers, params=commits_params)
            commits_response.raise_for_status()
            if commits_response.status_code == 200:
                commits = commits_response.json()
                commit_url = F'https://api.github.com/repos/{repo_owner}/{repo_name}/contents/{json_path}'
                # Iterate over the commits and upload the JSON file to Firestore
                for commit in commits:
                    commit_sha = commit['sha']
                    commit_params = {'ref': commit_sha}
                    try:
                        response = requests.get(commit_url, headers=headers, params=commit_params)
                        response.raise_for_status()
                        if response.status_code == 200:
                            content = json.loads(response.content)
                            json_data = json.loads(base64.b64decode(content['content']).decode('utf-8'))
                            upload_data(db, commit_sha, json_data, platform, design, "base")
                    except requests.exceptions.HTTPError as e:
                        if e.response.status_code == 404:
                            print(f'The file path {json_path} does not exist in the {repo_name} repository in commit {commit_sha}')
                        else:
                            print("error in making request", e.response.text)
        except requests.exceptions.HTTPError as err:
            print("error in making request", err.response.text)
