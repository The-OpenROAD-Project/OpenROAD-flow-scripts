import argparse
import os
import datetime
from ray.job_submission import JobSubmissionClient

from autotuner.utils.config_helper import parse_config

# Constants
FILE_DIR = os.path.dirname(os.path.abspath(__file__))
EXPERIMENT_DATETIME = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")

TUNE_TEMPLATE = """python3 -m autotuner.distributed \
--design {design} \
--platform {platform} \
--config {config} \
--server {server} \
--cloud_dir {cloud_dir} \
tune \
--samples {samples}"""

SWEEP_TEMPLATE = """python3 -m autotuner.distributed \
--design {design} \
--platform {platform} \
--config {config} \
--server {server} \
--cloud_dir {cloud_dir} \
sweep"""

# CLI Arguments
arguments = argparse.ArgumentParser()
arguments.add_argument(
    "--ray-dashboard-address",
    type=str,
    help="IP address of the Ray dashboard. If not provided, it will be set to the IP address of the current machine.",
    default="localhost",
)
arguments.add_argument(
    "--ray-cluster-head-address",
    type=str,
    help="IP address of the Ray cluster head. If not provided, it will be set to the IP address of the current machine.",
    default="10.138.0.21",
)

# Parse configs
# TODO: Validations + Schemas
config_args = parse_config(os.path.join(FILE_DIR, "config.yaml"))


if __name__ == "__main__":
    args = arguments.parse_args()
    ray_dashboard_address = args.ray_dashboard_address
    ray_cluster_head_address = args.ray_cluster_head_address

    # Initialize JobSubmissionClient
    client = JobSubmissionClient(address=f"http://{ray_dashboard_address}:8265")

    # Get ray parameters
    entrypoint_num_cpus = config_args.get("entrypoint_num_cpus", 1)

    # Get experiment parameters
    cloud_dir = config_args.get("cloud_dir", "gs://autotuner_test")
    design = config_args.get("design", "gcd")
    platform = config_args.get("platform", "asap7")
    config = config_args.get("config", "../../flow/designs/asap7/gcd/autotuner.json")
    mode_arg = config_args.get("mode_arg", "tune")
    samples = config_args.get("samples", 1)

    # Submit a job
    entrypoint = (
        TUNE_TEMPLATE.format(
            design=design,
            platform=platform,
            config=config,
            server=ray_cluster_head_address,
            cloud_dir=cloud_dir,
            samples=samples,
        )
        if mode_arg == "tune"
        else SWEEP_TEMPLATE.format(
            design=design,
            platform=platform,
            config=config,
            server=ray_cluster_head_address,
            cloud_dir=cloud_dir,
        )
    )
    job_id = client.submit_job(
        entrypoint=entrypoint,
        entrypoint_num_cpus=entrypoint_num_cpus,
    )
    print(f"Job submitted with ID: {job_id}")
