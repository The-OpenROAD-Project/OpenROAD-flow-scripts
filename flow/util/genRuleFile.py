#!/usr/bin/env python3

import sys
from os.path import isfile, abspath
from re import sub
import json

if len(sys.argv) != 2:
    print('usage:', sys.argv[0], '<DIR>')
    sys.exit(1)
else:
    from os import chdir
    chdir(sys.argv[1])

okFile = 'metadata-base-ok.json'
outFile = 'rules.json'
rules = list()

if isfile(okFile):
    with open(okFile, 'r') as f:
        data = json.load(f)
else:
    print('Not found', abspath(okFile))
    sys.exit(1)

# dict format
# 'metric__name': {
#     'usePeriod': <bool>, use a percentage of the clock period as padding
#     'padding': <float>, percentage of padding to use
#     'roundValue': <bool>, use the rounded value for the rule
#     'customThreshold': <float>, value if the current gold metric is zero
#                    OR [<float>, <float>] this will check if the gold metric
#                    is <= to first <float>, if trye the rule value will be the
#                    second <float>
# },
metrics = {
    # synth
    'synth__design__instance__stdcell__area': {
        'usePeriod': False,
        'padding': 15,
        'roundValue': True,
        'customThreshold': 0,
        'compare': '<=',
    },
    # clock
    'constraints__clocks__count': {
        'usePeriod': False,
        'padding': 0,
        'roundValue': True,
        'customThreshold': 0,
        'compare': '==',
    },
    # floorplan
    # place
    'placeopt__design__instance__design__area': {
        'usePeriod': False,
        'padding': 15,
        'roundValue': True,
        'customThreshold': 0,
        'compare': '<=',
    },
    'placeopt__design__instance__stdcell__count': {
        'usePeriod': False,
        'padding': 15,
        'roundValue': True,
        'customThreshold': 0,
        'compare': '<=',
    },
    'detailedplace__design__violations__count': {
        'usePeriod': False,
        'padding': 0,
        'roundValue': True,
        'customThreshold': 0,
        'compare': '==',
    },
    # cts
    'cts__timing__setup__ws': {
        'usePeriod': True,
        'padding': 10,
        'roundValue': False,
        'customThreshold': 0,
        'compare': '>=',
    },
    'cts__timing__setup__ws__prerepair': {
        'usePeriod': True,
        'padding': 10,
        'roundValue': False,
        'customThreshold': 0,
        'compare': '>=',
    },
    'cts__timing__setup__ws__postrepair': {
        'usePeriod': True,
        'padding': 10,
        'roundValue': False,
        'customThreshold': 0,
        'compare': '>=',
    },
    # route
    'globalroute__timing__clock__slack': {
        'usePeriod': True,
        'padding': 5,
        'roundValue': False,
        'customThreshold': 0,
        'compare': '>=',
    },
    'globalroute__timing__setup__ws': {
        'usePeriod': True,
        'padding': 5,
        'roundValue': False,
        'customThreshold': 0,
        'compare': '>=',
    },
    'detailedroute__route__wirelength': {
        'usePeriod': False,
        'padding': 15,
        'roundValue': True,
        'customThreshold': 0,
        'compare': '<=',
    },
    'detailedroute__route__drc_errors__count': {
        'usePeriod': False,
        'padding': 0,
        'roundValue': True,
        'customThreshold': 0,
        'compare': '<=',
    },
    # finish
    'finish__timing__setup__ws': {
        'usePeriod': True,
        'padding': 5,
        'roundValue': False,
        'customThreshold': 0,
        'compare': '>=',
    },
    'finish__design__instance__area': {
        'usePeriod': False,
        'padding': 15,
        'roundValue': True,
        'customThreshold': 0,
        'compare': '<=',
    },
}

periodList = list()
for entry in data['constraints__clocks__details']:
    periodList.append(float(sub(r'^.*: ', '', entry)))

if len(periodList) != 1:
    print('[WARNING] Multiple clocks not supported. Will use first clock.')
period = periodList[0]

for field, option in metrics.items():
    if field not in data.keys():
        print(f'[ERROR] Metric {field} not found in metrics file: {okFile}.')
        sys.exit(1)

    value = data[field]

    if isinstance(value, str):
        print('[WARNING] Skipping string field {} = {}'.format(field, value))
        continue

    if len(periodList) != 1 and field == 'globalroute__timing__clock__slack':
        print('[WARNING] Skipping clock slack until multiple clocks support.')
        continue

    if option['padding'] != 0:
        if isinstance(option['customThreshold'], list):
            customThreshold, customValue = option['customThreshold']
        else:
            customThreshold = 0
            customValue = option['customThreshold']
        if option['usePeriod']:
            value -= period * option['padding'] / 100
            value = min(value, 0)
        elif value <= customThreshold:
            value = customValue
        else:
            value += value * option['padding'] / 100

    if 'timing' in field and 'count' not in field and value > 0:
        value = 0

    newRule = dict()
    newRule['field'] = field
    if option['roundValue']:
        newRule['value'] = round(value)
    else:
        newRule['value'] = float('{:.2f}'.format(value))
    newRule['compare'] = option['compare']
    rules.append(newRule)

finalRules = dict()
finalRules['rules'] = rules
with open(outFile, 'w') as f:
    print('[INFO] writing', abspath(outFile))
    json.dump(finalRules, f, indent=4)
