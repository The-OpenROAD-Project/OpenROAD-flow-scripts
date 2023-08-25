# Build from sources using Docker

## Prerequisites

For this method you only need to install
[Docker](https://docs.docker.com/engine/install) on your machine.

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

Courtesy of Precision Innovations, they have released triweekly 
releases of the OpenROAD binaries in Ubuntu and Debian. This greatly
helps to reduce the compilation time needed. 

We recommend a setup whereby you install the OS using Docker,
followed by installing the prebuilt binaries for OpenROAD. 
First clone the desired Docker image, in this case we use Ubuntu 22.04.
Then, we can start the container in an interactive mode using 
`docker run -it`, telling it to start the prompt `sh`. 

```shell
docker pull ubuntu:22.04
docker run -it ubuntu:22.04 sh
```

Now you are ready to install the prebuilt binaries. 
Please refer to the instructions for installing prebuilt binaries 
[here](./BuildWithPrebuilt.md).

### Build Using Docker from sources

Alternatively, if you would like the latest commits from the OpenROAD repositories,
do follow the instructions below. 


#### Clone and Build

The following instructions build the docker image with CentOS 7 as the base OS:
You can restrict the number of CPUs with the `-t|--threads N` argument:

``` shell
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts
cd OpenROAD-flow-scripts
./build_openroad.sh --threads N 
```

## Verify Installation

The binaries are only available from inside a Docker container. Here is an example of starting a container from the created Docker image. 

``` shell
docker run --rm -it -u $(id -u ${USER}):$(id -g ${USER}) -v $(pwd)/flow:/OpenROAD-flow-scripts/flow openroad/flow-centos7-builder
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

To use the GUI feature you will need to start the docker with the
following command,

For Ubuntu/Centos/Debian OS users:

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

## Docker Shell Utility

Alternatively, use `docker_shell` to automate the above commands using the
user's parameters. Do refer to the documentation [here](./DockerShell.md).

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
