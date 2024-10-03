#!/usr/bin/env python3
import os
import yaml

dir_path = os.path.dirname(os.path.realpath(__file__))

yaml_path = os.path.join(dir_path, "variables.yaml")

with open(yaml_path, "r") as file:
    data = yaml.safe_load(file)

preferred_order = [
    "synth",
    "floorplan",
    "place",
    "cts",
    "grt",
    "route",
    "final",
    "generate_abstract",
    "all",
]
stages = {stage for value in data.values() for stage in value.get("stages", [])}
# convert set of stages to stages in a list in the preferred order, but
# list all stages
stages = [stage for stage in preferred_order if stage in stages] + [
    stage for stage in stages if stage not in preferred_order
]

markdown_table = ""

markdown_table += "## Variables in alphabetic order\n\n"
table_header = "| Variable | Description |\n| --- | --- |\n"
table_rows = ""
for key in sorted(data):
    value = data[key]
    description = value.get("description", "").replace("\n", " ").strip()
    table_rows += f"| {key} | {description} |\n"

markdown_table += table_header + table_rows

for stage in stages:
    markdown_table += f"## {stage}\n\n"
    stage_keys = [
        key
        for key in sorted(data)
        if "stages" not in data[key] or stage in data[key]["stages"]
    ]
    markdown_table += " ".join(stage_keys) + "\n\n"

docs = os.path.join(dir_path, "..", "..", "docs", "user", "FlowVariables.md")
with open(docs, "r") as file:
    lines = file.readlines()

# Find the section to replace
start_marker = "# Automatically generated"
end_marker = "# "
start_index = None
end_index = len(lines)

for i, line in enumerate(lines):
    if line.startswith(start_marker):
        start_index = i + 1
    elif start_index is not None and line.startswith(end_marker):
        end_index = i
        break

if start_index is None:
    raise ValueError("Start marker not found")

# Replace the section with the new table
new_lines = lines[:start_index] + [markdown_table] + lines[end_index:]

# Write the updated content back to FlowVariables.md
with open(docs, "w") as file:
    file.writelines(new_lines)
