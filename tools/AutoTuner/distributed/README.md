# Ray Cluster Setup on Google Cloud Platform (GCP)

This tutorial covers the setup of Ray Clusters on GCP. Ray Clusters are a way to
start compute intensive jobs (e.g. Autotuner) on a distributed set of nodes spawned 
automatically. For more information on Ray Cluster, refer to [here](https://docs.ray.io/en/latest/cluster/getting-started.html).

To run Autotuner jobs on Ray Cluster, we have to first install ORFS onto the
GCP nodes.

How does this differ from the previous Kubernetes approach?
- Support for autoscaling
- Faster startup time using Docker (no need for JIT rebuilds of runtime dependencies)
- Simplified architecture and codebase

There are two different ways for ORFS setup on Ray Cluster, namely:
- [Public](#public-cluster-setup): Upload Docker image to Dockerhub (or any public Docker registry).
- [Private](#private-cluster-setup): Upload Docker image to private registry. Authentication needs then to be handled for Kubernetes. 

```note
Currently it looks like the `autoscaler.yaml` file might only be used for public.yaml
For private deployments, we might have to use KubeRay
1. https://github.com/GoogleCloudPlatform/ai-on-gke/tree/main/ray-on-gke
2. https://www.paulsblog.dev/how-to-install-a-private-docker-container-registry-in-kubernetes/
```

## Prerequisites

Make sure Autotuner prerequisites are installed. To do so, refer to the installation script.

```bash
pip install ray[default] google-api-python-client cryptography cloudpathlib
```

## Cloud-native support

Currently, this setup supports GCP with batteries included. With configuration of the necessary variables in `public.yaml`,
alternative cloud providers could be used:
- [Azure](https://docs.ray.io/en/latest/cluster/vms/user-guides/launching-clusters/azure.html)
- [AWS](https://docs.ray.io/en/latest/cluster/vms/user-guides/launching-clusters/aws.html)

## Public cluster setup

0a. Authenticate the necessary GCP account with enough privileges to do:
- `setIamPolicy`

```bash
gcloud auth application-default login
```

0b. Generate your service account keys for `ray-autoscaler-sa-v1@<project_id>.iam.gserviceaccount.com`.
Rename it `service_account.json`.

1. Set up `.env` with Docker registry username/password. Also, set up the `public.yaml`
file accordingly to your desired specifications.

```bash
cp .env.sample .env
cp public.yaml.template public.yaml
```

2. Run the following commands to build, tag and upload the public image:

```bash
make clean
make docker
make upload
```

3. Launch your cluster as follows:

```bash
make up
make dashboard
```

4. Ray CLI API

```bash
# Commands on machine (assume files/commands are present on cluster)
ray job submit --address http://localhost:8265 ls

# Case 1: 1 job
ray job submit --address http://localhost:8265 -- python3 -m autotuner.distributed --design gcd --platform asap7 --config ../../flow/designs/asap7/gcd/autotuner.json --cloud_dir gs://autotuner_test tune --samples 1
 
# Case 2A: 2 job, with resource spec.
HEAD_SERVER=10.138.0.13
ray job submit --address http://localhost:8265 --entrypoint-num-cpus 2 -- python3 -m autotuner.distributed --design gcd --platform asap7 --server $HEAD_SERVER --config ../../flow/designs/asap7/gcd/autotuner.json --cloud_dir gs://autotuner_test tune --samples 1
ray job submit --address http://localhost:8265 --entrypoint-num-cpus 2 -- python3 -m autotuner.distributed --design gcd --platform asap7 --server $HEAD_SERVER --config ../../flow/designs/asap7/gcd/autotuner.json --cloud_dir gs://autotuner_test tune --samples 1

# Case 2B: 2 job, with resource spec (sweep)
HEAD_SERVER=10.138.0.13
ray job submit --address http://localhost:8265 --entrypoint-num-cpus 2 -- python3 -m autotuner.distributed --design gcd --platform asap7 --server $HEAD_SERVER --config ./src/autotuner/distributed-sweep-example.json --cloud_dir gs://autotuner_test sweep
ray job submit --address http://localhost:8265 --entrypoint-num-cpus 2 -- python3 -m autotuner.distributed --design gcd --platform asap7 --server $HEAD_SERVER --config ./src/autotuner/distributed-sweep-example.json --cloud_dir gs://autotuner_test sweep

# Case 3: Overprovisioned resource spec (should fail because the cluster cannot meet this demand.)
HEAD_SERVER=10.138.0.13
ray job submit --address http://localhost:8265 --entrypoint-num-cpus 4 -- python3 -m autotuner.distributed --design gcd --platform asap7 --server $HEAD_SERVER --config ../../flow/designs/asap7/gcd/autotuner.json --cloud_dir gs://autotuner_test tune --samples 1

# Commands on machine (sync local working dir, note the dir is stored as some /tmp dir)
ray job submit --address http://localhost:8265 \
    --working-dir scripts -- python3 hello_world.py
```

## Useful commands

```bash
HEAD_SERVER=10.138.0.13
ray job stop --address $HEAD_SERVER:6379 --no-wait {{ JOB_SUBMIT_ID }}
```

## Roadmap

- Public flow, fixed: via autotuner script
    - Tune
    - Sweep
- Public flow, fixed: via ray API.
- Public flow, autoscaling
- test using private registry on dockerhub same flow
- Scaling concerns
    - increase storage of head node.
    - Object store memory - does that affect file transfer?
- Private cluster setup
