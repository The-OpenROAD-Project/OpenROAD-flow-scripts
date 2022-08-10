#!/usr/bin/env python3

# This scripts attempts to extract relevant data from a completed flow design
# and save it into a 'metadata.json'. It achieves this by looking for specific
# information in specific files using regular expressions
# -----------------------------------------------------------------------------

import os
from sys import exit
from datetime import datetime, timedelta
from collections import defaultdict
from uuid import uuid4 as uuid
from subprocess import check_output, call, STDOUT

import argparse
import json
import pandas as pd
import re
from glob import glob

# make sure the working dir is flow/
os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)) , '..'))

# Parse and validate arguments
# =============================================================================


def parse_args():
    parser = argparse.ArgumentParser(
        description='Generates metadata from OpenROAD flow')
    parser.add_argument('--flowPath',
                        '-f',
                        required=False,
                        default='./',
                        help='Path to the flow directory')
    parser.add_argument('--design',
                        '-d',
                        required=False,
                        default='all_designs',
                        help='Design Name for metrics')
    parser.add_argument('--flowVariant',
                        '-v',
                        required=False,
                        default='base',
                        help='FLOW_VARIANT for the design')
    parser.add_argument('--platform',
                        '-p',
                        required=False,
                        default='nangate45',
                        help='Design Platform')
    parser.add_argument('--comment',
                        '-c',
                        required=False,
                        default='',
                        help='Additional comments to embed')
    parser.add_argument('--output',
                        '-o',
                        required=False,
                        default='metadata.json',
                        help='Output file')
    parser.add_argument('--hier',
                        '-x',
                        action='store_true',
                        help='Hierarchical JSON')
    args = parser.parse_args()

    if not os.path.isdir(args.flowPath):
        print('[ERROR] flowPath does not exist')
        print('Path: ' + args.flowPath)
        exit(1)

    return args


# Functions
# =============================================================================
# Main function to do specific extraction of patterns from a file

# This function will look for a regular expression 'pattern' in a 'file', and
# set the key, 'jsonTag', to the value found. The specific 'occurrence' selects
# which occurrence it uses (default -1, i.e., last). If pattern not found, it
# will print an error and set the value to N/A. If a 'defaultNotFound' is set,
# it will use that instead.  If count is set to True, it will return the count
# of the pattern.

def extractTagFromFile(jsonTag, jsonFile, pattern, file, count=False,
                       occurrence=-1, defaultNotFound='N/A', t=str,
                       required=True):
    if jsonTag in jsonFile:
        print('[WARN] Overwriting Tag', jsonTag)

    # Open file
    try:
        searchFilePath = os.path.join(args.flowPath, file)
        with open(searchFilePath) as f:
            content = f.read()

        parsedMetrics = re.findall(pattern, content, re.M)

        patternNotFound = (len(parsedMetrics) < abs(occurrence))
        if patternNotFound and not required:
            jsonFile[jsonTag] = defaultNotFound
            return

        if parsedMetrics:
            if count:
                # Return the count
                jsonFile[jsonTag] = len(parsedMetrics)
            else:
                # Note: This gets the specified occurrence
                value = parsedMetrics[occurrence]
                value = value.strip()
                try:
                    jsonFile[jsonTag] = float(value)
                except BaseException:
                    jsonFile[jsonTag] = str(value)
        else:
            # Only print a warning if the defaultNotFound is not set
            print('[WARN] Tag {} not found in {}.'.format(jsonTag,
                                                          searchFilePath),
                  'Will use {}.'.format(defaultNotFound))
            jsonFile[jsonTag] = defaultNotFound
    except IOError:
        print('[ERROR] Failed to open file:', searchFilePath)
        jsonFile[jsonTag] = 'ERR'


def extractGnuTime(prefix, jsonFile, file):

    extractTagFromFile(
        prefix +
        '__runtime__total',
        jsonFile,
        '^Elapsed time: (\S+)\[h:\]min:sec.*',
        file)
    extractTagFromFile(
        prefix +
        '__cpu__total',
        jsonFile,
        '^Elapsed time:.*CPU time: user (\S+) .*',
        file)
    extractTagFromFile(
        prefix +
        '__mem__peak',
        jsonFile,
        '^Elapsed time:.*Peak memory: (\S+)KB.',
        file)

#
# Extract Clock Latency, Skew numbers
# Need to extract these from native json
#
def get_skew_latency(file_name):
    f = None
    try:
        f = open(file_name, 'r')
    except IOError:
        print('[WARN] Failed to open file:', file_name)
        return ('ERR', 'ERR', 'ERR')

    lines = f.readlines()
    f.close()

    latency_section = False
    latency_max = latency_min = skew = 0.0
    worst_latency_max = worst_latency_min = worst_skew = 0.0

    for line in lines:
        if len(line.split()) < 1:
            continue
        if line.startswith('Latency'):
            latency_section = True
            continue
        if latency_section and len(line.split()) == 1:
            latency_max = float(line.split()[0])
            continue
        if latency_section and len(line.split()) > 2:
            latency_min = float(line.split()[0])
            skew = float(line.split()[2])
            if skew > worst_skew:
                worst_skew = skew
                worst_latency_max = latency_max
                worst_latency_min = latency_min
            latency_section = False

    return(worst_latency_max, worst_latency_min, worst_skew)


#
#  Extract clock info from sdc file
#
def read_sdc(file_name):
    clkList = []
    sdcFile = None

    try:
        sdcFile = open(file_name, 'r')
    except IOError:
        print('[WARN] Failed to open file:', file_name)
        return clkList

    lines = sdcFile.readlines()
    sdcFile.close()

    for line in lines:
        if len(line.split()) < 2:
            continue
        if line.split()[0] == 'create_clock':
            clk_idx = line.split().index('-name')
            clkName = line.split()[clk_idx + 1]
            period_idx = line.split().index('-period')
            period = line.split()[period_idx + 1]

            clk = '%s: %s' % (clkName, period)
            clkList.append(clk)

    clkList.sort()
    return clkList


# Main
# =============================================================================

def is_git_repo(folder=None):
    cmd = ['git', 'branch']
    if folder is not None:
        return call(cmd, stderr=STDOUT, stdout=open(os.devnull, 'w'),
                    cwd=folder) == 0
    else:
        return call(cmd, stderr=STDOUT, stdout=open(os.devnull, 'w')) == 0

def merge_jsons(root_path, output, files):
    paths = sorted(glob(os.path.join(root_path, files)))
    for path in paths:
        file = open(path, "r")
        data = json.load(file)
        output.update(data)
        file.close()


def extract_metrics(cwd, platform, design, flow_variant, output, hier_json):
    baseRegEx = '^{}\n^-*\n^{}'

    logPath = os.path.join(cwd, 'logs', platform, design, flow_variant)
    rptPath = os.path.join(cwd, 'reports', platform, design, flow_variant)
    resultPath = os.path.join(cwd, 'results', platform, design, flow_variant)

    metrics_dict = defaultdict(dict)
    metrics_dict['run__flow__generate_date'] = now.strftime('%Y-%m-%d %H:%M')
    metrics_dict['run__flow__metrics_version'] = 'Metrics_2.1.2'
    cmdOutput = check_output(['openroad', '-version'])
    cmdFields = [x.decode('utf-8') for x in cmdOutput.split()]
    metrics_dict['run__flow__openroad_version'] = str(cmdFields[0])
    if len(cmdFields) > 1:
        metrics_dict['run__flow__openroad_commit'] = str(cmdFields[1])
    else:
        metrics_dict['run__flow__openroad_commit'] = 'N/A'
    if is_git_repo():
        cmdOutput = check_output(['git', 'rev-parse', 'HEAD'])
        cmdOutput = cmdOutput.decode('utf-8').strip()
    else:
        cmdOutput = 'not a git repo'
        print('[WARN]', cmdOutput)
    metrics_dict['run__flow__scripts_commit'] = cmdOutput
    metrics_dict['run__flow__uuid'] = str(uuid())
    metrics_dict['run__flow__design'] = design
    metrics_dict['run__flow__platform'] = platform
    platformDir = os.environ.get('PLATFORM_DIR')
    if platformDir is None:
        print('[INFO]', 'PLATFORM_DIR env variable not set')
        cmdOutput = 'N/A'
    elif is_git_repo(folder=platformDir):
        cmdOutput = check_output(['git', 'rev-parse', 'HEAD'], cwd=platformDir)
        cmdOutput = cmdOutput.decode('utf-8').strip()
    else:
        print('[WARN]', 'not a git repo')
        cmdOutput = 'N/A'
    metrics_dict['run__flow__platform_commit'] = cmdOutput
    metrics_dict['run__flow__variant'] = flow_variant


    # Synthesis
    # =========================================================================

    extractTagFromFile('synth__design__instance__count__stdcell',
                       metrics_dict,
                       'Number of cells: +(\S+)',
                       rptPath + '/synth_stat.txt')

    extractTagFromFile('synth__design__instance__area__stdcell',
                       metrics_dict,
                       'Chip area for module.*: +(\S+)',
                       rptPath + '/synth_stat.txt')

    extractGnuTime('synth', metrics_dict, logPath + '/1_1_yosys.log')

    # Clocks
    # =========================================================================

    clk_list = read_sdc(resultPath + '/2_floorplan.sdc')
    metrics_dict['constraints__clocks__count'] = len(clk_list)
    metrics_dict['constraints__clocks__details'] = clk_list

    # Floorplan
    # =========================================================================
    merge_jsons(logPath, metrics_dict, "2_*.json")

    extractGnuTime('floorplan', metrics_dict, logPath + '/2_4_mplace.log')

    # Place
    # =========================================================================

    merge_jsons(logPath, metrics_dict, "3_*.json")
    extractGnuTime('placeopt', metrics_dict, logPath + '/3_4_resizer.log')
    extractTagFromFile('detailedplace__design__violations',
                       metrics_dict,
                       '^\[INFO FLW-0012\] Placement violations (\S+).',
                       logPath + '/3_5_opendp.log', defaultNotFound=0)

    extractGnuTime('detailedplace', metrics_dict, logPath + '/3_5_opendp.log')

    # CTS
    # =======================================================================

    merge_jsons(logPath, metrics_dict, "4_*.json")
    extractTagFromFile('cts__design__instance__count__setup_buffer',
                       metrics_dict,
                       'Inserted (\d+) buffers',
                       logPath + '/4_1_cts.log',
                       defaultNotFound=0)

    extractTagFromFile('cts__design__instance__count__hold_buffer',
                       metrics_dict,
                       'Inserted (\d+) hold buffers',
                       logPath + '/4_1_cts.log',
                       defaultNotFound=0)
    # Global Route
    # =========================================================================

    merge_jsons(logPath, metrics_dict, "5_*.json")
    extractTagFromFile('globalroute__timing__clock__slack',
                       metrics_dict,
                       '^\[INFO FLW-....\] Clock .* slack (\S+)',
                       logPath + '/5_1_fastroute.log')

    # Finish
    # =========================================================================

    merge_jsons(logPath, metrics_dict, "6_*.json")
    extractTagFromFile('finish__timing__drv__setup_violation_count',
                       metrics_dict,
                       baseRegEx.format('finish setup_violation_count',
                                        'setup violation count (\S+)'),
                       logPath + '/6_report.log')
    extractTagFromFile('finish__timing__drv__hold_violation_count',
                       metrics_dict,
                       baseRegEx.format('finish hold_violation_count',
                                        'hold violation count (\S+)'),
                       logPath + '/6_report.log')
    extractTagFromFile('finish__timing__wns_percent_delay',
                       metrics_dict,
                       baseRegEx.format('finish slack div critical path delay',
                                        '(\S+)'),
                       logPath + '/6_report.log')

    extractGnuTime('finish', metrics_dict, logPath + '/6_report.log')

    # Accumulate time
    # =========================================================================

    failed = False
    total = timedelta()
    for key in metrics_dict:
        if key.endswith('__runtime__total'):
            # Big try block because Hour and microsecond is optional
            try:
                t = datetime.strptime(metrics_dict[key], '%H:%M:%S.%f')
            except ValueError:
                try:
                    t = datetime.strptime(metrics_dict[key], '%M:%S.%f')
                except ValueError:
                    try:
                        t = datetime.strptime(metrics_dict[key], '%H:%M:%S')
                    except ValueError:
                        try:
                            t = datetime.strptime(metrics_dict[key], '%M:%S')
                        except ValueError:
                            failed = True
                            break

            delta = timedelta(hours=t.hour, minutes=t.minute,
                              seconds=t.second, microseconds=t.microsecond)
            total += delta

    if failed:
        metrics_dict['total_time'] = 'ERR'
    else:
        metrics_dict['total_time'] = str(total)

    metrics_df = pd.DataFrame(list(metrics_dict.items()))
    col_index = metrics_df.iloc[0][1] + '__' + metrics_df.iloc[1][1]
    metrics_df.columns = ['Metrics', col_index]

    if hier_json:
        # Convert the Metrics dictionary to hierarchical format by stripping
        # the stage as a 'key'
        hier_dict = defaultdict(dict)
        for metric in metrics_dict:
            key_list = metric.split('__', 1)
            if len(key_list) == 2:
                hier_dict[key_list[0]][key_list[1]] = metrics_dict[metric]
        metrics_dict = hier_dict

    with open(output, 'w') as resultSpecfile:
        json.dump(metrics_dict, resultSpecfile, indent=2)

    return metrics_dict, metrics_df


args = parse_args()
now = datetime.now()
flow_variants = args.flowVariant.split()
all_designs =  True if args.design == 'all_designs' else False

designs = args.design.split()
if all_designs or len(designs) > 1 or len(flow_variants) > 1:
    rootdir = './logs'

    all_df = pd.DataFrame()
    all_d = []

    cwd = os.getcwd()
    for platform_it in os.scandir(rootdir):
        if not platform_it.is_dir():
            continue
        plt = platform_it.name
        for design_it in os.scandir(platform_it.path):
            if not design_it.is_dir():
                continue
            des = design_it.name
            if not (all_designs or des in designs):
                continue
            for variant in flow_variants:
                design_dir = os.path.join(cwd, 'reports', plt, des, variant)
                if not os.path.isdir(design_dir):
                    continue
                print(f'Extract Metrics for {plt}, {des}, {variant}')
                file = '/'.join(['reports', plt, des, variant, 'metrics.json'])
                metrics, df = extract_metrics(cwd, plt, des, variant,
                                              file, args.hier)
                all_d.append(metrics)
                if all_df.shape[0] == 0:
                    all_df = df
                else:
                    all_df = all_df.merge(df, on='Metrics', how='inner')

    with open('metrics.json', 'w') as outFile:
        json.dump(all_d, outFile, indent=2)

    with open('metrics.html', 'w') as f:
        f.write(all_df.to_html())
else:
    metrics_dict, metrics_df = extract_metrics(args.flowPath, args.platform,
                                               args.design, args.flowVariant,
                                               args.output, args.hier)
