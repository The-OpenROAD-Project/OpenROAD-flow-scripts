#!/usr/bin/env python3

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
# operator can be one of "<", ">", "<=", ">=", "==", "!=", "%"
# The value is converted to a float for comparison if possible
#
# Note: the operator "%" computes the difference (in percentage) between
# the reference value against the gold metadata. The rule also can have
# an attribute called "sign". The values allowed are "abs" for absolute value
# (default if not explicitly defined), or one of "<", ">", "<=", ">=", "==", "!=".
# In the example below, the value of "tns" can differ by +/- 15% between current run
# and the gold metadata file:
#        ...
#        {
#            "field" : "tns",
#            "value" : 15,
#            "compare": "%",
#            "sign": "abs"
#        }, ...
#
#-------------------------------------------------------------------------------

import argparse  # argument parsing
import json  # json parsing
import sys
import operator
from os.path import isfile

# Parse and validate arguments
# ==============================================================================
parser = argparse.ArgumentParser(
    description='Checks metadata from OpenROAD flow against a set of rules')
parser.add_argument('--metadata', '-m', required=True,
                    help='The metadata file')
parser.add_argument('--rules', '-r', required=True, nargs='+',
                    help='The rules file')
parser.add_argument('--goldMetadata', '-g', required=True,
                    help='The gold/reference metadata file')
args = parser.parse_args()

with open(args.metadata) as metadataFile:
    metadata = json.load(metadataFile)

with open(args.goldMetadata) as goldMetadataFile:
    referenceMetadata = json.load(goldMetadataFile)

rules = list()
for filePath in args.rules:
    if isfile(filePath):
        with open(filePath) as rulesFile:
            rules += json.load(rulesFile)['rules']
    else:
        print('[WARN] File {} not found'.format(filePath))
if len(rules) == 0:
    print('No rules')
    sys.exit(1)

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

errors = 0

for rule in rules:
    field = rule['field']
    compare = rule['compare']
    op = ops[compare]
    rule_value = try_number(rule['value'])
    build_value = try_number(metadata[field])
    reference_value = try_number(referenceMetadata[field])

    formatError = list()
    if not isinstance(rule_value, float):
        formatError.append('rule_value')
    if not isinstance(build_value, float):
        formatError.append('build_value')
    if not isinstance(reference_value, float):
        formatError.append('reference_value')
    if len(formatError):
        print('Error: field {}, has invalid float format for {}'.format(
            field, ', '.join(formatError)))
        errors += 1
        continue

    percentage = ''
    if reference_value != 0:
        percentage = (build_value - reference_value) / reference_value * 100
    elif reference_value == build_value:
        percentage = reference_value
    else:
        errors += 1
        continue

    if 'diff' in rule:
        check_value = percentage
        check_name = 'diff'
    else:
        check_value = build_value
        check_name = 'field value'

    if op(check_value, rule_value):
        print('Passed:', end='')
    else:
        print('Error: ', end='')
        errors += 1
    print(' field {} = {:.2f},'.format(field, build_value), end='')
    print(' reference = {:.2f},'.format(reference_value), end='')
    if check_name == 'diff':
        print(' diff = {:.2f}.'.format(percentage), end='')
    print(' Rule: {} must be {} {:.2f}'.format(check_name, compare, rule_value), end='')
    if check_name == 'diff':
        print('%')
    else:
        print('')

if errors == 0:
    print('All metadata rules passed ({} rules)'.format(len(rules)))
else:
    print('Failed metadata checks: {} out of {}'.format(errors, len(rules)))

sys.exit(1 if errors else 0)
