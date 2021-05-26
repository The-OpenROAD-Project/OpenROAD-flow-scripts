#!/usr/bin/env python3

import sys
from os.path import isfile, abspath
import json

if len(sys.argv) != 2:
    print('usage:', sys.argv[0], '<DIR>')
    sys.exit(1)
else:
    from os import chdir
    chdir(sys.argv[1])

okFile = 'metadata-base-ok.json'
outFile = 'rules.json'
errors = 0
rules = list()
regularPadding = 1.15
periodPadding = 0.05
valueIfZero = -50

if isfile(okFile):
    with open(okFile, 'r') as f:
        data = json.load(f)
else:
    print('Not found', abspath(okFile))
    sys.exit(1)

metrics = [
    # name                                        , allowChange , periodPad , roundValue
    ["synth__design__instance__stdcell__area"     , True        , False     , True],
    ["constraints__clocks__count"                 , False       , False     , True],
    ["placeopt__design__instance__design__area"   , True        , False     , True],
    ["placeopt__design__instance__stdcell__count" , True        , False     , True],
    ["globalroute__timing__clock__slack"          , True        , True      , False],
    ["detailedroute__route__wirelength"           , True        , False     , True],
    ["detailedroute__route__drc_errors__count"    , False       , False     , True],
    ["finish__design__instance__area"             , True        , False     , True],
]

for entry in metrics:
    field, allowChange, periodPad, roundValue = entry
    value = data[field]
    if periodPad:
        periodName = field.replace('slack', 'period')
        period = data[periodName]
        try:
            if value >= 0:
                value = - period * periodPadding
            else:
                value = value - period * periodPadding
        except Exception as e:
            print('[ERROR] while computing period padding', field, value, periodName, period)
            print(e)
            errors += 1
            continue
    else:
        if value == 0 and allowChange:
            value = valueIfZero
        elif allowChange:
            try:
                value *= regularPadding
            except Exception as e:
                print('[ERROR] while computing padding', field, value)
                print(e)
                continue
                errors += 1
    if not allowChange:
        compare = '=='
    elif value < 0:
        compare = '>='
    else:
        compare = '<='
    newRule = dict()
    newRule['field'] = field
    if roundValue :
        newRule['value'] = round(value)
    else:
        newRule['value'] = float("{:.2f}".format(value))
    newRule['compare'] = compare
    rules.append(newRule)

finalRules = dict()
finalRules['rules'] = rules
with open(outFile, 'w') as f:
    print('[INFO] writing', abspath(outFile))
    json.dump(finalRules, f, indent=4)
sys.exit(errors)
