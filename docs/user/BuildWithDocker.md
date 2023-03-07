# Build from sources using Docker

## Prerequisites

For this method you only need to install
[Docker](https://docs.docker.com/engine/install) on your machine.

> **Warning:**
> The `build_openroad.sh` will use the host number of CPUs to compile `openroad`.
> 
> Please check your Docker daemon setup to make sure all host CPUs are
> available.  If you are not sure, you can check with the command below. If
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

### Build Docker Image

The following instructions build the docker image with a parameterized OS in two stages. 
Dev stage for installing all the dependencies and packages that are needed to run OpenROAD and OpenROAD Flow Scripts.
The build stage actually builds all of the binaries needed to run flow (i.e., `openroad` and `yosys`).

``` shell
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts
cd OpenROAD-flow-scripts
./etc/DockerHelper.sh create -target=dev -os=$OS_NAME
./etc/DockerHelper.sh create -target=builder -os=$OS_NAME
```

### Build Docker Image with Default Values

The following instructions build the docker image with Centos 7 as the base OS:

``` shell
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts
cd OpenROAD-flow-scripts
./build_openroad.sh
```

## Verify Installation

The binaries are only available from inside the Docker container, thus to
start one use:

``` shell
docker run -it -u $(id -u ${USER}):$(id -g ${USER}) openroad/flow-$OS_NAME-builder
```

Then, inside docker:

``` shell
source ./setup_env.sh
yosys -help
openroad -help
cd flow
make
exit
```
