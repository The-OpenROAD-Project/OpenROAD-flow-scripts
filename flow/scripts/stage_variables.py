#!/usr/bin/env python3
#
# Print a .md table of stage variables that are set in the environment.
# Paths shortened relative to FLOW_DIR. Descriptions truncated with "..."
# to signal that variables.yaml has full details.
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


def shorten_path(value, flow_dir):
    """Replace FLOW_DIR prefix with ./ to keep values compact."""
    if flow_dir and value.startswith(flow_dir + "/"):
        return "./" + value[len(flow_dir) + 1 :]
    return value


def main():
    stage = sys.argv[1]
    dir_path = os.path.dirname(os.path.realpath(__file__))
    flow_dir = os.path.dirname(dir_path)
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
        val = shorten_path(os.environ[key], flow_dir)
        rows.append((key, val, desc))

    if not rows:
        return

    w0 = max(max(len(r[0]) for r in rows), len("Variable"))
    w1 = max(max(len(r[1]) for r in rows), len("Value"))

    # Script runs inside Tcl exec (no tty on any fd).
    # Query /dev/tty directly for terminal width; fall back to COLUMNS env.
    width = 0
    try:
        with open("/dev/tty") as tty:
            width = os.get_terminal_size(tty.fileno()).columns
    except (OSError, AttributeError):
        cols = os.environ.get("COLUMNS", "")
        width = int(cols) if cols.isdigit() else 0

    # framing: "| " + " | " + " | " + " |" = 10 chars
    min_desc = 20
    if width > 0:
        # Shrink value column if needed to fit description within terminal.
        max_w1 = width - w0 - 10 - min_desc
        if w1 > max_w1 > len("Value"):
            w1 = max_w1
        desc_budget = max(width - w0 - w1 - 10, min_desc)
    else:
        desc_budget = 40  # brief hint + "..." crib for AI to check variables.yaml

    def trunc(text, budget):
        if budget == 0 or len(text) <= budget:
            return text
        return text[: budget - 3] + "..."

    def fmt(c0, c1, c2):
        v = trunc(c1, w1)
        d = trunc(c2, desc_budget)
        if desc_budget:
            return f"| {c0:<{w0}} | {v:<{w1}} | {d:<{desc_budget}} |"
        return f"| {c0:<{w0}} | {v:<{w1}} | {d} |"

    header = fmt("Variable", "Value", "Description")
    print(header)
    print(re.sub(r"[^|]", "-", header))
    for var, val, desc in rows:
        print(fmt(var, val, desc))


if __name__ == "__main__":
    main()
