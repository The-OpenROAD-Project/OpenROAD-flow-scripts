#!/usr/bin/env python3

# This scripts attempts to extract relevant data from a completed flow design
# and save it into a 'metadata.json'. It achieves this by looking for specific
# information in specific files using regular expressions
# -----------------------------------------------------------------------------

import hashlib
import os
import shutil
from datetime import datetime, timedelta
from collections import defaultdict
from uuid import uuid4 as uuid
from subprocess import check_output, call, STDOUT

import argparse
import json
import re
from glob import glob


def parse_args():
    parser = argparse.ArgumentParser(
        description="Generates metadata from OpenROAD flow"
    )
    parser.add_argument(
        "--design",
        "-d",
        required=True,
        help="Design Name for metrics",
    )
    parser.add_argument(
        "--flowVariant",
        "-v",
        required=False,
        default="base",
        help="FLOW_VARIANT for the design",
    )
    parser.add_argument(
        "--platform", "-p", required=False, default="nangate45", help="Design Platform"
    )
    parser.add_argument(
        "--comment",
        "-c",
        required=False,
        default="",
        help="Additional comments to embed",
    )
    parser.add_argument(
        "--output", "-o", required=False, default="metadata.json", help="Output file"
    )
    parser.add_argument("--hier", "-x", action="store_true", help="Hierarchical JSON")
    parser.add_argument("--logs", required=True, help="Path to logs")
    parser.add_argument("--reports", required=True, help="Path to reports")
    parser.add_argument("--results", required=True, help="Path to results")
    args = parser.parse_args()

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


def extractTagFromFile(
    jsonTag,
    jsonFile,
    pattern,
    file,
    count=False,
    occurrence=-1,
    defaultNotFound="N/A",
    t=float,
    required=True,
):
    if jsonTag in jsonFile:
        print("[WARN] Overwriting Tag", jsonTag)

    try:
        with open(file) as f:
            content = f.read()

        parsedMetrics = re.findall(pattern, content, re.M)

        patternNotFound = len(parsedMetrics) < abs(occurrence)
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
                    jsonFile[jsonTag] = t(value)
                except BaseException:
                    jsonFile[jsonTag] = str(value)
        else:
            # Only print a warning if the defaultNotFound is not set
            print(
                "[WARN] Tag {} not found in {}.".format(jsonTag, file),
                "Will use {}.".format(defaultNotFound),
            )
            jsonFile[jsonTag] = defaultNotFound
    except IOError:
        print("[ERROR] Failed to open file:", file)
        jsonFile[jsonTag] = "ERR"


def extractGnuTime(prefix, jsonFile, file):
    if not os.path.isfile(file):
        return
    extractTagFromFile(
        prefix + "__runtime__total",
        jsonFile,
        "^Elapsed time: (\\S+)\\[h:\\]min:sec.*",
        file,
    )
    extractTagFromFile(
        prefix + "__cpu__total",
        jsonFile,
        "^Elapsed time:.*CPU time: user (\\S+) .*",
        file,
    )
    extractTagFromFile(
        prefix + "__mem__peak", jsonFile, "^Elapsed time:.*Peak memory: (\\S+)KB.", file
    )


#
#  Extract clock info from sdc file
#
def read_sdc(file_name):
    clkList = []

    try:
        with open(file_name, "r") as sdcFile:
            lines = sdcFile.readlines()
    except OSError as e:
        print(f"[WARN] Failed to open file: {file_name} ({e})")
        return clkList

    for line in lines:
        if len(line.split()) < 2:
            continue
        if line.split()[0] == "create_clock":
            clk_idx = line.split().index("-name")
            clkName = line.split()[clk_idx + 1]
            period_idx = line.split().index("-period")
            period = line.split()[period_idx + 1]

            clk = "%s: %s" % (clkName, period)
            clkList.append(clk)

    clkList.sort()
    return clkList


# Main
# =============================================================================


def git_head_commit(git_exe, folder):
    """Resolve the HEAD commit SHA of `folder`'s git working tree, or
    return a descriptive fallback string. Accepts a pre-resolved
    `git_exe` path so callers don't pay a `shutil.which` lookup per
    invocation. Prints a [WARN] for the not-a-git-repo case (the
    git-missing case is expected to be warned about by the caller)."""
    if git_exe is None:
        return "git not on PATH"
    if not os.path.isdir(folder):
        return "N/A"
    with open(os.devnull, "w") as devnull:
        if call([git_exe, "branch"], stderr=STDOUT, stdout=devnull, cwd=folder) != 0:
            print("[WARN] not a git repo:", folder)
            return "not a git repo"
    return (
        check_output([git_exe, "rev-parse", "HEAD"], cwd=folder).decode("utf-8").strip()
    )


def file_sha1(path):
    """SHA-1 of `path`, or "N/A" if absent or empty. Empty counts as
    absent so Bazel's touched placeholder files (e.g. the canonicalize
    RTLIL under SYNTH_USE_SYN or SYNTH_NETLIST_FILES) hash the same as
    a make run that never wrote the file. Read in chunks so large
    netlists don't blow the heap."""
    if not os.path.isfile(path) or os.path.getsize(path) == 0:
        return "N/A"
    hasher = hashlib.sha1()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(16 * 1024 * 1024), b""):
            hasher.update(chunk)
    return hasher.hexdigest()


def merge_jsons(root_path, output, files):
    paths = sorted(glob(os.path.join(root_path, files)))
    for path in paths:
        with open(path, "r") as file:
            data = json.load(file)
        output.update(data)


def extract_metrics(
    cwd, platform, design, flow_variant, output, hier_json, logPath, rptPath, resultPath
):
    baseRegEx = "^{}\n^-*\n^{}"

    metrics_dict = defaultdict(dict)
    metrics_dict["run__flow__generate_date"] = datetime.now().strftime("%Y-%m-%d %H:%M")
    metrics_dict["run__flow__metrics_version"] = "Metrics_2.1.2"
    cmdOutput = check_output([os.environ.get("OPENROAD_EXE", "openroad"), "-version"])
    cmdFields = [x.decode("utf-8") for x in cmdOutput.split()]
    metrics_dict["run__flow__openroad_version"] = str(cmdFields[0])
    if len(cmdFields) > 1:
        metrics_dict["run__flow__openroad_commit"] = str(cmdFields[1])
    else:
        metrics_dict["run__flow__openroad_commit"] = "N/A"
    git_exe = shutil.which("git")
    if git_exe is None:
        print("[WARN] git not on PATH; commit metadata will be N/A")
    metrics_dict["run__flow__scripts_commit"] = git_head_commit(git_exe, cwd)
    metrics_dict["run__flow__uuid"] = str(uuid())
    metrics_dict["run__flow__design"] = design
    metrics_dict["run__flow__platform"] = platform
    platformDir = os.environ.get("PLATFORM_DIR")
    if platformDir is None:
        print("[INFO]", "PLATFORM_DIR env variable not set")
        metrics_dict["run__flow__platform_commit"] = "N/A"
    else:
        metrics_dict["run__flow__platform_commit"] = git_head_commit(
            git_exe, platformDir
        )
    metrics_dict["run__flow__variant"] = flow_variant

    # Synthesis
    # =========================================================================
    merge_jsons(logPath, metrics_dict, "1_*.json")

    # Netlist hashes: fingerprints of the canonical RTLIL (pre-ABC) and
    # the final post-synthesis Verilog so the rules-base.json check
    # (level=warning) flags when bazel-built vs make-built yosys
    # disagree for the same RTL.
    metrics_dict["synth__canonical_netlist__hash"] = file_sha1(
        resultPath + "/1_1_yosys_canonicalize.rtlil"
    )
    metrics_dict["synth__netlist__hash"] = file_sha1(resultPath + "/1_2_yosys.v")

    # Clocks
    # =========================================================================
    # Prefer the floorplan SDC; on a synthesis-only tree (e.g. the "syn"
    # flow variant stops after 1_synth) fall back to the canonicalized
    # synthesis SDC, which carries the same create_clock lines.
    sdc_file = resultPath + "/2_floorplan.sdc"
    if not os.path.isfile(sdc_file):
        sdc_file = resultPath + "/1_synth.sdc"
    clk_list = read_sdc(sdc_file)
    metrics_dict["constraints__clocks__count"] = len(clk_list)
    metrics_dict["constraints__clocks__details"] = clk_list

    # Floorplan
    # =========================================================================
    merge_jsons(logPath, metrics_dict, "2_*.json")

    # Place
    # =========================================================================
    merge_jsons(logPath, metrics_dict, "3_*.json")

    # CTS
    # =======================================================================
    merge_jsons(logPath, metrics_dict, "4_*.json")

    # Global Route
    # =========================================================================
    merge_jsons(logPath, metrics_dict, "5_*.json")
    # Guarded so a synthesis-only tree doesn't pollute the metadata with
    # "ERR" values for stages that never ran.
    if os.path.isfile(logPath + "/5_1_grt.log"):
        extractTagFromFile(
            "globalroute__timing__clock__slack",
            metrics_dict,
            "^\\[INFO FLW-....\\] Clock .* slack (\\S+)",
            logPath + "/5_1_grt.log",
        )

    # Finish
    # =========================================================================
    merge_jsons(logPath, metrics_dict, "6_*.json")
    if os.path.isfile(rptPath + "/6_finish.rpt"):
        extractTagFromFile(
            "finish__timing__wns_percent_delay",
            metrics_dict,
            baseRegEx.format("finish slack div critical path delay", "(\\S+)"),
            rptPath + "/6_finish.rpt",
        )

    extractGnuTime("finish", metrics_dict, logPath + "/6_report.log")

    # Accumulate time
    # =========================================================================

    extractGnuTime("synth", metrics_dict, logPath + "/1_synth.log")  # syn
    extractGnuTime("synth", metrics_dict, logPath + "/1_2_yosys.log")  # yosys
    extractGnuTime("floorplan", metrics_dict, logPath + "/2_1_floorplan.log")
    extractGnuTime("floorplan_io", metrics_dict, logPath + "/2_2_floorplan_io.log")
    extractGnuTime(
        "floorplan_macro", metrics_dict, logPath + "/2_3_floorplan_macro.log"
    )
    extractGnuTime(
        "floorplan_tap", metrics_dict, logPath + "/2_4_floorplan_tapcell.log"
    )
    extractGnuTime("floorplan_pdn", metrics_dict, logPath + "/2_5_floorplan_pdn.log")
    extractGnuTime(
        "globalplace_skip_io", metrics_dict, logPath + "/3_1_place_gp_skip_io.log"
    )
    extractGnuTime("globalplace_io", metrics_dict, logPath + "/3_2_place_iop.log")
    extractGnuTime("globalplace", metrics_dict, logPath + "/3_3_place_gp.log")
    extractGnuTime("placeopt", metrics_dict, logPath + "/3_4_place_resized.log")
    extractGnuTime("detailedplace", metrics_dict, logPath + "/3_5_place_dp.log")
    extractGnuTime("cts", metrics_dict, logPath + "/4_1_cts.log")
    extractGnuTime("globalroute", metrics_dict, logPath + "/5_1_grt.log")
    extractGnuTime("fillcell", metrics_dict, logPath + "/5_2_fillcell.log")
    extractGnuTime("detailedroute", metrics_dict, logPath + "/5_3_route.log")
    extractGnuTime("finish_merge", metrics_dict, logPath + "/6_1_merge.log")
    extractGnuTime("finish", metrics_dict, logPath + "/6_report.log")

    failed = False
    total = timedelta()
    elapsed_seconds = {}
    for key in metrics_dict:
        if key.endswith("__runtime__total"):
            # Big try block because Hour and microsecond is optional
            try:
                t = datetime.strptime(metrics_dict[key], "%H:%M:%S.%f")
            except ValueError:
                try:
                    t = datetime.strptime(metrics_dict[key], "%M:%S.%f")
                except ValueError:
                    try:
                        t = datetime.strptime(metrics_dict[key], "%H:%M:%S")
                    except ValueError:
                        try:
                            t = datetime.strptime(metrics_dict[key], "%M:%S")
                        except ValueError:
                            failed = True
                            break

            delta = timedelta(
                hours=t.hour,
                minutes=t.minute,
                seconds=t.second,
                microseconds=t.microsecond,
            )
            total += delta

            stage = key[: -len("__runtime__total")]
            elapsed_seconds[stage + "__elapsed_seconds"] = delta.total_seconds()

    if failed:
        metrics_dict["total_time"] = "ERR"
        metrics_dict["total_elapsed_seconds"] = "ERR"
    else:
        metrics_dict["total_time"] = str(total)
        metrics_dict["total_elapsed_seconds"] = total.total_seconds()

    metrics_dict.update(elapsed_seconds)

    metrics_dict = {
        key.replace(":", "__"): value for key, value in metrics_dict.items()
    }

    if hier_json:
        # Convert the Metrics dictionary to hierarchical format by stripping
        # the stage as a 'key'
        hier_dict = defaultdict(dict)
        for metric in metrics_dict:
            key_list = metric.split("__", 1)
            if len(key_list) == 2:
                hier_dict[key_list[0]][key_list[1]] = metrics_dict[metric]
        metrics_dict = hier_dict

    with open(output, "w") as resultSpecfile:
        json.dump(metrics_dict, resultSpecfile, indent=2, sort_keys=True)


if __name__ == "__main__":
    args = parse_args()

    extract_metrics(
        os.path.join(os.path.dirname(os.path.realpath(__file__)), "../"),
        args.platform,
        args.design,
        args.flowVariant,
        args.output,
        args.hier,
        args.logs,
        args.reports,
        args.results,
    )
