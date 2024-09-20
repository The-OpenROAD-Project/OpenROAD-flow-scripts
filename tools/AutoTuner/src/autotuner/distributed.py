"""
This scripts handles sweeping and tuning of OpenROAD-flow-scripts parameters.
Dependencies are documented in pip format at distributed-requirements.txt

For both sweep and tune modes:
    python3 -m distributed -h

Note: the order of the parameters matter.
Arguments --design, --platform and --config are always required and should
precede the <mode>.

AutoTuner:
    python3 -m distributed tune -h
    python3 -m distributed --design gcd --platform sky130hd \
                           --config ../designs/sky130hd/gcd/autotuner.json \
                           tune
    Example:

Parameter sweeping:
    python3 -m distributed sweep -h
    Example:
    python3 -m distributed --design gcd --platform sky130hd \
                           --config distributed-sweep-example.json \
                           sweep
"""

import argparse
import json
import os
import sys
from datetime import datetime
from multiprocessing import cpu_count
from itertools import product
from uuid import uuid4 as uuid

import numpy as np

import ray
from ray import tune
from ray.tune.schedulers import AsyncHyperBandScheduler
from ray.tune.schedulers import PopulationBasedTraining
from ray.tune.search import ConcurrencyLimiter
from ray.tune.search.ax import AxSearch
from ray.tune.search.basic_variant import BasicVariantGenerator
from ray.tune.search.hyperopt import HyperOptSearch

# from ray.tune.search.nevergrad import NevergradSearch
from ray.tune.search.optuna import OptunaSearch
from ray.util.queue import Queue

# import nevergrad as ng
from ax.service.ax_client import AxClient

from utils import (
    add_common_args,
    openroad,
    parse_config,
    read_config,
    read_metrics,
    run_command,
)

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
        self.parameters = parse_config(config, args.platform, SDC_ORIGINAL, CONSTRAINTS_SDC, FR_ORIGINAL, FASTROUTE_TCL, path=os.getcwd())
        self.step_ = 0
        self.variant = f"variant-{self.__class__.__name__}-{self.trial_id}-or"

    def step(self):
        """
        Run step experiment and compute its score.
        """
        metrics_file = openroad(args, self.repo_dir, self.parameters, self.variant, install_path=INSTALL_PATH, stage=args.to_stage)
        self.step_ += 1
        score = self.evaluate(read_metrics(metrics_file, args.to_stage))
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
        print("evaluate METRICS")
        print(metrics)
        if error or not_found:
            return ERROR_METRIC
        gamma = (metrics["clk_period"] - metrics["worst_slack"]) / 10
        score = metrics["clk_period"] - metrics["worst_slack"]
        score = score * (self.step_ / 100) ** (-1) + gamma * metrics["num_drc"]
        return score


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
        print("evaluate METRICS")
        print(metrics)
        if error or not_found:
            return ERROR_METRIC
        ppa = self.get_ppa(metrics)
        gamma = ppa / 10
        score = ppa * (self.step_ / 100) ** (-1) + (gamma * metrics["num_drc"])
        return score


@ray.remote
def openroad_distributed(repo_dir, config, path):
    """Simple wrapper to run openroad distributed with Ray."""
    config = parse_config(args, config, SDC_ORIGINAL, CONSTRAINTS_SDC, FR_ORIGINAL, FASTROUTE_TCL)
    openroad(args, repo_dir, config, str(uuid()), path=path, install_path=INSTALL_PATH, stage=args.to_stage)


def clone(path):
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
    run_command(args, build_command)


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

    add_common_args(parser)

    # Experiment Setup
    parser.add_argument(
        "--experiment",
        type=str,
        metavar="<str>",
        default="test",
        help="Experiment name. This parameter is used to prefix the"
        " FLOW_VARIANT and to set the Ray log destination.",
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
        choices=["hyperopt", "ax", "nevergrad", "optuna", "pbt", "random"],
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
        "--seed", type=int, metavar="<int>", default=42, help="Random seed."
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
    if args.algorithm == "hyperopt":
        algorithm = HyperOptSearch(points_to_evaluate=best_params)
    elif args.algorithm == "ax":
        ax_client = AxClient(enforce_sequential_optimization=False)
        ax_client.create_experiment(
            name=experiment_name,
            parameters=config,
            objective_name=METRIC,
            minimize=True,
        )
        algorithm = AxSearch(ax_client=ax_client, points_to_evaluate=best_params)
    elif args.algorithm == "nevergrad":
        algorithm = NevergradSearch(
            points_to_evaluate=best_params,
            optimizer=ng.optimizers.registry["PortfolioDiscreteOnePlusOne"],
        )
    elif args.algorithm == "optuna":
        algorithm = OptunaSearch(points_to_evaluate=best_params, seed=args.seed)
    elif args.algorithm == "pbt":
        algorithm = PopulationBasedTraining(
            time_attr="training_iteration",
            perturbation_interval=args.perturbation,
            hyperparam_mutations=config,
            synch=True,
        )
    elif args.algorithm == "random":
        algorithm = BasicVariantGenerator(max_concurrent=args.jobs)
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


if __name__=="__main__":
    args = parse_arguments()

    # Read config and original files before handling where to run in case we
    # need to upload the files.
    config_dict, SDC_ORIGINAL, FR_ORIGINAL = read_config(os.path.abspath(args.config), args.mode, args.algorithm)

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
            reference = read_metrics(args.reference, args.to_stage)

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
