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
#            "value" : <numeric_value>,
#            "compare": "<operator>"
#        }, ...
#    ]
# }
#
# field is the name of a field in the metadata file
# value is the reference value to compare to
# operator can be one of "<", ">", "<=", ">=", "==", "!=".
# The value is converted to a float for comparison if possible
#
#-------------------------------------------------------------------------------

import argparse
import json
from sys import exit
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
args = parser.parse_args()

with open(args.metadata) as metadataFile:
    metadata = json.load(metadataFile)

rules = dict()
for filePath in args.rules:
    if isfile(filePath):
        with open(filePath) as rulesFile:
            for rule in json.load(rulesFile)['rules']:
                field = rule['field']
                if field in rules.keys():
                    print('[WARN] rule for field {} = {}'.format(
                        field, rules[field]['value']), end='')
                    print(' was overwritten by design rule = {}'.format(
                        rule['value']))
                rules[field] = rule
    else:
        print('[WARN] File {} not found'.format(filePath))
if len(rules) == 0:
    print('No rules')
    exit(1)

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

for _, rule in rules.items():
    field = rule['field']
    compare = rule['compare']
    op = ops[compare]
    rule_value = try_number(rule['value'])
    build_value = try_number(metadata[field])

    formatError = list()
    if not isinstance(rule_value, float):
        formatError.append('rule_value')
    if not isinstance(build_value, float):
        formatError.append('build_value')
    if len(formatError):
        print('Error: field {}, has invalid float format for {}'.format(
            field, ', '.join(formatError)))
        errors += 1
        continue

    if op(build_value, rule_value):
        pre = '[INFO]'
        check = 'pass'
    else:
        pre = '[ERROR]'
        check = 'fail'
        errors += 1
    print(pre, field, check, 'test:', build_value, compare, rule_value)

if errors == 0:
    print('All metadata rules passed ({} rules)'.format(len(rules)))
else:
    print('Failed metadata checks: {} out of {}'.format(errors, len(rules)))

exit(1 if errors else 0)
