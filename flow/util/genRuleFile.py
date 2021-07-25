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
errors = 0
rules = list()
regularPadding = 1.15  # %
periodPadding = 0.05  # %
periodPaddingRelax = 0.1  # %
valueIfZero = -50

if isfile(okFile):
    with open(okFile, 'r') as f:
        data = json.load(f)
else:
    print('Not found', abspath(okFile))
    sys.exit(1)

# autopep8: off
metrics = [
    # name                                        , usePadding , periodPad          , roundValue
    # synth
    ['synth__design__instance__stdcell__area'     , True       , 0                  , True]      ,
    # clock
    ['constraints__clocks__count'                 , False      , 0                  , True]      ,
    # floorplan
    # place
    ['placeopt__design__instance__design__area'   , True       , 0                  , True]      ,
    ['placeopt__design__instance__stdcell__count' , True       , 0                  , True]      ,
    # cts
    ['cts__timing__setup__ws'                     , True       , periodPaddingRelax , False]     ,
    ['cts__timing__setup__ws__prerepair'          , True       , periodPaddingRelax , False]     ,
    ['cts__timing__setup__ws__postrepair'         , True       , periodPaddingRelax , False]     ,
    # route
    ['globalroute__timing__clock__slack'          , True       , periodPadding      , False]     ,
    ['globalroute__timing__setup__ws'             , True       , periodPadding      , False]     ,
    ['detailedroute__route__wirelength'           , True       , 0                  , True]      ,
    ['detailedroute__route__drc_errors__count'    , False      , 0                  , True]      ,
    # finish
    ['finish__timing__setup__ws'                  , True       , periodPadding      , False]     ,
    ['finish__design__instance__area'             , True       , 0                  , True]      ,
    ['finish__timing__slew__violation__count'     , True       , 0                  , True]      ,
    ['finish__timing__fanout__violation__count'   , True       , 0                  , True]      ,
    ['finish__timing__max_cap__violation__count'  , True       , 0                  , True]      ,
]
# autopep8: on

period = list()
for entry in data['constraints__clocks__details']:
    period.append(float(sub(r'^.*: ', '', entry)))

if len(period) == 1:
    period = period[0]
else:
    period = 'multiple clocks not supported'

for entry in metrics:
    field, usePadding, periodPad, roundValue = entry
    value = data[field]

    if usePadding:
        if periodPad:
            try:
                if value >= 0:
                    value = - period * periodPadding
                else:
                    value = value - period * periodPadding
            except Exception as e:
                print('[ERROR] while computing period padding ', end='')
                print(field, value, period)
                print(e)
                errors += 1
                continue
        elif value == 0:
            value = valueIfZero
        else:
            try:
                value *= regularPadding
            except Exception as e:
                print('[ERROR] while computing padding', field, value)
                print(e)
                errors += 1
                continue

    if not usePadding:
        compare = '=='
    elif value < 0:
        compare = '>='
    else:
        compare = '<='

    newRule = dict()
    newRule['field'] = field
    if roundValue:
        newRule['value'] = round(value)
    else:
        newRule['value'] = float('{:.2f}'.format(value))
    newRule['compare'] = compare
    rules.append(newRule)

finalRules = dict()
finalRules['rules'] = rules
with open(outFile, 'w') as f:
    print('[INFO] writing', abspath(outFile))
    json.dump(finalRules, f, indent=4)
sys.exit(errors)
