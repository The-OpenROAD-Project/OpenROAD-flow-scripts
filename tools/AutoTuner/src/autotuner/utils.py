import argparse
import glob
import json
import os
import re
import subprocess
import sys
from multiprocessing import cpu_count
from datetime import datetime
from uuid import uuid4 as uuid
from time import time

import numpy as np
import ray

# Default scheme of a SDC constraints file
SDC_TEMPLATE = """
set clk_name  core_clock
set clk_port_name clk
set clk_period 2000
set clk_io_pct 0.2

set clk_port [get_ports $clk_port_name]

create_clock -name $clk_name -period $clk_period $clk_port

set non_clock_inputs [lsearch -inline -all -not -exact [all_inputs] $clk_port]

set_input_delay  [expr $clk_period * $clk_io_pct] -clock $clk_name $non_clock_inputs
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [all_outputs]
"""
# Maps ORFS stage to a name of produced metrics
STAGE_TO_METRICS = {
    "route": "detailedroute",
    "place": "detailedplace",
    "final": "finish",
}
# Name of the SDC file with constraints
CONSTRAINTS_SDC = "constraint.sdc"
# Name of the TCL script run before routing
FASTROUTE_TCL = "fastroute.tcl"
# URL to ORFS GitHub repository
ORFS_URL = "https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts"
DATE = datetime.now().strftime("%Y-%m-%d-%H-%M-%S")


def write_sdc(variables, path, sdc_original, constraints_sdc):
    """
    Create a SDC file with parameters for current tuning iteration.
    """
    # Handle case where the reference file does not exist
    if sdc_original == "":
        print("[ERROR TUN-0020] No SDC reference file provided.")
        sys.exit(1)
    new_file = sdc_original
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
        else:
            print(
                f"[WARN TUN-0025] {key} variable not supported in context of SDC files"
            )
            continue
    file_name = path + f"/{constraints_sdc}"
    with open(file_name, "w") as file:
        file.write(new_file)
    return file_name


def write_fast_route(variables, path, platform, fr_original, fastroute_tcl):
    """
    Create a FastRoute Tcl file with parameters for current tuning iteration.
    """
    # Handle case where the reference file does not exist (asap7 doesn't have reference)
    if fr_original == "" and platform != "asap7":
        print("[ERROR TUN-0021] No FastRoute Tcl reference file provided.")
        sys.exit(1)
    layer_cmd = "set_global_routing_layer_adjustment"
    new_file = fr_original
    # This is part of the defaults when no FASTROUTE_TCL is provided
    if len(new_file) == 0:
        new_file = "set_routing_layers -signal $::env(MIN_ROUTING_LAYER)-$::env(MAX_ROUTING_LAYER)"
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
        else:
            print(
                f"[WARN TUN-0028] {key} variable not supported in context of FastRoute TCL files"
            )
            continue
    file_name = path + f"/{fastroute_tcl}"
    with open(file_name, "w") as file:
        file.write(new_file)
    return file_name


def parse_flow_variables(base_dir, platform):
    """
    Parse the flow variables from source
    - Code: Makefile `vars` target output

    TODO: Tests.

    Output:
    - flow_variables: set of flow variables
    """
    # first, generate vars.tcl
    makefile_path = os.path.join(base_dir, "flow")
    result = subprocess.run(
        ["make", "-C", makefile_path, "vars", f"PLATFORM={platform}"],
        capture_output=True,
    )
    if result.returncode != 0:
        print(f"[ERROR TUN-0018] Makefile failed with error code {result.returncode}.")
        sys.exit(1)
    if not os.path.exists(os.path.join(makefile_path, "vars.tcl")):
        print("[ERROR TUN-0019] Makefile did not generate vars.tcl.")
        sys.exit(1)

    # for code parsing, you need to parse from both scripts and vars.tcl file.
    pattern = r"(?:::)?env\((.*?)\)"
    files = glob.glob(os.path.join(makefile_path, "scripts/*.tcl"))
    files.append(os.path.join(makefile_path, "vars.tcl"))
    variables = set()
    for file in files:
        with open(file) as fp:
            matches = re.findall(pattern, fp.read())
        for match in matches:
            for variable in match.split("\n"):
                variables.add(variable.strip().upper())
    return variables


def parse_config(
    config,
    base_dir,
    platform,
    sdc_original,
    constraints_sdc,
    fr_original,
    fastroute_tcl,
    path=os.getcwd(),
):
    """
    Parse configuration received from tune into make variables.
    """
    options = ""
    sdc = {}
    fast_route = {}
    # flow_variables = parse_flow_variables(base_dir, platform)
    for key, value in config.items():
        # Keys that begin with underscore need special handling.
        if key.startswith("_"):
            # Variables to be injected into fastroute.tcl
            if key.startswith("_FR_"):
                fast_route[key[4:]] = value
            # Variables to be injected into constraints.sdc
            elif key.startswith("_SDC_"):
                sdc[key[5:]] = value
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
            # Sanity check: ignore all flow variables that are not tunable
            # if key not in flow_variables:
            #     print(f"[ERROR TUN-0017] Variable {key} is not tunable.")
            #     sys.exit(1)
            options += f" {key}={value}"
    if sdc:
        write_sdc(sdc, path, sdc_original, constraints_sdc)
        options += f" SDC_FILE={path}/{constraints_sdc}"
    if fast_route:
        write_fast_route(fast_route, path, platform, fr_original, fastroute_tcl)
        options += f" FASTROUTE_TCL={path}/{fastroute_tcl}"
    return options


def run_command(
    args, cmd, timeout=None, stderr_file=None, stdout_file=None, fail_fast=False
):
    """
    Wrapper for subprocess.run
    Allows to run shell command, control print and exceptions.
    """
    process = subprocess.run(
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


def openroad(
    args,
    base_dir,
    parameters,
    flow_variant,
    path="",
    install_path=None,
    stage="",
):
    """
    Run OpenROAD-flow-scripts with a given set of parameters.
    """
    # Make sure path ends in a slash, i.e., is a folder
    flow_variant = f"{args.experiment}/{flow_variant}"
    if path != "":
        log_path = f"{path}/{flow_variant}/"
        report_path = log_path.replace("logs", "reports")
        run_command(args, f"mkdir -p {log_path}")
        run_command(args, f"mkdir -p {report_path}")
    else:
        log_path = report_path = os.getcwd() + "/"

    if install_path is None:
        install_path = os.path.join(base_dir, "tools/install")

    export_command = f"export PATH={install_path}/OpenROAD/bin"
    export_command += f":{install_path}/yosys/bin:$PATH"
    export_command += " && "

    make_command = export_command
    make_command += f"make -C {base_dir}/flow DESIGN_CONFIG=designs/"
    make_command += f"{args.platform}/{args.design}/config.mk {stage}"
    make_command += f" PLATFORM={args.platform}"
    make_command += f" FLOW_VARIANT={flow_variant} {parameters}"
    make_command += " EQUIVALENCE_CHECK=0"
    make_command += f" NUM_CORES={args.openroad_threads} SHELL=bash"
    run_command(
        args,
        make_command,
        timeout=args.timeout,
        stderr_file=f"{log_path}error-make-finish.log",
        stdout_file=f"{log_path}make-finish-stdout.log",
    )

    metrics_file = os.path.abspath(os.path.join(report_path, "metrics.json"))
    metrics_command = export_command
    metrics_command += f"{base_dir}/flow/util/genMetrics.py -x"
    metrics_command += f" -v {flow_variant}"
    metrics_command += f" -d {args.design}"
    metrics_command += f" -p {args.platform}"
    metrics_command += f" -o {metrics_file}"
    run_command(
        args,
        metrics_command,
        stderr_file=f"{log_path}error-metrics.log",
        stdout_file=f"{log_path}metrics-stdout.log",
    )

    return metrics_file


STAGES = list(
    enumerate(
        [
            "synth",
            "floorplan",
            "floorplan_io",
            "floorplan_tdms",
            "floorplan_macro",
            "floorplan_tap",
            "floorplan_pdn",
            "globalplace",
            "detailedplace",
            "cts",
            "globalroute",
            "detailedroute",
            "finish",
        ]
    )
)


def read_metrics(file_name, stage=""):
    """
    Collects metrics to evaluate the user-defined objective function.
    """
    metric_name = STAGE_TO_METRICS.get(stage if stage else "final", stage)
    with open(file_name) as file:
        data = json.load(file)
    clk_period = 9999999
    worst_slack = "ERR"
    wirelength = "ERR"
    num_drc = "ERR"
    total_power = "ERR"
    core_util = "ERR"
    final_util = "ERR"
    design_area = "ERR"
    die_area = "ERR"
    core_area = "ERR"
    last_stage = -1
    for stage_name, value in data.items():
        if stage_name == "constraints" and len(value["clocks__details"]) > 0:
            clk_period = float(value["clocks__details"][0].split()[1])
        if stage_name == "floorplan" and "design__instance__utilization" in value:
            core_util = value["design__instance__utilization"]
        if stage_name == "detailedroute" and "route__drc_errors" in value:
            num_drc = value["route__drc_errors"]
        if stage_name == "detailedroute" and "route__wirelength" in value:
            wirelength = value["route__wirelength"]
        if stage_name == metric_name and "timing__setup__ws" in value:
            worst_slack = value["timing__setup__ws"]
        if stage_name == metric_name and "power__total" in value:
            total_power = value["power__total"]
        if stage_name == metric_name and "design__instance__utilization" in value:
            final_util = value["design__instance__utilization"]
        if stage_name == metric_name and "design__instance__area" in value:
            design_area = value["design__instance__area"]
        if stage_name == metric_name and "design__core__area" in value:
            core_area = value["design__core__area"]
        if stage_name == metric_name and "design__die__area" in value:
            die_area = value["design__die__area"]
    for i, stage_name in reversed(STAGES):
        if stage_name in data and [d for d in data[stage_name].values() if d != "ERR"]:
            last_stage = i
            break
    ret = {
        "clk_period": clk_period,
        "worst_slack": worst_slack,
        "total_power": total_power,
        "core_util": core_util,
        "final_util": final_util,
        "design_area": design_area,
        "core_area": core_area,
        "die_area": die_area,
        "last_successful_stage": last_stage,
    } | (
        {
            "wirelength": wirelength,
            "num_drc": num_drc,
        }
        if metric_name in ("detailedroute", "finish")
        else {}
    )
    return ret


def read_config(file_name, mode, algorithm):
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
        from ray import tune
        import random

        # TODO: tune.sample_from only supports random search algorithm.
        # To make conditional parameter for the other algorithms, different
        # algorithms should take different methods (will be added)
        if algorithm != "random":
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
        from ray import tune

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
        from ray import tune

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
        from ray import tune

        if "minmax" not in this:
            return None
        min_, max_ = this["minmax"]
        if min_ == max_:
            return tune.choice([min_, max_])
        if this["type"] == "int":
            return tune.randint(min_, max_)
        if this["type"] == "float":
            return tune.uniform(min_, max_)

    def read_vizier(this):
        dict_ = {}
        min_, max_ = this["minmax"]
        dict_["value"] = (min_, max_)
        if "scale_type" in this:
            dict_["scale_type"] = this["scale_type"]
        if min_ == max_:
            dict_["type"] = "fixed"
        elif this["type"] == "int":
            dict_["type"] = "int"
        elif this["type"] == "float":
            dict_["type"] = "float"
        return dict_

    # Check file exists and whether it is a valid JSON file.
    assert os.path.isfile(file_name), f"File {file_name} not found."
    try:
        with open(file_name) as file:
            data = json.load(file)
    except json.JSONDecodeError:
        raise ValueError(f"Invalid JSON file: {file_name}")
    sdc_file = ""
    fr_file = ""
    if mode == "tune" and algorithm == "ax":
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
            if mode == "tune" and algorithm == "ax":
                param_dict = read_tune_ax(key, value)
                if param_dict:
                    config.append(param_dict)
            elif mode == "tune" and algorithm == "pbt":
                param_dict = read_tune_pbt(key, value)
                if param_dict:
                    config[key] = param_dict
            else:
                config[key] = value
        elif mode == "sweep":
            config[key] = read_sweep(value)
        elif mode == "tune" and algorithm == "ax":
            config.append(read_tune_ax(key, value))
        elif mode == "tune" and algorithm == "pbt":
            config[key] = read_tune_pbt(key, value)
        elif mode == "tune":
            config[key] = read_tune(value)
        elif mode == "vizier":
            config[key] = read_vizier(value)
    if mode == "tune":
        config = apply_condition(config, data)
    return config, sdc_file, fr_file


def clone(args, path):
    """
    Clone base repo in the remote machine. Only used for Kubernetes at GCP.
    """
    if args.git_clone:
        run_command(args, f"rm -rf {path}")
    if not os.path.isdir(f"{path}/.git"):
        git_command = "git clone --depth 1 --recursive --single-branch"
        git_command += f" {args.git_clone_args}"
        git_command += f" --branch {args.git_orfs_branch}"
        git_command += f" {args.git_url} {path}"
        run_command(args, git_command)


def build(args, base, install):
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
    run_command(args, build_command)


@ray.remote
def setup_repo(args, base):
    """
    Clone ORFS repository and compile binaries.
    """
    print(f"[INFO TUN-0000] Remote folder: {base}")
    install = f"{base}/tools/install"
    if args.server is not None:
        clone(base)
    build(base, install)
    return install


def prepare_ray_server(args):
    """
    Prepares Ray server and returns basic directories.
    """
    # Connect to remote Ray server if any, otherwise will run locally
    if args.server is not None:
        # At GCP we have a NFS folder that is present for all worker nodes.
        # This allows to build required binaries once. We clone, build and
        # store intermediate files at LOCAL_DIR.
        with open(args.config) as config_file:
            local_dir = "/shared-data/autotuner"
            local_dir += f"-orfs-{args.git_orfs_branch}"
            if args.git_or_branch != "":
                local_dir += f"-or-{args.git_or_branch}"
            if args.git_latest:
                local_dir += "-or-latest"
        # Connect to ray server before first remote execution.
        ray.init(f"ray://{args.server}:{args.port}")
        # Remote functions return a task id and are non-blocking. Since we
        # need the setup repo before continuing, we call ray.get() to wait
        # for its completion.
        install_path = ray.get(setup_repo.remote(local_dir))
        orfs_flow_dir = os.path.join(local_dir, "flow")
        local_dir += f"/flow/logs/{args.platform}/{args.design}"
        print("[INFO TUN-0001] NFS setup completed.")
    else:
        orfs_dir = getattr(args, "orfs", None)
        # For local runs, use the same folder as other ORFS utilities.
        orfs_flow_dir = os.path.abspath(
            os.path.join(orfs_dir, "flow")
            if orfs_dir
            else os.path.join(os.path.dirname(__file__), "../../../../flow")
        )
        local_dir = f"logs/{args.platform}/{args.design}"
        local_dir = os.path.join(orfs_flow_dir, local_dir)
        install_path = os.path.abspath(os.path.join(orfs_flow_dir, "../tools/install"))
    return local_dir, orfs_flow_dir, install_path


@ray.remote
def openroad_distributed(
    args,
    repo_dir,
    config,
    path,
    sdc_original,
    fr_original,
    install_path,
    variant=None,
):
    """Simple wrapper to run openroad distributed with Ray."""
    config = parse_config(
        config=config,
        base_dir=repo_dir,
        platform=args.platform,
        sdc_original=sdc_original,
        constraints_sdc=CONSTRAINTS_SDC,
        fr_original=fr_original,
        fastroute_tcl=FASTROUTE_TCL,
    )
    if variant is None:
        variant = config.replace(" ", "_").replace("=", "_")
    t = time()
    metric_file = openroad(
        args=args,
        base_dir=repo_dir,
        parameters=config,
        flow_variant=f"{uuid()}-{variant}",
        path=path,
        install_path=install_path,
        stage=args.to_stage,
    )
    duration = time() - t
    return metric_file, duration


@ray.remote
def consumer(queue):
    """consumer"""
    while not queue.empty():
        next_item = queue.get()
        name = next_item[1]
        print(f"[INFO TUN-0007] Scheduling run for parameter {name}.")
        ray.get(openroad_distributed.remote(*next_item))
        print(f"[INFO TUN-0008] Finished run for parameter {name}.")


def add_common_args(parser: argparse.ArgumentParser):
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
        "--to-stage",
        type=str,
        choices=("floorplan", "place", "cts", "route", "finish"),
        default="",
        help="Run ORFS only to the given stage (inclusive)",
    )
    parser.add_argument(
        "--timeout",
        type=float,
        metavar="<float>",
        default=None,
        help="Time limit (in hours) for each trial run. Default is no limit.",
    )
    # Workload
    parser.add_argument(
        "--openroad_threads",
        type=int,
        metavar="<int>",
        default=16,
        help="Max number of threads openroad can use.",
    )
    parser.add_argument(
        "-v",
        "--verbose",
        action="count",
        default=0,
        help="Verbosity level.\n\t0: only print status\n\t1: also print"
        " training stderr\n\t2: also print training stdout.",
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

    # Workload
    parser.add_argument(
        "--jobs",
        type=int,
        metavar="<int>",
        default=int(np.floor(cpu_count() / 2)),
        help="Max number of concurrent jobs.",
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
