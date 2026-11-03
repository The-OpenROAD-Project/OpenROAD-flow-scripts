#!/usr/bin/env python3
#
# This script generates a list of variables known
# not to be in the current stage.
#
# Reads variables.yaml as JSON on stdin:
#
#   $YAML2JSON variables.yaml | non_stage_variables.py <stage>
import json
import sys

text = sys.stdin.read()
if not text:
    sys.exit("non_stage_variables.py: no input; pipe $YAML2JSON variables.yaml into it")
data = json.loads(text)

for key, value in data.items():
    if "stages" not in value:
        continue
    if "All stages" in value["stages"]:
        continue
    if sys.argv[1] in value["stages"]:
        continue
    # This variable is in a stage, but not in this stage
    print(key)
