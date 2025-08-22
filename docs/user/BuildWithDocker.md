# Build from sources using Docker

:::{Note}
This document describes how to build your own Docker image.
If your goal is to use the latest version of OpenROAD-Flow-Scripts,
please refer to the [Docker Shell](./DockerShell.md) documentation.
:::

## Prerequisites

- For this method you only need to install
[Docker](https://docs.docker.com/engine/install) on your machine.
- Ensure that you have sufficient memory allocated to the Virtual Machine (VM)
as per our system [requirements](../index.md#system-requirements). Refer to
this [Docker guide](https://docs.docker.com/config/containers/resource_constraints/) for setting CPU cores and memory limits.

:::{Warning}
The `build_openroad.sh` will use the host number of CPUs to compile `openroad`.

Please check your Docker daemon setup to make sure all host CPUs are
available. If you are not sure, you can check with the command below. If
the output number is different from the number of CPUs from your machine,
then is recommended that you restrict the number of CPUs used by the scripts
(see instructions below).
:::

``` shell
docker run --rm ubuntu:22.04 nproc
```

### Build Using Docker from pre-built binaries

Courtesy of [Precision Innovations](https://precisioninno.com/),
they release `.deb` installers of OpenROAD for Ubuntu
and Debian on a regular basis.
This greatly helps to reduce the compilation time needed.

We recommend to use a Docker image of a supported OS
and install OpenROAD using the pre-built binaries from
Precision Innovations.
You can start the container in an interactive mode using
the command below.

```shell
docker run -it ubuntu:22.04
```

Now you are ready to install the prebuilt binaries.
Please refer to the instructions for installing prebuilt binaries
[here](./BuildWithPrebuilt.md).

### Build Using Docker from sources

Alternatively, if you would like the latest commits from the OpenROAD repositories,
do follow the instructions below.


#### Clone and Build

The following instructions build the docker image with Ubuntu 22.04 as the base OS:


``` shell
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts
cd OpenROAD-flow-scripts
./build_openroad.sh
```

You can restrict the number of CPUs with the `-t|--threads N` argument:

``` shell
./build_openroad.sh --threads N
```

## Verify Installation

The binaries are only available from inside a Docker container. Here is an example of starting a container from the created Docker image.

``` shell
docker run --rm -it -u $(id -u ${USER}):$(id -g ${USER}) -v $(pwd)/flow:/OpenROAD-flow-scripts/flow openroad/flow-ubuntu22.04-builder
```

Then, inside docker:

``` shell
source ./env.sh
yosys -help
yosys -m slang -p "slang_version"
openroad -help
cd flow
make
exit
```

Alternatively you may also use the `docker_shell` utility as follows.
It is important that you are in the `flow` directory.

```shell
cd flow
util/docker_shell make
```

## Enable GUI support

To use the GUI feature you will need to start the docker with the
following command,

For Ubuntu/Debian OS users:

```
docker run --rm -it \
           -u $(id -u ${USER}):$(id -g ${USER}) \
           -v $(pwd)/flow:/OpenROAD-flow-scripts/flow \
           -e DISPLAY=${DISPLAY} \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v ${HOME}/.Xauthority:/.Xauthority \
           --network host \
           --security-opt seccomp=unconfined \
           openroad/flow-$OS_NAME-builder
```

Running GUI with Docker on Mac OS X users, refer [here](https://cntnr.io/running-guis-with-docker-on-mac-os-x-a14df6a76efc).

Then use:

```
docker run --rm -it -e DISPLAY=<IP_LIKE_FROM_TUTORIAL>:0 --network host --privileged <IMAGE_NAME>
```

Alternatively, you may also use the `docker_shell` utility for GUI as follows.
It is important that you are in the `flow` directory.

```shell
cd flow
util/docker_shell gui_final
```

```{note}
`docker_shell` is a helpful utility to automate the
aforementioned Docker commands using the user's parameters.
Do refer to the documentation [here](./DockerShell.md).
```

## Build Docker Image for Different OS

The following instructions build the docker image with a parameterized OS
in two stages. These are for CI and developers that wish to use an OS other
than Ubuntu 22.04; regular users should use the steps from previous sections.
The dev stage installs all dependencies and packages required to run OpenROAD
and OpenROAD Flow Scripts. The build stage generates all binaries needed to run
the flow (i.e., `openroad` and `yosys`).

``` shell
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts
cd OpenROAD-flow-scripts
./etc/DockerHelper.sh create -target=dev -os=$OS_NAME
./etc/DockerHelper.sh create -target=builder -os=$OS_NAME
```
