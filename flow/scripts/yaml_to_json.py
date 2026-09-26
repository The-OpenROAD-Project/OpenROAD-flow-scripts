#!/usr/bin/env python3
"""Convert variables.yaml to variables.json.

Run this whenever variables.yaml is modified.
Requires PyYAML (pip install pyyaml).
"""

import json
import os

import yaml

dir_path = os.path.dirname(os.path.realpath(__file__))
yaml_path = os.path.join(dir_path, "variables.yaml")
json_path = os.path.join(dir_path, "variables.json")

with open(yaml_path, "r") as f:
    data = yaml.safe_load(f)

with open(json_path, "w") as f:
    json.dump(data, f, indent=2, sort_keys=True)
    f.write("\n")
