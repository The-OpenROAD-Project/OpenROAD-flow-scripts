# Build OpenROAD Flow

> **Warning:**
> On CentOS 7 you need to manually make sure the PATH variable includes at
> least one of the new version of GCC/Clang. To enable GCC-8 or Clang-7 you
> need to run:
>
> ```shell
> # to enable gcc-8
> source /opt/rh/devtoolset-8/enable
> # or to enable clang-7
> source /opt/rh/llvm-toolset-7.0/enable
> ```

## Build Command and options

``` shell
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
| `-c` or `--copy-platforms`    | Only applicable for docker builds. Copy platforms to inside docker image.             |
| `--docker-args-overwrite`     | Only applicable for docker builds. Do not use default flags set by this script for Docker builds.  |
| `--docker-args STRING`        | Only applicable for docker builds. Additional compilation flags for Docker build.     |


## Build from sources locally

Build from sources locally, [instructions here](./BuildLocally.md).

## Build from sources using Docker

Build from sources using Docker, [instructions here](./BuildWithDocker.md).