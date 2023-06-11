# Build from sources using Docker

## Prerequisites

For this method you only need to install
[Docker](https://docs.docker.com/engine/install) on your machine.

> **Warning:**
> The `build_openroad.sh` will use the host number of CPUs to compile `openroad`.
>
> Please check your Docker daemon setup to make sure all host CPUs are
> available. If you are not sure, you can check with the command below. If
> the output number is different from the number of CPUs from your machine,
> then is recommended that you restrict the number of CPUs used by the scripts
> (see instructions below).
>
> ``` shell
> docker run <IMAGE> nproc
> # <IMAGE> can be any commonly used OS, e.g., 'centos:centos7'
> docker run centos:centos7 nproc
> ```
>
> You can restrict the number of CPUs with the `-t|--threads N` argument:
>
> ``` shell
> ./build_openroad.sh --threads N
> ```

## Clone and Build

The following instructions build the docker image with CentOS 7 as the base OS:

``` shell
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts
cd OpenROAD-flow-scripts
./build_openroad.sh
```

## Verify Installation

The binaries are only available from inside the Docker container, thus to
start one use:

``` shell
docker run --rm -it -u $(id -u ${USER}):$(id -g ${USER}) -v $(pwd)/flow:/OpenROAD-flow-scripts/flow openroad/flow-$OS_NAME-builder
```

Then, inside docker:

``` shell
source ./env.sh
yosys -help
openroad -help
cd flow
make
exit
```

## Enable GUI support

To use the GUI feature you will need to start the docker with the following command:

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


### Docker shell utility
Alternatively, use `docker_shell` to automate these commands using the user's parameters.
```
cd flow
util/docker_shell make             # run flow
util/docker_shell make gui_final   # make GUI outputs
util/docker_shell bash             # interactive session
```


If you need to use a different Docker image than default, override by using the `docker_shell_IMAGE`
environment variable:

```
OR_IMAGE=openroad/flow-centos7-builder:v1234 util/docker_shell make
```

### Using `docker_shell` from outside of `OpenROAD-flow-scripts/flow` folder

If you have designs you are keeping in a git source repository that is not
a fork of the OpenROAD-flow-scripts git repository, you can still use
the `docker_shell` script.

Two ways to use `docker_shell`

1. Simply invoke it from the ORFS location.
2. Copy the script into your source folder. This would allow you
   to build and publish a Docker image to a private Docker repository
   and lock the ORFS version to the version of your source code. This
   gives you a way to deploy updates of ORFS
   easily, publish a new Docker image, modify the copy of `docker_shell`
   and create a pull request to possibly test your upgrade on your private
   build serves.

## Build Docker Image for Different OS

The following instructions build the docker image with a parameterized OS
in two stages. These are for CI and developers that wish to use an OS other
than CentOS 7; regular users should use the steps from previous sections.
The dev stage installs all dependencies and packages required to run OpenROAD
and OpenROAD Flow Scripts. The build stage generates all binaries needed to run
the flow (i.e., `openroad` and `yosys`).

``` shell
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts
cd OpenROAD-flow-scripts
./etc/DockerHelper.sh create -target=dev -os=$OS_NAME
./etc/DockerHelper.sh create -target=builder -os=$OS_NAME
```
