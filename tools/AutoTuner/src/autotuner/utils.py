#############################################################################
##
## BSD 3-Clause License
##
## Copyright (c) 2019, The Regents of the University of California
## All rights reserved.
##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions are met:
##
## * Redistributions of source code must retain the above copyright notice, this
##   list of conditions and the following disclaimer.
##
## * Redistributions in binary form must reproduce the above copyright notice,
##   this list of conditions and the following disclaimer in the documentation
##   and/or other materials provided with the distribution.
##
## * Neither the name of the copyright holder nor the names of its
##   contributors may be used to endorse or promote products derived from
##   this software without specific prior written permission.
##
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
## AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
## IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
## ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
## LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
## CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
## SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
## INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
## CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
## ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
## POSSIBILITY OF SUCH DAMAGE.
##
###############################################################################

import glob
import json
import os
import re
import yaml
import subprocess
import sys
import uuid
import time
from multiprocessing import cpu_count
from datetime import datetime

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
# Name of the SDC file with constraints
CONSTRAINTS_SDC = "constraint.sdc"
# Name of the TCL script run before routing
FASTROUTE_TCL = "fastroute.tcl"
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


def parse_tunable_variables():
    """
    Parse the tunable variables from variables.yaml
    TODO: Tests.
    """
    cur_path = os.path.dirname(os.path.realpath(__file__))
    vars_path = os.path.join(cur_path, "../../../../flow/scripts/variables.yaml")

    # Read from variables.yaml and get variables with tunable = 1
    with open(vars_path) as file:
        result = yaml.safe_load(file)
    variables = {key for key, value in result.items() if value.get("tunable", 0) == 1}
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
    flow_variables = parse_tunable_variables()
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
            if key not in flow_variables:
                print(f"[ERROR TUN-0017] Variable {key} is not tunable.")
                sys.exit(1)
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
    install_path=None,
):
    """
    Run OpenROAD-flow-scripts with a given set of parameters.
    """
    # Make sure path ends in a slash, i.e., is a folder
    flow_variant = f"{args.experiment}/{flow_variant}"
    log_path = os.path.abspath(
        os.path.join(base_dir, f"flow/logs/{args.platform}/{args.design}", flow_variant)
    )
    report_path = os.path.abspath(
        os.path.join(
            base_dir, f"flow/reports/{args.platform}/{args.design}", flow_variant
        )
    )
    results_path = os.path.abspath(
        os.path.join(
            base_dir, f"flow/results/{args.platform}/{args.design}", flow_variant
        )
    )
    os.makedirs(log_path, exist_ok=True)
    os.makedirs(report_path, exist_ok=True)
    os.makedirs(results_path, exist_ok=True)

    if install_path is None:
        install_path = os.path.join(base_dir, "tools/install")

    export_command = f"export PATH={install_path}/OpenROAD/bin"
    export_command += f":{install_path}/yosys/bin:$PATH"
    export_command += " && "

    make_command = export_command
    if args.memory_limit is not None:
        limit = int(args.memory_limit * 1_000_000)
        make_command += f"ulimit -v {limit}; "
    make_command += f"make -C {base_dir}/flow DESIGN_CONFIG=designs/"
    make_command += f"{args.platform}/{args.design}/config.mk"
    make_command += f" PLATFORM={args.platform}"
    make_command += f" FLOW_VARIANT={flow_variant} {parameters}"
    make_command += " EQUIVALENCE_CHECK=0"
    make_command += f" NUM_CORES={args.openroad_threads} SHELL=bash"
    if args.stop_stage != "finish":
        make_command += f" {args.stop_stage}"
    run_command(
        args,
        make_command,
        timeout=args.timeout,
        stderr_file=os.path.join(log_path, "error-make-finish.log"),
        stdout_file=os.path.join(log_path, "make-finish-stdout.log"),
    )

    metrics_file = os.path.abspath(os.path.join(log_path, "metrics.json"))
    metrics_command = export_command
    metrics_command += f"{base_dir}/flow/util/genMetrics.py -x"
    metrics_command += f" -v {flow_variant}"
    metrics_command += f" -d {args.design}"
    metrics_command += f" -p {args.platform}"
    metrics_command += f" --logs {log_path}"
    metrics_command += f" --reports {report_path}"
    metrics_command += f" --results {results_path}"
    metrics_command += f" -o {metrics_file}"
    run_command(
        args,
        metrics_command,
        stderr_file=os.path.join(log_path, "error-metrics.log"),
        stdout_file=os.path.join(log_path, "metrics-stdout.log"),
    )

    return metrics_file


def read_metrics(file_name, stop_stage):
    """
    Collects metrics to evaluate the user-defined objective function.

    stop_stage indicates the last stage executed, so get most of the metrics
    from that stage. The default stop stage is "finish". But if the run stops
    before "finish", then no need to extract the metrics from the route stage,
    so set them to 0
    """
    with open(file_name) as file:
        data = json.load(file)
    clk_period = 9999999
    worst_slack = "ERR"
    total_power = "ERR"
    core_util = "ERR"
    final_util = "ERR"
    design_area = "ERR"
    die_area = "ERR"
    core_area = "ERR"
    if stop_stage != "finish":
        num_drc = wirelength = 0
    else:
        num_drc = wirelength = "ERR"
    for stage_name, value in data.items():
        if stage_name == "constraints" and len(value["clocks__details"]) > 0:
            clk_period = float(value["clocks__details"][0].split()[1])
        if stage_name == "floorplan" and "design__instance__utilization" in value:
            core_util = value["design__instance__utilization"]
        if stage_name == "detailedroute" and "route__drc_errors" in value:
            num_drc = value["route__drc_errors"]
        if stage_name == "detailedroute" and "route__wirelength" in value:
            wirelength = value["route__wirelength"]
        if stage_name == stop_stage and "timing__setup__ws" in value:
            worst_slack = value["timing__setup__ws"]
        if stage_name == stop_stage and "power__total" in value:
            total_power = value["power__total"]
        if stage_name == stop_stage and "design__instance__utilization" in value:
            final_util = value["design__instance__utilization"]
        if stage_name == stop_stage and "design__instance__area" in value:
            design_area = value["design__instance__area"]
        if stage_name == stop_stage and "design__core__area" in value:
            core_area = value["design__core__area"]
        if stage_name == stop_stage and "design__die__area" in value:
            die_area = value["design__die__area"]
    ret = {
        "clk_period": clk_period,
        "worst_slack": worst_slack,
        "total_power": total_power,
        "core_util": core_util,
        "final_util": final_util,
        "design_area": design_area,
        "core_area": core_area,
        "die_area": die_area,
        "wirelength": wirelength,
        "num_drc": num_drc,
    }
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
        if "CELL_PAD_IN_SITES_DETAIL_PLACEMENT" in data:
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

        if "minmax" in this:
            min_, max_ = this["minmax"]
            if min_ == max_:
                # Returning a choice of a single element allow pbt algorithm to
                # work. pbt does not accept single values as tunable.
                return tune.choice([min_, max_])
            if this["type"] == "int":
                if this["step"] == 1:
                    return tune.randint(min_, max_)
                return tune.choice(
                    np.ndarray.tolist(np.arange(min_, max_, this["step"]))
                )
            if this["type"] == "float":
                if this["step"] == 0:
                    return tune.uniform(min_, max_)
                return tune.choice(
                    np.ndarray.tolist(np.arange(min_, max_, this["step"]))
                )
        if this["type"] == "string":
            return tune.choice(this["values"])
        return None

    def read_tune_ax(name, this):
        """
        Ax format: https://ax.dev/versions/0.3.7/api/service.html
        """
        from ray import tune

        dict_ = dict(name=name)
        if "minmax" in this:
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
        if "values" in this:
            dict_["type"] = "choice"
            dict_["values"] = this["values"]
            if this["type"] == "string":
                dict_["value_type"] = "str"
            else:
                dict_["value_type"] = this["type"]
            return dict_
        return None

    def read_tune_pbt(name, this):
        """
        PBT format: https://docs.ray.io/en/releases-2.9.3/tune/examples/pbt_guide.html
        Note that PBT does not support step values.
        """
        from ray import tune

        if "minmax" in this:
            min_, max_ = this["minmax"]
            if min_ == max_:
                return tune.choice([min_, max_])
            if this["type"] == "int":
                return tune.randint(min_, max_)
            if this["type"] == "float":
                return tune.uniform(min_, max_)
        if "values" in this:
            return tune.choice(this["values"])
        return None

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
    if mode == "tune":
        config = apply_condition(config, data)
    return config, sdc_file, fr_file


def prepare_ray_server(args):
    """
    Prepares Ray server and returns basic directories.
    """
    # Connect to remote Ray server if any, otherwise will run locally
    if args.server is not None:
        # Connect to ray server before first remote execution.
        ray.init(f"ray://{args.server}:{args.port}")
        print("[INFO TUN-0001] Connected to Ray server.")
    # Common variables used for local and remote runs.
    orfs_dir = getattr(args, "orfs", None)
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
    t = time.time()
    metric_file = openroad(
        args=args,
        base_dir=repo_dir,
        parameters=config,
        flow_variant=f"{uuid.uuid4()}-{variant}" if variant else f"{uuid.uuid4()}",
        install_path=install_path,
    )
    duration = time.time() - t
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
