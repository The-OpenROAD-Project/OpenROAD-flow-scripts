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
# Note: the operator "%" computes the difference (in percentage) between the
# reference value against the gold metadata. The test will pass if the
# difference is +/- the value of the rule. In the example below, the value of
# metricX can differ by +/- 10% between current run and the gold metadata file:
#        ...
#        {
#            "field" : "metricX",
#            "value" : 0.1,
#            "compare": "%",
#            "sign": "abs/inc/dec"
#        }, ...
#
#-------------------------------------------------------------------------------

import argparse  # argument parsing
import json  # json parsing
import sys
import operator

# Parse and validate arguments
# ==============================================================================
parser = argparse.ArgumentParser(
    description='Checks metadata from OpenROAD flow against a set of rules')
parser.add_argument('--metadata', '-m', required=True,
                    help='The metadata file')
parser.add_argument('--rules', '-r', required=True,
                    help='The rules file')
parser.add_argument('--goldMetadata', '-g', required=True,
                    help='The gold/reference metadata file')
parser.add_argument('--rulesGlobal', '-l', required=False,
                    help='The global rules file')
args = parser.parse_args()

with open(args.metadata) as metadataFile:
    metadata = json.load(metadataFile)

with open(args.goldMetadata) as goldMetadataFile:
    referenceMetadata = json.load(goldMetadataFile)

with open(args.rules) as rulesFile:
    rulesDesign = json.load(rulesFile)['rules']

rulesGlobal = list()
if args.rulesGlobal is not None:
    with open(args.rulesGlobal) as rulesFile:
        rulesGlobal = json.load(rulesFile)['rules']

rules = rulesDesign + rulesGlobal

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

    if op == "delta":
        reference_value = try_number(referenceMetadata[field])
        if not isinstance(check_value, float) or not isinstance(reference_value, float):
            print('Error: field {} fails rule {} {} {}'.format(field, check_value, compare, rule_value))
            errors += 1
            continue
        percentage = (check_value - reference_value) / reference_value * 100
        print("check_value = {}, reference_value = {}, diff_percentage = {}%".format(
            check_value, reference_value, percentage))
        check_value = percentage
        if not rule.has_key('sign') or rule['sign'] == 'abs':
            check_value = abs(check_value)
            op = operator.le
            compare = "(absolute value) <="
        elif rule['sign'] == 'inc':
            op = operator.le
            compare = "<="
        elif rule['sign'] == 'dec':
            if rule_value > 0.0:
                rule_value = - rule_value
            op = operator.ge
            compare = ">="
        else:
            print('invalid sign filed', rule['sign'])
            errors += 1
            continue

    if (isinstance(rule_value, float) != isinstance(check_value, float)
        or not op(check_value, rule_value)):
        errors += 1
        print('Error: field {} fails rule {} {} {}'.format(field, check_value, compare, rule_value))
    else:
        print('Passed: field {} passed rule {} {} {}'.format(field, check_value, compare, rule_value))

if errors == 0:
    print('All metadata rules passed ({} rules)'.format(len(rulesDesign)+len(rulesGlobal)))
else:
    print('Failed metadata checks: {} out of {}'.format(errors, len(rulesDesign)+len(rulesGlobal)))

sys.exit(1 if errors else 0)
