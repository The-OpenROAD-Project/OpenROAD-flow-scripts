#!/usr/bin/env python3

# This scripts attempts to extract relevant data from a completed flow design
# and save it into a "metadata.json". It achieves this by looking for specific
# information in specific files using regular expressions
#-------------------------------------------------------------------------------

import argparse  # argument parsing
import json  # json parsing
#import numpy as np
import pandas as pd
import subprocess
import sys
import re
import os  # filesystem manipulation
import datetime
import uuid
import platform
from collections import OrderedDict


# Functions
# ==============================================================================
# Main function to do specific extraction of patterns from a file

# This function will look for a regular expression "pattern" in a "file", and
# set the key, "jsonTag", to the value found. The specific "occurrence" selects
# which occurrence it uses. If pattern not found, it will print an error and set
# the value to N/A. If a "defaultNotFound" is set, it will use that instead.
# If occurrence is set to -2, it will return the count of the pattern.
# t indicates the type that should be written to the JSON file (default: string)
#
def extractTagFromFile(jsonTag, pattern, file, occurrence=-1, defaultNotFound="N/A", t=str):
#  if jsonTag in jsonFile:
#    print("[WARN] Overwriting Tag", jsonTag)

  # Open file
  try:
    #searchFilePath = os.path.join(args.flowPath, file)
    searchFilePath = file
    with open(searchFilePath,encoding='latin1') as f:
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
      #if defaultNotFound == "N/A":
      #  print("[WARN] Tag", jsonTag, "not found in", searchFilePath)
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


def extract_metrics(cwd, plt, des):
    logPath = os.path.join(cwd, "logs", plt, des)
    rptPath = os.path.join(cwd, "reports", plt, des)
    resultPath = os.path.join(cwd, "results", plt, des)

    now = datetime.datetime.now()
    metrics_dict = {}

    jsonFile["run__flow__generate__date"] = now.strftime("%Y-%m-%d %H:%M")
    cmdOutput = subprocess.check_output(['openroad', '-version'])
    cmdFields = cmdOutput.split()
    jsonFile["run__flow__openroad__version"] = str(cmdFields[0])
    if (len(cmdFields) > 1):
      jsonFile["run__flow__openroad__commit"] = str(cmdFields[1])
    else:
      jsonFile["run__flow__openroad__commit"] = "N/A"
    jsonFile["run__flow__uuid"] = str(uuid.uuid4())
    jsonFile["run__flow__design"] = des
    jsonFile["run__flow__platform"] = plt
    jsonFile["run__flow__hostname"] = platform.node()
    metrics_dict["run__flow__tool"] = "OpenROAD"
    metrics_dict["run__flow__date"] = jsonFile["run__flow__generate__date"]
    metrics_dict["run__flow__version"] = jsonFile["run__flow__openroad__version"]
    metrics_dict["run__flow__commit"] = jsonFile["run__flow__openroad__commit"]
    metrics_dict["run__flow__design"] = jsonFile["run__flow__design"]
    metrics_dict["run__flow__platform"] = jsonFile["run__flow__platform"]
    metrics_dict["run__flow__hostname"] = jsonFile["run__flow__hostname"]

# Synthesis
# ==============================================================================
# yosys
    extractTagFromFile("run__synth__yosys__version",
                       "^Yosys (.*)",
                       logPath+"/1_1_yosys.log")
    extractTagFromFile("synth__inst__num__total",
                       "Number of cells: +(\S+)",
                       rptPath+"/synth_stat.txt", t=int)
    metrics_dict["synth__inst__num__total"] = jsonFile["synth__inst__num__total"]
    extractTagFromFile("synth__inst__area__stdcell",
                       "Chip area for module.*: +(\S+)",
                       rptPath+"/synth_stat.txt", t=float)
    metrics_dict["synth__inst__area__stdcell"] = jsonFile["synth__inst__area__stdcell"]
    extractTagFromFile("run__synth__yosys__runtime",
                       "CPU: user (\S+)",
                       logPath+"/1_1_yosys.log")
    extractTagFromFile("run__synth__yosys__mem",
                       "CPU: user.*MEM: (\S+ \S+)",
                       logPath+"/1_1_yosys.log")
    extractTagFromFile("run__synth__yosys__warnings",
                       "Warnings: \d+ unique messages, (\d+) total",
                       logPath+"/1_1_yosys.log", t=int)

    extractGnuTime("run__synth",logPath+"/1_1_yosys.log")


    clk_list = read_sdc(resultPath+"/2_floorplan.sdc")
    metrics_dict["constraints__clocks__count"] = len(clk_list)
    metrics_dict["constraints__clocks__details"] = clk_list


# Floorplan
# ==============================================================================
    extractTagFromFile("floorplan__timing__tns_total",
                       "^tns (\S+)",
                       logPath+"/2_1_floorplan.log", t=float)
    metrics_dict["floorplan__timing__tns_total"] = jsonFile["floorplan__timing__tns_total"]

    extractTagFromFile("floorplan__timing__wns__worst",
                       "^wns (\S+)",
                       logPath+"/2_1_floorplan.log", t=float)
    metrics_dict["floorplan__timing__wns__worst"] = jsonFile["floorplan__timing__wns__worst"]

    metrics_dict["floorplan__timing__tns__regreg"] = "N/A"
    metrics_dict["floorplan__timing__wns__regreg"] = "N/A"
    metrics_dict["floorplan__timing__tns__pireg"]= "N/A"
    metrics_dict["floorplan__timing__wns__pireg"] = "N/A"
    metrics_dict["floorplan__timing__tns__regpo"] = "N/A"
    metrics_dict["floorplan__timing__wns__regpo"] = "N/A"

    extractTagFromFile("floorplan__inst__area__stdcell",
                       "^Design area (\S+) u\^2",
                       logPath+"/2_1_floorplan.log", t=int)
    metrics_dict["floorplan__inst__count__stdcell"] = 0
    metrics_dict["floorplan__inst__area__stdcell"] = jsonFile["floorplan__inst__area__stdcell"]

    extractTagFromFile("floorplan__inst__count__macros",
                       "Extracted # Macros: (\S+)",
                       logPath+"/2_4_mplace.log", -1, 0, t=int)
    metrics_dict["floorplan__inst__count__macros"] = jsonFile["floorplan__inst__count__macros" ]

    metrics_dict["floorplan__inst__area__macros"] = 0 
    metrics_dict["floorplan__inst__area__total"] = 0 
    extractTagFromFile("floorplan__inst__count__IO",
                       "Num of I/O +(\d+)",
                       logPath+"/3_2_place_iop.log", t=int)
    metrics_dict["floorplan__inst__count__IO"] = jsonFile["floorplan__inst__count__IO"]

    extractTagFromFile("floorplan__inst__area__util",
                       "^Design area.* (\S+%) utilization",
                       logPath+"/2_1_floorplan.log")
    metrics_dict["floorplan__inst__area__util"] = jsonFile["floorplan__inst__area__util"]

    '''
    extractTagFromFile("run__floorplan__warnings",
                       "(?i)warning",
                       logPath+"/2_1_floorplan.log", -2, 0)
    extractGnuTime("floorplan",logPath+"/2_1_floorplan.log")

    extractGnuTime("run__floorplan_io",logPath+"/2_2_floorplan_io.log")
    extractGnuTime("run__floorplan_tdms",logPath+"/2_3_tdms_place.log")

    extractTagFromFile("macroplace__solutions",
                       "Total Extracted Solution: (\S+)",
                       logPath+"/2_4_mplace.log", -1, 0, t=int)
    extractGnuTime("run__mplace",logPath+"/2_4_mplace.log")

    extractGnuTime("run__tapcell",logPath+"/2_5_tapcell.log")

    extractGnuTime("run__pdn",logPath+"/2_6_pdn.log")
    '''


# Place
# ==============================================================================

# global place
    extractTagFromFile("globalplace__density__target",
                       "TargetDensity: (\S+)",
                       logPath+"/3_1_place_gp.log")
    metrics_dict["globalplace__density__target"] = jsonFile["globalplace__density__target"]

    extractTagFromFile("globalplace__wirelength__est",
                       "Total wirelength: (\S+)",
                       logPath+"/3_1_place_gp.log")
    metrics_dict["globalplace__wirelength__est"] = jsonFile["globalplace__wirelength__est"]

    '''
    extractTagFromFile("globalplace__slack__average__worst",
                       "^Worst slack: (\S+)",
                       logPath+"/3_1_place_gp.log")
    metrics_dict['place__global__timing__wns'] = jsonFile["globalplace__slack__average__worst"]

    extractTagFromFile("globalplace__slack__average__totneg",
                       "^Total negative slack: (\S+)",
                       logPath+"/3_1_place_gp.log")
    extractTagFromFile("globalplace__util",
                       "Util\(%\) = (\S+)",
                       logPath+"/3_1_place_gp.log")
    extractGnuTime("run__globalplace",logPath+"/3_1_place_gp.log")
    '''

# Resizer
    '''
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
    '''
    extractTagFromFile("placeopt__buffer__input__count",
                       "Inserted (\d+) input buffers",
                       logPath+"/3_3_resizer.log", t=int)
    metrics_dict["placeopt__buffer__input__count"] = jsonFile["placeopt__buffer__input__count"]

    extractTagFromFile("placeopt__buffer__output__count",
                       "Inserted (\d+) output buffers",
                       logPath+"/3_3_resizer.log", t=int)
    metrics_dict["placeopt__buffer__output__count"] = jsonFile["placeopt__buffer__output__count"]


    extractTagFromFile("placeopt__resize__inst__count",
                       "Resized (\d+) instances",
                       logPath+"/3_3_resizer.log", t=int)
    metrics_dict["placeopt__resize__inst__count"] = jsonFile["placeopt__resize__inst__count"]

    '''
    extractTagFromFile("resizer__hbuf_count",
                       "Inserted (\d+) hold buffers",
                       logPath+"/3_3_resizer.log", t=int)
    metrics_dict["placeopt__buffer__hold__count"] = jsonFile["resizer__hbuf_count"]

    extractTagFromFile("resizer__maxcap_viols",
                       "Found (\d+) max capacitance violations",
                       logPath+"/3_3_resizer.log", -1, 0, t=int)
    extractTagFromFile("resizer__maxslew_viols",
                       "Found (\d+) max slew violations",
                       logPath+"/3_3_resizer.log", -1, 0, t=int)
    extractTagFromFile("resizer__maxfanout_viols",
                       "Found (\d+) max fanout violations",
                       logPath+"/3_3_resizer.log", -1, 0, t=int)
    extractTagFromFile("resizer__maxfanout_bufs",
                       "Inserted (\d+) buffers",
                       logPath+"/3_3_resizer.log", -1, 0, t=int)
    '''


#TODO Tie hi tie low
# extractTagFromFile("resizer_maxfanout_bufs_tielo",
#                    "Inserted (\d+) tie \S+ instances for \d+ nets",
#                    logPath+"/3_3_resizer.log", 0, "0")
# extractTagFromFile("resizer_maxfanout_bufs_tielo",
#                    "Inserted (\d+) tie \S+ instances for \d+ nets",
#                    logPath+"/3_3_resizer.log", 1, "0")
    extractTagFromFile("resizer__post__slack__average__totneg",
                       "^tns (\S+)",
                       logPath+"/3_3_resizer.log", t=float)
    metrics_dict["placeopt__timing__tns__total"] = jsonFile["resizer__post__slack__average__totneg"]

    extractTagFromFile("resizer__post__slack__average__worst",
                       "^wns (\S+)",
                       logPath+"/3_3_resizer.log", t=float)
    metrics_dict["placeopt__timing__wns__worst"] = jsonFile["resizer__post__slack__average__worst"]

    extractTagFromFile("resizer__post__core__area__total",
                       "^Design area (\S+ \S+)",
                       logPath+"/3_3_resizer.log")
    metrics_dict["placeopt__inst__area__total"] = jsonFile["resizer__post__core__area__total"]

    extractTagFromFile("resizer__post__util",
                       "^Design area.* (\S+%) utilization",
                       logPath+"/3_3_resizer.log")
    metrics_dict["placeopt__inst__area__util"] = jsonFile["resizer__post__util"]

    extractGnuTime("run__resizer",logPath+"/3_3_resizer.log")


# Detail place
    extractTagFromFile("detailedplace__inst__displacement__total",
                       "total displacement +(\d*\.?\d*)",
                       logPath+"/3_4_opendp.log", t=float)
    metrics_dict["detailedplace__inst__displacement__total"] = jsonFile["detailedplace__inst__displacement__total"]

    extractTagFromFile("detailedplace__inst__displacement__average",
                       "average displacement +(\d*\.?\d*)",
                       logPath+"/3_4_opendp.log", t=float)
    metrics_dict["detailedplace__inst__displacement__average"] = jsonFile["detailedplace__inst__displacement__average"]

    extractTagFromFile("detailedplace__inst__displacement__max",
                       "max displacement +(\d*\.?\d*)",
                       logPath+"/3_4_opendp.log", t=float)
    metrics_dict["detailedplace__inst__displacement__max"] = jsonFile["detailedplace__inst__displacement__max"]

    extractTagFromFile("detailedplace__wirelength__initial__estimate",
                       "original HPWL +(\d*\.?\d*)",
                       logPath+"/3_4_opendp.log", t=float)
    metrics_dict["detailedplace__wirelength__initial__estimate"] = jsonFile["detailedplace__wirelength__initial__estimate"]

    extractTagFromFile("detailedplace__wirelength__final__estimate",
                       "legalized HPWL +(\d*\.?\d*)",
                       logPath+"/3_4_opendp.log", t=float)
    metrics_dict["detailedplace__wirelength__final__estimate"] = jsonFile["detailedplace__wirelength__final__estimate"]

    metrics_dict["detailedplace_timing_tns_total"] = "N/A"
    metrics_dict["detailedplace_timing_wns_worst"] = "N/A"

    '''
    extractTagFromFile("detailedplace__inst__core__area__total",
                       "design area +(\d*\.?\d*)",
                       logPath+"/3_4_opendp.log", t=float)
    metrics_dict["detailedplace__inst__area"] = jsonFile["detailedplace__inst__core__area__total"]

    extractTagFromFile("detailedplace__inst__num__total",
                       "total instances +(\d+)",
                       logPath+"/3_4_opendp.log", t=int)
    metrics_dict["detailedplace__inst__count"] = jsonFile["detailedplace__inst__num__total"]

    extractTagFromFile("detailedplace__util",
                       "utilization +(\d+)",
                       logPath+"/3_4_opendp.log", t=int)
    extractTagFromFile("detailedplace__wirelength__est__delta",
                       "delta HPWL +(\d*\.?\d*)",
                       logPath+"/3_4_opendp.log", t=int)
    extractGnuTime("run__dp",logPath+"/3_4_opendp.log")
    '''



# CTS

    extractTagFromFile("cts__timing__slack__tns",
                       "^tns (\S+)",
                       logPath+"/4_1_cts.log", t=float)
    metrics_dict["cts__timing__tns__total"] = jsonFile["cts__timing__slack__tns"]

    extractTagFromFile("cts__timing__slack__wns",
                       "^wns (\S+)",
                       logPath+"/4_1_cts.log", t=float)
    metrics_dict["cts__timing__wns__worst"] = jsonFile["cts__timing__slack__wns"]
    metrics_dict["cts__timing__skew__worst"] = 0 
    metrics_dict["cts__timing__latency__worst"] = 0 


# ==============================================================================
    extractGnuTime("run__cts",logPath+"/4_1_cts.log")

# Route
# ==============================================================================

    extractGnuTime("run__globalroute",logPath+"/5_1_fastroute.log")


    extractTagFromFile("detailedroute__layers__num__total",
                       "#layers: +(\S+)",
                       logPath+"/5_2_TritonRoute.log", t=int)
    metrics_dict["detailedroute__layers__count"] = jsonFile["detailedroute__layers__num__total"]

    extractTagFromFile("detailedroute__wirelength",
                       "total wire length = +(\S+) um",
                       logPath+"/5_2_TritonRoute.log", t=int)
    metrics_dict["detailedroute__wirelength"] = jsonFile["detailedroute__wirelength"]

    extractTagFromFile("detailedroute__via__count",
                       "total number of vias = +(\S+)",
                       logPath+"/5_2_TritonRoute.log", t=int)
    metrics_dict["detailedroute__via__count"] = jsonFile["detailedroute__via__count"]

    extractTagFromFile("detailedroute__errors__count",
                       "(?i)error:",
                       logPath+"/5_2_TritonRoute.log", -2, 0)
    metrics_dict["detailedroute__errors__count"] = jsonFile["detailedroute__errors__count"]

    extractTagFromFile("detailedroute__drc__error__count",
                       "(?i)violation",
                       rptPath+"/5_route_drc.rpt", -2, 0)
    metrics_dict["detailedroute__drc__error__count"] = jsonFile["detailedroute__drc__error__count"]

    '''
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
    extractTagFromFile("detailedroute__peak_mem",
                       "peak = (\S+)",
                       logPath+"/5_2_TritonRoute.log", t=float)

    extractTagFromFile("detailedroute__warnings",
                       "(?i)warning:",
                       logPath+"/5_2_TritonRoute.log", -2, 0)
    extractGnuTime("run__detailedroute",logPath+"/5_2_TritonRoute.log")
    '''

    with open("metrics.out", "w") as outFile:
      json.dump(metrics_dict, outFile, indent=4)

    metrics_df = pd.DataFrame(list(metrics_dict.items()))
    col_index = metrics_df.iloc[0][1] + "__" + metrics_df.iloc[1][1]
    metrics_df.columns = ["Metrics", col_index]
    return metrics_dict, metrics_df


# Main

print("List of designs")
rootdir = './logs'

jsonFile = OrderedDict()
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
                design_metrics, design_metrics_df = extract_metrics(cwd, plt, des)
                all_metrics.append(design_metrics)
                if all_metrics_df.shape[0] == 0:
                    all_metrics_df = design_metrics_df
                else:
                    all_metrics_df = all_metrics_df.merge(design_metrics_df, on = 'Metrics', how = 'inner')
#metrics_json = all_metrics_df.to_json(orient='columns')
#metrics_json = all_metrics.to_json()
#print(metrics_json)
with open("metrics.json", "w") as outFile:
  json.dump(all_metrics, outFile)
  #outFile.write(metrics_json)
#print(all_metrics_df)

#
# render to html
#
metrics_html = all_metrics_df.to_html()
metrics_html_file = open("metrics.html", "w")
metrics_html_file.write(metrics_html)
metrics_html_file.close()
exit()

"""
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

print("Total = ", total)
print(jsonFile)
if failed:
  jsonFile["total_time"] = "ERR"
else:
  jsonFile["total_time"] = str(total)

print(jsonFile["detailedplace__wirelength__est__legalized"])
#print json.dumps(jsonFile, indent=2)
#with open(args.output, "w") as resultSpecfile:
with open("metrics.out", "w") as outFile:
  outFile.write(json.dumps(metrics_dict))
"""
