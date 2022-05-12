#!/usr/bin/env python3

from math import ceil, isinf
from os import chdir
from os.path import isfile, abspath
from re import sub
import argparse
import json
import operator
import sys

parser = argparse.ArgumentParser(
    description='Generates or updates rules file for CI.')
parser.add_argument('dir', help='Path to the design directory.')
parser.add_argument(
    '-v',
    '--variant',
    default='base',
    help='Flow variant [default="base"].')
parser.add_argument(
    '-u',
    '--update',
    action='store_true',
    default=False,
    help='Update all rules independent of previous values.')
parser.add_argument(
    '-t',
    '--tighten',
    action='store_true',
    default=False,
    help='Update passing rules if they became tighter')
parser.add_argument(
    '-f',
    '--failing',
    action='store_true',
    default=False,
    help='Update failing rules.')
args = parser.parse_args()

if not args.update and not args.tighten and not args.failing:
    print('[ERROR] Please select at least one of '
          '-u/--update, -t/--tighten, -f/--failing.')
    parser.print_help()
    sys.exit(1)

chdir(args.dir)
metrics_file = f"metadata-{args.variant}-ok.json"
rules_file = f"rules-{args.variant}.json"
rules = dict()

if isfile(metrics_file):
    with open(metrics_file, 'r') as f:
        metrics = json.load(f)
else:
    print(f"[ERROR] File not found {abspath(metrics_file)}")
    sys.exit(1)

if isfile(rules_file):
    with open(rules_file, 'r') as f:
        OLD_RULES = json.load(f)
else:
    print(f"[WARNING] File not found {abspath(rules_file)}")
    OLD_RULES = None

# dict format
# 'metric_name': {
#     'use_period': <bool>, use a percentage of the clock period as padding
#     'padding': <float>, percentage of padding to use
#     'padding_fixed': <float>, fixed margin for padding
#     'fixed': <float>, sum this number instead of using % padding
#     'round_value': <bool>, use the rounded value for the rule
# },
rules_dict = {
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

ops = {
    '<': operator.lt,
    '>': operator.gt,
    '<=': operator.le,
    '>=': operator.ge,
    '==': operator.eq,
    '!=': operator.ne,
}

period_list = list()
for entry in metrics['constraints__clocks__details']:
    period_list.append(float(sub(r'^.*: ', '', entry)))

if len(period_list) != 1:
    print('[WARNING] Multiple clocks not supported. Will use first clock.')
period = period_list[0]

for field, option in rules_dict.items():
    if field not in metrics.keys():
        print(f"[ERROR] Metric {field} not found in "
              f"metrics file: {metrics_file}.")
        sys.exit(1)

    if isinstance(metrics[field], str):
        print(f"[WARNING] Skipping string field {field} = {metrics[field]}")
        continue

    if len(period_list) != 1 and field == 'globalroute__timing__clock__slack':
        print('[WARNING] Skipping clock slack until multiple clocks support.')
        continue

    if 'padding' in option.keys() and option['padding'] != 0:
        if option['use_period']:
            new_rule_value = metrics[field] - period * option['padding'] / 100
            new_rule_value = min(new_rule_value, 0)
        elif 'padding_fixed' in option.keys():
            temp_1 = metrics[field] + option['padding_fixed']
            temp_2 = metrics[field] * (1 + option['padding'] / 100)
            new_rule_value = max(temp_1, temp_2)
        else:
            new_rule_value = metrics[field] * (1 + option['padding'] / 100)
    elif 'fixed' in option.keys():
        new_rule_value = min(option['fixed'], metrics[field] + option['fixed'])
    else:
        new_rule_value = metrics[field]

    if field == 'cts__design__instance__count__hold_buffer' \
            and new_rule_value == 0:
        new_rule_value = ceil(
            metrics['placeopt__design__instance__count__stdcell'] * 0.1)

    if option['round_value'] and not isinf(new_rule_value):
        new_rule_value = int(round(new_rule_value))
    else:
        new_rule_value = float(f"{new_rule_value:.2f}")

    if OLD_RULES is not None:
        old_rule = OLD_RULES[field]
        if old_rule['compare'] != option['compare']:
            print('[WARNING] Compare operator changed since last update.')

        compare = ops[option['compare']]

        UPDATE = False
        if args.tighten \
                and new_rule_value != old_rule['value'] \
                and compare(new_rule_value, old_rule['value']):
            UPDATE = True
            print(f"[INFO] Tightening rule {field} "
                  f"from {old_rule['value']} to {new_rule_value}.")

        if args.failing and not compare(metrics[field], old_rule['value']):
            UPDATE = True
            print(f"[INFO] Updating failing rule {field} "
                  f"from {old_rule['value']} to {new_rule_value}.")

        if args.update:
            UPDATE = True
            print(f"[INFO] Updating rule {field} "
                  f"from {old_rule['value']} to {new_rule_value}.")

        if not UPDATE:
            new_rule_value = old_rule['value']

    rules[field] = dict(value=new_rule_value, compare=option['compare'])

with open(rules_file, 'w') as f:
    print('[INFO] writing', abspath(rules_file))
    json.dump(rules, f, indent=4)
