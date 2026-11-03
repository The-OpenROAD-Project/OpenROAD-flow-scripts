#!/usr/bin/env python3

# Reads variables.yaml as JSON on stdin: $(YAML2JSON) variables.yaml | defaults.py
import json
import sys

text = sys.stdin.read()
if not text:
    sys.exit("defaults.py: no input; pipe $YAML2JSON variables.yaml into it")
data = json.loads(text)

for key, value in data.items():
    if value.get("default", None) is None:
        continue
    print(f'export {key}?={str(value["default"]).replace(" ", "__SPACE__")}')
