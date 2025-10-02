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

"""
This scripts handles sweeping and tuning of OpenROAD-flow-scripts parameters.
Dependencies are documented in pip format at distributed-requirements.txt

For both sweep and tune modes:
    openroad_autotuner -h

Note: the order of the parameters matter.
Arguments --design, --platform and --config are always required and should
precede the <mode>.

AutoTuner:
    openroad_autotuner tune -h
    openroad_autotuner --design gcd --platform sky130hd \
                           --config ../designs/sky130hd/gcd/autotuner.json \
                           tune
    Example:

Parameter sweeping:
    openroad_autotuner sweep -h
    Example:
    openroad_autotuner --design gcd --platform sky130hd \
                       --config distributed-sweep-example.json \
                       sweep
"""

import argparse
import json
import os
import sys
import random
from itertools import product
from uuid import uuid4 as uuid
from collections import namedtuple
from multiprocessing import cpu_count

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

from autotuner.utils import (
    openroad,
    consumer,
    parse_config,
    read_config,
    read_metrics,
    prepare_ray_server,
    CONSTRAINTS_SDC,
    FASTROUTE_TCL,
)

# Name of the final metric
METRIC = "metric"
# The worst of optimized metric
ERROR_METRIC = 9e99
# Path to the FLOW_HOME directory
ORFS_FLOW_DIR = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "../../../../flow")
)
# Global variable for args
args = None


class AutoTunerBase(tune.Trainable):
    """
    AutoTuner base class for experiments.
    """

    def setup(self, config):
        """
        Setup current experiment step.
        """
        # We create the following directory structure:
        #      1/     2/         3/       4/           5/
        # <repo>/<logs>/<platform>/<design>/<experiment/<cwd>
        self.repo_dir = os.path.abspath(LOCAL_DIR + "/../" * 4)
        self.parameters = parse_config(
            config=config,
            base_dir=self.repo_dir,
            platform=args.platform,
            sdc_original=SDC_ORIGINAL,
            constraints_sdc=CONSTRAINTS_SDC,
            fr_original=FR_ORIGINAL,
            fastroute_tcl=FASTROUTE_TCL,
            path=os.getcwd(),
        )
        self.step_ = 0
        self.variant = f"variant-{self.__class__.__name__}-{self.trial_id}-or"
        # Do a valid config check here, since we still have the config in a
        # dict vs. having to scan through the parameter string later
        self.is_valid_config = self._is_valid_config(config)

    def step(self):
        """
        Run step experiment and compute its score.
        """

        # if not a valid config, then don't run and pass back an error
        if not self.is_valid_config:
            return {METRIC: ERROR_METRIC, "effective_clk_period": "-", "num_drc": "-"}
        self._variant = f"{self.variant}-{self.step_}"
        metrics_file = openroad(
            args=args,
            base_dir=self.repo_dir,
            parameters=self.parameters,
            flow_variant=self._variant,
            install_path=INSTALL_PATH,
        )
        self.step_ += 1
        (score, effective_clk_period, num_drc, die_area) = self.evaluate(
            read_metrics(metrics_file, args.stop_stage)
        )
        # Feed the score back to Tune.
        # return must match 'metric' used in tune.run()
        return {
            METRIC: score,
            "effective_clk_period": effective_clk_period,
            "num_drc": num_drc,
            "die_area": die_area,
        }

    def evaluate(self, metrics):
        """
        User-defined evaluation function.
        It can change in any form to minimize the score (return value).
        Default evaluation function optimizes effective clock period.
        """
        error = "ERR" in metrics.values()
        not_found = "N/A" in metrics.values()
        if error or not_found:
            return (ERROR_METRIC, "-", "-", "-")
        effective_clk_period = metrics["clk_period"] - metrics["worst_slack"]
        num_drc = metrics["num_drc"]
        gamma = effective_clk_period / 10
        score = effective_clk_period
        score = score * (100 / self.step_) + gamma * num_drc
        return (score, effective_clk_period, num_drc, metrics["die_area"])

    def _is_valid_config(self, config):
        """
        Checks dependent parameters and returns False if we violate
        a dependency. That way, we don't end up running an incompatible run
        """

        ret_val = True
        ret_val &= self._is_valid_padding(config)
        return ret_val

    def _is_valid_padding(self, config):
        """Returns True if global padding >= detail padding"""

        if (
            "CELL_PAD_IN_SITES_GLOBAL_PLACEMENT" in config
            and "CELL_PAD_IN_SITES_DETAIL_PLACEMENT" in config
        ):
            global_padding = config["CELL_PAD_IN_SITES_GLOBAL_PLACEMENT"]
            detail_padding = config["CELL_PAD_IN_SITES_DETAIL_PLACEMENT"]
            if global_padding < detail_padding:
                print(
                    f"[WARN TUN-0032] CELL_PAD_IN_SITES_DETAIL_PLACEMENT ({detail_padding}) cannot be greater than CELL_PAD_IN_SITES_GLOBAL_PLACEMENT ({global_padding})"
                )
                return False
        return True


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
        if error or not_found:
            return (ERROR_METRIC, "-", "-", "-")
        ppa = self.get_ppa(metrics)
        gamma = ppa / 10
        score = ppa * (self.step_ / 100) ** (-1) + (gamma * metrics["num_drc"])
        effective_clk_period = metrics["clk_period"] - metrics["worst_slack"]
        num_drc = metrics["num_drc"]
        return (score, effective_clk_period, num_drc, metrics["die_area"])


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
    parser.add_argument(
        "--stop_stage",
        type=str,
        metavar="<str>",
        choices=["floorplan", "place", "cts", "globalroute", "route", "finish"],
        default="finish",
        help="Name of the stage to stop after. Default is finish.",
    )
    tune_parser.add_argument(
        "--resume",
        action="store_true",
        help="Resume previous run. Note that you must also set a unique experiment\
                name identifier via `--experiment NAME` to be able to resume.",
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
        type=float,
        metavar="<float>",
        default=1,
        help="Number of CPUs to request for each tuning job.",
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
        "--memory_limit",
        type=float,
        metavar="<float>",
        default=None,
        help="Maximum memory in GB that each trial job can use, process will be killed and not retried if it exceeds.",
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

    args = parser.parse_args()
    if args.mode == "tune":
        args.algorithm = args.algorithm.lower()
        # Validation of arguments
        if args.eval == "ppa-improv" and args.reference is None:
            print(
                '[ERROR TUN-0006] The argument "--eval ppa-improv"'
                ' requires that "--reference <FILE>" is also given.'
            )
            sys.exit(7)

        # Check for experiment name and resume flag.
        if args.resume and args.experiment == "test":
            print(
                '[ERROR TUN-0031] The flag "--resume"'
                ' requires that "--experiment NAME" is also given.'
            )
            sys.exit(1)

    # If the experiment name is the default, add a UUID to the end.
    if args.experiment == "test":
        id = str(uuid())[:8]
        args.experiment = f"{args.mode}-{id}"
    else:
        args.experiment += f"-{args.mode}"

    if args.timeout is not None:
        args.timeout = round(args.timeout * 3600)

    return args


def set_algorithm(
    algorithm_name, experiment_name, best_params, seed, perturbation, jobs, config
):
    """
    Configure search algorithm.
    """
    # Pre-set seed if user sets seed to 0
    if seed == 0:
        print(
            "Warning: you have chosen not to set a seed. Do you wish to continue? (y/n)"
        )
        if input().lower() != "y":
            sys.exit(0)
        seed = None
    else:
        torch.manual_seed(seed)
        np.random.seed(seed)
        random.seed(seed)

    if algorithm_name == "hyperopt":
        algorithm = HyperOptSearch(
            points_to_evaluate=best_params,
            random_state_seed=seed,
        )
    elif algorithm_name == "ax":
        ax_client = AxClient(
            enforce_sequential_optimization=False,
            random_seed=seed,
        )
        AxClientMetric = namedtuple("AxClientMetric", "minimize")
        ax_client.create_experiment(
            name=experiment_name,
            parameters=config,
            objectives={METRIC: AxClientMetric(minimize=True)},
        )
        algorithm = AxSearch(ax_client=ax_client, points_to_evaluate=best_params)
    elif algorithm_name == "optuna":
        algorithm = OptunaSearch(points_to_evaluate=best_params, seed=seed)
    elif algorithm_name == "pbt":
        print("Warning: PBT does not support seed values. seed will be ignored.")
        algorithm = PopulationBasedTraining(
            time_attr="training_iteration",
            perturbation_interval=perturbation,
            hyperparam_mutations=config,
            synch=True,
        )
    elif algorithm_name == "random":
        algorithm = BasicVariantGenerator(
            max_concurrent=jobs,
            random_state=seed,
        )

    # A wrapper algorithm for limiting the number of concurrent trials.
    if algorithm_name not in ["random", "pbt"]:
        algorithm = ConcurrencyLimiter(algorithm, max_concurrent=jobs)

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


def sweep():
    """Run sweep of parameters"""
    if args.server is not None:
        # For remote sweep we create the following directory structure:
        #      1/     2/         3/       4/
        # <repo>/<logs>/<platform>/<design>/
        repo_dir = os.path.abspath(LOCAL_DIR + "/../" * 4)
    else:
        repo_dir = os.path.abspath(os.path.join(ORFS_FLOW_DIR, ".."))
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
        queue.put([args, repo_dir, temp, SDC_ORIGINAL, FR_ORIGINAL, INSTALL_PATH])
    workers = [consumer.remote(queue) for _ in range(args.jobs)]
    print("[INFO TUN-0009] Waiting for results.")
    ray.get(workers)
    print("[INFO TUN-0010] Sweep complete.")


def main():
    global args, SDC_ORIGINAL, FR_ORIGINAL, LOCAL_DIR, INSTALL_PATH, ORFS_FLOW_DIR, config_dict, reference, best_params
    args = parse_arguments()

    # Read config and original files before handling where to run in case we
    # need to upload the files.
    config_dict, SDC_ORIGINAL, FR_ORIGINAL = read_config(
        os.path.abspath(args.config), args.mode, getattr(args, "algorithm", None)
    )

    LOCAL_DIR, ORFS_FLOW_DIR, INSTALL_PATH = prepare_ray_server(args)

    if args.mode == "tune":
        best_params = set_best_params(args.platform, args.design)
        search_algo = set_algorithm(
            args.algorithm,
            args.experiment,
            best_params,
            args.seed,
            args.perturbation,
            args.jobs,
            config_dict,
        )
        TrainClass = set_training_class(args.eval)
        # PPAImprov requires a reference file to compute training scores.
        if args.eval == "ppa-improv":
            reference = read_metrics(args.reference, args.stop_stage)

        tune_args = dict(
            name=args.experiment,
            metric=METRIC,
            mode="min",
            num_samples=args.samples,
            fail_fast=False,
            storage_path=LOCAL_DIR,
            resume=args.resume,
            stop={"training_iteration": args.iterations},
            resources_per_trial={"cpu": os.cpu_count() / args.jobs},
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
        if analysis.best_result[METRIC] == ERROR_METRIC:
            print("[ERROR TUN-0016] No successful runs found.")
            sys.exit(16)
    elif args.mode == "sweep":
        sweep()


if __name__ == "__main__":
    main()
