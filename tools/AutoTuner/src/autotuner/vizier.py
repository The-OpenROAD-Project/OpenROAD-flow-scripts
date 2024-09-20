import argparse
import json
import logging
import os
import sys
import time
import traceback
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime
from pathlib import Path
from tqdm import tqdm
from typing import Dict, Tuple

from utils import add_common_args, openroad, parse_config, read_config, read_metrics
from vizier import service
from vizier.service import clients, servers
from vizier.service import pyvizier as vz

ORFS = list(Path(__file__).absolute().parents)[4]
CONSTRAINTS_SDC = "constraint.sdc"
FASTROUTE_TCL = "fastroute.tcl"
METRIC_TO_GOAL = {
    "worst_slack": vz.ObjectiveMetricGoal.MAXIMIZE,
    "clk_period-worst_slack": vz.ObjectiveMetricGoal.MINIMIZE,
    "total_power": vz.ObjectiveMetricGoal.MINIMIZE,
    "core_util": vz.ObjectiveMetricGoal.MAXIMIZE,
    "final_util": vz.ObjectiveMetricGoal.MAXIMIZE,
    "design_area": vz.ObjectiveMetricGoal.MINIMIZE,
    "core_area": vz.ObjectiveMetricGoal.MINIMIZE,
    "die_area": vz.ObjectiveMetricGoal.MINIMIZE,
    "last_successful_stage": vz.ObjectiveMetricGoal.MAXIMIZE,
}
GOAL_TO_VALUE = {
    vz.ObjectiveMetricGoal.MINIMIZE: float("inf"),
    vz.ObjectiveMetricGoal.MAXIMIZE: float("-inf"),
}
MAP_SCALE_TYPE = {
    "linear": vz.ScaleType.LINEAR,
    "log": vz.ScaleType.LOG,
    "rlog": vz.ScaleType.REVERSE_LOG,
}
DATE = datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
LOG = logging.Logger(Path(__name__).with_suffix("").name)


def evaluate(
    args: argparse.Namespace,
    params: Dict,
    iteration: int,
    suggestion: int,
    install_path: Path,
) -> Tuple[Dict[str, float], str, float]:
    """
    Runs ORFS and calculates metrics.

    Parameters
    ----------
    args : argparse.Namespace
        Optimization arguments
    params : Dict
        Parameters to evaluate
    iteration : int
        Current iteration
    suggestion : int
        Current suggestion number
    install_path : Path
        Path to the folder with installed ORFS binaries

    Returns
    -------
    Tuple[Dict[str, float], str, float]
        Dictionary with metrics, name of variant and duration of ORFS run
    """
    variant = f"variant-{iteration}-{suggestion}"
    try:
        # Prepare ORFS options
        options = parse_config(
            params,
            args.platform,
            args.sdc_file,
            CONSTRAINTS_SDC,
            args.fr_file,
            FASTROUTE_TCL,
        )
        t = time.time()
        # Run flow
        metric_file = openroad(
            args,
            str(args.orfs),
            options,
            variant,
            path=f"logs/{args.platform}/{args.design}",
            install_path=str(install_path),
            stage=args.to_stage,
        )
        duration = time.time() - t
        metrics = read_metrics(metric_file, stage=args.to_stage)
        # Calculate difference of clock period and worst slack
        if metrics["clk_period"] != 9999999 and metrics["worst_slack"] != "ERR":
            metrics["clk_period-worst_slack"] = (
                metrics["clk_period"] - metrics["worst_slack"]
            )
        else:
            metrics["clk_period-worst_slack"] = "ERR"

        # Copy and normalize metrics
        results = {}
        for metric in args.use_metrics:
            value = metrics[metric]
            results[metric] = (
                float(value)
                if value != "ERR"
                else GOAL_TO_VALUE[METRIC_TO_GOAL[metric]]
            )
        if results["last_successful_stage"] <= 6 and results["core_util"] < float(
            "inf"
        ):
            # Invert core util, as for smaller values design should be easier to built
            results["core_util"] *= -1
        return results, variant, duration
    except Exception as ex:
        LOG.error(f"Exception during {args.design} {variant}: {ex}", file=sys.stderr)
        LOG.error("\n".join(traceback.format_tb(ex.__traceback__)), file=sys.stderr)
        results = {}
        for metric, goal in args.use_metrics:
            results[metric] = GOAL_TO_VALUE[METRIC_TO_GOAL[metric]]
        return results, variant, 0.0


def parallel_evaluate(tup: Tuple[argparse.Namespace, Dict, int, int]) -> Dict:
    """
    Wrapper for evaluate, run in thread pool.

    Parameters
    ----------
    tup : Tuple[argparse.Namespace, Dict, int, int]
        Tupled evaluate input

    Returns
    -------
    Dict
        Results of evaluation with additional data
    """
    args, suggestion, i, s, install_path = tup
    LOG.info(f"It {i} sug {s} params: {suggestion}")
    objective, variant, duration = evaluate(args, suggestion, i, s, install_path)
    LOG.info(f"It {i} sug {s} metric: {objective}")
    return {
        "iterations": i,
        "suggestion": s,
        "params": suggestion,
        "evaluation": objective,
        "variant": variant,
        "duration": duration,
    }


def register_param(
    args: argparse.Namespace, problem: vz.ProblemStatement, name: str, conf: Dict
):
    """
    Registers parameters in Vizier problem statement.

    Parameters
    ----------
    args : argparse.Namespace
        Optimization arguments
    problem : vz.ProblemStatement
        Vizier problem statement
    name : str
        Name of the parameter
    conf : Dict
        Parameter config
    """
    if conf["type"] == "fixed":
        problem.search_space.root.add_discrete_param(
            name,
            feasible_values=[conf["value"][0]],
        )
    else:
        map_func = {
            "float": problem.search_space.root.add_float_param,
            "int": problem.search_space.root.add_int_param,
        }
        map_func[conf.get("type", "float")](
            name,
            min_value=conf["value"][0],
            max_value=conf["value"][1],
            scale_type=MAP_SCALE_TYPE[conf.get("scale_type", "linear")],
        )


def main(
    args: argparse.Namespace,
    config: Dict,
    install_path: Path,
    server_endpoint: str = None,
) -> Dict:
    """
    Converts config to Vizier problem definition and runs optimization.

    Parameters
    ----------
    args : argparse.Namespace
        Optimization arguments
    config : Dict
        Optimization configuration
    install_path : Path
        Path to the folder with installed ORFS binaries
    server_endpoint : str
        URL pointing to Vizier server

    Returns
    -------
    Dict
        Results of optimization, containing 'config', 'population'
        and found 'optimals'
    """
    results = {"config": config, "populations": [], "optimals": []}

    problem = vz.ProblemStatement()
    for key, value in config.items():
        register_param(args, problem, key, value)
    for metric, goal in METRIC_TO_GOAL.items():
        problem.metric_information.append(vz.MetricInformation(metric, goal=goal))

    study_config = vz.StudyConfig.from_problem(problem)
    study_config.algorithm = args.algorithm

    # Vizier Client setup
    if server_endpoint:
        clients.environment_variables.server_endpoint = server_endpoint
    study_client = clients.Study.from_study_config(
        study_config, owner="owner", study_id=f"{args.experiment}-{args.design}"
    )

    state = study_client.materialize_state()
    start_iteration = 0
    # Check if experiment should be continued
    if state == vz.StudyState.COMPLETED or state == vz.StudyState.ABORTED:
        trials = list(study_client.trials().get())
        last_iteration = max(
            map(lambda x: int(x.metadata.get("iteration", -1)), trials)
        )
        start_iteration = last_iteration + 1
        if start_iteration <= args.iterations - 1:
            LOG.warn(f"Trying to restart experiment (previously {state})")
            study_client.set_state(vz.StudyState.ACTIVE)

    # Run iterations
    for i, s in zip(
        range(start_iteration, args.iterations), args.suggestions[start_iteration:]
    ):
        try:
            suggestions = study_client.suggest(count=s)
            with ThreadPoolExecutor(args.workers) as pool:
                population = pool.map(
                    parallel_evaluate,
                    [
                        (args, suggestion.parameters, i, s, install_path)
                        for s, suggestion in enumerate(suggestions)
                    ],
                )
                tqdm_population = tqdm(population)
                tqdm_population.set_description(f"Iteration {i}/{args.iterations}")
                for p in tqdm_population:
                    results["populations"].append(p)
                    final_measurement = vz.Measurement(p["evaluation"])
                    suggestions[p["suggestion"]].update_metadata(
                        vz.Metadata(
                            {
                                "variant": p["variant"],
                                "duration": str(p["duration"]),
                                "iteration": str(i),
                                "suggestion": str(s),
                            }
                        )
                    )
                    suggestions[p["suggestion"]].complete(final_measurement)
            LOG.info(f"Iteration {i} finished")
        except KeyboardInterrupt as ex:
            study_client.set_state(vz.StudyState.ABORTED)
            raise ex

    study_client.set_state(vz.StudyState.COMPLETED)

    for optimal_trial in study_client.optimal_trials():
        trial = optimal_trial.materialize()
        LOG.info(trial.parameters.as_dict())
        LOG.info(trial.final_measurement.metrics)
        results["optimals"].append(
            {
                "params": trial.parameters.as_dict(),
                "evaluation": {
                    k: v.value for k, v in trial.final_measurement.metrics.items()
                },
                "variant": f"{args.experiment}/{trial.metadata.get_or_error('variant')}",
                "time": float(trial.metadata.get_or_error("duration")),
            }
        )
    return results


def initialize_parser() -> argparse.ArgumentParser:
    """
    Creates parser with required arguments.

    Returns
    -------
    argparse.ArgumentParser
        Preared parser
    """
    parser = argparse.ArgumentParser()
    add_common_args(parser)
    parser.add_argument(
        "--experiment",
        type=str,
        metavar="<str>",
        default=f"test-{DATE}",
        help="Experiment name. This parameter is used to prefix the"
        " FLOW_VARIANT and as the Vizier study ID.",
    )
    parser.add_argument(
        "--orfs",
        type=Path,
        default=ORFS,
        help="Path to the OpenROAD-flow-scripts repository",
    )
    parser.add_argument(
        "--results",
        type=Path,
        default="results.json",
        help="Path where JSON file with results will be saved",
    )
    parser.add_argument(
        "-a",
        "--algorithm",
        type=str,
        choices=[
            "GAUSSIAN_PROCESS_BANDIT",
            "RANDOM_SEARCH",
            "QUASI_RANDOM_SEARCH",
            "GRID_SEARCH",
            "SHUFFLED_GRID_SEARCH",
            "NSGA2",
        ],
        help="Algorithm for the optimization engine",
        default="NSGA2",
    )
    available_metrics = list(METRIC_TO_GOAL.keys())
    parser.add_argument(
        "-m",
        "--use-metrics",
        nargs="+",
        choices=available_metrics,
        default=available_metrics,
        help="Metrics to optimize",
    )
    parser.add_argument(
        "-i",
        "--iterations",
        type=int,
        help="Max iteration count for the optimization engine",
        default=2,
    )
    parser.add_argument(
        "-s",
        "--suggestions",
        type=int,
        nargs="+",
        help="Suggestion count per iteration of the optimization engine",
        default=[5],
    )
    parser.add_argument(
        "-w",
        "--workers",
        default=2,
        help="Number of parallel workers",
        type=int,
    )
    vizier_server_args = parser.add_mutually_exclusive_group()
    vizier_server_args.add_argument(
        "--use-existing-server",
        type=str,
        help="Address of the running Vizier server",
        default=None,
    )
    start_server_args = vizier_server_args.add_argument_group("Local server")
    start_server_args.add_argument(
        "--server-host",
        type=str,
        help="Spawn Vizier server with given host",
        default=None,
    )
    start_server_args.add_argument(
        "--server-port",
        type=str,
        help="Spawn Vizier server with given port",
        default=None,
    )
    start_server_args.add_argument(
        "--server-db",
        type=str,
        help="Path to the Vizier server's database",
        default=None,
    )
    return parser


def run_vizier():
    """
    Entrypoint for Vizier optimization.

    Parses arguments and config, prepares Vizier server,
    runs optimization and saves the results.
    """
    parser = initialize_parser()
    args = parser.parse_args()

    LOG.setLevel([logging.ERROR, logging.WARN, logging.INFO][args.verbose])

    if args.algorithm == "GAUSSIAN_PROCESS_BANDIT" and any(
        s > 1 for s in args.suggestions
    ):
        LOG.error(
            "GAUSSIAN_PROCESS_BANDIT does not support batch operation, please set suggestions to 1"
        )
        exit(1)

    args.results = args.results.absolute()
    args.mode = "vizier"
    args.suggestions += [
        args.suggestions[-1] for _ in range(args.iterations - len(args.suggestions))
    ]
    if args.to_stage is None:
        args.to_stage = ""

    config, sdc_file, fr_file = read_config(args.config, "vizier", args.algorithm)
    args.sdc_file = sdc_file
    args.fr_file = fr_file

    orfs_flow_dir = str(args.orfs / "flow")
    os.chdir(orfs_flow_dir)
    install_path = Path("../tools/install").absolute()

    server_endpoint = None
    if args.server_host:
        # Start Vizier server
        server_database = args.server_db if args.server_db else service.SQL_LOCAL_URL
        server = servers.DefaultVizierServer(
            host=args.server_host, database_url=server_database, port=args.server_port
        )
        LOG.info(f"Started Vizier Server at: {server.endpoint}")
        LOG.info(f"SQL database file located at: {server._database_url}")
        server_endpoint = server.endpoint
    if args.use_existing_server:
        server_endpoint = args.use_existing_server

    results = main(args, config, install_path, server_endpoint)
    with args.results.open("w") as fd:
        json.dump(results, fd)
    print(f"Results saved to {args.results}")


if __name__ == "__main__":
    run_vizier()
