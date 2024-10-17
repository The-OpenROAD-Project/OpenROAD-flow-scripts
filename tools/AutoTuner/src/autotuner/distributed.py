"""
This scripts handles sweeping and tuning of OpenROAD-flow-scripts parameters.
Dependencies are documented in pip format at distributed-requirements.txt

For both sweep and tune modes:
    python3 distributed.py -h

Note: the order of the parameters matter.
Arguments --design, --platform and --config are always required and should
precede the <mode>.

AutoTuner:
    python3 distributed.py tune -h
    python3 distributed.py --design gcd --platform sky130hd \
                           --config ../designs/sky130hd/gcd/autotuner.json \
                           tune
    Example:

Parameter sweeping:
    python3 distributed.py sweep -h
    Example:
    python3 distributed.py --design gcd --platform sky130hd \
                           --config distributed-sweep-example.json \
                           sweep
"""

import argparse
import json
import os
import re
import sys
import glob
import subprocess
import random
from datetime import datetime
from multiprocessing import cpu_count
from subprocess import run
from itertools import product
from collections import namedtuple
from uuid import uuid4 as uuid

import numpy as np
import torch

import ray
from ray import tune
from ray.tune.schedulers import AsyncHyperBandScheduler
from ray.tune.schedulers import PopulationBasedTraining
from ray.tune.search import ConcurrencyLimiter
from ray.tune.search.ax import AxSearch
from ray.tune.search.basic_variant import BasicVariantGenerator
from ray.tune.search.hyperopt import HyperOptSearch
from ray.tune.search.optuna import OptunaSearch
from ray.util.queue import Queue

from ax.service.ax_client import AxClient

DATE = datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
ORFS_URL = "https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts"
FASTROUTE_TCL = "fastroute.tcl"
CONSTRAINTS_SDC = "constraint.sdc"
METRIC = "minimum"
ERROR_METRIC = 9e99
ORFS_FLOW_DIR = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "../../../../flow")
)


class AutoTunerBase(tune.Trainable):
    """
    AutoTuner base class for experiments.
    """

    def setup(self, config):
        """
        Setup current experiment step.
        """
        # We create the following directory structure:
        #      1/     2/         3/       4/                5/   6/
        # <repo>/<logs>/<platform>/<design>/<experiment>-DATE/<id>/<cwd>
        repo_dir = os.getcwd() + "/../" * 6
        self.repo_dir = os.path.abspath(repo_dir)
        self.parameters = parse_config(config, path=os.getcwd())
        self.step_ = 0
        self.variant = f"variant-{self.__class__.__name__}-{self.trial_id}-or"

    def step(self):
        """
        Run step experiment and compute its score.
        """
        metrics_file = openroad(self.repo_dir, self.parameters, self.variant)
        self.step_ += 1
        score = self.evaluate(self.read_metrics(metrics_file))
        # Feed the score back to Tune.
        # return must match 'metric' used in tune.run()
        return {METRIC: score}

    def evaluate(self, metrics):
        """
        User-defined evaluation function.
        It can change in any form to minimize the score (return value).
        Default evaluation function optimizes effective clock period.
        """
        error = "ERR" in metrics.values()
        not_found = "N/A" in metrics.values()
        if error or not_found:
            return ERROR_METRIC
        gamma = (metrics["clk_period"] - metrics["worst_slack"]) / 10
        score = metrics["clk_period"] - metrics["worst_slack"]
        score = score * (self.step_ / 100) ** (-1) + gamma * metrics["num_drc"]
        return score

    @classmethod
    def read_metrics(cls, file_name):
        """
        Collects metrics to evaluate the user-defined objective function.
        """
        with open(file_name) as file:
            data = json.load(file)
        clk_period = 9999999
        worst_slack = "ERR"
        wirelength = "ERR"
        num_drc = "ERR"
        total_power = "ERR"
        core_util = "ERR"
        final_util = "ERR"
        for stage, value in data.items():
            if stage == "constraints" and len(value["clocks__details"]) > 0:
                clk_period = float(value["clocks__details"][0].split()[1])
            if stage == "floorplan" and "design__instance__utilization" in value:
                core_util = value["design__instance__utilization"]
            if stage == "detailedroute" and "route__drc_errors" in value:
                num_drc = value["route__drc_errors"]
            if stage == "detailedroute" and "route__wirelength" in value:
                wirelength = value["route__wirelength"]
            if stage == "finish" and "timing__setup__ws" in value:
                worst_slack = value["timing__setup__ws"]
            if stage == "finish" and "power__total" in value:
                total_power = value["power__total"]
            if stage == "finish" and "design__instance__utilization" in value:
                final_util = value["design__instance__utilization"]
        ret = {
            "clk_period": clk_period,
            "worst_slack": worst_slack,
            "wirelength": wirelength,
            "num_drc": num_drc,
            "total_power": total_power,
            "core_util": core_util,
            "final_util": final_util,
        }
        return ret


class PPAImprov(AutoTunerBase):
    """
    PPAImprov
    """

    @classmethod
    def get_ppa(cls, metrics):
        """
        Compute PPA term for evaluate.
        """
        coeff_perform, coeff_power, coeff_area = 10000, 100, 100

        eff_clk_period = metrics["clk_period"]
        if metrics["worst_slack"] < 0:
            eff_clk_period -= metrics["worst_slack"]

        eff_clk_period_ref = reference["clk_period"]
        if reference["worst_slack"] < 0:
            eff_clk_period_ref -= reference["worst_slack"]

        def percent(x_1, x_2):
            return (x_1 - x_2) / x_1 * 100

        performance = percent(eff_clk_period_ref, eff_clk_period)
        power = percent(reference["total_power"], metrics["total_power"])
        area = percent(100 - reference["final_util"], 100 - metrics["final_util"])

        # Lower values of PPA are better.
        ppa_upper_bound = (coeff_perform + coeff_power + coeff_area) * 100
        ppa = performance * coeff_perform
        ppa += power * coeff_power
        ppa += area * coeff_area
        return ppa_upper_bound - ppa

    def evaluate(self, metrics):
        error = "ERR" in metrics.values() or "ERR" in reference.values()
        not_found = "N/A" in metrics.values() or "N/A" in reference.values()
        print("Metrics", metrics.values())
        print("Reference", reference.values())
        print(error, not_found)
        if error or not_found:
            return ERROR_METRIC
        ppa = self.get_ppa(metrics)
        gamma = ppa / 10
        score = ppa * (self.step_ / 100) ** (-1) + (gamma * metrics["num_drc"])
        return score


def read_config(file_name):
    """
    Please consider inclusive, exclusive
    Most type uses [min, max)
    But, Quantization makes the upper bound inclusive.
    e.g., qrandint and qlograndint uses [min, max]
    step value is used for quantized type (e.g., quniform). Otherwise, write 0.
    When min==max, it means the constant value
    """

    def read(path):
        # if file path does not exist, return empty string
        print(os.path.abspath(path))
        if not os.path.isfile(os.path.abspath(path)):
            return ""
        with open(os.path.abspath(path), "r") as file:
            ret = file.read()
        return ret

    def read_sweep(this):
        return [*this["minmax"], this["step"]]

    def apply_condition(config, data):
        # TODO: tune.sample_from only supports random search algorithm.
        # To make conditional parameter for the other algorithms, different
        # algorithms should take different methods (will be added)
        if args.algorithm != "random":
            return config
        dp_pad_min = data["CELL_PAD_IN_SITES_DETAIL_PLACEMENT"]["minmax"][0]
        dp_pad_step = data["CELL_PAD_IN_SITES_DETAIL_PLACEMENT"]["step"]
        if dp_pad_step == 1:
            config["CELL_PAD_IN_SITES_DETAIL_PLACEMENT"] = tune.sample_from(
                lambda spec: np.random.randint(
                    dp_pad_min, spec.config.CELL_PAD_IN_SITES_GLOBAL_PLACEMENT + 1
                )
            )
        if dp_pad_step > 1:
            config["CELL_PAD_IN_SITES_DETAIL_PLACEMENT"] = tune.sample_from(
                lambda spec: random.randrange(
                    dp_pad_min,
                    spec.config.CELL_PAD_IN_SITES_GLOBAL_PLACEMENT + 1,
                    dp_pad_step,
                )
            )
        return config

    def read_tune(this):
        min_, max_ = this["minmax"]
        if min_ == max_:
            # Returning a choice of a single element allow pbt algorithm to
            # work. pbt does not accept single values as tunable.
            return tune.choice([min_, max_])
        if this["type"] == "int":
            if this["step"] == 1:
                return tune.randint(min_, max_)
            return tune.choice(np.ndarray.tolist(np.arange(min_, max_, this["step"])))
        if this["type"] == "float":
            if this["step"] == 0:
                return tune.uniform(min_, max_)
            return tune.choice(np.ndarray.tolist(np.arange(min_, max_, this["step"])))
        return None

    def read_tune_ax(name, this):
        """
        Ax format: https://ax.dev/versions/0.3.7/api/service.html
        """
        dict_ = dict(name=name)
        if "minmax" not in this:
            return None
        min_, max_ = this["minmax"]
        if min_ == max_:
            dict_["type"] = "fixed"
            dict_["value"] = min_
        elif this["type"] == "int":
            if this["step"] == 1:
                dict_["type"] = "range"
                dict_["bounds"] = [min_, max_]
                dict_["value_type"] = "int"
            else:
                dict_["type"] = "choice"
                dict_["values"] = tune.randint(min_, max_, this["step"])
                dict_["value_type"] = "int"
        elif this["type"] == "float":
            if this["step"] == 1:
                dict_["type"] = "choice"
                dict_["values"] = tune.choice(
                    np.ndarray.tolist(np.arange(min_, max_, this["step"]))
                )
                dict_["value_type"] = "float"
            else:
                dict_["type"] = "range"
                dict_["bounds"] = [min_, max_]
                dict_["value_type"] = "float"
        return dict_

    def read_tune_pbt(name, this):
        """
        PBT format: https://docs.ray.io/en/releases-2.9.3/tune/examples/pbt_guide.html
        Note that PBT does not support step values.
        """
        if "minmax" not in this:
            return None
        min_, max_ = this["minmax"]
        if min_ == max_:
            return ray.tune.choice([min_, max_])
        if this["type"] == "int":
            return ray.tune.randint(min_, max_)
        if this["type"] == "float":
            return ray.tune.uniform(min_, max_)

    # Check file exists and whether it is a valid JSON file.
    assert os.path.isfile(file_name), f"File {file_name} not found."
    try:
        with open(file_name) as file:
            data = json.load(file)
    except json.JSONDecodeError:
        raise ValueError(f"Invalid JSON file: {file_name}")
    sdc_file = ""
    fr_file = ""
    if args.mode == "tune" and args.algorithm == "ax":
        config = list()
    else:
        config = dict()
    for key, value in data.items():
        if key == "best_result":
            continue
        if key == "_SDC_FILE_PATH" and value != "":
            if sdc_file != "":
                print("[WARNING TUN-0004] Overwriting SDC base file.")
            sdc_file = read(f"{os.path.dirname(file_name)}/{value}")
            continue
        if key == "_FR_FILE_PATH" and value != "":
            if fr_file != "":
                print("[WARNING TUN-0005] Overwriting FastRoute base file.")
            fr_file = read(f"{os.path.dirname(file_name)}/{value}")
            continue
        if not isinstance(value, dict):
            # To take care of empty values like _FR_FILE_PATH
            if args.mode == "tune" and args.algorithm == "ax":
                param_dict = read_tune_ax(key, value)
                if param_dict:
                    config.append(param_dict)
            elif args.mode == "tune" and args.algorithm == "pbt":
                param_dict = read_tune_pbt(key, value)
                if param_dict:
                    config[key] = param_dict
            else:
                config[key] = value
        elif args.mode == "sweep":
            config[key] = read_sweep(value)
        elif args.mode == "tune" and args.algorithm == "ax":
            config.append(read_tune_ax(key, value))
        elif args.mode == "tune" and args.algorithm == "pbt":
            config[key] = read_tune_pbt(key, value)
        elif args.mode == "tune":
            config[key] = read_tune(value)
    if args.mode == "tune":
        config = apply_condition(config, data)
    return config, sdc_file, fr_file


def parse_flow_variables():
    """
    Parse the flow variables from source
    - Code: Makefile `vars` target output

    TODO: Tests.

    Output:
    - flow_variables: set of flow variables
    """
    cur_path = os.path.dirname(os.path.realpath(__file__))

    # first, generate vars.tcl
    makefile_path = os.path.join(cur_path, "../../../../flow/")
    initial_path = os.path.abspath(os.getcwd())
    os.chdir(makefile_path)
    result = subprocess.run(["make", "vars", f"PLATFORM={args.platform}"])
    if result.returncode != 0:
        print(f"[ERROR TUN-0018] Makefile failed with error code {result.returncode}.")
        sys.exit(1)
    if not os.path.exists("vars.tcl"):
        print(f"[ERROR TUN-0019] Makefile did not generate vars.tcl.")
        sys.exit(1)
    os.chdir(initial_path)

    # for code parsing, you need to parse from both scripts and vars.tcl file.
    pattern = r"(?:::)?env\((.*?)\)"
    files = glob.glob(os.path.join(cur_path, "../../../../flow/scripts/*.tcl"))
    files.append(os.path.join(cur_path, "../../../../flow/vars.tcl"))
    variables = set()
    for file in files:
        with open(file) as fp:
            matches = re.findall(pattern, fp.read())
        for match in matches:
            for variable in match.split("\n"):
                variables.add(variable.strip().upper())
    return variables


def parse_config(config, path=os.getcwd()):
    """
    Parse configuration received from tune into make variables.
    """
    options = ""
    sdc = {}
    fast_route = {}
    flow_variables = parse_flow_variables()
    for key, value in config.items():
        # Keys that begin with underscore need special handling.
        if key.startswith("_"):
            # Variables to be injected into fastroute.tcl
            if key.startswith("_FR_"):
                fast_route[key.replace("_FR_", "", 1)] = value
            # Variables to be injected into constraints.sdc
            elif key.startswith("_SDC_"):
                sdc[key.replace("_SDC_", "", 1)] = value
            # Special substitution cases
            elif key == "_PINS_DISTANCE":
                options += f' PLACE_PINS_ARGS="-min_distance {value}"'
            elif key == "_SYNTH_FLATTEN":
                print(
                    "[WARNING TUN-0013] Non-flatten the designs are not "
                    "fully supported, ignoring _SYNTH_FLATTEN parameter."
                )
        # Default case is VAR=VALUE
        else:
            # FIXME there is no robust way to get this metainformation from
            # ORFS about the variables, so disable this code for now.

            # Sanity check: ignore all flow variables that are not tunable
            # if key not in flow_variables:
            #     print(f"[ERROR TUN-0017] Variable {key} is not tunable.")
            #     sys.exit(1)
            options += f" {key}={value}"
    if bool(sdc):
        write_sdc(sdc, path)
        options += f" SDC_FILE={path}/{CONSTRAINTS_SDC}"
    if bool(fast_route):
        write_fast_route(fast_route, path)
        options += f" FASTROUTE_TCL={path}/{FASTROUTE_TCL}"
    return options


def write_sdc(variables, path):
    """
    Create a SDC file with parameters for current tuning iteration.
    """
    # Handle case where the reference file does not exist
    if SDC_ORIGINAL == "":
        print("[ERROR TUN-0020] No SDC reference file provided.")
        sys.exit(1)
    new_file = SDC_ORIGINAL
    for key, value in variables.items():
        if key == "CLK_PERIOD":
            if new_file.find("set clk_period") != -1:
                new_file = re.sub(
                    r"set clk_period .*\n(.*)", f"set clk_period {value}\n\\1", new_file
                )
            else:
                new_file = re.sub(
                    r"-period [0-9\.]+ (.*)", f"-period {value} \\1", new_file
                )
                new_file = re.sub(r"-waveform [{}\s0-9\.]+[\s|\n]", "", new_file)
        elif key == "UNCERTAINTY":
            if new_file.find("set uncertainty") != -1:
                new_file = re.sub(
                    r"set uncertainty .*\n(.*)",
                    f"set uncertainty {value}\n\\1",
                    new_file,
                )
            else:
                new_file += f"\nset uncertainty {value}\n"
        elif key == "IO_DELAY":
            if new_file.find("set io_delay") != -1:
                new_file = re.sub(
                    r"set io_delay .*\n(.*)", f"set io_delay {value}\n\\1", new_file
                )
            else:
                new_file += f"\nset io_delay {value}\n"
    file_name = path + f"/{CONSTRAINTS_SDC}"
    with open(file_name, "w") as file:
        file.write(new_file)
    return file_name


def write_fast_route(variables, path):
    """
    Create a FastRoute Tcl file with parameters for current tuning iteration.
    """
    # Handle case where the reference file does not exist (asap7 doesn't have reference)
    if FR_ORIGINAL == "" and args.platform != "asap7":
        print("[ERROR TUN-0021] No FastRoute Tcl reference file provided.")
        sys.exit(1)
    layer_cmd = "set_global_routing_layer_adjustment"
    new_file = FR_ORIGINAL
    for key, value in variables.items():
        if key.startswith("LAYER_ADJUST"):
            layer = key.lstrip("LAYER_ADJUST")
            # If there is no suffix (i.e., layer name) apply adjust to all
            # layers.
            if layer == "":
                new_file += "\nset_global_routing_layer_adjustment"
                new_file += " $::env(MIN_ROUTING_LAYER)"
                new_file += "-$::env(MAX_ROUTING_LAYER)"
                new_file += f" {value}"
            elif re.search(f"{layer_cmd}.*{layer}", new_file):
                new_file = re.sub(
                    f"({layer_cmd}.*{layer}).*\n(.*)", f"\\1 {value}\n\\2", new_file
                )
            else:
                new_file += f"\n{layer_cmd} {layer} {value}\n"
        elif key == "GR_SEED":
            new_file += f"\nset_global_routing_random -seed {value}\n"
    file_name = path + f"/{FASTROUTE_TCL}"
    with open(file_name, "w") as file:
        file.write(new_file)
    return file_name


def run_command(cmd, timeout=None, stderr_file=None, stdout_file=None, fail_fast=False):
    """
    Wrapper for subprocess.run
    Allows to run shell command, control print and exceptions.
    """
    process = run(
        cmd, timeout=timeout, capture_output=True, text=True, check=False, shell=True
    )
    if stderr_file is not None and process.stderr != "":
        with open(stderr_file, "a") as file:
            file.write(f"\n\n{cmd}\n{process.stderr}")
    if stdout_file is not None and process.stdout != "":
        with open(stdout_file, "a") as file:
            file.write(f"\n\n{cmd}\n{process.stdout}")
    if args.verbose >= 1:
        print(process.stderr)
    if args.verbose >= 2:
        print(process.stdout)

    if fail_fast and process.returncode != 0:
        raise RuntimeError


@ray.remote
def openroad_distributed(repo_dir, config, path):
    """Simple wrapper to run openroad distributed with Ray."""
    config = parse_config(config)
    openroad(repo_dir, config, str(uuid()), path=path)


def openroad(base_dir, parameters, flow_variant, path=""):
    """
    Run OpenROAD-flow-scripts with a given set of parameters.
    """
    # Make sure path ends in a slash, i.e., is a folder
    flow_variant = f"{args.experiment}/{flow_variant}"
    if path != "":
        log_path = f"{path}/{flow_variant}/"
        report_path = log_path.replace("logs", "reports")
        run_command(f"mkdir -p {log_path}")
        run_command(f"mkdir -p {report_path}")
    else:
        log_path = report_path = os.getcwd() + "/"

    export_command = f"export PATH={INSTALL_PATH}/OpenROAD/bin"
    export_command += f":{INSTALL_PATH}/yosys/bin:$PATH"
    export_command += " && "

    make_command = export_command
    make_command += f"make -C {base_dir}/flow DESIGN_CONFIG=designs/"
    make_command += f"{args.platform}/{args.design}/config.mk"
    make_command += f" PLATFORM={args.platform}"
    make_command += f" FLOW_VARIANT={flow_variant} {parameters}"
    make_command += f" EQUIVALENCE_CHECK=0"
    make_command += f" NPROC={args.openroad_threads} SHELL=bash"
    run_command(
        make_command,
        timeout=args.timeout,
        stderr_file=f"{log_path}error-make-finish.log",
        stdout_file=f"{log_path}make-finish-stdout.log",
    )

    metrics_file = os.path.join(report_path, "metrics.json")
    metrics_command = export_command
    metrics_command += f"{base_dir}/flow/util/genMetrics.py -x"
    metrics_command += f" -v {flow_variant}"
    metrics_command += f" -d {args.design}"
    metrics_command += f" -p {args.platform}"
    metrics_command += f" -o {metrics_file}"
    run_command(
        metrics_command,
        stderr_file=f"{log_path}error-metrics.log",
        stdout_file=f"{log_path}metrics-stdout.log",
    )

    return metrics_file


def clone(path):
    """
    Clone base repo in the remote machine. Only used for Kubernetes at GCP.
    """
    if args.git_clone:
        run_command(f"rm -rf {path}")
    if not os.path.isdir(f"{path}/.git"):
        git_command = "git clone --depth 1 --recursive --single-branch"
        git_command += f" {args.git_clone_args}"
        git_command += f" --branch {args.git_orfs_branch}"
        git_command += f" {args.git_url} {path}"
        run_command(git_command)


def build(base, install):
    """
    Build OpenROAD, Yosys and other dependencies.
    """
    build_command = f'cd "{base}"'
    if args.git_clean:
        build_command += " && git clean -xdf tools"
        build_command += " && git submodule foreach --recursive git clean -xdf"
    if (
        args.git_clean
        or not os.path.isfile(f"{install}/OpenROAD/bin/openroad")
        or not os.path.isfile(f"{install}/yosys/bin/yosys")
    ):
        build_command += ' && bash -ic "./build_openroad.sh'
        # Some GCP machines have 200+ cores. Let's be reasonable...
        build_command += f" --local --nice --threads {min(32, cpu_count())}"
        if args.git_latest:
            build_command += " --latest"
        build_command += f' {args.build_args}"'
    run_command(build_command)


@ray.remote
def setup_repo(base):
    """
    Clone ORFS repository and compile binaries.
    """
    print(f"[INFO TUN-0000] Remote folder: {base}")
    install = f"{base}/tools/install"
    if args.server is not None:
        clone(base)
    build(base, install)
    return install


def parse_arguments():
    """
    Parse arguments from command line.
    """
    parser = argparse.ArgumentParser()

    subparsers = parser.add_subparsers(
        help="mode of execution", dest="mode", required=True
    )
    tune_parser = subparsers.add_parser("tune")
    _ = subparsers.add_parser("sweep")

    # DUT
    parser.add_argument(
        "--design",
        type=str,
        metavar="<gcd,jpeg,ibex,aes,...>",
        required=True,
        help="Name of the design for Autotuning.",
    )
    parser.add_argument(
        "--platform",
        type=str,
        metavar="<sky130hd,sky130hs,asap7,...>",
        required=True,
        help="Name of the platform for Autotuning.",
    )

    # Experiment Setup
    parser.add_argument(
        "--config",
        type=str,
        metavar="<path>",
        required=True,
        help="Configuration file that sets which knobs to use for Autotuning.",
    )
    parser.add_argument(
        "--experiment",
        type=str,
        metavar="<str>",
        default="test",
        help="Experiment name. This parameter is used to prefix the"
        " FLOW_VARIANT and to set the Ray log destination.",
    )
    parser.add_argument(
        "--timeout",
        type=float,
        metavar="<float>",
        default=None,
        help="Time limit (in hours) for each trial run. Default is no limit.",
    )
    tune_parser.add_argument(
        "--resume", action="store_true", help="Resume previous run."
    )

    # Setup
    parser.add_argument(
        "--git_clean",
        action="store_true",
        help="Clean binaries and build files."
        " WARNING: may lose previous data."
        " Use carefully.",
    )
    parser.add_argument(
        "--git_clone",
        action="store_true",
        help="Force new git clone."
        " WARNING: may lose previous data."
        " Use carefully.",
    )
    parser.add_argument(
        "--git_clone_args",
        type=str,
        metavar="<str>",
        default="",
        help="Additional git clone arguments.",
    )
    parser.add_argument(
        "--git_latest", action="store_true", help="Use latest version of OpenROAD app."
    )
    parser.add_argument(
        "--git_or_branch",
        type=str,
        metavar="<str>",
        default="",
        help="OpenROAD app branch to use.",
    )
    parser.add_argument(
        "--git_orfs_branch",
        type=str,
        metavar="<str>",
        default="master",
        help="OpenROAD-flow-scripts branch to use.",
    )
    parser.add_argument(
        "--git_url",
        type=str,
        metavar="<url>",
        default=ORFS_URL,
        help="OpenROAD-flow-scripts repo URL to use.",
    )
    parser.add_argument(
        "--build_args",
        type=str,
        metavar="<str>",
        default="",
        help="Additional arguments given to ./build_openroad.sh.",
    )

    # ML
    tune_parser.add_argument(
        "--algorithm",
        type=str,
        choices=["hyperopt", "ax", "optuna", "pbt", "random"],
        default="hyperopt",
        help="Search algorithm to use for Autotuning.",
    )
    tune_parser.add_argument(
        "--eval",
        type=str,
        choices=["default", "ppa-improv"],
        default="default",
        help="Evaluate function to use with search algorithm.",
    )
    tune_parser.add_argument(
        "--samples",
        type=int,
        metavar="<int>",
        default=10,
        help="Number of samples for tuning.",
    )
    tune_parser.add_argument(
        "--iterations",
        type=int,
        metavar="<int>",
        default=1,
        help="Number of iterations for tuning.",
    )
    tune_parser.add_argument(
        "--resources_per_trial",
        type=int,
        metavar="<int>",
        default=1,
        help="Number of CPUs to request for each tunning job.",
    )
    tune_parser.add_argument(
        "--reference",
        type=str,
        metavar="<path>",
        default=None,
        help="Reference file for use with PPAImprov.",
    )
    tune_parser.add_argument(
        "--perturbation",
        type=int,
        metavar="<int>",
        default=25,
        help="Perturbation interval for PopulationBasedTraining.",
    )
    tune_parser.add_argument(
        "--seed",
        type=int,
        metavar="<int>",
        default=42,
        help="Random seed. (0 means no seed.)",
    )

    # Workload
    parser.add_argument(
        "--jobs",
        type=int,
        metavar="<int>",
        default=int(np.floor(cpu_count() / 2)),
        help="Max number of concurrent jobs.",
    )
    parser.add_argument(
        "--openroad_threads",
        type=int,
        metavar="<int>",
        default=16,
        help="Max number of threads openroad can use.",
    )
    parser.add_argument(
        "--server",
        type=str,
        metavar="<ip|servername>",
        default=None,
        help="The address of Ray server to connect.",
    )
    parser.add_argument(
        "--port",
        type=int,
        metavar="<int>",
        default=10001,
        help="The port of Ray server to connect.",
    )

    parser.add_argument(
        "-v",
        "--verbose",
        action="count",
        default=0,
        help="Verbosity level.\n\t0: only print Ray status\n\t1: also print"
        " training stderr\n\t2: also print training stdout.",
    )

    arguments = parser.parse_args()
    if arguments.mode == "tune":
        arguments.algorithm = arguments.algorithm.lower()
        # Validation of arguments
        if arguments.eval == "ppa-improv" and arguments.reference is None:
            print(
                '[ERROR TUN-0006] The argument "--eval ppa-improv"'
                ' requires that "--reference <FILE>" is also given.'
            )
            sys.exit(7)

    arguments.experiment += f"-{arguments.mode}-{DATE}"

    if arguments.timeout is not None:
        arguments.timeout = round(arguments.timeout * 3600)

    return arguments


def set_algorithm(experiment_name, config):
    """
    Configure search algorithm.
    """
    # Pre-set seed if user sets seed to 0
    if args.seed == 0:
        print(
            "Warning: you have chosen not to set a seed. Do you wish to continue? (y/n)"
        )
        if input().lower() != "y":
            sys.exit(0)
        args.seed = None
    else:
        torch.manual_seed(args.seed)
        np.random.seed(args.seed)
        random.seed(args.seed)

    if args.algorithm == "hyperopt":
        algorithm = HyperOptSearch(
            points_to_evaluate=best_params,
            random_state_seed=args.seed,
        )
    elif args.algorithm == "ax":
        ax_client = AxClient(
            enforce_sequential_optimization=False,
            random_seed=args.seed,
        )
        AxClientMetric = namedtuple("AxClientMetric", "minimize")
        ax_client.create_experiment(
            name=experiment_name,
            parameters=config,
            objectives={METRIC: AxClientMetric(minimize=True)},
        )
        algorithm = AxSearch(ax_client=ax_client, points_to_evaluate=best_params)
    elif args.algorithm == "optuna":
        algorithm = OptunaSearch(points_to_evaluate=best_params, seed=args.seed)
    elif args.algorithm == "pbt":
        print("Warning: PBT does not support seed values. args.seed will be ignored.")
        algorithm = PopulationBasedTraining(
            time_attr="training_iteration",
            perturbation_interval=args.perturbation,
            hyperparam_mutations=config,
            synch=True,
        )
    elif args.algorithm == "random":
        algorithm = BasicVariantGenerator(
            max_concurrent=args.jobs,
            random_state=args.seed,
        )

    # A wrapper algorithm for limiting the number of concurrent trials.
    if args.algorithm not in ["random", "pbt"]:
        algorithm = ConcurrencyLimiter(algorithm, max_concurrent=args.jobs)

    return algorithm


def set_best_params(platform, design):
    """
    Get current known best parameters if it exists.
    """
    params = []
    best_param_file = f"designs/{platform}/{design}/autotuner-best.json"
    if os.path.isfile(best_param_file):
        with open(best_param_file) as file:
            params = json.load(file)
    return params


def set_training_class(function):
    """
    Set training class.
    """
    if function == "default":
        return AutoTunerBase
    if function == "ppa-improv":
        return PPAImprov
    return None


@ray.remote
def save_best(results):
    """
    Save best configuration of parameters found.
    """
    best_config = results.best_config
    best_config["best_result"] = results.best_result[METRIC]
    trial_id = results.best_trial.trial_id
    new_best_path = f"{LOCAL_DIR}/{args.experiment}/"
    new_best_path += f"autotuner-best-{trial_id}.json"
    with open(new_best_path, "w") as new_best_file:
        json.dump(best_config, new_best_file, indent=4)
    print(f"[INFO TUN-0003] Best parameters written to {new_best_path}")


@ray.remote
def consumer(queue):
    """consumer"""
    while not queue.empty():
        next_item = queue.get()
        name = next_item[1]
        print(f"[INFO TUN-0007] Scheduling run for parameter {name}.")
        ray.get(openroad_distributed.remote(*next_item))
        print(f"[INFO TUN-0008] Finished run for parameter {name}.")


def sweep():
    """Run sweep of parameters"""
    if args.server is not None:
        # For remote sweep we create the following directory structure:
        #      1/     2/         3/       4/
        # <repo>/<logs>/<platform>/<design>/
        repo_dir = os.path.abspath(LOCAL_DIR + "/../" * 4)
    else:
        repo_dir = os.path.abspath("../")
    print(f"[INFO TUN-0012] Log folder {LOCAL_DIR}.")
    queue = Queue()
    parameter_list = list()
    for name, content in config_dict.items():
        if not isinstance(content, list):
            print(f"[ERROR TUN-0015] {name} sweep is not supported.")
            sys.exit(1)
        if content[-1] == 0:
            print("[ERROR TUN-0014] Sweep does not support step value zero.")
            sys.exit(1)
        parameter_list.append([{name: i} for i in np.arange(*content)])
    parameter_list = list(product(*parameter_list))
    for parameter in parameter_list:
        temp = dict()
        for value in parameter:
            temp.update(value)
        print(temp)
        queue.put([repo_dir, temp, LOCAL_DIR])
    workers = [consumer.remote(queue) for _ in range(args.jobs)]
    print("[INFO TUN-0009] Waiting for results.")
    ray.get(workers)
    print("[INFO TUN-0010] Sweep complete.")


if __name__ == "__main__":
    args = parse_arguments()

    # Read config and original files before handling where to run in case we
    # need to upload the files.
    config_dict, SDC_ORIGINAL, FR_ORIGINAL = read_config(os.path.abspath(args.config))

    # Connect to remote Ray server if any, otherwise will run locally
    if args.server is not None:
        # At GCP we have a NFS folder that is present for all worker nodes.
        # This allows to build required binaries once. We clone, build and
        # store intermediate files at LOCAL_DIR.
        with open(args.config) as config_file:
            LOCAL_DIR = "/shared-data/autotuner"
            LOCAL_DIR += f"-orfs-{args.git_orfs_branch}"
            if args.git_or_branch != "":
                LOCAL_DIR += f"-or-{args.git_or_branch}"
            if args.git_latest:
                LOCAL_DIR += "-or-latest"
        # Connect to ray server before first remote execution.
        ray.init(f"ray://{args.server}:{args.port}")
        # Remote functions return a task id and are non-blocking. Since we
        # need the setup repo before continuing, we call ray.get() to wait
        # for its completion.
        INSTALL_PATH = ray.get(setup_repo.remote(LOCAL_DIR))
        LOCAL_DIR += f"/flow/logs/{args.platform}/{args.design}"
        print("[INFO TUN-0001] NFS setup completed.")
    else:
        # For local runs, use the same folder as other ORFS utilities.
        ORFS_FLOW_DIR = os.path.abspath(
            os.path.join(os.path.dirname(__file__), "../../../../flow")
        )
        os.chdir(ORFS_FLOW_DIR)
        LOCAL_DIR = f"logs/{args.platform}/{args.design}"
        LOCAL_DIR = os.path.abspath(LOCAL_DIR)
        INSTALL_PATH = os.path.abspath("../tools/install")

    if args.mode == "tune":
        best_params = set_best_params(args.platform, args.design)
        search_algo = set_algorithm(args.experiment, config_dict)
        TrainClass = set_training_class(args.eval)
        # PPAImprov requires a reference file to compute training scores.
        if args.eval == "ppa-improv":
            reference = PPAImprov.read_metrics(args.reference)

        tune_args = dict(
            name=args.experiment,
            metric=METRIC,
            mode="min",
            num_samples=args.samples,
            fail_fast=False,
            local_dir=LOCAL_DIR,
            resume=args.resume,
            stop={"training_iteration": args.iterations},
            resources_per_trial={"cpu": args.resources_per_trial},
            log_to_file=["trail-out.log", "trail-err.log"],
            trial_name_creator=lambda x: f"variant-{x.trainable_name}-{x.trial_id}-ray",
            trial_dirname_creator=lambda x: f"variant-{x.trainable_name}-{x.trial_id}-ray",
        )
        if args.algorithm == "pbt":
            os.environ["TUNE_MAX_PENDING_TRIALS_PG"] = str(args.jobs)
            tune_args["scheduler"] = search_algo
        else:
            tune_args["search_alg"] = search_algo
            tune_args["scheduler"] = AsyncHyperBandScheduler()
        if args.algorithm != "ax":
            tune_args["config"] = config_dict
        analysis = tune.run(TrainClass, **tune_args)

        task_id = save_best.remote(analysis)
        _ = ray.get(task_id)
        print(f"[INFO TUN-0002] Best parameters found: {analysis.best_config}")

        # if all runs have failed
        if analysis.best_result["minimum"] == ERROR_METRIC:
            print("[ERROR TUN-0016] No successful runs found.")
            sys.exit(1)
    elif args.mode == "sweep":
        sweep()
