import argparse
import json
import sys
import traceback
from pathlib import Path
from typing import Dict

import ray
from tqdm import tqdm
from vizier import service
from vizier.service import clients, servers
from vizier.service import pyvizier as vz

from autotuner.utils import (
    DATE,
    add_common_args,
    openroad_distributed,
    read_config,
    read_metrics,
    prepare_ray_server,
)

# Path to the ORFS base directory
ORFS = list(Path(__file__).absolute().parents)[4]
# Maps metrics to a goal (min or max)
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
# Maps goal to a worst value
GOAL_TO_VALUE = {
    vz.ObjectiveMetricGoal.MINIMIZE: float("inf"),
    vz.ObjectiveMetricGoal.MAXIMIZE: float("-inf"),
}
# Maps string to Vizier ScaleType
MAP_SCALE_TYPE = {
    "linear": vz.ScaleType.LINEAR,
    "log": vz.ScaleType.LOG,
    "rlog": vz.ScaleType.REVERSE_LOG,
}


def evaluate(args: argparse.Namespace, metric_file: str) -> Dict[str, float]:
    """
    Runs ORFS and calculates metrics.

    Parameters
    ----------
    args : argparse.Namespace
        Optimization arguments
    metric_file : str
        Path to the file with metrics

    Returns
    -------
    Dict[str, float]
        Dictionary with metrics
    """
    try:
        metrics = read_metrics(metric_file)
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
        return results
    except Exception as ex:
        print(
            f"[ERROR TUN-0023] Exception during metrics processing {args.design}: {ex}",
            file=sys.stderr,
        )
        print("\n".join(traceback.format_tb(ex.__traceback__)), file=sys.stderr)
        results = {}
        for metric, goal in args.use_metrics:
            results[metric] = GOAL_TO_VALUE[METRIC_TO_GOAL[metric]]
        return results


@ray.remote
def parallel_evaluate(
    args: argparse.Namespace,
    suggestion: Dict,
    i: int,
    s: int,
    install_path: Path,
) -> Dict:
    """
    Wrapper for evaluate, run in thread pool.

    Parameters
    ----------
    args : argparse.Namespace
        Optimization arguments
    suggestion : Dict
    i : int
        Number of iteration
    s : int
        Number of suggestion
    install_path : Path
        Path to the install directory with ORFS binaries

    Returns
    -------
    Dict
        Results of evaluation with additional data
    """
    variant = f"variant-{i}-{s}"
    metric_file, duration = ray.get(
        openroad_distributed.remote(
            args=args,
            repo_dir=str(args.orfs),
            config=suggestion,
            path=f"logs/{args.platform}/{args.design}",
            sdc_original=args.sdc_file,
            fr_original=args.fr_file,
            install_path=str(install_path),
            variant=variant,
        )
    )
    objective = evaluate(args, metric_file)
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


def cast_params(params: Dict, config: Dict) -> Dict:
    """
    Cast params to integer according to configuration.

    Parameters
    ----------
    params : Dict
        Dictionary with suggested parameters
    config : Dict
        Provided configuration with types

    Returns
    -------
    Dict
        Updated parameters
    """
    for key, value in params.items():
        if config[key]["type"] == "int":
            params[key] = int(value)
    return params


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
        if isinstance(value, Dict):
            register_param(args, problem, key, value)
    for metric in args.use_metrics:
        problem.metric_information.append(
            vz.MetricInformation(metric, goal=METRIC_TO_GOAL[metric])
        )

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
            print(f"[WARN TUN-0026] Trying to restart experiment (previously {state})")
            study_client.set_state(vz.StudyState.ACTIVE)

    # Run iterations
    for i, s in zip(
        range(start_iteration, args.iterations), args.suggestions[start_iteration:]
    ):
        try:
            suggestions = study_client.suggest(count=s)
            unfinished = [
                parallel_evaluate.remote(
                    args,
                    cast_params(suggestion.parameters, config),
                    i,
                    s_i,
                    install_path,
                )
                for s_i, suggestion in enumerate(suggestions)
            ]
            # Setup tqdm
            print("\n")  # Prepare space for additional info
            tqdm_population = tqdm(total=s)
            tqdm_population.set_description(f"Iteration {i + 1}/{args.iterations}")
            while unfinished:
                finished, unfinished = ray.wait(unfinished, num_returns=1)
                sample = ray.get(finished)[0]
                print(sample)
                results["populations"].append(sample)
                final_measurement = vz.Measurement(sample["evaluation"])
                process_suggestion = suggestions[sample["suggestion"]]
                process_suggestion.update_metadata(
                    vz.Metadata(
                        {
                            "variant": sample["variant"],
                            "duration": str(sample["duration"]),
                            "iteration": str(i),
                            "suggestion": str(s),
                        }
                    )
                )
                # Display suggestion's parameters and evaluations
                tqdm_population.display(
                    f"[INFO TUN-0024] Params: {process_suggestion.parameters}\n"
                    f"Evaluation: {sample['evaluation']}\n",
                    -1,
                )
                tqdm_population.update(1)
                suggestions[sample["suggestion"]].complete(final_measurement)
        except KeyboardInterrupt as ex:
            study_client.set_state(vz.StudyState.ABORTED)
            raise ex

    study_client.set_state(vz.StudyState.COMPLETED)

    for optimal_trial in study_client.optimal_trials():
        trial = optimal_trial.materialize()
        print(
            f"[INFO TUN-0027] Found params: {trial.parameters.as_dict()}\nMetrics: {trial.final_measurement.metrics}"
        )
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
        metavar="<str>",
        default=ORFS,
        help="Path to the OpenROAD-flow-scripts repository",
    )
    parser.add_argument(
        "--results",
        type=Path,
        metavar="<str>",
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
        metavar="<int>",
        help="Max iteration count for the optimization engine",
        default=2,
    )
    parser.add_argument(
        "-s",
        "--suggestions",
        type=int,
        metavar="<int>",
        nargs="+",
        help="Suggestion count per iteration of the optimization engine",
        default=[5],
    )
    vizier_server_args = parser.add_mutually_exclusive_group()
    vizier_server_args.add_argument(
        "--vz-use-existing-server",
        type=str,
        metavar="<str>",
        help="Address of the running Vizier server",
        default=None,
    )
    start_server_args = vizier_server_args.add_argument_group("Local server")
    start_server_args.add_argument(
        "--vz-server-host",
        type=str,
        metavar="<str>",
        help="Spawn Vizier server with given host",
        default=None,
    )
    start_server_args.add_argument(
        "--vz-server-db",
        type=str,
        metavar="<str>",
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

    if args.algorithm == "GAUSSIAN_PROCESS_BANDIT" and any(
        s > 1 for s in args.suggestions
    ):
        print(
            "[ERROR TUN-0022] GAUSSIAN_PROCESS_BANDIT does not support "
            "batch operation, please set suggestions to 1",
            file=sys.stderr,
        )
        exit(1)

    args.results = args.results.absolute()
    args.mode = "vizier"
    args.suggestions += [
        args.suggestions[-1] for _ in range(args.iterations - len(args.suggestions))
    ]

    config, sdc_file, fr_file = read_config(args.config, "vizier", args.algorithm)
    args.sdc_file = sdc_file
    args.fr_file = fr_file

    local_dir, orfs_flow_dir, install_path = prepare_ray_server(args)
    args.orfs = Path(orfs_flow_dir).parent

    server_endpoint = None
    if args.vz_server_host:
        # Start Vizier server
        server_database = (
            args.vz_server_db if args.vz_server_db else service.SQL_LOCAL_URL
        )
        server = servers.DefaultVizierServer(
            host=args.vz_server_host,
            database_url=server_database,
        )
        print(f"[INFO TUN-0020] Started Vizier Server at: {server.endpoint}")
        print(f"[INFO TUN-0021] SQL database file located at: {server._database_url}")
        server_endpoint = server.endpoint
    if args.vz_use_existing_server:
        server_endpoint = args.vz_use_existing_server

    results = main(args, config, install_path, server_endpoint)
    with args.results.open("w") as fd:
        json.dump(results, fd)
    print(f"[INFO TUN-0002] Results saved to {args.results}")


if __name__ == "__main__":
    run_vizier()
