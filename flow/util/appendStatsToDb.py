#!/usr/bin/env python2

# This scripts appends the test metadata to the master json
#-------------------------------------------------------------------------

import argparse  # argument parsing
import json  # json parsing
import sys
import re
import os  # filesystem manipulation

import csv
import datetime
import uuid
from collections import OrderedDict


# Parse and validate arguments
# ==============================================================================
parser = argparse.ArgumentParser(
    description='Appends test metadata to master database')
parser.add_argument('--masterTestListPath', '-m', default="masterTestList.json", required=False,
                    help='Path to Master Metadata')
parser.add_argument('--testMetadataPaths', '-t', required=True,
                    help='Path to Json Metadata', nargs='+')
args = parser.parse_args()

# Open master file
if os.path.isfile(args.masterTestListPath):
  with open(args.masterTestListPath) as f:
    masterJson = json.load(f, object_pairs_hook=OrderedDict)
else:
  masterJson = {"fields": [], "testcases": []}


for testMetadata in args.testMetadataPaths:

  if not os.path.isfile(testMetadata):
    print "Error: testMetadataPath does not exist"
    print "Path: " + testMetadata
    sys.exit(1)

  # Open test metadata
  try:
    with open(testMetadata) as f:
      designJson = json.load(f, object_pairs_hook=OrderedDict)
  except ValueError as e:
    print("Error occured opening or loading json file.")
    print >> sys.stderr, "Exception: %s" % str(e)
    sys.exit(1)

  if not designJson["uuid"] in [d["uuid"] for d in masterJson["testcases"]]:
    masterJson["testcases"].append(designJson)

    # Update Headers if necessary
    for key in list(designJson):
      if not key in masterJson["fields"]:
        masterJson["fields"].append(key)
        print "Updating fields with", key
  else:
    print("Skipping " + designJson["platform"] + "/" + designJson["design"] +
          " (" + designJson["uuid"] + ") already in masterDB")


# Dump JSON
with open(args.masterTestListPath, "w") as f:
  json.dump(masterJson, f, indent=2)


# Dump CSV
csvFilePath = os.path.splitext(args.masterTestListPath)[0] + '.csv'
with open(csvFilePath, 'w') as csvfile:
  fieldnames = list(masterJson["fields"])
  writer = csv.DictWriter(csvfile, fieldnames=fieldnames,
                          restval="-", extrasaction="ignore", dialect='excel')

  writer.writeheader()
  for testcase in masterJson["testcases"]:
    writer.writerow(testcase)
