import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from datetime import datetime
import json
import argparse
import re
import os

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

def upload_platforms(db, dataFile, platform, design, args):
    # Create a new document with the folder name as the key
    doc_ref = db.collection('platforms').document(platform)

    # Get the current designs array
    try:
        designs = doc_ref.get().to_dict()['designs']
    except:
        designs = {}

    # Load JSON data from file
    with open(dataFile) as f:
        data = json.load(f) 

    designs[design] =  {
        'name': design,
        'rules': data
    }

    # Create a dictionary with the designs list
    data = {
        'designs': designs,
        'name': platform
    }

    # Set the data for the document
    doc_ref.set(data)


runFilename = f'rules-base.json'


for designsDir, dirs, files in sorted(os.walk('designs', topdown=False)):
    dirList = designsDir.split(os.sep)
    if len(dirList) != 3:
        continue

    # basic info about test design
    platform = dirList[1]
    design = dirList[2]
    test = '{} {}'.format(platform, design)
    print(test)
    dataFile = os.path.join(designsDir, runFilename)
    if os.path.exists(dataFile) and (platform != 'sky130hd_fakestack' or platform != 'src'):
        upload_platforms(db, dataFile, platform, design, args)
