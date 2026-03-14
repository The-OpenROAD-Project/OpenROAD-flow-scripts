#!/usr/bin/env python3
#
# Print a .md table of stage variables that are set in the environment.
# Sorted alphabetically, description truncated to fit 80 char lines.
# No external dependencies: parses variables.yaml line by line.
#
import os
import re
import sys


def parse_variables(yaml_path):
    """Parse variables.yaml into {name: {description, stages}}."""
    variables = {}
    current_var = None
    current_field = None

    with open(yaml_path) as f:
        for line in f:
            # Top-level variable: "VAR_NAME:"
            m = re.match(r"^(\w+):\s*$", line)
            if m:
                current_var = m.group(1)
                variables[current_var] = {"description": "", "stages": []}
                current_field = None
                continue

            if current_var is None:
                continue

            # Field: "  description: >" or "  stages:"
            m = re.match(r"^  (\w+):", line)
            if m:
                current_field = m.group(1)
                continue

            # List item under stages: "    - name"
            m = re.match(r"^    - (\S+)", line)
            if m and current_field == "stages":
                variables[current_var]["stages"].append(m.group(1))
                continue

            # Continuation of description
            if current_field == "description":
                variables[current_var]["description"] += " " + line.strip()

    return variables


def main():
    stage = sys.argv[1]
    dir_path = os.path.dirname(os.path.realpath(__file__))
    yaml_path = os.path.join(dir_path, "variables.yaml")
    variables = parse_variables(yaml_path)

    rows = []
    for key in sorted(variables):
        v = variables[key]
        stages = v["stages"]
        if not stages:
            continue
        if "All stages" not in stages and stage not in stages:
            continue
        if key not in os.environ:
            continue
        desc = v["description"].strip()
        rows.append((key, os.environ[key], desc))

    if rows:
        w0 = max(len(r[0]) for r in rows)
        w1 = max(len(r[1]) for r in rows)
        w0 = max(w0, len("Variable"))
        w1 = max(w1, len("Value"))

        def fmt(c0, c1, c2):
            prefix = f"| {c0:<{w0}} | {c1:<{w1}} |"
            remaining = 80 - len(prefix) - 1
            if remaining >= 4:
                max_desc = remaining - 3
                if len(c2) > max_desc:
                    c2 = c2[: max_desc - 3] + "..."
                return f"{prefix} {c2:<{max_desc}} |"
            return f"{prefix} |"

        header = fmt("Variable", "Value", "Description")
        print(header)
        print(re.sub(r"[^|]", "-", header))
        for var, val, desc in rows:
            print(fmt(var, val, desc))


if __name__ == "__main__":
    main()
