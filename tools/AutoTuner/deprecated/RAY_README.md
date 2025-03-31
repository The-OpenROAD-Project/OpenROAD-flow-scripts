# AutoTuner with Ray cluster at GCP

This documentation shows how to create a Ray cluster on Google Cloud
Kubernetes Engine (i.e., GKE) and the required support infrastructure to
enable AutoTuner to work properly. The documentation is intended to users
with some familiarity with Google Cloud or other cloud services. For
more details on how to use AutoTuner see the main documentation page
[here](https://openroad-flow-scripts.readthedocs.io/en/latest/user/InstructionsForAutoTuner.html).

## How to use this document

If you want to create a new cluster, follow the document from begin to end.

If you want to run experiments on an existing cluster, make sure you have
all the [Prerequisites](#prerequisites) and then you can jump to [Running
Ray programs with Ray Client](#running-ray-programs-with-ray-client).

## Prerequisites

-   Google Cloud CLI installed, see instructions [here](https://cloud.google.com/sdk/docs/install).
-   Access to an existing Google Cloud project with "Editor" permissions to
    create the cluster. To use an existing cluster contact the person who
    created the cluster.
-   `kubectl` installed and available on your PATH. See instructions bellow.


Configure `gcloud` to use the Kubernetes credentials of the newly created
cluster. The credentials allow the use of `kubectl` locally.

```bash
gcloud components install kubectl
```

## Enable GKE

Follow the Google quickstart guide up to the section "Create a GKE cluster"
[here](https://cloud.google.com/kubernetes-engine/docs/quickstart). The
quickstart guide instructs how to enable GKE (Google's Kubernetes Engine)
start a CLI interface and get the settings for your project.

## Create a Kubernetes cluster

Create a GKE cluster using the following `gcloud` command as a guide. Note
that each argument defines a characteristic of the cluster. Furthermore,
the cluster and node pool allocate resources that cost money. Hence, be
mindful when choosing the configuration. For additional information see:

```bash
gcloud beta container clusters create --help
gcloud beta container node-pools create --help
```

```bash
gcloud beta container clusters create "autotuner" \
         --machine-type "e2-standard-8" \
         --image-type "UBUNTU_CONTAINERD" \
         --disk-type "pd-standard" \
         --disk-size "100" \
         --num-nodes "1" \
         --enable-autoscaling \
         --min-nodes "1" \
         --max-nodes "10"
```

Configure `gcloud` to use the Kubernetes credentials of the newly created
cluster. The credentials allow the use of `kubectl` locally.

```bash
gcloud container clusters get-credentials autotuner
```

Create a new node pool. This step is optional, however, recommended. The
new pool uses preemptive nodes which are not only cheaper, but also have
a more powerful CPU and have more disk space.

```bash
gcloud beta container node-pools create "worker-pool" \
         --cluster "autotuner" \
         --machine-type "c2-standard-60" \
         --image-type "UBUNTU_CONTAINERD" \
         --disk-type "pd-standard" \
         --disk-size "2000" \
         --preemptible \
         --num-nodes "3" \
         --enable-autoscaling \
         --min-nodes "1" \
         --max-nodes "625"
```

## Create NFS and setup mount options

NOTE: This tutorial requires a working NFS server.

To access the NFS mount point in the Ray cluster, we use a NFS helm
chart. You need to modify the helm chart with the information about your
server IP and mount point path.

### Install NFS Kubernetes provisioner

```bash
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner
helm repo update
```

Before installing the helm chart, double check the fields marked with
`TODO` on the file `./nfs/nfs-helm-values.yaml`. The `server` and `path`
need to match the NFS server IP and the path to the exposed folder.
The `nodeSelector` must match the non-preemptive Kubernetes pool.

```bash
helm install nfs nfs-subdir-external-provisioner/nfs-subdir-external-provisioner -f nfs/nfs-helm-values.yaml
```

### Create a PVC

Create the PVC:

```bash
kubectl create -f nfs/nfs-pvc.yaml
```

## Ray cluster

The two main files for the helm chart are:

```bash
helm-chart/templates/raycluster.yaml
helm-chart/values.yaml
```

You can restrict the node pool your AutoTuner jobs will use. To create
this policy, replace POOL_NAME with the name of the pool you created on
the previous step. For this tutorial we use `worker-pool`.

```yaml
nodeSelector:
  cloud.google.com/gke-nodepool: POOL_NAME
```

### Deploy Ray cluster inside Kubernetes

Use Helm to deploy a Ray cluster.

```bash
helm install autotuner ./helm-chart
```

### Upgrade deployment

After the initial deployment, if you change the values inside `./helm-chart`
you need to upgrade the configuration stored at the Kubernetes cluster.

```bash
helm upgrade autotuner ./helm-chart
```

### Useful ways to observe

Ray dashboard:

```bash
kubectl port-forward service/autotuner-ray-head 8265
```

Overall cluster status:

```bash
kubectl get nodes,rayclusters,pods,services,replicaset,pvc,pv
```

Ray auto-scaler logs:

```bash
kubectl logs \
  $(kubectl get pod -l cluster.ray.io/component=operator -o custom-columns=:metadata.name) \
  --tail=100 -f
```

### Remove

First, delete the `RayCluster` custom resource.

```bash
kubectl delete raycluster autotuner
```

Delete the Ray release.

```bash
helm uninstall autotuner
```

## Running Ray programs with Ray Client

Currently there are three different ways to launch a job on the GKE cluster.
All three methods depend on having `kubectl` installed and correctly setup.

To configure `gcloud` to use the Kubernetes credentials of a existing cluster.

```bash
gcloud components install kubectl
gcloud container clusters get-credentials autotuner
```

### Using port forwarding

NOTE: Ray requires that the version of Python on the server and locally
match. The current `openroad/ray` image has Python 3.7.7, make sure your
local machine has at least Python 3.7.x before continuing.

```bash
pip3 install -U --user 'ray[default,tune]==1.11.0' ax-platform hyperopt nevergrad optuna pandas
pip3 install -U --user colorama==0.4.4 bayesian-optimization==1.4.0
```

Start the port forwarding:

```bash
kubectl port-forward service/autotuner-ray-head 10001
```

Run the test script locally:

```bash
python3 kubernetes/run.py
```

### Connecting to head node

Instead of depending on your local environment, you can connect to the head
node of the Ray cluster and run the scripts from there.

```bash
kubectl exec -it $(kubectl get pod -l cluster.ray.io/component=autotuner-ray-head -o custom-columns=:metadata.name) -- bash
wget https://raw.githubusercontent.com/The-OpenROAD-Project/OpenROAD-flow-scripts/master/tools/AutoTuner/kubernetes/run.py
python run.py
```

### Using Kubernetes job submit

Finally, if you do not wish to keep a terminal session open, you can submit
a Kubernetes job.

```bash
kubectl create -f kubernetes/submit.yaml
```
