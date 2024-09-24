#!/usr/bin/env python3

from math import ceil, isinf
from os import chdir, getcwd
from os.path import isfile, abspath
from re import sub
import argparse
import json
import operator
import sys
import requests


def get_golden(platform, design, api_base_url):
    try:
        response = requests.get(
            api_base_url + f"/golden?platform={platform}&design={design}&variant=base"
        )

        # Check if the request was successful (status code 200)
        if response.status_code == 200 and "error" not in response.json():
            # Parse the JSON response
            data = response.json()

            return data, None
        else:
            print("API request failed")
            return None, "API request failed"
    except Exception as e:
        print(f"An error occurred: {str(e)}")
        return None, f"An error occurred: {str(e)}"


def get_metrics(commitSHA, platform, design, api_base_url):
    try:
        response = requests.get(
            api_base_url
            + f"/commit?commitSHA={commitSHA}&platform={platform}&design={design}&variant=base"
        )

        # Check if the request was successful (status code 200)
        if response.status_code == 200 and "error" not in response.json():
            # Parse the JSON response
            data = response.json()

            return data, None
        else:
            print("API request failed")
            return None, "API request failed"
    except Exception as e:
        print(f"An error occurred: {str(e)}")
        return None, f"An error occurred: {str(e)}"


def update_rules(designDir, variant, golden_metrics, overwrite):
    if overwrite:
        gen_rule_file(
            designDir,  # design directory
            True,  # update
            False,  # tighten
            False,  # failing
            variant,  # variant
            golden_metrics,  # metrics needed for update, default is {} in case of file
        )
    else:
        gen_rule_file(
            designDir,  # design directory
            False,  # update
            True,  # tighten
            False,  # failing
            variant,  # variant
            golden_metrics,  # metrics needed for update, default is {} in case of file
        )


def gen_rule_file(design_dir, update, tighten, failing, variant, golden_metrics={}):
    original_directory = getcwd()
    chdir(design_dir)

    metrics_file = f"metadata-{variant}-ok.json"
    rules_file = f"rules-{variant}.json"
    rules = dict()

    if golden_metrics == {}:
        if isfile(metrics_file):
            with open(metrics_file, "r") as f:
                metrics = json.load(f)
        else:
            print(f"[ERROR] File not found {abspath(metrics_file)}")
            sys.exit(1)
    else:
        metrics = golden_metrics

    if isfile(rules_file):
        with open(rules_file, "r") as f:
            OLD_RULES = json.load(f)
    else:
        print(f"[WARNING] File not found {abspath(rules_file)}")
        OLD_RULES = None

    # dict format
    # 'metric_name': {
    #     'padding': <float>, percentage of padding to use
    #     'fixed': <float>, sum this number instead of using % padding
    #     'round_value': <bool>, use the rounded value for the rule
    # }

    rules_dict = {
        # synth
        "synth__design__instance__area__stdcell": {
            "mode": "padding",
            "padding": 15,
            "round_value": False,
            "compare": "<=",
        },
        # clock
        "constraints__clocks__count": {
            "mode": "direct",
            "round_value": True,
            "compare": "==",
        },
        # floorplan
        # place
        "placeopt__design__instance__area": {
            "mode": "padding",
            "padding": 15,
            "round_value": True,
            "compare": "<=",
        },
        "placeopt__design__instance__count__stdcell": {
            "mode": "padding",
            "padding": 15,
            "round_value": True,
            "compare": "<=",
        },
        "detailedplace__design__violations": {
            "mode": "direct",
            "round_value": True,
            "compare": "==",
        },
        # cts
        "cts__design__instance__count__setup_buffer": {
            "mode": "metric",
            "padding": 10,
            "metric": "placeopt__design__instance__count__stdcell",
            "round_value": True,
            "compare": "<=",
        },
        "cts__design__instance__count__hold_buffer": {
            "mode": "metric",
            "padding": 10,
            "metric": "placeopt__design__instance__count__stdcell",
            "round_value": True,
            "compare": "<=",
        },
        # route
        "globalroute__antenna_diodes_count": {
            "mode": "padding",
            "padding": 15,
            "round_value": True,
            "compare": "<=",
        },
        "detailedroute__route__wirelength": {
            "mode": "padding",
            "padding": 15,
            "round_value": True,
            "compare": "<=",
        },
        "detailedroute__route__drc_errors": {
            "mode": "direct",
            "round_value": True,
            "compare": "<=",
        },
        "detailedroute__antenna__violating__nets": {
            "mode": "padding",
            "padding": 30,
            "round_value": True,
            "compare": "<=",
        },
        "detailedroute__antenna_diodes_count": {
            "mode": "padding",
            "padding": 15,
            "round_value": True,
            "compare": "<=",
        },
        # finish
        "finish__timing__setup__ws": {
            "mode": "period",
            "padding": 5,
            "round_value": False,
            "compare": ">=",
        },
        "finish__design__instance__area": {
            "mode": "padding",
            "padding": 15,
            "round_value": True,
            "compare": "<=",
        },
        "finish__timing__drv__setup_violation_count": {
            "mode": "metric",
            "padding": 5,
            "metric": "placeopt__design__instance__count__stdcell",
            "round_value": True,
            "compare": "<=",
        },
        "finish__timing__drv__hold_violation_count": {
            "mode": "padding",
            "padding": 25,
            "min_max": max,
            "min_max_sum": 100,
            "round_value": True,
            "compare": "<=",
        },
        "finish__timing__wns_percent_delay": {
            "mode": "padding",
            "padding": 20,
            "min_max": min,
            "min_max_sum": -10,
            "round_value": False,
            "compare": ">=",
        },
    }

    ops = {
        "<": operator.lt,
        ">": operator.gt,
        "<=": operator.le,
        ">=": operator.ge,
        "==": operator.eq,
        "!=": operator.ne,
    }

    period_list = metrics["constraints__clocks__details"]

    period = float(sub(r"^.*: ", "", period_list[0]))
    if len(period_list) != 1:
        print(
            f"[WARNING] Multiple clocks not supported. Will use first clock: {period_list[0]}."
        )

    format_str = "| {:45} | {:8} | {:8} | {:8} |\n"
    change_str = ""
    for field, option in rules_dict.items():
        if field not in metrics.keys():
            print(
                f"[ERROR] Metric {field} not found in "
                f"metrics file: {metrics_file} or golden metrics."
            )
            sys.exit(1)

        if isinstance(metrics[field], str):
            print(f"[WARNING] Skipping string field {field} = {metrics[field]}")
            continue

        if len(period_list) != 1 and field == "globalroute__timing__clock__slack":
            print("[WARNING] Skipping clock slack until multiple clocks support.")
            continue

        rule_value = None
        if option["mode"] == "direct":
            rule_value = metrics[field]

        elif option["mode"] == "sum_fixed":
            rule_value = metrics[field] + option["padding"]

        elif option["mode"] == "period":
            rule_value = metrics[field] - period * option["padding"] / 100
            rule_value = min(rule_value, 0)

        elif option["mode"] == "padding":
            rule_value = metrics[field] * (1 + option["padding"] / 100)

        elif option["mode"] == "abs_padding":
            rule_value = abs(metrics[field]) * (1 + option["padding"] / 100)

        elif option["mode"] == "metric":
            rule_value = metrics[option["metric"]] * option["padding"] / 100

        if (
            field == "cts__design__instance__count__setup_buffer"
            or field == "cts__design__instance__count__hold_buffer"
        ):
            rule_value = max(rule_value, metrics[field] * 1.1)

        if "min_max" in option.keys():
            if "min_max_direct" in option.keys():
                rule_value = option["min_max"](rule_value, option["min_max_direct"])
            elif "min_max_sum" in option.keys():
                rule_value = option["min_max"](
                    rule_value + option["min_max_sum"], option["min_max_sum"]
                )
            else:
                print(
                    f"[ERROR] Metric {field} has 'min_max' field but no "
                    "'min_max_direct' or 'min_max_sum' field."
                )
                sys.exit(1)

        if rule_value is None:
            print(f"[ERROR] Metric {field} has invalid mode {option['mode']}.")
            sys.exit(1)

        if option["round_value"] and not isinf(rule_value):
            rule_value = int(round(rule_value))
        else:
            rule_value = ceil(rule_value * 100) / 100.0

        if OLD_RULES is not None and field in OLD_RULES.keys():
            old_rule = OLD_RULES[field]
            if old_rule["compare"] != option["compare"]:
                print("[WARNING] Compare operator changed since last update.")

            compare = ops[option["compare"]]

            if compare(rule_value, metrics[field]) and "padding" in option.keys():
                rule_value = metrics[field] * (1 + option["padding"] / 100)
                if option["round_value"] and not isinf(rule_value):
                    rule_value = int(round(rule_value))
                else:
                    rule_value = ceil(rule_value * 100) / 100.0

            UPDATE = False
            if (
                tighten
                and rule_value != old_rule["value"]
                and compare(rule_value, old_rule["value"])
            ):
                UPDATE = True
                change_str += format_str.format(
                    field, old_rule["value"], rule_value, "Tighten"
                )

            if failing and not compare(metrics[field], old_rule["value"]):
                UPDATE = True
                change_str += format_str.format(
                    field, old_rule["value"], rule_value, "Failing"
                )

            if update and old_rule["value"] != rule_value:
                UPDATE = True
                change_str += format_str.format(
                    field, old_rule["value"], rule_value, "Updating"
                )

            if not UPDATE:
                rule_value = old_rule["value"]

        rules[field] = dict(value=rule_value, compare=option["compare"])

    if len(change_str) > 0:
        print(format_str.format("Metric", "Old", "New", "Type"), end="")
        print(format_str.format("------", "---", "---", "----"), end="")
        print(change_str)

    with open(rules_file, "w") as f:
        print("[INFO] writing", abspath(rules_file))
        json.dump(rules, f, indent=4)

    chdir(original_directory)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Generates or updates rules file for CI."
    )
    parser.add_argument("dir", help="Path to the design directory.")
    parser.add_argument(
        "-v", "--variant", default="base", help='Flow variant [default="base"].'
    )
    parser.add_argument(
        "-u",
        "--update",
        action="store_true",
        default=False,
        help="Update all rules independent of previous values.",
    )
    parser.add_argument(
        "-t",
        "--tighten",
        action="store_true",
        default=False,
        help="Update passing rules if they became tighter",
    )
    parser.add_argument(
        "-f",
        "--failing",
        action="store_true",
        default=False,
        help="Update failing rules.",
    )
    args = parser.parse_args()

    if not args.update and not args.tighten and not args.failing:
        print(
            "[ERROR] Please select at least one of "
            "-u/--update, -t/--tighten, -f/--failing."
        )
        parser.print_help()
        sys.exit(1)

    gen_rule_file(args.dir, args.update, args.tighten, args.failing, args.variant)
