#!/usr/bin/env python3

# This scripts attempts to extract relevant data from a completed flow design
# and save it into a "metadata.json". It achieves this by looking for specific
# information in specific files using regular expressions
#-------------------------------------------------------------------------------

import argparse  # argument parsing
import json  # json parsing
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
parser = argparse.ArgumentParser(
    description='Generates metadata from OpenROAD flow')
parser.add_argument('--flowPath', '-f', required=True,
                    help='Path to the flow directory')
parser.add_argument('--design', '-d', required=True,
                    help='Path to the flow directory')
parser.add_argument('--platform', '-p', required=True,
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

logPath = os.path.join(args.flowPath, "logs", args.platform, args.design)
rptPath = os.path.join(args.flowPath, "reports", args.platform, args.design)

# Functions
# ==============================================================================
# Main function to do specific extraction of patterns from a file

# This function will look for a regular expression "pattern" in a "file", and
# set the key, "jsonTag", to the value found. The specific "occurrence" selects
# which occurrence it uses. If pattern not found, it will print an error and set
# the value to N/A. If a "defaultNotFound" is set, it will use that instead.
# If occurrence is set to -2, it will return the count of the pattern.
# t indicates the type that should be written to the JSON file (default: string)

def extractTagFromFile(jsonTag, pattern, file, occurrence=-1, defaultNotFound="N/A", t=str):
  if jsonTag in jsonFile:
    print("[WARN] Overwriting Tag", jsonTag)

  # Open file
  try:
    searchFilePath = os.path.join(args.flowPath, file)
    with open(searchFilePath) as f:
      content = f.read()

    m = re.findall(pattern, content, re.M)

    if m:
      if occurrence == -2:
        # Return the count
        jsonFile[jsonTag] = len(m)
      else:
        # Note: This gets the specified occurrence
        jsonFile[jsonTag] = (t)(m[occurrence].strip())
    else:
      # Only print a warning if the defaultNotFound is not set
      if defaultNotFound == "N/A":
        print("[WARN] Tag", jsonTag, "not found in", searchFilePath)
      jsonFile[jsonTag] = defaultNotFound
  except IOError:
    print("[WARN] Failed to open file:", searchFilePath)
    jsonFile[jsonTag] = "ERR"


def extractGnuTime(prefix, file):
  extractTagFromFile(prefix + "__runtime__total",
                     "^(\S+)elapsed \S+CPU \S+memKB",
                     file)
  extractTagFromFile(prefix + "__cpu__total",
                     "^\S+elapsed (\S+)CPU \S+memKB",
                     file)
  extractTagFromFile(prefix + "__mem__peak",
                     "^\S+elapsed \S+CPU (\S+)memKB",
                     file, t=int)


# Main
# ==============================================================================

now = datetime.datetime.now()
jsonFile = OrderedDict()

jsonFile["run__flow__generate__date"] = now.strftime("%Y-%m-%d %H:%M")
cmdOutput = subprocess.check_output(['openroad', '-version'])
cmdFields = [ x.decode('utf-8') for x in cmdOutput.split()  ]
jsonFile["run__flow__openroad__version"] = str(cmdFields[0])
if (len(cmdFields) > 1):
  jsonFile["run__flow__openroad__commit"] = str(cmdFields[1])
else:
  jsonFile["run__flow__openroad__commit"] = "N/A"
jsonFile["run__flow__uuid"] = str(uuid.uuid4())
jsonFile["run__flow__design"] = args.design
jsonFile["run__flow__platform"] = args.platform

# Synthesis
# ==============================================================================

extractTagFromFile("synth__area__stdcell__count",
                   "Number of cells: +(\S+)",
                   rptPath+"/synth_stat.txt", t=int)

extractTagFromFile("synth__area__stdcell__area",
                   "Chip area for module.*: +(\S+)",
                   rptPath+"/synth_stat.txt", t=float)

# Floorplan
# ==============================================================================

extractTagFromFile("floorplan__timing__tns__total",
                   "^tns (\S+)",
                   logPath+"/2_1_floorplan.log", t=float)

extractTagFromFile("floorplan__timing__wns__worst",
                   "^wns (\S+)",
                   logPath+"/2_1_floorplan.log", t=float)

extractTagFromFile("floorplan__area__stdcell__count",
                   "^Design area (\S+) u\^2",
                   logPath+"/2_1_floorplan.log", t=int)

extractTagFromFile("floorplan__area__instance__util",
                   "^Design area.* (\S+)% utilization",
                   logPath+"/2_1_floorplan.log", t=int)

extractTagFromFile("floorplan__area__IO__count",
                   "Num of I/O +(\d+)",
                   logPath+"/3_2_place_iop.log", t=int)

extractTagFromFile("floorplan__area__macros__count",
                   "Extracted # Macros: (\S+)",
                   logPath+"/2_4_mplace.log", -1, 0, t=int)

# Place
# ==============================================================================

extractTagFromFile("globalplace__area__density__target",
                   "TargetDensity: (\S+)",
                   logPath+"/3_1_place_gp.log")

extractTagFromFile("globalplace__area__wirelength__estimate",
                   "Total wirelength: (\S+)",
                   logPath+"/3_1_place_gp.log")

extractTagFromFile("placeopt__area__inbuffer__count",
                   "Inserted (\d+) input buffers",
                   logPath+"/3_3_resizer.log", t=int)

extractTagFromFile("placeopt__area__outbuffer__count",
                   "Inserted (\d+) output buffers",
                   logPath+"/3_3_resizer.log", t=int)

extractTagFromFile("placeopt__area__resize__count",
                   "Resized (\d+) instances",
                   logPath+"/3_3_resizer.log", t=int)

extractTagFromFile("placeopt__timing__tns__total",
                   "^tns (\S+)",
                   logPath+"/3_3_resizer.log", occurrence=-1, t=float)

extractTagFromFile("placeopt__timing__wns__worst",
                   "^wns (\S+)",
                   logPath+"/3_3_resizer.log", occurrence=-1, t=float)

extractTagFromFile("placeopt__area__instance__area",
                   "^Design area (\S+ \S+)",
                   logPath+"/3_3_resizer.log", occurrence=-1)

extractTagFromFile("placeopt__area__instance__util",
                   "^Design area.* (\S+)% utilization",
                   logPath+"/3_3_resizer.log", t=float)

extractTagFromFile("detailedplace__inst__displacement__total",
                   "total displacement +(\d*\.?\d*)",
                   logPath+"/3_4_opendp.log", t=float)

extractTagFromFile("detailedplace__inst__displacement__average",
                   "average displacement +(\d*\.?\d*)",
                   logPath+"/3_4_opendp.log", t=float)

extractTagFromFile("detailedplace__inst__displacement__max",
                   "max displacement +(\d*\.?\d*)",
                   logPath+"/3_4_opendp.log", t=float)

extractTagFromFile("detailedplace__wirelength__initial__estimate",
                   "original HPWL +(\d*\.?\d*)",
                   logPath+"/3_4_opendp.log", t=float)

extractTagFromFile("detailedplace__wirelength__final__estimate",
                   "legalized HPWL +(\d*\.?\d*)",
                   logPath+"/3_4_opendp.log", t=float)

# CTS
# ==============================================================================

extractTagFromFile("cts__timing__slack__tns",
                   "^tns (\S+)",
                   logPath+"/4_1_cts.log", t=float)

extractTagFromFile("cts__timing__slack__wns",
                   "^wns (\S+)",
                   logPath+"/4_1_cts.log", t=float)

# Route
# ==============================================================================

extractTagFromFile("detailedroute__wirelength",
                   "total wire length = +(\S+) um",
                   logPath+"/5_2_TritonRoute.log", t=int)

extractTagFromFile("detailedroute__via__count",
                   "total number of vias = +(\S+)",
                   logPath+"/5_2_TritonRoute.log", t=int)

extractTagFromFile("detailedroute__errors__count",
                   "(?i)error:",
                   logPath+"/5_2_TritonRoute.log", -2, 0)

extractTagFromFile("detailedroute__drc__error__count",
                   "(?i)violation",
                   rptPath+"/5_route_drc.rpt", -2, 0)

# Finish
# ==============================================================================

extractTagFromFile("finish__power__internal__total",
                   "Total +(\S+) +\S+ +\S+ +\S+ +\S+",
                   logPath+"/6_report.log", t=float)

extractTagFromFile("finish__power__switch__total",
                   "Total +\S+ +(\S+) +\S+ +\S+ +\S+",
                   logPath+"/6_report.log", t=float)

extractTagFromFile("finish__power__leak__total",
                   "Total +\S+ +\S+ +(\S+) +\S+ +\S+",
                   logPath+"/6_report.log", t=float)

extractTagFromFile("finish__power__total",
                   "Total +\S+ +\S+ +\S+ +(\S+) +\S+",
                   logPath+"/6_report.log", t=float)

extractTagFromFile("finish__area",
                   "^Design area (\S+)",
                   logPath+"/6_report.log")

extractTagFromFile("finish__util",
                   "^Design area.* (\S+%) utilization",
                   logPath+"/6_report.log")

# Accumulate time
# ==============================================================================

failed = False
total = datetime.timedelta()
for key in jsonFile:
  if key.endswith("_time"):
    # Big try block because Hour and microsecond is optional
    try:
      t = datetime.datetime.strptime(jsonFile[key],"%H:%M:%S.%f")
    except ValueError:
      try:
        t = datetime.datetime.strptime(jsonFile[key],"%M:%S.%f")
      except ValueError:
        try:
          t = datetime.datetime.strptime(jsonFile[key],"%H:%M:%S")
        except ValueError:
          try:
            t = datetime.datetime.strptime(jsonFile[key],"%M:%S")
          except ValueError:
            failed = True
            break

    delta = datetime.timedelta(hours=t.hour, minutes=t.minute, seconds=t.second)
    total += delta

if failed:
  jsonFile["total_time"] = "ERR"
else:
  jsonFile["total_time"] = str(total)

with open(args.output, "w") as resultSpecfile:
  json.dump(jsonFile, resultSpecfile, indent=2)
