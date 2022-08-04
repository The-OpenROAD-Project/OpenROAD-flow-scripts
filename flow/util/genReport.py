#!/usr/bin/env python3
'''
Generate reports from current logs
'''
import argparse
import os
import re

os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))

LOGS_FOLDER = 'logs'
REPORTS_FOLDER = 'reports'
REPORT_FILENAME = 'report.log'
SINGLE_REPORT_FILENAME = f"{REPORTS_FOLDER}/report.log"
SUMMARY_FILENAME = f"{REPORTS_FOLDER}/report-summary.log"
DRC_FILENAME = '5_route_drc.rpt'
LAST_EXPECTED_LOG = '6_report.log'
METRICS_LOG_FMT = 'gen-metrics-{}-check.log'
METRICS_CHECK_FMT = '{}/metadata-{}-check.log'
REGEX_ERROR = re.compile(r"^\[error ?(\w+-\d+)?\]", re.IGNORECASE)
REGEX_WARNING = re.compile(r"^\[warning ?(\w+-\d+)?\]", re.IGNORECASE)
STATUS_GREEN = 'Passing'
STATUS_RED = 'Failing'

HELP_TEXT = '''
Scans "./logs" and "./reports" folders for errors and warnings.
'''
parser = argparse.ArgumentParser(description=HELP_TEXT)

HELP_TEXT = '''
Level 0: report error message id and drc types.
Level 1: report full error messages.
Level 2: report full error messages and warning messages id.
Level 3: report full error messages and full warning messages.
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
    except BaseException:
        if print_missing:
            print(f"Failed to open {filename}.")
    return errors, warnings


def append_text(list_, text, sup, regex, verbose):
    '''
    TODO
    '''
    if len(list_) == 0:
        return text
    text += f"  Found {len(list_)} {sup}.\n"
    if verbose >= 1:  # print full message
        for item in list_:
            text += f"      {item}\n"
    else:  # only print the id
        set_ = set()
        long_set = set()
        for item in list_:
            message = re.match(regex, item).group(1)
            if message is None:
                message = item
            if len(message) > 10:  # considering a std msg id XYZ-0000
                long_set.add(message)
            else:
                set_.add(message)
        set_ = sorted(set_, reverse=True)
        if set_:
            text += f"      {', '.join(set_)}\n"
        for item in long_set:
            text += f"      {item}\n"
    return text


def gen_report(name, data):
    '''
    TODO: docs
    '''

    if args.verbose >= 2 or data['drcs'] or data['status'] != STATUS_GREEN:
        output = f"{name}\n"
        if data['status'] == STATUS_RED:
            if data['finished']:
                output += '  Flow reached last stage.\n'
            else:
                output += f"  Last log file {data['last_log']}\n"
    else:
        output = ""

    output = append_text(data['log_errors'], output, 'errors in the logs', REGEX_ERROR, args.verbose)
    output = append_text(data['metrics_logs_errors'], output, 'errors in the metrics logs', REGEX_ERROR, args.verbose)
    output = append_text(data['metrics_errors'], output, 'metrics failures', REGEX_ERROR, args.verbose)

    if args.verbose >= 2:
        output = append_text(data['log_warnings'], output, 'warnings in the logs', REGEX_WARNING, args.verbose-2)
        output = append_text(data['metrics_logs_warnings'], output, 'warnings in the metrics logs', REGEX_WARNING, args.verbose-2)
        output = append_text(data['metrics_warnings'], output, 'metrics warnings', REGEX_WARNING, args.verbose-2)

    if d['drcs']:
        if data['status'] == STATUS_GREEN:
            output += '  Design has the violations under the allowed limit: '
        else:
            output += '  Design has the violations over the allowed limit: '
        for drc, count in data['drcs'].items():
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
        content += f"\n  Generated report file: {path}\n"
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
    for name, data in design_list.items():
        if data['status'] == status:
            content = gen_report(name, data)
            if content != '':
                text += content + '\n'
                # add empty line for readability
                if args.verbose >= 2 or status == STATUS_RED:
                    text += '\n'
    return text


def write_summary():
    '''
    Write summary and individual report files with data on design_list
    '''
    summary = '=' * 60 + '\n'
    summary += ' ' * 26 + 'SUMMARY\n'
    summary += '=' * 60 + '\n'
    summary += f"\nNumber of designs: {len(design_list.keys())}\n\n"

    summary = get_summary(STATUS_GREEN, summary)
    summary += '\n'
    summary = get_summary(STATUS_RED, summary)

    if not args.quiet:
        if os.path.isfile(SUMMARY_FILENAME):
            print(f"Overwriting report summary {SUMMARY_FILENAME}.")
        print(summary)
    with open(SUMMARY_FILENAME, 'w') as file:
        file.write(summary)
    if not args.quiet and args.verbose:
        print('Generated report summary file:', SUMMARY_FILENAME)


design_list = dict()

for log_dir, dirs, files in sorted(os.walk(LOGS_FOLDER, topdown=False)):
    dir_list = log_dir.split(os.sep)
    if len(dir_list) != 4:
        continue
    report_dir = log_dir.replace(LOGS_FOLDER, REPORTS_FOLDER)

    # basic info about current design
    platform, design, variant = dir_list[1:]
    d = dict()
    d['output_file'] = os.path.join(report_dir, REPORT_FILENAME)

    # check if design ran to completion without errors or warnings
    d['log_errors'] = list()
    d['log_warnings'] = list()
    for name_ in sorted(files):
        temp_e, temp_w = parse_messages(os.path.join(log_dir, name_))
        d['log_errors'] += temp_e
        d['log_warnings'] += temp_w
        if name_.endswith('.log'):
            d['last_log'] = name_
    d['finished'] = (d['last_log'] == LAST_EXPECTED_LOG)

    # check if metrics generation had issues
    d['metrics_logs_errors'], d['metrics_logs_warnings'] = parse_messages(
        os.path.join(report_dir, METRICS_LOG_FMT.format(variant)),
        print_missing=d['finished'])

    # check if metrics passed
    d['metrics_errors'], d['metrics_warnings'] = parse_messages(
        METRICS_CHECK_FMT.format(report_dir, variant),
        print_missing=d['finished'])

    # check if calibre was run and if drc check passed
    d['calibre_errors'], d['calibre_warnings'] = parse_messages(
        os.path.join(log_dir, 'calibre/save-to-drc-db.log'),
        print_missing=False)

    # check if there were drc violations
    d['drcs'] = dict()
    try:
        drc_report_file = os.path.join(report_dir, DRC_FILENAME)
        with open(drc_report_file, 'r') as file_:
            for line_ in file_.readlines():
                if 'violation type:' in line_:
                    type_ = line_.strip('violation type:').strip()
                    if type_ in d['drcs'].keys():
                        d['drcs'][type_] += 1
                    else:
                        d['drcs'][type_] = 1
    except BaseException:
        if d['finished']:
            print(f"Failed to open {DRC_FILENAME}.")

    if d['log_errors'] or d['metrics_errors'] or d['calibre_errors']:
        d['status'] = STATUS_RED
    else:
        d['status'] = STATUS_GREEN

    design_list[f"{platform} {design} ({variant})"] = d

if not os.path.isdir(REPORTS_FOLDER):
    os.mkdir(REPORTS_FOLDER)

if args.summary:
    write_summary()
else:
    if os.path.isfile(SINGLE_REPORT_FILENAME):
        if not args.quiet:
            print(f"Overwriting report {SINGLE_REPORT_FILENAME}.")
        os.remove(SINGLE_REPORT_FILENAME)
    for name_, data_ in design_list.items():
        write_report(data_['output_file'], gen_report(name_, data_))
