#!/usr/bin/env python3

# This scripts attempts to extract relevant data from a completed flow design
# and save it into a "metadata.json". It achieves this by looking for specific
# information in specific files using regular expressions
#-------------------------------------------------------------------------------

import argparse  # argument parsing
import json  # json parsing
import pandas as pd
import subprocess
import sys
import re
import os  # filesystem manipulation
import datetime
import uuid
import platform
from collections import OrderedDict


# Parse and validate arguments
# ==============================================================================
def parse_args():
  parser = argparse.ArgumentParser(
      description='Generates metadata from OpenROAD flow')
  parser.add_argument('--flowPath', '-f', required=False, default="./",
                      help='Path to the flow directory')
  parser.add_argument('--design', '-d', required=False, default="all_designs",
                      help='Path to the flow directory')
  parser.add_argument('--platform', '-p', required=False, default="nangage45",
                      help='Path to the flow directory')
  parser.add_argument('--comment', '-c', required=False, default="",
                      help='Additional comments to embed')
  parser.add_argument('--output', '-o', required=False, default="metadata.json",
                      help='Output file')
  args = parser.parse_args()

  if not os.path.isdir(args.flowPath):
    print("Error: flowPath does not exist")
    print("Path: " + args.flowPath)
    sys.exit(1)

  return args


# Functions
# ==============================================================================
# Main function to do specific extraction of patterns from a file

# This function will look for a regular expression "pattern" in a "file", and
# set the key, "jsonTag", to the value found. The specific "occurrence" selects
# which occurrence it uses (default -1, i.e., last). If pattern not found, it
# will print an error and set the value to N/A. If a "defaultNotFound" is set,
# it will use that instead.  If count is set to True, it will return the count
# of the pattern.

def extractTagFromFile(jsonTag, jsonFile, pattern, file, count=False, occurrence=-1, defaultNotFound="N/A", t=str):
  if jsonTag in jsonFile:
    print("[WARN] Overwriting Tag", jsonTag)

  # Open file
  try:
    searchFilePath = os.path.join(args.flowPath, file)
    with open(searchFilePath) as f:
      content = f.read()

    m = re.findall(pattern, content, re.M)

    if m:
      if count:
        # Return the count
        jsonFile[jsonTag] = len(m)
      else:
        # Note: This gets the specified occurrence
        value = m[occurrence]
        if isinstance(value, tuple):
          value = value[arrayPos]
        value = value.strip()
        try:
          jsonFile[jsonTag] = float(value)
        except:
          jsonFile[jsonTag] = str(value)
    else:
      # Only print a warning if the defaultNotFound is not set
      if defaultNotFound == "N/A":
        print("[WARN] Tag", jsonTag, "not found in", searchFilePath)
      jsonFile[jsonTag] = defaultNotFound
  except IOError:
    print("[WARN] Failed to open file:", searchFilePath)
    jsonFile[jsonTag] = "ERR"


def extractGnuTime(prefix, file, jsonFile):
  extractTagFromFile(prefix + "__runtime__total", jsonFile,
                     "^(\S+)elapsed \S+CPU \S+memKB",
                     file)
  extractTagFromFile(prefix + "__cpu__total", jsonFile,
                     "^\S+elapsed (\S+)CPU \S+memKB",
                     file)
  extractTagFromFile(prefix + "__mem__peak", jsonFile,
                     "^\S+elapsed \S+CPU (\S+)memKB",
                     file)


#
#  Extract clock info from sdc file
#
def read_sdc(file_name):
  sdcFile = open(file_name, 'r')
  lines = sdcFile.readlines()
  sdcFile.close()

  clkList = []
  for line in lines:
    if len(line.split())<2:
      continue
    if line.split()[0]=='create_clock':
      clk_idx = line.split().index('-name')
      clkName = line.split()[clk_idx+1]
      period_idx = line.split().index('-period')
      period = line.split()[period_idx+1]

      clk = "%s: %s"%(clkName, period)
      clkList.append(clk)


  clkList.sort()
  return clkList


# Main
# ==============================================================================

def extract_metrics(cwd, platform, design, output):
    logPath = os.path.join(cwd, "logs", platform, design)
    rptPath = os.path.join(cwd, "reports", platform, design)
    resultPath = os.path.join(cwd, "results", platform, design)

    metrics_dict = {}
    metrics_dict["run__flow__generate__date"] = now.strftime("%Y-%m-%d %H:%M")
    cmdOutput = subprocess.check_output(['openroad', '-version'])
    cmdFields = cmdOutput.split()
    cmdFields = [ x.decode('utf-8') for x in cmdOutput.split()  ]
    metrics_dict["run__flow__openroad__version"] = str(cmdFields[0])
    if (len(cmdFields) > 1):
      metrics_dict["run__flow__openroad__commit"] = str(cmdFields[1])
    else:
      metrics_dict["run__flow__openroad__commit"] = "N/A"
    metrics_dict["run__flow__uuid"] = str(uuid.uuid4())
    metrics_dict["run__flow__design"] = design
    metrics_dict["run__flow__platform"] = platform

# Synthesis
# ==============================================================================

    extractTagFromFile("synth__area__stdcell__count", metrics_dict,
                       "Number of cells: +(\S+)",
                       rptPath+"/synth_stat.txt")

    extractTagFromFile("synth__area__stdcell__area", metrics_dict,
                       "Chip area for module.*: +(\S+)",
                       rptPath+"/synth_stat.txt")

# Clocks
#===============================================================================

    clk_list = read_sdc(resultPath+"/2_floorplan.sdc")
    metrics_dict["constraints__clocks__count"] = len(clk_list)
    metrics_dict["constraints__clocks__details"] = clk_list

# Floorplan
# ==============================================================================

    extractTagFromFile("floorplan__timing__tns_total", metrics_dict,
                       "^tns (\S+)",
                       logPath+"/2_1_floorplan.log")

    extractTagFromFile("floorplan__timing__wns__worst", metrics_dict,
                       "^wns (\S+)",
                       logPath+"/2_1_floorplan.log")

    extractTagFromFile("floorplan__area__stdcell__count", metrics_dict,
                       "^Design area (\S+) u\^2",
                       logPath+"/2_1_floorplan.log")

    extractTagFromFile("floorplan__area__instance__util", metrics_dict,
                       "^Design area.* (\S+)% utilization",
                       logPath+"/2_1_floorplan.log")

    extractTagFromFile("floorplan__area__IO__count", metrics_dict,
                       "Num of I/O +(\d+)",
                       logPath+"/3_2_place_iop.log")

    extractTagFromFile("floorplan__area__macros__count", metrics_dict,
                       "Extracted # Macros: (\S+)",
                       logPath+"/2_4_mplace.log", defaultNotFound=0)

# Place
# ==============================================================================

    extractTagFromFile("globalplace__area__density__target", metrics_dict,
                       "TargetDensity: (\S+)",
                       logPath+"/3_1_place_gp.log")

    extractTagFromFile("globalplace__area__wirelength__estimate", metrics_dict,
                       "Total wirelength: (\S+)",
                       logPath+"/3_1_place_gp.log")

    extractTagFromFile("globalplace__timing__tns__total", metrics_dict,
                      "^tns (\S+)",
                      logPath+"/3_1_place_gp.log")

    extractTagFromFile("globalplace__timing__wns__worst", metrics_dict,
                      "^wns (\S+)",
                      logPath+"/3_1_place_gp.log")

    extractTagFromFile("placeopt__area__inbuffer__count", metrics_dict,
                       "Inserted (\d+) input buffers",
                       logPath+"/3_3_resizer.log")

    extractTagFromFile("placeopt__area__outbuffer__count", metrics_dict,
                       "Inserted (\d+) output buffers",
                       logPath+"/3_3_resizer.log")

    extractTagFromFile("placeopt__area__resize__count", metrics_dict,
                       "Resized (\d+) instances",
                       logPath+"/3_3_resizer.log")

    extractTagFromFile("placeopt__timing__tns__total", metrics_dict,
                       "^tns (\S+)",
                       logPath+"/3_3_resizer.log")

    extractTagFromFile("placeopt__timing__wns__worst", metrics_dict,
                       "^wns (\S+)",
                       logPath+"/3_3_resizer.log")

    extractTagFromFile("placeopt__area__instance__area", metrics_dict,
                       "^Design area (\S+) u\^2",
                       logPath+"/3_3_resizer.log")

    extractTagFromFile("placeopt__area__instance__util", metrics_dict,
                       "^Design area.* (\S+)% utilization",
                       logPath+"/3_3_resizer.log")

    extractTagFromFile("detailedplace__timing__tns__total", metrics_dict,
                       "^tns (\S+)",
                       logPath+"/3_4_opendp.log")

    extractTagFromFile("detailedplace__timing__wns__worst", metrics_dict,
                       "^wns (\S+)",
                       logPath+"/3_4_opendp.log")

    extractTagFromFile("detailedplace__inst__displacement__total", metrics_dict,
                       "total displacement +(\d*\.?\d*)",
                       logPath+"/3_4_opendp.log")

    extractTagFromFile("detailedplace__inst__displacement__average", metrics_dict,
                       "average displacement +(\d*\.?\d*)",
                       logPath+"/3_4_opendp.log")

    extractTagFromFile("detailedplace__inst__displacement__max", metrics_dict,
                       "max displacement +(\d*\.?\d*)",
                       logPath+"/3_4_opendp.log")

    extractTagFromFile("detailedplace__wirelength__initial__estimate", metrics_dict,
                       "original HPWL +(\d*\.?\d*)",
                       logPath+"/3_4_opendp.log")

    extractTagFromFile("detailedplace__wirelength__final__estimate", metrics_dict,
                       "legalized HPWL +(\d*\.?\d*)",
                       logPath+"/3_4_opendp.log")

# CTS
# ==============================================================================

    extractTagFromFile("cts__timing__slack__tns", metrics_dict,
                       "^tns (\S+)",
                       logPath+"/4_1_cts.log")

    extractTagFromFile("cts__timing__slack__wns", metrics_dict,
                       "^wns (\S+)",
                       logPath+"/4_1_cts.log")

# Route
# ==============================================================================

    extractTagFromFile("globalroute__timing__tns__total", metrics_dict,
                      "^tns (\S+)",
                      logPath+"/5_1_fastroute.log")

    extractTagFromFile("globalroute__timing__wns__worst", metrics_dict,
                      "^wns (\S+)",
                      logPath+"/5_1_fastroute.log")

    extractTagFromFile("detailedroute__wirelength", metrics_dict,
                       "total wire length = +(\S+) um",
                       logPath+"/5_2_TritonRoute.log")

    extractTagFromFile("detailedroute__via__count", metrics_dict,
                       "total number of vias = +(\S+)",
                       logPath+"/5_2_TritonRoute.log")

    extractTagFromFile("detailedroute__errors__count", metrics_dict,
                       "(?i)error:",
                       logPath+"/5_2_TritonRoute.log",
                       count=True, defaultNotFound=0)

    extractTagFromFile("detailedroute__drc__error__count", metrics_dict,
                       "(?i)violation",
                       rptPath+"/5_route_drc.rpt",
                       count=True, defaultNotFound=0)

# Finish
# ==============================================================================

    extractTagFromFile("finish__power__internal__total", metrics_dict,
                       "Total +(\S+) +\S+ +\S+ +\S+ +\S+",
                       logPath+"/6_report.log")

    extractTagFromFile("finish__power__switch__total", metrics_dict,
                       "Total +\S+ +(\S+) +\S+ +\S+ +\S+",
                       logPath+"/6_report.log")

    extractTagFromFile("finish__power__leak__total", metrics_dict,
                       "Total +\S+ +\S+ +(\S+) +\S+ +\S+",
                       logPath+"/6_report.log")

    extractTagFromFile("finish__power__total", metrics_dict,
                       "Total +\S+ +\S+ +\S+ +(\S+) +\S+",
                       logPath+"/6_report.log")

    extractTagFromFile("finish__area", metrics_dict,
                      "^Design area (\S+) u\^2",
                       logPath+"/6_report.log")

    extractTagFromFile("finish__util", metrics_dict,
                      "^Design area.* (\S+)% utilization",
                       logPath+"/6_report.log")

# Accumulate time
# ==============================================================================

    failed = False
    total = datetime.timedelta()
    for key in metrics_dict:
      if key.endswith("_time"):
        # Big try block because Hour and microsecond is optional
        try:
          t = datetime.datetime.strptime(metrics_dict[key],"%H:%M:%S.%f")
        except ValueError:
          try:
            t = datetime.datetime.strptime(metrics_dict[key],"%M:%S.%f")
          except ValueError:
            try:
              t = datetime.datetime.strptime(metrics_dict[key],"%H:%M:%S")
            except ValueError:
              try:
                t = datetime.datetime.strptime(metrics_dict[key],"%M:%S")
              except ValueError:
                failed = True
                break

        delta = datetime.timedelta(hours=t.hour, minutes=t.minute, seconds=t.second)
        total += delta

    if failed:
      metrics_dict["total_time"] = "ERR"
    else:
      metrics_dict["total_time"] = str(total)

    with open(output, "w") as resultSpecfile:
        json.dump(metrics_dict, resultSpecfile, indent=2)

    metrics_df = pd.DataFrame(list(metrics_dict.items()))
    col_index = metrics_df.iloc[0][1] + "__" + metrics_df.iloc[1][1]
    metrics_df.columns = ["Metrics", col_index]

    return metrics_dict, metrics_df


args = parse_args()
now = datetime.datetime.now()

if args.design == "all_designs":
    print("List of designs")
    rootdir = './logs'

    all_metrics_df = pd.DataFrame()
    all_metrics = []

    cwd = os.getcwd()
    for platform_it in os.scandir(rootdir):
        if platform_it.is_dir():
            plt = platform_it.name
            for design_it in os.scandir(platform_it.path):
                if design_it.is_dir():
                    des = design_it.name
                    print(plt,des)
                    design_metrics, design_metrics_df = extract_metrics(cwd, plt, des,
                                        os.path.join(".", "reports", plt, des, "metrics.json"))
                    all_metrics.append(design_metrics)
                    if all_metrics_df.shape[0] == 0:
                        all_metrics_df = design_metrics_df
                    else:
                        all_metrics_df = all_metrics_df.merge(design_metrics_df,
                                                    on = 'Metrics', how = 'inner')
#
# render to html
#
    metrics_html = all_metrics_df.to_html()
    metrics_html_file = open("metrics.html", "w")
    metrics_html_file.write(metrics_html)
    metrics_html_file.close()
else:
    metrics_dict, metrics_df = extract_metrics(args.flowPath, args.platform, args.design, args.output)
