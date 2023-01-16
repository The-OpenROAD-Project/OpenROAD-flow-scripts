# Build from sources using Docker

## Prerequisites

For this method you only need to install
[Docker](https://docs.docker.com/engine/install) on your machine.

---

**WARNING**

The `build_openroad.sh` will use the host number of CPUs to compile `openroad`.

Please check your Docker daemon setup to make sure all host CPUs are
available.  If you are not sure, you can check with the command below. If
the output number is different from the number of CPUs from your machine,
then is recommended that you restrict the number of CPUs used by the scripts
(see instructions below).

``` shell
docker run <IMAGE> nproc
# <IMAGE> can be any commonly used OS, e.g., 'centos:centos7'
docker run centos:centos7 nproc
```

You can restrict the number of CPUs with the `-t|--threads N` argument:

``` shell
./build_openroad.sh --threads N
```

---

## Clone and Build

``` shell
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts
cd OpenROAD-flow-scripts
./build_openroad.sh
```
Options for `./build_openroad.sh` script
| Argument                      | Description                                                                           |
|-------------------------------|---------------------------------------------------------------------------------------|
| `-h` or `--help`              | Print help message.                                                                   |
| `-o` or  `--local`            | Build locally instead of building a Docker image.                                     |
| `-l` or  `--latest`           | Use the head of branch --or_branch or 'master' by default for tools/OpenROAD.         |
| `--or_branch BRANCH_NAME`     | Use the head of branch BRANCH for tools/OpenROAD.                                     |
| `--or_repo REPO_URL`          | Use a fork at REPO-URL (https/ssh) for tools/OpenROAD.                                |
| `--no_init`                   | Skip initializing submodules.                                                         |
| `-t N` or `--threads N`       | Use N cpus when compiling software.                                                   |
| `-n` or `--nice`              | Nice all jobs. Use all cpus unless `--threads` is also given, then use N threads.     |
| `--yosys-args-overwrite`      | Do not use default flags set by this scrip during Yosys compilation.                  |
| `--yosys-args STRING`         | Aditional compilation flags for Yosys compilation.                                    |
| `--openroad-args-overwrite`   | Do not use default flags set by this script during OpenROAD app compilation.          |
| `--openroad-args STRING`      | Aditional compilation flags for OpenROAD app compilation.                             |
| `--lsoracle-enable`           | Compile LSOracle. Disable by default as it is not currently used on the flow.         |
| `--lsoracle-args-overwrite`   | Do not use default flags set by this scrip during LSOracle compilation.               |
| `--lsoracle-args STRING`      | Aditional compilation flags for LSOracle compilation.                                 |
| `--install-path PATH`         | Path to install tools. Default is `${INSTALL_PATH}`.                                  |
| `--clean`                     | Call git clean interactively before compile. Useful to remove old build files.        |
| `--clean-force`               | Call git clean before compile. WARNING: this option will not ask for confirmation. Useful to remove old build files. |
| `-c` or `--copy-platforms`    | Copy platforms to inside docker image.                                                |
| `--docker-args-overwrite`     | Do not use default flags set by this script for Docker builds.                        |
| `--docker-args STRING`        | Aditional compilation flags for Docker build.                                         |


## Verify Installation

The binaries are only available from inside the Docker container, thus to
start one use:

``` shell
docker run -it -u $(id -u ${USER}):$(id -g ${USER}) -v $(pwd)/flow/platforms:/OpenROAD-flow-scripts/flow/platforms:ro openroad/flow-scripts
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
