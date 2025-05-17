from jsonargparse.typing import (
    PositiveInt,
    NonNegativeInt,
    PositiveFloat,
    Path_fr,
    restricted_string_type,
    restricted_number_type,
)
from jsonargparse import ActionConfigFile, Namespace, ArgumentParser
import numpy as np
import os
import sys
import uuid

# Collection of restricted types
IP_ADDRESS_TYPE = restricted_string_type(
    name="IP_ADDRESS_TYPE",
    regex=r"^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$",
)
IP_PORT_TYPE = restricted_number_type(
    name="IP_PORT_TYPE",
    base_type=int,    
    restrictions=[(">", 0), ("<", 65536)],
)


def process_args(args: Namespace) -> Namespace:
    """Process and validate command line arguments."""

    # --- Utility Functions ---
    def _process_common_args(args: Namespace) -> None:
        """Common argument processing."""
        # If the experiment name is the default, add a UUID to the end.
        if args.experiment == "test":
            id = str(uuid.uuid4())[:8]
            args.experiment = f"{args.mode}-{id}"
        else:
            args.experiment += f"-{args.mode}"

        # If timeout is set, convert it to seconds.
        if args.timeout is not None:
            args.timeout = round(args.timeout * 3600)

        # --- Conversion into python primitive types for Ray compatibility. ---
        # Ray ConcurrencyLimiter expects `int` type for args.jobs
        if args.jobs is not None:
            args.jobs = int(args.jobs)

        # Ray workers are unable to import custom jsonargparse types.
        if args.server is not None:
            args.server = str(args.server)
        if args.port is not None:
            args.port = int(args.port)

    def _validate_tune_args(args: Namespace) -> None:
        """Validate and process arguments specific to tuning."""
        if args.tune.eval == "ppa-improv" and args.tune.reference is None:
            print(
                '[ERROR TUN-0006] The argument "--eval ppa-improv"'
                ' requires that "--reference <FILE>" is also given.'
            )
            sys.exit(7)

        # Check for experiment name and resume flag.
        if args.tune.resume and args.experiment == "test":
            print(
                '[ERROR TUN-0031] The flag "--resume"'
                ' requires that "--experiment NAME" is also given.'
            )
            sys.exit(1)

    def _validate_sweep_args(args: Namespace) -> None:
        """Validate and process arguments specific to sweeping."""
        # Add any sweep-specific validations or post-processing here.
        pass

    # --- End of Utility Functions ---

    _process_common_args(args)
    if args.mode == "tune":
        _validate_tune_args(args)
    elif args.mode == "sweep":
        _validate_sweep_args(args)

    return args


def parse_arguments():
    parser = ArgumentParser()
    tune_parser = ArgumentParser()
    sweep_parser = ArgumentParser()

    subcommands = parser.add_subcommands(dest="mode")
    subcommands.add_subcommand("tune", parser=tune_parser)
    subcommands.add_subcommand("sweep", parser=sweep_parser)

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
        "--experiment",
        type=str,
        metavar="<str>",
        default="test",
        help="Experiment name. This parameter is used to prefix the"
        " FLOW_VARIANT and to set the Ray log destination.",
    )
    parser.add_argument(
        "--timeout",
        type=PositiveFloat,
        metavar="<float>",
        default=None,
        help="Time limit (in hours) for each trial run. Default is no limit.",
    )
    parser.add_argument(
        "--yaml",
        action=ActionConfigFile,
        help="Path to Overall YAML config file.",
    )

    # Sweep-specific
    sweep_parser.add_argument(
        "--config",
        type=Path_fr,
        metavar="<path>",
        required=True,
        help="Configuration file that sets which knobs to use for Autotuning.",
    )

    # Tune-Specific
    tune_parser.add_argument(
        "--config",
        type=Path_fr,
        metavar="<path>",
        required=True,
        help="Configuration file that sets which knobs to use for Autotuning.",
    )
    tune_parser.add_argument(
        "--resume",
        action="store_true",
        help="Resme previous run. Note that you must also set a unique experiment\
                name identifier via `--experiment NAME` to be able to resume.",
    )
    tune_parser.add_argument(
        "--algorithm",
        type=str.lower,
        choices=["hyperopt", "ax", "optuna", "pbt", "random"],
        default="hyperopt",
        help="Search algorithm to use for Autotuning.",
    )
    tune_parser.add_argument(
        "--eval",
        type=str.lower,
        choices=["default", "ppa-improv"],
        default="default",
        help="Evaluate function to use with search algorithm.",
    )
    tune_parser.add_argument(
        "--samples",
        type=PositiveInt,
        metavar="<int>",
        default=10,
        help="Number of samples for tuning.",
    )
    tune_parser.add_argument(
        "--iterations",
        type=PositiveInt,
        metavar="<int>",
        default=1,
        help="Number of iterations for tuning.",
    )
    tune_parser.add_argument(
        "--resources_per_trial",
        type=PositiveFloat,
        metavar="<float>",
        default=1,
        help="Number of CPUs to request for each tuning job.",
    )
    tune_parser.add_argument(
        "--reference",
        type=Path_fr,
        metavar="<path>",
        default=None,
        help="Reference file for use with PPAImprov.",
    )
    tune_parser.add_argument(
        "--perturbation",
        type=PositiveInt,
        metavar="<int>",
        default=25,
        help="Perturbation interval for PopulationBasedTraining.",
    )
    tune_parser.add_argument(
        "--seed",
        type=NonNegativeInt,
        metavar="<int>",
        default=42,
        help="Random seed. (0 means no seed.)",
    )

    # Workload
    parser.add_argument(
        "--jobs",
        type=PositiveInt,
        metavar="<int>",
        default=int(np.floor(os.cpu_count() / 2)),
        help="Max number of concurrent jobs.",
    )
    parser.add_argument(
        "--openroad_threads",
        type=PositiveInt,
        metavar="<int>",
        default=16,
        help="Max number of threads openroad can use.",
    )
    parser.add_argument(
        "--server",
        type=IP_ADDRESS_TYPE,
        metavar="<a.b.c.d>",
        default=None,
        help="The address of Ray server to connect.",
    )
    parser.add_argument(
        "--port",
        type=IP_PORT_TYPE,
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
    process_args(args)
    return args


if __name__ == "__main__":
    print(parse_arguments())
