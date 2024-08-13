#!/usr/bin/env python3

"""
This scripts checks the metadata.json against a set of rules for allowed
values.  This allows degradation in results to be flagged as an error
in the build.

The rules file has the form
{
   "rules": [
       {
           "field" : "<name>",
           "value" : <numeric_value>,
           "compare": "<operator>"
       }, ...
   ]
}

field is the name of a field in the metadata file
value is the reference value to compare to
operator can be one of "<", ">", "<=", ">=", "==", "!=".
The value is converted to a float for comparison if possible
"""

from os.path import isfile
import argparse
import json
import operator
import sys

parser = argparse.ArgumentParser(
    description="Checks metadata from OpenROAD flow against a set of rules"
)
parser.add_argument("--metadata", "-m", required=True, help="The metadata file")
parser.add_argument("--rules", "-r", required=True, nargs="+", help="The rules file")
args = parser.parse_args()

with open(args.metadata) as metadataFile:
    metadata = json.load(metadataFile)

rules = dict()
for filePath in args.rules:
    if isfile(filePath):
        with open(filePath) as rulesFile:
            rules.update(json.load(rulesFile))
    else:
        print(f"[WARN] File {filePath} not found")

if len(rules) == 0:
    print("No rules")
    sys.exit(1)


def try_number(string):
    """
    Convert to a float if possible
    """
    try:
        return float(string)
    except ValueError:
        return string


ops = {
    "<": operator.lt,
    ">": operator.gt,
    "<=": operator.le,
    ">=": operator.ge,
    "==": operator.eq,
    "!=": operator.ne,
}

ERRORS = 0

for field, rule in rules.items():
    compare = rule["compare"]
    op = ops[compare]
    rule_value = try_number(rule["value"])

    if field in metadata.keys():
        build_value = try_number(metadata[field])
    else:
        print(f"[ERROR] Value not found for {field}.")
        sys.exit(1)

    formatError = list()
    if not isinstance(rule_value, float):
        formatError.append("rule_value")
    if not isinstance(build_value, float):
        formatError.append("build_value")
    if len(formatError) != 0:
        print(
            f"Error: field {field}, has invalid float format for "
            f"{', '.join(formatError)}"
        )
        ERRORS += 1
        continue

    if op(build_value, rule_value):
        PRE = "[INFO]"
        CHECK = "pass"
    else:
        PRE = "[ERROR]"
        CHECK = "fail"
        ERRORS += 1
    print(PRE, field, CHECK, "test:", build_value, compare, rule_value)

if ERRORS == 0:
    print(f"All metadata rules passed ({len(rules)} rules)")
else:
    print(f"Failed metadata checks: {ERRORS} out of {len(rules)}")

sys.exit(1 if ERRORS else 0)
