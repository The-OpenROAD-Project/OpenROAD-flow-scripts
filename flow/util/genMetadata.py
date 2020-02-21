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
# Main function to do specific extraction and

# This function will look for a regular expression "pattern" in a "file", and
# set the key, "jsonTag", to the value found. The specific "occurrence" selects
# which occurrence it uses. If pattern not found, it will print an error and set
# the value to N/A. If a "defaultNotFound" is set, it will use that instead
def extractTagFromFile(jsonTag, pattern, file, occurrence=-1, defaultNotFound="N/A"):
  # Open file
  try:
    searchFilePath = os.path.join(args.flowPath, file)
    with open(searchFilePath) as f:
      content = f.read()

    m = re.findall(pattern, content, re.M)

    if m:
      if occurrence == -2:
        # Return the count
        jsonFile[jsonTag] = str(len(m))
      else:
        # Note: This gets the specified occurrence
        jsonFile[jsonTag] = m[occurrence].strip()
    else:
      # Only print a warning if the defaultNotFound is not set
      if defaultNotFound == "N/A":
        print "WARNING: Tag", jsonTag, "not found in", searchFilePath
      jsonFile[jsonTag] = defaultNotFound
  except IOError:
    print "WARNING: Failed to open file:", searchFilePath
    jsonFile[jsonTag] = "ERR"


# Main
# ==============================================================================

now = datetime.datetime.now()
jsonFile = OrderedDict()

jsonFile["generate_date"] = now.strftime("%Y-%m-%d %H:%M")
cmdOutput = subprocess.check_output(['openroad', '-version'])
jsonFile["openroad_version"],jsonFile["openroad_commit"] = cmdOutput.split()
jsonFile["uuid"] = str(uuid.uuid4())
jsonFile["design"] = args.design
jsonFile["platform"] = args.platform
jsonFile["comment"] = args.comment


# Synthesis
# ==============================================================================

# yosys
extractTagFromFile("yosys_version",
                   "^Yosys (.*)",
                   logPath+"/1_1_yosys.log")
extractTagFromFile("yosys_cell_count",
                   "Number of cells: +(\S+)",
                   rptPath+"/synth_stat.txt")
extractTagFromFile("yosys_chip_area",
                   "Chip area for module.*: +(\S+)",
                   rptPath+"/synth_stat.txt")
extractTagFromFile("yosys_runtime",
                   "^CPU: user (\S+)",
                   logPath+"/1_1_yosys.log")
extractTagFromFile("yosys_mem",
                   "^CPU: user.*MEM: (\S+ \S+)",
                   logPath+"/1_1_yosys.log")
extractTagFromFile("yosys_warnings",
                   "Warnings: \d+ unique messages, (\d+) total",
                   logPath+"/1_1_yosys.log")

# Floorplan
# ==============================================================================
extractTagFromFile("floorplan_tns",
                   "^tns (\S+)",
                   rptPath+"/2_init.rpt")
extractTagFromFile("floorplan_wns",
                   "^wns (\S+)",
                   rptPath+"/2_init.rpt")
extractTagFromFile("floorplan_area",
                   "^Design area (\S+ \S+)",
                   rptPath+"/2_init.rpt")
extractTagFromFile("floorplan_util",
                   "^Design area.* (\S+%) utilization",
                   rptPath+"/2_init.rpt")
extractTagFromFile("floorplan_warnings",
                   "(?i)warning",
                   logPath+"/2_1_floorplan.log", -2, "0")


extractTagFromFile("floorplan_io_count",
                   "Num of I/O +(\d+)",
                   logPath+"/2_2_floorplan_io.log")


extractTagFromFile("mplace_macro_count",
                   "Extracted # Macros: (\S+)",
                   logPath+"/2_4_mplace.log", -1, "0")






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



# Resizer
extractTagFromFile("resizer_pre_tns",
                   "^tns (\S+)",
                   rptPath+"/3_pre_resize.rpt")
extractTagFromFile("resizer_pre_wns",
                   "^wns (\S+)",
                   rptPath+"/3_pre_resize.rpt")
extractTagFromFile("resizer_pre_area",
                   "^Design area (\S+ \S+)",
                   rptPath+"/3_pre_resize.rpt")
extractTagFromFile("resizer_pre_util",
                   "^Design area.* (\S+%) utilization",
                   rptPath+"/3_pre_resize.rpt")

extractTagFromFile("resizer_ibuf_count",
                   "Inserted (\d+) input buffers",
                   logPath+"/3_2_resizer.log")
extractTagFromFile("resizer_obuf_count",
                   "Inserted (\d+) output buffers",
                   logPath+"/3_2_resizer.log")
extractTagFromFile("resizer_resize_count",
                   "Resized (\d+) instances",
                   logPath+"/3_2_resizer.log")
extractTagFromFile("resizer_hbuf_count",
                   "Inserted (\d+) hold buffers",
                   logPath+"/3_2_resizer.log")

extractTagFromFile("resizer_maxcap_viols",
                   "Found (/d+) max capacitance violations",
                   logPath+"/3_2_resizer.log", -1, "0")
extractTagFromFile("resizer_maxslew_viols",
                   "Found (/d+) max slew violations",
                   logPath+"/3_2_resizer.log", -1, "0")
extractTagFromFile("resizer_maxfanout_viols",
                   "Found (/d+) max fanout violations",
                   logPath+"/3_2_resizer.log", -1, "0")
extractTagFromFile("resizer_maxfabout_bufs",
                   "Inserted (/d+) buffers",
                   logPath+"/3_2_resizer.log", -1, "0")


#TODO Tie hi tie low


extractTagFromFile("resizer_post_tns",
                   "^tns (\S+)",
                   rptPath+"/3_post_resize.rpt")
extractTagFromFile("resizer_post_wns",
                   "^wns (\S+)",
                   rptPath+"/3_post_resize.rpt")
extractTagFromFile("resizer_post_area",
                   "^Design area (\S+ \S+)",
                   rptPath+"/3_post_resize.rpt")
extractTagFromFile("resizer_post_util",
                   "^Design area.* (\S+%) utilization",
                   rptPath+"/3_post_resize.rpt")

# Detail place
extractTagFromFile("dp_core_area",
                   "core area +: +(.*)",
                   logPath+"/3_3_opendp.log")
extractTagFromFile("dp_total_cells",
                   "total cells +: +(.*)",
                   logPath+"/3_3_opendp.log")
extractTagFromFile("dp_design_utilization",
                   "design utilization +: +(.*)",
                   logPath+"/3_3_opendp.log")
extractTagFromFile("dp_total_displacement",
                   "total displacement +: +(.*)",
                   logPath+"/3_3_opendp.log")
extractTagFromFile("dp_average_displacement",
                   "average displacement +: +(.*)",
                   logPath+"/3_3_opendp.log")
extractTagFromFile("dp_max_displacement",
                   "max displacement +: +(.*)",
                   logPath+"/3_3_opendp.log")
extractTagFromFile("dp_original_HPWL",
                   "original HPWL +: +(.*)",
                   logPath+"/3_3_opendp.log")
extractTagFromFile("dp_legalized_HPWL",
                   "legalized HPWL +: +(.*)",
                   logPath+"/3_3_opendp.log")
extractTagFromFile("dp_delta_HPWL",
                   "delta HPWL +: +(.*)",
                   logPath+"/3_3_opendp.log")

# CTS
# ==============================================================================
#TODO

# Route
# ==============================================================================

extractTagFromFile("droute_num_layers",
                   "#layers: +(\S+)",
                   logPath+"/5_2_TritonRoute.log")
extractTagFromFile("droute_num_macros",
                   "#macros: +(\S+)",
                   logPath+"/5_2_TritonRoute.log")
extractTagFromFile("droute_num_vias",
                   "#vias: +(\S+)",
                   logPath+"/5_2_TritonRoute.log")
extractTagFromFile("droute_trackPts",
                   "trackPts: +(\S+)",
                   logPath+"/5_2_TritonRoute.log")
extractTagFromFile("droute_defvias",
                   "defvias: +(\S+)",
                   logPath+"/5_2_TritonRoute.log")
extractTagFromFile("droute_num_components",
                   "#components: +(\S+)",
                   logPath+"/5_2_TritonRoute.log")
extractTagFromFile("droute_num_terminals",
                   "#terminals: +(\S+)",
                   logPath+"/5_2_TritonRoute.log")
extractTagFromFile("droute_num_nets",
                   "nets: +(\S+)",
                   logPath+"/5_2_TritonRoute.log")
extractTagFromFile("droute_num_unique_instances",
                   "#unique instances = +(\S+)",
                   logPath+"/5_2_TritonRoute.log")
extractTagFromFile("droute_num_instances",
                   "#scanned instances += +(\S+)",
                   logPath+"/5_2_TritonRoute.log")
extractTagFromFile("droute_runtime",
                   "Runtime taken \(hrt\): +(\S+)",
                   logPath+"/5_2_TritonRoute.log")
extractTagFromFile("droute_wirelength",
                   "total wire length = +(\S+ \S+)",
                   logPath+"/5_2_TritonRoute.log")
extractTagFromFile("droute_num_vias",
                   "total number of vias = +(\S+)",
                   logPath+"/5_2_TritonRoute.log")
extractTagFromFile("droute_peak_mem",
                   "peak = (\S+)",
                   logPath+"/5_2_TritonRoute.log")


# Finish
# ==============================================================================

extractTagFromFile("finish_internal_power",
                   "Total +(\S+) +\S+ +\S+ +\S+ +\S+",
                   rptPath+"/6_final_report.rpt")

extractTagFromFile("finish_switching_power",
                   "Total +\S+ +(\S+) +\S+ +\S+ +\S+",
                   rptPath+"/6_final_report.rpt")

extractTagFromFile("finish_leakage_power",
                   "Total +\S+ +\S+ +(\S+) +\S+ +\S+",
                   rptPath+"/6_final_report.rpt")

extractTagFromFile("finish_total_power",
                   "Total +\S+ +\S+ +\S+ +(\S+) +\S+",
                   rptPath+"/6_final_report.rpt")

extractTagFromFile("finish_total_power",
                   "Total +\S+ +\S+ +\S+ +(\S+) +\S+",
                   rptPath+"/6_final_report.rpt")

extractTagFromFile("finish_area",
                   "^Design area (\S+ \S+)",
                   rptPath+"/6_final_report.rpt")
extractTagFromFile("finish_util",
                   "^Design area.* (\S+%) utilization",
                   rptPath+"/6_final_report.rpt")


# print json.dumps(jsonFile, indent=2)
with open(args.output, "w") as resultSpecfile:
  json.dump(jsonFile, resultSpecfile, indent=2)
