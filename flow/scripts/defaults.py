#!/usr/bin/env python3

import os
import yaml

dir_path = os.path.dirname(os.path.realpath(__file__))

yaml_path = os.path.join(dir_path, "variables.yaml")
with open(yaml_path, "r") as file:
    data = yaml.safe_load(file)

defaults = {
    key: value["default"]
    for key, value in data.items()
    if "default" in value and value["default"] is not None
} | {
    "VARIABLE_NAMES": " ".join(data.keys())
}

for key, value in defaults.items():
    print(f'export {key}?={str(value).replace(" ", "__SPACE__")}')
