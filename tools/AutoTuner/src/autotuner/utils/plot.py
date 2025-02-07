import glob
import json
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import re
import os
import argparse
import sys

# Only does plotting for AutoTunerBase variants
AT_REGEX = r"variant-AutoTunerBase-([\w-]+)-\w+"

# TODO: Make sure the distributed.py METRIC variable is consistent with this, single source of truth.
METRIC = "metric"

cur_dir = os.path.dirname(os.path.abspath(__file__))
root_dir = os.path.join(cur_dir, "../../../../../")
os.chdir(root_dir)


def load_dir(dir: str) -> pd.DataFrame:
    """
    Load and merge progress, parameters, and metrics data from a specified directory.
    This function searches for `progress.csv`, `params.json`, and `metrics.json` files within the given directory,
    concatenates the data, and merges them into a single pandas DataFrame.
    Args:
        dir (str): The directory path containing the subdirectories with `progress.csv`, `params.json`, and `metrics.json` files.
    Returns:
        pd.DataFrame: A DataFrame containing the merged data from the progress, parameters, and metrics files.
    """

    # Concatenate progress DFs
    progress_csvs = glob.glob(f"{dir}/*/progress.csv")
    if len(progress_csvs) == 0:
        print("No progress.csv files found.")
        sys.exit(1)
    progress_df = pd.concat([pd.read_csv(f) for f in progress_csvs])

    # Concatenate params.json & metrics.json file
    params = []
    failed = []
    for params_fname in glob.glob(f"{dir}/*/params.json"):
        metrics_fname = params_fname.replace("params.json", "metrics.json")
        try:
            with open(params_fname, "r") as f:
                _dict = json.load(f)
                _dict["trial_id"] = re.search(AT_REGEX, params_fname).group(1)
            with open(metrics_fname, "r") as f:
                metrics = json.load(f)
                ws = metrics["finish"]["timing__setup__ws"]
                metrics["worst_slack"] = ws
                _dict.update(metrics)
            params.append(_dict)
        except Exception as e:
            failed.append(metrics_fname)
            continue

    # Merge all dataframe
    params_df = pd.DataFrame(params)
    try:
        progress_df = progress_df.merge(params_df, on="trial_id")
    except KeyError:
        print(
            "Unable to merge DFs due to missing trial_id in params.json (possibly due to failed trials.)"
        )
        sys.exit(1)

    # Print failed, if any
    if failed:
        failed_files = "\n".join(failed)
        print(f"Failed to load {len(failed)} files:\n{failed_files}")
    return progress_df


def preprocess(df: pd.DataFrame) -> pd.DataFrame:
    """
    Preprocess the input DataFrame by renaming columns, removing unnecessary columns,
    filtering out invalid rows, and normalizing the timestamp.
    Args:
        df (pd.DataFrame): The input DataFrame to preprocess.
    Returns:
        pd.DataFrame: The preprocessed DataFrame with renamed columns, removed columns,
                      filtered rows, and normalized timestamp.
    """

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
        "_SDC_CLK_PERIOD": "clk_period",  # param
    }
    try:
        df = df.rename(columns=rename_dict)
        df = df.drop(columns=cols_to_remove)
        df = df[df[METRIC] != 9e99]
        df["timestamp"] -= df["timestamp"].min()
        return df
    except KeyError as e:
        print(
            f"KeyError: {e} in the DataFrame. Dataframe does not contain necessary columns."
        )
        sys.exit(1)


def plot(df: pd.DataFrame, key: str, dir: str):
    """
    Plots a scatter plot with a linear fit and a box plot for a specified key from a DataFrame.
    Args:
        df (pd.DataFrame): The DataFrame containing the data to plot.
        key (str): The column name in the DataFrame to plot.
        dir (str): The directory where the plots will be saved. The directory must exist.
    Returns:
        None
    """

    assert os.path.exists(dir), f"Directory {dir} does not exist."
    # Plot box plot and time series plot for key
    fig, ax = plt.subplots(1, figsize=(15, 10))
    ax.scatter(df["timestamp"], df[key])
    ax.set_xlabel("Time (s)")
    ax.set_ylabel(key)
    ax.set_title(f"{key} vs Time")

    try:
        coeff = np.polyfit(df["timestamp"], df[key], 1)
        poly_func = np.poly1d(coeff)
        ax.plot(
            df["timestamp"],
            poly_func(df["timestamp"]),
            "r--",
            label=f"y={coeff[0]:.2f}x+{coeff[1]:.2f}",
        )
        ax.legend()
    except np.linalg.LinAlgError:
        print("Cannot fit a line to the data, plotting only scatter plot.")

    fig.savefig(f"{dir}/{key}.png")

    plt.figure(figsize=(15, 10))
    plt.boxplot(df[key])
    plt.ylabel(key)
    plt.title(f"{key} Boxplot")
    plt.savefig(f"{dir}/{key}-boxplot.png")


def main(platform: str, design: str, experiment: str):
    """
    Main function to process results from a specified directory and plot the results.
    Args:
        platform (str): The platform name.
        design (str): The design name.
        experiment (str): The experiment name.
    Returns:
        None
    """

    results_dir = os.path.join(
        root_dir, f"./flow/logs/{platform}/{design}/{experiment}"
    )
    img_dir = os.path.join(
        root_dir, f"./flow/reports/images/{platform}/{design}/{experiment}"
    )
    print("Processing results from", results_dir)
    os.makedirs(img_dir, exist_ok=True)
    df = load_dir(results_dir)
    df = preprocess(df)
    keys = [METRIC] + ["runtime", "clk_period", "worst_slack"]

    # Plot only if more than one entry
    if len(df) < 2:
        print("Less than 2 entries, skipping plotting.")
        sys.exit(0)
    for key in keys:
        plot(df, key, img_dir)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Plot AutoTuner results.")
    parser.add_argument("--platform", type=str, help="Platform name.", required=True)
    parser.add_argument("--design", type=str, help="Design name.", required=True)
    parser.add_argument(
        "--experiment", type=str, help="Experiment name.", required=True
    )
    args = parser.parse_args()
    main(platform=args.platform, design=args.design, experiment=args.experiment)
