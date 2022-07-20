#!/usr/bin/env python3
import argparse
import os
import re

# make sure the working dir is flow/
os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))

reportFilename = 'report.log'
singleReportFilename = f"reports/{reportFilename}"
summaryFilename = 'reports/report-summary.log'
drcFilename = '5_route_drc.rpt'
lastExpectedLog = '6_report.log'
metricsLogFmt = 'gen-metrics-{}-check.log'
metricsCheckFmt = 'metadata-{}-check.log'
regexError = re.compile(r"^\[err", re.IGNORECASE)
regexWarning = re.compile(r"^\[warn", re.IGNORECASE)

helpText = '''
Scans "./logs" and "./reports" folders for errors and warnings.
'''
parser = argparse.ArgumentParser(description=helpText)

helpText = '''
Level 0: only report fail/pass (default).
Level 1: report count per file.
Level 2: report full messages.
'''
parser.add_argument('--verbose', '-v',
                    required=False, default=0, action='count',
                    help=helpText)

parser.add_argument('--quiet', '-q',
                    required=False, default=False, action='store_true',
                    help='Do not print report to stdout.')

args = parser.parse_args()


def parseMessages(filename):
    errors = list()
    warnings = list()
    try:
        with open(filename, 'r') as f:
            lines = f.readlines()
    except Exception as e:
        print(f"Failed to open {filename}. Check to see if design finished.")
        return None, None
    for line in lines:
        if re.search(regexError, line):
            errors.append(line.strip())
        elif re.search(regexWarning, line):
            warnings.append(line.strip())
    return errors, warnings


def gen_report(name, data):
    if args.verbose or data['drcList'] or data['status'] is not 'green':
        output = f"{name}\n"
    else:
        output = ""

    if args.verbose:
        if data['finished']:
            output += '  Flow reached last stage.\n'
        else:
            output += f"  Last log file {data['lastLog']}\n"

    if len(data['logErrors']) == 0:
        if args.verbose:
            output += '  No error found in the log files.\n'
    else:
        if args.verbose:
            output += f"  Found {len(data['logErrors'])} error(s) in the log files.\n"
        if args.verbose >= 1:
            for error in data['logErrors']:
                if args.verbose >= 2:
                    output += f"      {error}\n"

    if len(data['logWarnings']) == 0:
        if args.verbose:
            output += '  No warning found in the log files.\n'
    else:
        if args.verbose:
            output += f"  Found {len(data['logWarnings'])} warning(s) in the log files.\n"
        if args.verbose >= 1:
            for warning in data['logWarnings']:
                if args.verbose >= 2:
                    output += f"      {warning}\n"

    if len(data['metricsLogsErrors']) == 0:
        if args.verbose:
            output += '  No error found while generating the metrics file.\n'
    else:
        if args.verbose:
            output += f"  Found {len(data['metricsLogsErrors'])} error(s) while generating the metrics file.\n"
        for e in data['metricsLogsErrors']:
            output += f"    {e}\n"

    if len(data['metricsLogsWarnings']) == 0:
        if args.verbose:
            output += '  No warning found while generating the metrics file.\n'
    else:
        if args.verbose:
            output += f"  Found {len(data['metricsLogsWarnings'])} warning(s) while generating the metrics file.\n"
        if args.verbose >= 2:
            for e in data['metricsLogsWarnings']:
                output += f"    {e}\n"

    if len(data['metricsErrors']) == 0:
        if args.verbose:
            output += '  No metrics check failed.\n'
    else:
        if args.verbose:
            output += f"  Found {len(data['metricsErrors'])} failures during metrics check.\n"
        for e in data['metricsErrors']:
            output += f"    {e}\n"

    if len(data['metricsWarnings']) == 0:
        if args.verbose:
            output += '  No warning found during metrics check.\n'
    else:
        if args.verbose:
            output += f"  Found {len(data['metricsWarnings'])} warning(s) during metrics check.\n"
        if args.verbose >= 2:
            for e in data['metricsWarnings']:
                output += f"    {e}\n"

    if len(data['drcList']) == 0:
        if args.verbose:
            output += '  No violations found.'
    else:
        if data['status'] == 'green':
            output += '  Design has the following violations under the allowed limit: '
        else:
            output += '  Design has the following violations over the allowed limit: '
        for drc, count in data['drcList'].items():
            output += f"{drc} ({count}) "
        output += '\n'

    return output.strip()


def write_report(path, content):
    content = content.strip()
    with open(path, 'w') as f:
        f.write(content)
    if args.verbose:
        content += f"\nGenerated report file: {path}\n"
    with open(singleReportFilename, 'a') as f:
        f.write(content)
        f.write('\n')
    if not args.quiet and content != '':
        print(content)


if os.path.isfile(singleReportFilename):
    if not args.quiet:
        print(f"Overwriting report {singleReportFilename}.")
    os.remove(singleReportFilename)

if os.path.isfile(summaryFilename):
    if not args.quiet:
        print(f"Overwriting report summary {summaryFilename}.")
    os.remove(summaryFilename)

designList = dict()

for logDir, dirs, files in sorted(os.walk('logs', topdown=False)):
    dirList = logDir.split(os.sep)
    if len(dirList) != 4:
        continue
    reportDir = logDir.replace('logs', 'reports')

    # basic info about current design
    platform, design, variant = dirList[1:]
    d = dict()
    d['outputFile'] = os.path.join(reportDir, reportFilename)

    # check if design ran to completion without errors or warnings
    for name in sorted(files):
        filename = os.path.join(logDir, name)
        d['logErrors'], d['logWarnings'] = parseMessages(filename)
        if name.endswith('.log'):
            d['lastLog'] = name
    d['finished'] = (d['lastLog'] == lastExpectedLog)

    # check if metrics generation had issues
    metricsLogFile = os.path.join(reportDir, metricsLogFmt.format(variant))
    d['metricsLogsErrors'], d['metricsLogsWarnings'] = parseMessages(metricsLogFile)

    # check if metrics passed
    metricsCheckFile = os.path.join(reportDir, metricsCheckFmt.format(variant))
    d['metricsErrors'], d['metricsWarnings'] = parseMessages(metricsCheckFile)

    # check if calibre was run and if drc check passed
    calibreCheckFile = os.path.join(logDir, 'calibre/save-to-drc-db.log')
    if os.path.isfile(calibreCheckFile):
        d['calibreErrors'], d['calibreWarnings'] = parseMessages(calibreCheckFile)
    else:
        d['calibreErrors'] = None
        d['calibreWarnings'] = None

    # check if there were drc violations
    drcReportFile = os.path.join(reportDir, drcFilename)
    d['drcList'] = dict()
    try:
        with open(drcReportFile, 'r') as f:
            for l in f.readlines():
                if 'violation type:' in l:
                    type_ = l.strip('violation type:').strip()
                    if type_ in d['drcList'].keys():
                        d['drcList'][type_] += 1
                    else:
                        d['drcList'][type_] = 1
    except Exception as e:
        print(f"Failed to open {drcFilename}. DRT probably did not finished.")

    if d['metricsErrors'] or d['calibreErrors']:
        d['status'] = 'red'
    else:
        d['status'] = 'green'

    designList[f"{platform} {design} ({variant})"] = d

# write summary and individual report files with data on designList

summary = '=' * 60 + '\n'
summary += ' ' * 26 + 'SUMMARY\n'
summary += '=' * 60 + '\n'
summary += f"\nNumber of designs: {len(designList.keys())}\n\n"
summary += '-' * 30 + '\n'
summary += ' ' * 7 + 'Passing designs\n'
summary += '-' * 30 + '\n'

for name, data in designList.items():
    if data['status'] == 'green':
        content = gen_report(name, data)
        if content != '':
            summary += content + '\n'
        if args.verbose:  # add empty line for readability
            summary += '\n'
        write_report(data['outputFile'], content)

summary += '\n' + '-' * 30 + '\n'
summary += ' ' * 7 + 'Failing designs\n'
summary += '-' * 30 + '\n\n'

for name, data in designList.items():
    if data['status'] == 'red':
        content = gen_report(name, data)
        summary += content + '\n'
        if args.verbose:  # add empty line for readability
            summary += '\n'
        write_report(data['outputFile'], content)

if not args.quiet and summary != '':
    print(summary)

with open(summaryFilename, 'a') as summaryFile:
    summaryFile.write(summary)

if not args.quiet and args.verbose:
    print('Generated report file:', singleReportFilename)
    print('Generated report summary file:', singleReportFilename)
