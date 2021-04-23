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
# Optional Fields:
#
# "diff" field: if defined the checker will compute the percentage difference
# between the current value and the reference. The "value" in this case is the
# percentage used in the comparison. In the example below, the value of "tns"
# can differ by at most 15% between current run and the gold metadata file:
#        ...
#        {
#            "field" : "tns",
#            "value" : 15,
#            "diff": "True",
#            "compare": "<="
#        }, ...
#
# "absolute" field: the value of this field will be checked against the current
# value in addition to the percentage, thus this only make sense if "diff" is
# defined. In the example below, the test will only pass if the "tns"
# difference in at most 15% and smaller than 10 units of time.
#        ...
#        {
#            "field" : "tns",
#            "value" : 15,
#            "diff": "True",
#            "compare": "<=",
#            "absolute": 10
#        }, ...
#
# "dontAllowChangeToNonZero" field: if this field is set, the checker will
# consider an error if the refence value is zero and the current value is
# non-zero. In contrast, if this was not set a change from 0 -> 5 units of time
# would be ok.
#        ...
#        {
#            "field" : "tns",
#            "value" : 15,
#            "diff": "True",
#            "compare": "<=",
#            "absolute": 10,
#            "dontAllowChangeToNonZero": "True"
#        }, ...
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
parser.add_argument('--goldMetadata', '-g', required=True,
                    help='The gold/reference metadata file')
args = parser.parse_args()

with open(args.metadata) as metadataFile:
    metadata = json.load(metadataFile)

with open(args.goldMetadata) as goldMetadataFile:
    referenceMetadata = json.load(goldMetadataFile)

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
    reference_value = try_number(referenceMetadata[field])

    hasAbsolute = 'absolute' in rule
    hasDiff = 'diff' in rule
    dontAllowChangeToNonZero = 'dontAllowChangeToNonZero' in rule

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

    hasError = False
    percentage = None
    check_value = build_value
    if hasDiff:
        if reference_value != 0:
            percentage = (build_value - reference_value) / reference_value
            percentage *= 100
            check_value = percentage
        elif dontAllowChangeToNonZero and build_value != 0:
            hasError = True
            percentage = float('inf')
        elif build_value == reference_value:
            percentage = 0

    absoluteDiff = abs(build_value) - abs(reference_value)
    if not hasError and not op(check_value, rule_value):
        if hasAbsolute and op(absoluteDiff, rule['absolute']):
            hasError = False
            print('[INFO]', end='')
        else:
            hasError = True
            print('[ERROR]', end='')
            errors += 1
    else:
        hasError = False
        print('[INFO]', end='')

    print(' {}:'.format(field), end='')
    print(' value = {:.2f}'.format(build_value), end='')
    print(', reference = {:.2f}'.format(reference_value), end='')

    if hasError:
        print('. Failed', end='')
    else:
        print('. Passed', end='')
    if hasDiff:
        if percentage is not None:
            print(' percentage diff = {:.2f}%'.format(percentage), end='')
        else:
            print(' percentage diff = inf%'.format(percentage), end='')
    else:
        print(' value', end='')
    print(' {} {:.2f}'.format(compare, rule_value), end='')
    if hasDiff:
        print('%', end='')
    if hasAbsolute:
        print(' and value diff = {:.2f} {} {:.2f}'.format(absoluteDiff, compare, rule['absolute']), end='')
    # if hasDiff and percentage is not None:
    #     print(', diff = {:.2f}%'.format(percentage), end='')
    print('')


if errors == 0:
    print('All metadata rules passed ({} rules)'.format(len(rules)))
else:
    print('Failed metadata checks: {} out of {}'.format(errors, len(rules)))

exit(1 if errors else 0)
