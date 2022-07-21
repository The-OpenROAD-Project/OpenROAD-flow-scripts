#!/usr/bin/env python3
import argparse
import os
import re

os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))

REPORT_FILENAME = 'report.log'
SINGLE_REPORT_FILENAME = "reports/report.log"
SUMMARY_FILENAME = 'reports/report-summary.log'
DRC_FILENAME = '5_route_drc.rpt'
LAST_EXPECTED_LOG = '6_report.log'
METRICS_LOG_FMT = 'gen-metrics-{}-check.log'
METRICS_CHECK_FMT = 'metadata-{}-check.log'
REGEX_ERROR = re.compile(r"^\[err", re.IGNORECASE)
REGEX_WARNING = re.compile(r"^\[warn", re.IGNORECASE)
STATUS_GREEN = 'Passing'
STATUS_RED = 'Failing'

HELP_TEXT = '''
Scans "./logs" and "./reports" folders for errors and warnings.
'''
parser = argparse.ArgumentParser(description=HELP_TEXT)

HELP_TEXT = '''
Level 0: only report fail/pass (default).
Level 1: report count per file.
Level 2: report full messages.
'''
parser.add_argument('--verbose', '-v',
                    required=False, default=0, action='count',
                    help=HELP_TEXT)

parser.add_argument('--quiet', '-q',
                    required=False, default=False, action='store_true',
                    help='Do not print report to stdout.')

parser.add_argument('--summary', '-s',
                    required=False, default=False, action='store_true',
                    help='Only write summary file.')

args = parser.parse_args()


def parse_messages(filename, print_missing=True):
    '''
    TODO: docs
    '''
    errors = list()
    warnings = list()
    try:
        with open(filename, 'r') as file:
            lines = file.readlines()
        for line in lines:
            if re.search(REGEX_ERROR, line):
                errors.append(line.strip())
            elif re.search(REGEX_WARNING, line):
                warnings.append(line.strip())
    except Exception as e:
        if print_missing:
            print(f"Failed to open {filename}. Check to see if design finished.")
    return errors, warnings


def gen_report(name, data):
    '''
    TODO: docs
    '''

    if args.verbose or data['drcList'] or data['status'] != STATUS_GREEN:
        output = f"{name}\n"
    else:
        output = ""

    if args.verbose:
        if data['finished']:
            output += '  Flow reached last stage.\n'
        else:
            output += f"  Last log file {data['lastLog']}\n"

    if args.verbose:
        output += f"  Found {len(data['logErrors'])} error(s) in the log files.\n"
    for error in data['logErrors']:
        output += f"      {error}\n"

    if args.verbose:
        output += f"  Found {len(data['logWarnings'])} warning(s) in the log files.\n"
    if args.verbose >= 2:
        for warning in data['logWarnings']:
            output += f"      {warning}\n"

    if args.verbose:
        output += f"  Found {len(data['metricsLogsErrors'])} error(s) while generating the metrics file.\n"
    for error in data['metricsLogsErrors']:
        output += f"      {error}\n"

    if args.verbose:
        output += f"  Found {len(data['metricsLogsWarnings'])} warning(s) while generating the metrics file.\n"
    if args.verbose >= 2:
        for warning in data['metricsLogsWarnings']:
            output += f"      {warning}\n"

    if args.verbose:
        output += f"  Found {len(data['metricsErrors'])} failures during metrics check.\n"
    for error in data['metricsErrors']:
        output += f"      {error}\n"

    if args.verbose:
        output += f"  Found {len(data['metricsWarnings'])} warning(s) during metrics check.\n"
    if args.verbose >= 2:
        for warning in data['metricsWarnings']:
            output += f"      {warning}\n"

    if d['drcList']:
        if data['status'] == STATUS_GREEN:
            output += '  Design has the following violations under the allowed limit: '
        else:
            output += '  Design has the following violations over the allowed limit: '
        for drc, count in data['drcList'].items():
            output += f"{drc} ({count}) "
        output += '\n'

    return output.strip()


def write_report(path, content):
    '''
    TODO: docs
    '''
    content = content.strip()
    with open(path, 'w') as file:
        file.write(content)
    if args.verbose:
        content += f"\nGenerated report file: {path}\n"
    with open(SINGLE_REPORT_FILENAME, 'a') as file:
        file.write(content)
        file.write('\n')
    if not args.quiet and content != '':
        print(content)


def get_summary(status, text):
    '''
    TODO: docs
    '''
    text += '-' * 30 + '\n'
    text += ' ' * 7 + f"{status} designs\n"
    text += '-' * 30 + '\n'
    for name, data in designList.items():
        if data['status'] == status:
            content = gen_report(name, data)
            if content != '':
                text += content + '\n'
                if args.verbose:  # add empty line for readability
                    text += '\n'
    return text


def write_summary():
    '''
    Write summary and individual report files with data on designList
    '''
    summary = '=' * 60 + '\n'
    summary += ' ' * 26 + 'SUMMARY\n'
    summary += '=' * 60 + '\n'
    summary += f"\nNumber of designs: {len(designList.keys())}\n\n"

    summary = get_summary(STATUS_GREEN, summary)
    summary = get_summary(STATUS_RED, summary)

    if summary != '':
        if not args.quiet:
            print(summary)
        with open(SUMMARY_FILENAME, 'a') as summaryFile:
            summaryFile.write(summary)
        if not args.quiet and args.verbose:
            print('Generated report file:', SINGLE_REPORT_FILENAME)
            print('Generated report summary file:', SINGLE_REPORT_FILENAME)


if os.path.isfile(SINGLE_REPORT_FILENAME):
    if not args.quiet:
        print(f"Overwriting report {SINGLE_REPORT_FILENAME}.")
    os.remove(SINGLE_REPORT_FILENAME)

if os.path.isfile(SUMMARY_FILENAME):
    if not args.quiet:
        print(f"Overwriting report summary {SUMMARY_FILENAME}.")
    os.remove(SUMMARY_FILENAME)

designList = dict()

for logDir, dirs, files in sorted(os.walk('logs', topdown=False)):
    dirList = logDir.split(os.sep)
    if len(dirList) != 4:
        continue
    reportDir = logDir.replace('logs', 'reports')

    # basic info about current design
    platform, design, variant = dirList[1:]
    d = dict()
    d['outputFile'] = os.path.join(reportDir, REPORT_FILENAME)

    # check if design ran to completion without errors or warnings
    for name in sorted(files):
        filename = os.path.join(logDir, name)
        d['logErrors'], d['logWarnings'] = parse_messages(filename)
        if name.endswith('.log'):
            d['lastLog'] = name
    d['finished'] = (d['lastLog'] == LAST_EXPECTED_LOG)

    # check if metrics generation had issues
    metricsLogFile = os.path.join(reportDir, METRICS_LOG_FMT.format(variant))
    d['metricsLogsErrors'], d['metricsLogsWarnings'] = parse_messages(metricsLogFile, print_missing=d['finished'])

    # check if metrics passed
    metricsCheckFile = os.path.join(reportDir, METRICS_CHECK_FMT.format(variant))
    d['metricsErrors'], d['metricsWarnings'] = parse_messages(metricsCheckFile, print_missing=d['finished'])

    # check if calibre was run and if drc check passed
    calibreCheckFile = os.path.join(logDir, 'calibre/save-to-drc-db.log')
    d['calibreErrors'], d['calibreWarnings'] = parse_messages(calibreCheckFile, print_missing=False)

    # check if there were drc violations
    d['drcList'] = dict()
    try:
        drcReportFile = os.path.join(reportDir, DRC_FILENAME)
        with open(drcReportFile, 'r') as file:
            for line in file.readlines():
                if 'violation type:' in line:
                    type_ = line.strip('violation type:').strip()
                    if type_ in d['drcList'].keys():
                        d['drcList'][type_] += 1
                    else:
                        d['drcList'][type_] = 1
    except Exception as e:
        if d['finished']:
            print(f"Failed to open {DRC_FILENAME}.")

    if d['logErrors'] or d['metricsErrors'] or d['calibreErrors']:
        d['status'] = STATUS_RED
    else:
        d['status'] = STATUS_GREEN

    designList[f"{platform} {design} ({variant})"] = d

if args.summary:
    write_summary()
else:
    for name, data in designList.items():
        write_report(data['outputFile'], gen_report(name, data))
