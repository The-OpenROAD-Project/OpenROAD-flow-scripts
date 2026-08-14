#!/usr/bin/env python3

import json
import os

dir_path = os.path.dirname(os.path.realpath(__file__))

json_path = os.path.join(dir_path, "variables.json")
with open(json_path, "r") as file:
    data = json.load(file)

platform_dir = os.environ.get("PLATFORM_DIR")
if platform_dir:
    platform_config_path = os.path.join(platform_dir, "config.json")
    if os.path.exists(platform_config_path):
        with open(platform_config_path, "r") as file:
            try:
                platform_data = json.load(file)
                for key, value in platform_data.items():
                    if key in data:
                        data[key]["default"] = value
                    else:
                        data[key] = {"default": value}
            except json.JSONDecodeError:
                pass

for key, value in data.items():
    if value.get("default", None) is None:
        continue
    print(f'export {key}?={str(value["default"]).replace(" ", "__SPACE__")}')
