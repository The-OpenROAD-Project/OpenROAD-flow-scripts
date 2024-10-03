#!/usr/bin/env python3

import os
import sys
import yaml

dir_path = os.path.dirname(os.path.realpath(__file__))

yaml_path = os.path.join(dir_path, "variables.yaml")
with open(yaml_path, "r") as file:
    data = yaml.safe_load(file)

for key, value in data.items():
    if "stages" not in value:
        continue
    if sys.argv[1] in value["stages"]:
        continue
    # This variable is in a stage, but not in this stage
    print(key)
