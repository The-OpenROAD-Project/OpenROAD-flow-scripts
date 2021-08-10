#!/usr/bin/env python3

import argparse
import os
import re

# make sure the working dir is flow/
os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)) , '..'))

reportFilename = 'report.log'
singleReportFilename = 'reports/' + reportFilename
drcFilename = '5_route_drc.rpt'
lastExpectedLog = '6_report.log'
metricsLogFmt = 'gen-metrics-{}-check.log'
metricsCheckFmt = 'metadata-{}-check.log'
regexError = re.compile(r"^\[?err", re.IGNORECASE)
regexWarning = re.compile(r"^\[?warn", re.IGNORECASE)

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

parser.add_argument('--file', '-f',
                    required=False, default=False, action='store_true',
                    help='Generate final report file.')

parser.add_argument('--no-print', '-q',
                    required=False, default=False, action='store_true',
                    help='Do not print report to stdout.')

parser.add_argument('--single', '-s',
                    required=False, default=False, action='store_true',
                    help='Generate aggregated file with all reports.')

args = parser.parse_args()
verbose = args.verbose
generateSingleFile = args.single
generateFile = args.file
printOutput = not args.no_print


def parseMessages(filename):
    errors = list()
    warnings = list()
    try:
        with open(filename, 'r') as f:
            lines = f.readlines()
    except Exception as e:
        msg = 'Failed to open ' + filename + '.'
        msg += ' Check to see if design finished.'
        print(msg)
        return [msg], [msg]
    for line in lines:
        if re.search(regexError, line):
            errors.append(line.strip())
        elif re.search(regexWarning, line):
            warnings.append(line.strip())
    return errors, warnings


def finish(output, outputFile='', summary=False):
    output = output.strip()
    if generateFile and not summary and outputFile != '':
        with open(outputFile, 'w') as f:
            f.write(output)
        output += '\nGenerated report file: ' + outputFile + '\n'
    if generateSingleFile:
        if summary:
            with open(singleReportFilename, 'r+') as f:
                content = f.read()
                f.seek(0, 0)
                content = output + '\n\n' + '=' * 60 + '\n\n' + content
                f.write(content.strip())
        else:
            with open(singleReportFilename, 'a') as f:
                f.write(output)
                f.write('\n\n')
    if printOutput or summary:
        print(output)
    if verbose != 0 and printOutput:
        print()


if generateSingleFile:
    if os.path.isfile(singleReportFilename):
        print('Overwrtting report {}.'.format(singleReportFilename))
        os.remove(singleReportFilename)

designsWithError = list()
designsRed = list()
designsWithViolations = list()
designCount = 0

for logDir, dirs, files in sorted(os.walk('logs', topdown=False)):
    dirList = logDir.split(os.sep)
    if len(dirList) != 4:
        continue
    designCount += 1
    reportDir = logDir.replace('logs', 'reports')
    outputFile = os.path.join(reportDir, reportFilename)

    # basic info about current design
    platform, design, variant = dirList[1:]

    # check if design ran to completion without errors or warnings
    logErrors = dict()
    logWarnings = dict()
    numLogErrors = 0
    numLogWarnings = 0
    for name in sorted(files):
        filename = os.path.join(logDir, name)
        logErrors[name], logWarnings[name] = parseMessages(filename)
        numLogErrors += len(logErrors[name])
        numLogWarnings += len(logWarnings[name])
        if name.endswith('.log'):
            lastLog = name
    finished = (lastLog == lastExpectedLog)

    # check if metrics generation had issues
    metricsLogFile = os.path.join(reportDir, metricsLogFmt.format(variant))
    metricsLogErrors, metricsLogWarnings = parseMessages(metricsLogFile)
    numMetricsLogErrors = len(metricsLogErrors)
    numMetricsLogWarnings = len(metricsLogWarnings)

    # check if metrics passed
    metricsCheckFile = os.path.join(reportDir, metricsCheckFmt.format(variant))
    metricsErrors, metricsWarnings = parseMessages(metricsCheckFile)
    numMetricsErrors = len(metricsErrors)
    numMetricsWarnings = len(metricsWarnings)

    # check if there were drc violations
    drcReportFile = os.path.join(reportDir, drcFilename)
    try:
        with open(drcReportFile, 'r') as f:
            drcList = [l.strip() for l in f.readlines()]
    except Exception as e:
        msg = 'Failed to open ' + drcFilename + '.'
        msg += ' DRT probablye did not finished'
        print(msg)
        drcList = [msg]

    totalNumErrors = numLogErrors
    totalNumErrors += numMetricsErrors
    totalNumErrors += numMetricsLogErrors
    totalNumErrors += len(drcList)

    currentRun = '{} {} ({})'.format(platform, design, variant)

    if totalNumErrors != 0:
        designsWithError.append(currentRun)
    if numMetricsErrors != 0:
        designsRed.append(currentRun)
    if len(drcList) != 0:
        designsWithViolations.append(currentRun)

    output = currentRun + '\n'
    currentRun = 'Parsing files for ' + currentRun
    # check if should print without errors
    if verbose == 0 and totalNumErrors == 0:
        finish(currentRun)
        continue
    elif verbose == 0:
        finish(currentRun)
        continue

    if finished:
        output += '  Flow reached last stage.\n'
    else:
        output += '  Last log file {}\n'.format(lastLog)

    if numLogErrors == 0:
        output += '  No error found in the log files.\n'
    else:
        output += '  Found {} error(s) in the log files.\n'.format(numLogErrors)
        if verbose >= 2:
            for key, errorList in logErrors.items():
                if len(errorList) == 0:
                    continue
                output += '    File {}'.format(key)
                output += ' has {} error(s).\n'.format(len(errorList))
                if verbose >= 3:
                    for error in errorList:
                        output += '      {}\n'.format(error)
    if numLogWarnings == 0:
        output += '  No warning found in the log files.\n'
    else:
        output += '  Found {}'.format(numLogWarnings)
        output += ' warning(s) in the log files.\n'
        if verbose >= 2:
            for key, warningList in logWarnings.items():
                if len(warningList) == 0:
                    continue
                output += '    File {}'.format(key)
                output += ' has {} warning(s).\n'.format(len(warningList))
                if verbose >= 3:
                    for warning in warningList:
                        output += '      {}\n'.format(warning)

    if numMetricsLogErrors == 0:
        output += '  No error found while generating the metrics file.\n'
    else:
        output += '  Found {} '.format(numMetricsLogErrors)
        output += 'error(s) while generating the metrics file.\n'
        for e in metricsLogErrors:
            output += '    {}\n'.format(e)
    if numMetricsLogWarnings == 0:
        output += '  No warning found while generating the metrics file.\n'
    else:
        output += '  Found {}'.format(numMetricsLogWarnings)
        output += ' warning(s) while generating the metrics file.\n'
        if verbose >= 3:
            for e in metricsLogWarnings:
                output += '    {}\n'.format(e)

    if numMetricsErrors == 0:
        output += '  No metrics check failed.\n'
    else:
        output += '  Found {}'.format(numMetricsErrors)
        output += ' failures during metrics check.\n'
        for e in metricsErrors:
            output += '    {}\n'.format(e)
    if numMetricsWarnings == 0:
        output += '  No warning found during metrics check.\n'
    else:
        output += '  Found {}'.format(numMetricsWarnings)
        output += ' warning(s) during metrics check.\n'
        if verbose >= 3:
            for e in metricsWarnings:
                output += '    {}\n'.format(e)

    if len(drcList) == 0:
        output += '  No violations found.'
    else:
        output += '  Found the following violations:'
        for drc in drcList:
            output += '\n    {}'.format(drc)

    finish(output, outputFile)


output = '''
============================================================
                          SUMMARY
============================================================

Number of designs: {}.

'''.format(designCount)
if len(designsWithError) == 0:
    output += 'All designs logs are clean.\n'
else:
    output += 'List of designs with at least one error in their logs:\n'
    for design in designsWithError:
        output += '  ' + design + '\n'

if len(designsRed) == 0:
    output += '\nAll designs are green.\n'
else:
    output += '\nList of red designs:\n'
    for design in designsRed:
        output += '  ' + design + '\n'

if len(designsWithViolations) == 0:
    output += '\nAll designs have zero violations.\n'
else:
    output += '\nList of designs with violations:'
    for design in designsWithViolations:
        output += '\n  ' + design

finish(output, summary=True)

if generateSingleFile:
    print('Generated aggregated file:', singleReportFilename)
