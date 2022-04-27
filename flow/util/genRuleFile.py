#!/usr/bin/env python3

import sys
from os import chdir
from os.path import isfile, abspath
from re import sub
import json
from math import ceil, isinf

if len(sys.argv) != 3:
    print('usage:', sys.argv[0], '<DIR> <VARIANT>')
    sys.exit(1)

chdir(sys.argv[1])
variant = sys.argv[2]
ok_file = f'metadata-{variant}-ok.json'
out_file = f'rules-{variant}.json'
rules = list()

if isfile(ok_file):
    with open(ok_file, 'r') as f:
        data = json.load(f)
else:
    print('Not found', abspath(ok_file))
    sys.exit(1)

# dict format
# 'metric_name': {
#     'use_period': <bool>, use a percentage of the clock period as padding
#     'padding': <float>, percentage of padding to use
#     'padding_fixed': <float>, fixed margin for padding
#     'fixed': <float>, sum this number instead of using % padding
#     'round_value': <bool>, use the rounded value for the rule
# },
metrics = {
    # synth
    'synth__design__instance__area__stdcell': {
        'use_period': False,
        'padding': 15,
        'round_value': True,
        'compare': '<=',
    },
    # clock
    'constraints__clocks__count': {
        'use_period': False,
        'padding': 0,
        'round_value': True,
        'compare': '==',
    },
    # floorplan
    # place
    'placeopt__design__instance__area': {
        'use_period': False,
        'padding': 15,
        'round_value': True,
        'compare': '<=',
    },
    'placeopt__design__instance__count__stdcell': {
        'use_period': False,
        'padding': 15,
        'round_value': True,
        'compare': '<=',
    },
    'detailedplace__design__violations': {
        'use_period': False,
        'padding': 0,
        'round_value': True,
        'compare': '==',
    },
    # cts
    'cts__timing__setup__ws': {
        'use_period': True,
        'padding': 25,
        'round_value': False,
        'compare': '>=',
    },
    'cts__timing__setup__ws__pre_repair': {
        'use_period': True,
        'padding': 25,
        'round_value': False,
        'compare': '>=',
    },
    'cts__timing__setup__ws__post_repair': {
        'use_period': True,
        'padding': 25,
        'round_value': False,
        'compare': '>=',
    },
    'cts__design__instance__count__hold_buffer': {
        'use_period': False,
        'padding': 10,
        'padding_fixed': 10,
        'round_value': True,
        'compare': '<=',
    },
    # route
    'globalroute__timing__clock__slack': {
        'use_period': True,
        'padding': 5,
        'round_value': False,
        'compare': '>=',
    },
    'globalroute__timing__setup__ws': {
        'use_period': True,
        'padding': 5,
        'round_value': False,
        'compare': '>=',
    },
    'detailedroute__route__wirelength': {
        'use_period': False,
        'padding': 15,
        'round_value': True,
        'compare': '<=',
    },
    'detailedroute__route__drc_errors': {
        'use_period': False,
        'padding': 0,
        'round_value': True,
        'compare': '<=',
    },
    # finish
    'finish__timing__setup__ws': {
        'use_period': True,
        'padding': 5,
        'round_value': False,
        'compare': '>=',
    },
    'finish__design__instance__area': {
        'use_period': False,
        'padding': 15,
        'round_value': True,
        'compare': '<=',
    },
    'finish__timing__drv__max_slew_limit': {
        'use_period': False,
        'fixed': -0.20,
        'round_value': False,
        'compare': '>=',
    },
    'finish__timing__drv__max_fanout_limit': {
        'use_period': False,
        'fixed': -0.20,
        'round_value': False,
        'compare': '>=',
    },
    'finish__timing__drv__max_cap_limit': {
        'use_period': False,
        'fixed': -0.20,
        'round_value': False,
        'compare': '>=',
    },
    'finish__timing__drv__setup_violation_count': {
        'use_period': False,
        'padding': 20,
        'padding_fixed': 10,
        'round_value': True,
        'compare': '<=',
    },
    'finish__timing__drv__hold_violation_count': {
        'use_period': False,
        'padding': 20,
        'padding_fixed': 10,
        'round_value': True,
        'compare': '<=',
    },
}

period_list = list()
for entry in data['constraints__clocks__details']:
    period_list.append(float(sub(r'^.*: ', '', entry)))

if len(period_list) != 1:
    print('[WARNING] Multiple clocks not supported. Will use first clock.')
period = period_list[0]

for field, option in metrics.items():
    if field not in data.keys():
        print(f'[ERROR] Metric {field} not found in metrics file: {ok_file}.')
        sys.exit(1)

    value = data[field]

    if isinstance(value, str):
        print('[WARNING] Skipping string field {} = {}'.format(field, value))
        continue

    if len(period_list) != 1 and field == 'globalroute__timing__clock__slack':
        print('[WARNING] Skipping clock slack until multiple clocks support.')
        continue

    if 'padding' in option.keys() and option['padding'] != 0:
        if option['use_period']:
            value -= period * option['padding'] / 100
            value = min(value, 0)
        elif 'padding_fixed' in option.keys():
            temp_1 = value + option['padding_fixed']
            temp_2 = value * (1 + option['padding'] / 100)
            value = max(temp_1, temp_2)
        else:
            value += value * option['padding'] / 100
    elif 'fixed' in option.keys():
        value = min(option['fixed'], value + option['fixed'])

    if field == 'cts__design__instance__count__hold_buffer' and value == 0:
        value = ceil(data['placeopt__design__instance__count__stdcell'] * 0.1)

    new_rule = dict()
    new_rule['field'] = field
    if option['round_value'] and not isinf(value):
        new_rule['value'] = round(value)
    else:
        new_rule['value'] = float('{:.2f}'.format(value))
    new_rule['compare'] = option['compare']
    rules.append(new_rule)

final_rules = dict()
final_rules['rules'] = rules
with open(out_file, 'w') as f:
    print('[INFO] writing', abspath(out_file))
    json.dump(final_rules, f, indent=4)
