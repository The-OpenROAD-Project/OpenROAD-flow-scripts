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
        "%" : "delta",
      }

errors = 0

for rule in rules:
    field = rule['field']
    rule_value = try_number(rule['value'])
    compare = rule['compare']
    op = ops[compare]
    check_value = try_number(metadata[field])

    deltaMessage = ''
    if op == "delta":
        reference_value = try_number(referenceMetadata[field])
        if not isinstance(check_value, float) or not isinstance(reference_value, float):
            errors += 1
            print('Error: field {} fails rule {} {} {}. Invalid number.'.format(field, check_value, compare, rule_value))
            continue
        percentage = (check_value - reference_value) / reference_value * 100
        deltaMessage = " check_value = {}, reference_value = {}, diff_percentage = {}%".format(
                check_value, reference_value, percentage)
        check_value = percentage
        if not rule.has_key('sign') or rule['sign'] == 'abs':
            check_value = abs(check_value)
            op = operator.le
            compare = "(absolute value) <="
        else:
            compare = rule['sign']
            op = ops[compare]

    if (isinstance(rule_value, float) != isinstance(check_value, float)
        or not op(check_value, rule_value)):
        errors += 1
        print('Error: field {} fails rule {} {} {}.{}'.format(field, check_value, compare, rule_value, deltaMessage))
    else:
        print('Passed: field {} passed rule {} {} {}.{}'.format(field, check_value, compare, rule_value, deltaMessage))

if errors == 0:
    print('All metadata rules passed ({} rules)'.format(len(rules)))
else:
    print('Failed metadata checks: {} out of {}'.format(errors, len(rules)))

sys.exit(1 if errors else 0)
