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
  print "Error: flowPath does not exist"
  print "Path: " + args.flowPath
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
    print "[WARN] Overwriting Tag", jsonTag

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
        print "[WARN] Tag", jsonTag, "not found in", searchFilePath
      jsonFile[jsonTag] = defaultNotFound
  except IOError:
    print "[WARN] Failed to open file:", searchFilePath
    jsonFile[jsonTag] = "ERR"


def extractGnuTime(prefix, file):
  extractTagFromFile(prefix + "_time",
                     "^(\S+)elapsed \S+CPU \S+memKB",
                     file)
  extractTagFromFile(prefix + "_cpu",
                     "^\S+elapsed (\S+)CPU \S+memKB",
                     file)
  extractTagFromFile(prefix + "_mem",
                     "^\S+elapsed \S+CPU (\S+)memKB",
                     file, t=int)


# Main
# ==============================================================================

now = datetime.datetime.now()
jsonFile = OrderedDict()

jsonFile["generate_date"] = now.strftime("%Y-%m-%d %H:%M")
cmdOutput = subprocess.check_output(['openroad', '-version'])
cmdFields = cmdOutput.split()
jsonFile["openroad_version"] = cmdFields[0]
if (len(cmdFields) > 1):
  jsonFile["openroad_commit"] = cmdFields[1]
else:
  jsonFile["openroad_commit"] = "N/A"
jsonFile["uuid"] = str(uuid.uuid4())
jsonFile["design"] = args.design
jsonFile["platform"] = args.platform
jsonFile["comment"] = args.comment
jsonFile["hostname"] = platform.node()
jsonFile["comment"] = args.comment


# Synthesis
# ==============================================================================

# yosys
extractTagFromFile("yosys_version",
                   "^Yosys (.*)",
                   logPath+"/1_1_yosys.log")
extractTagFromFile("yosys_cell_count",
                   "Number of cells: +(\S+)",
                   rptPath+"/synth_stat.txt", t=int)
extractTagFromFile("yosys_chip_area",
                   "Chip area for module.*: +(\S+)",
                   rptPath+"/synth_stat.txt", t=float)
extractTagFromFile("yosys_runtime",
                   "CPU: user (\S+)",
                   logPath+"/1_1_yosys.log")
extractTagFromFile("yosys_mem",
                   "CPU: user.*MEM: (\S+ \S+)",
                   logPath+"/1_1_yosys.log")
extractTagFromFile("yosys_warnings",
                   "Warnings: \d+ unique messages, (\d+) total",
                   logPath+"/1_1_yosys.log", t=int)

extractGnuTime("synth",logPath+"/1_1_yosys.log")

# Floorplan
# ==============================================================================
extractTagFromFile("floorplan_tns",
                   "^tns (\S+)",
                   rptPath+"/2_init.rpt", t=float)
extractTagFromFile("floorplan_wns",
                   "^wns (\S+)",
                   rptPath+"/2_init.rpt", t=float)
extractTagFromFile("floorplan_area",
                   "^Design area (\S+) u\^2",
                   rptPath+"/2_init.rpt", t=int)
extractTagFromFile("floorplan_util",
                   "^Design area.* (\S+%) utilization",
                   rptPath+"/2_init.rpt")
extractTagFromFile("floorplan_warnings",
                   "(?i)warning",
                   logPath+"/2_1_floorplan.log", -2, 0)
extractGnuTime("floorplan",logPath+"/2_1_floorplan.log")

extractTagFromFile("floorplan_io_count",
                   "Num of I/O +(\d+)",
                   logPath+"/2_2_floorplan_io.log", t=int)
extractGnuTime("floorplan_io",logPath+"/2_2_floorplan_io.log")


extractGnuTime("floorplan_tdms",logPath+"/2_3_tdms_place.log")


extractTagFromFile("mplace_macro_count",
                   "Extracted # Macros: (\S+)",
                   logPath+"/2_4_mplace.log", -1, 0, t=int)
extractTagFromFile("mplace_solutions",
                   "Total Extracted Solution: (\S+)",
                   logPath+"/2_4_mplace.log", -1, 0, t=int)
extractGnuTime("mplace",logPath+"/2_4_mplace.log")

extractGnuTime("tapcell",logPath+"/2_5_tapcell.log")

extractGnuTime("pdn",logPath+"/2_6_pdn.log")


# Place
# ==============================================================================

# global place
extractTagFromFile("globalplace_hpwl",
                   "^HP wire length: (\S+)",
                   logPath+"/3_1_place_gp.log")
extractTagFromFile("globalplace_ws",
                   "^Worst slack: (\S+)",
                   logPath+"/3_1_place_gp.log")
extractTagFromFile("globalplace_tns",
                   "^Total negative slack: (\S+)",
                   logPath+"/3_1_place_gp.log")
extractTagFromFile("globalplace_util",
                   "Util\(%\) = (\S+)",
                   logPath+"/3_1_place_gp.log")
extractGnuTime("globalplace",logPath+"/3_1_place_gp.log")


# Resizer
extractTagFromFile("resizer_pre_tns",
                   "^tns (\S+)",
                   rptPath+"/3_pre_resize.rpt", t=float)
extractTagFromFile("resizer_pre_wns",
                   "^wns (\S+)",
                   rptPath+"/3_pre_resize.rpt", t=float)
extractTagFromFile("resizer_pre_area",
                   "^Design area (\S+ \S+)",
                   rptPath+"/3_pre_resize.rpt")
extractTagFromFile("resizer_pre_util",
                   "^Design area.* (\S+%) utilization",
                   rptPath+"/3_pre_resize.rpt")
extractTagFromFile("resizer_ibuf_count",
                   "Inserted (\d+) input buffers",
                   logPath+"/3_2_resizer.log", t=int)
extractTagFromFile("resizer_obuf_count",
                   "Inserted (\d+) output buffers",
                   logPath+"/3_2_resizer.log", t=int)
extractTagFromFile("resizer_resize_count",
                   "Resized (\d+) instances",
                   logPath+"/3_2_resizer.log", t=int)
extractTagFromFile("resizer_hbuf_count",
                   "Inserted (\d+) hold buffers",
                   logPath+"/3_2_resizer.log", t=int)
extractTagFromFile("resizer_maxcap_viols",
                   "Found (\d+) max capacitance violations",
                   logPath+"/3_2_resizer.log", -1, 0, t=int)
extractTagFromFile("resizer_maxslew_viols",
                   "Found (\d+) max slew violations",
                   logPath+"/3_2_resizer.log", -1, 0, t=int)
extractTagFromFile("resizer_maxfanout_viols",
                   "Found (\d+) max fanout violations",
                   logPath+"/3_2_resizer.log", -1, 0, t=int)
extractTagFromFile("resizer_maxfanout_bufs",
                   "Inserted (\d+) buffers",
                   logPath+"/3_2_resizer.log", -1, 0, t=int)
#TODO Tie hi tie low
# extractTagFromFile("resizer_maxfanout_bufs_tielo",
#                    "Inserted (\d+) tie \S+ instances for \d+ nets",
#                    logPath+"/3_2_resizer.log", 0, "0")
# extractTagFromFile("resizer_maxfanout_bufs_tielo",
#                    "Inserted (\d+) tie \S+ instances for \d+ nets",
#                    logPath+"/3_2_resizer.log", 1, "0")
extractTagFromFile("resizer_post_tns",
                   "^tns (\S+)",
                   rptPath+"/3_post_resize.rpt", t=float)
extractTagFromFile("resizer_post_wns",
                   "^wns (\S+)",
                   rptPath+"/3_post_resize.rpt", t=float)
extractTagFromFile("resizer_post_area",
                   "^Design area (\S+ \S+)",
                   rptPath+"/3_post_resize.rpt")
extractTagFromFile("resizer_post_util",
                   "^Design area.* (\S+%) utilization",
                   rptPath+"/3_post_resize.rpt")
extractGnuTime("resizer",logPath+"/3_2_resizer.log")


# Detail place
extractTagFromFile("dp_core_area",
                   "design area +(\d*\.?\d*)",
                   logPath+"/3_3_opendp.log", t=float)
extractTagFromFile("dp_total_cells",
                   "total instances +(\d+)",
                   logPath+"/3_3_opendp.log", t=int)
extractTagFromFile("dp_design_utilization",
                   "utilization +(\d+)",
                   logPath+"/3_3_opendp.log", t=int)
extractTagFromFile("dp_total_displacement",
                   "total displacement +(\d*\.?\d*)",
                   logPath+"/3_3_opendp.log", t=float)
extractTagFromFile("dp_average_displacement",
                   "average displacement +(\d*\.?\d*)",
                   logPath+"/3_3_opendp.log", t=float)
extractTagFromFile("dp_max_displacement",
                   "max displacement +(\d*\.?\d*)",
                   logPath+"/3_3_opendp.log", t=float)
extractTagFromFile("dp_original_HPWL",
                   "original HPWL +(\d*\.?\d*)",
                   logPath+"/3_3_opendp.log", t=float)
extractTagFromFile("dp_legalized_HPWL",
                   "legalized HPWL +(\d*\.?\d*)",
                   logPath+"/3_3_opendp.log", t=float)
extractTagFromFile("dp_delta_HPWL",
                   "delta HPWL +(\d*\.?\d*)",
                   logPath+"/3_3_opendp.log", t=int)
extractGnuTime("dp",logPath+"/3_3_opendp.log")

# CTS
# ==============================================================================
extractGnuTime("cts",logPath+"/4_cts.log")

# Route
# ==============================================================================

extractGnuTime("fastroute",logPath+"/5_1_fastroute.log")


extractTagFromFile("droute_num_layers",
                   "#layers: +(\S+)",
                   logPath+"/5_2_TritonRoute.log", t=int)
extractTagFromFile("droute_num_macros",
                   "#macros: +(\S+)",
                   logPath+"/5_2_TritonRoute.log", t=int)
extractTagFromFile("droute_num_vias",
                   "#vias: +(\S+)",
                   logPath+"/5_2_TritonRoute.log", t=int)
extractTagFromFile("droute_trackPts",
                   "trackPts: +(\S+)",
                   logPath+"/5_2_TritonRoute.log", t=int)
extractTagFromFile("droute_defvias",
                   "defvias: +(\S+)",
                   logPath+"/5_2_TritonRoute.log", t=int)
extractTagFromFile("droute_num_components",
                   "#components: +(\S+)",
                   logPath+"/5_2_TritonRoute.log", t=int)
extractTagFromFile("droute_num_terminals",
                   "#terminals: +(\S+)",
                   logPath+"/5_2_TritonRoute.log", t=int)
extractTagFromFile("droute_num_nets",
                   "nets: +(\S+)",
                   logPath+"/5_2_TritonRoute.log", t=int)
extractTagFromFile("droute_num_unique_instances",
                   "#unique instances = +(\S+)",
                   logPath+"/5_2_TritonRoute.log", t=int)
extractTagFromFile("droute_num_instances",
                   "#scanned instances += +(\S+)",
                   logPath+"/5_2_TritonRoute.log", t=int)
extractTagFromFile("droute_runtime",
                   "Runtime taken \(hrt\): +(\S+)",
                   logPath+"/5_2_TritonRoute.log", t=float)
extractTagFromFile("droute_wirelength",
                   "total wire length = +(\S+) um",
                   logPath+"/5_2_TritonRoute.log", t=int)
extractTagFromFile("droute_total_num_vias",
                   "total number of vias = +(\S+)",
                   logPath+"/5_2_TritonRoute.log", t=int)
extractTagFromFile("droute_peak_mem",
                   "peak = (\S+)",
                   logPath+"/5_2_TritonRoute.log", t=float)

extractTagFromFile("droute_warnings",
                   "(?i)warning:",
                   logPath+"/5_2_TritonRoute.log", -2, 0)
extractTagFromFile("droute_errors",
                   "(?i)error:",
                   logPath+"/5_2_TritonRoute.log", -2, 0)
extractTagFromFile("droute_viols",
                   "(?i)violation",
                   rptPath+"/5_route_drc.rpt", -2, 0)

extractGnuTime("droute",logPath+"/5_2_TritonRoute.log")

# Finish
# ==============================================================================

extractTagFromFile("finish_internal_power",
                   "Total +(\S+) +\S+ +\S+ +\S+ +\S+",
                   rptPath+"/6_final_report.rpt", t=float)

extractTagFromFile("finish_switching_power",
                   "Total +\S+ +(\S+) +\S+ +\S+ +\S+",
                   rptPath+"/6_final_report.rpt", t=float)

extractTagFromFile("finish_leakage_power",
                   "Total +\S+ +\S+ +(\S+) +\S+ +\S+",
                   rptPath+"/6_final_report.rpt", t=float)

extractTagFromFile("finish_total_power",
                   "Total +\S+ +\S+ +\S+ +(\S+) +\S+",
                   rptPath+"/6_final_report.rpt", t=float)

extractTagFromFile("finish_area",
                   "^Design area (\S+ \S+)",
                   rptPath+"/6_final_report.rpt")
extractTagFromFile("finish_util",
                   "^Design area.* (\S+%) utilization",
                   rptPath+"/6_final_report.rpt")

extractGnuTime("report",logPath+"/6_report.log")

extractGnuTime("merge",logPath+"/6_1_merge.log")


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
