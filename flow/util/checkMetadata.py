#!/usr/bin/env python2

# This scripts checks the metadata.json against a set of rules for allowed
# values.  This allows degradation in results to be flagged as an error
# in the build.
#
# The rules file has the form
# {
#    "rules": [
#        {
#            "field" : "<name>",
#            "value" : <numeric_value>
#            "compare": "<operator>"
#        }, ...
#    ]
# }
#
# field is the name of a field in the metadata file
# value is the reference value to compare to
# operator can be one of "<", ">", "<=", ">=", "==", "!="
# The value is converted to a float for comparison if possible
#-------------------------------------------------------------------------------

import argparse  # argument parsing
import json  # json parsing
import sys
import operator

# Parse and validate arguments
# ==============================================================================
parser = argparse.ArgumentParser(
    description='Generates metadata from OpenROAD flow')
parser.add_argument('--metadata', '-m', required=True,
                    help='The metadata file')
parser.add_argument('--rules', '-r', required=True,
                    help='The rules file')
args = parser.parse_args()

with open(args.metadata) as metadataFile:
    metadata = json.load(metadataFile)

with open(args.rules) as rulesFile:
    rules = json.load(rulesFile)['rules']

# Convert to a float if possible
def try_number(s):
    try:
        return float(s)
    except ValueError:
        return s

ops = { "<" : operator.lt,
        ">" : operator.gt,
        "<=": operator.le,
        ">=": operator.ge,
        "==": operator.eq,
        "!=": operator.ne,
      }

errors = False

for rule in rules:
    field = rule['field']
    rule_value = try_number(rule['value'])
    compare = rule['compare']
    op = ops[compare]
    check_value = try_number(metadata[field])

    if (isinstance(rule_value, float) != isinstance(check_value, float)
        or not op(check_value, rule_value)):
        errors = True
        print 'Error: field {} fails rule {} {} {}'.format(field, check_value, compare, rule_value)
    else:
        print 'Passed: field {} passed rule {} {} {}'.format(field, check_value, compare, rule_value)

if not errors:
    print 'All metadata rules passed ({} rules)'.format(len(rules))

sys.exit(1 if errors else 0)
