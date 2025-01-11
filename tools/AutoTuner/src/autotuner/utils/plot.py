import glob
import json
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import re
import os
import argparse

AT_REGEX = r"variant-AutoTunerBase-([\w-]+)-\w+"
IMG_DIR = "images"


def load_dir(dir: str) -> pd.DataFrame:
    # Concatenate progress DFs
    df = pd.concat([pd.read_csv(fname) for fname in glob.glob(f"{dir}/*/progress.csv")])

    # Concatenate params.json & metrics.json file
    params = []
    failed = []
    for params_fname in glob.glob(f"{dir}/*/params.json"):
        try:
            with open(params_fname, "r") as f:
                _dict = json.load(f)
                _dict["trial_id"] = re.search(AT_REGEX, params_fname).group(1)
            metrics_fname = params_fname.replace("params.json", "metrics.json")
            with open(metrics_fname, "r") as f:
                metrics = json.load(f)
                ws = metrics["finish"]["timing__setup__ws"]
                metrics["worst_slack"] = ws
                _dict.update(metrics)
            params.append(_dict)
        except Exception as e:
            failed.append(metrics_fname)
            continue
    tmp_df = pd.DataFrame(params)

    # Merge all dataframe
    df = df.merge(tmp_df, on="trial_id")
    print(f"Failed to load {len(failed)} files:\n{'\n'.join(failed)}")
    return df


def preprocess(df: pd.DataFrame) -> pd.DataFrame:
    cols_to_remove = [
        "done",
        "training_iteration",
        "date",
        "pid",
        "hostname",
        "node_ip",
        "time_since_restore",
        "time_total_s",
        "iterations_since_restore",
    ]
    rename_dict = {
        "time_this_iter_s": "runtime",
        "_SDC_CLK_PERIOD": "clk_period",
        "minimum": "qor",
    }
    df = df.rename(columns=rename_dict)
    df = df.drop(columns=cols_to_remove)
    df = df[df["qor"] != 9e99]
    df["timestamp"] -= df["timestamp"].min()
    return df


def plot(df: pd.DataFrame, key: str):
    # Plot box plot and time series plot for key
    fig, ax = plt.subplots(1, figsize=(15, 10))
    ax.scatter(df["timestamp"], df[key])
    ax.set_xlabel("Time (s)")
    ax.set_ylabel(key)
    ax.set_title(f"{key} vs Time")
    z = np.polyfit(df["timestamp"], df[key], 1)
    p = np.poly1d(z)
    ax.plot(
        df["timestamp"], p(df["timestamp"]), "r--", label=f"y={z[0]:.2f}x+{z[1]:.2f}"
    )
    ax.legend()
    fig.savefig(f"images/{key}.png")

    plt.figure(figsize=(15, 10))
    plt.boxplot(df[key])
    plt.ylabel(key)
    plt.title(f"{key} Boxplot")
    plt.savefig(f"images/{key}-boxplot.png")


def main(results_dir: str):
    # Default: saves to <REPO_ROOT>/images. Change the IMG_DIR above.
    os.makedirs(IMG_DIR, exist_ok=True)
    df = load_dir(results_dir)
    df = preprocess(df)
    keys = ["qor", "runtime", "clk_period", "worst_slack"]
    for key in keys:
        plot(df, key)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Plot AutoTuner results.")
    parser.add_argument(
        "--results_dir",
        type=str,
        help="Directory containing the results.",
        required=True,
    )
    args = parser.parse_args()
    main(args.results_dir)
