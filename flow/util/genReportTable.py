#!/usr/bin/env python3

import re
import argparse
import os
import json

# make sure the working dir is flow/
os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))

goldFilename = 'metadata-base-ok.json'
runFilename = 'metadata-base.json'
htmlOutput = 'reports/report-table.html'
designPathFile = 'design-dir.txt'

dontUse = re.compile(r'''
clocks__details |
commit |
cpu__total |
mem__peak |
runtime__total |
total_time |
uuid |
version
''', re.VERBOSE | re.IGNORECASE)

# list of metrics that should be considered green if they increase
# all other metrics are considered better if they decrease in value
higherIsBetter = re.compile(r'''
''', re.VERBOSE | re.IGNORECASE)


helpText = '''
Creates a HTML table with metric comparison between golden and current run
for each design.
'''
parser = argparse.ArgumentParser(description=helpText)
args = parser.parse_args()


def readMetrics(fname):
    global tableDict
    try:
        with open(fname, 'r') as f:
            tempDict = json.loads(f.read())
    except Exception as e:
        print('Failed to open {}.'.format(fname))
        exit(1)
    metrics = dict()
    for metric, value in tempDict.items():
        if not re.search(dontUse, metric):
            metrics[metric] = value
        else:
            continue
        if metric not in tableDict.keys():
            tableDict[metric] = list()
    return metrics


def getDiff(metric, gold, run):
    diff = '-'
    style = 'no_change'
    if isNumber:
        run = abs(run)
        gold = abs(gold)
        diff = run - gold
        if gold != 0:
            percentage = '{:+.2f}%'.format(diff / gold * 100)
        else:
            percentage = '#DIV/0!'
        if re.search(higherIsBetter, metric):
            if diff < 0:
                style = 'green'
            elif diff > 0:
                style = 'red'
        else:
            if diff < 0:
                style = 'red'
            elif diff > 0:
                style = 'green'
        if diff != 0:
            diff = '{:+.2f} ({})'.format(diff, percentage)
    return diff, style


tableDict = dict()
testList = list()
status = dict()

for logDir, dirs, files in sorted(os.walk('logs', topdown=False)):
    dirList = logDir.split(os.sep)
    if len(dirList) != 4:
        continue

    # basic info about test design
    reportDir = logDir.replace('logs', 'reports')
    with open(os.path.join(reportDir, designPathFile), 'r') as f:
        designDir = f.read().strip()

    platform = dirList[1]
    design = dirList[2]
    test = '{} {}'.format(platform, design)
    testList.append(test)
    if test not in status.keys():
        status[test] = dict()
        status[test]['no_change'] = 0
        status[test]['green'] = 0
        status[test]['red'] = 0

    print('-' * 79)
    print(test)
    print('-' * 79)

    gold = readMetrics(os.path.join(designDir, goldFilename))
    run = readMetrics(os.path.join(reportDir, runFilename))

    # report metrics missing from test run
    keysDiff = gold.keys() - run.keys()
    if keysDiff:
        keysDiff = ', '.join([x for x in list(keysDiff)])
        print('Keys missing from this run: {}.'.format(keysDiff))

    # report metrics missing from golden
    keysDiff = run.keys() - gold.keys()
    if keysDiff:
        keysDiff = ', '.join([x for x in list(keysDiff)])
        print('Keys missing from the golden run: {}.'.format(keysDiff))
        print('Check the bottom of the table as they might be out-of-order.')

    for metric in tableDict.keys():
        if metric in gold.keys():
            goldValue = gold[metric]
        else:
            goldValue = 'N/A'
        if metric in run.keys():
            runValue = run[metric]
        else:
            runValue = 'N/A'
        try:
            goldValue = float(goldValue)
            runValue = float(runValue)
            isNumber = True
        except BaseException:
            isNumber = False
        tableDict[metric].append(goldValue)
        tableDict[metric].append(runValue)
        diff, style = getDiff(metric, goldValue, runValue)
        tableDict[metric].append([diff, style])
        status[test][style] += 1

    print()

head = '''<!DOCTYPE html>
<html>

<style>
table {
  border-collapse: collapse;
  margin: 25px 0;
  font-size: 0.9em;
  font-family: sans-serif;
  min-width: 400px;
  box-shadow: 0 0 20px rgba(0, 0, 0, 0.15);
}
table thead tr {
  background-color: #009879;
  color: #ffffff;
  text-align: left;
}
table th,
table td {
  padding: 12px 15px;
}
table tbody tr {
  border-bottom: 1px solid #dddddd;
}
table tbody tr:nth-of-type(even) {
  background-color: #f3f3f3;
}
table td:nth-child(n+2) {
  text-align: center;
}
table tbody tr:last-of-type {
  border-bottom: 2px solid #009879;
}
table tbody tr.active-row {
  font-weight: bold;
  color: #009879;
}
table th,
table td:nth-child(1),
.summary-table td {
  border-right: solid 2px;
  border-left: solid 2px;
}
table th {
  border-top: solid 2px;
}
.main-table td:nth-child(3n+4) {
  border-left: dotted 1px;
}
.main-table td:nth-child(3n+1) {
  border-right: solid 2px;
}
</style>

<head>
<link rel="stylesheet" href="mystyle.css">
</head>
<body>
'''

tail = '''</body>
</html>
'''

subColumns = ['Gold', 'Current', 'Diff (%)']

table = ''
with open(htmlOutput, 'w') as f:

    # Compute summary rows
    noChangeList = list()
    improvementList = list()
    degradationList = list()
    designsMoreImprovements = list()
    designsMoreDegradations = list()
    designsNoChange = list()
    designsSameNumber = list()
    for test, value in status.items():
        noChange = value['no_change']
        improvements = value['green']
        degradations = value['red']
        noChangeList.append(noChange)
        improvementList.append(improvements)
        degradationList.append(degradations)
        if improvements == degradations:
            if improvements == 0:
                designsNoChange.append(test)
            else:
                designsSameNumber.append(test)
        elif improvements > degradations:
            designsMoreImprovements.append(test)
        else:
            designsMoreDegradations.append(test)

    # Summary table begin
    table += '\n<h1>Metrics Overview</h1>\n'

    table += '<pre>Number of designs with more improvements: '
    table += '{}\n'.format(len(designsMoreImprovements))
    table += '    {}</pre>\n'.format(', '.join(designsMoreImprovements))

    table += '<pre>Number of designs with more degradations: '
    table += '{}\n'.format(len(designsMoreDegradations))
    table += '    {}</pre>\n'.format(', '.join(designsMoreDegradations))

    table += '<pre>Number of designs with same number of degradations and improvements: '
    table += '{}\n'.format(len(designsSameNumber))
    table += '    {}</pre>\n'.format(', '.join(designsSameNumber))

    table += '<pre>Number of designs with no change: '
    table += '{}\n'.format(len(designsNoChange))
    table += '    {}</pre>\n'.format(', '.join(designsNoChange))

    table += '<table class="summary-table">\n'
    # Summary header
    table += '  <tr>\n'
    table += '    <th>Summary</th>\n'
    for test in testList + ['Total']:
        table += '    <th colspan="3">{}</th>\n'.format(test.strip())
    table += '  </tr>\n'

    # Summary rows
    table += '  <tr>\n'
    table += '    <td>{}</td>\n'.format('No Change')
    for value in noChangeList:
        table += '    <td colspan=3>{}</td>\n'.format(value)
    table += '    <td colspan=3>{}</td>\n'.format(sum(noChangeList))
    table += '  </tr>\n'

    table += '  <tr>\n'
    table += '    <td>{}</td>\n'.format('Improvement')
    for value in improvementList:
        table += '    <td colspan=3>{}</td>\n'.format(value)
    table += '    <td colspan=3>{}</td>\n'.format(sum(improvementList))
    table += '  </tr>\n'

    table += '  <tr>\n'
    table += '    <td>{}</td>\n'.format('Degradation')
    for value in degradationList:
        table += '    <td colspan=3>{}</td>\n'.format(value)
    table += '    <td colspan=3>{}</td>\n'.format(sum(degradationList))
    table += '  </tr>\n'
    table += '</table>\n'

    # Main table begin
    table += '\n<h1>Metrics Comparison Per Design</h1>\n'
    table += '<table class="main-table">\n'
    # Main table header
    table += '  <tr>\n'
    table += '    <th>Metric</th>\n'
    for test in testList:
        table += '    <th colspan="3">{}</th>\n'.format(test.strip())
    table += '  </tr>\n'

    # Main table header subdivision
    table += '  <tr>\n'
    table += '    <td>Name</td>\n'
    for _ in testList:
        for col in subColumns:
            table += '    <td>{}</td>\n'.format(col.strip())
    table += '  </tr>\n'

    # Main table rows
    for metric, entry in tableDict.items():
        table += '  <tr>\n'
        table += '    <td>{}</td>\n'.format(metric.strip())
        for num in range(0, len(entry), len(subColumns)):
            style = 'white'
            goldValue = '{}'.format(entry[num])
            if goldValue == 'N/A':
                table += '    <td bgcolor=yellow>{}</td>\n'.format(
                    goldValue.strip())
            else:
                table += '    <td>{}</td>\n'.format(goldValue.strip())
            runValue = '{}'.format(entry[num + 1])
            if runValue == 'N/A':
                table += '    <td bgcolor=yellow>{}</td>\n'.format(
                    runValue.strip())
            else:
                table += '    <td>{}</td>\n'.format(runValue.strip())
            diffValue, style = entry[num + 2]
            if style == 'no_change':
                style = ''
            table += '    <td bgcolor="{}">{}</td>\n'.format(style, diffValue)
        table += '  </tr>\n'

    table += '</table>\n\n'

    fname = 'reports/report.log'
    content = ''
    if os.path.isfile(fname):
        with open(fname, 'r') as reportFile:
            content = ''.join(reportFile.readlines()[4:])
        content = '<pre>\n' + content + '</pre>\n'
        content = '<h1>Flow Finish State and Log Summary</h1>\n' + content

    html = head + table + content + tail
    f.writelines(html)
