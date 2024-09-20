import argparse
import pandas as pd
import json
import re
import sys
from pathlib import Path

METRICS = (
    "clk_period-worst_slack",
    # "worst_slack",
    "total_power",
    "core_util",
    "final_util",
    "design_area",
    "core_area",
    "die_area",
    "last_successful_stage",
)


def normalize_level_number(name: str) -> str:
    """
    Adds zero padding for numbers in name.

    Parameters
    ----------
    name : str
        Name of the design

    Returns
    -------
    str
        Name with padded numbers
    """

    def _replace(match: re.Match) -> str:
        number = int(match.group(1))
        return f"_{number:05}_"

    return re.sub(r"_([0-9]+)_", _replace, name)


def read_config(conf):
    params = []
    for key, value in conf.items():
        if value["type"] != "fixed":
            params.append(key)
    columns = ("Level", *params, *METRICS)
    return params, columns


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-r",
        "--results",
        help="Directory containing optimization results (JSON files)",
        type=Path,
        required=True,
    )
    parser.add_argument(
        "--to-markdown",
        help="Path where markdown file with results will be saved",
        default=None,
        type=Path,
    )
    parser.add_argument(
        "--to-html",
        help="Path where html file with results will be saved",
        default=None,
        type=Path,
    )

    args = parser.parse_args(sys.argv[1:])

    rows = []
    params, columns = None, None
    for result in sorted(
        args.results.glob("*.json"),
        key=lambda x: normalize_level_number(x.with_suffix("").name),
    ):
        design = result.with_suffix("").name
        with result.open("r") as fd:
            result_json = json.load(fd)
        if params is None or columns is None:
            params, columns = read_config(result_json["config"])
        optimals = result_json["optimals"]
        not_finished = False
        if 11 in set(opt["evaluation"]["last_successful_stage"] for opt in optimals):
            opts = sorted(
                filter(
                    lambda x: x["evaluation"]["last_successful_stage"] == 11, optimals
                ),
                key=lambda x: x["evaluation"]["core_util"],
                reverse=True,
            )
        else:
            opts = [optimals[0]]
        for opt in opts:
            if opt["evaluation"]["last_successful_stage"] < 11:
                if not_finished:
                    continue
                not_finished = True
            rows.append(
                [design]
                + [opt["params"][p] for p in params]
                + [opt["evaluation"][e] for e in METRICS]
            )
        rows.append(["" for _ in columns])
    result_df = pd.DataFrame(rows[:-1], columns=columns)
    if args.to_markdown:
        result_df.to_markdown(args.to_markdown, index=False)
    if args.to_html:
        result_df.to_html(args.to_html, index=False)
