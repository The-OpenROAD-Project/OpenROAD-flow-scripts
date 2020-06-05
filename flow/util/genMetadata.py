#!/usr/bin/env python2

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

jsonFile["run__flow__generate_date"] = now.strftime("%Y-%m-%d %H:%M")
cmdOutput = subprocess.check_output(['openroad', '-version'])
cmdFields = cmdOutput.split()
jsonFile["run__flow__openroad_version"] = cmdFields[0]
if (len(cmdFields) > 1):
  jsonFile["run__flow__openroad_commit"] = cmdFields[1]
else:
  jsonFile["run__flow__openroad_commit"] = "N/A"
jsonFile["run__flow__uuid"] = str(uuid.uuid4())
jsonFile["run__flow__design"] = args.design
jsonFile["run__flow__platform"] = args.platform
jsonFile["comment"] = args.comment
jsonFile["run__flow__hostname"] = platform.node()
jsonFile["comment"] = args.comment


# Synthesis
# ==============================================================================

# yosys
extractTagFromFile("run__synth__yosys_version",
                   "^Yosys (.*)",
                   logPath+"/1_1_yosys.log")
extractTagFromFile("synth__inst__num__total",
                   "Number of cells: +(\S+)",
                   rptPath+"/synth_stat.txt", t=int)
extractTagFromFile("synth__inst__stdcell__area__total",
                   "Chip area for module.*: +(\S+)",
                   rptPath+"/synth_stat.txt", t=float)
extractTagFromFile("run__synth__yosys_runtime__total",
                   "CPU: user (\S+)",
                   logPath+"/1_1_yosys.log")
extractTagFromFile("run__synth__yosys_mem",
                   "CPU: user.*MEM: (\S+ \S+)",
                   logPath+"/1_1_yosys.log")
extractTagFromFile("run__synth__yosys_warnings",
                   "Warnings: \d+ unique messages, (\d+) total",
                   logPath+"/1_1_yosys.log", t=int)

extractGnuTime("run__synth",logPath+"/1_1_yosys.log")

# Floorplan
# ==============================================================================
extractTagFromFile("floorplan__slack__average__totneg",
                   "^tns (\S+)",
                   rptPath+"/2_init.rpt", t=float)
extractTagFromFile("floorplan__slack__average__worst",
                   "^wns (\S+)",
                   rptPath+"/2_init.rpt", t=float)
extractTagFromFile("floorplan__std__area__total",
                   "^Design area (\S+) u\^2",
                   rptPath+"/2_init.rpt", t=int)
extractTagFromFile("floorplan__util",
                   "^Design area.* (\S+%) utilization",
                   rptPath+"/2_init.rpt")
extractTagFromFile("run__floorplan__warnings",
                   "(?i)warning",
                   logPath+"/2_1_floorplan.log", -2, 0)
extractGnuTime("floorplan",logPath+"/2_1_floorplan.log")

extractTagFromFile("floorplan__io__count__total",
                   "Num of I/O +(\d+)",
                   logPath+"/2_2_floorplan_io.log", t=int)
extractGnuTime("run__floorplan_io",logPath+"/2_2_floorplan_io.log")


extractGnuTime("run__floorplan_tdms",logPath+"/2_3_tdms_place.log")


extractTagFromFile("macroplace__inst__macro__count__total",
                   "Extracted # Macros: (\S+)",
                   logPath+"/2_4_mplace.log", -1, 0, t=int)
extractTagFromFile("macroplace__solutions",
                   "Total Extracted Solution: (\S+)",
                   logPath+"/2_4_mplace.log", -1, 0, t=int)
extractGnuTime("run__mplace",logPath+"/2_4_mplace.log")

extractGnuTime("run__tapcell",logPath+"/2_5_tapcell.log")

extractGnuTime("run__pdn",logPath+"/2_6_pdn.log")


# Place
# ==============================================================================

# global place
extractTagFromFile("globalplace__wirelength__est",
                   "^HP wire length: (\S+)",
                   logPath+"/3_1_place_gp.log")
extractTagFromFile("globalplace__slack__average__worst",
                   "^Worst slack: (\S+)",
                   logPath+"/3_1_place_gp.log")
extractTagFromFile("globalplace__slack__average__totneg",
                   "^Total negative slack: (\S+)",
                   logPath+"/3_1_place_gp.log")
extractTagFromFile("globalplace__util",
                   "Util\(%\) = (\S+)",
                   logPath+"/3_1_place_gp.log")
extractGnuTime("run__globalplace",logPath+"/3_1_place_gp.log")


# Resizer
extractTagFromFile("resizer__pre__slack__average__totneg",
                   "^tns (\S+)",
                   rptPath+"/3_pre_resize.rpt", t=float)
extractTagFromFile("resizer__pre__slack__average_worst",
                   "^wns (\S+)",
                   rptPath+"/3_pre_resize.rpt", t=float)
extractTagFromFile("resizer__pre__core__area__area",
                   "^Design area (\S+ \S+)",
                   rptPath+"/3_pre_resize.rpt")
extractTagFromFile("resizer__pre__util",
                   "^Design area.* (\S+%) utilization",
                   rptPath+"/3_pre_resize.rpt")
extractTagFromFile("resizer__ibuf_count",
                   "Inserted (\d+) input buffers",
                   logPath+"/3_2_resizer.log", t=int)
extractTagFromFile("resizer__obuf_count",
                   "Inserted (\d+) output buffers",
                   logPath+"/3_2_resizer.log", t=int)
extractTagFromFile("resizer__resize_count",
                   "Resized (\d+) instances",
                   logPath+"/3_2_resizer.log", t=int)
extractTagFromFile("resizer__hbuf_count",
                   "Inserted (\d+) hold buffers",
                   logPath+"/3_2_resizer.log", t=int)
extractTagFromFile("resizer__maxcap_viols",
                   "Found (\d+) max capacitance violations",
                   logPath+"/3_2_resizer.log", -1, 0, t=int)
extractTagFromFile("resizer__maxslew_viols",
                   "Found (\d+) max slew violations",
                   logPath+"/3_2_resizer.log", -1, 0, t=int)
extractTagFromFile("resizer__maxfanout_viols",
                   "Found (\d+) max fanout violations",
                   logPath+"/3_2_resizer.log", -1, 0, t=int)
extractTagFromFile("resizer__maxfanout_bufs",
                   "Inserted (\d+) buffers",
                   logPath+"/3_2_resizer.log", -1, 0, t=int)
#TODO Tie hi tie low
# extractTagFromFile("resizer_maxfanout_bufs_tielo",
#                    "Inserted (\d+) tie \S+ instances for \d+ nets",
#                    logPath+"/3_2_resizer.log", 0, "0")
# extractTagFromFile("resizer_maxfanout_bufs_tielo",
#                    "Inserted (\d+) tie \S+ instances for \d+ nets",
#                    logPath+"/3_2_resizer.log", 1, "0")
extractTagFromFile("resizer__post__slack__average__totneg",
                   "^tns (\S+)",
                   rptPath+"/3_post_resize.rpt", t=float)
extractTagFromFile("resizer__post__slack__average__worst",
                   "^wns (\S+)",
                   rptPath+"/3_post_resize.rpt", t=float)
extractTagFromFile("resizer__post__core__area__total",
                   "^Design area (\S+ \S+)",
                   rptPath+"/3_post_resize.rpt")
extractTagFromFile("resizer__post__util",
                   "^Design area.* (\S+%) utilization",
                   rptPath+"/3_post_resize.rpt")
extractGnuTime("run__resizer",logPath+"/3_2_resizer.log")


# Detail place
extractTagFromFile("detailedplace__inst__core__area__total",
                   "design area +(\d*\.?\d*)",
                   logPath+"/3_3_opendp.log", t=float)
extractTagFromFile("detailedplace__inst__num__total",
                   "total instances +(\d+)",
                   logPath+"/3_3_opendp.log", t=int)
extractTagFromFile("detailedplace__util",
                   "utilization +(\d+)",
                   logPath+"/3_3_opendp.log", t=int)
extractTagFromFile("detailedplace__total_displacement",
                   "total displacement +(\d*\.?\d*)",
                   logPath+"/3_3_opendp.log", t=float)
extractTagFromFile("detailedplace__average_displacement",
                   "average displacement +(\d*\.?\d*)",
                   logPath+"/3_3_opendp.log", t=float)
extractTagFromFile("detailedplace__max_displacement",
                   "max displacement +(\d*\.?\d*)",
                   logPath+"/3_3_opendp.log", t=float)
extractTagFromFile("detailedplace__wirelength__est__original",
                   "original HPWL +(\d*\.?\d*)",
                   logPath+"/3_3_opendp.log", t=float)
extractTagFromFile("detailedplace__wirelength__est__legalized",
                   "legalized HPWL +(\d*\.?\d*)",
                   logPath+"/3_3_opendp.log", t=float)
extractTagFromFile("detailedplace__wirelength__est__delta",
                   "delta HPWL +(\d*\.?\d*)",
                   logPath+"/3_3_opendp.log", t=int)
extractGnuTime("run__dp",logPath+"/3_3_opendp.log")

# CTS
# ==============================================================================
extractGnuTime("run__cts",logPath+"/4_cts.log")

# Route
# ==============================================================================

extractGnuTime("run__globalroute",logPath+"/5_1_fastroute.log")


extractTagFromFile("detailedroute__layers__num__total",
                   "#layers: +(\S+)",
                   logPath+"/5_2_TritonRoute.log", t=int)
extractTagFromFile("detailedroute__inst__macro__num__total",
                   "#macros: +(\S+)",
                   logPath+"/5_2_TritonRoute.log", t=int)
extractTagFromFile("detailedroute__num_vias",
                   "#vias: +(\S+)",
                   logPath+"/5_2_TritonRoute.log", t=int)
extractTagFromFile("detailedroute__trackPts",
                   "trackPts: +(\S+)",
                   logPath+"/5_2_TritonRoute.log", t=int)
extractTagFromFile("detailedroute__defvias__num__total",
                   "defvias: +(\S+)",
                   logPath+"/5_2_TritonRoute.log", t=int)
extractTagFromFile("detailedroute__components__num__total",
                   "#components: +(\S+)",
                   logPath+"/5_2_TritonRoute.log", t=int)
extractTagFromFile("detailedroute__terminals__num__total",
                   "#terminals: +(\S+)",
                   logPath+"/5_2_TritonRoute.log", t=int)
extractTagFromFile("detailedroute__nets__num__total",
                   "nets: +(\S+)",
                   logPath+"/5_2_TritonRoute.log", t=int)
extractTagFromFile("droute_num_unique_instances",
                   "#unique instances = +(\S+)",
                   logPath+"/5_2_TritonRoute.log", t=int)
extractTagFromFile("detailedroute__unique_instances__num__total",
                   "#scanned instances += +(\S+)",
                   logPath+"/5_2_TritonRoute.log", t=int)
extractTagFromFile("detailedroute__runtime",
                   "Runtime taken \(hrt\): +(\S+)",
                   logPath+"/5_2_TritonRoute.log", t=float)
extractTagFromFile("detailedroute__wirelength__est",
                   "total wire length = +(\S+) um",
                   logPath+"/5_2_TritonRoute.log", t=int)
extractTagFromFile("detailedroute__via__num__total",
                   "total number of vias = +(\S+)",
                   logPath+"/5_2_TritonRoute.log", t=int)
extractTagFromFile("detailedroute__peak_mem",
                   "peak = (\S+)",
                   logPath+"/5_2_TritonRoute.log", t=float)

extractTagFromFile("detailedroute__warnings",
                   "(?i)warning:",
                   logPath+"/5_2_TritonRoute.log", -2, 0)
extractTagFromFile("detailedroute__errors",
                   "(?i)error:",
                   logPath+"/5_2_TritonRoute.log", -2, 0)
extractTagFromFile("detailedroute__drc__num__total",
                   "(?i)violation",
                   rptPath+"/5_route_drc.rpt", -2, 0)

extractGnuTime("run__detailedroute",logPath+"/5_2_TritonRoute.log")

# Finish
# ==============================================================================

extractTagFromFile("finish__power__internal__total",
                   "Total +(\S+) +\S+ +\S+ +\S+ +\S+",
                   rptPath+"/6_final_report.rpt", t=float)

extractTagFromFile("finish__power__switch__total",
                   "Total +\S+ +(\S+) +\S+ +\S+ +\S+",
                   rptPath+"/6_final_report.rpt", t=float)

extractTagFromFile("finish__power__leak__total",
                   "Total +\S+ +\S+ +(\S+) +\S+ +\S+",
                   rptPath+"/6_final_report.rpt", t=float)

extractTagFromFile("finish__power__total",
                   "Total +\S+ +\S+ +\S+ +(\S+) +\S+",
                   rptPath+"/6_final_report.rpt", t=float)

extractTagFromFile("finish__area",
                   "^Design area (\S+ \S+)",
                   rptPath+"/6_final_report.rpt")
extractTagFromFile("finish__util",
                   "^Design area.* (\S+%) utilization",
                   rptPath+"/6_final_report.rpt")

extractGnuTime("run__report",logPath+"/6_report.log")

extractGnuTime("run__merge",logPath+"/6_1_merge.log")


extractTagFromFile("drc_klayout_viols",
                   "<value>",
                   rptPath+"/6_drc_count.rpt", -2, 0, t=int)


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

# print json.dumps(jsonFile, indent=2)
with open(args.output, "w") as resultSpecfile:
  json.dump(jsonFile, resultSpecfile, indent=2)
