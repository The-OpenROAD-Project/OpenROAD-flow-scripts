#!/usr/bin/env python3

import re
import argparse
import os
import json
import operator
from collections import defaultdict

# make sure the working dir is flow/
os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))

htmlOutput = 'reports/report-table.html'
cssOutput = 'reports/table.css'
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
__ws |
__wns |
__drv__max.*_limit |
__clock__slack |
__tns
''', re.VERBOSE | re.IGNORECASE)


helpText = '''
Creates a HTML table with metric comparison between golden and current run
for each design.
'''
parser = argparse.ArgumentParser(description=helpText)
parser.add_argument(
    "--variant",
    default="base"
)
args = parser.parse_args()

goldFilename = f'metadata-{args.variant}-ok.json'
runFilename = f'metadata-{args.variant}.json'


def readMetrics(fname, justLoad=False):
    global tableDict
    try:
        with open(fname, 'r') as f:
            tempDict = json.loads(f.read())
    except BaseException:
        print('Failed to open {}.'.format(fname))
        return None
    if justLoad:
        return tempDict
    metrics = dict()
    for metric, value in tempDict.items():
        if not re.search(dontUse, metric):
            metrics[metric] = value
        else:
            continue
        if metric not in tableDict.keys():
            tableDict[metric] = list()
    return metrics


ops = {
    "<": operator.lt,
    ">": operator.gt,
    "<=": operator.le,
    ">=": operator.ge,
    "==": operator.eq,
    "!=": operator.ne,
}


def getDiff(metric, gold, run, rules):
    diff = '-'
    style = 'no_change'
    if isNumber:
        diff = run - gold
        if gold != 0:
            percentage = '{:.2f}%'.format(abs(diff / gold) * 100)
        else:
            percentage = '#DIV/0!'
        if run > gold:
            style = 'green' if re.search(higherIsBetter, metric) else 'orange'
        elif gold > run:
            style = 'orange' if re.search(higherIsBetter, metric) else 'green'
        for field, rule in rules.items():
            if metric != field:
                continue
            op = ops[rule['compare']]
            value = rule['value']
            if not op(run, value):
                style = 'red'
        if diff != 0:
            if abs(diff) < 0.01:
                diff = '{:+.2} ({})'.format(diff, percentage)
            else:
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
    platform = dirList[1]
    design = dirList[2]
    variant = dirList[3]
    test = '{} {} {}'.format(platform, design, variant)
    reportDir = logDir.replace('logs', 'reports')
    errors = 0

    print('-' * 79)
    print(test)
    print('-' * 79)

    try:
        with open(os.path.join(reportDir, designPathFile), 'r') as f:
            designDir = f.read().strip()
    except BaseException:
        print('Failed to open {}.'.format(designPathFile))
        designDir = os.path.join('designs', platform, design)
        errors += 1

    gold = readMetrics(os.path.join(designDir, goldFilename))
    if gold is None:
        errors += 1
        goldKeys = None
    else:
        goldKeys = gold.keys()

    run = readMetrics(os.path.join(reportDir, runFilename))
    if run is None:
        errors += 1
        runKeys = None
    else:
        runKeys = run.keys()

    rulesFilename = f'rules-{variant}.json'
    rules = readMetrics(os.path.join(designDir, rulesFilename), justLoad=True)
    if rules is None:
        errors += 1

    testList.append(test)
    if test not in status.keys():
        status[test] = dict()
        status[test]['error'] = errors
        status[test]['red'] = 0
        status[test]['orange'] = 0
        status[test]['no_change'] = 0
        status[test]['green'] = 0

    for metric in tableDict.keys():
        try:
            if metric in goldKeys:
                goldValue = gold[metric]
            else:
                goldValue = 'N/A'
        except BaseException:
            goldValue = 'ERR'
        try:
            if metric in runKeys:
                runValue = run[metric]
            else:
                runValue = 'N/A'
        except BaseException:
            runValue = 'ERR'
        try:
            goldValue = float(goldValue)
            runValue = float(runValue)
            isNumber = True
        except BaseException:
            isNumber = False
        tableDict[metric].append(goldValue)
        tableDict[metric].append(runValue)
        diff, style = getDiff(metric, goldValue, runValue, rules)
        tableDict[metric].append([diff, style])
        status[test][style] += 1

    print()

cssStyle = '''/* table styles */
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
.image-table td,
.summary-table td {
  border-right: solid 2px;
  border-left: solid 2px;
}
table th {
  border-top: solid 2px;
}
.main-table th {
  position: sticky;
  top: 0;
  background-color: #727272;
  color: #e0e0e0;
}
.main-table tr:nth-of-type(even) td:nth-child(1) {
  background-color: #f3f3f3;
}
.main-table tr:nth-of-type(odd) td:nth-child(1) {
  background-color: #ffffff;
}
.main-table tr:nth-child(2),
.main-table tr:nth-child(2) td:nth-child(1) {
  position: sticky;
  top: 44px;
  background-color: #727272;
  color: #e0e0e0;
  z-index: 2;
}
.main-table th:nth-child(1),
.main-table td:nth-child(1) {
  position: sticky;
  left: 0;
}
.main-table th:nth-child(1){
  z-index: 2;
}
.main-table td:nth-child(3n+4) {
  border-left: dotted 1px;
}
.main-table td:nth-child(3n+1) {
  border-right: solid 2px;
}
div.gallery {
  margin: 5px;
  float: left;
  height: 300px;
}
div.gallery:hover {
  border: 1px solid #777;
}
div.gallery img {
  max-height: 300px;
  width: auto;
}
div.desc {
  padding: 10px;
  text-align: center;
}
'''

with open(cssOutput, 'w') as f:
    f.writelines(cssStyle)

head = '''<!DOCTYPE html>
<html lang="en">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="table.css">
</head>

<body>
'''

tail = '''</body>
</html>
'''


def add_image(path, platform, view):
    return f'''<td>
  <div class="gallery">
    <div class="desc">
      {platform} - {view}
    </div>
    <a target="_blank" href="{path}">
      <img src="{path}" alt="{platform}/{view}">
    </a>
  </div>
</td>
'''


platforms = set()
designs = set()
views = set()
images = defaultdict(lambda: defaultdict(dict))
for parents, dirs, files in sorted(os.walk('reports', topdown=False)):
    for file in files:
        if file.endswith('.webp'):
            path = os.path.join(parents, file).replace('reports', '.')
            platform, design = path.split(os.sep)[1:3]
            view = file[:-5]
            designs.add(design)
            platforms.add(platform)
            views.add(view)
            images[design][platform][view] = path

platforms = sorted(platforms)
designs = sorted(designs)
view = sorted(views)


def write_gallery(design, platforms, views):
    htmlGallery = f'reports/report-gallery-{design}.html'
    with open(htmlGallery, 'w') as f:
        gallery = '  <h1>Image Gallery</h1>\n'
        gallery += '<table class="image-table">\n'
        gallery += '<tr>\n'
        for key in platforms:
            gallery += f'<th>{key}</th>\n'
        gallery += '</tr>\n'
        for view in views:
            gallery += '<tr>\n'
            for platform in platforms:
                if platform in images[design] and \
                   view in images[design][platform]:
                    gallery += add_image(images[design][platform][view],
                                         platform, view)
                else:
                    gallery += '<td>\n</td>\n'
            gallery += '</tr>\n'
        gallery += '</table>\n'
        html = head + gallery + tail
        f.writelines(html)


for design in designs:
    write_gallery(design, platforms, views)

subColumns = ['Gold', 'Current', 'Diff (%)']

table = ''
with open(htmlOutput, 'w') as f:

    # Compute summary rows
    noChangeList = list()
    improvementList = list()
    degradationList = list()
    failedMetricsList = list()
    parsingErrorList = list()
    designsMoreImprovements = list()
    designsMoreDegradations = list()
    designsNoChange = list()
    designsSameNumber = list()
    designsRed = list()
    designsParsingErrors = list()
    for test, value in status.items():
        noChange = value['no_change']
        improvements = value['green']
        degradations = value['orange']
        failedMetrics = value['red']
        parsingErrors = value['error']
        noChangeList.append(noChange)
        improvementList.append(improvements)
        degradationList.append(degradations)
        failedMetricsList.append(failedMetrics)
        parsingErrorList.append(parsingErrors)
        if parsingErrors > 0:
            designsParsingErrors.append(test)
        if failedMetrics > 0:
            designsRed.append(test)
        elif improvements == degradations:
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

    txt = 'Number of designs that failed parsing: '
    txt += '{}\n'.format(len(designsParsingErrors))
    txt += '    {}\n'.format(', '.join(designsParsingErrors))
    table += '<pre>\n{}\n</pre>\n'.format(txt.strip())

    txt = 'Number of designs failing metrics checks: '
    txt += '{}\n'.format(len(designsRed))
    txt += '    {}\n'.format(', '.join(designsRed))
    table += '<pre>\n{}\n</pre>\n'.format(txt.strip())

    txt = 'Number of designs with more improvements: '
    txt += '{}\n'.format(len(designsMoreImprovements))
    txt += '    {}\n'.format(', '.join(designsMoreImprovements))
    table += '<pre>\n{}\n</pre>\n'.format(txt.strip())

    txt = 'Number of designs with more degradations: '
    txt += '{}\n'.format(len(designsMoreDegradations))
    txt += '    {}\n'.format(', '.join(designsMoreDegradations))
    table += '<pre>\n{}\n</pre>\n'.format(txt.strip())

    txt = 'Number of designs with same number of degradations and improvements: '
    txt += '{}\n'.format(len(designsSameNumber))
    txt += '    {}\n'.format(', '.join(designsSameNumber))
    table += '<pre>\n{}\n</pre>\n'.format(txt.strip())

    txt = 'Number of designs with no change: '
    txt += '{}\n'.format(len(designsNoChange))
    txt += '    {}\n'.format(', '.join(designsNoChange))
    table += '<pre>\n{}\n</pre>\n'.format(txt.strip())

    table += '\n<table class="summary-table">\n'
    # Summary header
    table += '  <tr>\n'
    table += '    <th>Summary</th>\n'
    for test in testList + ['Total']:
        table += '    <th>{}</th>\n'.format(test)
    table += '  </tr>\n'

    # Summary rows

    title = 'Parsing Errors'
    table += '  <tr>\n'
    table += '    <td bgcolor="brown">{}</td>\n'.format(title)
    for value in parsingErrorList:
        table += '    <td title="{}">{}</td>\n'.format(title, value)
    table += '    <td>{}</td>\n'.format(sum(parsingErrorList))
    table += '  </tr>\n'

    title = 'Failed Metrics'
    table += '  <tr>\n'
    table += '    <td bgcolor="red">{}</td>\n'.format(title)
    for value in failedMetricsList:
        table += '    <td title="{}">{}</td>\n'.format(title, value)
    table += '    <td>{}</td>\n'.format(sum(failedMetricsList))
    table += '  </tr>\n'

    title = 'Degradation'
    table += '  <tr>\n'
    table += '    <td bgcolor="orange">{}</td>\n'.format(title)
    for value in degradationList:
        table += '    <td title="{}">{}</td>\n'.format(title, value)
    table += '    <td>{}</td>\n'.format(sum(degradationList))
    table += '  </tr>\n'

    title = 'No Change'
    table += '  <tr>\n'
    table += '    <td>{}</td>\n'.format(title)
    for value in noChangeList:
        table += '    <td title="{}">{}</td>\n'.format(title, value)
    table += '    <td>{}</td>\n'.format(sum(noChangeList))
    table += '  </tr>\n'

    title = 'Improvement'
    table += '  <tr>\n'
    table += '    <td bgcolor="green">{}</td>\n'.format(title)
    for value in improvementList:
        table += '    <td title="{}">{}</td>\n'.format(title, value)
    table += '    <td>{}</td>\n'.format(sum(improvementList))
    table += '  </tr>\n'

    table += '</table>\n'

    # Main table begin
    table += '\n<h1>Metrics Comparison Per Design</h1>\n'
    table += '<table class="main-table">\n'
    # Main table header
    table += '  <tr>\n'
    table += '    <th>Metric</th>\n'
    for test in testList:
        table += '    <th colspan="3">{}</th>\n'.format(test)
    table += '  </tr>\n'

    # Main table header subdivision
    table += '  <tr>\n'
    table += '    <td>Name</td>\n'
    for _ in testList:
        for col in subColumns:
            table += '    <td>{}</td>\n'.format(col)
    table += '  </tr>\n'

    # Main table rows
    for metric, entry in tableDict.items():
        table += '  <tr>\n'
        table += '    <td>{}</td>\n'.format(metric)
        title = 'title="{}"'.format(metric)

        for num in range(0, len(entry), len(subColumns)):

            goldValue = '{}'.format(entry[num])
            props = title
            if goldValue == 'N/A':
                props += 'bgcolor=yellow'
            elif goldValue == 'ERR':
                props += 'bgcolor=brown'
            table += '    <td {}>{}</td>\n'.format(props, goldValue)

            runValue = '{}'.format(entry[num + 1])
            props = title
            if runValue == 'N/A':
                props += 'bgcolor=yellow'
            elif runValue == 'ERR':
                props += 'bgcolor=brown'
            table += '    <td {}>{}</td>\n'.format(props, runValue)

            diffValue, style = entry[num + 2]
            props = title
            if style == 'no_change':
                style = ''
            props = '{} bgcolor="{}"'.format(props, style)
            table += '    <td {}>{}</td>\n'.format(props, diffValue)

        table += '  </tr>\n'

    table += '</table>\n\n'

    fname = 'reports/report.log'
    content = ''
    if os.path.isfile(fname):
        with open(fname, 'r') as reportFile:
            content = ''.join(reportFile.readlines()[4:])
        content = '<pre>\n' + content + '\n</pre>\n'
        content = '<h1>Flow Finish State and Log Summary</h1>\n' + content

    html = head + table + content + tail
    f.writelines(html)
