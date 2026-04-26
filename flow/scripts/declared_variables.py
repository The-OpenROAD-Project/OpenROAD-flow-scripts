#!/usr/bin/env python3
#
# Emits the names of variables declared in variables.yaml that are valid in
# a given stage. With no argument, emits the names of all declared variables
# regardless of stage. Used by util.tcl's typo guard to error on misspelled
# or wrong-stage variable references.
import json
import os
import sys

dir_path = os.path.dirname(os.path.realpath(__file__))

json_path = os.path.join(dir_path, "variables.json")
with open(json_path, "r") as file:
    data = json.load(file)

stage = sys.argv[1] if len(sys.argv) > 1 else None

for key, value in data.items():
    stages = value.get("stages")
    if stage is None or stages is None or "All stages" in stages or stage in stages:
        print(key)
