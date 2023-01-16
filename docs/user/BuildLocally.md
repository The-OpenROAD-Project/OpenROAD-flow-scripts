# Build from sources locally

## Prerequisites & Dependencies

### OpenROAD

Instructions for installing OpenROAD are available [here](https://openroad.readthedocs.io/en/latest/main/README.html#install-dependencies)

### KLayout

OpenROAD Flow requires [KLayout](https://www.klayout.de) `v0.27.1`.

### Packages

-   `libffi-devel`
-   `tcl`
-   `time`
-   `pandas` Python library
      -   Available from pip (e.g., `python3-pip`) to install pandas:
          `pip3 install --user pandas`

## Clone and Build

``` shell
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts
cd OpenROAD-flow-scripts
./build_openroad.sh --local
```

Options for `./build_openroad.sh` script
| Argument                      | Value                                                                                 |
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
| `--openroad-args-overwrite`   | Do not use default flags set by this scrip during OpenROAD app compilation.           |
| `--openroad-args STRING`      | Aditional compilation flags for OpenROAD app compilation.                             |
| `--lsoracle-enable`           | Compile LSOracle. Disable by default as it is not currently used on the flow.         |
| `--lsoracle-args-overwrite`   | Do not use default flags set by this scrip during LSOracle compilation.               |
| `--lsoracle-args STRING`      | Aditional compilation flags for LSOracle compilation.                                 |
| `--install-path PATH`         | Path to install tools. Default is `${INSTALL_PATH}`.                                  |
| `--clean`                     | Call git clean interactively before compile. Useful to remove old build files.        |
| `--clean-force`               | Call git clean before compile. WARNING: this option will not ask for confirmation.    |
|                               |  Useful to remove old build files.                                                    |

## Verify Installation

The binaries should be available on your `$PATH` after setting up the
environment.

``` shell
source ./setup_env.sh
yosys -help
openroad -help
exit
```
