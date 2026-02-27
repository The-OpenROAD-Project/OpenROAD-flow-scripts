#!/usr/bin/env python3

import json
import os

dir_path = os.path.dirname(os.path.realpath(__file__))

json_path = os.path.join(dir_path, "variables.json")
with open(json_path, "r") as file:
    data = json.load(file)

for key, value in data.items():
    if value.get("default", None) is None:
        continue
    print(f'export {key}?={str(value["default"]).replace(" ", "__SPACE__")}')
